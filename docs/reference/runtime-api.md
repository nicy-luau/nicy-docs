# Runtime API Reference

## Global object: `runtime`

### `runtime.version: string`

Runtime version string.

### `runtime.hasJIT(path?: string): boolean`

Returns JIT/CodeGen activation state.

Arguments:

- `path` optional module path

Behavior:

- No path: evaluates current file
- Path provided: evaluates referenced module

### `runtime.entry_file: string`

Absolute path of entry script.

### `runtime.entry_dir: string`

Absolute directory of entry script.

### `runtime.loadlib(path: string)`

Loads a native dynamic library.

Supported path features:

- relative paths
- `@self` alias

Error modes:

- file not found
- incompatible binary format
- required symbol missing

## Example

```luau
print(runtime.version)
print(runtime.hasJIT())
local lib = runtime.loadlib("@self/native/test_extension.dll")
```
