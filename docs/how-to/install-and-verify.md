# Install and Verify (How-to)

Goal: install Nicy and confirm runtime wiring in less than 2 minutes.

## Steps

1. run installer command for your platform
2. refresh shell PATH
3. execute `nicy runtime-version`

## Commands

::: code-group

```powershell [Windows]
powershell -NoProfile -ExecutionPolicy Bypass -Command "$url='https://nicy-luau.github.io/nicy-docs/scripts/install-nicy.ps1'; $dst=Join-Path $env:TEMP 'install-nicy.ps1'; Invoke-WebRequest -Uri $url -OutFile $dst; & $dst"
```

```bash [Linux/macOS/Termux]
curl -fsSL https://nicy-luau.github.io/nicy-docs/scripts/install-nicy.sh | bash
```

:::

## Verify

```bash
nicy runtime-version
```
