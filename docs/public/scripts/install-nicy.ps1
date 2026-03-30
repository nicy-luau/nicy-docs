param(
    [string]$InstallRoot = "$env:LOCALAPPDATA\Nicy\bin",
    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
if (Get-Variable -Name PSNativeCommandUseErrorActionPreference -ErrorAction SilentlyContinue) {
    $PSNativeCommandUseErrorActionPreference = $false
}

$NicyRepo = "nicy-luau/nicy"
$RuntimeRepo = "nicy-luau/nicyrtdyn"

function New-GitHubHeaders {
    return @{ "User-Agent" = "nicy-installer" }
}

function Get-HttpStatusCodeFromError {
    param([System.Exception]$Exception)

    if ($null -ne $Exception.Response -and $null -ne $Exception.Response.StatusCode) {
        return [int]$Exception.Response.StatusCode
    }
    return -1
}

function Invoke-GitHubApi {
    param([string]$Uri)

    try {
        return Invoke-RestMethod -Uri $Uri -Headers (New-GitHubHeaders)
    } catch {
        throw
    }
}

function Get-OsTarget {
    $arch = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture
    switch ($arch.ToString()) {
        "X64" { return "win-x64" }
        "X86" { return "win-x86" }
        "Arm64" { return "win-arm" }
        default { throw "Unsupported architecture: $arch" }
    }
}

function Get-LatestRelease {
    param([string]$Repo)

    $latestUrl = "https://api.github.com/repos/$Repo/releases/latest"

    try {
        return Invoke-GitHubApi -Uri $latestUrl
    } catch {
        $status = Get-HttpStatusCodeFromError -Exception $_.Exception
        if ($status -ne 404) {
            throw
        }
    }

    $listUrl = "https://api.github.com/repos/$Repo/releases?per_page=20"
    try {
        $releases = Invoke-GitHubApi -Uri $listUrl
    } catch {
        $status = Get-HttpStatusCodeFromError -Exception $_.Exception
        if ($status -eq 404) {
            throw "Could not access releases for '$Repo' (404). Check the repository name."
        }
        throw
    }
    if ($null -eq $releases -or $releases.Count -eq 0) {
        throw "No release found in '$Repo'. Publish a GitHub release before installing."
    }

    $stable = $releases | Where-Object { -not $_.draft -and -not $_.prerelease } | Select-Object -First 1
    if ($null -ne $stable) {
        return $stable
    }

    $nonDraft = $releases | Where-Object { -not $_.draft } | Select-Object -First 1
    if ($null -ne $nonDraft) {
        Write-Host "Warning: using prerelease '$($nonDraft.tag_name)' from $Repo" -ForegroundColor Yellow
        return $nonDraft
    }

    throw "No usable public release exists in '$Repo'."
}

function Select-AssetUrl {
    param(
        [object]$Release,
        [string[]]$Candidates
    )

    foreach ($name in $Candidates) {
        $asset = $Release.assets | Where-Object { $_.name -eq $name } | Select-Object -First 1
        if ($null -ne $asset) {
            return $asset.browser_download_url
        }
    }

    $names = ($Release.assets | Select-Object -ExpandProperty name) -join ", "
    throw "No asset found. Expected: $($Candidates -join ', '). Available: $names"
}

function Find-Asset {
    param(
        [object]$Release,
        [string[]]$Candidates
    )

    foreach ($name in $Candidates) {
        $asset = $Release.assets | Where-Object { $_.name -eq $name } | Select-Object -First 1
        if ($null -ne $asset) {
            return $asset
        }
    }
    return $null
}

function Expand-Zip {
    param(
        [string]$ZipPath,
        [string]$Destination
    )

    if (Test-Path -LiteralPath $Destination) {
        Remove-Item -LiteralPath $Destination -Recurse -Force
    }
    New-Item -ItemType Directory -Force -Path $Destination | Out-Null
    Expand-Archive -LiteralPath $ZipPath -DestinationPath $Destination -Force
}

function Add-UserPathIfMissing {
    param([string]$PathToAdd)

    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $parts = @()
    if (-not [string]::IsNullOrWhiteSpace($userPath)) {
        $parts = $userPath.Split(';') | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
    }

    $exists = $parts | Where-Object { $_.TrimEnd('\\') -ieq $PathToAdd.TrimEnd('\\') } | Select-Object -First 1
    if (-not $exists) {
        $newPath = if ($parts.Count -eq 0) { $PathToAdd } else { ($parts + $PathToAdd) -join ';' }
        $persisted = $false

        try {
            $envKey = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey("Environment", $true)
            if ($null -eq $envKey) {
                throw "Could not open HKCU\\Environment for writing."
            }
            $envKey.SetValue("Path", $newPath, [Microsoft.Win32.RegistryValueKind]::ExpandString)
            $envKey.Close()

            [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
            $verify = [Environment]::GetEnvironmentVariable("Path", "User")
            if (($verify -split ';' | Where-Object { $_.TrimEnd('\\') -ieq $PathToAdd.TrimEnd('\\') }).Count -gt 0) {
                $persisted = $true
            }
        } catch {
            $persisted = $false
        }

        if (-not $persisted) {
            Write-Host "Warning: could not persist user PATH automatically." -ForegroundColor Yellow
            Write-Host "Run manually later:" -ForegroundColor Yellow
            Write-Host "[Environment]::SetEnvironmentVariable('Path', ([Environment]::GetEnvironmentVariable('Path','User') + ';$PathToAdd'), 'User')" -ForegroundColor Yellow
        }
    }

    $machinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $newUserPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $env:Path = if ([string]::IsNullOrWhiteSpace($machinePath)) { $newUserPath } else { "$machinePath;$newUserPath" }

    try {
        if (-not ("NicyEnvBroadcast" -as [type])) {
            Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public static class NicyEnvBroadcast {
    [DllImport("user32.dll", SetLastError=true, CharSet=CharSet.Unicode)]
    public static extern IntPtr SendMessageTimeout(
        IntPtr hWnd, uint Msg, IntPtr wParam, string lParam,
        uint fuFlags, uint uTimeout, out IntPtr lpdwResult);
}
"@
        }

        $HWND_BROADCAST = [IntPtr]0xFFFF
        $WM_SETTINGCHANGE = 0x001A
        $SMTO_ABORTIFHUNG = 0x0002
        $out = [IntPtr]::Zero
        [void][NicyEnvBroadcast]::SendMessageTimeout(
            $HWND_BROADCAST,
            [uint32]$WM_SETTINGCHANGE,
            [IntPtr]::Zero,
            "Environment",
            [uint32]$SMTO_ABORTIFHUNG,
            [uint32]5000,
            [ref]$out
        )
    } catch {
    }
}

$target = Get-OsTarget
$tmpRoot = Join-Path $env:TEMP ("nicy-install-" + [Guid]::NewGuid().ToString("N"))
$downloadDir = Join-Path $tmpRoot "downloads"
$extractDir = Join-Path $tmpRoot "extract"

New-Item -ItemType Directory -Force -Path $downloadDir | Out-Null
New-Item -ItemType Directory -Force -Path $extractDir | Out-Null
New-Item -ItemType Directory -Force -Path $InstallRoot | Out-Null

try {
    $nicyRelease = Get-LatestRelease -Repo $NicyRepo
    $runtimeRelease = Get-LatestRelease -Repo $RuntimeRepo

    $nicyCandidates = @(
        "nicy-$target.zip",
        "nicy-win-msvc-$($target.Substring(4)).zip"
    )
    $runtimeCandidates = @(
        "nicyrtdyn-$target.zip",
        "nicyrtdyn-win-msvc-$($target.Substring(4)).zip"
    )

    $nicyAssets = New-Object System.Collections.Generic.List[object]
    foreach ($candidate in $nicyCandidates) {
        $asset = Find-Asset -Release $nicyRelease -Candidates @($candidate)
        if ($null -eq $asset) { continue }

        $zipPath = Join-Path $downloadDir ("nicy-" + $candidate)
        $extractPath = Join-Path $extractDir ("nicy-" + $candidate)
        Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $zipPath
        Expand-Zip -ZipPath $zipPath -Destination $extractPath
        $exe = Get-ChildItem -Path $extractPath -Recurse -File -Filter "nicy.exe" | Select-Object -First 1
        if ($null -ne $exe) {
            $nicyAssets.Add([PSCustomObject]@{
                Name = $candidate
                ExePath = $exe.FullName
            }) | Out-Null
        }
    }

    $runtimeAssets = New-Object System.Collections.Generic.List[object]
    foreach ($candidate in $runtimeCandidates) {
        $asset = Find-Asset -Release $runtimeRelease -Candidates @($candidate)
        if ($null -eq $asset) { continue }

        $zipPath = Join-Path $downloadDir ("runtime-" + $candidate)
        $extractPath = Join-Path $extractDir ("runtime-" + $candidate)
        Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $zipPath
        Expand-Zip -ZipPath $zipPath -Destination $extractPath
        $dll = Get-ChildItem -Path $extractPath -Recurse -File -Filter "nicyrtdyn.dll" | Select-Object -First 1
        if ($null -ne $dll) {
            $runtimeAssets.Add([PSCustomObject]@{
                Name = $candidate
                DllPath = $dll.FullName
            }) | Out-Null
        }
    }

    if ($nicyAssets.Count -eq 0) {
        $nicyUrl = Select-AssetUrl -Release $nicyRelease -Candidates $nicyCandidates
        throw "Could not prepare nicy.exe from: $nicyUrl"
    }
    if ($runtimeAssets.Count -eq 0) {
        $runtimeUrl = Select-AssetUrl -Release $runtimeRelease -Candidates $runtimeCandidates
        throw "Could not prepare nicyrtdyn.dll from: $runtimeUrl"
    }

    $selected = $null
    foreach ($n in $nicyAssets) {
        foreach ($r in $runtimeAssets) {
            Copy-Item -LiteralPath $n.ExePath -Destination (Join-Path $InstallRoot "nicy.exe") -Force
            Copy-Item -LiteralPath $r.DllPath -Destination (Join-Path $InstallRoot "nicyrtdyn.dll") -Force

            $testExit = 1
            try {
                & (Join-Path $InstallRoot "nicy.exe") runtime-version *> $null
                $testExit = $LASTEXITCODE
            } catch {
                $testExit = 1
            }

            if ($testExit -eq 0) {
                $selected = [PSCustomObject]@{
                    NicyAsset = $n.Name
                    RuntimeAsset = $r.Name
                }
                break
            }
        }
        if ($null -ne $selected) { break }
    }

    if ($null -eq $selected) {
        $nList = ($nicyAssets | ForEach-Object { $_.Name }) -join ", "
        $rList = ($runtimeAssets | ForEach-Object { $_.Name }) -join ", "
        throw "No asset combination worked. Nicy: [$nList] Runtime: [$rList]"
    }

    Add-UserPathIfMissing -PathToAdd $InstallRoot

    Write-Host "Installation completed"
    Write-Host "Nicy: $(Join-Path $InstallRoot 'nicy.exe')"
    Write-Host "Runtime: $(Join-Path $InstallRoot 'nicyrtdyn.dll')"
    Write-Host "Target: $target"
    Write-Host "Nicy release: $($nicyRelease.tag_name)"
    Write-Host "Runtime release: $($runtimeRelease.tag_name)"
    Write-Host "Nicy asset: $($selected.NicyAsset)"
    Write-Host "Runtime asset: $($selected.RuntimeAsset)"
    Write-Host "User PATH updated with: $InstallRoot"
    Write-Host "To use it in the current terminal, run:"
    Write-Host '$env:Path = [Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [Environment]::GetEnvironmentVariable("Path","User")'
}
finally {
    if (Test-Path -LiteralPath $tmpRoot) {
        Remove-Item -LiteralPath $tmpRoot -Recurse -Force
    }
}

