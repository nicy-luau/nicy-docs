# Require e Cache

O `nicyrtdyn` usa um `require()` customizado para módulos Luau.

## Recursos

- cache por módulo
- fingerprint de arquivo (invalidação automática)
- suporte a aliases em `.luaurc`
- detecção de dependência circular

## Comportamento esperado

- Se o arquivo do módulo muda, o cache antigo é descartado.
- Requerimentos repetidos reutilizam o módulo em memória.
- Aliases ajudam a manter import estável em projetos grandes.

## Exemplo simples

```luau
local util = require("./util.luau")
local util2 = require("./util.luau")
print(util == util2) -- true (cache)
```

## Observação sobre `--!native`

O CodeGen é por arquivo/módulo:

- se o módulo tiver `--!native`, ele pode usar JIT mesmo que o entry não tenha
- se o entry tiver `--!native`, isso não obriga módulos sem diretiva a usar JIT

Valide com:

```luau
print(runtime.hasJIT("./modulo.luau"))
```
