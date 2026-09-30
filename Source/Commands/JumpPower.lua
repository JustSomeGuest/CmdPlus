Cmd.new(
    {"jumppower", "jp"},
    "Changes your character's jump power.",
    "jumppower <number>",
    function(Args)
        local Value = tonumber(Args[2])

        if not Value then
            Notify("Usage: " .. Prefix .. "jumppower <number>")
            return
        end

        local Character = Plr.Character

        if not Character then
            Notify("You need a character to use that command.")
            return
        end

        local Humanoid = Character:FindFirstChildOfClass("Humanoid")

        if not Humanoid then
            Notify("Jumppower: Humanoid not found")
            return
        end

        Humanoid.JumpPower = Value

        Notify("Jumppower set to " .. Value)
    end
)