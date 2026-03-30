# Runtime

O objeto global `runtime` expõe metadados e integração nativa.

## `runtime.version`

Versão do runtime carregado (`nicyrtdyn`).

```luau
print(runtime.version)
```

## `runtime.hasJIT(path?: string): boolean`

Retorna se o CodeGen/JIT está ativo para um arquivo.

- sem argumento: verifica o arquivo atual
- com caminho: verifica o módulo informado

```luau
print(runtime.hasJIT())
print(runtime.hasJIT("./modulo.luau"))
```

Para ativar JIT em um arquivo Luau, use `--!native` na primeira linha desse arquivo.

## `runtime.entry_file`

Caminho absoluto do script de entrada.

## `runtime.entry_dir`

Diretório do script de entrada.

## `runtime.loadlib(path: string)`

Carrega biblioteca dinâmica nativa.

- aceita caminho relativo
- aceita alias `@self` para diretório do script atual

```luau
local ext = runtime.loadlib("@self/native/test_extension.dll")
```

## Próximos tópicos

- [Task Scheduler](/task)
- [Require e Cache](/require-cache)
- [FFI / Bare Metal](/ffi-bare-metal)
