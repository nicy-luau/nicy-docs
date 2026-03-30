# Load Native Libraries

Use `runtime.loadlib(path)` to load native dynamic libraries.

## Path patterns

- Relative path from script location
- `@self` alias for current script directory

Example:

```luau
local lib = runtime.loadlib("@self/native/test_extension.dll")
```

## Platform filenames

- Windows: `.dll`
- Linux: `.so`
- macOS: `.dylib`

## Recommended layout

```text
project/
  main.luau
  native/
    test_extension.dll
```

## Verify successful load

- `runtime.loadlib` returns non-nil value/object per your module contract
- no loader error from runtime

## If it fails

Go to [Fix common runtime errors](/how-to/fix-common-errors).
