# Task Scheduler

`task` provides cooperative scheduling for Luau coroutines.

## `task.spawn(f, ...)`

Schedules a coroutine immediately.

```luau
task.spawn(function(name)
    print("spawn", name)
end, "worker")
```

## `task.defer(f, ...)`

Schedules for the next scheduler cycle.

```luau
task.defer(function()
    print("deferred")
end)
```

## `task.delay(seconds, f, ...)`

Schedules execution after a delay.

```luau
task.delay(1.5, function()
    print("executed after 1.5s")
end)
```

## `task.wait(seconds?)`

Yields the current coroutine.

```luau
task.wait(0.25)
```

## `task.cancel(thread_or_id)`

Cancels a scheduled or running task.

```luau
local id = task.delay(10, function()
    print("should not run")
end)

task.cancel(id)
```

## Best practices

- Never busy-loop without `task.wait`.
- Prefer `task.defer` to decouple side effects from hot call paths.
- Cancel long-lived delayed tasks when no longer needed.
