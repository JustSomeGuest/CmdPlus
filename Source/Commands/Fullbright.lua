local Lighting = GetService("Lighting")

local Defaults = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient
}

local FullbrightProperties = {
    Brightness = 2,
    ClockTime = 12,
    FogEnd = 100000,
    GlobalShadows = false,
    Ambient = Color3.new(1, 1, 1),
    OutdoorAmbient = Color3.new(1, 1, 1)
}

local Connections = {}

local function ApplyFullbright(Property)
    local Value = FullbrightProperties[Property]

    if Value ~= nil and Lighting[Property] ~= Value then
        Lighting[Property] = Value
    end
end

local function EnableFullbright()
    for Property in pairs(FullbrightProperties) do
        ApplyFullbright(Property)

        if not Connections[Property] then
            Connections[Property] = Lighting:GetPropertyChangedSignal(Property):Connect(function()
                ApplyFullbright(Property)
            end)
        end
    end
end

local function DisableFullbright()
    for Property, Connection in pairs(Connections) do
        Connection:Disconnect()
        Connections[Property] = nil
    end

    for Property, Value in pairs(Defaults) do
        Lighting[Property] = Value
    end
end

Cmd.new(
    {"fullbright", "fb"},
    "Enables fullbright.",
    "fullbright",
    function()
        EnableFullbright()
        Notify("Fullbright: Enabled.")
    end
)

Cmd.new(
    {"unfullbright", "unfb"},
    "Disables fullbright.",
    "unfullbright",
    function()
        DisableFullbright()
        Notify("Fullbright: Disabled.")
    end
)