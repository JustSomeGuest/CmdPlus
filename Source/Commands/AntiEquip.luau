local AntiEquipConns = {}
local AntiEquipActive = false

local function BlockTool(Tool)
    local Backpack = Plr:FindFirstChild("Backpack")

    if Backpack then
        Tool.Parent = Backpack
    else
        Tool.Parent = nil
    end
end

local function HookCharacter(Character)
    AntiEquipConns[#AntiEquipConns + 1] = Character.ChildAdded:Connect(function(Child)
        if AntiEquipActive and Child:IsA("Tool") then
            BlockTool(Child)
        end
    end)

    for _, Child in ipairs(Character:GetChildren()) do
        if Child:IsA("Tool") then
            BlockTool(Child)
        end
    end
end

local function AntiEquip()
    for _, Connection in ipairs(AntiEquipConns) do
        Connection:Disconnect()
    end

    AntiEquipConns = {}
    AntiEquipActive = true

    local Character = Plr.Character

    if Character then
        HookCharacter(Character)
    end

    AntiEquipConns[#AntiEquipConns + 1] = Plr.CharacterAdded:Connect(function(Character)
        if AntiEquipActive then
            HookCharacter(Character)
        end
    end)

    Notify("AntiEquip: Enabled")
end

local function UnAntiEquip()
    AntiEquipActive = false

    for _, Connection in ipairs(AntiEquipConns) do
        Connection:Disconnect()
    end

    AntiEquipConns = {}

    Notify("AntiEquip: Disabled")
end

Cmd.new(
    {"antiequip", "preventtools", "prevtools"},
    "Prevents you from equipping tools.",
    "antiequip",
    AntiEquip
)

Cmd.new(
    {"unantiequip", "unpreventtools", "unprevtools"},
    "Allows you to equip tools again.",
    "unantiequip",
    UnAntiEquip
)