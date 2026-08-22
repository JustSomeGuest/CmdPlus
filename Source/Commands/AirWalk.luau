local Airwalk = {
    Active = false,
    Platform = nil,
    CharacterConn = nil,
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

    Airwalk.Platform = platform
    Airwalk.FloorHeight = rootPart.Position.Y - 3

    platform.CFrame = CFrame.new(rootPart.Position.X, Airwalk.FloorHeight, rootPart.Position.Z)

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        Airwalk.StateConn = humanoid.StateChanged:Connect(function(oldState, newState)
            if newState == Enum.HumanoidStateType.Landed then
                local root = character:FindFirstChild("HumanoidRootPart")
                if not root or not Airwalk.Platform then return end

                local rayOrigin = root.Position
                local rayDir = Vector3.new(0, -10, 0)
                local raycastParams = RaycastParams.new()
                raycastParams.FilterDescendantsInstances = {character, platform}
                raycastParams.FilterType = Enum.RaycastFilterType.Exclude

                local result = workspace:Raycast(rayOrigin, rayDir, raycastParams)
                if result then
                    Airwalk.FloorHeight = result.Position.Y
                end
            end
        end)
    end

    Airwalk.UpdateConn = RunService.Heartbeat:Connect(function()
        if not rootPart or not Airwalk.Platform then return end
        Airwalk.Platform.CFrame = CFrame.new(rootPart.Position.X, Airwalk.FloorHeight, rootPart.Position.Z)
    end)
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
    if Airwalk.Platform then
        Airwalk.Platform:Destroy()
        Airwalk.Platform = nil
    end
    Airwalk.Active = false
end

Cmd.new({"airwalk", "aw"}, "Enables airwalk.", "airwalk", function()
    if Airwalk.Active then
        DebugNotif("Airwalk: Already active")
        return
    end

    local char = Players.LocalPlayer.Character
    if not char then
        DebugNotif("AirWalk: You need a character to start airwalk")
        return
    end

    StartAirwalk(char)
    Airwalk.Active = true
    DebugNotif("Airwalk: Enabled")

    Airwalk.CharacterConn = Players.LocalPlayer.CharacterAdded:Connect(function(newChar)
        if Airwalk.Active then
            StopAirwalk()
            StartAirwalk(newChar)
            Airwalk.Active = true
        end
    end)
end)

Cmd.new({"unairwalk", "unaw"}, "Disables airwalk.", "unairwalk", function()
    if Airwalk.Active then
        StopAirwalk()
        DebugNotif("Airwalk: Disabled")
    else
        DebugNotif("Airwalk: Not active")
    end
end)