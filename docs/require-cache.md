# Require & Cache Guide

This page explains resolver behavior and module architecture choices.

## Resolver responsibilities

1. normalize request path
2. apply aliases (`.luaurc`)
3. resolve canonical module path
4. detect circular dependencies
5. use/invalidate cache via file fingerprint

## Cache behavior demo

```luau
<<< @/examples/luau/require/cache_hit_check.luau
```

## Architecture recommendations

1. Keep module top-level side effects minimal.
2. Prefer explicit init functions for heavy work.
3. Avoid hidden dependency cycles.
4. Keep alias maps simple and stable.

## JIT interaction

JIT mode is still file-scoped and independent per module.

