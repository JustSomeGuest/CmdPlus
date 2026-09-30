local Players = GetService("Players")
local RunService = GetService("RunService")

local AntiVoidActive = false
local AntiVoidConn
local CharacterAddedConn

local VoidPosition = -9e9
local VoidDistance = 1000
local SafeHeight = 25

local LastSafeCFrame
local Character

local function Disconnect(Connection)
    if Connection then
        Connection:Disconnect()
    end
end

local function GetRoot()
    Character = Plr.Character

    if not Character then
        return
    end

    local RootPart = Character:FindFirstChild("HumanoidRootPart")

    if RootPart and RootPart:IsA("BasePart") then
        return RootPart
    end
end

local function SaveSafePosition(RootPart)
    if not RootPart or not RootPart.Parent then
        return
    end

    if RootPart.Position.Y > VoidPosition + VoidDistance then
        LastSafeCFrame = RootPart.CFrame
    end
end

local function ReturnToSafePosition(RootPart)
    if not RootPart or not RootPart.Parent or not LastSafeCFrame then
        return
    end

    RootPart.CFrame = LastSafeCFrame
    RootPart.AssemblyLinearVelocity = Vector3.zero
    RootPart.AssemblyAngularVelocity = Vector3.zero
end

local function CheckVoid(RootPart)
    if not RootPart or not RootPart.Parent then
        return
    end

    local Position = RootPart.Position
    local Velocity = RootPart.AssemblyLinearVelocity

    if Position.Y <= VoidPosition + VoidDistance then
        ReturnToSafePosition(RootPart)
        return
    end

    if LastSafeCFrame then
        local SafeY = LastSafeCFrame.Position.Y

        if Position.Y < SafeY - VoidDistance and Velocity.Y < -SafeHeight then
            ReturnToSafePosition(RootPart)
            return
        end
    end

    if Velocity.Y > -SafeHeight then
        SaveSafePosition(RootPart)
    end
end

local function AntiVoid()
    if AntiVoidActive then
        Notify("AntiVoid: Already active")
        return
    end

    AntiVoidActive = true

    pcall(function()
        workspace.FallenPartsDestroyHeight = VoidPosition
    end)

    local RootPart = GetRoot()

    if RootPart then
        LastSafeCFrame = RootPart.CFrame
    end

    CharacterAddedConn = Plr.CharacterAdded:Connect(function(NewCharacter)
        Character = NewCharacter
        LastSafeCFrame = nil

        local NewRoot = NewCharacter:WaitForChild("HumanoidRootPart", 10)

        if NewRoot and AntiVoidActive then
            LastSafeCFrame = NewRoot.CFrame
        end
    end)

    AntiVoidConn = RunService.PreSimulation:Connect(function()
        if not AntiVoidActive then
            return
        end

        local CurrentRoot = GetRoot()

        if not CurrentRoot then
            return
        end

        if not LastSafeCFrame then
            LastSafeCFrame = CurrentRoot.CFrame
            return
        end

        CheckVoid(CurrentRoot)
    end)

    Notify("AntiVoid: Enabled")
end

local function UnAntiVoid()
    if not AntiVoidActive then
        Notify("AntiVoid: Not active")
        return
    end

    AntiVoidActive = false

    Disconnect(AntiVoidConn)
    Disconnect(CharacterAddedConn)

    AntiVoidConn = nil
    CharacterAddedConn = nil

    LastSafeCFrame = nil
    Character = nil

    Notify("AntiVoid: Disabled")
end

Cmd.new(
    {"antivoid", "av"},
    "Prevents your character from dying to the void.",
    "antivoid",
    function()
        AntiVoid()
    end
)

Cmd.new(
    {"unantivoid", "unav"},
    "Disables anti-void.",
    "unantivoid",
    function()
        UnAntiVoid()
    end
)