local Camera = workspace.CurrentCamera
local PreviousSubject

Cmd.new({"spectate", "view"}, "Spectates a player.", "spectate <player>", function(Args)
	local TargetName = Args[2]
	if not TargetName then
		DebugNotif("Spectate: Usage: .spectate <player>")
		return
	end

	local Matches = FindPlayers(TargetName)

	if #Matches == 0 then
		DebugNotif("Spectate: Player not found.")
		return
	end

	if #Matches > 1 then
		DebugNotif("Spectate: Multiple players matched.")
		return
	end

	local Character = Matches[1].Character
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

	if not Humanoid then
		DebugNotif("Spectate: Target has no Humanoid.")
		return
	end

	PreviousSubject = Camera.CameraSubject
	Camera.CameraSubject = Humanoid

	DebugNotif("Spectate: Now viewing " .. Matches[1].Name .. ".")
end)

Cmd.new({"unspectate", "unview"}, "Stops spectating.", "unspectate", function()
	local Character = Players.LocalPlayer.Character
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

	if not Humanoid then
		DebugNotif("Unspectate: Could not find your Humanoid.")
		return
	end

	Camera.CameraSubject = Humanoid
	PreviousSubject = nil

	DebugNotif("Unspectate: Returned to yourself.")
end)