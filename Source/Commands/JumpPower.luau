Cmd.new({"jumppower", "jp"}, "Changes your character's jump power.", "jumppower <number>", function(Args)
    local value = tonumber(Args[2])
    if not value then
        DebugNotif("Usage: .jumppower <number>")
        return
    end

    local char = Players.LocalPlayer.Character
    if not char then
        DebugNotif("You need a character to use that command.")
        return
    end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.JumpPower = value
        DebugNotif("Jumppower set to " .. value)
    end
end)