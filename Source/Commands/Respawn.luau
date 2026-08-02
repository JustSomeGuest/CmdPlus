Cmd.new({"respawn", "reset"}, "Respawns your character.", "respawn", function()
	local Character = Players.LocalPlayer.Character
	if not Character then
		DebugNotif("Respawn: You need a character to respawn.")
		return
	end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	if not Humanoid then
		DebugNotif("Respawn: Could not find Humanoid.")
		return
	end

	Humanoid.Health = 0
	DebugNotif("Respawn: Respawning character...")
end)