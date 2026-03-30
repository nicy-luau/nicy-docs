# Require and Cache Deep Dive

Nicy runtime ships a custom `require()` pipeline designed for project-scale module trees.

## Resolver responsibilities

1. Resolve request path (relative/aliases).
2. Normalize to canonical module location.
3. Detect circular dependency edges.
4. Reuse cache entry when valid.
5. Invalidate cache when module fingerprint changes.

## Why this matters

Without fingerprint-based invalidation, changed modules can remain stale in long-running processes.

## Cache behavior

```luau
local a = require("./config.luau")
local b = require("./config.luau")
print(a == b) -- true when cache is valid
```

## Circular dependency detection

If module A requires B and B requires A during initialization, resolver emits an explicit dependency cycle error.

## Alias support

When `.luaurc` defines aliases, resolver applies mapping before filesystem resolution.

## JIT and module boundaries

JIT mode does not propagate globally through `require`.

- Module with `--!native` can run with JIT.
- Module without `--!native` stays non-native.

Check state at runtime:

```luau
print(runtime.hasJIT("./some-module.luau"))
```

## Design tips for large projects

1. Keep module side effects minimal.
2. Use explicit initialization functions instead of heavy top-level execution.
3. Avoid hidden dependency cycles.
4. Use deterministic alias naming.
