if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Shared = (function()
    local Success, Env = pcall(getgenv)
    return (Success and Env) or _G or (warn("[Shared]: Failed to access a usable global environment.") or {})
end)()

if Shared.Tags and Shared.Tags.IsLoaded then
    return
end

local function expect(ExpectedType, Value, Fallback)
    if type(Value) == ExpectedType then
        return Value
    end

    if Fallback ~= nil then
        if type(Fallback) == "function" then
            return function(...)
                warn("[Expect]: Missing executor functionality. Using fallback function.")
                return Fallback(...)
            end
        end

        warn("[Expect]: Value has unexpected type. Using fallback value.")
    end

    return Fallback
end

local cloneref = expect("function", cloneref, function(...) return ... end)

local Services = setmetatable({}, {
    __index = function(Self, Name)
        local Success, Cache = pcall(function()
            return cloneref(game:GetService(Name))
        end)

        if Success then
            rawset(Self, Name, Cache)
            return Cache
        else
            error("Invalid Service: " .. tostring(Name))
        end
    end
})

local Hui = (gethui and gethui()) or Services.CoreGui
local Players = Services.Players
local RunService = Services.RunService
local TweenService = Services.TweenService

Shared.Tags = {
    IsLoaded = true
}

local function Tween(Object, Speed, Properties, EasingStyle, EasingDirection)
    if EasingStyle == nil then
        EasingStyle = "Quad"
    end

    if EasingDirection == nil then
        EasingDirection = "Out"
    end

    local TweenInformation = TweenInfo.new(
        Speed,
        Enum.EasingStyle[EasingStyle],
        Enum.EasingDirection[EasingDirection]
    )

    return TweenService:Create(Object, TweenInformation, Properties)
end

local function AnimateStroke(UIStroke)
    local UIGradient = UIStroke:FindFirstChildOfClass("UIGradient")
    if not UIGradient then
        return
    end

    task.spawn(function()
        while UIGradient and UIGradient.Parent do
            local Sine = os.clock()

            UIGradient.Rotation += 1
            UIGradient.Offset = Vector2.new(
                2.5 * math.sin(Sine),
                math.cos((Sine + 0.5) * 0.1)
            )

            task.wait()
        end
    end)
end

local function AnimateBillboard(BillboardGui)
    for _, Object in BillboardGui:GetDescendants() do
        if Object:IsA("UIStroke") then
            AnimateStroke(Object)
        end
    end
end

local Users = {
    ["IlIIllIlIIlIllIIlllI"] = {
        Name = "JustAGuest",
        Tag = "Owner",
        TagColor = Color3.fromRGB(51, 101, 255)
    },

    ["JvneX1"] = {
        Name = "Jvne",
        Tag = "Legend",
        TagColor = Color3.fromRGB(255, 0, 0)
    },

    ["imCherry511"] = {
        Name = "mxsynry",
        Tag = "Slyvie",
        TagColor = Color3.fromRGB(174, 0, 255)
    },
}

