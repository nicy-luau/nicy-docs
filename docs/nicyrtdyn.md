# nicyrtdyn (Host API)

`nicyrtdyn` is the dynamic runtime library (`cdylib`) loaded by `nicy` or any custom host.

## Primary exported symbols

### `nicy_start(const char* filepath)`

Initializes the runtime environment and executes a `.luau` script.

### `nicy_eval(const char* code)`

Evaluates Luau source from a string.

### `nicy_compile(const char* filepath)`

Compiles source into Luau bytecode (`.luauc`) without executing.

### `nicy_version()`

Returns runtime version string.

### `nicy_luau_version()`

Returns embedded Luau engine version string.

## Minimal C embedding (Windows)

```c
#include <windows.h>

typedef void (__cdecl *nicy_start_t)(const char*);

typedef const char* (__cdecl *nicy_version_t)(void);

int main(void) {
    HMODULE lib = LoadLibraryA("nicyrtdyn.dll");
    if (!lib) return 1;

    nicy_start_t nicy_start = (nicy_start_t)GetProcAddress(lib, "nicy_start");
    nicy_version_t nicy_version = (nicy_version_t)GetProcAddress(lib, "nicy_version");
    if (!nicy_start || !nicy_version) return 2;

    const char* v = nicy_version();
    (void)v;

    nicy_start("script.luau");
    FreeLibrary(lib);
    return 0;
}
```

## Host integration checklist

1. Load the runtime dynamic library.
2. Resolve mandatory symbols.
3. Validate symbol resolution and fail fast if missing.
4. Call `nicy_start`, `nicy_eval`, or `nicy_compile`.
5. Keep runtime and host binaries from the same release line.
