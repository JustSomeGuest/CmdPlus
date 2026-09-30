Cmd.new(
    {"time"},
    "Shows the current local time.",
    "time",
    function()
        Notify("Time: " .. os.date("%H:%M:%S"))
    end
)