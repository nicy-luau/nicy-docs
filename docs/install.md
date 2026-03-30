# Installation

Use the official installer script for your platform.

## Windows (PowerShell, automatic download)

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "$url='https://nicy-luau.github.io/nicy-docs/scripts/install-nicy.ps1'; $dst=Join-Path $env:TEMP 'install-nicy.ps1'; Invoke-WebRequest -Uri $url -OutFile $dst; & $dst"
```

## Linux / macOS / Android (Termux)

```bash
curl -fsSL https://nicy-luau.github.io/nicy-docs/scripts/install-nicy.sh | bash
```

## PowerShell policy troubleshooting

If your environment blocks script execution, use one of the following approaches.

### One-time bypass (recommended for install)

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "$url='https://nicy-luau.github.io/nicy-docs/scripts/install-nicy.ps1'; $dst=Join-Path $env:TEMP 'install-nicy.ps1'; Invoke-WebRequest -Uri $url -OutFile $dst; & $dst"
```

### Enable local user script execution (persistent)

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
```

### Verify active policies

```powershell
Get-ExecutionPolicy -List
```

## Common post-install fixes

### `nicy` is not recognized

Refresh PATH for the current terminal:

```powershell
$env:Path = [Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [Environment]::GetEnvironmentVariable("Path","User")
```

Then test:

```powershell
nicy runtime-version
```

### Runtime DLL is not loaded

Confirm both files exist in the install directory:

```powershell
$bin = "$env:LOCALAPPDATA\Nicy\bin"
Test-Path "$bin\nicy.exe"
Test-Path "$bin\nicyrtdyn.dll"
```

## Installer scripts

::: code-group

```powershell [install-nicy.ps1]
<<< ./scripts/install-nicy.ps1
```

```bash [install-nicy.sh]
<<< ./scripts/install-nicy.sh
```

:::
