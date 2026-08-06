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

local function GetService(Service)
    return cloneref(game:GetService(Service))
end

local Hui = gethui and gethui() or GetService("CoreGui")
local Players = GetService("Players")
local RunService = GetService("RunService")
local TweenService = GetService("TweenService")

Shared.Tags = { IsLoaded = true }

local function Tween(Object, Speed, Props, Style, Dir)
    return TweenService:Create(
        Object,
        TweenInfo.new(
            Speed,
            Enum.EasingStyle[Style or "Quad"],
            Enum.EasingDirection[Dir or "Out"]
        ),
        Props
    )
end

local function AnimTag(Tag)
    for _, Object in Tag:GetDescendants() do
        if Object:IsA("UIStroke") then
            local UIGradient = Object:FindFirstChildOfClass("UIGradient")

            if UIGradient then
                task.spawn(function()
                    while UIGradient.Parent do
                        local Sine = os.clock()
                        UIGradient.Rotation += 1
                        UIGradient.Offset = Vector2.new(2.5 * math.sin(Sine), math.cos((Sine + 0.5) * 0.1))
                        task.wait()
                    end
                end)
            end
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
        Name = "Yuni",
        Tag = "Legend",
        TagColor = Color3.fromRGB(255, 0, 0)
    },

    ["imCherry511"] = {
        Name = "mxsynry",
        Tag = "Slyvie",
        TagColor = Color3.fromRGB(174, 0, 255)
    },
}

local function UID(Length)
    Length = Length or 32

    local Chars = [[abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~]]
    local Id = {}

    for i = 1, Length do
        local Rand = math.random(#Chars)
        Id[i] = Chars:sub(Rand, Rand)
    end

    return table.concat(Id)
end

local UI = {}
local ActiveTags = {}
local InitialSpawn = true

local function CreateTag(Player, Data)
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local Head = Character:WaitForChild("Head")

    local TagColor = Data.TagColor or Color3.fromRGB(255, 255, 255)
    local DisplayName = Data.Name or Player.DisplayName
    local Tag = Data.Tag or "User"
    local Suffix = UID(8)
    local TagName = "Tag_" .. Suffix

    UI[TagName] = Instance.new("BillboardGui")
    UI[TagName]["Active"] = true
    UI[TagName]["Adornee"] = Head
    UI[TagName]["AlwaysOnTop"] = false
    UI[TagName]["LightInfluence"] = 0
    UI[TagName]["MaxDistance"] = 100
    UI[TagName]["Name"] = UID(64)
    UI[TagName]["ResetOnSpawn"] = false
    UI[TagName]["Size"] = UDim2.fromOffset(1000, 34)
    UI[TagName]["StudsOffset"] = Vector3.new(0, 2.5, 0)
    UI[TagName]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling
    UI[TagName]["Parent"] = Hui

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
    UI["TagText_" .. Suffix]["Parent"] = UI[TagName]

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

    ActiveTags[Player] = {
        Suffix = Suffix,
        TagName = TagName,
        Billboard = UI[TagName],
        Tag = UI["TagText_" .. Suffix]
    }

    AnimTag(UI[TagName])

    if not InitialSpawn then
        local FadeInTag = Tween(UI["TagText_" .. Suffix], 0.5, {TextTransparency = 0})
        FadeInTag:Play()
    else
        UI["TagText_" .. Suffix]["TextTransparency"] = 0
    end
end

local function RemoveTag(Player)
    local TagData = ActiveTags[Player]
    if not TagData then return end

    local Suffix = TagData.Suffix
    local TagName = TagData.TagName

    local FadeOutTag = Tween(UI["TagText_" .. Suffix], 0.5, {TextTransparency = 1})
    FadeOutTag:Play()
    FadeOutTag.Completed:Wait()

    if UI[TagName] then
        UI[TagName]:Destroy()
        UI[TagName] = nil
    end

    ActiveTags[Player] = nil
end

local function ConnCharAdded(Player)
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
            if ActiveTags[Player] then
                RemoveTag(Player)
            end

            local Head = Character:WaitForChild("Head", 5)
            if Head then
                CreateTag(Player, UserData)
            end
        end
    end)
end

local function OnPlayerAdded(Player)
    for UserId, Data in pairs(Users) do
        if Player.Name == UserId or Player.UserId == tonumber(UserId) then
            CreateTag(Player, Data)
        end
    end

    ConnCharAdded(Player)
end

local function OnPlayerRemoving(Player)
    RemoveTag(Player)
end

for _, Player in pairs(Players:GetPlayers()) do
    OnPlayerAdded(Player)
end

InitialSpawn = false

Players.PlayerAdded:Connect(OnPlayerAdded)
Players.PlayerRemoving:Connect(OnPlayerRemoving)

return UI