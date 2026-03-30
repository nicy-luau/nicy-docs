# Module Resolution Specification

## Resolution inputs

- Requested module path
- Current module location
- Alias mappings (`.luaurc`)

## Resolution process

1. Normalize request path
2. Apply alias mapping if present
3. Resolve to filesystem location
4. Validate module existence
5. Consult module cache
6. Load/execute module if cache miss

## Cache invalidation

- Cache key includes file fingerprint
- File changes invalidate prior module snapshot

## Circular dependencies

Resolver tracks in-progress modules and reports circular dependency chains.
