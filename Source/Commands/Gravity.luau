Cmd.new({"gravity", "grav"}, "Sets the workspace gravity.", "gravity <number>", function(Args)
	local Gravity = tonumber(Args[2])
	if not Gravity then
		DebugNotif("Gravity: Usage: .gravity <number>")
		return
	end

	workspace.Gravity = Gravity
	DebugNotif("Gravity: Set gravity to " .. Gravity .. ".")
end)