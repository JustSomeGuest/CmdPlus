local AntiEquip = {
    Active = false,
    CharacterConn = nil,
    ToolConn = nil
}

local function HookAntiEquip(Character)
    if AntiEquip.ToolConn then
        AntiEquip.ToolConn:Disconnect()
        AntiEquip.ToolConn = nil
    end

    AntiEquip.ToolConn = Character.ChildAdded:Connect(function(Child)
        if not AntiEquip.Active or not Child:IsA("Tool") then
            return
        end

        local Backpack = Plr:FindFirstChild("Backpack")

        if Backpack then
            Child.Parent = Backpack
        else
            Child.Parent = nil
        end
    end)

    for _, Child in ipairs(Character:GetChildren()) do
        if Child:IsA("Tool") then
            local Backpack = Plr:FindFirstChild("Backpack")

            if Backpack then
                Child.Parent = Backpack
            else
                Child.Parent = nil
            end
        end
    end
end

local function StartAntiEquip()
    if AntiEquip.Active then
        Notify("AntiEquip: Already active")
        return
    end

    local Character = Plr.Character

    if not Character then
        Notify("AntiEquip: You need a character to start AntiEquip")
        return
    end

    AntiEquip.Active = true
    HookAntiEquip(Character)

    if AntiEquip.CharacterConn then
        AntiEquip.CharacterConn:Disconnect()
    end

    AntiEquip.CharacterConn = Plr.CharacterAdded:Connect(function(NewCharacter)
        if not AntiEquip.Active then
            return
        end

        HookAntiEquip(NewCharacter)
    end)

    Notify("AntiEquip: Enabled")
end

local function StopAntiEquip()
    if not AntiEquip.Active then
        Notify("AntiEquip: Not active")
        return
    end

    AntiEquip.Active = false

    if AntiEquip.ToolConn then
        AntiEquip.ToolConn:Disconnect()
        AntiEquip.ToolConn = nil
    end

    if AntiEquip.CharacterConn then
        AntiEquip.CharacterConn:Disconnect()
        AntiEquip.CharacterConn = nil
    end

    Notify("AntiEquip: Disabled")
end

Cmd.new(
    {"antiequip", "preventtools", "prevtools"},
    "Prevents you from equipping tools.",
    "antiequip",
    StartAntiEquip
)

Cmd.new(
    {"unantiequip", "unpreventtools", "unprevtools"},
    "Allows you to equip tools again.",
    "unantiequip",
    StopAntiEquip
)