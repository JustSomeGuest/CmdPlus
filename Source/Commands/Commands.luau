local UI = {}

UI.ScreenGui = Instance.new("ScreenGui")
UI.ScreenGui.DisplayOrder = 100
UI.ScreenGui.Enabled = true
UI.ScreenGui.Name = "SimpleCMDS"
UI.ScreenGui.ResetOnSpawn = false
UI.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UI.ScreenGui.Parent = Hui

UI.ScreenGui:GetPropertyChangedSignal("Enabled"):Connect(function()
    if not UI.ScreenGui.Enabled then
        UI.ScreenGui.Enabled = true
    end
end)

UI.CmdsUI = Instance.new("Frame")
UI.CmdsUI.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.CmdsUI.BackgroundTransparency = 1
UI.CmdsUI.BorderSizePixel = 0
UI.CmdsUI.Name = "CmdsUI"
UI.CmdsUI.Position = UDim2.new(0, 16, 0, 6)
UI.CmdsUI.Size = UDim2.new(0.5, 0, 0.8, 0)
UI.CmdsUI.Visible = false
UI.CmdsUI.Parent = UI.ScreenGui

UI.CmdsShadow = Instance.new("ImageLabel")
UI.CmdsShadow.AnchorPoint = Vector2.new(0.5, 0.5)
UI.CmdsShadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.CmdsShadow.BackgroundTransparency = 1
UI.CmdsShadow.BorderSizePixel = 0
UI.CmdsShadow.Image = "rbxassetid://15298624572"
UI.CmdsShadow.Name = "CmdsShadow"
UI.CmdsShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
UI.CmdsShadow.Size = UDim2.new(1.059, 0, 1.088, 0)
UI.CmdsShadow.Parent = UI.CmdsUI

UI.CmdsFrame = Instance.new("CanvasGroup")
UI.CmdsFrame.AnchorPoint = Vector2.new(0.5, 0.5)
UI.CmdsFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
UI.CmdsFrame.BorderSizePixel = 0
UI.CmdsFrame.Name = "CmdsFrame"
UI.CmdsFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
UI.CmdsFrame.Size = UDim2.new(1, 0, 1, 0)
UI.CmdsFrame.Parent = UI.CmdsUI

UI.CmdsFrameCorner = Instance.new("UICorner")
UI.CmdsFrameCorner.CornerRadius = UDim.new(0, 4)
UI.CmdsFrameCorner.Name = "CmdsFrameCorner"
UI.CmdsFrameCorner.Parent = UI.CmdsFrame

UI.CmdsFrameLayout = Instance.new("UIListLayout")
UI.CmdsFrameLayout.FillDirection = Enum.FillDirection.Vertical
UI.CmdsFrameLayout.Name = "CmdsFrameLayout"
UI.CmdsFrameLayout.Padding = UDim.new(0, 2)
UI.CmdsFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.CmdsFrameLayout.Parent = UI.CmdsFrame

UI.CmdsFrameStroke = Instance.new("UIStroke")
UI.CmdsFrameStroke.Color = Color3.fromRGB(255, 255, 255)
UI.CmdsFrameStroke.Name = "CmdsFrameStroke"
UI.CmdsFrameStroke.Parent = UI.CmdsFrame

UI.CmdsContainer = Instance.new("Frame")
UI.CmdsContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.CmdsContainer.BackgroundTransparency = 1
UI.CmdsContainer.BorderSizePixel = 0
UI.CmdsContainer.LayoutOrder = 2
UI.CmdsContainer.Name = "CmdsContainer"
UI.CmdsContainer.Size = UDim2.new(1, 0, 1, 0)
UI.CmdsContainer.Parent = UI.CmdsFrame

UI.CmdsContainerPadding = Instance.new("UIPadding")
UI.CmdsContainerPadding.Name = "CmdsContainerPadding"
UI.CmdsContainerPadding.PaddingBottom = UDim.new(0, 4)
UI.CmdsContainerPadding.PaddingLeft = UDim.new(0, 4)
UI.CmdsContainerPadding.PaddingRight = UDim.new(0, 4)
UI.CmdsContainerPadding.PaddingTop = UDim.new(0, 4)
UI.CmdsContainerPadding.Parent = UI.CmdsContainer

