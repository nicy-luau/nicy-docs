# Task Guide

This page covers practical scheduler usage patterns.

## API summary

- `task.spawn`
- `task.defer`
- `task.delay`
- `task.wait`
- `task.cancel`

## `task.wait` behavior

When called without arguments, `task.wait()` yields for a minimum of ~0.007s (140Hz).
Values below this threshold are clamped to the minimum to prevent busy-loops.

```luau
task.wait()      -- yields ~0.007s (minimum)
task.wait(0)     -- yields ~0.007s (minimum)
task.wait(0.1)   -- yields ~0.1s
```

## Production-safe loop pattern

<<< @/examples/luau/task/worker_loop.luau

## Choosing the right primitive

- `spawn`: immediate asynchronous execution
- `defer`: run later to avoid re-entrancy
- `delay`: timed callback
- `wait`: cooperative yield (minimum ~0.007s)
- `cancel`: stop delayed/active handles

## Failure prevention

1. Never busy-loop without `task.wait`.
2. Always design cancellation paths.
3. Keep async callbacks short and composable.


