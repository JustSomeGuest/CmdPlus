local Player = Players.LocalPlayer

local AntiEquipConns = {}
local AntiEquipActive = false

local function BlockTool(Tool, Character)
    local Backpack = Player:FindFirstChild("Backpack")
    if Backpack then
        Tool.Parent = Backpack
    else
        Tool.Parent = nil
    end
end

local function HookCharacter(Character)
    AntiEquipConns[#AntiEquipConns + 1] = Character.ChildAdded:Connect(function(Child)
        if AntiEquipActive and Child:IsA("Tool") then
            BlockTool(Child, Character)
        end
    end)

    for _, Child in ipairs(Character:GetChildren()) do
        if Child:IsA("Tool") then
            BlockTool(Child, Character)
        end
    end
end

local function AntiEquip(Notify)
    for _, Connection in ipairs(AntiEquipConns) do
        Connection:Disconnect()
    end
    AntiEquipConns = {}
    AntiEquipActive = true

    local Character = Player.Character
    if Character then
        HookCharacter(Character)
    end

    AntiEquipConns[#AntiEquipConns + 1] = Player.CharacterAdded:Connect(function(Char)
        if AntiEquipActive then
            HookCharacter(Char)
        end
    end)

    if Notify then
        DebugNotif("AntiEquip: Enabled")
    end
end

local function UnAntiEquip()
    AntiEquipActive = false
    for _, Connection in ipairs(AntiEquipConns) do
        Connection:Disconnect()
    end
    AntiEquipConns = {}

    DebugNotif("AntiEquip: Disabled")
end

Cmd.new({"antiequip", "preventtools", "prevtools"}, "Prevents you from equipping tools.", "antiequip", function()
    AntiEquip(true)
end)

Cmd.new({"unantiequip", "unpreventtools", "unprevtools"}, "Allows you to equip tools again.", "unantiequip", function()
    UnAntiEquip()
end)