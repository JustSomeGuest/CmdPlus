local EspHighlights = {}
local EspCharConns = {}
local EspPlayerConn = nil

local LocHighlights = {}
local LocCharConns = {}

local function MakeHighlight(char, fill, outline)
    local hl = Instance.new("Highlight")
    hl.FillColor = fill
    hl.OutlineColor = outline
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0
    hl.Parent = char
    return hl
end

local function FindPlayer(query)
    if not query or query == "" then return nil end
    query = query:lower()
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower() == query or p.DisplayName:lower() == query then
            return p
        end
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower():find(query, 1, true) or p.DisplayName:lower():find(query, 1, true) then
            return p
        end
    end
    return nil
end

local function AddEsp(player)
    if player == Players.LocalPlayer then return end
    if EspHighlights[player.UserId] then return end

    if player.Character then
        EspHighlights[player.UserId] = MakeHighlight(
            player.Character,
            Color3.fromRGB(255, 50, 50),
            Color3.fromRGB(255, 255, 255)
        )
    end

    EspCharConns[player.UserId] = player.CharacterAdded:Connect(function(char)
        if EspHighlights[player.UserId] then
            EspHighlights[player.UserId]:Destroy()
        end
        EspHighlights[player.UserId] = MakeHighlight(
            char,
            Color3.fromRGB(255, 50, 50),
            Color3.fromRGB(255, 255, 255)
        )
    end)
end

local function RemoveEsp(player)
    if EspHighlights[player.UserId] then
        EspHighlights[player.UserId]:Destroy()
        EspHighlights[player.UserId] = nil
    end
    if EspCharConns[player.UserId] then
        EspCharConns[player.UserId]:Disconnect()
        EspCharConns[player.UserId] = nil
    end
end

local function AddLocate(player)
    if player == Players.LocalPlayer then return end
    if LocHighlights[player.UserId] then return end

    if player.Character then
        LocHighlights[player.UserId] = MakeHighlight(
            player.Character,
            Color3.fromRGB(50, 255, 50),
            Color3.fromRGB(255, 255, 0)
        )
    end

    LocCharConns[player.UserId] = player.CharacterAdded:Connect(function(char)
        if LocHighlights[player.UserId] then
            LocHighlights[player.UserId]:Destroy()
        end
        LocHighlights[player.UserId] = MakeHighlight(
            char,
            Color3.fromRGB(50, 255, 50),
            Color3.fromRGB(255, 255, 0)
        )
    end)
end

local function RemoveLocate(player)
    if LocHighlights[player.UserId] then
        LocHighlights[player.UserId]:Destroy()
        LocHighlights[player.UserId] = nil
    end
    if LocCharConns[player.UserId] then
        LocCharConns[player.UserId]:Disconnect()
        LocCharConns[player.UserId] = nil
    end
end

Cmd.Reg(Cmd.new({"esp"}, "Highlights all players.", "esp", function()
    if EspPlayerConn then return end
    for _, player in ipairs(Players:GetPlayers()) do
        AddEsp(player)
    end
    EspPlayerConn = Players.PlayerAdded:Connect(function(player)
        AddEsp(player)
    end)
    DebugNotif("ESP: Enabled")
end))

Cmd.Reg(Cmd.new({"unesp"}, "Removes all ESP highlights.", "unesp", function()
    for _, player in ipairs(Players:GetPlayers()) do
        RemoveEsp(player)
    end
    if EspPlayerConn then
        EspPlayerConn:Disconnect()
        EspPlayerConn = nil
    end
    DebugNotif("ESP: Disabled")
end))

Cmd.Reg(Cmd.new({"locate"}, "Highlights a specific player.", "locate <player>", function(args)
    local player = FindPlayer(args[1])
    if not player then
        DebugNotif("ESP: Player not found")
        return
    end
    AddLocate(player)
    DebugNotif("ESP: Locating " .. player.Name)
end))

Cmd.Reg(Cmd.new({"unlocate"}, "Removes locate highlight from a player.", "unlocate <player>", function(args)
    local player = FindPlayer(args[1])
    if not player then
        DebugNotif("ESP: Player not found")
        return
    end
    RemoveLocate(player)
    DebugNotif("ESP: Unlocated " .. player.Name)
end))