UI.CmdsList = Instance.new("ScrollingFrame")
UI.CmdsList.AutomaticCanvasSize = Enum.AutomaticSize.Y
UI.CmdsList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.CmdsList.BackgroundTransparency = 0.9
UI.CmdsList.BorderSizePixel = 0
UI.CmdsList.CanvasSize = UDim2.new(0, 0, 0, 0)
UI.CmdsList.Name = "CmdsList"
UI.CmdsList.ScrollBarThickness = 4
UI.CmdsList.ScrollingDirection = Enum.ScrollingDirection.Y
UI.CmdsList.Size = UDim2.new(1, 0, 1, 0)
UI.CmdsList.Parent = UI.CmdsContainer

UI.CmdsListCorner = Instance.new("UICorner")
UI.CmdsListCorner.CornerRadius = UDim.new(0, 4)
UI.CmdsListCorner.Name = "CmdsListCorner"
UI.CmdsListCorner.Parent = UI.CmdsList

UI.CmdsListLayout = Instance.new("UIListLayout")
UI.CmdsListLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.CmdsListLayout.Name = "CmdsListLayout"
UI.CmdsListLayout.Padding = UDim.new(0, 6)
UI.CmdsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.CmdsListLayout.Parent = UI.CmdsList

UI.CmdsListPadding = Instance.new("UIPadding")
UI.CmdsListPadding.Name = "CmdsListPadding"
UI.CmdsListPadding.PaddingBottom = UDim.new(0, 4)
UI.CmdsListPadding.PaddingLeft = UDim.new(0, 4)
UI.CmdsListPadding.PaddingRight = UDim.new(0, 8)
UI.CmdsListPadding.PaddingTop = UDim.new(0, 4)
UI.CmdsListPadding.Parent = UI.CmdsList

UI.CmdTemplate = Instance.new("Frame")
UI.CmdTemplate.AutomaticSize = Enum.AutomaticSize.Y
UI.CmdTemplate.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.CmdTemplate.BackgroundTransparency = 0.95
UI.CmdTemplate.BorderSizePixel = 0
UI.CmdTemplate.Name = "CmdTemplate"
UI.CmdTemplate.Size = UDim2.new(0, 80, 0, 0)
UI.CmdTemplate.Visible = false
UI.CmdTemplate.Parent = UI.CmdsList

UI.CmdTemplateCorner = Instance.new("UICorner")
UI.CmdTemplateCorner.CornerRadius = UDim.new(0, 4)
UI.CmdTemplateCorner.Name = "CmdTemplateCorner"
UI.CmdTemplateCorner.Parent = UI.CmdTemplate

UI.CmdTemplateLayout = Instance.new("UIListLayout")
UI.CmdTemplateLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.CmdTemplateLayout.Name = "CmdTemplateLayout"
UI.CmdTemplateLayout.Padding = UDim.new(0, 4)
UI.CmdTemplateLayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.CmdTemplateLayout.Parent = UI.CmdTemplate

UI.CmdTemplatePadding = Instance.new("UIPadding")
UI.CmdTemplatePadding.Name = "CmdTemplatePadding"
UI.CmdTemplatePadding.PaddingBottom = UDim.new(0, 4)
UI.CmdTemplatePadding.PaddingLeft = UDim.new(0, 4)
UI.CmdTemplatePadding.PaddingRight = UDim.new(0, 4)
UI.CmdTemplatePadding.PaddingTop = UDim.new(0, 4)
UI.CmdTemplatePadding.Parent = UI.CmdTemplate

UI.CmdTitle = Instance.new("TextLabel")
UI.CmdTitle.AutomaticSize = Enum.AutomaticSize.Y
UI.CmdTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.CmdTitle.BackgroundTransparency = 1
UI.CmdTitle.BorderSizePixel = 0
UI.CmdTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
UI.CmdTitle.LayoutOrder = 1
UI.CmdTitle.Name = "CmdTitle"
UI.CmdTitle.Size = UDim2.new(1, 0, 0, 0)
UI.CmdTitle.Text = "Teleport Player (tp, goto, to)"
UI.CmdTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
UI.CmdTitle.TextSize = 24
UI.CmdTitle.TextWrapped = true
UI.CmdTitle.TextXAlignment = Enum.TextXAlignment.Left
UI.CmdTitle.Parent = UI.CmdTemplate

