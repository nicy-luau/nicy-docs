# CLI (`nicy`)

O `nicy` é o host executável que carrega o runtime `nicyrtdyn` dinamicamente.

## Comandos

### Executar script

```bash
nicy run arquivo.luau
```

### Executar código inline

```bash
nicy eval "print('oi')"
```

### Compilar para bytecode

```bash
nicy compile arquivo.luau
```

## Runtime dinâmico

O CLI procura a biblioteca `nicyrtdyn`:

- no mesmo diretório do executável `nicy`
- ou no `PATH` do sistema

Nomes comuns por plataforma:

- Windows: `nicyrtdyn.dll`
- Linux: `libnicyrtdyn.so`
- macOS: `libnicyrtdyn.dylib`

## API disponível em scripts

Quando seu script roda via `nicy`, você tem:

- objeto global `runtime`
- biblioteca global `task`

Veja:

- [Runtime](/runtime)
- [Task Scheduler](/task)
