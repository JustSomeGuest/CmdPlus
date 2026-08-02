local SpinConnection

Cmd.new({"spin"}, "Spins your character.", "spin <speed>", function(Args)
	local Speed = tonumber(Args[2])
	if not Speed then
		DebugNotif("Spin: Usage: .spin <speed>")
		return
	end

	local Character = Players.LocalPlayer.Character
	local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
	if not RootPart then
		DebugNotif("Spin: Could not find HumanoidRootPart.")
		return
	end

	if SpinConnection then
		SpinConnection:Disconnect()
	end

	SpinConnection = RunService.RenderStepped:Connect(function(DeltaTime)
		RootPart.CFrame *= CFrame.Angles(0, math.rad(Speed * DeltaTime * 60), 0)
	end)

	DebugNotif("Spin: Now spinning at " .. Speed .. ".")
end)

Cmd.new({"unspin"}, "Stops spinning.", "unspin", function()
	if SpinConnection then
		SpinConnection:Disconnect()
		SpinConnection = nil
		DebugNotif("Spin: Stopped spinning.")
	else
		DebugNotif("Spin: You're not spinning.")
	end
end)