local function Random(Length)
    local Characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local Result = ""
    for Index = 1, Length do
        local Pos = math.random(1, #Characters)
        Result = Result .. Characters:sub(Pos, Pos)
    end
    return Result
end

local UI = {}
local ActiveBillboards = {}
local InitialSpawn = true

local function CreateBillboard(Player, Data)
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local Head = Character:WaitForChild("Head")

    local TagColor = Data.TagColor or Color3.fromRGB(255, 255, 255)
    local DisplayName = Data.Name or Player.DisplayName
    local Tag = Data.Tag or "User"

    local Suffix = Random(4)
    local IsOwner = Data.Tag == "Owner"
    local BillboardName = IsOwner and "OwnerTag" or ("Tag_" .. Suffix)

    UI[BillboardName] = Instance.new("BillboardGui")
    UI[BillboardName]["Active"] = true
    UI[BillboardName]["Adornee"] = Head
    UI[BillboardName]["AlwaysOnTop"] = false
    UI[BillboardName]["LightInfluence"] = 0
    UI[BillboardName]["MaxDistance"] = 100
    UI[BillboardName]["Name"] = BillboardName
    UI[BillboardName]["ResetOnSpawn"] = false
    UI[BillboardName]["Size"] = UDim2.fromOffset(1000, 34)
    UI[BillboardName]["StudsOffset"] = Vector3.new(0, 2.5, 0)
    UI[BillboardName]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling
    UI[BillboardName]["Parent"] = Hui

    UI["TagText_" .. Suffix] = Instance.new("TextLabel")
    UI["TagText_" .. Suffix]["AnchorPoint"] = Vector2.new(0.5, 0.5)
    UI["TagText_" .. Suffix]["AutomaticSize"] = Enum.AutomaticSize.X
    UI["TagText_" .. Suffix]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
    UI["TagText_" .. Suffix]["BackgroundTransparency"] = 0
    UI["TagText_" .. Suffix]["BorderSizePixel"] = 0
    UI["TagText_" .. Suffix]["FontFace"] = Font.new("rbxasset://fonts/families/Sarpanch.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    UI["TagText_" .. Suffix]["Name"] = "Tag"
    UI["TagText_" .. Suffix]["Position"] = UDim2.new(0.5, 0, 0.5, 0)
    UI["TagText_" .. Suffix]["Text"] = Tag .. " • " .. DisplayName
    UI["TagText_" .. Suffix]["TextColor3"] = TagColor
    UI["TagText_" .. Suffix]["TextSize"] = 24
    UI["TagText_" .. Suffix]["TextTransparency"] = 1
    UI["TagText_" .. Suffix]["Parent"] = UI[BillboardName]

    UI["TagPadding_" .. Suffix] = Instance.new("UIPadding")
    UI["TagPadding_" .. Suffix]["Name"] = "TagPadding"
    UI["TagPadding_" .. Suffix]["PaddingLeft"] = UDim.new(0, 4)
    UI["TagPadding_" .. Suffix]["PaddingRight"] = UDim.new(0, 4)
    UI["TagPadding_" .. Suffix]["Parent"] = UI["TagText_" .. Suffix]

    UI["TagConstraint_" .. Suffix] = Instance.new("UISizeConstraint")
    UI["TagConstraint_" .. Suffix]["MaxSize"] = Vector2.new(math.huge, 9999)
    UI["TagConstraint_" .. Suffix]["MinSize"] = Vector2.new(100, 34)
    UI["TagConstraint_" .. Suffix]["Name"] = "TagConstraint"
    UI["TagConstraint_" .. Suffix]["Parent"] = UI["TagText_" .. Suffix]

    UI["TagStroke_" .. Suffix] = Instance.new("UIStroke")
    UI["TagStroke_" .. Suffix]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
    UI["TagStroke_" .. Suffix]["Color"] = Color3.fromRGB(255, 255, 255)
    UI["TagStroke_" .. Suffix]["Name"] = "TagStroke"
    UI["TagStroke_" .. Suffix]["Thickness"] = 2
    UI["TagStroke_" .. Suffix]["Parent"] = UI["TagText_" .. Suffix]

    UI["TagLabelStrokeGradient_" .. Suffix] = Instance.new("UIGradient")
    UI["TagLabelStrokeGradient_" .. Suffix]["Color"] = ColorSequence.new{
        ColorSequenceKeypoint.new(0.000, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.499, TagColor),
        ColorSequenceKeypoint.new(1.000, Color3.fromRGB(0, 0, 0))
    }
    UI["TagLabelStrokeGradient_" .. Suffix]["Name"] = "TagLabelStrokeGradient"
    UI["TagLabelStrokeGradient_" .. Suffix]["Parent"] = UI["TagStroke_" .. Suffix]

    UI["TagCorner_" .. Suffix] = Instance.new("UICorner")
    UI["TagCorner_" .. Suffix]["CornerRadius"] = UDim.new(0, 3)
    UI["TagCorner_" .. Suffix]["Name"] = "TagCorner"
    UI["TagCorner_" .. Suffix]["Parent"] = UI["TagText_" .. Suffix]

    ActiveBillboards[Player] = {
        Suffix = Suffix,
        BillboardName = BillboardName,
        Billboard = UI[BillboardName],
        Tag = UI["TagText_" .. Suffix]
    }

    AnimateBillboard(UI[BillboardName])

    if not InitialSpawn then
        local FadeInTag = Tween(UI["TagText_" .. Suffix], 0.5, {TextTransparency = 0})
        FadeInTag:Play()
    else
        UI["TagText_" .. Suffix]["TextTransparency"] = 0
    end
end

local function RemoveBillboard(Player)
    local BillboardData = ActiveBillboards[Player]
    if not BillboardData then return end

    local Suffix = BillboardData.Suffix
    local BillboardName = BillboardData.BillboardName

    local FadeOutTag = Tween(UI["TagText_" .. Suffix], 0.5, {TextTransparency = 1})
    FadeOutTag:Play()
    FadeOutTag.Completed:Wait()

    if UI[BillboardName] then
        UI[BillboardName]:Destroy()
        UI[BillboardName] = nil
    end

    ActiveBillboards[Player] = nil
end

local function ConnectCharacterAdded(Player)
    Player.CharacterAdded:Connect(function(Character)
        local HasTag = false
        local UserData = nil

        for UserId, Data in pairs(Users) do
            if Player.Name == UserId or Player.UserId == tonumber(UserId) then
                HasTag = true
                UserData = Data
                break
            end
        end

        if HasTag and UserData then
            if ActiveBillboards[Player] then
                RemoveBillboard(Player)
            end

            local Head = Character:WaitForChild("Head", 5)
            if Head then
                CreateBillboard(Player, UserData)
            end
        end
    end)
end

local function OnPlayerAdded(Player)
    for UserId, Data in pairs(Users) do
        if Player.Name == UserId or Player.UserId == tonumber(UserId) then
            CreateBillboard(Player, Data)
        end
    end

    ConnectCharacterAdded(Player)
end

local function OnPlayerRemoving(Player)
    RemoveBillboard(Player)
end

for _, Player in pairs(Players:GetPlayers()) do
    OnPlayerAdded(Player)
end

InitialSpawn = false

Players.PlayerAdded:Connect(OnPlayerAdded)
Players.PlayerRemoving:Connect(OnPlayerRemoving)

return UI