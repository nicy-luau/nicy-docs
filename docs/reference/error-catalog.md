# Error Catalog

## `failed to load symbol 'nicy_start'`

Cause:

- Runtime library does not export expected symbol

Actions:

- Validate release artifact pair
- Inspect exports in runtime binary

## `failed to load symbol 'nicy_version'`

Cause:

- Incompatible runtime artifact

Actions:

- Replace runtime with matching release
- Ensure binary architecture is correct

## PowerShell execution policy error

Cause:

- Script policy restricts local or downloaded scripts

Actions:

- Use one-time bypass
- Set `CurrentUser` to `RemoteSigned`

## `nicy` command not found

Cause:

- PATH not persisted or not reloaded

Actions:

- Refresh current shell PATH
- Open a new terminal session

## Native module load failure

Cause:

- Wrong filename/extension/path
- Missing dependent libraries
- ABI mismatch

Actions:

- Verify full resolved path
- Check binary architecture
- Check required exports
