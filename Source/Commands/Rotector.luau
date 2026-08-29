local Players = GetService("Players")
local HttpService = GetService("HttpService")

local RotectorBaseURL = "https://roscoe.rotector.com"

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
    local RequestFunc =
        http_request
        or request
        or (syn and syn.request)

    if type(RequestFunc) ~= "function" then
        local Success, Result = pcall(function()
            return game:HttpGet(Url)
        end)

        if Success then
            return {
                Success = true,
                StatusCode = 200,
                Body = Result,
            }
        end

        return nil
    end

    local Success, Result = pcall(function()
        return RequestFunc({
            Url = Url,
            Method = "GET",
        })
    end)

    if not Success or not Result then
        return nil
    end

    return {
        Success = Result.Success ~= false,
        StatusCode = Result.StatusCode,
        Body = Result.Body,
    }
end

local function LookupRotector(UserId)
    local Url = RotectorBaseURL
        .. "/v1/lookup/roblox/user/"
        .. tostring(UserId)

    local Response = RotectorHttpGet(Url)

    if not Response then
        return nil, "HTTP request threw an error"
    end

    if not Response.Body then
        return nil, "No response body, status " .. tostring(Response.StatusCode)
    end

    if Response.StatusCode and Response.StatusCode ~= 200 then
        return nil,
            "HTTP "
            .. tostring(Response.StatusCode)
            .. ": "
            .. Response.Body:sub(1, 150)
    end

    local Success, Decoded = pcall(function()
        return HttpService:JSONDecode(Response.Body)
    end)

    if not Success or not Decoded then
        return nil,
            "Failed to parse response: "
            .. Response.Body:sub(1, 150)
    end

    if not Decoded.success or not Decoded.data then
        return nil,
            "Rotector returned an error: "
            .. Response.Body:sub(1, 150)
    end

    return Decoded.data, nil
end

Cmd.new(
    {"rotector", "rot"},
    "Checks a player against Rotector for flags, actionability, category, and confidence.",
    "rotector <player>",
    function(Args)
        local SearchTerm = Args[2]

        if not SearchTerm then
            Notify("Usage: .rotector <player>")
            return
        end

        local Matches = FindPlr(SearchTerm)

        if #Matches == 0 then
            Notify("Player not found: " .. SearchTerm)
            return
        end

        if #Matches > 1 then
            local PlayerNames = {}

            for _, Player in ipairs(Matches) do
                table.insert(
                    PlayerNames,
                    Player.Name .. " (" .. Player.DisplayName .. ")"
                )
            end

            Notify(
                "Multiple players found: "
                .. table.concat(PlayerNames, ", ")
            )

            return
        end

        local TargetPlayer = Matches[1]

        Notify(
            "Checking "
            .. TargetPlayer.Name
            .. " against Rotector..."
        )

        local Data, Err = LookupRotector(TargetPlayer.UserId)

        if not Data then
            Notify(
                "Rotector lookup failed: "
                .. tostring(Err)
            )

            return
        end

        local FlagName =
            RotectorFlagNames[Data.flagType]
            or "Unknown"

        local Actionable =
            RotectorActionable[Data.flagType]
            or "Unknown"

        local Message =
            TargetPlayer.Name
            .. " ("
            .. TargetPlayer.DisplayName
            .. "): "
            .. FlagName
            .. " | Actionable: "
            .. Actionable

        if Data.category
            and RotectorCategoryNames[Data.category] then

            Message = Message
                .. " | Category: "
                .. RotectorCategoryNames[Data.category]
        end

        if Data.confidence then
            Message = Message
                .. " | Confidence: "
                .. tostring(
                    math.floor(Data.confidence * 100)
                )
                .. "%"
        end

        Notify(Message)

        print("[Rotector] " .. Message)

        if Data.reasons then
            for ReasonKey, ReasonData in pairs(Data.reasons) do
                if type(ReasonData) == "table"
                    and ReasonData.message then

                    print(
                        "[Rotector] "
                        .. ReasonKey
                        .. ": "
                        .. ReasonData.message
                    )
                end
            end
        end

        print(
            "[Rotector] Data via rotector.com — statuses may change, do not cache beyond 24h."
        )
    end
)

local function ScanServerForRotector()
    local AllPlayers = Players:GetPlayers()
    local ScanList = {}

    for Index, Player in ipairs(AllPlayers) do
        if Index > RotectorScanMaxPlayers then
            break
        end

        if Player ~= Plr then
            table.insert(ScanList, Player)
        end
    end

    if #ScanList == 0 then
        return
    end

    print(
        "[Rotector] Scanning "
        .. #ScanList
        .. " player(s)..."
    )

    local FlaggedResults = {}
    local ErrorCount = 0

    for _, Player in ipairs(ScanList) do
        local Data, Err = LookupRotector(Player.UserId)

        if Data then
            local FlagName =
                RotectorFlagNames[Data.flagType]
                or "Unknown"

            local Actionable =
                RotectorActionable[Data.flagType]
                or "Unknown"

            print(
                "[Rotector] "
                .. Player.Name
                .. ": "
                .. FlagName
            )

            if Data.flagType == 1
                or Data.flagType == 2
                or Data.flagType == 5 then

                table.insert(FlaggedResults, {
                    Player = Player,
                    FlagName = FlagName,
                    Actionable = Actionable,
                    Category =
                        Data.category
                        and RotectorCategoryNames[Data.category]
                        or nil,
                    Confidence = Data.confidence,
                })
            end
        else
            ErrorCount = ErrorCount + 1

            print(
                "[Rotector] "
                .. Player.Name
                .. ": lookup failed - "
                .. tostring(Err)
            )
        end

        task.wait(RotectorScanDelay)
    end

    if #FlaggedResults > 0 then
        for _, Result in ipairs(FlaggedResults) do
            local Message =
                "⚠️ "
                .. Result.Player.Name
                .. " ("
                .. Result.Player.DisplayName
                .. "): "
                .. Result.FlagName
                .. " | Actionable: "
                .. Result.Actionable

            if Result.Category then
                Message = Message
                    .. " | "
                    .. Result.Category
            end

            if Result.Confidence then
                Message = Message
                    .. " | "
                    .. tostring(
                        math.floor(
                            Result.Confidence * 100
                        )
                    )
                    .. "%"
            end

            Notify(Message)
        end
    else
        Notify(
            "Rotector: scanned "
            .. #ScanList
            .. " player(s), no flags found"
        )
    end

    print(
        "[Rotector] Scan complete. "
        .. #FlaggedResults
        .. " flagged, "
        .. ErrorCount
        .. " errors, via rotector.com — do not cache beyond 24h."
    )
end

task.spawn(ScanServerForRotector)