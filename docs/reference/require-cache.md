# Require and Cache Reference

## Resolver capabilities

- fingerprint-based cache invalidation
- circular dependency detection
- alias support from `.luaurc`

## Cache behavior

- Same module path maps to cached module exports
- File change invalidates previous cache state

## JIT boundary interaction

`--!native` is applied at file level, not globally.

## Example

```luau
local m1 = require("./module.luau")
local m2 = require("./module.luau")
print(m1 == m2)
```
