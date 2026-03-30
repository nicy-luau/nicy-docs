# FFI / Bare Metal ABI Reference

Use this layer for direct low-level integration with Luau state through `nicyrtdyn` exported C-ABI functions.

## Integration model

- Host loads `nicyrtdyn`
- Native extension uses exported ABI functions
- Extension registers C functions/globals into Luau state

## Safety rules

1. Maintain strict stack discipline
2. Validate all arguments with `nicy_luaL_check*`
3. Prefer `nicy_lua_pcall` for protected boundaries
4. Keep ABI wrappers isolated in one module

## Advanced C example

```c
typedef struct lua_State LuauState;
typedef int (*lua_CFunction)(LuauState*);
extern const char* nicy_luaL_checkstring(LuauState *l, int narg);
extern void nicy_lua_pushstring(LuauState *l, const char *s);
extern void nicy_lua_pushcfunction(LuauState *l, lua_CFunction f);
extern void nicy_lua_setglobal(LuauState *l, const char *k);

static int native_echo(LuauState* l) {
    const char* s = nicy_luaL_checkstring(l, 1);
    nicy_lua_pushstring(l, s);
    return 1;
}

void register_native(LuauState* l) {
    nicy_lua_pushcfunction(l, native_echo);
    nicy_lua_setglobal(l, "nativeEcho");
}
```

## Advanced Rust declarations

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
