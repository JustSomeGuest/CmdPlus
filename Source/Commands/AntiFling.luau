local Players = GetService("Players")
local RunService = GetService("RunService")

local AntiFlingActive = false
local AntiflingConn
local AntiflingPlayerConn
local PlayerConns = {}
local Tracked = {}
local OrigCan = {}
local Signals = {}

local function ClearPart(Part)
    Tracked[Part] = nil
    OrigCan[Part] = nil

    if Signals[Part] then
        Signals[Part]:Disconnect()
        Signals[Part] = nil
    end
end

local function Apply(Part)
    if not (
        Part
        and typeof(Part) == "Instance"
        and Part:IsA("BasePart")
    ) or Tracked[Part] then
        return
    end

    Tracked[Part] = true

    if OrigCan[Part] == nil then
        OrigCan[Part] = Part.CanCollide
    end

    Signals[Part] = Part:GetPropertyChangedSignal("CanCollide"):Connect(function()
        if Tracked[Part] and Part.CanCollide then
            Part.CanCollide = false
        end
    end)

    if Part.CanCollide then
        Part.CanCollide = false
    end
end

local function SeedCharacter(Character)
    if not Character then
        return
    end

    for _, Descendant in ipairs(Character:GetDescendants()) do
        if Descendant:IsA("BasePart") then
            Apply(Descendant)
        end
    end

    local AddedConn = Character.DescendantAdded:Connect(function(Instance)
        if Instance:IsA("BasePart") then
            Apply(Instance)
        end
    end)

    local RemovingConn = Character.DescendantRemoving:Connect(function(Instance)
        if Instance:IsA("BasePart") then
            ClearPart(Instance)
        end
    end)

    PlayerConns[Character] = {
        AddedConn,
        RemovingConn
    }
end

local function CleanupCharacter(Character)
    if not Character then
        return
    end

    if PlayerConns[Character] then
        for _, Connection in ipairs(PlayerConns[Character]) do
            Connection:Disconnect()
        end

        PlayerConns[Character] = nil
    end

    for _, Descendant in ipairs(Character:GetDescendants()) do
        if Tracked[Descendant] then
            ClearPart(Descendant)
        end
    end
end

local function HookPlayer(Player)
    if Player == Plr then
        return
    end

    if Player.Character then
        SeedCharacter(Player.Character)
    end

    local CharacterAddedConn = Player.CharacterAdded:Connect(function(Character)
        if AntiFlingActive then
            SeedCharacter(Character)
        end
    end)

    local CharacterRemovingConn = Player.CharacterRemoving:Connect(function(Character)
        CleanupCharacter(Character)
    end)

    PlayerConns[Player] = {
        CharacterAddedConn,
        CharacterRemovingConn
    }
end

local function Antifling()
    if AntiFlingActive then
        Notify("AntiFling: Already active")
        return
    end

    AntiFlingActive = true

    Tracked = {}
    OrigCan = {}
    Signals = {}

    for _, Player in ipairs(Players:GetPlayers()) do
        HookPlayer(Player)
    end

    AntiflingPlayerConn = Players.PlayerAdded:Connect(function(Player)
        if AntiFlingActive then
            HookPlayer(Player)
        end
    end)

    AntiflingConn = RunService.PreSimulation:Connect(function()
        local Quota = 256
        local Key = nil

        while Quota > 0 do
            Key = next(Tracked, Key)

            if not Key then
                break
            end

            if typeof(Key) == "Instance"
                and Key:IsA("BasePart")
                and Key.Parent then

                if Key.CanCollide then
                    Key.CanCollide = false
                end
            else
                ClearPart(Key)
            end

            Quota -= 1
        end
    end)

    Notify("AntiFling: Enabled")
end

local function Unantifling()
    if not AntiFlingActive then
        Notify("AntiFling: Not active")
        return
    end

    AntiFlingActive = false

    if AntiflingConn then
        AntiflingConn:Disconnect()
        AntiflingConn = nil
    end

    if AntiflingPlayerConn then
        AntiflingPlayerConn:Disconnect()
        AntiflingPlayerConn = nil
    end

    for Object, Connections in pairs(PlayerConns) do
        for _, Connection in ipairs(Connections) do
            Connection:Disconnect()
        end

        PlayerConns[Object] = nil
    end

    for Part in pairs(Tracked) do
        if typeof(Part) == "Instance"
            and Part:IsA("BasePart")
            and Part.Parent
            and OrigCan[Part] ~= nil then

            Part.CanCollide = OrigCan[Part]
        end
    end

    for _, Connection in pairs(Signals) do
        Connection:Disconnect()
    end

    Tracked = {}
    OrigCan = {}
    Signals = {}

    Notify("AntiFling: Disabled")
end

Cmd.new(
    {"antifling", "af"},
    "Prevents your character from being flung.",
    "antifling",
    function()
        Antifling()
    end
)

Cmd.new(
    {"unantifling", "uaf"},
    "Disables anti-fling.",
    "unantifling",
    function()
        Unantifling()
    end
)