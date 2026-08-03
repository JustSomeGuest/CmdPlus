local FPS = 0

Cmd.new({"fps"}, "Shows your current FPS.", "fps", function()
	local Start = tick()

	task.wait(0.1)

	FPS = math.round(0.1 / (tick() - Start))
	DebugNotif("FPS: " .. FPS)
end)