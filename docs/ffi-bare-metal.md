# FFI / Bare Metal Guide

This page is for native module authors.

## Objective

Expose a real native function to Luau using Nicy ABI.

## Important ABI contract

- **Entry point function name:** `nicydinamic_init` or `nicydynamic_init` (spelling variants accepted)
- **Function signature:** `pub unsafe extern "C-unwind" fn nicydinamic_init(l: *mut LuauState) -> c_int` (Rust) or `int nicydinamic_init(LuauState* l)` (C/C++)
- **Return value:** Number of values left on the stack (usually 1 for module table)
- **Validate input stack arguments** using `nicy_luaL_check*` functions
- **Push the correct number of return values** before returning
- **Use C ABI boundary explicitly** (`extern "C"` for C++, `extern "C-unwind"` for Rust)

## Native module implementations

::: code-group

<<< @/examples/native/c/native_add.c [C module]

<<< @/examples/native/cpp/native_add.cpp [C++ module]

<<< @/examples/native/rust/Cargo.toml [Rust Cargo.toml]

<<< @/examples/native/rust/src/lib.rs [Rust module]

:::

## Build commands

::: code-group

```powershell [C/C++ on Windows (MSVC)]
cl /LD native_add.c /Fenative_add.dll
cl /LD native_add.cpp /EHsc /Fenative_add.dll
```

```bash [Rust (all platforms)]
cargo build --release
```

```bash [Inspect exported symbols]
# Windows
# dumpbin /exports native_add.dll

# Linux
# nm -D libnative_add.so

# macOS
# nm -gU libnative_add.dylib
```

:::

## Luau-side usage

::: code-group

<<< @/examples/luau/native/native_load_windows.luau [Windows]

<<< @/examples/luau/native/native_load_linux.luau [Linux]

<<< @/examples/luau/native/native_load_macos.luau [macOS]

:::

## Frequent failure modes

1. **Symbol not found:** Wrong entry point name (must be `nicydinamic_init` or `nicydynamic_init`)
2. **Wrong signature:** Must return `int`, not `void`
3. **Crash on call:** Invalid stack contract or missing `extern "C-unwind"` (Rust)
4. **Load error:** Wrong architecture or missing dependencies
5. **Runtime mismatch:** Incompatible CLI/runtime release pair

## Complete ABI list

See [FFI ABI Reference Appendix](/reference/ffi-bare-metal).


