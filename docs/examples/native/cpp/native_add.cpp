// native_add.cpp
// C++ variant of nativeAdd module with C ABI boundary.

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
