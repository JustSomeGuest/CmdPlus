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

	local BodyGyro = Instance.new("BodyAngularVelocity")
	BodyGyro.MaxTorque = Vector3.new(0, 400000, 0)
	BodyGyro.AngularVelocity = Vector3.new(0, math.rad(Speed), 0)
	BodyGyro.Parent = RootPart

	SpinConnection = BodyGyro

	DebugNotif("Spin: Now spinning at " .. Speed .. ".")
end)

Cmd.new({"unspin"}, "Stops spinning.", "unspin", function()
	if SpinConnection then
		SpinConnection:Destroy()
		SpinConnection = nil
		DebugNotif("Spin: Stopped spinning.")
	else
		DebugNotif("Spin: You're not spinning.")
	end
end)