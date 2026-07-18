for _, v in ipairs(Lighting:GetChildren()) do
    if v:IsA("PostEffect") or v:IsA("Atmosphere") then
        v:Destroy()
    end
end

local Atmosphere = Instance.new("Atmosphere")
Atmosphere.Parent = Lighting

local ColorCorrection = Instance.new("ColorCorrectionEffect")
ColorCorrection.Parent = Lighting

local Bloom = Instance.new("BloomEffect")
Bloom.Parent = Lighting

local SunRays = Instance.new("SunRaysEffect")
SunRays.Parent = Lighting

local DOF = Instance.new("DepthOfFieldEffect")
DOF.Parent = Lighting

local Shaders = {
    Night = {
        Lighting = {
            ClockTime = 0,
            Brightness = 1,
            ExposureCompensation = -0.2,
            Ambient = Color3.fromRGB(30, 34, 52),
            OutdoorAmbient = Color3.fromRGB(42, 50, 78),
            ColorShift_Top = Color3.fromRGB(60, 82, 150),
            ColorShift_Bottom = Color3.fromRGB(12, 16, 32),
            ShadowSoftness = 0.15
        },
        Atmosphere = {
            Color = Color3.fromRGB(70, 90, 160),
            Decay = Color3.fromRGB(20, 26, 48),
            Density = 0.4,
            Offset = 0,
            Glare = 0,
            Haze = 2.1
        },
        ColorCorrection = {
            Brightness = -0.04,
            Contrast = 0.22,
            Saturation = -0.15,
            TintColor = Color3.fromRGB(185, 205, 255)
        },
        Bloom = { Intensity = 0.07, Size = 30, Threshold = 1 },
        SunRays = { Intensity = 0, Spread = 1 },
        DOF = { FocusDistance = 120, InFocusRadius = 120, NearIntensity = 0, FarIntensity = 0.09 },
        Water = { Color = Color3.fromRGB(20, 38, 72), Transparency = 0.25, Reflectance = 0.1, WaveSize = 0.15, WaveSpeed = 10 }
    },
    Sunrise = {
        Lighting = {
            ClockTime = 6,
            Brightness = 2.2,
            ExposureCompensation = 0.14,
            Ambient = Color3.fromRGB(78, 68, 78),
            OutdoorAmbient = Color3.fromRGB(140, 132, 130),
            ColorShift_Top = Color3.fromRGB(255, 170, 120),
            ColorShift_Bottom = Color3.fromRGB(255, 205, 170),
            ShadowSoftness = 0.25
        },
        Atmosphere = {
            Color = Color3.fromRGB(255, 175, 130),
            Decay = Color3.fromRGB(190, 130, 105),
            Density = 0.38,
            Offset = 0,
            Glare = 0.22,
            Haze = 2.0
        },
        ColorCorrection = {
            Brightness = 0.02,
            Contrast = 0.2,
            Saturation = 0.2,
            TintColor = Color3.fromRGB(255, 225, 200)
        },
        Bloom = { Intensity = 0.26, Size = 42, Threshold = 0.92 },
        SunRays = { Intensity = 0.18, Spread = 0.97 },
        DOF = { FocusDistance = 120, InFocusRadius = 120, NearIntensity = 0, FarIntensity = 0.035 },
        Water = { Color = Color3.fromRGB(110, 155, 220), Transparency = 0.2, Reflectance = 0.1, WaveSize = 0.15, WaveSpeed = 10 }
    },
    Morning = {
        Lighting = {
            ClockTime = 8.5,
            Brightness = 3,
            ExposureCompensation = 0.22,
            Ambient = Color3.fromRGB(90, 92, 100),
            OutdoorAmbient = Color3.fromRGB(168, 168, 168),
            ColorShift_Top = Color3.fromRGB(255, 235, 210),
            ColorShift_Bottom = Color3.fromRGB(248, 244, 235),
            ShadowSoftness = 0.18
        },
        Atmosphere = {
            Color = Color3.fromRGB(225, 220, 210),
            Decay = Color3.fromRGB(150, 150, 155),
            Density = 0.24,
            Offset = 0,
            Glare = 0.1,
            Haze = 1.2
        },
        ColorCorrection = {
            Brightness = 0.02,
            Contrast = 0.15,
            Saturation = 0.08,
            TintColor = Color3.fromRGB(255, 250, 244)
        },
        Bloom = { Intensity = 0.14, Size = 34, Threshold = 0.97 },
        SunRays = { Intensity = 0.08, Spread = 0.88 },
        DOF = { FocusDistance = 130, InFocusRadius = 130, NearIntensity = 0, FarIntensity = 0.02 },
        Water = { Color = Color3.fromRGB(70, 145, 230), Transparency = 0.2, Reflectance = 0.1, WaveSize = 0.15, WaveSpeed = 10 }
    },
    Afternoon = {
        Lighting = {
            ClockTime = 13,
            Brightness = 3.8,
            ExposureCompensation = 0.4,
            Ambient = Color3.fromRGB(98, 98, 108),
            OutdoorAmbient = Color3.fromRGB(175, 175, 175),
            ColorShift_Top = Color3.fromRGB(250, 250, 248),
            ColorShift_Bottom = Color3.fromRGB(238, 242, 255),
            ShadowSoftness = 0.15
        },
        Atmosphere = {
            Color = Color3.fromRGB(200, 222, 250),
            Decay = Color3.fromRGB(100, 112, 130),
            Density = 0.18,
            Offset = 0,
            Glare = 0.06,
            Haze = 1.1
        },
        ColorCorrection = {
            Brightness = 0.03,
            Contrast = 0.2,
            Saturation = 0.12,
            TintColor = Color3.fromRGB(255, 253, 250)
        },
        Bloom = { Intensity = 0.2, Size = 36, Threshold = 0.95 },
        SunRays = { Intensity = 0.1, Spread = 0.9 },
        DOF = { FocusDistance = 110, InFocusRadius = 130, NearIntensity = 0, FarIntensity = 0.025 },
        Water = { Color = Color3.fromRGB(30, 130, 255), Transparency = 0.18, Reflectance = 0.12, WaveSize = 0.15, WaveSpeed = 10 }
    },
    Evening = {
        Lighting = {
            ClockTime = 17.75,
            Brightness = 2.4,
            ExposureCompensation = 0.1,
            Ambient = Color3.fromRGB(85, 74, 76),
            OutdoorAmbient = Color3.fromRGB(140, 124, 114),
            ColorShift_Top = Color3.fromRGB(255, 165, 105),
            ColorShift_Bottom = Color3.fromRGB(255, 130, 95),
            ShadowSoftness = 0.28
        },
        Atmosphere = {
            Color = Color3.fromRGB(255, 155, 110),
            Decay = Color3.fromRGB(170, 95, 80),
            Density = 0.4,
            Offset = 0,
            Glare = 0.2,
            Haze = 2.2
        },
        ColorCorrection = {
            Brightness = 0.01,
            Contrast = 0.26,
            Saturation = 0.26,
            TintColor = Color3.fromRGB(255, 210, 180)
        },
        Bloom = { Intensity = 0.24, Size = 40, Threshold = 0.93 },
        SunRays = { Intensity = 0.17, Spread = 0.97 },
        DOF = { FocusDistance = 100, InFocusRadius = 120, NearIntensity = 0, FarIntensity = 0.05 },
        Water = { Color = Color3.fromRGB(190, 120, 80), Transparency = 0.2, Reflectance = 0.1, WaveSize = 0.15, WaveSpeed = 10 }
    },
    Sunset = {
        Lighting = {
            ClockTime = 19,
            Brightness = 1.9,
            ExposureCompensation = 0.06,
            Ambient = Color3.fromRGB(68, 56, 64),
            OutdoorAmbient = Color3.fromRGB(115, 98, 92),
            ColorShift_Top = Color3.fromRGB(255, 120, 65),
            ColorShift_Bottom = Color3.fromRGB(255, 80, 55),
            ShadowSoftness = 0.32
        },
        Atmosphere = {
            Color = Color3.fromRGB(255, 130, 85),
            Decay = Color3.fromRGB(155, 65, 62),
            Density = 0.48,
            Offset = 0,
            Glare = 0.28,
            Haze = 2.6
        },
        ColorCorrection = {
            Brightness = 0,
            Contrast = 0.32,
            Saturation = 0.36,
            TintColor = Color3.fromRGB(255, 190, 155)
        },
        Bloom = { Intensity = 0.32, Size = 46, Threshold = 0.88 },
        SunRays = { Intensity = 0.22, Spread = 1 },
        DOF = { FocusDistance = 95, InFocusRadius = 115, NearIntensity = 0, FarIntensity = 0.07 },
        Water = { Color = Color3.fromRGB(160, 90, 58), Transparency = 0.22, Reflectance = 0.1, WaveSize = 0.15, WaveSpeed = 10 }
    },
}

