if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

local function expect(expected, value, fallback)
    if type(value) == expected then
        return value
    end
    if fallback ~= nil then
        if type(fallback) == "function" then
            return function(...)
                warn("[Expect]: Missing executor functionality. Using fallback function.")
                return fallback(...)
            end
        end
        warn("[Expect]: Value has unexpected type. Using fallback value.")
    end
    return fallback
end

local cloneref = expect("function", cloneref, function(...) return ... end)

local WriteFile = expect("function", writefile, function() return end)
local IsFile = expect("function", isfile, function() return false end)
local DelFile = expect("function", delfile, function() return end)
local IsFolder = expect("function", isfolder, function() return false end)
local MakeFolder = expect("function", makefolder, function() return end)
local DelFolder = expect("function", delfolder, function() return end)
local ReadFile = expect("function", readfile, function() return "" end)
local ListFiles = expect("function", listfiles, function() return {} end)

local Services = setmetatable({}, {
    __index = function(self, name)
        local success, cache = pcall(function()
            return cloneref(game:GetService(name))
        end)
        if success then
            rawset(self, name, cache)
            return cache
        else
            error("Invalid Service: " .. tostring(name))
        end
    end
})

local Workspace = Services.Workspace
local Players = Services.Players
local ReplicatedStorage = Services.ReplicatedStorage
local RunService = Services.RunService
local StarterGui = Services.StarterGui
local Lighting = Services.Lighting
local Terrain = Workspace:FindFirstChildOfClass("Terrain")

local Hui = (gethui and gethui()) or Services.CoreGui

local NotifsSuccess, Notifs = pcall(function()
    local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustSomeGuest/VoidUI/Stable/Source/Notify.luau"))()
    Lib.Settings = {
        Theme = {
            Accent = Color3.fromRGB(255, 255, 255),
            Secondary = Color3.fromRGB(0, 0, 0),
            Text = Color3.fromRGB(255, 255, 255),
        },
        Fonts = {
            Title = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
            Description = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        }
    }
    return Lib
end)

if not NotifsSuccess then
    warn("[SimpleCMDS] Failed to load Notify library, falling back to StarterGui notifications")
end

local function DebugNotif(Text)
    if NotifsSuccess then
        local success = pcall(function()
            Notifs:Notify("SimpleCMDS", Text)
        end)
        if success then
            return
        end
        warn("[SimpleCMDS] Notify library errored, falling back to StarterGui notification")
    end

    StarterGui:SetCore("SendNotification", {
        Title = "SimpleCMDS",
        Text = Text,
        Duration = 5,
    })
end

local Commands = {}
local Cmd = {}
Cmd.__index = Cmd

function Cmd.new(Aliases, Callback)
    local Command = setmetatable({}, Cmd)
    Command.Aliases = Aliases
    Command.Callback = Callback
    return Command
end

function Cmd.Reg(Command)
    for _, Alias in ipairs(Command.Aliases) do
        Commands[Alias:lower()] = Command.Callback
    end
end

if not IsFolder("SimpleCMDS") then
    MakeFolder("SimpleCMDS")
end
if not IsFolder("SimpleCMDS/UserCommands") then
    MakeFolder("SimpleCMDS/UserCommands")
end

local CommandsURL = "https://raw.githubusercontent.com/JustSomeGuest/SimpleCMDS/Source/Commands/"

local BuiltInCommands = {
    "Antifling.luau",
    "Rejoin.luau",
    "ServerHop.luau",
    "SetShader.luau",
    "SetPrefix.luau",
    "Airwalk.luau",
    "Walkspeed.luau",
    "Jumppower.luau",
    "Teleport.luau",
}

local Prefix = "."

local function SetGlobalPrefix(NewPrefix)
    Prefix = NewPrefix
end

