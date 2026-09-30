Cmd.new(
    {"walkspeed", "ws"},
    "Changes your character's walking speed.",
    "walkspeed <number>",
    function(Args)
        local Value = tonumber(Args[2])

        if not Value then
            Notify("Usage: .walkspeed <number>")
            return
        end

        local Character = Plr.Character

        if not Character then
            Notify("You need a character to use that command.")
            return
        end

        local Humanoid = Character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            Humanoid.WalkSpeed = Value
            Notify("Walkspeed set to " .. Value)
        end
    end
)