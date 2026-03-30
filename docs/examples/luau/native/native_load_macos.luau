-- native_load_macos.luau
-- Loads macOS shared library and calls nativeAdd.

runtime.loadlib("@self/native/libnative_add.dylib")
print("nativeAdd(10, 32) =", nativeAdd(10, 32))