UI.CmdDescription = Instance.new("TextLabel")
UI.CmdDescription.AutomaticSize = Enum.AutomaticSize.Y
UI.CmdDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.CmdDescription.BackgroundTransparency = 1
UI.CmdDescription.BorderSizePixel = 0
UI.CmdDescription.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
UI.CmdDescription.LayoutOrder = 2
UI.CmdDescription.Name = "CmdDescription"
UI.CmdDescription.Size = UDim2.new(1, 0, 0, 0)
UI.CmdDescription.Text = "Teleports you to another player."
UI.CmdDescription.TextColor3 = Color3.fromRGB(200, 200, 200)
UI.CmdDescription.TextSize = 16
UI.CmdDescription.TextWrapped = true
UI.CmdDescription.TextXAlignment = Enum.TextXAlignment.Left
UI.CmdDescription.TextYAlignment = Enum.TextYAlignment.Top
UI.CmdDescription.Parent = UI.CmdTemplate

UI.Topbar = Instance.new("Frame")
UI.Topbar.Active = true
UI.Topbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.Topbar.BackgroundTransparency = 1
UI.Topbar.BorderSizePixel = 0
UI.Topbar.LayoutOrder = 1
UI.Topbar.Name = "Topbar"
UI.Topbar.Size = UDim2.new(1, 0, 0, 34)
UI.Topbar.Parent = UI.CmdsFrame

UI.TopbarConstraint = Instance.new("UISizeConstraint")
UI.TopbarConstraint.MaxSize = Vector2.new(9999, 34)
UI.TopbarConstraint.Name = "TopbarConstraint"
UI.TopbarConstraint.Parent = UI.Topbar

UI.TopbarLayout = Instance.new("UIListLayout")
UI.TopbarLayout.FillDirection = Enum.FillDirection.Horizontal
UI.TopbarLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.TopbarLayout.Name = "TopbarLayout"
UI.TopbarLayout.Padding = UDim.new(0, 4)
UI.TopbarLayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.TopbarLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
UI.TopbarLayout.Parent = UI.Topbar

UI.TopbarPadding = Instance.new("UIPadding")
UI.TopbarPadding.Name = "TopbarPadding"
UI.TopbarPadding.PaddingBottom = UDim.new(0, 4)
UI.TopbarPadding.PaddingLeft = UDim.new(0, 4)
UI.TopbarPadding.PaddingRight = UDim.new(0, 4)
UI.TopbarPadding.PaddingTop = UDim.new(0, 4)
UI.TopbarPadding.Parent = UI.Topbar

UI.TopbarStroke = Instance.new("UIStroke")
UI.TopbarStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.TopbarStroke.Color = Color3.fromRGB(255, 255, 255)
UI.TopbarStroke.Name = "TopbarStroke"
UI.TopbarStroke.Parent = UI.Topbar

UI.TopbarTitle = Instance.new("TextLabel")
UI.TopbarTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.TopbarTitle.BackgroundTransparency = 1
UI.TopbarTitle.BorderSizePixel = 0
UI.TopbarTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI.TopbarTitle.LayoutOrder = 1
UI.TopbarTitle.Name = "Title"
UI.TopbarTitle.Size = UDim2.new(0.2, 0, 0.3, 0)
UI.TopbarTitle.Text = "SimpleCMDS • Commands"
UI.TopbarTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
UI.TopbarTitle.TextScaled = true
UI.TopbarTitle.TextWrapped = true
UI.TopbarTitle.TextXAlignment = Enum.TextXAlignment.Left
UI.TopbarTitle.Parent = UI.Topbar

UI.Close = Instance.new("TextButton")
UI.Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.Close.BorderSizePixel = 0
UI.Close.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI.Close.LayoutOrder = 2
UI.Close.Name = "Close"
UI.Close.Size = UDim2.new(0.2, 0, 0.3, 0)
UI.Close.Text = "×"
UI.Close.TextColor3 = Color3.fromRGB(0, 0, 0)
UI.Close.TextScaled = true
UI.Close.TextWrapped = true
UI.Close.Parent = UI.Topbar

UI.CloseCorner = Instance.new("UICorner")
UI.CloseCorner.CornerRadius = UDim.new(0, 4)
UI.CloseCorner.Name = "CloseCorner"
UI.CloseCorner.Parent = UI.Close

UI.CloseRatio = Instance.new("UIAspectRatioConstraint")
UI.CloseRatio.Name = "CloseRatio"
UI.CloseRatio.Parent = UI.Close

local function Tween(Object, Speed, Properties, EasingStyle, EasingDirection)
    EasingStyle = EasingStyle or "Quad"
    EasingDirection = EasingDirection or "Out"
    local Info = TweenInfo.new(Speed, Enum.EasingStyle[EasingStyle], Enum.EasingDirection[EasingDirection])
    return TweenService:Create(Object, Info, Properties)
end

