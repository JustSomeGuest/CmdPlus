local UI = {}

UI["SimpleCMDS_1"] = Instance.new("ScreenGui", Hui)
UI["SimpleCMDS_1"]["DisplayOrder"] = 100
UI["SimpleCMDS_1"]["Name"] = [[SimpleCMDS]]
UI["SimpleCMDS_1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling
UI["SimpleCMDS_1"]["ResetOnSpawn"] = false


UI["CmdsUI_2"] = Instance.new("Frame", UI["SimpleCMDS_1"])
UI["CmdsUI_2"]["BorderSizePixel"] = 0
UI["CmdsUI_2"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["CmdsUI_2"]["Size"] = UDim2.new(0.5, 0, 0.8, 0)
UI["CmdsUI_2"]["Position"] = UDim2.new(0, 16, 0, 6)
UI["CmdsUI_2"]["Name"] = [[CmdsUI]]
UI["CmdsUI_2"]["BackgroundTransparency"] = 1


UI["CmdsShadow_3"] = Instance.new("ImageLabel", UI["CmdsUI_2"])
UI["CmdsShadow_3"]["BorderSizePixel"] = 0
UI["CmdsShadow_3"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255) 
UI["CmdsShadow_3"]["AnchorPoint"] = Vector2.new(0.5, 0.5)
UI["CmdsShadow_3"]["Image"] = [[rbxassetid://15298624572]]
UI["CmdsShadow_3"]["Size"] = UDim2.new(1.059, 0, 1.088, 0)
UI["CmdsShadow_3"]["BackgroundTransparency"] = 1
UI["CmdsShadow_3"]["Name"] = [[CmdsShadow]]
UI["CmdsShadow_3"]["Position"] = UDim2.new(0.5, 0, 0.5, 0)


UI["CmdsFrame_4"] = Instance.new("CanvasGroup", UI["CmdsUI_2"])
UI["CmdsFrame_4"]["BorderSizePixel"] = 0
UI["CmdsFrame_4"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
UI["CmdsFrame_4"]["AnchorPoint"] = Vector2.new(0.5, 0.5)
UI["CmdsFrame_4"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["CmdsFrame_4"]["Position"] = UDim2.new(0.5, 0, 0.5, 0)
UI["CmdsFrame_4"]["Name"] = [[CmdsFrame]]
UI["CmdsFrame_4"]["Visible"] = false


UI["CmdsFrameCorner_5"] = Instance.new("UICorner", UI["CmdsFrame_4"])
UI["CmdsFrameCorner_5"]["Name"] = [[CmdsFrameCorner]]
UI["CmdsFrameCorner_5"]["CornerRadius"] = UDim.new(0, 4)


UI["CmdsContainer_6"] = Instance.new("Frame", UI["CmdsFrame_4"])
UI["CmdsContainer_6"]["BorderSizePixel"] = 0
UI["CmdsContainer_6"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["CmdsContainer_6"]["Size"] = UDim2.new(0.2, 0, 0.3, 0)
UI["CmdsContainer_6"]["Name"] = [[CmdsContainer]]
UI["CmdsContainer_6"]["LayoutOrder"] = 2
UI["CmdsContainer_6"]["BackgroundTransparency"] = 1


UI["CmdsList_7"] = Instance.new("ScrollingFrame", UI["CmdsContainer_6"])
UI["CmdsList_7"]["ScrollingDirection"] = Enum.ScrollingDirection.Y
UI["CmdsList_7"]["BorderSizePixel"] = 0
UI["CmdsList_7"]["CanvasSize"] = UDim2.new(0, 0, 0, 0)
UI["CmdsList_7"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["CmdsList_7"]["Name"] = [[CmdsList]]
UI["CmdsList_7"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y
UI["CmdsList_7"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["CmdsList_7"]["ScrollBarThickness"] = 4
UI["CmdsList_7"]["BackgroundTransparency"] = 0.9


UI["CmdsListLayout_8"] = Instance.new("UIListLayout", UI["CmdsList_7"])
UI["CmdsListLayout_8"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["CmdsListLayout_8"]["Padding"] = UDim.new(0, 6)
UI["CmdsListLayout_8"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["CmdsListLayout_8"]["Name"] = [[CmdsListLayout]]


UI["CmdsListCorner_9"] = Instance.new("UICorner", UI["CmdsList_7"])
UI["CmdsListCorner_9"]["Name"] = [[CmdsListCorner]]
UI["CmdsListCorner_9"]["CornerRadius"] = UDim.new(0, 4)


UI["CmdsListPadding_a"] = Instance.new("UIPadding", UI["CmdsList_7"])
UI["CmdsListPadding_a"]["PaddingTop"] = UDim.new(0, 4)
UI["CmdsListPadding_a"]["PaddingRight"] = UDim.new(0, 8)
UI["CmdsListPadding_a"]["Name"] = [[CmdsListPadding]]
UI["CmdsListPadding_a"]["PaddingLeft"] = UDim.new(0, 4)
UI["CmdsListPadding_a"]["PaddingBottom"] = UDim.new(0, 4)


UI["CmdTemplate_b"] = Instance.new("Frame", UI["CmdsList_7"])
UI["CmdTemplate_b"]["Visible"] = false
UI["CmdTemplate_b"]["BorderSizePixel"] = 0
UI["CmdTemplate_b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["CmdTemplate_b"]["AutomaticSize"] = Enum.AutomaticSize.Y
UI["CmdTemplate_b"]["Size"] = UDim2.new(0, 80, 0, 0)
UI["CmdTemplate_b"]["Position"] = UDim2.new(0, 434, 0, -14)
UI["CmdTemplate_b"]["Name"] = [[CmdTemplate]]
UI["CmdTemplate_b"]["BackgroundTransparency"] = 0.95


UI["CmdTemplateCorner_c"] = Instance.new("UICorner", UI["CmdTemplate_b"])
UI["CmdTemplateCorner_c"]["Name"] = [[CmdTemplateCorner]]
UI["CmdTemplateCorner_c"]["CornerRadius"] = UDim.new(0, 4)


UI["Description_d"] = Instance.new("TextLabel", UI["CmdTemplate_b"])
UI["Description_d"]["TextWrapped"] = true
UI["Description_d"]["BorderSizePixel"] = 0
UI["Description_d"]["TextSize"] = 16
UI["Description_d"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["Description_d"]["TextYAlignment"] = Enum.TextYAlignment.Top
UI["Description_d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Description_d"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal)
UI["Description_d"]["TextColor3"] = Color3.fromRGB(200, 200, 200)
UI["Description_d"]["BackgroundTransparency"] = 1
UI["Description_d"]["Size"] = UDim2.new(1, 0, 0, 0)
UI["Description_d"]["Text"] = [[Teleports you to another player. Supports usernames, display names, and partial matches.]]
UI["Description_d"]["LayoutOrder"] = 2
UI["Description_d"]["AutomaticSize"] = Enum.AutomaticSize.Y
UI["Description_d"]["Name"] = [[Description]]


UI["CmdTemplatePadding_e"] = Instance.new("UIPadding", UI["CmdTemplate_b"])
UI["CmdTemplatePadding_e"]["PaddingTop"] = UDim.new(0, 4)
UI["CmdTemplatePadding_e"]["PaddingRight"] = UDim.new(0, 4)
UI["CmdTemplatePadding_e"]["Name"] = [[CmdTemplatePadding]]
UI["CmdTemplatePadding_e"]["PaddingLeft"] = UDim.new(0, 4)
UI["CmdTemplatePadding_e"]["PaddingBottom"] = UDim.new(0, 4)


UI["CmdTemplateLayout_f"] = Instance.new("UIListLayout", UI["CmdTemplate_b"])
UI["CmdTemplateLayout_f"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["CmdTemplateLayout_f"]["Padding"] = UDim.new(0, 4)
UI["CmdTemplateLayout_f"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["CmdTemplateLayout_f"]["Name"] = [[CmdTemplateLayout]]


UI["Title_10"] = Instance.new("TextLabel", UI["CmdTemplate_b"])
UI["Title_10"]["TextWrapped"] = true
UI["Title_10"]["BorderSizePixel"] = 0
UI["Title_10"]["TextSize"] = 24
UI["Title_10"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["Title_10"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Title_10"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal)
UI["Title_10"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["Title_10"]["BackgroundTransparency"] = 1
UI["Title_10"]["Size"] = UDim2.new(1, 0, 0, 0)
UI["Title_10"]["Text"] = [[Teleport Player (tp, goto, to)]]
UI["Title_10"]["LayoutOrder"] = 1
UI["Title_10"]["AutomaticSize"] = Enum.AutomaticSize.Y
UI["Title_10"]["Name"] = [[Title]]


UI["CmdsContainerPadding_11"] = Instance.new("UIPadding", UI["CmdsContainer_6"])
UI["CmdsContainerPadding_11"]["PaddingTop"] = UDim.new(0, 4)
UI["CmdsContainerPadding_11"]["PaddingRight"] = UDim.new(0, 4)
UI["CmdsContainerPadding_11"]["Name"] = [[CmdsContainerPadding]]
UI["CmdsContainerPadding_11"]["PaddingLeft"] = UDim.new(0, 4)
UI["CmdsContainerPadding_11"]["PaddingBottom"] = UDim.new(0, 4)


UI["Topbar_12"] = Instance.new("Frame", UI["CmdsFrame_4"])
UI["Topbar_12"]["BorderSizePixel"] = 0
UI["Topbar_12"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Topbar_12"]["Size"] = UDim2.new(0.2, 0, 0.3, 0)
UI["Topbar_12"]["Name"] = [[Topbar]]
UI["Topbar_12"]["LayoutOrder"] = 1
UI["Topbar_12"]["BackgroundTransparency"] = 1


UI["TopbarLayout_13"] = Instance.new("UIListLayout", UI["Topbar_12"])
UI["TopbarLayout_13"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["TopbarLayout_13"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["TopbarLayout_13"]["Padding"] = UDim.new(0, 4)
UI["TopbarLayout_13"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["TopbarLayout_13"]["Name"] = [[TopbarLayout]]
UI["TopbarLayout_13"]["FillDirection"] = Enum.FillDirection.Horizontal


UI["Close_14"] = Instance.new("TextButton", UI["Topbar_12"])
UI["Close_14"]["TextWrapped"] = true
UI["Close_14"]["BorderSizePixel"] = 0
UI["Close_14"]["TextScaled"] = true
UI["Close_14"]["TextColor3"] = Color3.fromRGB(0, 0, 0)
UI["Close_14"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Close_14"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI["Close_14"]["Size"] = UDim2.new(0.2, 0, 0.3, 0)
UI["Close_14"]["LayoutOrder"] = 2
UI["Close_14"]["Text"] = [[×]]
UI["Close_14"]["Name"] = [[Close]]


UI["CloseCorner_15"] = Instance.new("UICorner", UI["Close_14"])
UI["CloseCorner_15"]["Name"] = [[CloseCorner]]
UI["CloseCorner_15"]["CornerRadius"] = UDim.new(0, 4)


UI["CloseRatio_16"] = Instance.new("UIAspectRatioConstraint", UI["Close_14"])
UI["CloseRatio_16"]["Name"] = [[CloseRatio]]


UI["Title_17"] = Instance.new("TextLabel", UI["Topbar_12"])
UI["Title_17"]["TextWrapped"] = true
UI["Title_17"]["BorderSizePixel"] = 0
UI["Title_17"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["Title_17"]["TextScaled"] = true
UI["Title_17"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Title_17"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal)
UI["Title_17"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["Title_17"]["BackgroundTransparency"] = 1
UI["Title_17"]["Size"] = UDim2.new(0.2, 0, 0.3, 0)
UI["Title_17"]["Text"] = [[SimpleCMDS • Commands]]
UI["Title_17"]["LayoutOrder"] = 1
UI["Title_17"]["Name"] = [[Title]]


UI["TopbarStroke_18"] = Instance.new("UIStroke", UI["Topbar_12"])
UI["TopbarStroke_18"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["TopbarStroke_18"]["Name"] = [[TopbarStroke]]
UI["TopbarStroke_18"]["Color"] = Color3.fromRGB(255, 255, 255)


UI["TopbarPadding_19"] = Instance.new("UIPadding", UI["Topbar_12"])
UI["TopbarPadding_19"]["PaddingTop"] = UDim.new(0, 4)
UI["TopbarPadding_19"]["PaddingRight"] = UDim.new(0, 4)
UI["TopbarPadding_19"]["Name"] = [[TopbarPadding]]
UI["TopbarPadding_19"]["PaddingLeft"] = UDim.new(0, 4)
UI["TopbarPadding_19"]["PaddingBottom"] = UDim.new(0, 4)


UI["TopbarConstraint_1a"] = Instance.new("UISizeConstraint", UI["Topbar_12"])
UI["TopbarConstraint_1a"]["Name"] = [[TopbarConstraint]]
UI["TopbarConstraint_1a"]["MaxSize"] = Vector2.new(9999, 34)


UI["CmdsFrameStroke_1b"] = Instance.new("UIStroke", UI["CmdsFrame_4"])
UI["CmdsFrameStroke_1b"]["Name"] = [[CmdsFrameStroke]]
UI["CmdsFrameStroke_1b"]["Color"] = Color3.fromRGB(255, 255, 255)


UI["CmdsFrameLayout_1c"] = Instance.new("UIListLayout", UI["CmdsFrame_4"])
UI["CmdsFrameLayout_1c"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["CmdsFrameLayout_1c"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["CmdsFrameLayout_1c"]["Padding"] = UDim.new(0, 2)
UI["CmdsFrameLayout_1c"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["CmdsFrameLayout_1c"]["Name"] = [[CmdsFrameLayout]]


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

local IsOpen = false

local function ClearCommandEntries()
    for _, Child in ipairs(UI["CmdsList_7"]:GetChildren()) do
        if Child:IsA("Frame") and Child ~= UI["CmdTemplate_b"] then
            Child:Destroy()
        end
    end
end

local function PopulateCommands()
    ClearCommandEntries()

    local SortedCommands = {}
    for _, Command in ipairs(CommandRegistry) do
        table.insert(SortedCommands, Command)
    end

    table.sort(SortedCommands, function(a, b)
        return a.Aliases[1]:lower() < b.Aliases[1]:lower()
    end)

    for Index, Command in ipairs(SortedCommands) do
        local Entry = UI["CmdTemplate_b"]:Clone()

        local AliasText = {}
        for _, Alias in ipairs(Command.Aliases) do
            table.insert(AliasText, "." .. Alias)
        end

        Entry.Title.Text = table.concat(AliasText, ", ")
        Entry.Description.Text = Command.Description .. "\nUsage: " .. Command.Usage
        Entry.LayoutOrder = Index
        Entry.Visible = true
        Entry.Parent = UI["CmdsList_7"]
    end
end

local function ShowCommands()
    if IsOpen then
        return
    end
    IsOpen = true

    PopulateCommands()

    UI["CmdsFrame_4"].Visible = true
    UI["CmdsFrame_4"].GroupTransparency = 1
    UI["CmdsFrame_4"].Size = UDim2.new(0.9, 0, 0.9, 0)

    Tween(UI["CmdsFrame_4"], 0.35, {
        GroupTransparency = 0,
        Size = UDim2.new(1, 0, 1, 0)
    }, "Back", "Out"):Play()
end

local function HideCommands()
    if not IsOpen then
        return
    end
    IsOpen = false

    local HideTween = Tween(UI["CmdsFrame_4"], 0.25, {
        GroupTransparency = 1,
        Size = UDim2.new(0.9, 0, 0.9, 0)
    }, "Quad", "In")

    HideTween:Play()

    task.spawn(function()
        HideTween.Completed:Wait()
        UI["CmdsFrame_4"].Visible = false
    end)
end

UI["Close_14"].MouseButton1Click:Connect(HideCommands)

Cmd.Reg(Cmd.new({"commands", "cmds"}, "Opens a scrollable list of all available commands.", ".commands", function(Args)
    if IsOpen then
        HideCommands()
    else
        ShowCommands()
    end
end))