if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Env = (type(getgenv) == "function" and getgenv()) or shared or _G

local function GetService(Name)
    local Svc = game:GetService(Name)
    return cloneref and cloneref(Svc) or Svc
end

local function UID(Length)
    Length = Length or 64

    local Chars = [[abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~]]
    local Id = table.create(Length)

    for i = 1, Length do
        local Rand = math.random(1, #Chars)
        Id[i] = Chars:sub(Rand, Rand)
    end

    return table.concat(Id)
end

local Workspace = GetService("Workspace")
local Players = GetService("Players")
local ReplicatedStorage = GetService("ReplicatedStorage")
local RunService = GetService("RunService")
local StarterGui = GetService("StarterGui")
local Lighting = GetService("Lighting")
local CoreGui = GetService("CoreGui")
local Hui = (gethui and gethui()) or CoreGui
local SoundService = GetService("SoundService")
local TweenService = GetService("TweenService")
local UserInputService = GetService("UserInputService")
local GuiService = GetService("GuiService")
local TextService = GetService("TextService")
local HttpService = GetService("HttpService")
local MarketplaceService = GetService("MarketplaceService")
local TeleportService = GetService("TeleportService")
local TextChatService = GetService("TextChatService")
local VoiceChatService = GetService("VoiceChatService")
local Stats = GetService("Stats")
local Debris = GetService("Debris")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")

local WriteFile = writefile or function() end
local IsFile = isfile or function() return false end
local DelFile = delfile or function() end
local IsFolder = isfolder or function() return false end
local MakeFolder = makefolder or function() end
local DelFolder = delfolder or function() end
local ReadFile = readfile or function() return "" end
local ListFiles = listfiles or function() return {} end
local LoadAsset = getcustomasset or getsynasset

local CmdPlusUI = Instance.new("ScreenGui")
CmdPlusUI.DisplayOrder = 100
CmdPlusUI.Enabled = true
CmdPlusUI.Name = UID()
CmdPlusUI.IgnoreGuiInset = true
CmdPlusUI.ResetOnSpawn = false
CmdPlusUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
CmdPlusUI.Parent = Hui

CmdPlusUI:GetPropertyChangedSignal("Enabled"):Connect(function()
    if not CmdPlusUI.Enabled then
        CmdPlusUI.Enabled = true
    end
end)

local NotifsSuccess, Notifs = pcall(function()
    local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustSomeGuest/VoidUI/Main/Source/Notify.luau"))()
    Lib:SetTheme("Minimal")
    return Lib
end)

if not NotifsSuccess then
    warn("[CmdPlus] Failed to load Notify library, falling back to StarterGui notifications")
end

local function Notify(Text)
    if NotifsSuccess then
        local success = pcall(function()
            Notifs:Notify("CmdPlus", Text)
        end)
        if success then
            return
        end
        warn("[CmdPlus] Notify library errored, falling back to StarterGui notification")
    end

    StarterGui:SetCore("SendNotification", {
        Title = "CmdPlus",
        Text = Text,
        Duration = 5,
    })
end

Env.CmdPlus = Env.CmdPlus or {}
Env.CmdPlus.Cmds = Env.CmdPlus.Cmds or {}

local Cmds = Env.CmdPlus.Cmds
local CmdRegistry = {}
local Cmd = {}
Cmd.__index = Cmd

function Cmd.new(Aliases, Description, Usage, Callback)
    if type(Description) == "function" then
        Callback = Description
        Description = "No description provided."
        Usage = Aliases[1] or ""
    elseif type(Usage) == "function" then
        Callback = Usage
        Usage = Aliases[1] or ""
    end

    local Command = setmetatable({
        Aliases = Aliases,
        Description = Description or "No description provided.",
        Usage = Usage or (Aliases[1] or ""),
        Callback = Callback
    }, Cmd)

    for _, Alias in ipairs(Aliases) do
        Cmds[Alias:lower()] = Callback
    end

    table.insert(CmdRegistry, Command)

    return Command
end

local function GetCmdList()
    local List = {}
    for _, Command in ipairs(CmdRegistry) do
        table.insert(List, {
            Aliases = Command.Aliases,
            Description = Command.Description,
            Usage = Command.Usage,
        })
    end
    return List
end

if not IsFolder("CmdPlus") then
    MakeFolder("CmdPlus")
end
if not IsFolder("CmdPlus/UserCmds") then
    MakeFolder("CmdPlus/UserCmds")
end
if not IsFolder("CmdPlus/Assets") then
    MakeFolder("CmdPlus/Assets")
end

local MainURL = "https://raw.githubusercontent.com/JustSomeGuest/CmdPlus/Main/Source/"
local CmdsURL = MainURL .. "Commands/"
local AssetsURL = MainURL .. "Assets/"

local BuiltInCmds = {
    "Commands.luau",
    "AirWalk.luau",
    "AntiEquip.luau",
    "AntiFling.luau",
    "ClickTP.luau",
    "Console.luau",
    "Copy.luau",
    "ESP.luau",
    "FOV.luau",
    "FPS.luau",
    "Freeze.luau",
    "Fullbright.luau",
    "Gravity.luau",
    "JumpPower.luau",
    "Noclip.luau",
    "Ping.luau",
    "Position.luau",
    "Rejoin.luau",
    "Respawn.luau",
    "Rotector.luau",
    "ServerHop.luau",
    "SetPrefix.luau",
    "SetShader.luau",
    "Spectate.luau",
    "Spin.luau",
    "Teleport.luau",
    "Time.luau",
    "WalkSpeed.luau",
    "XRay.luau"
}

local Assets = {
    ["CmdPlus/Assets/CmdPlus_Logo.png"] = AssetsURL .. "Logo.png",
    ["CmdPlus/Assets/CmdPlus_Rain.mp3"] = AssetsURL .. "Rain.mp3",
    ["CmdPlus/Assets/CmdPlus_Thunder.mp3"] = AssetsURL .. "Thunder.mp3",
}

local function GetAsset(Path)
    if not LoadAsset then
        warn("[CmdPlus] getcustomasset/getsynasset not supported by this executor")
        return nil
    end

    local RemoteURL = Assets[Path]

    if not RemoteURL then
        warn("[CmdPlus] No asset registered for path: " .. Path)
        return nil
    end

    if RemoteURL:match("^rbxassetid://") then
        return RemoteURL
    end

    if not IsFile(Path) then
        local RequestFunc = http_request or request or (syn and syn.request)
        local Response

        if RequestFunc then
            local Success, Result = pcall(function()
                return RequestFunc({
                    Url = RemoteURL,
                    Method = "GET",
                })
            end)

            Response = Success and Result or nil
        else
            local Success, Result = pcall(function()
                return game:HttpGet(RemoteURL)
            end)

            if Success then
                Response = {
                    Success = true,
                    Body = Result,
                }
            end
        end

        if not Response or not Response.Success or not Response.Body then
            warn("[CmdPlus] Failed to download asset: " .. Path)
            return nil
        end

        WriteFile(Path, Response.Body)
    end

    local Success, Result = pcall(function()
        return LoadAsset(Path)
    end)

    if Success then
        return Result
    end

    warn("[CmdPlus] Failed to load local asset: " .. Path)
    return nil
end

local Prefix = "."

local function SetGlobalPrefix(NewPrefix)
    Prefix = NewPrefix
end

local function GetGlobalPrefix()
    if not IsFile("CmdPlus/Prefix.luau") then
        return Prefix
    end

    local Success, Content = pcall(ReadFile, "CmdPlus/Prefix.luau")

    if Success and type(Content) == "string" then
        Content = Content:gsub("%s+", "")

        if #Content == 1 then
            Prefix = Content
            return Content
        end
    end

    return Prefix
end

local Plr = Players.LocalPlayer

local function FindPlr(searchTerm)
    local matches = {}
    local searchLower = searchTerm:lower()

    for _, player in ipairs(Players:GetPlayers()) do
        local nameLower = player.Name:lower()
        local displayLower = player.DisplayName:lower()

        if nameLower == searchLower or displayLower == searchLower then
            table.insert(matches, player)
        elseif nameLower:match(searchLower) or displayLower:match(searchLower) then
            table.insert(matches, player)
        end
    end

    return matches
end

local function Tween(Object, Speed, Properties, EasingStyle, EasingDirection)
    EasingStyle = EasingStyle or "Quad"
    EasingDirection = EasingDirection or "Out"
    local Info = TweenInfo.new(Speed, Enum.EasingStyle[EasingStyle], Enum.EasingDirection[EasingDirection])
    return TweenService:Create(Object, Info, Properties)
end

local function Dragify(DragObject, MoveObject)
    MoveObject = MoveObject or DragObject

    local DragInput
    local DragStart
    local Dragging = false
    local StartPos

    DragObject.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then
            DragStart = Input.Position
            Dragging = true
            StartPos = MoveObject.Position

            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    DragObject.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement
        or Input.UserInputType == Enum.UserInputType.Touch then
            DragInput = Input
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if not Dragging or Input ~= DragInput then
            return
        end

        local Delta = Input.Position - DragStart
        local Size = CmdPlusUI.AbsoluteSize
        local ObjectSize = MoveObject.AbsoluteSize
        local Padding = 12

        local NewX = math.clamp(
            StartPos.X.Offset + Delta.X,
            Padding,
            Size.X - ObjectSize.X - Padding
        )

        local NewY = math.clamp(
            StartPos.Y.Offset + Delta.Y,
            Padding,
            Size.Y - ObjectSize.Y - Padding
        )

        MoveObject.Position = UDim2.fromOffset(NewX, NewY)
    end)
