# Installation

Install once, verify immediately, then move to runtime usage.

## Quick install (one-line)

::: code-group

```powershell [Windows PowerShell]
irm https://nicy-luau.github.io/nicy-docs/scripts/install-nicy.ps1 | iex
```

```bash [Linux/macOS]
curl -fsSL https://nicy-luau.github.io/nicy-docs/scripts/install-nicy.sh | bash
```

```bash [Android Termux]
curl -fsSL https://nicy-luau.github.io/nicy-docs/scripts/install-nicy.sh | bash
```

:::

## Alternative install commands

::: code-group

```powershell [Windows PowerShell - Download first]
$url='https://nicy-luau.github.io/nicy-docs/scripts/install-nicy.ps1'
$dst=Join-Path $env:TEMP 'install-nicy.ps1'
Invoke-WebRequest -Uri $url -OutFile $dst
& $dst
```

```bash [Linux/macOS - Download first]
curl -fsSL https://nicy-luau.github.io/nicy-docs/scripts/install-nicy.sh -o /tmp/install-nicy.sh
bash /tmp/install-nicy.sh
```

:::

## Verify install

```bash
nicy runtime-version
```

## PowerShell execution policy handling

::: code-group

```powershell [One-time bypass]
powershell -NoProfile -ExecutionPolicy Bypass -File .\install-nicy.ps1
```

```powershell [Persistent user-level policy]
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
```

```powershell [Inspect all active scopes]
Get-ExecutionPolicy -List
```

:::

## PATH refresh

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

## Official installer scripts

::: code-group

<<< @/scripts/install-nicy.ps1 [install-nicy.ps1]

<<< @/scripts/install-nicy.sh [install-nicy.sh]

:::


