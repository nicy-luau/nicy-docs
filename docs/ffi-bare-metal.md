# FFI / Bare Metal

Além da Host API, o `nicyrtdyn` exporta funções C-ABI de baixo nível para operar diretamente na stack do Luau.

## Casos de uso

- bindings nativos em C/C++/Rust
- módulos de alta performance
- integração direta com engines/SDKs

## Grupos de funções disponíveis

- stack: `nicy_lua_gettop`, `nicy_lua_settop`, `nicy_lua_pushvalue`
- tabelas: `nicy_lua_getfield`, `nicy_lua_setfield`, `nicy_lua_rawget`, `nicy_lua_rawset`
- tipos: `nicy_lua_type`, `nicy_lua_isnumber`, `nicy_lua_tostring`
- chamadas: `nicy_lua_call`, `nicy_lua_pcall`
- corrotinas: `nicy_lua_newthread`, `nicy_lua_resume`, `nicy_lua_yield`
- referências: `nicy_luaL_ref`, `nicy_luaL_unref`
- erros: `nicy_lua_error`, `nicy_luaL_error`

## Exemplo: registrar função C

```c
typedef struct lua_State LuauState;
typedef int (*lua_CFunction)(LuauState*);

extern void nicy_lua_pushcfunction(LuauState *l, lua_CFunction f);
extern void nicy_lua_setglobal(LuauState *l, const char *k);
```

## Cuidados críticos

- gerencie índice de stack com precisão
- use `pcall` quando possível
- valide tipos antes de converter
- mantenha contrato ABI estável entre host e módulo

## Estratégia recomendada

1. Comece com a Host API (`nicy_start`, `nicy_eval`, `nicy_compile`)
2. Avance para C-ABI baixo nível apenas quando necessário
3. Isolar camada FFI em módulo dedicado para facilitar manutenção