end

local function CreateCmdEnv()
    local ModEnv = setmetatable({
        CmdPlusUI = CmdPlusUI,
        GetService = GetService,
        UID = UID,
        Cmd = Cmd,
        Cmds = Cmds,
        CmdRegistry = CmdRegistry,
        GetCmdList = GetCmdList,
        Prefix = Prefix,
        SetPrefix = SetGlobalPrefix,
        GetPrefix = GetGlobalPrefix,
        GetAsset = GetAsset,
        Tween = Tween,
        Dragify = Dragify,
        Notify = Notify,
        Plr = Plr,
        FindPlr = FindPlr,
        WriteFile = WriteFile,
        ReadFile = ReadFile,
        IsFile = IsFile,
        DelFile = DelFile,
        IsFolder = IsFolder,
        MakeFolder = MakeFolder,
        DelFolder = DelFolder,
        ListFiles = ListFiles,
        Hui = Hui,
        Terrain = Terrain,
    }, {
        __index = getfenv(0),
        __newindex = getfenv(0),
    })

    return ModEnv
end

local function LoadCmd(url)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success and result then
        local func, err = loadstring(result)
        if func then
            local env = CreateCmdEnv()
            setfenv(func, env)
            local success, err = pcall(func)
            if not success then
                warn("[CmdPlus] Failed to execute command: " .. url .. " - " .. tostring(err))
            end
            return true
        else
            warn("[CmdPlus] Failed to compile command: " .. url .. " - " .. tostring(err))
        end
    else
        warn("[CmdPlus] Failed to download command: " .. url)
    end
    return false
