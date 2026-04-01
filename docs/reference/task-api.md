# Task API Reference

## Global: `task`

### `task.spawn(f, ...): thread`

Schedules immediate asynchronous callback.

### `task.defer(f, ...): thread`

Schedules callback for a later scheduler cycle.

### `task.delay(seconds, f, ...): delay_id`

Schedules callback after delay.

### `task.wait(seconds?): number`

Yields current coroutine for optional duration.

**Minimum duration:** ~0.007s (140Hz). Values below this threshold are clamped to prevent busy-loops.

```luau
task.wait()      -- yields ~0.007s (minimum)
task.wait(0)     -- yields ~0.007s (minimum)  
task.wait(0.1)   -- yields ~0.1s
```

Returns elapsed time.

### `task.cancel(thread_or_id): ()`

Cancels active scheduled unit.

## Scheduler model

- cooperative
- explicit yield-based progress
- minimum yield duration: ~0.007s (140Hz)

## Example

<<< @/examples/luau/task/worker_loop.luau

## Failure modes

- starvation from loops without `task.wait`
- runaway spawn recursion
- untracked delay handles


