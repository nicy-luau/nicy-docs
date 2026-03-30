-- basic_jit_check.luau
-- Shows how to inspect JIT state for current file and target module.

print("Runtime:", runtime.version)
print("Entry file:", runtime.entry_file)
print("Entry dir:", runtime.entry_dir)

-- Current file JIT status.
print("Current file JIT:", runtime.hasJIT())

-- Module JIT status.
print("fastmath module JIT:", runtime.hasJIT("./fastmath.luau"))
