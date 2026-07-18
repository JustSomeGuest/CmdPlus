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

## Commands

| Command | Aliases | Description |
|---|---|---|
| `airwalk` | `aw` | Enables Airwalk. |
| `unairwalk` | `unaw` | Disables Airwalk. |
| `antifling` | `af` | Enables AntiFling protection. |
| `unantifling` | `uaf` | Disables AntiFling protection. |
| `jumppower` | `jp` | Changes your JumpPower. |
| `rejoin` | `rj` | Rejoins the current server. |
| `serverhop` | `shop` | Joins a different public server. |
| `setprefix` | `sp` | Changes the command prefix. |

## Usage

The default command prefix is `.`.

Commands can be executed like this:

    .airwalk

    .antifling

    .jumppower 100

    .rejoin

    .serverhop

## Command Aliases

Most commands have shorter aliases for convenience.

For example:

    .serverhop

can also be used as:

    .shop

And:

    .jumppower 100

can also be used as:

    .jp 100

## Changing the Prefix

You can change the command prefix using `setprefix` or its alias `sp`.

Example:

    .setprefix !

After changing the prefix, commands can be used with the new prefix:

    !airwalk

    !serverhop

The prefix must be a single character and cannot be a letter.

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

## Command Aliases

Commands can have multiple aliases.

Example:

    Cmd.Reg(Cmd.new({"serverhop", "shop"}, function()
        -- Command code
    end))

Both commands will work:

    .serverhop

    .shop

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
