# FFI / Bare Metal Guide

This guide teaches how to create a native module for Nicy in multiple languages.

## Goal

Expose a single function `nativeAdd(a, b)` callable from Luau.

## Shared ABI assumptions

- module exports an init entry (`nicy_module_init`) recognized by your module loading flow
- function reads args from Luau stack
- function pushes exactly one return value

## C implementation

```c
// native_add.c
// Example native module: nativeAdd(a, b) -> integer

typedef struct lua_State LuauState;
typedef long long lua_Integer;
typedef int (*lua_CFunction)(LuauState*);

extern lua_Integer nicy_luaL_checkinteger(LuauState *l, int narg);
extern void nicy_lua_pushinteger(LuauState *l, lua_Integer n);
extern void nicy_lua_pushcfunction(LuauState *l, lua_CFunction f);
extern void nicy_lua_setglobal(LuauState *l, const char *k);

static int native_add(LuauState* l) {
    // Read and validate both integer args.
    lua_Integer a = nicy_luaL_checkinteger(l, 1);
    lua_Integer b = nicy_luaL_checkinteger(l, 2);

    // Push one result.
    nicy_lua_pushinteger(l, a + b);
    return 1;
}

__declspec(dllexport) void nicy_module_init(LuauState* l) {
    // Register function in global environment.
    nicy_lua_pushcfunction(l, native_add);
    nicy_lua_setglobal(l, "nativeAdd");
}
```

## C++ implementation

```cpp
// native_add.cpp
// Same behavior as C, with C ABI boundary.

extern "C" {
    typedef struct lua_State LuauState;
    typedef long long lua_Integer;
    typedef int (*lua_CFunction)(LuauState*);

    lua_Integer nicy_luaL_checkinteger(LuauState *l, int narg);
    void nicy_lua_pushinteger(LuauState *l, lua_Integer n);
    void nicy_lua_pushcfunction(LuauState *l, lua_CFunction f);
    void nicy_lua_setglobal(LuauState *l, const char *k);
}

static int native_add(LuauState* l) {
    auto a = nicy_luaL_checkinteger(l, 1);
    auto b = nicy_luaL_checkinteger(l, 2);
    nicy_lua_pushinteger(l, a + b);
    return 1;
}

extern "C" __declspec(dllexport) void nicy_module_init(LuauState* l) {
    nicy_lua_pushcfunction(l, native_add);
    nicy_lua_setglobal(l, "nativeAdd");
}
```

## Rust implementation

```rust
// src/lib.rs
use core::ffi::c_char;
use std::ffi::CString;

#[repr(C)]
pub struct LuauState {
    _private: [u8; 0],
}

pub type LuaInteger = i64;
pub type LuaCFunction = unsafe extern "C" fn(*mut LuauState) -> i32;

unsafe extern "C" {
    fn nicy_luaL_checkinteger(l: *mut LuauState, narg: i32) -> LuaInteger;
    fn nicy_lua_pushinteger(l: *mut LuauState, n: LuaInteger);
    fn nicy_lua_pushcfunction(l: *mut LuauState, f: LuaCFunction);
    fn nicy_lua_setglobal(l: *mut LuauState, k: *const c_char);
}

unsafe extern "C" fn native_add(l: *mut LuauState) -> i32 {
    // Validate and read integer arguments.
    let a = nicy_luaL_checkinteger(l, 1);
    let b = nicy_luaL_checkinteger(l, 2);

    // Push one return value.
    nicy_lua_pushinteger(l, a + b);
    1
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn nicy_module_init(l: *mut LuauState) {
    let name = CString::new("nativeAdd").unwrap();
    nicy_lua_pushcfunction(l, native_add);
    nicy_lua_setglobal(l, name.as_ptr());
}
```

`Cargo.toml`:

```toml
[lib]
crate-type = ["cdylib"]
```

## Build commands

::: code-group

```powershell [C / C++ (MSVC)]
cl /LD native_add.c /Fenative_add.dll
cl /LD native_add.cpp /EHsc /Fenative_add.dll
```

```bash [Rust]
cargo build --release
```

```bash [Inspect exports]
# Windows
# dumpbin /exports native_add.dll

# Linux
# nm -D libnative_add.so

# macOS
# nm -gU libnative_add.dylib
```

:::

## Luau usage

::: code-group

```luau [Windows]
runtime.loadlib("@self/native/native_add.dll")
print(nativeAdd(10, 32))
```

```luau [Linux]
runtime.loadlib("@self/native/libnative_add.so")
print(nativeAdd(10, 32))
```

```luau [macOS]
runtime.loadlib("@self/native/libnative_add.dylib")
print(nativeAdd(10, 32))
```

:::

## Troubleshooting native modules

### Symptom: symbol missing

- check `extern "C"` for C++/Rust boundaries
- confirm exported symbol names with dump tool

### Symptom: crash on call

- verify stack contract (return count matches pushed values)
- validate all arguments with `nicy_luaL_check*`

### Symptom: module not loadable

- wrong architecture (x64/x86/arm64 mismatch)
- wrong extension for platform
- missing dependent dynamic libs

## Full ABI list

Complete low-level export catalog is available in:

- [FFI ABI Reference Appendix](/reference/ffi-bare-metal)
