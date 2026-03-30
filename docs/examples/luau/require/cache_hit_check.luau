-- cache_hit_check.luau
-- Demonstrates require cache behavior for same module path.

local a = require("./config.luau")
local b = require("./config.luau")
print("Same table instance:", a == b)