local function CreateCommandEnv()
    local Env = {
        Cmd = Cmd,
        Services = Services,
        Commands = Commands,
        Prefix = Prefix,
        SetPrefix = SetGlobalPrefix,

        Workspace = Workspace,
        Players = Players,
        ReplicatedStorage = ReplicatedStorage,
        RunService = RunService,
        StarterGui = StarterGui,
        CoreGui = Services.CoreGui,
        Hui = Hui,
        SoundService = Services.SoundService,
        TweenService = Services.TweenService,
        UserInputService = Services.UserInputService,
        HttpService = Services.HttpService,
        MarketplaceService = Services.MarketplaceService,
        TeleportService = Services.TeleportService,
        TextChatService = Services.TextChatService,
        VoiceChatService = Services.VoiceChatService,
        Stats = Services.Stats,
        Debris = Services.Debris,
        Lighting = Lighting,
        Terrain = Terrain,

        WriteFile = WriteFile,
        ReadFile = ReadFile,
        IsFile = IsFile,
        DelFile = DelFile,
        IsFolder = IsFolder,
        MakeFolder = MakeFolder,
        DelFolder = DelFolder,
        ListFiles = ListFiles,
        DebugNotif = DebugNotif,

        print = print,
        warn = warn,
        error = error,
        assert = assert,
        pcall = pcall,
        xpcall = xpcall,
        select = select,
        type = type,
        typeof = typeof,
        tostring = tostring,
        tonumber = tonumber,
        rawset = rawset,
        rawget = rawget,
        rawequal = rawequal,
        rawlen = rawlen,
        setmetatable = setmetatable,
        getmetatable = getmetatable,
        unpack = unpack or table.unpack,
        require = require,
        collectgarbage = collectgarbage,
        loadstring = loadstring,
        newproxy = newproxy,

        pairs = pairs,
        ipairs = ipairs,
        next = next,
        table = table,
        string = string,
        math = math,
        os = os,
        coroutine = coroutine,
        utf8 = utf8,
        bit32 = bit32,
        debug = debug,

        game = game,
        workspace = workspace,
        script = script,
        task = task,
        delay = delay,
        spawn = spawn,
        wait = wait,
        tick = tick,
        time = time,
        elapsedTime = elapsedTime,

        Vector2 = Vector2,
        Vector3 = Vector3,
        Vector2int16 = Vector2int16,
        Vector3int16 = Vector3int16,
        CFrame = CFrame,
        Color3 = Color3,
        ColorSequence = ColorSequence,
        ColorSequenceKeypoint = ColorSequenceKeypoint,
        NumberSequence = NumberSequence,
        NumberSequenceKeypoint = NumberSequenceKeypoint,
        NumberRange = NumberRange,
        UDim = UDim,
        UDim2 = UDim2,
        Rect = Rect,
        Region3 = Region3,
        Region3int16 = Region3int16,
        BrickColor = BrickColor,
        Enum = Enum,
        Instance = Instance,
        Ray = Ray,
        Axes = Axes,
        Faces = Faces,
        PhysicalProperties = PhysicalProperties,
        TweenInfo = TweenInfo,
        DateTime = DateTime,
        Random = Random,
        Font = Font,
        OverlapParams = OverlapParams,
        RaycastParams = RaycastParams,
    }

    local RealEnv = getfenv()
    return setmetatable(Env, {
        __index = RealEnv,
        __newindex = RealEnv,
    })
end

local function LoadCommandFromURL(url)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success and result then
        local func, err = loadstring(result)
        if func then
            local env = CreateCommandEnv()
            setfenv(func, env)
            local success, err = pcall(func)
            if not success then
                warn("[SimpleCMDS] Failed to execute command: " .. url .. " - " .. tostring(err))
            end
            return true
        else
            warn("[SimpleCMDS] Failed to compile command: " .. url .. " - " .. tostring(err))
        end
    else
        warn("[SimpleCMDS] Failed to download command: " .. url)
    end
    return false
end

local function LoadBuiltInCommands()
    for _, cmdFile in ipairs(BuiltInCommands) do
        local url = CommandsURL .. cmdFile
        LoadCommandFromURL(url)
    end
end

local function LoadUserCommands()
    if IsFolder("SimpleCMDS/UserCommands") then
        local files = ListFiles("SimpleCMDS/UserCommands")
        for _, file in ipairs(files) do
            if file:match("%.luau$") or file:match("%.lua$") then
                local success, chunk = pcall(function()
                    local content = ReadFile(file)
                    local func = loadstring(content)
                    if func then
                        local env = CreateCommandEnv()
                        setfenv(func, env)
                        return func()
                    end
                end)
                if not success then
                    warn("[SimpleCMDS] Failed to load user command: " .. file)
                end
            end
        end
    end
end

local function LoadAutoConfig()
    if IsFile("SimpleCMDS/Autoload.luau") then
        local success, chunk = pcall(function()
            local content = ReadFile("SimpleCMDS/Autoload.luau")
            local func = loadstring(content)
            if func then
                local env = CreateCommandEnv()
                setfenv(func, env)
                return func()
            end
        end)
        if not success then
            warn("[SimpleCMDS] Failed to load autoload config")
        end
    end
end

local function CreateAutoExecuteTemplate()
    if not IsFile("SimpleCMDS/Autoexecute.luau") then
        local template = [[return {
    -- "Example",
}]]
        WriteFile("SimpleCMDS/Autoexecute.luau", template)
    end
end

local function LoadAutoExecute()
    if IsFile("SimpleCMDS/Autoexecute.luau") then
        local success, content = pcall(function()
            return ReadFile("SimpleCMDS/Autoexecute.luau")
        end)
        if success and content then
            local func, err = loadstring(content)
            if func then
                local env = CreateCommandEnv()
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
                            local cmdFunc = Commands[cmdName]
                            if cmdFunc then
                                local success, err = pcall(cmdFunc, args)
                                if not success then
                                    warn("[SimpleCMDS] Failed to autoexecute command: " .. cmd .. " - " .. tostring(err))
                                end
                            else
                                warn("[SimpleCMDS] Unknown command in autoexecute: " .. cmd)
                            end
                        end
                    end
                end
            end
        end
    end
end

local function LoadPrefix()
    if IsFile("SimpleCMDS/Prefix.luau") then
        local success, content = pcall(function()
            return ReadFile("SimpleCMDS/Prefix.luau")
        end)
        if success and content then
            local prefix = content:gsub("%s+", "")
            if prefix ~= "" and #prefix == 1 then
                Prefix = prefix
            end
        end
    end
end

local Plr = Players.LocalPlayer

LoadBuiltInCommands()
LoadUserCommands()
LoadAutoConfig()
CreateAutoExecuteTemplate()
LoadPrefix()
LoadAutoExecute()

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
    local CmdFunc = Commands[CmdName]
    if CmdFunc then
        CmdFunc(Args)
    end
end)
