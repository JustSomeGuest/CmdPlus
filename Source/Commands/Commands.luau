local UI = {}

local function Try(label, fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then
        warn("[SimpleCMDS] " .. label .. ": " .. tostring(err))
    end
    return ok
end

Try("ScreenGui creation", function()
    UI.ScreenGui = Instance.new("ScreenGui", Hui)
    UI.ScreenGui.DisplayOrder = 100
    UI.ScreenGui.Name = "SimpleCMDS"
    UI.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    UI.ScreenGui.ResetOnSpawn = false
end)

Try("CmdsUI creation", function()
    UI.CmdsUI = Instance.new("Frame", UI.ScreenGui)
    UI.CmdsUI.BorderSizePixel = 0
    UI.CmdsUI.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    UI.CmdsUI.Size = UDim2.new(0.5, 0, 0.8, 0)
    UI.CmdsUI.Position = UDim2.new(0, 16, 0, 6)
    UI.CmdsUI.Name = "CmdsUI"
    UI.CmdsUI.BackgroundTransparency = 1
    UI.CmdsUI.Visible = false
end)

Try("CmdsShadow creation", function()
    UI.CmdsShadow = Instance.new("ImageLabel", UI.CmdsUI)
    UI.CmdsShadow.BorderSizePixel = 0
    UI.CmdsShadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    UI.CmdsShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    UI.CmdsShadow.Image = "rbxassetid://15298624572"
    UI.CmdsShadow.Size = UDim2.new(1.059, 0, 1.088, 0)
    UI.CmdsShadow.BackgroundTransparency = 1
    UI.CmdsShadow.Name = "CmdsShadow"
    UI.CmdsShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
end)

Try("CmdsFrame creation", function()
    UI.CmdsFrame = Instance.new("CanvasGroup", UI.CmdsUI)
    UI.CmdsFrame.BorderSizePixel = 0
    UI.CmdsFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    UI.CmdsFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    UI.CmdsFrame.Size = UDim2.new(1, 0, 1, 0)
    UI.CmdsFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    UI.CmdsFrame.Name = "CmdsFrame"

    UI.CmdsFrameCorner = Instance.new("UICorner", UI.CmdsFrame)
    UI.CmdsFrameCorner.Name = "CmdsFrameCorner"
    UI.CmdsFrameCorner.CornerRadius = UDim.new(0, 4)
end)

Try("CmdsContainer creation", function()
    UI.CmdsContainer = Instance.new("Frame", UI.CmdsFrame)
    UI.CmdsContainer.BorderSizePixel = 0
    UI.CmdsContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    UI.CmdsContainer.Size = UDim2.new(1, 0, 1, 0)
    UI.CmdsContainer.Name = "CmdsContainer"
    UI.CmdsContainer.LayoutOrder = 2
    UI.CmdsContainer.BackgroundTransparency = 1

    UI.CmdsContainerPadding = Instance.new("UIPadding", UI.CmdsContainer)
    UI.CmdsContainerPadding.PaddingTop = UDim.new(0, 4)
    UI.CmdsContainerPadding.PaddingRight = UDim.new(0, 4)
    UI.CmdsContainerPadding.Name = "CmdsContainerPadding"
    UI.CmdsContainerPadding.PaddingLeft = UDim.new(0, 4)
    UI.CmdsContainerPadding.PaddingBottom = UDim.new(0, 4)
end)

Try("CmdsList creation", function()
    UI.CmdsList = Instance.new("ScrollingFrame", UI.CmdsContainer)
    UI.CmdsList.ScrollingDirection = Enum.ScrollingDirection.Y
    UI.CmdsList.BorderSizePixel = 0
    UI.CmdsList.CanvasSize = UDim2.new(0, 0, 0, 0)
    UI.CmdsList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    UI.CmdsList.Name = "CmdsList"
    UI.CmdsList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    UI.CmdsList.Size = UDim2.new(1, 0, 1, 0)
    UI.CmdsList.ScrollBarThickness = 4
    UI.CmdsList.BackgroundTransparency = 0.9

    UI.CmdsListLayout = Instance.new("UIListLayout", UI.CmdsList)
    UI.CmdsListLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
    UI.CmdsListLayout.Padding = UDim.new(0, 6)
    UI.CmdsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UI.CmdsListLayout.Name = "CmdsListLayout"

    UI.CmdsListCorner = Instance.new("UICorner", UI.CmdsList)
    UI.CmdsListCorner.Name = "CmdsListCorner"
    UI.CmdsListCorner.CornerRadius = UDim.new(0, 4)

    UI.CmdsListPadding = Instance.new("UIPadding", UI.CmdsList)
    UI.CmdsListPadding.PaddingTop = UDim.new(0, 4)
    UI.CmdsListPadding.PaddingRight = UDim.new(0, 8)
    UI.CmdsListPadding.Name = "CmdsListPadding"
    UI.CmdsListPadding.PaddingLeft = UDim.new(0, 4)
    UI.CmdsListPadding.PaddingBottom = UDim.new(0, 4)
end)

Try("CmdTemplate creation", function()
    UI.CmdTemplate = Instance.new("Frame", UI.CmdsList)
    UI.CmdTemplate.Visible = false
    UI.CmdTemplate.BorderSizePixel = 0
    UI.CmdTemplate.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    UI.CmdTemplate.AutomaticSize = Enum.AutomaticSize.Y
    UI.CmdTemplate.Size = UDim2.new(0, 80, 0, 0)
    UI.CmdTemplate.Position = UDim2.new(0, 434, 0, -14)
    UI.CmdTemplate.Name = "CmdTemplate"
    UI.CmdTemplate.BackgroundTransparency = 0.95

    UI.CmdTemplateCorner = Instance.new("UICorner", UI.CmdTemplate)
    UI.CmdTemplateCorner.Name = "CmdTemplateCorner"
    UI.CmdTemplateCorner.CornerRadius = UDim.new(0, 4)

    UI.CmdDescription = Instance.new("TextLabel", UI.CmdTemplate)
    UI.CmdDescription.TextWrapped = true
    UI.CmdDescription.BorderSizePixel = 0
    UI.CmdDescription.TextSize = 16
    UI.CmdDescription.TextXAlignment = Enum.TextXAlignment.Left
    UI.CmdDescription.TextYAlignment = Enum.TextYAlignment.Top
    UI.CmdDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    UI.CmdDescription.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    UI.CmdDescription.TextColor3 = Color3.fromRGB(200, 200, 200)
    UI.CmdDescription.BackgroundTransparency = 1
    UI.CmdDescription.Size = UDim2.new(1, 0, 0, 0)
    UI.CmdDescription.Text = "Teleports you to another player."
    UI.CmdDescription.LayoutOrder = 2
    UI.CmdDescription.AutomaticSize = Enum.AutomaticSize.Y
    UI.CmdDescription.Name = "CmdDescription"

    UI.CmdTemplatePadding = Instance.new("UIPadding", UI.CmdTemplate)
    UI.CmdTemplatePadding.PaddingTop = UDim.new(0, 4)
    UI.CmdTemplatePadding.PaddingRight = UDim.new(0, 4)
    UI.CmdTemplatePadding.Name = "CmdTemplatePadding"
    UI.CmdTemplatePadding.PaddingLeft = UDim.new(0, 4)
    UI.CmdTemplatePadding.PaddingBottom = UDim.new(0, 4)

    UI.CmdTemplateLayout = Instance.new("UIListLayout", UI.CmdTemplate)
    UI.CmdTemplateLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
    UI.CmdTemplateLayout.Padding = UDim.new(0, 4)
    UI.CmdTemplateLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UI.CmdTemplateLayout.Name = "CmdTemplateLayout"

    UI.CmdTitle = Instance.new("TextLabel", UI.CmdTemplate)
    UI.CmdTitle.TextWrapped = true
    UI.CmdTitle.BorderSizePixel = 0
    UI.CmdTitle.TextSize = 24
    UI.CmdTitle.TextXAlignment = Enum.TextXAlignment.Left
    UI.CmdTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    UI.CmdTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    UI.CmdTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    UI.CmdTitle.BackgroundTransparency = 1
    UI.CmdTitle.Size = UDim2.new(1, 0, 0, 0)
    UI.CmdTitle.Text = "Teleport Player (tp, goto, to)"
    UI.CmdTitle.LayoutOrder = 1
    UI.CmdTitle.AutomaticSize = Enum.AutomaticSize.Y
    UI.CmdTitle.Name = "CmdTitle"
end)

Try("Topbar creation", function()
    UI.Topbar = Instance.new("Frame", UI.CmdsFrame)
    UI.Topbar.BorderSizePixel = 0
    UI.Topbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    UI.Topbar.Size = UDim2.new(1, 0, 0, 34)
    UI.Topbar.Name = "Topbar"
    UI.Topbar.LayoutOrder = 1
    UI.Topbar.BackgroundTransparency = 1
    UI.Topbar.Active = true

    UI.TopbarLayout = Instance.new("UIListLayout", UI.Topbar)
    UI.TopbarLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
    UI.TopbarLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
    UI.TopbarLayout.Padding = UDim.new(0, 4)
    UI.TopbarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UI.TopbarLayout.Name = "TopbarLayout"
    UI.TopbarLayout.FillDirection = Enum.FillDirection.Horizontal

    UI.Close = Instance.new("TextButton", UI.Topbar)
    UI.Close.TextWrapped = true
    UI.Close.BorderSizePixel = 0
    UI.Close.TextScaled = true
    UI.Close.TextColor3 = Color3.fromRGB(0, 0, 0)
    UI.Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    UI.Close.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    UI.Close.Size = UDim2.new(0.2, 0, 0.3, 0)
    UI.Close.LayoutOrder = 2
    UI.Close.Text = "×"
    UI.Close.Name = "Close"

    UI.CloseCorner = Instance.new("UICorner", UI.Close)
    UI.CloseCorner.Name = "CloseCorner"
    UI.CloseCorner.CornerRadius = UDim.new(0, 4)

    UI.CloseRatio = Instance.new("UIAspectRatioConstraint", UI.Close)
    UI.CloseRatio.Name = "CloseRatio"

    UI.TopbarTitle = Instance.new("TextLabel", UI.Topbar)
    UI.TopbarTitle.TextWrapped = true
    UI.TopbarTitle.BorderSizePixel = 0
    UI.TopbarTitle.TextXAlignment = Enum.TextXAlignment.Left
    UI.TopbarTitle.TextScaled = true
    UI.TopbarTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    UI.TopbarTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    UI.TopbarTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    UI.TopbarTitle.BackgroundTransparency = 1
    UI.TopbarTitle.Size = UDim2.new(0.2, 0, 0.3, 0)
    UI.TopbarTitle.Text = "SimpleCMDS • Commands"
    UI.TopbarTitle.LayoutOrder = 1
    UI.TopbarTitle.Name = "Title"

    UI.TopbarStroke = Instance.new("UIStroke", UI.Topbar)
    UI.TopbarStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UI.TopbarStroke.Name = "TopbarStroke"
    UI.TopbarStroke.Color = Color3.fromRGB(255, 255, 255)

    UI.TopbarPadding = Instance.new("UIPadding", UI.Topbar)
    UI.TopbarPadding.PaddingTop = UDim.new(0, 4)
    UI.TopbarPadding.PaddingRight = UDim.new(0, 4)
    UI.TopbarPadding.Name = "TopbarPadding"
    UI.TopbarPadding.PaddingLeft = UDim.new(0, 4)
    UI.TopbarPadding.PaddingBottom = UDim.new(0, 4)

    UI.TopbarConstraint = Instance.new("UISizeConstraint", UI.Topbar)
    UI.TopbarConstraint.Name = "TopbarConstraint"
    UI.TopbarConstraint.MaxSize = Vector2.new(9999, 34)
end)

Try("CmdsFrame layout/stroke creation", function()
    UI.CmdsFrameStroke = Instance.new("UIStroke", UI.CmdsFrame)
    UI.CmdsFrameStroke.Name = "CmdsFrameStroke"
    UI.CmdsFrameStroke.Color = Color3.fromRGB(255, 255, 255)

    UI.CmdsFrameLayout = Instance.new("UIListLayout", UI.CmdsFrame)
    UI.CmdsFrameLayout.Padding = UDim.new(0, 2)
    UI.CmdsFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UI.CmdsFrameLayout.Name = "CmdsFrameLayout"
    UI.CmdsFrameLayout.FillDirection = Enum.FillDirection.Vertical
end)

local function Tween(Object, Speed, Properties, EasingStyle, EasingDirection)
    local ok, result = pcall(function()
        EasingStyle = EasingStyle or "Quad"
        EasingDirection = EasingDirection or "Out"
        local Info = TweenInfo.new(Speed, Enum.EasingStyle[EasingStyle], Enum.EasingDirection[EasingDirection])
        return TweenService:Create(Object, Info, Properties)
    end)
    if not ok then
        warn("[SimpleCMDS] Tween creation failed: " .. tostring(result))
        return nil
    end
    return result
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

Try("Drag InputBegan connect", function()
    UI.Topbar.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = Input.Position
            StartPos = UI.CmdsUI.Position
        end
    end)
end)

