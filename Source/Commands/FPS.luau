local FPS = 0

RunService.RenderStepped:Connect(function(DeltaTime)
	FPS = math.round(1 / DeltaTime)
end)

Cmd.new({"fps"}, "Shows your current FPS.", "fps", function()
	DebugNotif("FPS: " .. FPS)
end)