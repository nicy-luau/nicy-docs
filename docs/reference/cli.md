# CLI Reference

## Commands

### `nicy run <entry.luau>`

Executes a Luau entry script via `nicyrtdyn`.

Inputs:

- path to entry script

Output behavior:

- process exit code `0` on success
- non-zero on load/compile/runtime failure

### `nicy eval "<code>"`

Executes inline Luau code.

### `nicy compile <entry.luau>`

Compiles source into `.luauc` bytecode artifact.

### `nicy runtime-version`

Prints runtime and Luau engine version metadata.

## Resolution behavior

Runtime library search order:

1. Same directory as `nicy` executable
2. PATH directories

## Examples

::: code-group

```bash [Run]
nicy run main.luau
```

```bash [Eval]
nicy eval "print(runtime.version)"
```

```bash [Compile]
nicy compile main.luau
```

```bash [Runtime info]
nicy runtime-version
```

:::

## Failure modes

- runtime library not found
- required symbol missing
- architecture mismatch
- Luau runtime error
