# Architecture Explanation

## Layer split

- CLI layer (`nicy`): command processing + runtime discovery
- Runtime layer (`nicyrtdyn`): Luau execution + APIs + resolver + scheduler
- Native extension layer: optional ABI-level modules

## Why split host/runtime

1. independent release and testing of runtime engine
2. host embeddability in multiple environments
3. clearer boundaries for ABI compatibility management

## Data/control flow

1. user invokes CLI
2. CLI resolves runtime library
3. runtime initializes Luau state
4. runtime executes entry script
5. script consumes runtime/task/native APIs
