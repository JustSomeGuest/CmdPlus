Cmd.new(
    {"setprefix", "prefix"},
    "Changes the command prefix to a single non-letter character.",
    "setprefix <prefix>",
    function(Args)
        local NewPrefix = Args[2]

        if not NewPrefix then
            Notify("Usage: .setprefix <prefix>")
            return
        end

        if #NewPrefix ~= 1 then
            Notify("Prefix must be a single character")
            return
        end

        local Character = string.sub(NewPrefix, 1, 1)

        if Character:match("%a") then
            Notify("Prefix cannot be a letter")
            return
        end

        SetPrefix(Character)
        WriteFile("SimpleCMDS/Prefix.luau", Character)

        Notify("Prefix set to: " .. Character)
    end
)