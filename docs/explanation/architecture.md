# Architecture

Nicy is split into host and runtime to keep deployment and integration flexible.

## Layers

- CLI host (`nicy`): command routing and runtime loading
- Runtime engine (`nicyrtdyn`): execution, APIs, scheduler, resolver
- Native extension layer: optional bare-metal plugins via C-ABI

## Execution pipeline

1. Resolve entry script path
2. Load runtime shared library
3. Resolve required host symbols
4. Initialize Luau state and global APIs
5. Execute entry script

## Why this design

- Runtime can evolve independently from CLI host
- Host can be swapped or embedded in other languages
- Native extension support remains optional and explicit
