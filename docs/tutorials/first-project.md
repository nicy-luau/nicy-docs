# Your First Nicy Project (Tutorial)

## Goal

Create and execute a Luau project with one required module.

## Files

`main.luau`:

```luau
print("hello from nicy")
local cfg = require("./config.luau")
print(cfg.name)
```

`config.luau`:

```luau
return {
    name = "demo"
}
```

## Run

```bash
nicy run main.luau
```

## Outcome

- script execution works
- `require` path works
- runtime integrated correctly
