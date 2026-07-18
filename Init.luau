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

local Notifs = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustSomeGuest/VoidUI/Stable/Source/Notify.luau"))()

Notifs.Theme = {
    Accent = Color3.fromRGB(255, 255, 255),
    Secondary = Color3.fromRGB(0, 0, 0),
    Text = Color3.fromRGB(255, 255, 255),
}

local function DebugNotif(Text)
    Notifs:Notify("◈◈◈ SimpleCMDS ◈◈◈", Text)
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
if not IsFolder("SimpleCMDS/Commands") then
    MakeFolder("SimpleCMDS/Commands")
end
if not IsFolder("SimpleCMDS/UserCommands") then
    MakeFolder("SimpleCMDS/UserCommands")
end

local CommandsURL = "https://raw.githubusercontent.com/JustSomeGuest/SimpleCMDS/Source/Commands/"

local BuiltInCommands = {
    "Antifling.luau",
    "Airwalk.luau",
    "Rejoin.luau",
    "ServerHop.luau",
    "SetShader.luau",
    "SetPrefix.luau",
    "Walkspeed.luau",
    "Jumppower.luau",
}

local function DownloadCommandToFile(cmdFile)
    local filePath = "SimpleCMDS/Commands/" .. cmdFile
    local url = CommandsURL .. cmdFile
    
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success or not result then
        warn("[SimpleCMDS] Failed to download command: " .. cmdFile)
        return false
    end
    
    if IsFile(filePath) then
        local oldContent = ReadFile(filePath)
        if oldContent ~= result then
            DelFile(filePath)
            WriteFile(filePath, result)
        end
    else
        WriteFile(filePath, result)
    end
    return true
end

local function DownloadAllCommands()
    for _, cmdFile in ipairs(BuiltInCommands) do
        DownloadCommandToFile(cmdFile)
    end
end

local function LoadCommandFromFile(filePath)
    if IsFile(filePath) then
        local success, chunk = pcall(function()
            local content = ReadFile(filePath)
            local func = loadstring(content)
            if func then
                local env = CreateCommandEnv()
                setfenv(func, env)
                return func()
            end
        end)
        if success then
            return true
        else
            warn("[SimpleCMDS] Failed to load command: " .. filePath)
        end
    end
    return false
end

local function LoadBuiltInCommands()
    for _, cmdFile in ipairs(BuiltInCommands) do
        local filePath = "SimpleCMDS/Commands/" .. cmdFile
        LoadCommandFromFile(filePath)
    end
end

local function CreateCommandEnv()
    return {
        Cmd = Cmd,
        Services = Services,
        Workspace = Workspace,
        Players = Players,
        ReplicatedStorage = ReplicatedStorage,
        RunService = RunService,
        StarterGui = StarterGui,
        Lighting = Lighting,
        DebugNotif = DebugNotif,
        WriteFile = WriteFile,
        ReadFile = ReadFile,
        IsFile = IsFile,
        DelFile = DelFile,
        IsFolder = IsFolder,
        MakeFolder = MakeFolder,
        DelFolder = DelFolder,
        ListFiles = ListFiles,
        loadstring = loadstring,
        game = game,
        warn = warn,
        print = print,
        pcall = pcall,
        task = task,
        Vector3 = Vector3,
        Color3 = Color3,
        CFrame = CFrame,
        Enum = Enum,
        Instance = Instance,
        Terrain = Terrain,
        Prefix = Prefix,
        DownloadCommandToFile = DownloadCommandToFile,
        DownloadAllCommands = DownloadAllCommands,
    }
end

local function LoadUserCommands()
    if IsFolder("SimpleCMDS/UserCommands") then
        local files = ListFiles("SimpleCMDS/UserCommands")
        local env = CreateCommandEnv()
        for _, file in ipairs(files) do
            if file:match("%.luau$") or file:match("%.lua$") then
                local success, chunk = pcall(function()
                    local content = ReadFile(file)
                    local func = loadstring(content)
                    if func then
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

local Prefix = "."
local Plr = Players.LocalPlayer

DownloadAllCommands()
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
