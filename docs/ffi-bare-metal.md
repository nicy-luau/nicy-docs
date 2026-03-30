# FFI / Bare Metal Guide

This page is for native module authors.

## Objective

Expose a real native function to Luau (`nativeAdd`) using Nicy ABI.

## Important ABI contract

- validate input stack arguments
- push the correct number of return values
- use C ABI exports exactly as declared

## Native module implementations

::: code-group

```c [C module]
<<< ./examples/native/c/native_add.c
```

```cpp [C++ module]
<<< ./examples/native/cpp/native_add.cpp
```

```toml [Rust Cargo.toml]
<<< ./examples/native/rust/Cargo.toml
```

```rust [Rust module]
<<< ./examples/native/rust/src/lib.rs
```

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

```luau [Windows]
<<< ./examples/luau/native/native_load_windows.luau
```

```luau [Linux]
<<< ./examples/luau/native/native_load_linux.luau
```

```luau [macOS]
<<< ./examples/luau/native/native_load_macos.luau
```

:::

## Frequent failure modes

1. Symbol not found: missing `extern "C"` or wrong export name.
2. Crash on call: invalid stack contract.
3. Load error: wrong architecture or missing dependencies.
4. Runtime mismatch: incompatible CLI/runtime release pair.

## Complete ABI list

See [FFI ABI Reference Appendix](/reference/ffi-bare-metal).
