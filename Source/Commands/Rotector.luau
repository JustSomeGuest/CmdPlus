local RotectorBaseURL = "https://api.rotector.com"

local RotectorFlagNames = {
    [0] = "Unflagged",
    [1] = "Flagged",
    [2] = "Confirmed",
    [3] = "Queued",
    [4] = "Provisional Flag",
    [5] = "Mixed",
    [6] = "Past Offender",
    [8] = "Redacted",
}

local RotectorActionable = {
    [0] = "No",
    [1] = "Yes",
    [2] = "Yes",
    [3] = "No",
    [4] = "No",
    [5] = "At discretion",
    [6] = "No",
    [8] = "No",
}

local RotectorCategoryNames = {
    [1] = "CSAM",
    [2] = "Sexual",
    [3] = "Kink",
    [4] = "Raceplay",
    [5] = "Condo",
    [6] = "Other",
}

local RotectorScanMaxPlayers = 25
local RotectorScanDelay = 0.15

local function RotectorHttpGet(Url)
    local RequestFunc = expect("function", syn and syn.request,
        expect("function", request,
            expect("function", http_request, nil)))

    if not RequestFunc then
        local success, result = pcall(function()
            return game:HttpGet(Url)
        end)
        if success then
            return { Success = true, StatusCode = 200, Body = result }
        end
        return nil
    end

    local success, result = pcall(function()
        return RequestFunc({
            Url = Url,
            Method = "GET",
        })
    end)

    if not success or not result then
        return nil
    end

    return {
        Success = true,
        StatusCode = result.StatusCode,
        Body = result.Body,
    }
end

local function FindPlayersForRotector(searchTerm)
    local matches = {}
    local searchLower = searchTerm:lower()

    for _, player in ipairs(Players:GetPlayers()) do
        local nameLower = player.Name:lower()
        local displayLower = player.DisplayName:lower()

        if nameLower == searchLower or displayLower == searchLower then
            table.insert(matches, player)
        elseif nameLower:match(searchLower) or displayLower:match(searchLower) then
            table.insert(matches, player)
        end
    end

    return matches
end

local function LookupRotector(UserId)
    local Url = RotectorBaseURL .. "/v1/lookup/roblox/user/" .. tostring(UserId)
    local Response = RotectorHttpGet(Url)

    if not Response or not Response.Body then
        return nil, "Request failed"
    end

    local success, decoded = pcall(function()
        return HttpService:JSONDecode(Response.Body)
    end)

    if not success or not decoded then
        return nil, "Failed to parse response"
    end

    if not decoded.success or not decoded.data then
        return nil, "Rotector returned an error"
    end

    return decoded.data, nil
end

Cmd.Reg(Cmd.new({"rotector", "rot"}, function(Args)
    local searchTerm = Args[2]
    if not searchTerm then
        DebugNotif("Usage: .rotector <player>")
        return
    end

    local matches = FindPlayersForRotector(searchTerm)

    if #matches == 0 then
        DebugNotif("Player not found: " .. searchTerm)
        return
    end

    if #matches > 1 then
        local playerNames = {}
        for i, player in ipairs(matches) do
            table.insert(playerNames, player.Name .. " (" .. player.DisplayName .. ")")
        end
        DebugNotif("Multiple players found: " .. table.concat(playerNames, ", "))
        return
    end

    local targetPlayer = matches[1]

    DebugNotif("Checking " .. targetPlayer.Name .. " against Rotector...")

    local Data, Err = LookupRotector(targetPlayer.UserId)

    if not Data then
        DebugNotif("Rotector lookup failed: " .. tostring(Err))
        return
    end

    local FlagName = RotectorFlagNames[Data.flagType] or "Unknown"
    local Actionable = RotectorActionable[Data.flagType] or "Unknown"

    local Message = targetPlayer.Name .. " (" .. targetPlayer.DisplayName .. "): " .. FlagName .. " | Actionable: " .. Actionable

    if Data.category and RotectorCategoryNames[Data.category] then
        Message = Message .. " | Category: " .. RotectorCategoryNames[Data.category]
    end

    if Data.confidence then
        Message = Message .. " | Confidence: " .. tostring(math.floor(Data.confidence * 100)) .. "%"
    end

    DebugNotif(Message)

    print("[Rotector] " .. Message)

    if Data.reasons then
        for ReasonKey, ReasonData in pairs(Data.reasons) do
            if type(ReasonData) == "table" and ReasonData.message then
                print("[Rotector] " .. ReasonKey .. ": " .. ReasonData.message)
            end
        end
    end

    print("[Rotector] Data via rotector.com — statuses may change, do not cache beyond 24h.")
end))

local function ScanServerForRotector()
    local AllPlayers = Players:GetPlayers()
    local ScanList = {}

    for i, player in ipairs(AllPlayers) do
        if i > RotectorScanMaxPlayers then
            break
        end
        if player ~= Players.LocalPlayer then
            table.insert(ScanList, player)
        end
    end

    if #ScanList == 0 then
        return
    end

    print("[Rotector] Scanning " .. #ScanList .. " player(s)...")

    local FlaggedResults = {}
    local ErrorCount = 0

    for _, player in ipairs(ScanList) do
        local Data, Err = LookupRotector(player.UserId)

        if Data then
            local FlagName = RotectorFlagNames[Data.flagType] or "Unknown"
            local Actionable = RotectorActionable[Data.flagType] or "Unknown"

            print("[Rotector] " .. player.Name .. ": " .. FlagName)

            if Data.flagType == 1 or Data.flagType == 2 or Data.flagType == 5 then
                table.insert(FlaggedResults, {
                    Player = player,
                    FlagName = FlagName,
                    Actionable = Actionable,
                    Category = Data.category and RotectorCategoryNames[Data.category] or nil,
                    Confidence = Data.confidence,
                })
            end
        else
            ErrorCount = ErrorCount + 1
            print("[Rotector] " .. player.Name .. ": lookup failed - " .. tostring(Err))
        end

        task.wait(RotectorScanDelay)
    end

    if #FlaggedResults > 0 then
        for _, Result in ipairs(FlaggedResults) do
            local Message = "⚠️ " .. Result.Player.Name .. " (" .. Result.Player.DisplayName .. "): " .. Result.FlagName .. " | Actionable: " .. Result.Actionable

            if Result.Category then
                Message = Message .. " | " .. Result.Category
            end

            if Result.Confidence then
                Message = Message .. " | " .. tostring(math.floor(Result.Confidence * 100)) .. "%"
            end

            DebugNotif(Message)
        end
    else
        DebugNotif("Rotector: scanned " .. #ScanList .. " player(s), no flags found")
    end

    print("[Rotector] Scan complete. " .. #FlaggedResults .. " flagged, " .. ErrorCount .. " errors, via rotector.com — do not cache beyond 24h.")
end

task.spawn(ScanServerForRotector)