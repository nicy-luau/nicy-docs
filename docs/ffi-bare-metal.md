# FFI / Bare Metal

This page targets low-level native integration directly against `nicyrtdyn` C-ABI exports.

## Scope

Use this layer when you need:

- native modules with strict performance constraints
- direct stack/table manipulation in Luau state
- precise control over call boundaries and memory layout

If you only need script execution, start with [nicyrtdyn (Host API)](/nicyrtdyn).

## C-ABI groups (selected)

### Stack

- `nicy_lua_gettop`
- `nicy_lua_settop`
- `nicy_lua_pushvalue`
- `nicy_lua_remove`

### Push values

- `nicy_lua_pushnil`
- `nicy_lua_pushboolean`
- `nicy_lua_pushinteger`
- `nicy_lua_pushnumber`
- `nicy_lua_pushstring`
- `nicy_lua_pushcfunction`

### Read/check values

- `nicy_lua_type`
- `nicy_lua_isnumber`
- `nicy_lua_isstring`
- `nicy_lua_tointeger`
- `nicy_lua_toboolean`
- `nicy_lua_tostring`
- `nicy_luaL_checkstring`
- `nicy_luaL_checkinteger`

### Table/global operations

- `nicy_lua_getfield`
- `nicy_lua_setfield`
- `nicy_lua_rawget`
- `nicy_lua_rawset`
- `nicy_lua_getglobal`
- `nicy_lua_setglobal`

### Calls/coroutines/errors

- `nicy_lua_call`
- `nicy_lua_pcall`
- `nicy_lua_newthread`
- `nicy_lua_resume`
- `nicy_lua_yield`
- `nicy_lua_error`
- `nicy_luaL_error`

## Advanced example 1: register a native function and preserve stack balance

```c
#include <stddef.h>

typedef struct lua_State LuauState;
typedef long long lua_Integer;
typedef int (*lua_CFunction)(LuauState*);

extern const char* nicy_luaL_checkstring(LuauState *l, int narg);
extern lua_Integer nicy_luaL_checkinteger(LuauState *l, int narg);
extern void nicy_lua_pushinteger(LuauState *l, lua_Integer n);
extern int nicy_lua_gettop(LuauState *l);
extern void nicy_lua_settop(LuauState *l, int idx);
extern void nicy_lua_pushcfunction(LuauState *l, lua_CFunction f);
extern void nicy_lua_setglobal(LuauState *l, const char *k);

static int native_repeat_len(LuauState* l) {
    int base = nicy_lua_gettop(l);
    const char* s = nicy_luaL_checkstring(l, 1);
    lua_Integer n = nicy_luaL_checkinteger(l, 2);

    size_t len = 0;
    while (s[len] != '\0') len++;

    nicy_lua_pushinteger(l, (lua_Integer)(len * (size_t)n));

    if (nicy_lua_gettop(l) != base + 1) {
        nicy_lua_settop(l, base);
        return 0;
    }
    return 1;
}

void register_native_api(LuauState* l) {
    nicy_lua_pushcfunction(l, native_repeat_len);
    nicy_lua_setglobal(l, "nativeRepeatLen");
}
```

## Advanced example 2: protected call wrapper (`pcall`) from host-side helper

```c
typedef struct lua_State LuauState;

extern void nicy_lua_getglobal(LuauState *l, const char *k);
extern void nicy_lua_pushstring(LuauState *l, const char *s);
extern int nicy_lua_pcall(LuauState *l, int nargs, int nresults, int errfunc);
extern const char* nicy_lua_tostring(LuauState *l, int idx);
extern void nicy_lua_settop(LuauState *l, int idx);

int call_global_with_string(LuauState* l, const char* fn, const char* arg, const char** outErr) {
    nicy_lua_getglobal(l, fn);
    nicy_lua_pushstring(l, arg);

    if (nicy_lua_pcall(l, 1, 0, 0) != 0) {
        if (outErr) *outErr = nicy_lua_tostring(l, -1);
        nicy_lua_settop(l, 0);
        return 0;
    }

    return 1;
}
```

## Advanced example 3: Rust FFI declarations for a native extension

```rust
use core::ffi::{c_char, c_int};

#[repr(C)]
pub struct LuauState {
    _private: [u8; 0],
}

pub type LuaCFunction = unsafe extern "C" fn(*mut LuauState) -> c_int;

unsafe extern "C" {
    fn nicy_luaL_checkstring(l: *mut LuauState, narg: c_int) -> *const c_char;
    fn nicy_lua_pushstring(l: *mut LuauState, s: *const c_char);
    fn nicy_lua_pushcfunction(l: *mut LuauState, f: LuaCFunction);
    fn nicy_lua_setglobal(l: *mut LuauState, k: *const c_char);
}
```

