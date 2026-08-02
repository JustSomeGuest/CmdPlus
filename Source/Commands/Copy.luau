Cmd.new({"copyjobid"}, "Copies the current JobId.", "copyjobid", function()
	setclipboard(game.JobId)
	DebugNotif("Copied JobId.")
end)

Cmd.new({"copyplaceid"}, "Copies the current PlaceId.", "copyplaceid", function()
	setclipboard(tostring(game.PlaceId))
	DebugNotif("Copied PlaceId.")
end)

Cmd.new({"copygamelink"}, "Copies the current game link.", "copygamelink", function()
	setclipboard(("https://www.roblox.com/games/%d"):format(game.PlaceId))
	DebugNotif("Copied game link.")
end)

Cmd.new({"copyposition"}, "Copies your current position.", "copyposition", function()
	local Character = Players.LocalPlayer.Character
	local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")

	if not RootPart then
		DebugNotif("CopyPosition: Could not find HumanoidRootPart.")
		return
	end

	local Position = RootPart.Position
	setclipboard(("%.3f, %.3f, %.3f"):format(Position.X, Position.Y, Position.Z))
	DebugNotif("Copied position.")
end)