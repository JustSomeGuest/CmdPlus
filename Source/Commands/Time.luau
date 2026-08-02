Cmd.new({"time"}, "Shows the current local time.", "time", function()
	DebugNotif("Time: " .. os.date("%H:%M:%S"))
end)