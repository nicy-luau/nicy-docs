# Require and Cache

`nicyrtdyn` provides a custom `require()` implementation for Luau modules.

## Features

- module cache reuse
- file fingerprinting for cache invalidation
- `.luaurc` alias support
- circular dependency detection

## Expected behavior

- If a module file changes, cached state is invalidated.
- Requiring the same module again reuses in-memory exports.
- Alias resolution keeps imports stable in larger projects.

## Simple example

```luau
local utilA = require("./util.luau")
local utilB = require("./util.luau")
print(utilA == utilB)
```

## `--!native` behavior per module

CodeGen is file-scoped:

- a module with `--!native` can run with JIT even if the entry file does not
- an entry file with `--!native` does not force JIT on modules without it

Check status at runtime:

```luau
print(runtime.hasJIT("./module.luau"))
```
