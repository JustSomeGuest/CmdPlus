CmdPlusUI:GetPropertyChangedSignal("Enabled"):Connect(function()
    if not CmdPlusUI.Enabled then
        CmdPlusUI.Enabled = true
    end
end)

local UI = {}

UI.CmdsUI = Instance.new("CanvasGroup")
UI.CmdsUI.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
UI.CmdsUI.BackgroundTransparency = 0
UI.CmdsUI.BorderSizePixel = 0
UI.CmdsUI.Name = UID(32)
UI.CmdsUI.Position = UDim2.new(0, 16, 0, 6)
UI.CmdsUI.Size = UDim2.new(0.5, 0, 0.8, 0)
UI.CmdsUI.Visible = false
UI.CmdsUI.Parent = CmdPlusUI

UI.CmdsUICorner = Instance.new("UICorner")
UI.CmdsUICorner.CornerRadius = UDim.new(0, 4)
UI.CmdsUICorner.Name = UID(32)
UI.CmdsUICorner.Parent = UI.CmdsUI

UI.CmdsUILayout = Instance.new("UIListLayout")
UI.CmdsUILayout.FillDirection = Enum.FillDirection.Vertical
UI.CmdsUILayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.CmdsUILayout.ItemLineAlignment = Enum.ItemLineAlignment.Automatic
UI.CmdsUILayout.Name = UID(32)
UI.CmdsUILayout.Padding = UDim.new(0, 2)
UI.CmdsUILayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.CmdsUILayout.VerticalFlex = Enum.UIFlexAlignment.Fill
UI.CmdsUILayout.Parent = UI.CmdsUI

UI.CmdsUIStroke = Instance.new("UIStroke")
UI.CmdsUIStroke.Color = Color3.fromRGB(255, 255, 255)
UI.CmdsUIStroke.Name = UID(32)
UI.CmdsUIStroke.Parent = UI.CmdsUI

UI.Shadow = Instance.new("UIShadow")
UI.Shadow.BlurRadius = UDim.new(0, 24)
UI.Shadow.Color = Color3.fromRGB(255, 255, 255)
UI.Shadow.Name = UID(32)
UI.Shadow.Offset = UDim2.fromOffset(0, 0)
UI.Shadow.Spread = UDim2.fromOffset(7, 7)
UI.Shadow.Transparency = 0.25
UI.Shadow.Parent = UI.CmdsUI

UI.CmdsContainer = Instance.new("Frame")
UI.CmdsContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.CmdsContainer.BackgroundTransparency = 1
UI.CmdsContainer.BorderSizePixel = 0
UI.CmdsContainer.LayoutOrder = 2
UI.CmdsContainer.Name = UID(32)
UI.CmdsContainer.Size = UDim2.new(1, 0, 1, 0)
UI.CmdsContainer.Parent = UI.CmdsUI

UI.CmdsContainerPadding = Instance.new("UIPadding")
UI.CmdsContainerPadding.Name = UID(32)
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
UI.CmdsList.Name = UID(32)
UI.CmdsList.ScrollBarThickness = 4
UI.CmdsList.ScrollingDirection = Enum.ScrollingDirection.Y
UI.CmdsList.Size = UDim2.new(1, 0, 1, 0)
UI.CmdsList.Parent = UI.CmdsContainer

UI.CmdsListCorner = Instance.new("UICorner")
UI.CmdsListCorner.CornerRadius = UDim.new(0, 4)
UI.CmdsListCorner.Name = UID(32)
UI.CmdsListCorner.Parent = UI.CmdsList

UI.CmdsListLayout = Instance.new("UIListLayout")
UI.CmdsListLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.CmdsListLayout.Name = UID(32)
UI.CmdsListLayout.Padding = UDim.new(0, 6)
UI.CmdsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.CmdsListLayout.Parent = UI.CmdsList

UI.CmdsListPadding = Instance.new("UIPadding")
UI.CmdsListPadding.Name = UID(32)
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
UI.CmdTemplate.Name = UID(32)
UI.CmdTemplate.Size = UDim2.new(0, 80, 0, 0)
UI.CmdTemplate.Visible = false
UI.CmdTemplate.Parent = UI.CmdsList

UI.CmdTemplateCorner = Instance.new("UICorner")
UI.CmdTemplateCorner.CornerRadius = UDim.new(0, 4)
UI.CmdTemplateCorner.Name = UID(32)
UI.CmdTemplateCorner.Parent = UI.CmdTemplate

UI.CmdTemplateLayout = Instance.new("UIListLayout")
UI.CmdTemplateLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.CmdTemplateLayout.Name = UID(32)
UI.CmdTemplateLayout.Padding = UDim.new(0, 4)
UI.CmdTemplateLayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.CmdTemplateLayout.Parent = UI.CmdTemplate

UI.CmdTemplatePadding = Instance.new("UIPadding")
UI.CmdTemplatePadding.Name = UID(32)
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
UI.CmdTitle.Name = UID(32)
UI.CmdTitle.Size = UDim2.new(1, 0, 0, 0)
UI.CmdTitle.Text = "Command (Command Alias)"
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
UI.CmdDescription.Name = UID(32)
UI.CmdDescription.Size = UDim2.new(1, 0, 0, 0)
UI.CmdDescription.Text = "Command Description."
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
UI.Topbar.Name = UID(32)
UI.Topbar.Size = UDim2.new(1, 0, 0, 34)
UI.Topbar.Parent = UI.CmdsUI

