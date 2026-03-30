# FFI / Bare Metal ABI Reference

This page teaches how to build native modules against Nicy runtime in multiple languages, with practical minimal examples and diagnostics.

## Integration modes

There are two native integration strategies:

1. **Host API mode**: host process calls `nicy_start` / `nicy_eval` / `nicy_compile`.
2. **Bare-metal ABI mode**: native module manipulates Luau state via `nicy_lua_*` exports.

Use bare-metal mode when you need direct stack/table/function control.

## ABI safety checklist

1. Keep stack balanced for every C function return.
2. Validate arguments using `nicy_luaL_check*`.
3. Use `nicy_lua_pcall` where runtime errors are possible.
4. Keep calling convention and symbol names stable.
5. Pin module builds to runtime release line.

## Language examples: one simple function (`native_add`)

All examples expose `nativeAdd(a, b)` to Luau and return one integer.

### C example

```c
// native_add.c
// Exposes nativeAdd(a, b) to Luau.

typedef struct lua_State LuauState;
typedef long long lua_Integer;
typedef int (*lua_CFunction)(LuauState*);

extern lua_Integer nicy_luaL_checkinteger(LuauState *l, int narg);
extern void nicy_lua_pushinteger(LuauState *l, lua_Integer n);
extern void nicy_lua_pushcfunction(LuauState *l, lua_CFunction f);
extern void nicy_lua_setglobal(LuauState *l, const char *k);

static int native_add(LuauState* l) {
    // Validate args from Luau stack positions 1 and 2.
    lua_Integer a = nicy_luaL_checkinteger(l, 1);
    lua_Integer b = nicy_luaL_checkinteger(l, 2);

    // Push one return value.
    nicy_lua_pushinteger(l, a + b);
    return 1;
}

__declspec(dllexport) void nicy_module_init(LuauState* l) {
    // Register global function name visible in Luau.
    nicy_lua_pushcfunction(l, native_add);
    nicy_lua_setglobal(l, "nativeAdd");
}
```

Build (MSVC):

```powershell
cl /LD native_add.c /Fenative_add.dll
```

### C++ example

```cpp
// native_add.cpp
// Same behavior as C version, but compiled as C++.

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

Build (MSVC):

```powershell
cl /LD native_add.cpp /EHsc /Fenative_add.dll
```

### Rust example

```rust
// src/lib.rs
// cdylib exposing nicy_module_init and nativeAdd.

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
    // Validate args and push one result.
    let a = nicy_luaL_checkinteger(l, 1);
    let b = nicy_luaL_checkinteger(l, 2);
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

Build:

```bash
cargo build --release
```

Output:

- Windows: `target/release/<name>.dll`
- Linux: `target/release/lib<name>.so`
- macOS: `target/release/lib<name>.dylib`

## Luau usage example

```luau
local mod = runtime.loadlib("@self/native/native_add.dll")
print(nativeAdd(7, 5)) -- 12
```

Use `.so`/`.dylib` on non-Windows platforms.

## Troubleshooting native modules

### Symbol not found

- Ensure export is unmangled (`extern "C"` in C++/Rust FFI boundary).
- Confirm symbol names with dump tool:
  - Windows: `dumpbin /exports native_add.dll`
  - Linux: `nm -D libnative_add.so`
  - macOS: `nm -gU libnative_add.dylib`

### Library loads but call crashes

- Verify stack contract: number of pushed return values matches C function return.
- Validate all argument positions and types.
- Avoid invalid pointers crossing FFI boundary.

### Wrong architecture

- Ensure module architecture matches runtime architecture.
- Match x64/x86/arm64 consistently.

## Full export index

