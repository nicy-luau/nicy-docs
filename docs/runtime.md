# Runtime

The global `runtime` object exposes host/runtime integration points.

## `runtime.version`

Returns the loaded runtime version.

```luau
print(runtime.version)
```

## `runtime.hasJIT(path?: string): boolean`

Returns whether CodeGen/JIT is active for a file.

- no argument: checks the current file
- with argument: checks the specified module path

```luau
print(runtime.hasJIT())
print(runtime.hasJIT("./module.luau"))
```

To enable JIT for a file, place `--!native` on the first line of that specific file.

## `runtime.entry_file`

Absolute path of the entry script.

## `runtime.entry_dir`

Directory of the entry script.

## `runtime.loadlib(path: string)`

Loads a native dynamic library.

- accepts relative paths
- supports `@self` alias for current script directory

```luau
local ext = runtime.loadlib("@self/native/test_extension.dll")
```

## Next topics

- [Task Scheduler](/task)
- [Require and Cache](/require-cache)
- [FFI / Bare Metal](/ffi-bare-metal)