UI.TopbarConstraint = Instance.new("UISizeConstraint")
UI.TopbarConstraint.MaxSize = Vector2.new(9999, 34)
UI.TopbarConstraint.Name = UID(32)
UI.TopbarConstraint.Parent = UI.Topbar

UI.TopbarLayout = Instance.new("UIListLayout")
UI.TopbarLayout.FillDirection = Enum.FillDirection.Horizontal
UI.TopbarLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.TopbarLayout.Name = UID(32)
UI.TopbarLayout.Padding = UDim.new(0, 4)
UI.TopbarLayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.TopbarLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
UI.TopbarLayout.Parent = UI.Topbar

UI.TopbarPadding = Instance.new("UIPadding")
UI.TopbarPadding.Name = UID(32)
UI.TopbarPadding.PaddingBottom = UDim.new(0, 4)
UI.TopbarPadding.PaddingLeft = UDim.new(0, 4)
UI.TopbarPadding.PaddingRight = UDim.new(0, 4)
UI.TopbarPadding.PaddingTop = UDim.new(0, 4)
UI.TopbarPadding.Parent = UI.Topbar

UI.TopbarStroke = Instance.new("UIStroke")
UI.TopbarStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.TopbarStroke.Color = Color3.fromRGB(255, 255, 255)
UI.TopbarStroke.Name = UID(32)
UI.TopbarStroke.Parent = UI.Topbar

UI.LogoFrame = Instance.new("Frame")
UI.LogoFrame.BackgroundTransparency = 1
UI.LogoFrame.BorderSizePixel = 0
UI.LogoFrame.LayoutOrder = 1
UI.LogoFrame.Size = UDim2.new(1, 0, 1, 0)
UI.LogoFrame.Parent = UI.Topbar

UI.LogoFrameRatio = Instance.new("UIAspectRatioConstraint")
UI.LogoFrameRatio.Parent = UI.LogoFrame

UI.Logo = Instance.new("ImageLabel")
UI.Logo.AnchorPoint = Vector2.new(0.5, 0.5)
UI.Logo.BackgroundTransparency = 1
UI.Logo.BorderSizePixel = 0
UI.Logo.Image = GetAsset("CmdPlus/Assets/CmdPlus_Logo.png")
UI.Logo.Position = UDim2.new(0.5, 0, 0.5, 0)
UI.Logo.Size = UDim2.new(1, 8, 1, 8)
UI.Logo.Parent = UI.LogoFrame

UI.TopbarTitle = Instance.new("TextLabel")
UI.TopbarTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.TopbarTitle.BackgroundTransparency = 1
UI.TopbarTitle.BorderSizePixel = 0
UI.TopbarTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI.TopbarTitle.LayoutOrder = 2
UI.TopbarTitle.Name = UID(32)
UI.TopbarTitle.Size = UDim2.new(1,0,1,0)
UI.TopbarTitle.Text = "CmdPlus • Commands"
UI.TopbarTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
UI.TopbarTitle.TextScaled = true
UI.TopbarTitle.TextWrapped = true
UI.TopbarTitle.TextXAlignment = Enum.TextXAlignment.Left
UI.TopbarTitle.Parent = UI.Topbar

UI.Close = Instance.new("TextButton")
UI.Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.Close.BorderSizePixel = 0
UI.Close.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI.Close.LayoutOrder = 3
UI.Close.Name = UID(32)
UI.Close.Size = UDim2.new(1,0,1,0)
UI.Close.Text = "×"
UI.Close.TextColor3 = Color3.fromRGB(0, 0, 0)
UI.Close.TextScaled = true
UI.Close.TextWrapped = true
UI.Close.Parent = UI.Topbar

UI.CloseCorner = Instance.new("UICorner")
UI.CloseCorner.CornerRadius = UDim.new(0, 4)
UI.CloseCorner.Name = UID(32)
UI.CloseCorner.Parent = UI.Close

UI.CloseRatio = Instance.new("UIAspectRatioConstraint")
UI.CloseRatio.Name = UID(32)
UI.CloseRatio.Parent = UI.Close

local function Tween(Object, Speed, Properties, EasingStyle, EasingDirection)
    EasingStyle = EasingStyle or "Quad"
    EasingDirection = EasingDirection or "Out"
    local Info = TweenInfo.new(Speed, Enum.EasingStyle[EasingStyle], Enum.EasingDirection[EasingDirection])
    return TweenService:Create(Object, Info, Properties)
end

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
    for _, Command in ipairs(CmdRegistry) do
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
    UI.CmdsUI.GroupTransparency = 1
    UI.CmdsUI.Size = UDim2.new(0, 0, 0, 0)

    PopulateCommands()

    local T1 = Tween(UI.CmdsUI, 0.35, {
        GroupTransparency = 0,
        Size = UDim2.new(0.5, 0, 0.8, 0)
    }, "Back", "Out")

    T1:Play()
end

local function HideCommands()
    if not IsOpen then return end
    IsOpen = false

    local HideTween = Tween(UI.CmdsUI, 0.25, {
        GroupTransparency = 1,
        Size = UDim2.new(0, 0, 0, 0)
    }, "Quad", "In")

    HideTween:Play()

    task.spawn(function()
        HideTween.Completed:Wait()
        UI.CmdsUI.Visible = false
    end)
end

UI.Close.MouseButton1Click:Connect(function()
    HideCommands()
end)

Cmd.new({"commands", "cmds"}, "Opens a scrollable list of all available commands.", "commands", function(Args)
    if IsOpen then
        HideCommands()
    else
        ShowCommands()
    end
end)