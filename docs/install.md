# Instalação

Use o script adequado para seu sistema.

## Windows

```powershell
powershell -ExecutionPolicy Bypass -Command "iwr https://nicy-luau.github.io/nicy-docs/scripts/install-nicy.ps1 -OutFile $env:TEMP\install-nicy.ps1; & $env:TEMP\install-nicy.ps1"
```

## Linux / macOS / Android (Termux)

```bash
curl -fsSL https://nicy-luau.github.io/nicy-docs/scripts/install-nicy.sh | bash
```

## Scripts

::: code-group

```powershell [install-nicy.ps1]
<<< ./scripts/install-nicy.ps1
```

```bash [install-nicy.sh]
<<< ./scripts/install-nicy.sh
```

:::

