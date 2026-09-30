local Camera = workspace.CurrentCamera
local PreviousSubject

Cmd.new(
    {"spectate", "view"},
    "Spectates a player.",
    "spectate <player>",
    function(Args)
        local TargetName = Args[2]

        if not TargetName then
            Notify("Spectate: Usage: .spectate <player>")
            return
        end

        local Matches = FindPlr(TargetName)

        if #Matches == 0 then
            Notify("Spectate: Player not found.")
            return
        end

        if #Matches > 1 then
            Notify("Spectate: Multiple players matched.")
            return
        end

        local TargetPlayer = Matches[1]
        local Character = TargetPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

        if not Humanoid then
            Notify("Spectate: Target has no Humanoid.")
            return
        end

        PreviousSubject = Camera.CameraSubject
        Camera.CameraSubject = Humanoid

        Notify("Spectate: Now viewing " .. TargetPlayer.Name .. ".")
    end
)

Cmd.new(
    {"unspectate", "unview"},
    "Stops spectating.",
    "unspectate",
    function()
        local Character = Plr.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

        if not Humanoid then
            Notify("Unspectate: Could not find your Humanoid.")
            return
        end

        Camera.CameraSubject = Humanoid
        PreviousSubject = nil

        Notify("Unspectate: Returned to yourself.")
    end
)