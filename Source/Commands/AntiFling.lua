local Players = GetService("Players")
local RunService = GetService("RunService")

local AntiFlingActive = false
local AntiflingConn
local AntiflingPlayerConn

local PlayerConnections = {}
local CharacterParts = {}

local function Disconnect(Connection)
    if Connection then
        Connection:Disconnect()
    end
end

local function TrackPart(Part)
    if not Part:IsA("BasePart") or CharacterParts[Part] then
        return
    end

    CharacterParts[Part] = true
end

local function UntrackPart(Part)
    CharacterParts[Part] = nil
end

local function SetupCharacter(Character)
    if not Character or Character == Plr.Character then
        return
    end

    for _, Instance in ipairs(Character:GetDescendants()) do
        if Instance:IsA("BasePart") then
            TrackPart(Instance)
        end
    end

    local AddedConnection = Character.DescendantAdded:Connect(function(Instance)
        if AntiFlingActive and Instance:IsA("BasePart") then
            TrackPart(Instance)
        end
    end)

    local RemovingConnection = Character.DescendantRemoving:Connect(function(Instance)
        if Instance:IsA("BasePart") then
            UntrackPart(Instance)
        end
    end)

    PlayerConnections[Character] = {
        AddedConnection,
        RemovingConnection
    }
end

local function CleanupCharacter(Character)
    local Connections = PlayerConnections[Character]

    if Connections then
        for _, Connection in ipairs(Connections) do
            Disconnect(Connection)
        end

        PlayerConnections[Character] = nil
    end

    for Part in pairs(CharacterParts) do
        if not Part.Parent or Part:IsDescendantOf(Character) then
            UntrackPart(Part)
        end
    end
end

local function SetupPlayer(Player)
    if Player == Plr then
        return
    end

    if Player.Character then
        SetupCharacter(Player.Character)
    end

    local CharacterAddedConnection = Player.CharacterAdded:Connect(function(Character)
        if AntiFlingActive then
            SetupCharacter(Character)
        end
    end)

    local CharacterRemovingConnection = Player.CharacterRemoving:Connect(function(Character)
        CleanupCharacter(Character)
    end)

    PlayerConnections[Player] = {
        CharacterAddedConnection,
        CharacterRemovingConnection
    }
end

local function Antifling()
    if AntiFlingActive then
        Notify("AntiFling: Already active")
        return
    end

    AntiFlingActive = true

    for _, Player in ipairs(Players:GetPlayers()) do
        SetupPlayer(Player)
    end

    AntiflingPlayerConn = Players.PlayerAdded:Connect(function(Player)
        if AntiFlingActive then
            SetupPlayer(Player)
        end
    end)

    AntiflingConn = RunService.Heartbeat:Connect(function()
        if not AntiFlingActive then
            return
        end

        for Part in pairs(CharacterParts) do
            if Part.Parent then
                Part.CanCollide = false
            else
                UntrackPart(Part)
            end
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

    Disconnect(AntiflingConn)
    Disconnect(AntiflingPlayerConn)

    AntiflingConn = nil
    AntiflingPlayerConn = nil

    for Object, Connections in pairs(PlayerConnections) do
        for _, Connection in ipairs(Connections) do
            Disconnect(Connection)
        end

        PlayerConnections[Object] = nil
    end

    table.clear(CharacterParts)

    Notify("AntiFling: Disabled")
end

Cmd.new(
    {"antifling", "af"},
    "Prevents other players from colliding with your character.",
    "antifling",
    function()
        Antifling()
    end
)

Cmd.new(
    {"unantifling", "unaf"},
    "Disables anti-fling.",
    "unantifling",
    function()
        Unantifling()
    end
)