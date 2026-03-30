# nicyrtdyn Runtime Engine

`nicyrtdyn` is the dynamic runtime core used by `nicy` and custom hosts.

## What this project is

- A Rust `cdylib` runtime for Luau execution.
- Host-callable API (`nicy_start`, `nicy_eval`, `nicy_compile`).
- Runtime globals for scripts (`runtime`, `task`).
- Native module loading bridge and low-level C-ABI exports.

## Host API (high-level)

### `nicy_start(const char* filepath)`

Boot runtime and execute script.

### `nicy_eval(const char* code)`

Execute source string in runtime context.

### `nicy_compile(const char* filepath)`

Compile script to bytecode output.

### `nicy_version()` / `nicy_luau_version()`

Return runtime and Luau version strings.

## Runtime lifecycle

1. Host loads shared library.
2. Host resolves required symbols.
3. Runtime initializes Luau state.
4. Runtime installs globals and resolver.
5. Script executes.
6. Runtime returns control/errors to host.

## Embedding example (C, Windows)

```c
#include <windows.h>
#include <stdio.h>

typedef void (__cdecl *nicy_start_t)(const char*);
typedef const char* (__cdecl *nicy_version_t)(void);

int main(void) {
    HMODULE rt = LoadLibraryA("nicyrtdyn.dll");
    if (!rt) {
        fprintf(stderr, "failed to load nicyrtdyn.dll\n");
        return 1;
    }

    nicy_start_t nicy_start = (nicy_start_t)GetProcAddress(rt, "nicy_start");
    nicy_version_t nicy_version = (nicy_version_t)GetProcAddress(rt, "nicy_version");

    if (!nicy_start || !nicy_version) {
        fprintf(stderr, "missing required runtime exports\n");
        return 2;
    }

    printf("runtime: %s\n", nicy_version());
    nicy_start("main.luau");

    FreeLibrary(rt);
    return 0;
}
```

## Native module development tracks

- Script-level loading: `runtime.loadlib` in Luau.
- Bare-metal integration: `nicy_lua_*` C-ABI functions.

For multi-language module examples, see:

- [FFI / Bare Metal ABI Reference](/reference/ffi-bare-metal)
