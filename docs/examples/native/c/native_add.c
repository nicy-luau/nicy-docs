// native_add.c
// Native module example for Nicy bare-metal ABI.
// Registers nativeAdd(a, b) and returns one integer.

typedef struct lua_State LuauState;
typedef long long lua_Integer;
typedef int (*lua_CFunction)(LuauState*);

extern lua_Integer nicy_luaL_checkinteger(LuauState *l, int narg);
extern void nicy_lua_pushinteger(LuauState *l, lua_Integer n);
extern void nicy_lua_pushcfunction(LuauState *l, lua_CFunction f);
extern void nicy_lua_setglobal(LuauState *l, const char *k);

static int native_add(LuauState* l) {
    // Validate and read input arguments from stack positions 1 and 2.
    lua_Integer a = nicy_luaL_checkinteger(l, 1);
    lua_Integer b = nicy_luaL_checkinteger(l, 2);

    // Push one return value to stack.
    nicy_lua_pushinteger(l, a + b);
    return 1;
}

__declspec(dllexport) void nicy_module_init(LuauState* l) {
    // Register global function name visible to Luau scripts.
    nicy_lua_pushcfunction(l, native_add);
    nicy_lua_setglobal(l, "nativeAdd");
}
