# Nicy Documentation

Nicy is a Luau execution stack composed of two parts:

- `nicy`: CLI host executable
- `nicyrtdyn`: dynamic runtime engine loaded by the host

This documentation is organized using the Diataxis model:

- Tutorials: guided learning by doing
- How-to guides: task-oriented procedures
- Reference: exact API/ABI contracts
- Explanation: architecture and design decisions

## Start here

1. [Install and verify](/how-to/install-and-verify)
2. [Create your first project](/tutorials/first-project)
3. [Read runtime API reference](/reference/runtime-api)

## Developer tracks

- Application developer: focus on CLI, runtime globals, `task`, and `require`
- Runtime/plugin developer: focus on host API, FFI, ABI contracts, and error handling

## Repositories

- [nicy](https://github.com/nicy-luau/nicy)
- [nicyrtdyn](https://github.com/nicy-luau/nicyrtdyn)
