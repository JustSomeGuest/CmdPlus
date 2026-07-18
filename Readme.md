# SimpleCMDS

A simple and lightweight command system for Roblox.

SimpleCMDS provides built-in commands, command aliases, customizable prefixes, and support for creating your own commands.

## Loading

Execute SimpleCMDS with:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/JustSomeGuest/SimpleCMDS/Stable/Source/Init.luau"))()
```

Or, if you want errors prefixed with `[SimpleCMDS]`:

```lua
local Success, Result = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/JustSomeGuest/SimpleCMDS/Stable/Source/Init.luau"))()
end)

if not Success then
    error("[SimpleCMDS]: " .. tostring(Result))
end
```

## Features

- Lightweight
- Built-in commands
- Command aliases
- Customizable command prefix
- User commands
- Easy to extend
- Player utilities
- AntiFling protection
- Server rejoining
- Server hopping
- Player teleportation

## Commands

| Command | Aliases | Usage | Description |
|----------|---------|-------|-------------|
| `Airwalk` | `aw` | `.airwalk` | Enables Airwalk. |
| `UnAirwalk` | `unaw` | `.unairwalk` | Disables Airwalk. |
| `AntiFling` | `af` | `.antifling` | Enables AntiFling protection. |
| `UnAntiFling` | `uaf` | `.unantifling` | Disables AntiFling protection. |
| `WalkSpeed` | `ws` | `.walkspeed <number>` | Sets your WalkSpeed. |
| `JumpPower` | `jp` | `.jumppower <number>` | Sets your JumpPower. |
| `Teleport` | `tp`, `to`, `goto` | `.teleport <player>` | Teleports you to the specified player. |
| `Rejoin` | `rj` | `.rejoin` | Rejoins the current server. |
| `ServerHop` | `shop` | `.serverhop` | Joins another public server. |
| `SetPrefix` | `sp` | `.setprefix <prefix>` | Changes the command prefix. |

## Examples

Enable Airwalk:

```text
.airwalk
```

Disable Airwalk:

```text
.unairwalk
```

Enable AntiFling:

```text
.antifling
```

Disable AntiFling:

```text
.unantifling
```

Set your WalkSpeed:

```text
.walkspeed 50
```

or

```text
.ws 50
```

Set your JumpPower:

```text
.jumppower 100
```

or

```text
.jp 100
```

Teleport to a player:

```text
.teleport Builderman
```

or

```text
.tp Builderman
.to Builderman
.goto Builderman
```

Rejoin the current server:

```text
.rejoin
```

Join another server:

```text
.serverhop
```

Change the command prefix:

```text
.setprefix !
```

Commands will then use the new prefix:

```text
!airwalk
!serverhop
```

## User Commands

SimpleCMDS supports loading your own custom commands.

Create a `.luau` file inside:

```text
SimpleCMDS/
└── UserCommands/
    └── MyCommand.luau
```

Register your command:

```lua
Cmd.Reg(Cmd.new({"hello", "hi"}, function()
    DebugNotif("Hello!")
end))
```

You can now execute:

```text
.hello
```

or

```text
.hi
```

## License

**© 2026 JustSomeGuest. All Rights Reserved.**

SimpleCMDS and all associated source code are proprietary software protected by copyright law.

You may **not**:

- Copy or redistribute this project.
- Modify or create derivative works.
- Re-upload the source code, modified or unmodified.
- Claim ownership of this project or any part of it.
- Use any portion of the source code in another project without explicit written permission from the author.
- Sell, sublicense, lease, or commercially distribute this project.

Unauthorized copying, modification, redistribution, or republication of any part of this project is strictly prohibited.

Permission to use, modify, or redistribute this project may only be granted by the copyright holder.

---

Made with ❤️ by **JustSomeGuest**.
