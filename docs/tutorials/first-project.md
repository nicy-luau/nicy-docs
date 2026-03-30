# Your First Nicy Project

This tutorial creates and runs a minimal Luau project with Nicy.

## Prerequisites

- Nicy installed: [Install and verify](/how-to/install-and-verify)

## Step 1: Create project files

```bash
mkdir nicy-demo
cd nicy-demo
```

Create `main.luau`:

```luau
print("hello from nicy")
print("runtime version:", runtime.version)
```

## Step 2: Run the script

```bash
nicy run main.luau
```

Expected output includes:

- `hello from nicy`
- runtime version string

## Step 3: Add a module

Create `mathutil.luau`:

```luau
local M = {}

function M.sum(a, b)
    return a + b
end

return M
```

Update `main.luau`:

```luau
local mathutil = require("./mathutil.luau")
print("2 + 5 =", mathutil.sum(2, 5))
```

Run again:

```bash
nicy run main.luau
```

## What you learned

- Basic project setup
- Script execution
- Module loading through `require`
- Accessing `runtime` global

## Continue

- [Enable JIT in modules](/how-to/enable-jit)
- [Runtime API reference](/reference/runtime-api)
