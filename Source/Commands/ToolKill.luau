local function ToolKill(targetPlayer)
    if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character.PrimaryPart then
        return false
    end
    
    local LocalPlayer = game.Players.LocalPlayer
    if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then
        return false
    end
    
    local originalCFrame = LocalPlayer.Character.PrimaryPart.CFrame
    local character = LocalPlayer.Character
    character.Archivable = true
    local clone = character:Clone()
    LocalPlayer.Character = clone
    task.wait(0.5)
    LocalPlayer.Character = character
    task.wait(0.2)
    
    if not LocalPlayer.Character or not targetPlayer.Character or not targetPlayer.Character.PrimaryPart then
        return false
    end
    
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid:Destroy()
    end
    
    local newHumanoid = Instance.new("Humanoid")
    newHumanoid.Parent = LocalPlayer.Character
    
    local tool = nil
    if LocalPlayer.Character:FindFirstChildOfClass("Tool") then
        tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    elseif LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChildOfClass("Tool") then
        tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
    end
    
    if not tool then
        return false
    end
    
    tool.Parent = LocalPlayer.Backpack
    targetPlayer.Character.HumanoidRootPart.Anchored = true
    
    local rightArm = LocalPlayer.Character:FindFirstChild("Right Arm")
    if not rightArm then
        targetPlayer.Character.HumanoidRootPart.Anchored = false
        return false
    end
    
    local armCFrame = rightArm.CFrame * CFrame.new(0, -1, 0, 1, 0, 0, 0, 0, 1, 0, -1, 0)
    tool.Grip = armCFrame:ToObjectSpace(targetPlayer.Character.PrimaryPart.CFrame):Inverse()
    tool.Parent = LocalPlayer.Character
    
    repeat
        task.wait()
    until not tool or (tool and (tool.Parent == workspace or tool.Parent == targetPlayer.Character))
    
    targetPlayer.Character.HumanoidRootPart.Anchored = false
    task.wait(0.1)
    newHumanoid.Health = 0
    LocalPlayer.Character = nil
    
    spawn(function()
        LocalPlayer.CharacterAdded:Wait()
        targetPlayer.Character.HumanoidRootPart.Anchored = false
        if targetPlayer.Character.Humanoid.Health <= 15 then
            task.wait(0.4)
            if LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
                LocalPlayer.Character:SetPrimaryPartCFrame(originalCFrame)
            end
        end
    end)
    
    return true
end

Cmd.Reg(Cmd.new({"toolkill", "tkill"}, function(Args)
    if not Args[1] then
        DebugNotif("Usage: toolkill <player>")
        return
    end
    
    local input = Args[1]:lower()
    local matched = {}
    
    for _, player in pairs(game.Players:GetPlayers()) do
        local nameLower = player.Name:lower()
        local displayLower = player.DisplayName:lower()
        
        if input == nameLower or input == displayLower then
            matched = {player}
            break
        elseif nameLower:find(input, 1, true) or displayLower:find(input, 1, true) then
            table.insert(matched, player)
        end
    end
    
    if #matched == 0 then
        DebugNotif("No player found matching: " .. Args[1])
        return
    elseif #matched > 1 then
        local names = {}
        for i, player in pairs(matched) do
            table.insert(names, player.DisplayName .. " (@" .. player.Name .. ")")
        end
        DebugNotif("Multiple players found: " .. table.concat(names, ", "))
        return
    end
    
    local target = matched[1]
    local success = ToolKill(target)
    
    if success then
        DebugNotif("Used toolkill on " .. target.DisplayName .. " (@" .. target.Name .. ")")
    else
        DebugNotif("Failed to toolkill " .. target.DisplayName .. " (@" .. target.Name .. ")")
    end
end))