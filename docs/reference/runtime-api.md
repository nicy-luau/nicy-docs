# Runtime API Reference

## Global: `runtime`

### `runtime.version: string`

Runtime version string from loaded `nicyrtdyn`.

### `runtime.entry_file: string`

Absolute entry script path.

### `runtime.entry_dir: string`

Absolute directory of entry script.

### `runtime.hasJIT(path?: string): boolean`

Returns JIT state for current file or target module path.

Contract:

- no argument: current executing file
- string argument: resolved target file

### `runtime.loadlib(path: string): any`

Loads a native dynamic library.

Path handling:

- relative paths supported
- `@self` alias supported

## Examples

::: code-group

```luau [Inspect runtime + JIT]
<<< ../examples/luau/runtime/basic_jit_check.luau
```

```luau [Load native library]
<<< ../examples/luau/native/native_load_windows.luau
```

:::

## Failure modes

- unresolved library path
- wrong binary format for platform
- missing symbols expected by module contract
