// native_add.c
// Native module example for Nicy bare-metal ABI.
// Registers nativeAdd(a, b) and returns one integer.
//
// Entry point: int nicydinamic_init(LuauState* l)
// Note: The function name must be exactly "nicydinamic_init" or "nicydynamic_init"

typedef struct lua_State LuauState;
typedef long long lua_Integer;
typedef int (*lua_CFunction)(LuauState*);

extern lua_Integer nicy_luaL_checkinteger(LuauState *l, int narg);
extern void nicy_lua_pushinteger(LuauState *l, lua_Integer n);
extern void nicy_lua_pushcfunction(LuauState *l, lua_CFunction f);
extern void nicy_lua_setglobal(LuauState *l, const char *k);
extern void nicy_lua_createtable(LuauState *l, int narr, int nrec);

static int native_add(LuauState* l) {
    // Validate and read input arguments from stack positions 1 and 2.
    lua_Integer a = nicy_luaL_checkinteger(l, 1);
    lua_Integer b = nicy_luaL_checkinteger(l, 2);

    // Push one return value to stack.
    nicy_lua_pushinteger(l, a + b);
    return 1;
}

// Module entry point - called by nicyrtdyn when loading the module
// Must return the number of values on the stack (usually 1 for module table)
__declspec(dllexport) int nicydinamic_init(LuauState* l) {
    // Create a table for module exports (optional - can also use globals)
    nicy_lua_createtable(l, 0, 1);
    
    // Register global function name visible to Luau scripts.
    nicy_lua_pushcfunction(l, native_add);
    nicy_lua_setglobal(l, "nativeAdd");
    
    // Return 1 (the module table on stack)
    return 1;
}
