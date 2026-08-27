# CmdPlus

```lua
loadstring(game:HttpGet("https://justsomeguest.pages.dev/scripts/cmdplus"))()
```

## Features

- Lightweight
- Extensive built-in commands
- Command aliases
- Customizable command prefix
- User commands
- Easy to extend
- Movement utilities
- Player utilities
- AntiFling protection
- AirWalk
- NoClip
- WalkSpeed & JumpPower
- Shader customization
- Server rejoining
- Server hopping
- Player teleportation
- Continuously updated with new commands

## Commands

CmdPlus ships with a constantly expanding collection of built-in commands, including movement utilities, player tools, graphics customization, anti-exploit protections, server utilities, and more. Every command supports aliases where applicable, and new commands are added regularly.

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

CmdPlus supports loading your own custom commands.

Create a `.luau` file inside:

```text
CmdPlus/
└── UserCommands/
    └── MyCommand.luau
```

Register your command:

```lua
Cmd.new({"hello", "hi"}, "Sends a hello notification.", "hello", function(Args)
    DebugNotif("Hello!")
end)
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

CmdPlus and all associated source code are proprietary software protected by copyright law.

You may **not**:

- Copy or redistribute this project.
- Modify or create derivative works.
- Re-upload the source code, modified or unmodified.
- Claim ownership of this project or any part of it.
- Use any portion of the source code in another project without explicit written permission from the author.

Made with ❤️ by **JustSomeGuest**.
