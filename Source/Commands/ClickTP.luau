local Mouse = Players.LocalPlayer:GetMouse()

local ClickTPConnection

Cmd.new({"clicktp", "tptool"}, "Teleports where you click.", "clicktp", function()
	if ClickTPConnection then
		DebugNotif("ClickTP: Already enabled.")
		return
	end

	ClickTPConnection = Mouse.Button1Down:Connect(function()
		local Character = Players.LocalPlayer.Character
		local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
		if RootPart then
			RootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
		end
	end)

	DebugNotif("ClickTP: Enabled.")
end)

Cmd.new({"unclicktp", "untptool"}, "Disables ClickTP.", "unclicktp", function()
	if ClickTPConnection then
		ClickTPConnection:Disconnect()
		ClickTPConnection = nil
		DebugNotif("ClickTP: Disabled.")
	else
		DebugNotif("ClickTP: Already disabled.")
	end
end)