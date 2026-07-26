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

    ["imcherry511"] = {
        Name = "mxsynry",
        Tag = "Slyvie",
        TagColor = Color3.fromRGB(174, 0, 255)
    },
}

local function Random(Length)
    local Characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()"
    local Result = ""
    for Index = 1, Length do
        Result = Result .. Characters:sub(math.random(1, #Characters), math.random(1, #Characters))
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
    local TagKey = Data.Tag == "Owner" and "OwnerTag_" or "Tag_"
    
    UI["Billboard_" .. Suffix] = Instance.new("BillboardGui")
    UI["Billboard_" .. Suffix]["Active"] = true
    UI["Billboard_" .. Suffix]["Adornee"] = Head
    UI["Billboard_" .. Suffix]["AlwaysOnTop"] = false
    UI["Billboard_" .. Suffix]["LightInfluence"] = 0
    UI["Billboard_" .. Suffix]["MaxDistance"] = 100
    UI["Billboard_" .. Suffix]["Size"] = UDim2.new(0, 158, 0, 42)
    UI["Billboard_" .. Suffix]["StudsOffset"] = Vector3.new(0, 2.5, 0)
    UI["Billboard_" .. Suffix]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling
    UI["Billboard_" .. Suffix]["Parent"] = Hui
    
    UI[TagKey .. Suffix] = Instance.new("Frame")
    UI[TagKey .. Suffix]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
    UI[TagKey .. Suffix]["BackgroundTransparency"] = 1
    UI[TagKey .. Suffix]["BorderSizePixel"] = 0
    UI[TagKey .. Suffix]["Size"] = UDim2.new(1, 0, 1, 0)
    UI[TagKey .. Suffix]["Parent"] = UI["Billboard_" .. Suffix]
    
    UI[TagKey .. "Corner_" .. Suffix] = Instance.new("UICorner")
    UI[TagKey .. "Corner_" .. Suffix]["CornerRadius"] = UDim.new(0, 4)
    UI[TagKey .. "Corner_" .. Suffix]["Parent"] = UI[TagKey .. Suffix]
    
    UI[TagKey .. "Stroke_" .. Suffix] = Instance.new("UIStroke")
    UI[TagKey .. "Stroke_" .. Suffix]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
    UI[TagKey .. "Stroke_" .. Suffix]["Color"] = Color3.fromRGB(255, 255, 255)
    UI[TagKey .. "Stroke_" .. Suffix]["Thickness"] = 2
    UI[TagKey .. "Stroke_" .. Suffix]["Parent"] = UI[TagKey .. Suffix]
    
    UI[TagKey .. "StrokeGradient_" .. Suffix] = Instance.new("UIGradient")
    UI[TagKey .. "StrokeGradient_" .. Suffix]["Color"] = ColorSequence.new{
        ColorSequenceKeypoint.new(0.000, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.499, TagColor),
        ColorSequenceKeypoint.new(1.000, Color3.fromRGB(0, 0, 0))
    }
    UI[TagKey .. "StrokeGradient_" .. Suffix]["Rotation"] = 0
    UI[TagKey .. "StrokeGradient_" .. Suffix]["Parent"] = UI[TagKey .. "Stroke_" .. Suffix]
    
    UI["Name_" .. Suffix] = Instance.new("TextLabel")
    UI["Name_" .. Suffix]["AnchorPoint"] = Vector2.new(0.5, 0.5)
    UI["Name_" .. Suffix]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["Name_" .. Suffix]["BackgroundTransparency"] = 1
    UI["Name_" .. Suffix]["BorderSizePixel"] = 0
    UI["Name_" .. Suffix]["FontFace"] = Font.new("rbxasset://fonts/families/Sarpanch.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    UI["Name_" .. Suffix]["Position"] = UDim2.new(0.5, 0, 0.5, 0)
    UI["Name_" .. Suffix]["Size"] = UDim2.new(1, 0, 1, 0)
    UI["Name_" .. Suffix]["Text"] = Tag
    UI["Name_" .. Suffix]["TextColor3"] = TagColor
    UI["Name_" .. Suffix]["TextScaled"] = true
    UI["Name_" .. Suffix]["TextTransparency"] = 1
    UI["Name_" .. Suffix]["TextWrapped"] = true
    UI["Name_" .. Suffix]["Parent"] = UI[TagKey .. Suffix]
    
    UI["NamePadding_" .. Suffix] = Instance.new("UIPadding")
    UI["NamePadding_" .. Suffix]["PaddingLeft"] = UDim.new(0, 4)
    UI["NamePadding_" .. Suffix]["PaddingRight"] = UDim.new(0, 4)
    UI["NamePadding_" .. Suffix]["Parent"] = UI["Name_" .. Suffix]
    
    UI["Tag_" .. Suffix] = Instance.new("TextLabel")
    UI["Tag_" .. Suffix]["AnchorPoint"] = Vector2.new(0.5, 1)
    UI["Tag_" .. Suffix]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
    UI["Tag_" .. Suffix]["BackgroundTransparency"] = 1
    UI["Tag_" .. Suffix]["BorderSizePixel"] = 0
    UI["Tag_" .. Suffix]["FontFace"] = Font.new("rbxasset://fonts/families/Sarpanch.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    UI["Tag_" .. Suffix]["Position"] = UDim2.new(0.5, 0, 0, 2)
    UI["Tag_" .. Suffix]["Size"] = UDim2.new(0.6, 0, 0.6, 0)
    UI["Tag_" .. Suffix]["Text"] = DisplayName
    UI["Tag_" .. Suffix]["TextColor3"] = TagColor
    UI["Tag_" .. Suffix]["TextScaled"] = true
    UI["Tag_" .. Suffix]["TextTransparency"] = 1
    UI["Tag_" .. Suffix]["TextWrapped"] = true
    UI["Tag_" .. Suffix]["Parent"] = UI[TagKey .. Suffix]
    
    UI["TagCorner_" .. Suffix] = Instance.new("UICorner")
    UI["TagCorner_" .. Suffix]["CornerRadius"] = UDim.new(0, 4)
    UI["TagCorner_" .. Suffix]["Parent"] = UI["Tag_" .. Suffix]
    
    UI["TagStroke_" .. Suffix] = Instance.new("UIStroke")
    UI["TagStroke_" .. Suffix]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
    UI["TagStroke_" .. Suffix]["Color"] = Color3.fromRGB(255, 255, 255)
    UI["TagStroke_" .. Suffix]["Thickness"] = 2
    UI["TagStroke_" .. Suffix]["Parent"] = UI["Tag_" .. Suffix]
    
    UI["TagStrokeGradient_" .. Suffix] = Instance.new("UIGradient")
    UI["TagStrokeGradient_" .. Suffix]["Color"] = ColorSequence.new{
        ColorSequenceKeypoint.new(0.000, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.499, TagColor),
        ColorSequenceKeypoint.new(1.000, Color3.fromRGB(0, 0, 0))
    }
    UI["TagStrokeGradient_" .. Suffix]["Parent"] = UI["TagStroke_" .. Suffix]
    
    UI["TagPadding_" .. Suffix] = Instance.new("UIPadding")
    UI["TagPadding_" .. Suffix]["PaddingLeft"] = UDim.new(0, 4)
    UI["TagPadding_" .. Suffix]["PaddingRight"] = UDim.new(0, 4)
    UI["TagPadding_" .. Suffix]["Parent"] = UI["Tag_" .. Suffix]
    
    ActiveBillboards[Player] = {
        Suffix = Suffix,
        TagKey = TagKey,
        Billboard = UI["Billboard_" .. Suffix],
        Frame = UI[TagKey .. Suffix],
        Name = UI["Name_" .. Suffix],
        Tag = UI["Tag_" .. Suffix]
    }
    
    AnimateBillboard(UI["Billboard_" .. Suffix])
    
    if not InitialSpawn then
        local FadeInTween = Tween(UI[TagKey .. Suffix], 0.5, {BackgroundTransparency = 0})
        local FadeInName = Tween(UI["Name_" .. Suffix], 0.5, {TextTransparency = 0})
        local FadeInTag = Tween(UI["Tag_" .. Suffix], 0.5, {TextTransparency = 0, BackgroundTransparency = 0})
        
        FadeInTween:Play()
        FadeInName:Play()
        FadeInTag:Play()
    else
        UI[TagKey .. Suffix]["BackgroundTransparency"] = 0
        UI["Name_" .. Suffix]["TextTransparency"] = 0
        UI["Tag_" .. Suffix]["TextTransparency"] = 0
        UI["Tag_" .. Suffix]["BackgroundTransparency"] = 0
    end
end

local function RemoveBillboard(Player)
    local BillboardData = ActiveBillboards[Player]
    if not BillboardData then return end
    
    local Suffix = BillboardData.Suffix
    local TagKey = BillboardData.TagKey
    
    local FadeOutTween = Tween(UI[TagKey .. Suffix], 0.5, {BackgroundTransparency = 1})
    local FadeOutName = Tween(UI["Name_" .. Suffix], 0.5, {TextTransparency = 1})
    local FadeOutTag = Tween(UI["Tag_" .. Suffix], 0.5, {TextTransparency = 1, BackgroundTransparency = 1})
    
    FadeOutTween:Play()
    FadeOutName:Play()
    FadeOutTag:Play()
    
    FadeOutTween.Completed:Wait()
    
    if UI["Billboard_" .. Suffix] then
        UI["Billboard_" .. Suffix]:Destroy()
        UI["Billboard_" .. Suffix] = nil
    end
    
    ActiveBillboards[Player] = nil
end

local function OnPlayerAdded(Player)
    for UserId, Data in pairs(Users) do
        if Player.Name == UserId or Player.UserId == tonumber(UserId) then
            CreateBillboard(Player, Data)
        end
    end
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

Players.PlayerAdded:Connect(function(Player)
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
end)

return UI