# CLI Guide

`nicy` is the user-facing executable that routes commands to the runtime engine.

## Command overview

::: code-group

```bash [Run file]
nicy run main.luau
```

```bash [Eval inline]
nicy eval "print(runtime.version)"
```

```bash [Compile bytecode]
nicy compile main.luau
```

```bash [Runtime info]
nicy runtime-version
```

:::

## Command behavior

- `run`: executes a Luau entry script
- `eval`: executes code string directly
- `compile`: generates `.luauc` output
- `runtime-version`: verifies runtime engine wiring

## Runtime resolution order

1. executable directory
2. PATH directories

## Best practices

1. Always verify runtime with `nicy runtime-version` in CI.
2. Pin CLI/runtime artifacts to same release line.
3. Keep script entrypoints explicit in build scripts.
