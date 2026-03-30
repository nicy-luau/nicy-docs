# nicyrtdyn Guide

`nicyrtdyn` is the runtime engine backing Nicy.

## What it provides

- Luau execution environment
- scheduler and module resolver
- runtime globals (`runtime`, `task`)
- host API for embedding
- C-ABI exports for native modules

## Host API entrypoints

- `nicy_start(const char* filepath)`
- `nicy_eval(const char* code)`
- `nicy_compile(const char* filepath)`
- `nicy_version()`
- `nicy_luau_version()`

## Embedding workflow

1. Load runtime shared library.
2. Resolve required symbols.
3. Validate symbols before executing scripts.
4. Execute script/eval/compile operation.

## Minimal host examples

::: code-group

```c [Windows Loader]
#include <windows.h>

typedef void (__cdecl *nicy_start_t)(const char*);

typedef const char* (__cdecl *nicy_version_t)(void);

int main(void) {
    HMODULE rt = LoadLibraryA("nicyrtdyn.dll");
    if (!rt) return 1;

    nicy_start_t nicy_start = (nicy_start_t)GetProcAddress(rt, "nicy_start");
    nicy_version_t nicy_version = (nicy_version_t)GetProcAddress(rt, "nicy_version");
    if (!nicy_start || !nicy_version) return 2;

    nicy_start("main.luau");
    FreeLibrary(rt);
    return 0;
}
```

```c [POSIX Loader]
#include <dlfcn.h>

typedef void (*nicy_start_t)(const char*);

typedef const char* (*nicy_version_t)(void);

int main(void) {
    void* rt = dlopen("libnicyrtdyn.so", RTLD_NOW);
    if (!rt) return 1;

    nicy_start_t nicy_start = (nicy_start_t)dlsym(rt, "nicy_start");
    nicy_version_t nicy_version = (nicy_version_t)dlsym(rt, "nicy_version");
    if (!nicy_start || !nicy_version) return 2;

    nicy_start("main.luau");
    dlclose(rt);
    return 0;
}
```

:::

## Native module path

For native module authoring details, continue to:

- [FFI / Bare Metal Guide](/ffi-bare-metal)