end

local function LoadCoreCmds()
    for _, cmdFile in ipairs(BuiltInCmds) do
        local url = CmdsURL .. cmdFile
        LoadCmd(url)
    end
end

local function LoadUserCmds()
    if IsFolder("CmdPlus/UserCmds") then
        local files = ListFiles("CmdPlus/UserCmds")
        for _, file in ipairs(files) do
            if file:match("%.luau$") or file:match("%.lua$") then
                local success, chunk = pcall(function()
                    local content = ReadFile(file)
                    local func = loadstring(content)
                    if func then
                        local env = CreateCmdEnv()
                        setfenv(func, env)
                        return func()
                    end
                end)
                if not success then
                    warn("[CmdPlus] Failed to load user command: " .. file)
                end
            end
        end
    end
end

local function LoadAutoConfig()
    if IsFile("CmdPlus/Autoload.luau") then
        local success, chunk = pcall(function()
            local content = ReadFile("CmdPlus/Autoload.luau")
            local func = loadstring(content)
            if func then
                local env = CreateCmdEnv()
                setfenv(func, env)
                return func()
            end
        end)
        if not success then
            warn("[CmdPlus] Failed to load autoload config")
        end
    end
end

local function CreateAutoExec()
    if not IsFile("CmdPlus/Autoexecute.luau") then
        local template = [[return {
    }]]
        WriteFile("CmdPlus/Autoexecute.luau", template)
    end
end

local function LoadAutoExec()
    if IsFile("CmdPlus/Autoexecute.luau") then
        local success, content = pcall(function()
            return ReadFile("CmdPlus/Autoexecute.luau")
        end)
        if success and content then
            local func, err = loadstring(content)
            if func then
                local env = CreateCmdEnv()
                setfenv(func, env)
                local success, result = pcall(func)
                if success and type(result) == "table" then
                    for _, cmd in ipairs(result) do
                        if not cmd:match("^%-%-") then
                            local args = {}
                            for word in cmd:gmatch("%S+") do
                                table.insert(args, word)
                            end
                            local cmdName = args[1] and args[1]:lower()
                            local cmdFunc = Cmds[cmdName]
                            if cmdFunc then
                                local success, err = pcall(cmdFunc, args)
                                if not success then
                                    warn("[CmdPlus] Failed to autoexecute command: " .. cmd .. " - " .. tostring(err))
                                end
                            else
                                warn("[CmdPlus] Unknown command in autoexecute: " .. cmd)
                            end
                        end
                    end
                end
            end
        end
    end
end

