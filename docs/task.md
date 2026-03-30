# Task Scheduler Deep Dive

Nicy provides a cooperative scheduler through the global `task` library.

## Mental model

- Scheduler is cooperative, not preemptive.
- Code yields control via `task.wait`.
- Long CPU loops without yield can starve other tasks.

## API behavior

### `task.spawn(f, ...)`

Schedules function immediately.

```luau
task.spawn(function(name)
    -- Useful for fire-and-forget async work.
    print("spawn", name)
end, "worker-A")
```

### `task.defer(f, ...)`

Schedules for a later scheduler cycle.

```luau
task.defer(function()
    -- Useful to avoid re-entrant side effects in current call stack.
    print("deferred")
end)
```

### `task.delay(seconds, f, ...)`

Runs callback after delay.

```luau
local delayId = task.delay(2.0, function()
    print("delayed callback")
end)
```

### `task.wait(seconds?)`

Yields current coroutine.

```luau
task.wait(0.1)
```

### `task.cancel(thread_or_id)`

Cancels delayed/scheduled work.

```luau
local id = task.delay(10, function() print("should not execute") end)
task.cancel(id)
```

## Common anti-patterns

1. Busy loops without `task.wait`.
2. Recursive `spawn` storms without backpressure.
3. Forgetting to cancel long delay handles.

## Practical pattern: worker loop

```luau
local running = true

local worker = task.spawn(function()
    while running do
        -- Do small unit of work.
        task.wait(0.016) -- Yield every frame-like tick.
    end
end)

-- Later:
running = false
task.cancel(worker)
```

## Debugging scheduler issues

- Add timestamps around `spawn/defer/delay` callbacks.
- Check whether long sync code blocks scheduler progress.
- Reduce callback payload size to isolate hotspots.