## Production rules for stable bare-metal integrations

1. Keep strict stack discipline for every C function boundary.
2. Use `nicy_luaL_check*` for argument validation.
3. Prefer `nicy_lua_pcall` over raw `nicy_lua_call` in unsafe boundaries.
4. Keep one dedicated module for ABI wrappers.
5. Pin runtime/host versions together in releases.
6. Add symbol-resolution checks in startup (`GetProcAddress`/`dlsym`).
7. Fail fast on missing exports and report clear diagnostics.

## Complete C-ABI export index

```c
// Table operations
void nicy_lua_createtable(LuauState *l, int narr, int nrec);
void nicy_lua_setfield(LuauState *l, int idx, const char *k);
void nicy_lua_getfield(LuauState *l, int idx, const char *k);
void nicy_lua_gettable(LuauState *l, int idx);
void nicy_lua_settable(LuauState *l, int idx);
void nicy_lua_rawget(LuauState *l, int idx);
void nicy_lua_rawset(LuauState *l, int idx);
void nicy_lua_rawgeti(LuauState *l, int idx, lua_Integer n);
void nicy_lua_rawseti(LuauState *l, int idx, lua_Integer n);

// Stack manipulation
void nicy_lua_settop(LuauState *l, int idx);
int nicy_lua_gettop(LuauState *l);
void nicy_lua_pushvalue(LuauState *l, int idx);
void nicy_lua_remove(LuauState *l, int idx);
void nicy_lua_insert(LuauState *l, int idx);
int nicy_lua_absindex(LuauState *l, int idx);
int nicy_lua_checkstack(LuauState *l, int extra);

// Push values
void nicy_lua_pushnil(LuauState *l);
void nicy_lua_pushboolean(LuauState *l, int b);
void nicy_lua_pushnumber(LuauState *l, lua_Number n);
void nicy_lua_pushinteger(LuauState *l, lua_Integer n);
void nicy_lua_pushstring(LuauState *l, const char *s);
void nicy_lua_pushlstring(LuauState *l, const char *s, size_t len);
void nicy_lua_pushcfunction(LuauState *l, lua_CFunction f);
void nicy_lua_pushcclosure(LuauState *l, lua_CFunction f, int n);
void nicy_lua_pushlightuserdata(LuauState *l, void *p);

// Type checks and retrieval
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

// Conversion
int nicy_lua_toboolean(LuauState *l, int idx);
const char *nicy_lua_tostring(LuauState *l, int idx);
const char *nicy_lua_tolstring(LuauState *l, int idx, size_t *len);
lua_Integer nicy_lua_tointeger(LuauState *l, int idx);
void *nicy_lua_touserdata(LuauState *l, int idx);

// Argument checks
const char *nicy_luaL_checkstring(LuauState *l, int narg);
const char *nicy_luaL_checklstring(LuauState *l, int narg, size_t *len);
lua_Integer nicy_luaL_checkinteger(LuauState *l, int narg);

// Globals
void nicy_lua_getglobal(LuauState *l, const char *k);
void nicy_lua_setglobal(LuauState *l, const char *k);

// Metatables
int nicy_lua_getmetatable(LuauState *l, int idx);
int nicy_lua_setmetatable(LuauState *l, int idx);

// Calls
void nicy_lua_call(LuauState *l, int nargs, int nresults);
int nicy_lua_pcall(LuauState *l, int nargs, int nresults, int errfunc);

// Coroutines
LuauState *nicy_lua_newthread(LuauState *l);
int nicy_lua_resume(LuauState *l, LuauState *from, int nargs, int *nres);
int nicy_lua_yield(LuauState *l, int nresults);

// Userdata
void *nicy_lua_newuserdata(LuauState *l, size_t sz);

// Misc
void nicy_lua_concat(LuauState *l, int n);
int nicy_lua_next(LuauState *l, int idx);
int nicy_lua_rawequal(LuauState *l, int idx1, int idx2);
int nicy_lua_gc(LuauState *l, int what, int data);

// Errors
int nicy_lua_error(LuauState *l);
int nicy_luaL_error(LuauState *l, const char *msg);

// Registry references
int nicy_luaL_ref(LuauState *l, int t);
void nicy_luaL_unref(LuauState *l, int t, int r);
```
