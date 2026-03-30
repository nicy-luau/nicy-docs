# Nicy Documentation

Nicy is a Luau execution stack built around two components:

- `nicy`: the CLI host executable.
- `nicyrtdyn`: the runtime engine loaded dynamically by the host.

This documentation is intentionally split into practical developer tracks.

## Track A: App developer (Luau)

1. [Install](/install)
2. [Runtime Guide](/runtime)
3. [Task Guide](/task)
4. [Require & Cache Guide](/require-cache)

## Track B: Native/runtime developer

1. [nicyrtdyn Guide](/nicyrtdyn)
2. [FFI / Bare Metal Guide](/ffi-bare-metal)
3. [Troubleshooting](/troubleshooting)

## Runtime model at a glance

1. `nicy run script.luau`
2. `nicy` resolves and loads `nicyrtdyn`
3. runtime initializes Luau state
4. global APIs (`runtime`, `task`) are injected
5. script and required modules are executed

## Core goals of this docs set

- teach real usage, not only list functions
- show complete native module flow in multiple languages
- provide explicit diagnostics for common failures
- keep ABI and runtime behavior clear and testable
