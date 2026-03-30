# Runtime Guide

This page focuses on **runtime behavior**, JIT boundaries, and native loading from Luau.

## Runtime object

- `runtime.version`
- `runtime.entry_file`
- `runtime.entry_dir`
- `runtime.hasJIT(path?)`
- `runtime.loadlib(path)`

## JIT model (file-scoped)

`--!native` applies to one file at a time.

::: code-group

<<< @/examples/luau/runtime/basic_jit_check.luau [Basic runtime and JIT inspection]

<<< @/examples/luau/runtime/module_jit_pattern.luau [Entry uses module with separate JIT boundary]

<<< @/examples/luau/runtime/fastmath.luau [Native-enabled module file]

:::

## Native loading from Luau

::: code-group

<<< @/examples/luau/native/native_load_windows.luau [Windows DLL]

<<< @/examples/luau/native/native_load_linux.luau [Linux SO]

<<< @/examples/luau/native/native_load_macos.luau [macOS DYLIB]

:::

## Runtime usage rules

1. Treat JIT as explicit per file.
2. Keep native path resolution deterministic.
3. Validate architecture compatibility in CI.
4. Log runtime version on startup.


