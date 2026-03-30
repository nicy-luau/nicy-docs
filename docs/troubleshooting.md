# Troubleshooting

This page consolidates high-frequency issues and exact recovery steps.

## `nicy` command not found

Fix PATH refresh:

```powershell
$env:Path = [Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [Environment]::GetEnvironmentVariable("Path","User")
```

or restart terminal.

## `failed to load symbol 'nicy_start'`

Likely cause:

- runtime binary incompatible with current CLI release

Fix:

1. reinstall with official installer
2. verify artifact architecture
3. verify runtime binary location

## PowerShell script policy blocked

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
```

or run one-time bypass command.

## Native module load failure

Checks:

1. file path and extension
2. architecture alignment
3. exported symbol names
4. transitive dependencies

## Deep references

- [Runtime Guide](/runtime)
- [nicyrtdyn Guide](/nicyrtdyn)
- [FFI / Bare Metal Guide](/ffi-bare-metal)
- [Error Catalog](/reference/error-catalog)
