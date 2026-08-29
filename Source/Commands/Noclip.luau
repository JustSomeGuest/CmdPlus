local NoclipConnection = nil
local CharacterDescendantConnection = nil
local SavedCollisions = {}

local function GetChar()
    return Plr and Plr.Character
end

local function ApplyNoclip(Character)
    if not Character then
        return
    end

    for _, Part in ipairs(Character:GetDescendants()) do
        if Part:IsA("BasePart") then
            if SavedCollisions[Part] == nil then
                SavedCollisions[Part] = Part.CanCollide
            end

            Part.CanCollide = false
        end
    end

    if CharacterDescendantConnection then
        CharacterDescendantConnection:Disconnect()
        CharacterDescendantConnection = nil
    end

    CharacterDescendantConnection = Character.DescendantAdded:Connect(function(Instance)
        if Instance:IsA("BasePart") then
            if SavedCollisions[Instance] == nil then
                SavedCollisions[Instance] = Instance.CanCollide
            end

            Instance.CanCollide = false
        end
    end)
end

local function EnableNoclip()
    if NoclipConnection then
        return
    end

    local Character = GetChar()

    if Character then
        ApplyNoclip(Character)
    end

    NoclipConnection = Plr.CharacterAdded:Connect(function(NewCharacter)
        ApplyNoclip(NewCharacter)
    end)
end

local function DisableNoclip()
    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end

    if CharacterDescendantConnection then
        CharacterDescendantConnection:Disconnect()
        CharacterDescendantConnection = nil
    end

    local Character = GetChar()

    if Character then
        for _, Part in ipairs(Character:GetDescendants()) do
            if Part:IsA("BasePart") then
                if SavedCollisions[Part] ~= nil then
                    Part.CanCollide = SavedCollisions[Part]
                else
                    Part.CanCollide = true
                end
            end
        end
    end

    SavedCollisions = {}
end

Cmd.new(
    {"noclip", "nc"},
    "Enables noclip, letting you pass through geometry.",
    "noclip",
    function()
        EnableNoclip()
        Notify("Noclip: Enabled")
    end
)

Cmd.new(
    {"clip", "cl"},
    "Disables noclip and restores normal collision.",
    "clip",
    function()
        DisableNoclip()
        Notify("Noclip: Disabled")
    end
)