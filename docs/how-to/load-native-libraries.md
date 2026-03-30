# Load Native Libraries (How-to)

Goal: load platform-specific native library from Luau script.

## Steps

1. place binary in deterministic project path
2. call `runtime.loadlib(...)`
3. call exported function and validate output

## Example

::: code-group

```luau [Windows]
<<< ../examples/luau/native/native_load_windows.luau
```

```luau [Linux]
<<< ../examples/luau/native/native_load_linux.luau
```

```luau [macOS]
<<< ../examples/luau/native/native_load_macos.luau
```

:::
