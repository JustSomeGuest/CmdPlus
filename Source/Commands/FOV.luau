Cmd.new({"fov", "fieldofview"}, "Sets your camera's field of view.", "fov <number>", function(Args)
	local FOV = tonumber(Args[2])
	if not FOV then
		DebugNotif("FOV: Usage: .fov <number>")
		return
	end

	FOV = math.clamp(FOV, 1, 120)
	workspace.CurrentCamera.FieldOfView = FOV
	DebugNotif("FOV: Set field of view to " .. FOV .. ".")
end)