Cmd.new({"ping"}, "Shows your current ping.", "ping", function()
	local Ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
	DebugNotif("Ping: " .. Ping .. " ms")
end)