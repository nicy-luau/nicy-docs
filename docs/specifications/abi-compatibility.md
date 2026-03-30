# ABI and Compatibility Specification

## Compatibility boundaries

- Host API symbols (`nicy_start`, `nicy_eval`, `nicy_compile`, version functions)
- Bare-metal C-ABI exports (`nicy_lua_*` and `nicy_luaL_*`)

## Requirements

- Host and runtime should use matching release lines
- Native modules must match runtime ABI and architecture
- Calling convention and symbol names must be exact

## Versioning recommendation

- Treat ABI-breaking changes as major release events
- Publish migration notes when signatures/semantics change