local ShadowFullSize = UDim2.new(1.059, 0, 1.088, 0)
local ShadowSmallSize = UDim2.new(1.059 * 0.9, 0, 1.088 * 0.9, 0)

local IsOpen = false
local Dragging = false
local DragStart = nil
local StartPos = nil

local function ClampPosition(TargetPosition)
    local ScreenSize = UI.ScreenGui.AbsoluteSize
    local ElementSize = UI.CmdsUI.AbsoluteSize
    local MaxX = math.max(0, ScreenSize.X - ElementSize.X)
    local MaxY = math.max(0, ScreenSize.Y - ElementSize.Y)
    local ClampedX = math.clamp(TargetPosition.X.Offset, 0, MaxX)
    local ClampedY = math.clamp(TargetPosition.Y.Offset, 0, MaxY)
    return UDim2.new(0, ClampedX, 0, ClampedY)
end

UI.Topbar.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = Input.Position
        StartPos = UI.CmdsUI.Position
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if not Dragging then return end
    if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
        local Delta = Input.Position - DragStart
        local TargetPosition = UDim2.new(
            StartPos.X.Scale, StartPos.X.Offset + Delta.X,
            StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y
        )
        UI.CmdsUI.Position = ClampPosition(TargetPosition)
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = false
    end
end)

local function ClearCommandEntries()
    for _, Child in ipairs(UI.CmdsList:GetChildren()) do
        if Child:IsA("Frame") and Child ~= UI.CmdTemplate then
            Child:Destroy()
        end
    end
end

local function FormatCommandTitle(Command, CurrentPrefix)
    local Primary = CurrentPrefix .. Command.Aliases[1]
    if #Command.Aliases > 1 then
        local Extra = {}
        for i = 2, #Command.Aliases do
            table.insert(Extra, CurrentPrefix .. Command.Aliases[i])
        end
        return Primary .. " (" .. table.concat(Extra, ", ") .. ")"
    end
    return Primary
end

local function PopulateCommands()
    ClearCommandEntries()

    local CurrentPrefix = GetPrefix()

    local SortedCommands = {}
    for _, Command in ipairs(CommandRegistry) do
        table.insert(SortedCommands, Command)
    end

    table.sort(SortedCommands, function(a, b)
        return a.Aliases[1]:lower() < b.Aliases[1]:lower()
    end)

    for Index, Command in ipairs(SortedCommands) do
        local Entry = UI.CmdTemplate:Clone()
        Entry.CmdTitle.Text = FormatCommandTitle(Command, CurrentPrefix)
        Entry.CmdDescription.Text = Command.Description .. "\nUsage: " .. CurrentPrefix .. Command.Usage
        Entry.LayoutOrder = Index
        Entry.Visible = true
        Entry.Parent = UI.CmdsList
    end
end

local function ShowCommands()
    if IsOpen then return end
    IsOpen = true

    UI.CmdsUI.Visible = true
    UI.CmdsFrame.GroupTransparency = 1
    UI.CmdsFrame.Size = UDim2.new(0.9, 0, 0.9, 0)
    UI.CmdsShadow.ImageTransparency = 1
    UI.CmdsShadow.Size = ShadowSmallSize

    PopulateCommands()

    local T1 = Tween(UI.CmdsFrame, 0.35, { GroupTransparency = 0, Size = UDim2.new(1, 0, 1, 0) }, "Back", "Out")
    local T2 = Tween(UI.CmdsShadow, 0.35, { ImageTransparency = 0, Size = ShadowFullSize }, "Back", "Out")

    T1:Play()
    T2:Play()
end

local function HideCommands()
    if not IsOpen then return end
    IsOpen = false

    local HideTween = Tween(UI.CmdsFrame, 0.25, { GroupTransparency = 1, Size = UDim2.new(0.9, 0, 0.9, 0) }, "Quad", "In")
    local ShadowTween = Tween(UI.CmdsShadow, 0.25, { ImageTransparency = 1, Size = ShadowSmallSize }, "Quad", "In")

    ShadowTween:Play()
    HideTween:Play()

    task.spawn(function()
        HideTween.Completed:Wait()
        UI.CmdsUI.Visible = false
    end)
end

UI.Close.MouseButton1Click:Connect(function()
    HideCommands()
end)

Cmd.Reg(Cmd.new({"commands", "cmds"}, "Opens a scrollable list of all available commands.", "commands", function(Args)
    if IsOpen then
        HideCommands()
    else
        ShowCommands()
    end
end))