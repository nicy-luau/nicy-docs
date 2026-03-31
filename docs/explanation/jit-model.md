# JIT Model Explanation

## Core rule

JIT is file-scoped (`--!native`), not global.

Android/Termux note: current runtime builds disable Luau CodeGen/JIT on mobile for stability. In that environment, `--!native` is accepted but not activated, and `runtime.hasJIT(...)` stays `false`.

## Why this design

- predictable module behavior
- no hidden global state toggles
- package-level control over native codegen boundaries

## Practical implications

1. entry and required module may have different JIT states
2. tests should validate JIT state explicitly
3. performance assumptions should be module-specific
