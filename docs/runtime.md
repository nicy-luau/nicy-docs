# Runtime Deep Dive

This page explains how the runtime behaves at execution time and how to use it safely in real projects.

## Runtime object

The `runtime` global is injected by `nicyrtdyn`.

### `runtime.version`

```luau
print(runtime.version)
```

Use this for diagnostics and support reports.

### `runtime.entry_file`

Absolute path of the entry script.

### `runtime.entry_dir`

Absolute directory of the entry script.

### `runtime.hasJIT(path?: string)`

Reports whether CodeGen/JIT is enabled for a file.

```luau
print(runtime.hasJIT())
print(runtime.hasJIT("./module.luau"))
```

## JIT model (important)

JIT is **file-scoped** in Nicy.

- A file enables JIT by starting with `--!native`.
- Entry file JIT does not force JIT for every module.
- A required module can enable JIT independently.

Example:

`main.luau`

```luau
local fast = require("./fastmath.luau")
print("main jit?", runtime.hasJIT())
print("module jit?", runtime.hasJIT("./fastmath.luau"))
print(fast.mul(6, 7))
```

`fastmath.luau`

```luau
--!native
local M = {}

function M.mul(a, b)
    return a * b
end

return M
```

## Native dynamic loading: `runtime.loadlib(path)`

Loads a native shared library from disk.

```luau
local lib = runtime.loadlib("@self/native/test_extension.dll")
print(lib ~= nil)
```

### Path features

- Relative path support
- `@self` alias to current script directory

### Typical failure causes

- wrong extension for platform
- missing transitive dependencies
- incompatible binary architecture
- expected symbols not exported

## Production recommendations

1. Log `runtime.version` at startup.
2. Explicitly validate module JIT state in tests.
3. Keep native binary loading paths deterministic.
4. Fail fast with clear error messages when `loadlib` fails.
