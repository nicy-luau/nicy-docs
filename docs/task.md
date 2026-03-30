# Task Guide

`task` provides cooperative scheduling in Luau. This page focuses on practical patterns.

## APIs

- `task.spawn`
- `task.defer`
- `task.delay`
- `task.wait`
- `task.cancel`

## When to use each API

::: code-group

```luau [spawn]
-- Immediate async execution.
task.spawn(function()
    print("spawned")
end)
```

```luau [defer]
-- Defers execution to avoid re-entrant side effects.
task.defer(function()
    print("deferred")
end)
```

```luau [delay]
-- Time-based scheduling.
local id = task.delay(1.5, function()
    print("after delay")
end)
```

:::

## Loop pattern that does not starve scheduler

```luau
local running = true

local worker = task.spawn(function()
    while running do
        -- small unit of work
        task.wait(0.016)
    end
end)

-- shutdown path
running = false
task.cancel(worker)
```

## Anti-patterns to avoid

1. Infinite loop without `task.wait`.
2. Unbounded recursive `task.spawn`.
3. Never cancelling long delays.

## Debug checklist

- Track callback timestamps.
- Measure long synchronous blocks.
- Verify cancellation paths on shutdown.
