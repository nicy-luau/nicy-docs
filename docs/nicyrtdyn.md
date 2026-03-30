# nicyrtdyn Guide

This guide explains the runtime engine and host embedding flow.

## What nicyrtdyn owns

- Luau state initialization
- runtime global object injection
- task scheduler registration
- require/cache resolver lifecycle
- C-ABI export surface for native integrations

## Host API entrypoints

- `nicy_start`
- `nicy_eval`
- `nicy_compile`
- `nicy_version`
- `nicy_luau_version`

## Embedding examples

::: code-group

```c [Windows host loader]
<<< ./examples/host/c/windows_loader.c
```

```c [Linux/macOS host loader]
<<< ./examples/host/c/posix_loader.c
```

:::

## Embedding checklist

1. Resolve mandatory symbols at startup.
2. Abort startup if any required symbol is missing.
3. Keep runtime and host from same release line.
4. Add smoke test (`nicy runtime-version`) in release pipeline.

## Next step

Go to [FFI / Bare Metal Guide](/ffi-bare-metal) for native module authoring.