local function ApplyPreset(P)
    Lighting.ClockTime = P.Lighting.ClockTime
    Lighting.Brightness = P.Lighting.Brightness
    Lighting.ExposureCompensation = P.Lighting.ExposureCompensation
    Lighting.Ambient = P.Lighting.Ambient
    Lighting.OutdoorAmbient = P.Lighting.OutdoorAmbient
    Lighting.ColorShift_Top = P.Lighting.ColorShift_Top
    Lighting.ColorShift_Bottom = P.Lighting.ColorShift_Bottom
    Lighting.ShadowSoftness = P.Lighting.ShadowSoftness

    Atmosphere.Color = P.Atmosphere.Color
    Atmosphere.Decay = P.Atmosphere.Decay
    Atmosphere.Density = P.Atmosphere.Density
    Atmosphere.Offset = P.Atmosphere.Offset
    Atmosphere.Glare = P.Atmosphere.Glare
    Atmosphere.Haze = P.Atmosphere.Haze

    ColorCorrection.Brightness = P.ColorCorrection.Brightness
    ColorCorrection.Contrast = P.ColorCorrection.Contrast
    ColorCorrection.Saturation = P.ColorCorrection.Saturation
    ColorCorrection.TintColor = P.ColorCorrection.TintColor

    Bloom.Intensity = P.Bloom.Intensity
    Bloom.Size = P.Bloom.Size
    Bloom.Threshold = P.Bloom.Threshold

    SunRays.Intensity = P.SunRays.Intensity
    SunRays.Spread = P.SunRays.Spread

    DOF.FocusDistance = P.DOF.FocusDistance
    DOF.InFocusRadius = P.DOF.InFocusRadius
    DOF.NearIntensity = P.DOF.NearIntensity
    DOF.FarIntensity = P.DOF.FarIntensity

    if Terrain then
        Terrain.WaterColor = P.Water.Color
        Terrain.WaterTransparency = P.Water.Transparency
        Terrain.WaterReflectance = P.Water.Reflectance
        Terrain.WaterWaveSize = P.Water.WaveSize
        Terrain.WaterWaveSpeed = P.Water.WaveSpeed
    end
