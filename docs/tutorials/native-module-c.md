# Build a Native Module (Tutorial)

## Goal

Build `nativeAdd(a, b)` as a native module and call it from Luau.

## Step 1: implement native module

::: code-group

```c [C]
<<< ../examples/native/c/native_add.c
```

```cpp [C++]
<<< ../examples/native/cpp/native_add.cpp
```

```rust [Rust]
<<< ../examples/native/rust/src/lib.rs
```

:::

## Step 2: build

::: code-group

```powershell [MSVC]
cl /LD native_add.c /Fenative_add.dll
```

```bash [Rust]
cargo build --release
```

:::

## Step 3: load from Luau

```luau
<<< ../examples/luau/native/native_load_windows.luau
```
