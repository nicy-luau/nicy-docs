# Enable JIT in Modules (How-to)

Goal: enable native codegen for selected modules only.

## Steps

1. add `--!native` to target module first line
2. require module normally
3. validate with `runtime.hasJIT(path)`

## Example

::: code-group

<<< @/examples/luau/runtime/module_jit_pattern.luau [Entry]

<<< @/examples/luau/runtime/fastmath.luau [Native module]

<<< @/examples/luau/runtime/basic_jit_check.luau [Validation]

:::


