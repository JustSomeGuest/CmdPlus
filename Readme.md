# SimpleCMDS

A simple and lightweight command system for Roblox.

SimpleCMDS provides built-in commands, command aliases, customizable prefixes, and support for adding your own user commands.

## Features

- Simple command system
- Built-in commands
- Command aliases
- Customizable command prefix
- User command support
- Lightweight and easy to extend
- Player utilities
- Anti-fling protection
- Server rejoining
- Server hopping
- Player teleportation

## Commands

| Command | Aliases | Usage | Description |
|---|---|---|---|
| `airwalk` | `aw` | `.airwalk` | Enables Airwalk. |
| `unairwalk` | `unaw` | `.unairwalk` | Disables Airwalk. |
| `antifling` | `af` | `.antifling` | Enables AntiFling protection. |
| `unantifling` | `uaf` | `.unantifling` | Disables AntiFling protection. |
| `jumppower <number>` | `jp` | `.jumppower <number>` | Changes your JumpPower. |
| `walkspeed <number>` | `ws` | `.walkspeed <number>` | Changes your WalkSpeed. |
| `teleport <player>` | `tp`, `to`, `goto` | `.teleport <player>` | Teleports you to the specified player. |
| `rejoin` | `rj` | `.rejoin` | Rejoins the current server. |
| `serverhop` | `shop` | `.serverhop` | Joins a different public server. |
| `setprefix <prefix>` | `sp` | `.setprefix <prefix>` | Changes the command prefix. |

## Usage

The default command prefix is `.`.

Commands can be executed like this:

    .airwalk

    .antifling

    .jumppower 100

    .walkspeed 50

    .teleport PlayerName

    .rejoin

    .serverhop

## Command Arguments

Some commands require additional arguments.

### JumpPower

Set your JumpPower using:

    .jumppower <number>

Example:

    .jumppower 100

Or use the `jp` alias:

    .jp 100

### WalkSpeed

Set your WalkSpeed using:

    .walkspeed <number>

Example:

    .walkspeed 50

Or use the `ws` alias:

    .ws 50

### Teleport

Teleport to another player using:

    .teleport <player>

Example:

    .teleport PlayerName

You can also use any of the following aliases:

    .tp PlayerName

    .to PlayerName

    .goto PlayerName

### SetPrefix

Change the command prefix using:

    .setprefix <prefix>

Example:

    .setprefix !

After changing the prefix, commands can be used with the new prefix:

    !airwalk

    !serverhop

The prefix must be a single character and cannot be a letter.

## Command Aliases

Commands can have multiple aliases.

Example:

    Cmd.Reg(Cmd.new({"serverhop", "shop"}, function()
        -- Command code
    end))

Both commands will work:

    .serverhop

    .shop

## User Commands

SimpleCMDS supports custom user commands.

User commands can be created as `.luau` files inside the SimpleCMDS user commands directory.

Example file structure:

    SimpleCMDS/
    └── UserCommands/
        └── MyCommand.luau

A custom command can be registered using `Cmd.Reg` and `Cmd.new`:

    Cmd.Reg(Cmd.new({"hello", "hi"}, function()
        DebugNotif("Hello!")
    end))

This command can then be executed using either:

    .hello

or:

    .hi

## License

©️ 2026 SimpleCMDS. All Rights Reserved.

This project and its source code are proprietary and copyright protected.

You may **not**:

- Copy, reproduce, or redistribute this project or any part of its source code.
- Modify, alter, or create derivative works from this project.
- Re-upload or publish the source code, modified or unmodified.
- Claim ownership or authorship of this project.
- Use this project or its source code in another project without explicit written permission from the author.
- Sell, sublicense, or commercially distribute this project or any part of it.

Any unauthorized copying, modification, redistribution, or republishing of this project is prohibited.

Permission to use, modify, or redistribute this project may only be granted by the copyright holder.

All rights reserved.
