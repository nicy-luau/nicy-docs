# Require & Cache Reference

## Resolver pipeline

1. request normalization
2. alias application (`.luaurc`)
3. path resolution
4. circular graph detection
5. cache lookup
6. fingerprint-based invalidation

## Cache contract

- same canonical module path returns cached export table
- file change invalidates cache entry

## Example

<<< @/examples/luau/require/cache_hit_check.luau

## Edge behavior

- cyclic require chains produce explicit errors
- JIT remains file-scoped and independent per module


