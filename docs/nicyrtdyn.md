# nicyrtdyn (Host API)

`nicyrtdyn` é a biblioteca dinâmica (`cdylib`) que implementa o runtime Luau.

## Exportações principais

### `nicy_start(const char* filepath)`

Inicializa runtime completo e executa um arquivo `.luau`.

### `nicy_eval(const char* code)`

Executa código Luau recebido como string.

### `nicy_compile(const char* filepath)`

Compila arquivo para bytecode `.luauc` (sem executar).

### `nicy_version()`

Retorna versão do runtime.

### `nicy_luau_version()`

Retorna versão do engine Luau embutido.

## Exemplo mínimo em C (Windows)

```c
#include <windows.h>
#include <stdio.h>

typedef void (__cdecl *nicy_start_t)(const char*);

int main() {
    HMODULE lib = LoadLibraryA("nicyrtdyn.dll");
    if (!lib) return 1;

    nicy_start_t nicy_start = (nicy_start_t)GetProcAddress(lib, "nicy_start");
    if (!nicy_start) return 2;

    nicy_start("script.luau");
    FreeLibrary(lib);
    return 0;
}
```

## Fluxo de embedding

1. Carregar biblioteca dinâmica
2. Resolver símbolos obrigatórios (`nicy_start`, etc.)
3. Chamar API desejada
4. Tratar erros de carregamento/símbolo
