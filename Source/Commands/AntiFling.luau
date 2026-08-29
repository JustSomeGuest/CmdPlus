local Players = GetService("Players")
local RunService = GetService("RunService")

local antiflingConn
local antiflingPlayerConn
local playerConns = {}
local tracked = {}
local origCan = {}
local signals = {}

local function clearPart(Part)
    tracked[Part] = nil
    origCan[Part] = nil

    if signals[Part] then
        signals[Part]:Disconnect()
        signals[Part] = nil
    end
end

local function apply(Part)
    if not (
        Part
        and typeof(Part) == "Instance"
        and Part:IsA("BasePart")
    ) or tracked[Part] then
        return
    end

    tracked[Part] = true

    if origCan[Part] == nil then
        origCan[Part] = Part.CanCollide
    end

    signals[Part] = Part:GetPropertyChangedSignal("CanCollide"):Connect(function()
        if tracked[Part] and Part.CanCollide ~= false then
            Part.CanCollide = false
        end
    end)

    if Part.CanCollide ~= false then
        Part.CanCollide = false
    end
end

local function seedChar(Character)
    if not Character then
        return
    end

    for _, Descendant in ipairs(Character:GetDescendants()) do
        if Descendant:IsA("BasePart") then
            apply(Descendant)
        end
    end

    local AddedConn = Character.DescendantAdded:Connect(function(Instance)
        if Instance:IsA("BasePart") then
            apply(Instance)
        end
    end)

    local RemovingConn = Character.DescendantRemoving:Connect(function(Instance)
        if Instance:IsA("BasePart") then
            clearPart(Instance)
        end
    end)

    playerConns[Character] = {
        AddedConn,
        RemovingConn
    }
end

local function cleanupChar(Character)
    if not Character then
        return
    end

    if playerConns[Character] then
        for _, Connection in ipairs(playerConns[Character]) do
            Connection:Disconnect()
        end

        playerConns[Character] = nil
    end

    for _, Descendant in ipairs(Character:GetDescendants()) do
        if tracked[Descendant] then
            clearPart(Descendant)
        end
    end
end

local function hookPlayer(Player)
    if Player == Plr then
        return
    end

    if Player.Character then
        seedChar(Player.Character)
    end

    Player.CharacterAdded:Connect(function(Character)
        seedChar(Character)
    end)

    Player.CharacterRemoving:Connect(function(Character)
        cleanupChar(Character)
    end)
end

local function antifling(notify)
    if antiflingConn then
        antiflingConn:Disconnect()
        antiflingConn = nil
    end

    if antiflingPlayerConn then
        antiflingPlayerConn:Disconnect()
        antiflingPlayerConn = nil
    end

    for _, Connections in pairs(playerConns) do
        for _, Connection in ipairs(Connections) do
            Connection:Disconnect()
        end
    end

    playerConns = {}
    tracked = {}
    origCan = {}
    signals = {}

    for _, Player in ipairs(Players:GetPlayers()) do
        hookPlayer(Player)
    end

    antiflingPlayerConn = Players.PlayerAdded:Connect(hookPlayer)

    antiflingConn = RunService.PreSimulation:Connect(function()
        local Quota = 256
        local Key = nil

        while Quota > 0 do
            Key = next(tracked, Key)

            if not Key then
                break
            end

            if typeof(Key) == "Instance"
                and Key:IsA("BasePart")
                and Key.Parent then

                if Key.CanCollide ~= false then
                    Key.CanCollide = false
                end
            else
                clearPart(Key)
            end

            Quota -= 1
        end
    end)

    if notify then
        Notify("AntiFling: Enabled")
    end
end

local function unantifling()
    if antiflingConn then
        antiflingConn:Disconnect()
        antiflingConn = nil
    end

    if antiflingPlayerConn then
        antiflingPlayerConn:Disconnect()
        antiflingPlayerConn = nil
    end

    for Character, Connections in pairs(playerConns) do
        for _, Connection in ipairs(Connections) do
            Connection:Disconnect()
        end
    end

    playerConns = {}

    for Part in pairs(tracked) do
        if typeof(Part) == "Instance" and Part:IsA("BasePart") then
            if Part.Parent then
                if origCan[Part] ~= nil then
                    Part.CanCollide = origCan[Part]
                end
            end
        end
    end

    for _, Connection in pairs(signals) do
        Connection:Disconnect()
    end

    tracked = {}
    origCan = {}
    signals = {}

    Notify("AntiFling: Disabled")
end

Cmd.new(
    {"antifling", "af"},
    "Prevents your character from being flung.",
    "antifling",
    function()
        antifling(true)
    end
)

Cmd.new(
    {"unantifling", "uaf"},
    "Disables anti-fling.",
    "unantifling",
    function()
        unantifling()
    end
)