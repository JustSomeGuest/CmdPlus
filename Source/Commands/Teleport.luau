Cmd.new(
    {"teleport", "tp", "to", "goto"},
    "Teleports you to another player. Accepts usernames, display names, and partial names.",
    "teleport <player>",
    function(Args)
        local TargetName = Args[2]

        if not TargetName then
            Notify("Usage: .teleport <player>")
            return
        end

        local Character = Plr.Character

        if not Character then
            Notify("TP: You need a character to teleport.")
            return
        end

        local RootPart = Character:FindFirstChild("HumanoidRootPart")

        if not RootPart then
            Notify("TP: Could not find HumanoidRootPart.")
            return
        end

        local Matches = FindPlr(TargetName)

        if #Matches == 0 then
            Notify("TP: Player not found: " .. TargetName)
            return
        end

        if #Matches > 1 then
            local PlayerNames = {}

            for _, Player in ipairs(Matches) do
                table.insert(
                    PlayerNames,
                    Player.Name .. " (" .. Player.DisplayName .. ")"
                )
            end

            Notify(
                "TP: Multiple players found: "
                .. table.concat(PlayerNames, ", ")
            )

            return
        end

        local TargetPlayer = Matches[1]

        if TargetPlayer == Plr then
            Notify("TP: You can't teleport to yourself!")
            return
        end

        local TargetCharacter = TargetPlayer.Character

        if not TargetCharacter then
            Notify("TP: Target player doesn't have a character.")
            return
        end

        local TargetRoot = TargetCharacter:FindFirstChild("HumanoidRootPart")

        if not TargetRoot then
            Notify("TP: Target player doesn't have a HumanoidRootPart.")
            return
        end

        RootPart.CFrame = TargetRoot.CFrame + Vector3.new(0, 3, 0)

        Notify(
            "TP: Teleported to "
            .. TargetPlayer.Name
            .. " ("
            .. TargetPlayer.DisplayName
            .. ")"
        )
    end
)