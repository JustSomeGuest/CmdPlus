Cmd.new({"fps"}, "Shows your current FPS.", "fps", function()
	local Frames = 0
	local Start = tick()

	local Connection = RunService.RenderStepped:Connect(function()
		Frames += 1
	end)

	task.wait(1)

	Connection:Disconnect()

	local FPS = math.round(Frames / (tick() - Start))
	DebugNotif("FPS: " .. FPS)
end)