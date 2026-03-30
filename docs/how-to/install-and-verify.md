# Install and Verify

## Windows (automatic download + execute)

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "$url='https://nicy-luau.github.io/nicy-docs/scripts/install-nicy.ps1'; $dst=Join-Path $env:TEMP 'install-nicy.ps1'; Invoke-WebRequest -Uri $url -OutFile $dst; & $dst"
```

## Linux / macOS / Android (Termux)

```bash
curl -fsSL https://nicy-luau.github.io/nicy-docs/scripts/install-nicy.sh | bash
```

## Verify installation

```bash
nicy runtime-version
```

## PowerShell policy fixes

One-time bypass:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install-nicy.ps1
```

Persistent (current user):

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
```

Inspect policy chain:

```powershell
Get-ExecutionPolicy -List
```

## PATH refresh (current shell)

```powershell
$env:Path = [Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [Environment]::GetEnvironmentVariable("Path","User")
```

## Installer scripts

::: code-group

```powershell [install-nicy.ps1]
<<< ../scripts/install-nicy.ps1
```

```bash [install-nicy.sh]
<<< ../scripts/install-nicy.sh
```

:::