Try("Drag InputChanged connect", function()
    UserInputService.InputChanged:Connect(function(Input)
        if not Dragging then return end
        if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
            local ok, err = pcall(function()
                local Delta = Input.Position - DragStart
                local TargetPosition = UDim2.new(
                    StartPos.X.Scale, StartPos.X.Offset + Delta.X,
                    StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y
                )
                UI.CmdsUI.Position = ClampPosition(TargetPosition)
            end)
            if not ok then
                warn("[SimpleCMDS] Drag move error: " .. tostring(err))
            end
        end
    end)
end)

Try("Drag InputEnded connect", function()
    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)
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
    local ok, err = pcall(function()
        ClearCommandEntries()

        local CurrentPrefix = GetPrefix()
        warn("[SimpleCMDS] PopulateCommands: prefix=" .. tostring(CurrentPrefix) .. " registry size=" .. tostring(#CommandRegistry))

        local SortedCommands = {}
        for _, Command in ipairs(CommandRegistry) do
            table.insert(SortedCommands, Command)
        end

        table.sort(SortedCommands, function(a, b)
            return a.Aliases[1]:lower() < b.Aliases[1]:lower()
        end)

        for Index, Command in ipairs(SortedCommands) do
            local ok2, err2 = pcall(function()
                local Entry = UI.CmdTemplate:Clone()
                Entry.CmdTitle.Text = FormatCommandTitle(Command, CurrentPrefix)
                Entry.CmdDescription.Text = Command.Description .. "\nUsage: " .. CurrentPrefix .. Command.Usage
                Entry.LayoutOrder = Index
                Entry.Visible = true
                Entry.Parent = UI.CmdsList
            end)
            if not ok2 then
                warn("[SimpleCMDS] PopulateCommands failed on entry " .. tostring(Index) .. " (" .. tostring(Command.Aliases[1]) .. "): " .. tostring(err2))
            end
        end
    end)
    if not ok then
        warn("[SimpleCMDS] PopulateCommands outer error: " .. tostring(err))
    end
end

local function ShowCommands()
    warn("[SimpleCMDS] ShowCommands called, IsOpen=" .. tostring(IsOpen))
    if IsOpen then return end
    IsOpen = true

    local ok, err = pcall(function()
        UI.CmdsUI.Visible = true
        UI.CmdsFrame.GroupTransparency = 1
        UI.CmdsFrame.Size = UDim2.new(0.9, 0, 0.9, 0)
        UI.CmdsShadow.ImageTransparency = 1
        UI.CmdsShadow.Size = ShadowSmallSize
    end)
    if not ok then
        warn("[SimpleCMDS] ShowCommands visibility setup error: " .. tostring(err))
    end

    PopulateCommands()

    local T1 = Tween(UI.CmdsFrame, 0.35, { GroupTransparency = 0, Size = UDim2.new(1, 0, 1, 0) }, "Back", "Out")
    local T2 = Tween(UI.CmdsShadow, 0.35, { ImageTransparency = 0, Size = ShadowFullSize }, "Back", "Out")

    if T1 then
        local ok2, err2 = pcall(function() T1:Play() end)
        if not ok2 then warn("[SimpleCMDS] ShowCommands T1 play error: " .. tostring(err2)) end
    else
        warn("[SimpleCMDS] ShowCommands T1 is nil, skipping play")
    end
    if T2 then
        local ok3, err3 = pcall(function() T2:Play() end)
        if not ok3 then warn("[SimpleCMDS] ShowCommands T2 play error: " .. tostring(err3)) end
    else
        warn("[SimpleCMDS] ShowCommands T2 is nil, skipping play")
    end
end

local function HideCommands()
    warn("[SimpleCMDS] HideCommands called, IsOpen=" .. tostring(IsOpen))
    if not IsOpen then return end
    IsOpen = false

    local HideTween = Tween(UI.CmdsFrame, 0.25, { GroupTransparency = 1, Size = UDim2.new(0.9, 0, 0.9, 0) }, "Quad", "In")
    local ShadowTween = Tween(UI.CmdsShadow, 0.25, { ImageTransparency = 1, Size = ShadowSmallSize }, "Quad", "In")

    if ShadowTween then
        local ok, err = pcall(function() ShadowTween:Play() end)
        if not ok then warn("[SimpleCMDS] HideCommands shadow tween error: " .. tostring(err)) end
    end

    if HideTween then
        local ok, err = pcall(function() HideTween:Play() end)
        if not ok then warn("[SimpleCMDS] HideCommands frame tween error: " .. tostring(err)) end
        task.spawn(function()
            local ok2, err2 = pcall(function() HideTween.Completed:Wait() end)
            if not ok2 then warn("[SimpleCMDS] HideCommands Completed wait error: " .. tostring(err2)) end
            UI.CmdsUI.Visible = false
        end)
    else
        warn("[SimpleCMDS] HideCommands HideTween is nil, hiding immediately")
        UI.CmdsUI.Visible = false
    end
end

Try("Close button connect", function()
    UI.Close.MouseButton1Click:Connect(function()
        local ok, err = pcall(HideCommands)
        if not ok then warn("[SimpleCMDS] Close button error: " .. tostring(err)) end
    end)
end)

Try("commands/cmds Cmd.Reg", function()
    Cmd.Reg(Cmd.new({"commands", "cmds"}, "Opens a scrollable list of all available commands.", "commands", function(Args)
        local ok, err = pcall(function()
            if IsOpen then
                HideCommands()
            else
                ShowCommands()
            end
        end)
        if not ok then
            warn("[SimpleCMDS] commands callback error: " .. tostring(err))
        end
    end))
end)

warn("[SimpleCMDS] Commands.luau loaded successfully")