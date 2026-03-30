# Enable JIT in Modules

Nicy JIT/CodeGen is file-scoped, controlled by `--!native` at the top of each file.

## Enable JIT in one module

`fastmath.luau`:

```luau
--!native
local M = {}

function M.mul(a, b)
    return a * b
end

return M
```

Use from entry script:

```luau
local fastmath = require("./fastmath.luau")
print(runtime.hasJIT("./fastmath.luau"))
```

## Key behavior

- JIT on entry file does not force JIT on all required modules
- A module with `--!native` can use JIT even when entry file does not

## Validate

```luau
print(runtime.hasJIT())
print(runtime.hasJIT("./some-module.luau"))
```
