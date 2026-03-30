// posix_loader.c
// Minimal host embedding flow on Linux/macOS.

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
