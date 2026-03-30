# Fix Common Runtime Errors

## `nicy` is not recognized

Cause:

- PATH not refreshed in current terminal

Fix:

```powershell
$env:Path = [Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [Environment]::GetEnvironmentVariable("Path","User")
```

## `failed to load symbol 'nicy_start'`

Cause:

- Wrong runtime binary or incompatible artifact
- Missing expected export in dynamic library

Fix:

1. Download matching release pair for `nicy` and `nicyrtdyn`
2. Ensure runtime library is next to `nicy.exe` or in PATH
3. Verify export symbols with platform tooling (`dumpbin`, `nm`, `objdump`)

## PowerShell policy blocked script execution

Fix:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
```

## Library loads but fails at runtime

Checklist:

- Correct architecture (`x64`, `x86`, `arm64`)
- Correct platform binary format
- Correct file extension and path
- Required symbols exported by native module

## Reference

- [Error Catalog](/reference/error-catalog)
- [Host API](/reference/host-api)
- [FFI / Bare Metal ABI](/reference/ffi-bare-metal)
