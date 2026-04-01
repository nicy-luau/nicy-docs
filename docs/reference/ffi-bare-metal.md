# FFI ABI Reference

This appendix defines the low-level exported ABI surface used by native modules.

## Module entry point

Native modules must export exactly one of these entry points:

- `nicydinamic_init` (preferred spelling)
- `nicydynamic_init` (alternative spelling)

### Signature

**Rust:**
```rust
#[unsafe(no_mangle)]
pub unsafe extern "C-unwind" fn nicydinamic_init(l: *mut LuauState) -> c_int
```

**C/C++:**
```c
__declspec(dllexport) int nicydinamic_init(LuauState* l);
```

### Return value

The entry point must return the **number of values left on the stack** (typically 1 for a module table).

## ABI safety requirements

1. Validate arguments using `nicy_luaL_check*` functions
2. Push exactly the declared number of return values
3. Maintain stack integrity across calls
4. Keep C ABI boundaries explicit (`extern "C"` for C++, `extern "C-unwind"` for Rust)
5. Use `__declspec(dllexport)` on Windows for the entry point

## Core examples

::: code-group

<<< @/examples/native/c/native_add.c [C module]

<<< @/examples/native/cpp/native_add.cpp [C++ module]

<<< @/examples/native/rust/src/lib.rs [Rust module]

:::

## Full export list

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


