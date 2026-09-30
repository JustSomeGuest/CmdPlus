Cmd.new(
    {"position", "pos"},
    "Shows your current position.",
    "position",
    function()
        local Character = Plr.Character
        local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        if not RootPart then
            Notify("Position: Could not find HumanoidRootPart.")
            return
        end

        local Position = RootPart.Position

        Notify(("Position: X: %.3f Y: %.3f Z: %.3f"):format(
            Position.X,
            Position.Y,
            Position.Z
        ))
    end
)