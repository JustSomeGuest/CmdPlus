local Players = GetService("Players")

local EspHighlights = {}
local EspCharConns = {}
local EspPlayerConn = nil

local LocHighlights = {}
local LocCharConns = {}

local function MakeHighlight(Character, Fill)
    local Highlight = Instance.new("Highlight")

    Highlight.FillColor = Fill
    Highlight.OutlineColor = Color3.new(
        Fill.R * 0.65,
        Fill.G * 0.65,
        Fill.B * 0.65
    )

    Highlight.FillTransparency = 0.5
    Highlight.OutlineTransparency = 0
    Highlight.Parent = Character

    return Highlight
end

local function FindPlayers(SearchTerm)
    local Matches = {}
    local SearchLower = SearchTerm:lower()

    for _, Player in ipairs(Players:GetPlayers()) do
        local NameLower = Player.Name:lower()
        local DisplayLower = Player.DisplayName:lower()

        if NameLower == SearchLower or DisplayLower == SearchLower then
            table.insert(Matches, Player)
        elseif NameLower:match(SearchLower) or DisplayLower:match(SearchLower) then
            table.insert(Matches, Player)
        end
    end

    return Matches
end

local function ResolvePlayer(Args)
    if not Args[1] or Args[1] == "" then
        Notify("ESP: No player specified")
        return nil
    end

    local Matches = FindPlayers(Args[1])

    if #Matches == 0 then
        Notify("ESP: Player not found")
        return nil
    end

    if #Matches > 1 then
        local PlayerNames = {}

        for _, Player in ipairs(Matches) do
            table.insert(PlayerNames, Player.Name)
        end

        Notify(
            "ESP: Multiple players found: "
            .. table.concat(PlayerNames, ", ")
        )

        return nil
    end

    return Matches[1]
end

local function AddEsp(Player)
    if Player == Plr then
        return
    end

    if EspHighlights[Player.UserId] then
        return
    end

    if Player.Character then
        EspHighlights[Player.UserId] = MakeHighlight(
            Player.Character,
            Color3.fromRGB(255, 50, 50)
        )
    end

    EspCharConns[Player.UserId] = Player.CharacterAdded:Connect(function(Character)
        if EspHighlights[Player.UserId] then
            EspHighlights[Player.UserId]:Destroy()
        end

        EspHighlights[Player.UserId] = MakeHighlight(
            Character,
            Color3.fromRGB(255, 50, 50)
        )
    end)
end

local function RemoveEsp(Player)
    if EspHighlights[Player.UserId] then
        EspHighlights[Player.UserId]:Destroy()
        EspHighlights[Player.UserId] = nil
    end

    if EspCharConns[Player.UserId] then
        EspCharConns[Player.UserId]:Disconnect()
        EspCharConns[Player.UserId] = nil
    end
end

local function AddLocate(Player)
    if Player == Plr then
        return
    end

    if LocHighlights[Player.UserId] then
        return
    end

    if Player.Character then
        LocHighlights[Player.UserId] = MakeHighlight(
            Player.Character,
            Color3.fromRGB(50, 255, 50)
        )

        LocHighlights[Player.UserId].OutlineColor =
            Color3.fromRGB(255, 255, 0)
    end

    LocCharConns[Player.UserId] = Player.CharacterAdded:Connect(function(Character)
        if LocHighlights[Player.UserId] then
            LocHighlights[Player.UserId]:Destroy()
        end

        LocHighlights[Player.UserId] = MakeHighlight(
            Character,
            Color3.fromRGB(50, 255, 50)
        )

        LocHighlights[Player.UserId].OutlineColor =
            Color3.fromRGB(255, 255, 0)
    end)
end

local function RemoveLocate(Player)
    if LocHighlights[Player.UserId] then
        LocHighlights[Player.UserId]:Destroy()
        LocHighlights[Player.UserId] = nil
    end

    if LocCharConns[Player.UserId] then
        LocCharConns[Player.UserId]:Disconnect()
        LocCharConns[Player.UserId] = nil
    end
end

Cmd.new(
    {"esp"},
    "Highlights all players.",
    "esp",
    function()
        if EspPlayerConn then
            Notify("ESP: Already enabled")
            return
        end

        for _, Player in ipairs(Players:GetPlayers()) do
            AddEsp(Player)
        end

        EspPlayerConn = Players.PlayerAdded:Connect(function(Player)
            AddEsp(Player)
        end)

        Notify("ESP: Enabled")
    end
)

Cmd.new(
    {"unesp"},
    "Removes all ESP highlights.",
    "unesp",
    function()
        for _, Player in ipairs(Players:GetPlayers()) do
            RemoveEsp(Player)
        end

        if EspPlayerConn then
            EspPlayerConn:Disconnect()
            EspPlayerConn = nil
        end

        Notify("ESP: Disabled")
    end
)

Cmd.new(
    {"locate"},
    "Highlights a specific player.",
    "locate <player>",
    function(Args)
        local Player = ResolvePlayer(Args)

        if not Player then
            return
        end

        AddLocate(Player)

        Notify("ESP: Locating " .. Player.Name)
    end
)

Cmd.new(
    {"unlocate"},
    "Removes locate highlight from a player.",
    "unlocate <player>",
    function(Args)
        local Player = ResolvePlayer(Args)

        if not Player then
            return
        end

        RemoveLocate(Player)

        Notify("ESP: Unlocated " .. Player.Name)
    end
)