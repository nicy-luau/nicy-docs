# Error Catalog

## CLI / Runtime startup

### `failed to load symbol 'nicy_start'`

Cause:

- wrong runtime artifact, stale PATH, or architecture mismatch.

Actions:

1. reinstall runtime + cli pair
2. verify symbol exports
3. verify architecture match

### `failed to load symbol 'nicy_version'`

Cause:

- incompatible runtime library version.

Actions:

1. clear stale runtime binary from PATH precedence
2. reinstall matching release pair

## PowerShell policy

### `running scripts is disabled on this system`

Actions:

- one-time bypass (`-ExecutionPolicy Bypass`)
- persistent user policy (`RemoteSigned`)

## Native module loading

### library load failure

Cause:

- wrong extension
- missing dependencies
- architecture mismatch

Actions:

1. verify file name and path
2. inspect dependency chain
3. inspect exports

## Runtime execution

### unexpected Luau runtime error

Actions:

1. run minimal reproducer script
2. log runtime version and entry path
3. isolate failing module require chain
