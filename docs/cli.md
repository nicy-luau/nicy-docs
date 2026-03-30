# CLI (`nicy`)

`nicy` is the executable host that dynamically loads `nicyrtdyn`.

## Commands

### Run a script

```bash
nicy run script.luau
```

### Evaluate inline code

```bash
nicy eval "print('hello')"
```

### Compile to bytecode

```bash
nicy compile script.luau
```

## Dynamic runtime loading

`nicy` resolves `nicyrtdyn` in this order:

1. The same directory as the `nicy` executable.
2. Directories available in the system `PATH`.

Shared library names by platform:

- Windows: `nicyrtdyn.dll`
- Linux: `libnicyrtdyn.so`
- macOS: `libnicyrtdyn.dylib`

## Runtime APIs available to scripts

When running through `nicy`, scripts have:

- global `runtime`
- global `task`

See:

- [Runtime](/runtime)
- [Task Scheduler](/task)
