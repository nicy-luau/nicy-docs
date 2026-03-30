# Task Scheduler

O `task` é um scheduler cooperativo para corrotinas Luau.

## `task.spawn(f, ...)`

Executa uma corrotina imediatamente.

```luau
task.spawn(function(name)
    print("spawn:", name)
end, "A")
```

## `task.defer(f, ...)`

Agenda para o próximo ciclo de execução.

```luau
task.defer(function()
    print("defer")
end)
```

## `task.delay(seconds, f, ...)`

Agenda execução após atraso.

```luau
task.delay(1.5, function()
    print("rodou depois de 1.5s")
end)
```

## `task.wait(seconds?)`

Suspende a corrotina atual.

```luau
task.wait(0.25)
```

## `task.cancel(thread_or_id)`

Cancela tarefa agendada/em execução.

```luau
local id = task.delay(10, function() print("nao deve rodar") end)
task.cancel(id)
```

## Boas práticas

- Evite loops infinitos sem `task.wait`.
- Prefira `task.defer` para desacoplar callbacks.
- Cancele delays longos quando não forem mais necessários.
