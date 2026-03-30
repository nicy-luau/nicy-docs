# Host API Reference (`nicyrtdyn`)

## Exported host functions

### `void nicy_start(const char* filepath)`

Boot runtime and execute script file.

### `void nicy_eval(const char* code)`

Execute source string.

### `void nicy_compile(const char* filepath)`

Compile source file to bytecode output.

### `const char* nicy_version(void)`

Runtime version string.

### `const char* nicy_luau_version(void)`

Embedded Luau version string.

## Host integration requirements

- Resolve all required exports on startup
- Validate runtime/host artifact compatibility
- Fail fast when symbols are missing

## Minimal C loader pattern

```c
typedef void (__cdecl *nicy_start_t)(const char*);
typedef const char* (__cdecl *nicy_version_t)(void);
```