local function LoadPrefix()
    if IsFile("CmdPlus/Prefix.luau") then
        local success, content = pcall(function()
            return ReadFile("CmdPlus/Prefix.luau")
        end)
        if success and content then
            local prefix = content:gsub("%s+", "")
            if prefix ~= "" and #prefix == 1 then
                Prefix = prefix
            end
        end
    end
end

LoadCoreCmds()
LoadUserCmds()
LoadAutoConfig()
CreateAutoExec()
LoadPrefix()
LoadAutoExec()

pcall(function()
    loadstring(game:HttpGet(MainURL .. "Tags.luau"))()
end)

local UI = {}

UI.Cmdbar = Instance.new("Frame")
UI.Cmdbar.BackgroundColor3 = Color3.fromRGB(19, 19, 22)
UI.Cmdbar.BackgroundTransparency = 0.08
UI.Cmdbar.BorderSizePixel = 0
UI.Cmdbar.Position = UDim2.new(0.5, 0, 1, 10)
UI.Cmdbar.AnchorPoint = Vector2.new(0.5, 0.5)
UI.Cmdbar.Size = UDim2.new(1, -200, 0, 40)
UI.Cmdbar.Visible = false
UI.Cmdbar.ZIndex = 2
UI.Cmdbar.Parent = CmdPlusUI

UI.Cmdbox = Instance.new("TextBox")
UI.Cmdbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.Cmdbox.BackgroundTransparency = 1
UI.Cmdbox.BorderSizePixel = 0
UI.Cmdbox.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
UI.Cmdbox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
UI.Cmdbox.PlaceholderText = "Enter commands here..."
UI.Cmdbox.Size = UDim2.new(1, 0, 1, 0)
UI.Cmdbox.Text = ""
UI.Cmdbox.TextColor3 = Color3.fromRGB(255, 255, 255)
UI.Cmdbox.TextScaled = true
UI.Cmdbox.TextSize = 16
UI.Cmdbox.TextWrapped = true
UI.Cmdbox.TextXAlignment = Enum.TextXAlignment.Left
UI.Cmdbox.Parent = UI.Cmdbar

UI.CmdbarStroke = Instance.new("UIStroke")
UI.CmdbarStroke.Color = Color3.fromRGB(255, 255, 255)
UI.CmdbarStroke.Parent = UI.Cmdbar

UI.CmdbarCorner = Instance.new("UICorner")
UI.CmdbarCorner.CornerRadius = UDim.new(0, 4)
UI.CmdbarCorner.Parent = UI.Cmdbar

UI.CmdbarShadow = Instance.new("UIShadow")
UI.CmdbarShadow.BlurRadius = UDim.new(0, 8)
UI.CmdbarShadow.Color = Color3.fromRGB(255, 255, 255)
UI.CmdbarShadow.Transparency = 0.5
UI.CmdbarShadow.Parent = UI.Cmdbar

UI.CmdbarPadding = Instance.new("UIPadding")
UI.CmdbarPadding.PaddingBottom = UDim.new(0, 8)
UI.CmdbarPadding.PaddingLeft = UDim.new(0, 8)
UI.CmdbarPadding.PaddingRight = UDim.new(0, 8)
UI.CmdbarPadding.PaddingTop = UDim.new(0, 8)
UI.CmdbarPadding.Parent = UI.Cmdbar

local Camera = Workspace.CurrentCamera
local BtnSize = 38
local BtnPadding = 12

UI.CmdBtn = Instance.new("ImageButton")
UI.CmdBtn.BackgroundColor3 = Color3.fromRGB(19, 19, 22)
UI.CmdBtn.BackgroundTransparency = 0.08
UI.CmdBtn.BorderSizePixel = 0
UI.CmdBtn.Image = GetAsset("CmdPlus/Assets/CmdPlus_Logo.png")
UI.CmdBtn.Size = UDim2.new(0, BtnSize, 0, BtnSize)
UI.CmdBtn.Position = UDim2.fromOffset(math.floor(CmdPlusUI.AbsoluteSize.X / 2 - BtnSize / 2), -BtnSize - 10)
UI.CmdBtn.Visible = false
UI.CmdBtn.ZIndex = 3
UI.CmdBtn.Parent = CmdPlusUI

UI.CmdBtnRatio = Instance.new("UIAspectRatioConstraint")
UI.CmdBtnRatio.Parent = UI.CmdBtn

UI.CmdBtnStroke = Instance.new("UIStroke")
UI.CmdBtnStroke.Color = Color3.fromRGB(255, 255, 255)
UI.CmdBtnStroke.Parent = UI.CmdBtn