end

local function SetShader(Name)
    local P = Shaders[Name]
    if not P then return end
    ApplyPreset(P)
end

local function lerp(a, b, t)
    return a + (b - a) * t
end

local function lerpColor(a, b, t)
    return Color3.new(
        lerp(a.R, b.R, t),
        lerp(a.G, b.G, t),
        lerp(a.B, b.B, t)
    )
end

local function lerpSection(a, b, t)
    local out = {}
    for k, v in pairs(a) do
        local bv = b[k]
        if typeof(v) == "Color3" then
            out[k] = lerpColor(v, bv, t)
        else
            out[k] = lerp(v, bv, t)
        end
    end
    return out
end

local function BlendPresets(A, B, t)
    return {
        Lighting = lerpSection(A.Lighting, B.Lighting, t),
        Atmosphere = lerpSection(A.Atmosphere, B.Atmosphere, t),
        ColorCorrection = lerpSection(A.ColorCorrection, B.ColorCorrection, t),
        Bloom = lerpSection(A.Bloom, B.Bloom, t),
        SunRays = lerpSection(A.SunRays, B.SunRays, t),
        DOF = lerpSection(A.DOF, B.DOF, t),
        Water = lerpSection(A.Water, B.Water, t),
    }
end

local function GetLocalHour()
    local t = os.date("*t")
    return t.hour + (t.min / 60) + (t.sec / 3600)
end

local function GetBlendForHour(hour)
    local ShaderOrder = { "Night", "Sunrise", "Morning", "Afternoon", "Evening", "Sunset" }
    local n = #ShaderOrder
    for i = 1, n do
        local currName = ShaderOrder[i]
        local nextName = ShaderOrder[(i % n) + 1]
        local currTime = Shaders[currName].Lighting.ClockTime
        local nextTime = Shaders[nextName].Lighting.ClockTime

        local span = nextTime - currTime
        if span <= 0 then
            span = span + 24
        end

        local delta = hour - currTime
        if delta < 0 then
            delta = delta + 24
        end

        if delta <= span then
            local t = span > 0 and (delta / span) or 0
            return currName, nextName, t
        end
    end
    return ShaderOrder[1], ShaderOrder[1], 0
end

local RealisticActive = false
local RealisticConn = nil

local function UpdateRealistic()
    local hour = GetLocalHour()
    local nameA, nameB, t = GetBlendForHour(hour)
    local Blended = BlendPresets(Shaders[nameA], Shaders[nameB], t)
    ApplyPreset(Blended)
end

local function StartRealistic()
    if RealisticActive then return end
    RealisticActive = true
    UpdateRealistic()
    RealisticConn = RunService.Heartbeat:Connect(function()
        UpdateRealistic()
    end)
end

local function StopRealistic()
    RealisticActive = false
    if RealisticConn then
        RealisticConn:Disconnect()
        RealisticConn = nil
    end
end

Cmd.Reg(Cmd.new({"setshader", "ss"}, function(Args)
    local input = Args[2]
    if not input then
        DebugNotif("Usage: .setshader <Night/Sunrise/Morning/Afternoon/Evening/Sunset/Realistic>")
        return
    end

    local lowerInput = input:lower()

    if lowerInput == "realistic" then
        StartRealistic()
        DebugNotif("Shader: Realistic (following local time)")
        return
    end

    if lowerInput == "off" or lowerInput == "stop" then
        StopRealistic()
        DebugNotif("Realistic shader mode stopped")
        return
    end

    StopRealistic()

    local shaderName = nil
    for key, _ in pairs(Shaders) do
        if key:lower() == lowerInput then
            shaderName = key
            break
        end
    end

    if not shaderName then
        DebugNotif("Invalid shader. Choose: Night, Sunrise, Morning, Afternoon, Evening, Sunset, Realistic")
        return
    end

    SetShader(shaderName)
    DebugNotif("Shader set to " .. shaderName)
end))
