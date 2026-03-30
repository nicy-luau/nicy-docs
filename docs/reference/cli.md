# CLI Reference

## Commands

### `nicy run <file>`

Runs a Luau script through `nicyrtdyn`.

### `nicy eval <code>`

Evaluates inline Luau code.

### `nicy compile <file>`

Compiles source to Luau bytecode (`.luauc`).

### `nicy runtime-version`

Reports runtime version details.

## Runtime resolution order

1. Local directory of `nicy` executable
2. Process/system PATH

## Exit behavior

- Exit code `0`: command succeeded
- Non-zero: initialization, load, compile, or runtime failure

## See also

- [Runtime API](/reference/runtime-api)
- [Host API](/reference/host-api)
