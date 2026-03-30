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

### `task.cancel(thread_or_id): ()`

Cancels active scheduled unit.

## Scheduler model

- cooperative
- explicit yield-based progress

## Example

<<< @/examples/luau/task/worker_loop.luau

## Failure modes

- starvation from loops without `task.wait`
- runaway spawn recursion
- untracked delay handles


