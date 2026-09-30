local Lighting = GetService("Lighting")

local Defaults = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient
}

Cmd.new(
    {"fullbright", "fb"},
    "Enables fullbright.",
    "fullbright",
    function()
        Lighting.Brightness = 2
        Lighting.ClockTime = 12
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)

        Notify("Fullbright: Enabled.")
    end
)

Cmd.new(
    {"unfullbright", "unfb"},
    "Disables fullbright.",
    "unfullbright",
    function()
        for Property, Value in pairs(Defaults) do
            Lighting[Property] = Value
        end

        Notify("Fullbright: Disabled.")
    end
)