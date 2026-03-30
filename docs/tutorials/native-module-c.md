# Build a Native Module (C)

This tutorial builds a native shared library and loads it through `runtime.loadlib`.

## Prerequisites

- Nicy installed and working
- C toolchain available

## Step 1: Create Luau loader

`main.luau`:

```luau
local mod = runtime.loadlib("@self/native/test_extension.dll")
print("native module loaded:", mod ~= nil)
```

Use `.so` on Linux or `.dylib` on macOS.

## Step 2: Implement native export

Your library must expose the expected entrypoints required by your runtime bridge.

Minimum checks during development:

- Build shared library format for your platform
- Verify exported symbol names
- Keep ABI and calling convention consistent

## Step 3: Place and run

Place the binary under `native/` and run:

```bash
nicy run main.luau
```

## Validation checklist

- Library file exists at the resolved path
- Export symbols are present
- Runtime loads library without symbol errors

## Troubleshooting

- [Fix common runtime errors](/how-to/fix-common-errors)
- [FFI / Bare Metal ABI](/reference/ffi-bare-metal)
