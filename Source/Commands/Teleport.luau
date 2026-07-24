local function FindPlayers(searchTerm)
    local matches = {}
    local searchLower = searchTerm:lower()
    
    for _, player in ipairs(Players:GetPlayers()) do
        local nameLower = player.Name:lower()
        local displayLower = player.DisplayName:lower()
        
        if nameLower == searchLower or displayLower == searchLower then
            table.insert(matches, player)
        elseif nameLower:match(searchLower) or displayLower:match(searchLower) then
            table.insert(matches, player)
        end
    end
    
    return matches
end

Cmd.Reg(Cmd.new({"teleport", "tp", "to", "goto"}, "Teleports you to another player. Accepts usernames, display names, and partial names.", "teleport <player>", function(Args)
    local targetName = Args[2]
    if not targetName then
        DebugNotif("Usage: .teleport <player>")
        return
    end
    
    local character = Players.LocalPlayer.Character
    if not character then
        DebugNotif("TP: You need a character to teleport.")
        return
    end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        DebugNotif("TP: Could not find HumanoidRootPart.")
        return
    end
    
    local matches = FindPlayers(targetName)
    
    if #matches == 0 then
        DebugNotif("TP: Player not found: " .. targetName)
        return
    end
    
    if #matches > 1 then
        local playerNames = {}
        for i, player in ipairs(matches) do
            table.insert(playerNames, player.Name .. " (" .. player.DisplayName .. ")")
        end
        DebugNotif("TP: Multiple players found: " .. table.concat(playerNames, ", "))
        return
    end
    
    local targetPlayer = matches[1]
    
    if targetPlayer == Players.LocalPlayer then
        DebugNotif("TP: You can't teleport to yourself!")
        return
    end
    
    local targetChar = targetPlayer.Character
    if not targetChar then
        DebugNotif("TP: Target player doesn't have a character.")
        return
    end
    
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot then
        DebugNotif("TP: Target player doesn't have a HumanoidRootPart.")
        return
    end
    
    rootPart.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
    DebugNotif("TP: Teleported to " .. targetPlayer.Name .. " (" .. targetPlayer.DisplayName .. ")")
end))