Cmd.new(
    {"gravity", "grav"},
    "Sets the workspace gravity.",
    "gravity <number>",
    function(Args)
        local Gravity = tonumber(Args[2])

        if not Gravity then
            Notify("Gravity: Usage: .gravity <number>")
            return
        end

        workspace.Gravity = Gravity
        Notify("Gravity: Set gravity to " .. Gravity .. ".")
    end
)