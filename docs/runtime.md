# Runtime Guide

This guide explains how scripts interact with the runtime and how to structure production code.

## Runtime global overview

- `runtime.version`
- `runtime.entry_file`
- `runtime.entry_dir`
- `runtime.hasJIT(path?)`
- `runtime.loadlib(path)`

## JIT behavior (`--!native`)

JIT is controlled per file.

- a file with `--!native` enables native codegen for itself
- JIT does not globally propagate to all required modules

::: code-group

```luau [Basic JIT check]
print("entry JIT:", runtime.hasJIT())
print("module JIT:", runtime.hasJIT("./fastmath.luau"))
```

```luau [Module-level JIT]
-- main.luau
local fast = require("./fastmath.luau")
print(fast.mul(9, 9))

-- fastmath.luau
--!native
local M = {}
function M.mul(a, b)
    return a * b
end
return M
```

:::

## Native loading with `runtime.loadlib`

Use deterministic paths and keep binaries under project-controlled directories.

::: code-group

```luau [Windows DLL]
local native = runtime.loadlib("@self/native/native_add.dll")
print(native ~= nil)
```

```luau [Linux SO]
local native = runtime.loadlib("@self/native/libnative_add.so")
print(native ~= nil)
```

```luau [macOS DYLIB]
local native = runtime.loadlib("@self/native/libnative_add.dylib")
print(native ~= nil)
```

:::

## Recommended project layout

```text
project/
  main.luau
  modules/
    util.luau
    fastmath.luau
  native/
    native_add.dll | libnative_add.so | libnative_add.dylib
```

## Production checks

1. Log `runtime.version` at startup.
2. Assert expected JIT states in tests.
3. Fail fast when `loadlib` cannot resolve.
4. Keep runtime and native binaries on the same release line.
