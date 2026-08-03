local Airwalk = {
    Active = false,
    Platform = nil,
    CharacterConn = nil,
    AlignPos = nil,
    Attachment0 = nil,
    Attachment1 = nil,
    StateConn = nil,
    UpdateConn = nil,
    FloorHeight = 0
}

local function StartAirwalk(character)
    if Airwalk.Platform then
        Airwalk.Platform:Destroy()
    end

    local rootPart = character:WaitForChild("HumanoidRootPart", 5)
    if not rootPart then return end

    local platform = Instance.new("Part")
    platform.Name = UID(64)
    platform.Size = Vector3.new(20, 1, 20)
    platform.Anchored = true
    platform.CanCollide = true
    platform.Transparency = 1
    platform.Parent = workspace

    local att0 = Instance.new("Attachment")
    att0.Parent = platform

    local att1 = Instance.new("Attachment")
    att1.Parent = rootPart

    local alignPos = Instance.new("AlignPosition")
    alignPos.MaxForce = 100000
    alignPos.Responsiveness = 200
    alignPos.RigidityEnabled = true
    alignPos.Attachment0 = att0
    alignPos.Parent = platform

    Airwalk.Platform = platform
    Airwalk.AlignPos = alignPos
    Airwalk.Attachment0 = att0
    Airwalk.Attachment1 = att1
    Airwalk.FloorHeight = rootPart.Position.Y - 3

    platform.CFrame = CFrame.new(rootPart.Position.X, Airwalk.FloorHeight, rootPart.Position.Z)
    att1.WorldCFrame = CFrame.new(rootPart.Position.X, Airwalk.FloorHeight, rootPart.Position.Z)

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        Airwalk.StateConn = humanoid.StateChanged:Connect(function(oldState, newState)
            if newState == Enum.HumanoidStateType.Landed then
                local char = Players.LocalPlayer.Character
                if not char then return end
                local root = char:FindFirstChild("HumanoidRootPart")
                if not root then return end
                local ray = Ray.new(root.Position, Vector3.new(0, -10, 0))
                local hit = workspace:FindPartOnRayWithIgnoreList(ray, {char, platform})
                if hit and hit ~= platform then
                    Airwalk.FloorHeight = hit.Position.Y + hit.Size.Y / 2
                    if Airwalk.Attachment1 then
                        Airwalk.Attachment1.WorldCFrame = CFrame.new(root.Position.X, Airwalk.FloorHeight, root.Position.Z)
                    end
                end
            end
        end)

        Airwalk.UpdateConn = RunService.Heartbeat:Connect(function()
            if Airwalk.Attachment1 and rootPart then
                Airwalk.Attachment1.WorldCFrame = CFrame.new(rootPart.Position.X, Airwalk.FloorHeight, rootPart.Position.Z)
            end
        end)
    end
end

local function StopAirwalk()
    if Airwalk.UpdateConn then
        Airwalk.UpdateConn:Disconnect()
        Airwalk.UpdateConn = nil
    end
    if Airwalk.StateConn then
        Airwalk.StateConn:Disconnect()
        Airwalk.StateConn = nil
    end
    if Airwalk.CharacterConn then
        Airwalk.CharacterConn:Disconnect()
        Airwalk.CharacterConn = nil
    end
    if Airwalk.AlignPos then
        Airwalk.AlignPos:Destroy()
        Airwalk.AlignPos = nil
    end
    if Airwalk.Attachment0 then
        Airwalk.Attachment0:Destroy()
        Airwalk.Attachment0 = nil
    end
    if Airwalk.Attachment1 then
        Airwalk.Attachment1:Destroy()
        Airwalk.Attachment1 = nil
    end
    if Airwalk.Platform then
        Airwalk.Platform:Destroy()
        Airwalk.Platform = nil
    end
    Airwalk.Active = false
end

Cmd.new({"airwalk", "aw"}, "Enables airwalk.", "airwalk", function()
    if Airwalk.Active then
        DebugNotif("Airwalk is already active")
    else
        local char = Players.LocalPlayer.Character
        if not char then
            DebugNotif("You need a character to start airwalk.")
            return
        end

        StartAirwalk(char)
        Airwalk.Active = true
        DebugNotif("Airwalk enabled")

        Airwalk.CharacterConn = Players.LocalPlayer.CharacterAdded:Connect(function(newChar)
            if Airwalk.Active then
                StopAirwalk()
                StartAirwalk(newChar)
                Airwalk.Active = true
            end
        end)
    end
end)

Cmd.new({"unairwalk", "unaw"}, "Disables airwalk.", "unairwalk", function()
    if Airwalk.Active then
        StopAirwalk()
        DebugNotif("Airwalk disabled")
    else
        DebugNotif("Airwalk is not active")
    end
end)