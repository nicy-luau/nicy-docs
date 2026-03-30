# Host API Reference (`nicyrtdyn`)

## Exported host entrypoints

### `void nicy_start(const char* filepath)`

Boot runtime and execute script file.

### `void nicy_eval(const char* code)`

Execute inline source code.

### `void nicy_compile(const char* filepath)`

Compile source to bytecode output.

### `const char* nicy_version(void)`

Return runtime version string.

### `const char* nicy_luau_version(void)`

Return embedded Luau version string.

## Host loading examples

::: code-group

```c [Windows]
<<< ../examples/host/c/windows_loader.c
```

```c [Linux/macOS]
<<< ../examples/host/c/posix_loader.c
```

:::

## Operational requirements

1. resolve all required symbols before first call
2. abort startup on missing symbol
3. keep host/runtime release versions aligned
