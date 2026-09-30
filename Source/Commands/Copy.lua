local SetClipboard = setclipboard or toclipboard or function() end

Cmd.new(
    {"copyjobid"},
    "Copies the current JobId.",
    "copyjobid",
    function()
        SetClipboard(game.JobId)
        Notify("Copied JobId.")
    end
)

Cmd.new(
    {"copyplaceid"},
    "Copies the current PlaceId.",
    "copyplaceid",
    function()
        SetClipboard(tostring(game.PlaceId))
        Notify("Copied PlaceId.")
    end
)

Cmd.new(
    {"copygamelink"},
    "Copies the current game link.",
    "copygamelink",
    function()
        SetClipboard(("https://www.roblox.com/games/%d"):format(game.PlaceId))
        Notify("Copied game link.")
    end
)

Cmd.new(
    {"copyposition"},
    "Copies your current position.",
    "copyposition",
    function()
        local Character = Plr.Character
        local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        if not RootPart then
            Notify("CopyPosition: Could not find HumanoidRootPart.")
            return
        end

        local Position = RootPart.Position

        SetClipboard(
            ("%.3f, %.3f, %.3f"):format(
                Position.X,
                Position.Y,
                Position.Z
            )
        )

        Notify("Copied position.")
    end
)