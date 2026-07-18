Cmd.Reg(Cmd.new({"setprefix", "sp"}, function(Args)
    local newPrefix = Args[2]
    if not newPrefix then
        DebugNotif("Usage: .setprefix <prefix>")
        return
    end
    
    if #newPrefix ~= 1 then
        DebugNotif("Prefix must be a single character")
        return
    end
    
    local char = string.sub(newPrefix, 1, 1)
    if char:match("%a") then
        DebugNotif("Prefix cannot be a letter")
        return
    end
    
    Prefix = char
    DebugNotif("Prefix set to: " .. Prefix)
end))
