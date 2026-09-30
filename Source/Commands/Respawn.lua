Cmd.new(
    {"respawn", "reset"},
    "Respawns your character.",
    "respawn",
    function()
        local Character = Plr.Character

        if not Character then
            Notify("Respawn: You need a character to respawn.")
            return
        end

        local Humanoid = Character:FindFirstChildOfClass("Humanoid")

        if not Humanoid then
            Notify("Respawn: Could not find Humanoid.")
            return
        end

        Humanoid.Health = 0
        Notify("Respawn: Respawning character...")
    end
)