# Project Overview

Nicy provides a practical way to run Luau scripts with native runtime capabilities.

## Components

- `nicy` handles CLI parsing and dynamic runtime loading
- `nicyrtdyn` initializes Luau, scheduler, module resolver, and native bridge

## Runtime model

1. User calls `nicy run file.luau`
2. `nicy` loads `nicyrtdyn` from local folder or PATH
3. `nicyrtdyn` boots Luau state and globals
4. Script executes with `runtime` and `task` APIs available

## When to use what

- Use `run` for executing scripts
- Use `eval` for shell snippets and quick checks
- Use `compile` for generating `.luauc` bytecode artifacts

## Next steps

- [Install and verify](/how-to/install-and-verify)
- [Your first Nicy project](/tutorials/first-project)
- [Architecture explanation](/explanation/architecture)
