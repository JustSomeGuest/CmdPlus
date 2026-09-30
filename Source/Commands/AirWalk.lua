local RunService = GetService("RunService")

local Airwalk = {
    Active = false,
    Platform = nil,
    CharacterConn = nil,
    StateConn = nil,
    UpdateConn = nil,
    FloorHeight = 0
}

local function StartAirwalk(Character)
    if Airwalk.Platform then
        Airwalk.Platform:Destroy()
        Airwalk.Platform = nil
    end

    if Airwalk.StateConn then
        Airwalk.StateConn:Disconnect()
        Airwalk.StateConn = nil
    end

    if Airwalk.UpdateConn then
        Airwalk.UpdateConn:Disconnect()
        Airwalk.UpdateConn = nil
    end

    local RootPart = Character:WaitForChild("HumanoidRootPart", 5)

    if not RootPart then
        return
    end

    local Platform = Instance.new("Part")
    Platform.Name = UID(64)
    Platform.Size = Vector3.new(20, 1, 20)
    Platform.Anchored = true
    Platform.CanCollide = true
    Platform.Transparency = 1
    Platform.Parent = workspace

    Airwalk.Platform = Platform
    Airwalk.FloorHeight = RootPart.Position.Y - 3

    Platform.CFrame = CFrame.new(
        RootPart.Position.X,
        Airwalk.FloorHeight,
        RootPart.Position.Z
    )

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

    if Humanoid then
        Airwalk.StateConn = Humanoid.StateChanged:Connect(function(OldState, NewState)
            if NewState ~= Enum.HumanoidStateType.Landed then
                return
            end

            local Root = Character:FindFirstChild("HumanoidRootPart")

            if not Root or not Airwalk.Platform then
                return
            end

            local RayOrigin = Root.Position
            local RayDirection = Vector3.new(0, -10, 0)

            local RaycastParams = RaycastParams.new()
            RaycastParams.FilterDescendantsInstances = {
                Character,
                Platform
            }
            RaycastParams.FilterType = Enum.RaycastFilterType.Exclude

            local Result = workspace:Raycast(
                RayOrigin,
                RayDirection,
                RaycastParams
            )

            if Result then
                Airwalk.FloorHeight = Result.Position.Y
            end
        end)
    end

    Airwalk.UpdateConn = RunService.Heartbeat:Connect(function()
        if not RootPart or not Airwalk.Platform then
            return
        end

        Airwalk.Platform.CFrame = CFrame.new(
            RootPart.Position.X,
            Airwalk.FloorHeight,
            RootPart.Position.Z
        )
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

Cmd.new(
    {"airwalk", "aw"},
    "Enables airwalk.",
    "airwalk",
    function()
        if Airwalk.Active then
            Notify("Airwalk: Already active")
            return
        end

        local Character = Plr.Character

        if not Character then
            Notify("Airwalk: You need a character to start airwalk")
            return
        end

        StartAirwalk(Character)

        Airwalk.Active = true
        Notify("Airwalk: Enabled")

        Airwalk.CharacterConn = Plr.CharacterAdded:Connect(function(NewCharacter)
            if not Airwalk.Active then
                return
            end

            StopAirwalk()
            StartAirwalk(NewCharacter)
            Airwalk.Active = true

            Airwalk.CharacterConn = Plr.CharacterAdded:Connect(function(Character)
                if Airwalk.Active then
                    StopAirwalk()
                    StartAirwalk(Character)
                    Airwalk.Active = true
                end
            end)
        end)
    end
)

Cmd.new(
    {"unairwalk", "unaw"},
    "Disables airwalk.",
    "unairwalk",
    function()
        if Airwalk.Active then
            StopAirwalk()
            Notify("Airwalk: Disabled")
        else
            Notify("Airwalk: Not active")
        end
    end
)