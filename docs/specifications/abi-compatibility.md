# ABI and Compatibility Specification

## Compatibility boundaries

- host API symbols (`nicy_*` entrypoints)
- low-level ABI symbols (`nicy_lua_*`, `nicy_luaL_*`)

## Mandatory constraints

1. matching architecture across host/runtime/module
2. stable symbol names and calling conventions
3. aligned release line between host and runtime

## Release discipline

- ABI-breaking changes require version signaling and migration notes