```c
void nicy_lua_createtable(LuauState *l, int narr, int nrec);
void nicy_lua_setfield(LuauState *l, int idx, const char *k);
void nicy_lua_getfield(LuauState *l, int idx, const char *k);
void nicy_lua_gettable(LuauState *l, int idx);
void nicy_lua_settable(LuauState *l, int idx);
void nicy_lua_rawget(LuauState *l, int idx);
void nicy_lua_rawset(LuauState *l, int idx);
void nicy_lua_rawgeti(LuauState *l, int idx, lua_Integer n);
void nicy_lua_rawseti(LuauState *l, int idx, lua_Integer n);
void nicy_lua_settop(LuauState *l, int idx);
int nicy_lua_gettop(LuauState *l);
void nicy_lua_pushvalue(LuauState *l, int idx);
void nicy_lua_remove(LuauState *l, int idx);
void nicy_lua_insert(LuauState *l, int idx);
int nicy_lua_absindex(LuauState *l, int idx);
int nicy_lua_checkstack(LuauState *l, int extra);
void nicy_lua_pushnil(LuauState *l);
void nicy_lua_pushboolean(LuauState *l, int b);
void nicy_lua_pushnumber(LuauState *l, lua_Number n);
void nicy_lua_pushinteger(LuauState *l, lua_Integer n);
void nicy_lua_pushstring(LuauState *l, const char *s);
void nicy_lua_pushlstring(LuauState *l, const char *s, size_t len);
void nicy_lua_pushcfunction(LuauState *l, lua_CFunction f);
void nicy_lua_pushcclosure(LuauState *l, lua_CFunction f, int n);
void nicy_lua_pushlightuserdata(LuauState *l, void *p);
int nicy_lua_type(LuauState *l, int idx);
const char *nicy_lua_typename(LuauState *l, int tp);
int nicy_lua_isnil(LuauState *l, int idx);
int nicy_lua_isnumber(LuauState *l, int idx);
int nicy_lua_isstring(LuauState *l, int idx);
int nicy_lua_istable(LuauState *l, int idx);
int nicy_lua_isfunction(LuauState *l, int idx);
int nicy_lua_isuserdata(LuauState *l, int idx);
int nicy_lua_isthread(LuauState *l, int idx);
int nicy_lua_isboolean(LuauState *l, int idx);
int nicy_lua_iscfunction(LuauState *l, int idx);
int nicy_lua_isinteger(LuauState *l, int idx);
int nicy_lua_toboolean(LuauState *l, int idx);
const char *nicy_lua_tostring(LuauState *l, int idx);
const char *nicy_lua_tolstring(LuauState *l, int idx, size_t *len);
lua_Integer nicy_lua_tointeger(LuauState *l, int idx);
void *nicy_lua_touserdata(LuauState *l, int idx);
const char *nicy_luaL_checkstring(LuauState *l, int narg);
const char *nicy_luaL_checklstring(LuauState *l, int narg, size_t *len);
lua_Integer nicy_luaL_checkinteger(LuauState *l, int narg);
void nicy_lua_getglobal(LuauState *l, const char *k);
void nicy_lua_setglobal(LuauState *l, const char *k);
int nicy_lua_getmetatable(LuauState *l, int idx);
int nicy_lua_setmetatable(LuauState *l, int idx);
void nicy_lua_call(LuauState *l, int nargs, int nresults);
int nicy_lua_pcall(LuauState *l, int nargs, int nresults, int errfunc);
LuauState *nicy_lua_newthread(LuauState *l);
int nicy_lua_resume(LuauState *l, LuauState *from, int nargs, int *nres);
int nicy_lua_yield(LuauState *l, int nresults);
void *nicy_lua_newuserdata(LuauState *l, size_t sz);
void nicy_lua_concat(LuauState *l, int n);
int nicy_lua_next(LuauState *l, int idx);
int nicy_lua_rawequal(LuauState *l, int idx1, int idx2);
int nicy_lua_gc(LuauState *l, int what, int data);
int nicy_lua_error(LuauState *l);
int nicy_luaL_error(LuauState *l, const char *msg);
int nicy_luaL_ref(LuauState *l, int t);
void nicy_luaL_unref(LuauState *l, int t, int r);
```
