local LocalPlayer = Players.LocalPlayer

local function GetRootPart()
	local Character = LocalPlayer.Character
	if not Character then
		return nil, "You need a character."
	end

	local RootPart = Character:FindFirstChild("HumanoidRootPart")
	if not RootPart then
		return nil, "Could not find HumanoidRootPart."
	end

	return RootPart
end

Cmd.new({"freeze"}, "Freezes your character.", "freeze", function()
	local RootPart, Error = GetRootPart()
	if not RootPart then
		DebugNotif("Freeze: " .. Error)
		return
	end

	if RootPart.Anchored then
		DebugNotif("Freeze: You're already frozen.")
		return
	end

	RootPart.Anchored = true
	DebugNotif("Freeze: Character frozen.")
end)

Cmd.new({"unfreeze"}, "Unfreezes your character.", "unfreeze", function()
	local RootPart, Error = GetRootPart()
	if not RootPart then
		DebugNotif("Unfreeze: " .. Error)
		return
	end

	if not RootPart.Anchored then
		DebugNotif("Unfreeze: You're already unfrozen.")
		return
	end

	RootPart.Anchored = false
	DebugNotif("Unfreeze: Character unfrozen.")
end)