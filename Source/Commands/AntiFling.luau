local AntiflingConn

local function Antifling(Notify)
    if AntiflingConn then
        AntiflingConn:Disconnect()
    end

    AntiflingConn = RunService.Heartbeat:Connect(function()
        local Character = Players.LocalPlayer.Character
        local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        if RootPart then
            if RootPart.AssemblyLinearVelocity.Magnitude > 250 then
                RootPart.AssemblyLinearVelocity = Vector3.zero
            end

            if RootPart.AssemblyAngularVelocity.Magnitude > 250 then
                RootPart.AssemblyAngularVelocity = Vector3.zero
            end
        end
    end)

    if Notify then
        DebugNotif("AntiFling: Enabled")
    end
end

local function Unantifling()
    if AntiflingConn then
        AntiflingConn:Disconnect()
        AntiflingConn = nil
    end

    DebugNotif("AntiFling: Disabled")
end

Cmd.new({"antifling", "af"}, "Prevents your character from being flung.", "antifling", function()
    Antifling(true)
end)

Cmd.new({"unantifling", "uaf"}, "Disables anti-fling.", "unantifling", function()
    Unantifling()
end)