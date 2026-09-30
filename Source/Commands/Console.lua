local StarterGui = GetService("StarterGui")

Cmd.new(
    {"console"},
    "Opens the Roblox developer console.",
    "console",
    function()
        StarterGui:SetCore("DevConsoleVisible", true)
        Notify("Console: Opened developer console.")
    end
)

Cmd.new(
    {"clearconsole", "cls"},
    "Clears the executor console.",
    "clearconsole",
    function()
        if rconsoleclear then
            rconsoleclear()
        elseif consoleclear then
            consoleclear()
        else
            for _ = 1, 500 do
                print()
            end
        end

        Notify("Console: Cleared.")
    end
)