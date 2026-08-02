local ChangedParts = {}

local function IsPlayerPart(Part)
	local Model = Part:FindFirstAncestorOfClass("Model")
	return Model and Players:GetPlayerFromCharacter(Model)
end

local function SetXray(State)
	for _, Object in ipairs(workspace:GetDescendants()) do
		if Object:IsA("BasePart") and not IsPlayerPart(Object) then
			if State then
				if ChangedParts[Object] == nil then
					ChangedParts[Object] = Object.LocalTransparencyModifier
				end
				Object.LocalTransparencyModifier = 0.5
			elseif ChangedParts[Object] ~= nil then
				Object.LocalTransparencyModifier = ChangedParts[Object]
				ChangedParts[Object] = nil
			end
		end
	end
end

Cmd.new({"xray"}, "Makes the world semi-transparent.", "xray", function()
	SetXray(true)
	DebugNotif("Xray: Enabled.")
end)

Cmd.new({"unxray"}, "Disables xray.", "unxray", function()
	SetXray(false)
	DebugNotif("Xray: Disabled.")
end)