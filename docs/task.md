# Task Guide

This page covers practical scheduler usage patterns.

## API summary

- `task.spawn`
- `task.defer`
- `task.delay`
- `task.wait`
- `task.cancel`

## Production-safe loop pattern

```luau
<<< @/examples/luau/task/worker_loop.luau
```

## Choosing the right primitive

- `spawn`: immediate asynchronous execution
- `defer`: run later to avoid re-entrancy
- `delay`: timed callback
- `wait`: cooperative yield
- `cancel`: stop delayed/active handles

## Failure prevention

1. Never busy-loop without `task.wait`.
2. Always design cancellation paths.
3. Keep async callbacks short and composable.

