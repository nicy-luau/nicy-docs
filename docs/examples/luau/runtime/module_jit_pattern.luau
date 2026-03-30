-- module_jit_pattern.luau
-- Entry file that consumes a module with its own --!native boundary.

local fast = require("./fastmath.luau")
print("Result:", fast.mul(9, 9))
