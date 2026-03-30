# Fix Common Errors (How-to)

Goal: diagnose startup and native integration failures quickly.

## Symptom-to-action map

1. `nicy` not found -> refresh PATH and reopen terminal.
2. missing runtime symbols -> replace runtime artifact with matching release.
3. script blocked by policy -> use bypass or `RemoteSigned`.
4. native module fails to load -> verify extension/architecture/dependencies.

## Commands

::: code-group

```powershell [Refresh PATH]
$env:Path = [Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [Environment]::GetEnvironmentVariable("Path","User")
```

```powershell [Set policy]
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
```

```bash [Verify runtime]
nicy runtime-version
```

:::
