local Airwalk = {
    Active = false,
    Platform = nil,
    CharacterConn = nil,
    HeartbeatConn = nil,
    StateConn = nil,
    FloorHeight = 0
}

local function StartAirwalk(character)
    if Airwalk.Platform then
        Airwalk.Platform:Destroy()
    end

    local rootPart = character:WaitForChild("HumanoidRootPart", 5)
    if not rootPart then return end

    local platform = Instance.new("Part")
    platform.Name = "AirwalkPlatform"
    platform.Size = Vector3.new(20, 1, 20)
    platform.Anchored = true
    platform.CanCollide = true
    platform.Transparency = 1
    platform.Parent = Workspace

    Airwalk.Platform = platform
    Airwalk.FloorHeight = rootPart.Position.Y - 3

    Airwalk.HeartbeatConn = RunService.Heartbeat:Connect(function()
        local char = Players.LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        platform.CFrame = CFrame.new(root.Position.X, Airwalk.FloorHeight, root.Position.Z)
    end)

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        Airwalk.StateConn = humanoid.StateChanged:Connect(function(oldState, newState)
            if newState == Enum.HumanoidStateType.Landed then
                local char = Players.LocalPlayer.Character
                if not char then return end
                local root = char:FindFirstChild("HumanoidRootPart")
                if not root then return end
                local ray = Ray.new(root.Position, Vector3.new(0, -10, 0))
                local hit = Workspace:FindPartOnRayWithIgnoreList(ray, {char, platform})
                if hit and hit ~= platform then
                    Airwalk.FloorHeight = hit.Position.Y + hit.Size.Y / 2
                end
            end
        end)
    end
end

local function StopAirwalk()
    if Airwalk.HeartbeatConn then
        Airwalk.HeartbeatConn:Disconnect()
        Airwalk.HeartbeatConn = nil
    end
    if Airwalk.StateConn then
        Airwalk.StateConn:Disconnect()
        Airwalk.StateConn = nil
    end
    if Airwalk.CharacterConn then
        Airwalk.CharacterConn:Disconnect()
        Airwalk.CharacterConn = nil
    end
    if Airwalk.Platform then
        Airwalk.Platform:Destroy()
        Airwalk.Platform = nil
    end
    Airwalk.Active = false
end

Cmd.Reg(Cmd.new({"airwalk", "aw"}, function()
    if Airwalk.Active then
        StopAirwalk()
        DebugNotif("Airwalk disabled")
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
end))

Cmd.Reg(Cmd.new({"unairwalk", "unaw"}, function()
    if Airwalk.Active then
        StopAirwalk()
        DebugNotif("Airwalk disabled")
    else
        DebugNotif("Airwalk is not active")
    end
end))
