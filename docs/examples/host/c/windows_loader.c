// windows_loader.c
// Minimal host embedding flow on Windows.

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
