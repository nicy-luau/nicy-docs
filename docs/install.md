# Installation

This page covers installation, environment setup, and policy-related issues on Windows.

## Automatic install commands

::: code-group

```powershell [Windows PowerShell]
# Downloads installer script and executes it in a single command.
powershell -NoProfile -ExecutionPolicy Bypass -Command "$url='https://nicy-luau.github.io/nicy-docs/scripts/install-nicy.ps1'; $dst=Join-Path $env:TEMP 'install-nicy.ps1'; Invoke-WebRequest -Uri $url -OutFile $dst; & $dst"
```

```bash [Linux/macOS]
# Streams official installer script.
curl -fsSL https://nicy-luau.github.io/nicy-docs/scripts/install-nicy.sh | bash
```

```bash [Android Termux]
# Same installer flow for Termux.
curl -fsSL https://nicy-luau.github.io/nicy-docs/scripts/install-nicy.sh | bash
```

:::

## What the installer configures

- downloads matching `nicy` + `nicyrtdyn` release assets
- installs binaries in user-local directory
- updates user PATH
- runs `nicy runtime-version` smoke test

## Verify installation

::: code-group

```powershell [Windows]
nicy runtime-version
```

```bash [Linux/macOS/Termux]
nicy runtime-version
```

:::

## PowerShell policy and script blocking

If script execution is blocked, use one of the options below.

::: code-group

```powershell [One-time bypass]
powershell -NoProfile -ExecutionPolicy Bypass -File .\install-nicy.ps1
```

```powershell [Persistent user policy]
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
```

```powershell [Inspect policy chain]
Get-ExecutionPolicy -List
```

:::

## PATH not updated in current terminal

::: code-group

```powershell [Windows]
$env:Path = [Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [Environment]::GetEnvironmentVariable("Path","User")
```

```bash [Linux/macOS/Termux]
source ~/.profile 2>/dev/null || true
source ~/.bashrc 2>/dev/null || true
source ~/.zshrc 2>/dev/null || true
```

:::

## Useful next steps

- [Runtime Guide](/runtime)
- [Troubleshooting](/troubleshooting)
