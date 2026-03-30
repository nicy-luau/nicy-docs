# Load Native Libraries (How-to)

Goal: load platform-specific native library from Luau script.

## Steps

1. place binary in deterministic project path
2. call `runtime.loadlib(...)`
3. call exported function and validate output

## Example

::: code-group

<<< @/examples/luau/native/native_load_windows.luau [Windows]

<<< @/examples/luau/native/native_load_linux.luau [Linux]

<<< @/examples/luau/native/native_load_macos.luau [macOS]

:::


