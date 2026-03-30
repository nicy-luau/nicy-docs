-- native_load_windows.luau
-- Loads Windows dynamic library and calls nativeAdd.

runtime.loadlib("@self/native/native_add.dll")
print("nativeAdd(10, 32) =", nativeAdd(10, 32))
