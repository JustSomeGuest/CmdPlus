Cmd.new({"walkspeed", "ws"}, "Changes your character's walking speed.", "walkspeed <number>", function(Args)
    local value = tonumber(Args[2])
    if not value then
        DebugNotif("Usage: .walkspeed <number>")
        return
    end

    local char = Players.LocalPlayer.Character
    if not char then
        DebugNotif("You need a character to use that command.")
        return
    end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = value
        DebugNotif("Walkspeed set to " .. value)
    end
end)