local AntiEquipConns = {}
local AntiEquipActive = false

local function HookHumanoid(Humanoid)
    AntiEquipConns[#AntiEquipConns + 1] = Humanoid.Equipped:Connect(function()
        Humanoid:UnequipTools()
    end)
end

local function SeedCharacter(Character)
    local Humanoid = Character:WaitForChild("Humanoid", 5)
    if Humanoid then
        HookHumanoid(Humanoid)
        Humanoid:UnequipTools()
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
        SeedCharacter(Character)
    end

    AntiEquipConns[#AntiEquipConns + 1] = Player.CharacterAdded:Connect(function(Char)
        if AntiEquipActive then
            SeedCharacter(Char)
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

AntiEquip(false)

Cmd.Reg(Cmd.new({"antiequip", "preventtools", "prevtools"}, function()
    AntiEquip(true)
end))

Cmd.Reg(Cmd.new({"unantiequip", "unpreventtools", "unprevtools"}, function()
    UnAntiEquip()
end))