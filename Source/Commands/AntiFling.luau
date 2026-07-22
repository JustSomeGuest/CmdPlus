local AntiflingConns = {}
local TrackedParts = {}
local OriginalCanCollide = {}
local PartSignals = {}

local function ClearPart(Part)
    TrackedParts[Part] = nil
    OriginalCanCollide[Part] = nil
    if PartSignals[Part] then
        PartSignals[Part]:Disconnect()
        PartSignals[Part] = nil
    end
end

local function ApplyPart(Part)
    if not (Part and typeof(Part) == "Instance" and Part:IsA("BasePart")) or TrackedParts[Part] then
        return
    end

    TrackedParts[Part] = true

    if OriginalCanCollide[Part] == nil then
        OriginalCanCollide[Part] = Part.CanCollide
    end

    if not PartSignals[Part] then
        AntiflingConns[#AntiflingConns + 1] = Part:GetPropertyChangedSignal("CanCollide"):Connect(function()
            if TrackedParts[Part] and Part.CanCollide ~= false then
                Part.CanCollide = false
            end
        end)
        PartSignals[Part] = AntiflingConns[#AntiflingConns]
    end

    if Part.CanCollide ~= false then
        Part.CanCollide = false
    end
end

local function SeedChar(Char)
    if not Char then
        return
    end

    for _, Descendant in ipairs(Char:GetDescendants()) do
        if Descendant:IsA("BasePart") then
            ApplyPart(Descendant)
        end
    end

    AntiflingConns[#AntiflingConns + 1] = Char.DescendantAdded:Connect(function(Inst)
        if Inst:IsA("BasePart") then
            ApplyPart(Inst)
        end
    end)

    AntiflingConns[#AntiflingConns + 1] = Char.DescendantRemoving:Connect(function(Inst)
        if Inst:IsA("BasePart") then
            ClearPart(Inst)
        end
    end)
end

local function CleanupChar(Char)
    if not Char then
        return
    end

    for _, Descendant in ipairs(Char:GetDescendants()) do
        if TrackedParts[Descendant] then
            ClearPart(Descendant)
        end
    end
end

local function Antifling(Notify)
    for _, Connection in ipairs(AntiflingConns) do
        Connection:Disconnect()
    end
    AntiflingConns = {}

    for Part, _ in pairs(TrackedParts) do
        if typeof(Part) == "Instance" and Part:IsA("BasePart") then
            local Original = OriginalCanCollide[Part]
            if Original == nil then
                Original = true
            end
            Part.CanCollide = Original
        end
    end

    for _, Signal in pairs(PartSignals) do
        if Signal and Signal.Disconnect then
            Signal:Disconnect()
        end
    end

    table.clear(TrackedParts)
    table.clear(OriginalCanCollide)
    table.clear(PartSignals)

    local function HookOther(OtherPlr)
        if OtherPlr == Players.LocalPlayer then
            return
        end

        if OtherPlr.Character then
            SeedChar(OtherPlr.Character)
        end

        AntiflingConns[#AntiflingConns + 1] = OtherPlr.CharacterAdded:Connect(function(Char)
            SeedChar(Char)
        end)

        AntiflingConns[#AntiflingConns + 1] = OtherPlr.CharacterRemoving:Connect(function(Char)
            CleanupChar(Char)
        end)
    end

    for _, OtherPlr in ipairs(Players:GetPlayers()) do
        HookOther(OtherPlr)
    end

    AntiflingConns[#AntiflingConns + 1] = Players.PlayerAdded:Connect(HookOther)

    AntiflingConns[#AntiflingConns + 1] = Players.PlayerRemoving:Connect(function(OtherPlr)
        if OtherPlr == Players.LocalPlayer then
            return
        end
        CleanupChar(OtherPlr.Character)
    end)

    local LastKey = nil
    local QuotaPerStep = 256

    AntiflingConns[#AntiflingConns + 1] = RunService.PreSimulation:Connect(function()
        local Quota = QuotaPerStep
        local Key = LastKey

        if Key ~= nil and TrackedParts[Key] == nil then
            Key = nil
        end

        while Quota > 0 do
            Key = next(TrackedParts, Key)
            if not Key then
                LastKey = nil
                break
            end

            local Part = Key
            if typeof(Part) == "Instance" and Part:IsA("BasePart") and Part.Parent then
                if Part.CanCollide ~= false then
                    Part.CanCollide = false
                end
                LastKey = Part
            else
                ClearPart(Part)
                LastKey = nil
            end

            Quota = Quota - 1
        end
    end)

    if Notify then
        DebugNotif("AntiFling: Enabled")
    end
end

local function Unantifling()
    for _, Connection in ipairs(AntiflingConns) do
        Connection:Disconnect()
    end
    AntiflingConns = {}

    for Part, _ in pairs(TrackedParts) do
        if typeof(Part) == "Instance" and Part:IsA("BasePart") then
            local Original = OriginalCanCollide[Part]
            if Original == nil then
                Original = true
            end
            Part.CanCollide = Original
        end
    end

    for _, Signal in pairs(PartSignals) do
        if Signal and Signal.Disconnect then
            Signal:Disconnect()
        end
    end

    table.clear(TrackedParts)
    table.clear(OriginalCanCollide)
    table.clear(PartSignals)

    DebugNotif("AntiFling: Disabled")
end

Antifling(false)

Cmd.Reg(Cmd.new({"antifling", "af"}, "Prevents your character from being flung.", ".antifling", function()
    Antifling(true)
end))

Cmd.Reg(Cmd.new({"unantifling", "uaf"}, "Disables anti-fling.", ".unantifling", function()
    Unantifling()
end))