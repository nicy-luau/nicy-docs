# JIT and Module Boundaries

`--!native` controls JIT at file scope.

## Rules

- Each file decides its own JIT mode
- Entry file JIT does not cascade globally
- Required module can enable JIT independently

## Why this matters

- Predictable behavior for package/module authors
- Avoids hidden global toggles
- Improves module portability

## Practical recommendation

Use `runtime.hasJIT(path?)` in diagnostics and tests to validate expected behavior.
