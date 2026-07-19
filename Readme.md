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

SimpleCMDS ships with a growing set of built-in commands (movement utilities, anti-exploit protections, server tools, and more), each with short aliases for faster typing. Commands are loaded automatically on startup — no need to memorize a fixed list here, since new ones get added over time.

The default prefix is `.` (change it anytime with `setprefix`, see below).

## Setting the Prefix

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