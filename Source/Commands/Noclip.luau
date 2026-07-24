local NoclipConnection = nil
local SavedCollisions = {}

local function GetChar()
    local lp = Players.LocalPlayer
    return lp and lp.Character
end

local function EnableNoclip()
    if NoclipConnection then return end

    local char = GetChar()
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                SavedCollisions[part] = part.CanCollide
            end
        end
    end

    NoclipConnection = RunService.Stepped:Connect(function()
        local c = GetChar()
        if not c then return end
        for _, part in ipairs(c:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

local function DisableNoclip()
    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end

    local char = GetChar()
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = if SavedCollisions[part] ~= nil
                    then SavedCollisions[part]
                    else true
            end
        end
    end

    SavedCollisions = {}
end

Cmd.Reg(Cmd.new({"noclip", "nc"}, "Enables noclip, letting you pass through geometry.", "noclip", function()
    EnableNoclip()
    DebugNotif("Noclip: Enabled")
end))

Cmd.Reg(Cmd.new({"clip", "cl"}, "Disables noclip and restores normal collision.", "clip", function()
    DisableNoclip()
    DebugNotif("Noclip: Disabled")
end))