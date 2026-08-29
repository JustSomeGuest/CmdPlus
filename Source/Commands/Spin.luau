local SpinConnection

Cmd.new(
    {"spin"},
    "Spins your character.",
    "spin <speed>",
    function(Args)
        local Speed = tonumber(Args[2])

        if not Speed then
            Notify("Spin: Usage: .spin <speed>")
            return
        end

        if SpinConnection then
            Notify("Spin: Already active")
            return
        end

        local Character = Plr.Character
        local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        if not RootPart then
            Notify("Spin: Could not find HumanoidRootPart.")
            return
        end

        local BodyAngularVelocity = Instance.new("BodyAngularVelocity")
        BodyAngularVelocity.MaxTorque = Vector3.new(0, 400000, 0)
        BodyAngularVelocity.AngularVelocity = Vector3.new(0, math.rad(Speed), 0)
        BodyAngularVelocity.Parent = RootPart

        SpinConnection = BodyAngularVelocity

        Notify("Spin: Now spinning at " .. Speed .. ".")
    end
)

Cmd.new(
    {"unspin"},
    "Stops spinning.",
    "unspin",
    function()
        if not SpinConnection then
            Notify("Spin: Not active")
            return
        end

        SpinConnection:Destroy()
        SpinConnection = nil

        Notify("Spin: Stopped spinning.")
    end
)