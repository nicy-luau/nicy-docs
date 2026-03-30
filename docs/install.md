# Installation Guide

This page explains **what gets installed**, how installation works on each platform, and how to recover from the most common failures.

## What the installer does

The Nicy installer performs these steps:

1. Detects your OS and architecture.
2. Fetches the latest stable releases for `nicy` and `nicyrtdyn`.
3. Downloads matching assets for your platform.
4. Extracts binaries into your local install directory.
5. Adds the install directory to your user PATH.
6. Runs a runtime smoke test (`nicy runtime-version`).

## Default install locations

- Windows: `%LOCALAPPDATA%\Nicy\bin`
- Linux/macOS: `$HOME/.local/Nicy/bin`
- Termux: `$PREFIX/opt/nicy/bin`

## One-command installation

### Windows (PowerShell, automatic download)

```powershell
# Downloads installer script to TEMP and executes it with policy bypass for this process only.
powershell -NoProfile -ExecutionPolicy Bypass -Command "$url='https://nicy-luau.github.io/nicy-docs/scripts/install-nicy.ps1'; $dst=Join-Path $env:TEMP 'install-nicy.ps1'; Invoke-WebRequest -Uri $url -OutFile $dst; & $dst"
```

### Linux / macOS / Android (Termux)

```bash
# Streams installer script directly to bash.
curl -fsSL https://nicy-luau.github.io/nicy-docs/scripts/install-nicy.sh | bash
```

## Verify installation

```bash
nicy runtime-version
```

Expected: engine/runtime version information.

## PowerShell execution policy troubleshooting

### Error pattern

- `running scripts is disabled on this system`

### Safe one-time method

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install-nicy.ps1
```

### Persistent user-level policy

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
```

### Inspect active policy chain

```powershell
Get-ExecutionPolicy -List
```

## PATH troubleshooting

### Symptom

- `nicy` is not recognized

### Fix for current terminal

```powershell
$env:Path = [Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [Environment]::GetEnvironmentVariable("Path","User")
```

Then test:

```powershell
nicy runtime-version
```

## Runtime binary troubleshooting

### Symptom

- `failed to load symbol 'nicy_start'`
- `failed to load symbol 'nicy_version'`

### Root cause

Usually a mismatch between CLI and runtime artifacts or wrong architecture.

### Fix checklist

1. Reinstall using official installer.
2. Ensure both binaries are from compatible release line.
3. Verify runtime binary exists beside `nicy` or in PATH.
4. Confirm architecture (`x64`, `x86`, `arm64`) matches your system.

## Installer scripts source

::: code-group

```powershell [install-nicy.ps1]
<<< ./scripts/install-nicy.ps1
```

```bash [install-nicy.sh]
<<< ./scripts/install-nicy.sh
```

:::