UI.CmdBtnShadow = Instance.new("UIShadow")
UI.CmdBtnShadow.BlurRadius = UDim.new(0, 8)
UI.CmdBtnShadow.Color = Color3.fromRGB(255, 255, 255)
UI.CmdBtnShadow.Transparency = 0.5
UI.CmdBtnShadow.Parent = UI.CmdBtn

UI.CmdBtnCorner = Instance.new("UICorner")
UI.CmdBtnCorner.CornerRadius = UDim.new(1, 0)
UI.CmdBtnCorner.Parent = UI.CmdBtn

UI.CmdBtn.Visible = true

TweenService:Create(UI.CmdBtn, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Position = UDim2.fromOffset(
        math.floor(Camera.ViewportSize.X / 2 - BtnSize / 2),
        BtnPadding
    )
}):Play()

Dragify(UI.CmdBtn)

local CmdbarOpen = false
local CmdbarTweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local function OpenCmdbar()
    CmdbarOpen = true
    UI.Cmdbar.Position = UDim2.new(0.5, 0, 0.55, 0)
    UI.Cmdbar.Size = UDim2.new(0.85, 0, 0, 40)
    UI.Cmdbar.BackgroundTransparency = 1
    UI.CmdbarStroke.Transparency = 1
    UI.Cmdbar.Visible = true

    TweenService:Create(UI.Cmdbar, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0.4, 0),
        Size = UDim2.new(1, -200, 0, 40),
        BackgroundTransparency = 0.08,
    }):Play()

    TweenService:Create(UI.CmdbarStroke, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 0,
    }):Play()

    task.delay(0.05, function()
        UI.Cmdbox:CaptureFocus()
    end)
end

local function CloseCmdbar()
    CmdbarOpen = false

    TweenService:Create(UI.Cmdbar, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, 0, 0.55, 0),
        Size = UDim2.new(0.85, 0, 0, 40),
        BackgroundTransparency = 1,
    }):Play()

    local StrokeTween = TweenService:Create(UI.CmdbarStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Transparency = 1,
    })
    StrokeTween:Play()
    StrokeTween.Completed:Connect(function()
        UI.Cmdbar.Visible = false
        UI.Cmdbar.Size = UDim2.new(1, -200, 0, 40)
    end)
end

local function RunCmdbarInput()
    local Text = UI.Cmdbox.Text
    UI.Cmdbox.Text = ""
    CloseCmdbar()

    if Text == "" then return end

    local Args = {}
    for Word in Text:gmatch("%S+") do
        table.insert(Args, Word)
    end

    local CmdName = Args[1] and Args[1]:lower()
    local CmdFunc = Cmds[CmdName]

    if CmdFunc then
        pcall(CmdFunc, Args)
    else
        Notify('"' .. (Args[1] or Text) .. '" isn\'t a valid command.')
    end
end

local BtnNormalSize = UDim2.new(0, 38, 0, 38)
local BtnHoverSize = UDim2.new(0, 44, 0, 44)
local BtnTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function AnimateBtnHover()
    TweenService:Create(UI.CmdBtn, BtnTweenInfo, { Size = BtnHoverSize }):Play()
end

local function AnimateBtnNormal()
    TweenService:Create(UI.CmdBtn, BtnTweenInfo, { Size = BtnNormalSize }):Play()
end

UI.CmdBtn.MouseEnter:Connect(function()
    if not BtnDragging then
        AnimateBtnHover()
    end
end)

UI.CmdBtn.MouseLeave:Connect(function()
    AnimateBtnNormal()
end)

UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    if GameProcessed then return end
    if Input.KeyCode == Enum.KeyCode.Semicolon then
        if CmdbarOpen then
            CloseCmdbar()
        else
            OpenCmdbar()
        end
    end
end)

UI.CmdBtn.MouseButton1Click:Connect(function()
    AnimateBtnHover()
    task.delay(0.15, AnimateBtnNormal)
    if CmdbarOpen then
        CloseCmdbar()
    else
        OpenCmdbar()
    end
end)

UI.Cmdbox.FocusLost:Connect(function(EnterPressed)
    if EnterPressed then
        RunCmdbarInput()
    else
        CloseCmdbar()
        UI.Cmdbox.Text = ""
    end
end)

Plr.Chatted:Connect(function(Message)
    if Message:sub(1, #Prefix) ~= Prefix then
        return
    end
    local Content = Message:sub(#Prefix + 1)
    local Args = {}
    for Word in Content:gmatch("%S+") do
        table.insert(Args, Word)
    end
    local CmdName = Args[1] and Args[1]:lower()
    local CmdFunc = Cmds[CmdName]
    if CmdFunc then
        CmdFunc(Args)
    end
end)
