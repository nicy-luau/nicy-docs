-- native_load_linux.luau
-- Loads Linux shared object and calls nativeAdd.

runtime.loadlib("@self/native/libnative_add.so")
print("nativeAdd(10, 32) =", nativeAdd(10, 32))
