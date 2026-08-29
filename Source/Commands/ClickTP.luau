local Mouse = Plr:GetMouse()

local ClickTPConnection
local ClickTPTool

local function CreateClickTPTool()
    if ClickTPTool then
        return
    end

    local Backpack = Plr:FindFirstChildOfClass("Backpack")

    if not Backpack then
        return
    end

    local Tool = Instance.new("Tool")
    Tool.Name = "ClickTP"
    Tool.RequiresHandle = false
    Tool.CanBeDropped = false

    Tool.Activated:Connect(function()
        local Character = Plr.Character
        local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        if RootPart then
            RootPart.CFrame = CFrame.new(
                Mouse.Hit.Position + Vector3.new(0, 3, 0)
            )
        end
    end)

    Tool.Parent = Backpack
    ClickTPTool = Tool
end

local function RemoveClickTPTool()
    if ClickTPTool then
        ClickTPTool:Destroy()
        ClickTPTool = nil
    end

    local Backpack = Plr:FindFirstChildOfClass("Backpack")

    if Backpack then
        local ExistingTool = Backpack:FindFirstChild("ClickTP")

        if ExistingTool then
            ExistingTool:Destroy()
        end
    end

    local Character = Plr.Character

    if Character then
        local ExistingTool = Character:FindFirstChild("ClickTP")

        if ExistingTool then
            ExistingTool:Destroy()
        end
    end
end

local function EnableClickTP()
    if ClickTPConnection then
        Notify("ClickTP: Already active")
        return
    end

    CreateClickTPTool()

    ClickTPConnection = Mouse.Button1Down:Connect(function()
        local Character = Plr.Character
        local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        if RootPart then
            RootPart.CFrame = CFrame.new(
                Mouse.Hit.Position + Vector3.new(0, 3, 0)
            )
        end
    end)

    Notify("ClickTP: Enabled")
end

local function DisableClickTP()
    if not ClickTPConnection then
        Notify("ClickTP: Already inactive")
        return
    end

    ClickTPConnection:Disconnect()
    ClickTPConnection = nil

    RemoveClickTPTool()

    Notify("ClickTP: Disabled")
end

Cmd.new(
    {"clicktp", "tptool"},
    "Teleports where you click.",
    "clicktp",
    function()
        EnableClickTP()
    end
)

Cmd.new(
    {"unclicktp", "untptool"},
    "Disables ClickTP.",
    "unclicktp",
    function()
        DisableClickTP()
    end
)