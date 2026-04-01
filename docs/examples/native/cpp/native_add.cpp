// native_add.cpp
// C++ variant of nativeAdd module with C ABI boundary.
//
// Entry point: extern "C" __declspec(dllexport) int nicydinamic_init(LuauState* l)
// Note: The function name must be exactly "nicydinamic_init" or "nicydynamic_init"

extern "C" {
    typedef struct lua_State LuauState;
    typedef long long lua_Integer;
    typedef int (*lua_CFunction)(LuauState*);

    lua_Integer nicy_luaL_checkinteger(LuauState *l, int narg);
    void nicy_lua_pushinteger(LuauState *l, lua_Integer n);
    void nicy_lua_pushcfunction(LuauState *l, lua_CFunction f);
    void nicy_lua_setglobal(LuauState *l, const char *k);
    void nicy_lua_createtable(LuauState *l, int narr, int nrec);
}

static int native_add(LuauState* l) {
    auto a = nicy_luaL_checkinteger(l, 1);
    auto b = nicy_luaL_checkinteger(l, 2);
    nicy_lua_pushinteger(l, a + b);
    return 1;
}

// Module entry point - called by nicyrtdyn when loading the module
// Must return the number of values on the stack (usually 1 for module table)
extern "C" __declspec(dllexport) int nicydinamic_init(LuauState* l) {
    // Create a table for module exports (optional - can also use globals)
    nicy_lua_createtable(l, 0, 1);
    
    nicy_lua_pushcfunction(l, native_add);
    nicy_lua_setglobal(l, "nativeAdd");
    
    // Return 1 (the module table on stack)
    return 1;
}
