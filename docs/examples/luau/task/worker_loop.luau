-- worker_loop.luau
-- Cooperative worker loop with explicit yielding and clean shutdown.

local running = true

local worker = task.spawn(function()
    while running do
        -- Do one small unit of work per iteration.
        -- Yield to avoid starving other scheduled tasks.
        task.wait(0.016)
    end
end)

-- Simulate main thread work.
task.wait(1.0)

-- Stop and cancel worker.
running = false
task.cancel(worker)
print("Worker stopped")
