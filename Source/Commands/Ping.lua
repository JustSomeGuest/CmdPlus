Cmd.new(
    {"ping"},
    "Shows your current ping.",
    "ping",
    function()
        local Stats = GetService("Stats")
        local Ping = math.floor(
            Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        )

        Notify("Ping: " .. Ping .. " ms")
    end
)