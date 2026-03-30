# Require & Cache Guide

Nicy runtime uses a custom module resolver designed for real projects.

## Resolver responsibilities

1. Normalize requested path.
2. Apply `.luaurc` aliases.
3. Resolve module location.
4. Detect circular dependency chain.
5. Reuse valid cache entry.
6. Invalidate cache when file fingerprint changes.

## Cache behavior

::: code-group

```luau [Cache hit]
local a = require("./config.luau")
local b = require("./config.luau")
print(a == b) -- true
```

```luau [JIT boundary check]
local m = require("./native_module.luau")
print("module jit:", runtime.hasJIT("./native_module.luau"))
```

:::

## Circular dependencies

If A requires B and B requires A during initialization, resolver reports cycle information instead of silently misbehaving.

## Design rules for maintainable modules

1. Keep top-level side effects minimal.
2. Prefer explicit init functions for heavy setup.
3. Keep aliases simple and deterministic.
4. Treat cache invalidation as normal behavior during development.
