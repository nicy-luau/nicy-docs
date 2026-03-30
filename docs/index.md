# Nicy Documentation

Nicy is a Luau toolchain with two layers:

- `nicy`: command-line host.
- `nicyrtdyn`: runtime engine loaded by the host.

This docs set is structured to avoid repetition and keep responsibilities clear.

## Read in this order

1. [Install](/install)
2. [Runtime Guide](/runtime)
3. [Task Guide](/task)
4. [Require & Cache Guide](/require-cache)
5. [nicyrtdyn Guide](/nicyrtdyn)
6. [FFI / Bare Metal Guide](/ffi-bare-metal)
7. [Troubleshooting](/troubleshooting)

## Audience split

- Luau developer: runtime/task/require usage.
- Native/runtime developer: embedding and bare-metal ABI.

## Design goals of this documentation

- explain runtime behavior, not only list functions
- provide production-oriented examples
- keep examples reusable as standalone files
- centralize troubleshooting for faster diagnosis
