local antiflingConn
local antiflingPlayerConn
local tracked = {}
local origCan = {}
local signals = {}

local function clearPart(p)
	tracked[p] = nil
	origCan[p] = nil
	if signals[p] then
		signals[p]:Disconnect()
		signals[p] = nil
	end
end

local function apply(p)
	if not (p and typeof(p) == "Instance" and p:IsA("BasePart")) or tracked[p] then return end
	tracked[p] = true
	if origCan[p] == nil then origCan[p] = p.CanCollide end
	if not signals[p] then
		signals[p] = p:GetPropertyChangedSignal("CanCollide"):Connect(function()
			if tracked[p] and p.CanCollide ~= false then
				p.CanCollide = false
			end
		end)
	end
	if p.CanCollide ~= false then p.CanCollide = false end
end

local function seedChar(char)
	if not char then return end
	for _, d in ipairs(char:GetDescendants()) do
		if d:IsA("BasePart") then apply(d) end
	end
	char.DescendantAdded:Connect(function(inst)
		if inst:IsA("BasePart") then apply(inst) end
	end)
	char.DescendantRemoving:Connect(function(inst)
		if inst:IsA("BasePart") then clearPart(inst) end
	end)
end

local function cleanupChar(char)
	if not char then return end
	for _, d in ipairs(char:GetDescendants()) do
		if tracked[d] then clearPart(d) end
	end
end

local function hookPlayer(plr)
	if plr == Players.LocalPlayer then return end
	if plr.Character then seedChar(plr.Character) end
	plr.CharacterAdded:Connect(function(char) seedChar(char) end)
	plr.CharacterRemoving:Connect(function(char) cleanupChar(char) end)
end

local function antifling(notify)
	if antiflingConn then antiflingConn:Disconnect() end

	tracked = {}
	origCan = {}
	signals = {}

	for _, plr in ipairs(Players:GetPlayers()) do
		hookPlayer(plr)
	end

	antiflingPlayerConn = Players.PlayerAdded:Connect(hookPlayer)
	Players.PlayerRemoving:Connect(function(plr)
		if plr == Players.LocalPlayer then return end
		cleanupChar(plr.Character)
	end)

	local lastKey = nil
	antiflingConn = RunService.PreSimulation:Connect(function()
		local quota = 256
		local k = lastKey
		if k ~= nil and tracked[k] == nil then k = nil end
		while quota > 0 do
			k = next(tracked, k)
			if not k then lastKey = nil break end
			local p = k
			if typeof(p) == "Instance" and p:IsA("BasePart") and p.Parent then
				if p.CanCollide ~= false then p.CanCollide = false end
				lastKey = p
			else
				clearPart(p)
				lastKey = nil
			end
			quota -= 1
		end
	end)

	if notify then DebugNotif("AntiFling: Enabled") end
end

local function unantifling()
	if antiflingConn then antiflingConn:Disconnect() antiflingConn = nil end
	if antiflingPlayerConn then antiflingPlayerConn:Disconnect() antiflingPlayerConn = nil end

	for p in tracked do
		if typeof(p) == "Instance" and p:IsA("BasePart") then
			p.CanCollide = origCan[p] ~= nil and origCan[p] or true
		end
	end

	for _, c in signals do c:Disconnect() end

	tracked = {}
	origCan = {}
	signals = {}

	DebugNotif("AntiFling: Disabled")
end

Cmd.new({"antifling", "af"}, "Prevents your character from being flung.", "antifling", function()
	antifling(true)
end)

Cmd.new({"unantifling", "uaf"}, "Disables anti-fling.", "unantifling", function()
	unantifling()
end)