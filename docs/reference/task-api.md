# Task API Reference

## Global library: `task`

### `task.spawn(f, ...): thread`

Schedules execution immediately.

### `task.defer(f, ...): thread`

Schedules execution in a later scheduler cycle.

### `task.delay(seconds, f, ...): delay_id`

Schedules callback after delay.

### `task.wait(seconds?): number`

Yields current coroutine.

### `task.cancel(thread_or_id): ()`

Cancels scheduled work.

## Notes

- Scheduler is cooperative
- Long-running loops should yield with `task.wait`
