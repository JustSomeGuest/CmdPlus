for _, v in ipairs(Lighting:GetChildren()) do
    if v:IsA("PostEffect") or v:IsA("Atmosphere") then
        v:Destroy()
    end
end

local OriginalLighting = {
    ClockTime = Lighting.ClockTime,
    Brightness = Lighting.Brightness,
    ExposureCompensation = Lighting.ExposureCompensation,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    ColorShift_Top = Lighting.ColorShift_Top,
    ColorShift_Bottom = Lighting.ColorShift_Bottom,
    ShadowSoftness = Lighting.ShadowSoftness,
}

local OriginalWater = nil
if Terrain then
    OriginalWater = {
        Color = Terrain.WaterColor,
        Transparency = Terrain.WaterTransparency,
        Reflectance = Terrain.WaterReflectance,
        WaveSize = Terrain.WaterWaveSize,
        WaveSpeed = Terrain.WaterWaveSpeed,
    }
end

local OriginalSky = Lighting:FindFirstChildOfClass("Sky")

local StormSky = Instance.new("Sky")
StormSky.Name = "WeatherStormSky"
StormSky.SkyboxBk = "rbxassetid://4495864450"
StormSky.SkyboxDn = "rbxassetid://4495864887"
StormSky.SkyboxFt = "rbxassetid://4495865458"
StormSky.SkyboxLf = "rbxassetid://4495866035"
StormSky.SkyboxRt = "rbxassetid://4495866584"
StormSky.SkyboxUp = "rbxassetid://4495867486"
StormSky.SunTextureId = ""
StormSky.MoonTextureId = ""
StormSky.SunAngularSize = 1
StormSky.MoonAngularSize = 1
StormSky.StarCount = 3000
StormSky.CelestialBodiesShown = true
StormSky.SkyboxOrientation = Vector3.new(0, 0, 0)

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

local RainSound = Instance.new("Sound")
RainSound.Name = "WeatherRain"
RainSound.SoundId = GetAsset("SimpleCMDS/Assets/Rain.mp3") or ""
RainSound.Looped = true
RainSound.Volume = 0.5
RainSound.Parent = SoundService

local ThunderSound = Instance.new("Sound")
ThunderSound.Name = "WeatherThunder"
ThunderSound.SoundId = GetAsset("SimpleCMDS/Assets/Thunder.mp3") or ""
ThunderSound.Looped = true
ThunderSound.Volume = 0.35
ThunderSound.Parent = SoundService

local Player = Players.LocalPlayer
local CurrentLightConfig = nil

local RainPart = Instance.new("Part")
RainPart.Name = "WeatherRainEmitter"
RainPart.Size = Vector3.new(120, 1, 120)
RainPart.Anchored = true
RainPart.CanCollide = false
RainPart.CanQuery = false
RainPart.CanTouch = false
RainPart.Transparency = 1
RainPart.Parent = Workspace

local RainEmitter = Instance.new("ParticleEmitter")
RainEmitter.Name = "RainEmitter"
RainEmitter.Texture = "rbxasset://textures/particles/fire_main.dds"
RainEmitter.Color = ColorSequence.new(Color3.fromRGB(174, 194, 224))
RainEmitter.Size = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.05),
    NumberSequenceKeypoint.new(1, 0.05),
})
RainEmitter.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.2),
    NumberSequenceKeypoint.new(1, 0.5),
})
RainEmitter.Lifetime = NumberRange.new(1.1, 1.4)
RainEmitter.Rate = 0
RainEmitter.Speed = NumberRange.new(60, 60)
RainEmitter.SpreadAngle = Vector2.new(0, 0)
RainEmitter.Acceleration = Vector3.new(0, -50, 0)
RainEmitter.RotSpeed = NumberRange.new(0, 0)
RainEmitter.Rotation = NumberRange.new(0, 0)
RainEmitter.LightEmission = 0
RainEmitter.EmissionDirection = Enum.NormalId.Bottom
RainEmitter.Orientation = Enum.ParticleOrientation.VelocityParallel
RainEmitter.Parent = RainPart

local RainRaycastFilter = RaycastParams.new()
RainRaycastFilter.FilterType = Enum.RaycastFilterType.Exclude
RainRaycastFilter.FilterDescendantsInstances = { RainPart }

local RainIntensityConfig = {
    Rain = { Rate = 300, Speed = 60, PuddleInterval = 0.2, PuddleChance = 0.5, PuddleRadius = 30 },
    Thunderstorm = { Rate = 550, Speed = 80, PuddleInterval = 0.12, PuddleChance = 0.75, PuddleRadius = 35 },
}

local RainEffectActive = false
local RainLoopConn = nil
local PuddleLoopThread = nil
local ActivePuddles = {}

local function CreatePuddle(Position, Normal)
    local Puddle = Instance.new("Part")
    Puddle.Name = "WeatherPuddle"
    Puddle.Shape = Enum.PartType.Cylinder
    Puddle.Material = Enum.Material.SmoothPlastic
    Puddle.Color = Color3.fromRGB(35, 40, 55)
    Puddle.Anchored = true
    Puddle.CanCollide = false
    Puddle.CanQuery = false
    Puddle.CanTouch = false
    Puddle.Transparency = 1

    local Size = math.random(3, 6)
    Puddle.Size = Vector3.new(0.05, Size, Size)

    local XAxis = Normal
    local Reference = (math.abs(XAxis.Y) < 0.99) and Vector3.new(0, 1, 0) or Vector3.new(1, 0, 0)
    local ZAxis = XAxis:Cross(Reference).Unit
    local YAxis = ZAxis:Cross(XAxis).Unit
    Puddle.CFrame = CFrame.fromMatrix(Position, XAxis, YAxis, ZAxis)

    Puddle.Parent = Workspace

    ActivePuddles[Puddle] = true

    local FadeIn = TweenService:Create(Puddle, TweenInfo.new(0.4), { Transparency = 0.35 })
    FadeIn:Play()

    task.delay(math.random(4, 8), function()
        if not Puddle.Parent then
            ActivePuddles[Puddle] = nil
            return
        end
        local FadeOut = TweenService:Create(Puddle, TweenInfo.new(1.2), { Transparency = 1 })
        FadeOut:Play()
        FadeOut.Completed:Wait()
        ActivePuddles[Puddle] = nil
        Puddle:Destroy()
    end)
end

local function SpawnPuddleNearPlayer(Radius)
    local Character = Player.Character
    if not Character then return end

    local Root = Character:FindFirstChild("HumanoidRootPart")
    if not Root then return end

    local OffsetX = math.random(-Radius, Radius)
    local OffsetZ = math.random(-Radius, Radius)
    local Origin = Root.Position + Vector3.new(OffsetX, 20, OffsetZ)
    local Result = Workspace:Raycast(Origin, Vector3.new(0, -60, 0), RainRaycastFilter)

    if Result and Result.Instance then
        CreatePuddle(Result.Position, Result.Normal)
    end
end

local function StartRainEffects(Intensity)
    RainEffectActive = true
    RainEmitter.Rate = Intensity.Rate
    RainEmitter.Speed = NumberRange.new(Intensity.Speed, Intensity.Speed)

    if not RainLoopConn then
        RainLoopConn = RunService.Heartbeat:Connect(function()
            local Character = Player.Character
            local Root = Character and Character:FindFirstChild("HumanoidRootPart")
            if Root then
                RainPart.CFrame = CFrame.new(Root.Position + Vector3.new(0, 45, 0))
            end
        end)
    end

    if not PuddleLoopThread then
        PuddleLoopThread = task.spawn(function()
            while RainEffectActive do
                task.wait(Intensity.PuddleInterval)
                if math.random() <= Intensity.PuddleChance then
                    SpawnPuddleNearPlayer(Intensity.PuddleRadius)
                end
            end
            PuddleLoopThread = nil
        end)
    end
end

local function StopRainEffects()
    RainEffectActive = false
    RainEmitter.Rate = 0

    if RainLoopConn then
        RainLoopConn:Disconnect()
        RainLoopConn = nil
    end
end

local function UpdateWeatherParticles(WeatherName)
    local Intensity = RainIntensityConfig[WeatherName]
    if Intensity then
        StartRainEffects(Intensity)
    else
        StopRainEffects()
    end
end

local function SetupLight(Character)
    local Root = Character:WaitForChild("HumanoidRootPart")

    local Light = Root:FindFirstChild("TorchLight")
    if not Light then
        Light = Instance.new("PointLight")
        Light.Name = "TorchLight"
        Light.Parent = Root
    end

    if CurrentLightConfig then
        Light.Enabled = CurrentLightConfig.Brightness > 0.05
        Light.Brightness = CurrentLightConfig.Brightness
        Light.Range = CurrentLightConfig.Range
        Light.Color = CurrentLightConfig.Color
        Light.Shadows = true
    else
        Light.Enabled = false
    end
end

if Player.Character then
    SetupLight(Player.Character)
end

Player.CharacterAdded:Connect(SetupLight)

local function ApplyCharacterLight(LightConfig)
    CurrentLightConfig = LightConfig

    local Character = Player.Character
    if not Character then
        return
    end

    local Root = Character:FindFirstChild("HumanoidRootPart")
    if not Root then
        return
    end

    local Light = Root:FindFirstChild("TorchLight")
    if not Light then
        Light = Instance.new("PointLight")
        Light.Name = "TorchLight"
        Light.Parent = Root
    end

    Light.Enabled = LightConfig.Brightness > 0.05
    Light.Brightness = LightConfig.Brightness
    Light.Range = LightConfig.Range
    Light.Color = LightConfig.Color
    Light.Shadows = true
end

local TimeOfDay = {
    Night = {
        Emoji = "🌙",
        Lighting = {
            ClockTime = 0,
            Brightness = 0.6,
            ExposureCompensation = -0.3,
            Ambient = Color3.fromRGB(24, 27, 40),
            OutdoorAmbient = Color3.fromRGB(34, 40, 60),
            ColorShift_Top = Color3.fromRGB(50, 68, 120),
            ColorShift_Bottom = Color3.fromRGB(10, 13, 26),
            ShadowSoftness = 0.2
        },
        Atmosphere = {
            Color = Color3.fromRGB(60, 78, 135),
            Decay = Color3.fromRGB(15, 20, 38),
            Density = 0.36,
            Offset = 0,
            Glare = 0,
            Haze = 1.6
        },
        ColorCorrection = {
            Brightness = -0.05,
            Contrast = 0.15,
            Saturation = -0.2,
            TintColor = Color3.fromRGB(190, 205, 240)
        },
        Bloom = { Intensity = 0.05, Size = 24, Threshold = 1.1 },
        SunRays = { Intensity = 0, Spread = 1 },
        DOF = { FocusDistance = 120, InFocusRadius = 120, NearIntensity = 0, FarIntensity = 0.06 },
        Water = { Color = Color3.fromRGB(18, 34, 64), Transparency = 0.3, Reflectance = 0.15, WaveSize = 0.12, WaveSpeed = 8 },
        Light = { Brightness = 1.2, Range = 12, Color = Color3.fromRGB(255, 235, 200) }
    },
    Sunrise = {
        Emoji = "🌅",
        Lighting = {
            ClockTime = 6,
            Brightness = 1.6,
            ExposureCompensation = 0.05,
            Ambient = Color3.fromRGB(68, 60, 68),
            OutdoorAmbient = Color3.fromRGB(120, 112, 112),
            ColorShift_Top = Color3.fromRGB(255, 178, 130),
            ColorShift_Bottom = Color3.fromRGB(255, 200, 165),
            ShadowSoftness = 0.3
        },
        Atmosphere = {
            Color = Color3.fromRGB(255, 180, 135),
            Decay = Color3.fromRGB(175, 120, 100),
            Density = 0.34,
            Offset = 0,
            Glare = 0.15,
            Haze = 1.7
        },
        ColorCorrection = {
            Brightness = 0.01,
            Contrast = 0.15,
            Saturation = 0.14,
            TintColor = Color3.fromRGB(255, 228, 205)
        },
        Bloom = { Intensity = 0.18, Size = 34, Threshold = 0.95 },
        SunRays = { Intensity = 0.12, Spread = 0.95 },
        DOF = { FocusDistance = 120, InFocusRadius = 120, NearIntensity = 0, FarIntensity = 0.025 },
        Water = { Color = Color3.fromRGB(100, 145, 210), Transparency = 0.22, Reflectance = 0.12, WaveSize = 0.12, WaveSpeed = 8 },
        Light = { Brightness = 0.25, Range = 9, Color = Color3.fromRGB(255, 225, 190) }
    },
    Morning = {
        Emoji = "🌄",
        Lighting = {
            ClockTime = 8.5,
            Brightness = 2.2,
            ExposureCompensation = 0.12,
            Ambient = Color3.fromRGB(85, 87, 95),
            OutdoorAmbient = Color3.fromRGB(150, 150, 150),
            ColorShift_Top = Color3.fromRGB(250, 235, 215),
            ColorShift_Bottom = Color3.fromRGB(245, 242, 232),
            ShadowSoftness = 0.2
        },
        Atmosphere = {
            Color = Color3.fromRGB(215, 212, 205),
            Decay = Color3.fromRGB(140, 140, 148),
            Density = 0.2,
            Offset = 0,
            Glare = 0.06,
            Haze = 1.0
        },
        ColorCorrection = {
            Brightness = 0.01,
            Contrast = 0.1,
            Saturation = 0.05,
            TintColor = Color3.fromRGB(255, 250, 244)
        },
        Bloom = { Intensity = 0.1, Size = 28, Threshold = 1.0 },
        SunRays = { Intensity = 0.05, Spread = 0.85 },
        DOF = { FocusDistance = 130, InFocusRadius = 130, NearIntensity = 0, FarIntensity = 0.015 },
        Water = { Color = Color3.fromRGB(65, 140, 220), Transparency = 0.2, Reflectance = 0.1, WaveSize = 0.12, WaveSpeed = 8 },
        Light = { Brightness = 0, Range = 9, Color = Color3.fromRGB(255, 250, 244) }
    },
    Noon = {
        Emoji = "☀️",
        Lighting = {
            ClockTime = 12,
            Brightness = 3,
            ExposureCompensation = 0.28,
            Ambient = Color3.fromRGB(100, 100, 108),
            OutdoorAmbient = Color3.fromRGB(180, 180, 180),
            ColorShift_Top = Color3.fromRGB(248, 249, 252),
            ColorShift_Bottom = Color3.fromRGB(235, 240, 252),
            ShadowSoftness = 0.12
        },
        Atmosphere = {
            Color = Color3.fromRGB(190, 214, 245),
            Decay = Color3.fromRGB(90, 102, 120),
            Density = 0.13,
            Offset = 0,
            Glare = 0.03,
            Haze = 0.8
        },
        ColorCorrection = {
            Brightness = 0.02,
            Contrast = 0.12,
            Saturation = 0.06,
            TintColor = Color3.fromRGB(255, 255, 252)
        },
        Bloom = { Intensity = 0.14, Size = 30, Threshold = 1.02 },
        SunRays = { Intensity = 0.07, Spread = 0.9 },
        DOF = { FocusDistance = 115, InFocusRadius = 140, NearIntensity = 0, FarIntensity = 0.015 },
        Water = { Color = Color3.fromRGB(22, 128, 252), Transparency = 0.16, Reflectance = 0.14, WaveSize = 0.12, WaveSpeed = 8 },
        Light = { Brightness = 0, Range = 9, Color = Color3.fromRGB(255, 255, 252) }
    },
    Afternoon = {
        Emoji = "🌞",
        Lighting = {
            ClockTime = 15.5,
            Brightness = 2.6,
            ExposureCompensation = 0.2,
            Ambient = Color3.fromRGB(92, 92, 100),
            OutdoorAmbient = Color3.fromRGB(158, 158, 158),
            ColorShift_Top = Color3.fromRGB(250, 244, 232),
            ColorShift_Bottom = Color3.fromRGB(240, 236, 224),
            ShadowSoftness = 0.16
        },
        Atmosphere = {
            Color = Color3.fromRGB(220, 210, 190),
            Decay = Color3.fromRGB(110, 105, 100),
            Density = 0.17,
            Offset = 0,
            Glare = 0.05,
            Haze = 1.0
        },
        ColorCorrection = {
            Brightness = 0.015,
            Contrast = 0.13,
            Saturation = 0.08,
            TintColor = Color3.fromRGB(255, 248, 238)
        },
        Bloom = { Intensity = 0.14, Size = 30, Threshold = 1.0 },
        SunRays = { Intensity = 0.08, Spread = 0.9 },
        DOF = { FocusDistance = 110, InFocusRadius = 135, NearIntensity = 0, FarIntensity = 0.02 },
        Water = { Color = Color3.fromRGB(30, 120, 240), Transparency = 0.18, Reflectance = 0.12, WaveSize = 0.12, WaveSpeed = 8 },
        Light = { Brightness = 0, Range = 9, Color = Color3.fromRGB(255, 248, 238) }
    },
    Sunset = {
        Emoji = "🌇",
        Lighting = {
            ClockTime = 18.5,
            Brightness = 1.4,
            ExposureCompensation = -0.02,
            Ambient = Color3.fromRGB(62, 50, 58),
            OutdoorAmbient = Color3.fromRGB(105, 88, 84),
            ColorShift_Top = Color3.fromRGB(255, 134, 76),
            ColorShift_Bottom = Color3.fromRGB(255, 94, 65),
            ShadowSoftness = 0.35
        },
        Atmosphere = {
            Color = Color3.fromRGB(255, 142, 96),
            Decay = Color3.fromRGB(145, 62, 60),
            Density = 0.4,
            Offset = 0,
            Glare = 0.2,
            Haze = 2.0
        },
        ColorCorrection = {
            Brightness = -0.02,
            Contrast = 0.22,
            Saturation = 0.24,
            TintColor = Color3.fromRGB(255, 200, 168)
        },
        Bloom = { Intensity = 0.2, Size = 36, Threshold = 0.93 },
        SunRays = { Intensity = 0.15, Spread = 1 },
        DOF = { FocusDistance = 95, InFocusRadius = 115, NearIntensity = 0, FarIntensity = 0.04 },
        Water = { Color = Color3.fromRGB(155, 84, 56), Transparency = 0.22, Reflectance = 0.1, WaveSize = 0.12, WaveSpeed = 8 },
        Light = { Brightness = 0.7, Range = 11, Color = Color3.fromRGB(255, 180, 130) }
    },
    Evening = {
        Emoji = "🌆",
        Lighting = {
            ClockTime = 20.5,
            Brightness = 0.95,
            ExposureCompensation = -0.15,
            Ambient = Color3.fromRGB(36, 34, 48),
            OutdoorAmbient = Color3.fromRGB(52, 52, 76),
            ColorShift_Top = Color3.fromRGB(90, 90, 150),
            ColorShift_Bottom = Color3.fromRGB(30, 24, 50),
            ShadowSoftness = 0.25
        },
        Atmosphere = {
            Color = Color3.fromRGB(95, 100, 165),
            Decay = Color3.fromRGB(30, 30, 55),
            Density = 0.38,
            Offset = 0,
            Glare = 0.05,
            Haze = 1.8
        },
        ColorCorrection = {
            Brightness = -0.03,
            Contrast = 0.18,
            Saturation = -0.05,
            TintColor = Color3.fromRGB(210, 210, 245)
        },
        Bloom = { Intensity = 0.1, Size = 28, Threshold = 1.05 },
        SunRays = { Intensity = 0.02, Spread = 0.95 },
        DOF = { FocusDistance = 110, InFocusRadius = 120, NearIntensity = 0, FarIntensity = 0.05 },
        Water = { Color = Color3.fromRGB(28, 30, 62), Transparency = 0.28, Reflectance = 0.12, WaveSize = 0.12, WaveSpeed = 8 },
        Light = { Brightness = 1.0, Range = 12, Color = Color3.fromRGB(255, 220, 175) }
    },
}

local TimeOrder = { "Night", "Sunrise", "Morning", "Noon", "Afternoon", "Sunset", "Evening" }

local TimeAliases = {
    dawn = "Sunrise",
    dusk = "Evening",
    midday = "Noon",
    midnight = "Night",
}

local Weather = {
    Clear = {
        Emoji = "🌤️",
        BrightnessMul = 1,
        SaturationAdd = 0,
        HazeAdd = 0,
        DensityAdd = 0,
        Sound = nil
    },
    Cloudy = {
        Emoji = "☁️",
        BrightnessMul = 0.82,
        SaturationAdd = -0.12,
        HazeAdd = 0.5,
        DensityAdd = 0.08,
        Sound = nil
    },
    Rain = {
        Emoji = "🌧️",
        BrightnessMul = 0.68,
        SaturationAdd = -0.16,
        HazeAdd = 0.7,
        DensityAdd = 0.13,
        Sound = "Rain"
    },
    Thunderstorm = {
        Emoji = "⛈️",
        BrightnessMul = 0.5,
        SaturationAdd = -0.24,
        HazeAdd = 1.0,
        DensityAdd = 0.2,
        Sound = "Thunderstorm"
    },
    Fog = {
        Emoji = "🌫️",
        BrightnessMul = 0.88,
        SaturationAdd = -0.05,
        HazeAdd = 1.4,
        DensityAdd = 0.28,
        Sound = nil
    },
}

local WeatherAliases = {
    sunny = "Clear",
    clouds = "Cloudy",
    overcast = "Cloudy",
    rainy = "Rain",
    raining = "Rain",
    storm = "Thunderstorm",
    stormy = "Thunderstorm",
    thunder = "Thunderstorm",
    foggy = "Fog",
    misty = "Fog",
}

local function clamp01(v)
    if v < 0 then return 0 end
    if v > 1 then return 1 end
    return v
end

local function ResolveTimeName(input)
    local lower = input:lower()
    if TimeAliases[lower] then
        return TimeAliases[lower]
    end
    for key, _ in pairs(TimeOfDay) do
        if key:lower() == lower then
            return key
        end
    end
    return nil
end

local function ResolveWeatherName(input)
    local lower = input:lower()
    if WeatherAliases[lower] then
        return WeatherAliases[lower]
    end
    for key, _ in pairs(Weather) do
        if key:lower() == lower then
            return key
        end
    end
    return nil
end

local CurrentTimeName = "Morning"
local CurrentWeatherName = "Clear"
local ThunderFlashActive = false
local ThunderFlashConn = nil

local function StopThunderFlash()
    ThunderFlashActive = false
    if ThunderFlashConn then
        ThunderFlashConn:Disconnect()
        ThunderFlashConn = nil
    end
end

local function StartThunderFlash()
    if ThunderFlashActive then return end
    ThunderFlashActive = true

    task.spawn(function()
        while ThunderFlashActive do
            task.wait(math.random(4, 11))
            if not ThunderFlashActive then break end

            local OriginalBrightness = ColorCorrection.Brightness
            local OriginalBloom = Bloom.Intensity

            ColorCorrection.Brightness = OriginalBrightness + 0.5
            Bloom.Intensity = OriginalBloom + 0.4
            task.wait(0.06)
            ColorCorrection.Brightness = OriginalBrightness
            Bloom.Intensity = OriginalBloom
            task.wait(0.08)
            ColorCorrection.Brightness = OriginalBrightness + 0.3
            task.wait(0.05)
            ColorCorrection.Brightness = OriginalBrightness
        end
    end)
end

local function UpdateWeatherSound(WeatherName)
    local W = Weather[WeatherName]

    if W.Sound == "Rain" then
        if not RainSound.IsPlaying then
            RainSound:Play()
        end
        ThunderSound:Stop()
        StopThunderFlash()
    elseif W.Sound == "Thunderstorm" then
        if not RainSound.IsPlaying then
            RainSound:Play()
        end
        if not ThunderSound.IsPlaying then
            ThunderSound:Play()
        end
        StartThunderFlash()
    else
        RainSound:Stop()
        ThunderSound:Stop()
        StopThunderFlash()
    end
end

local function UpdateWeatherSky(WeatherName)
    local W = Weather[WeatherName]

    if W.Sound == "Rain" or W.Sound == "Thunderstorm" then
        if OriginalSky then
            OriginalSky.Parent = nil
        end
        StormSky.Parent = Lighting
    else
        StormSky.Parent = nil
        if OriginalSky then
            OriginalSky.Parent = Lighting
        end
    end
end

local function ApplyCombined(TimeName, WeatherName)
    local T = TimeOfDay[TimeName]
    local W = Weather[WeatherName]
    if not T or not W then return end

    Lighting.ClockTime = T.Lighting.ClockTime
    Lighting.Brightness = T.Lighting.Brightness * W.BrightnessMul
    Lighting.ExposureCompensation = T.Lighting.ExposureCompensation
    Lighting.Ambient = T.Lighting.Ambient
    Lighting.OutdoorAmbient = T.Lighting.OutdoorAmbient
    Lighting.ColorShift_Top = T.Lighting.ColorShift_Top
    Lighting.ColorShift_Bottom = T.Lighting.ColorShift_Bottom
    Lighting.ShadowSoftness = T.Lighting.ShadowSoftness

    Atmosphere.Color = T.Atmosphere.Color
    Atmosphere.Decay = T.Atmosphere.Decay
    Atmosphere.Density = clamp01(T.Atmosphere.Density + W.DensityAdd)
    Atmosphere.Offset = T.Atmosphere.Offset
    Atmosphere.Glare = T.Atmosphere.Glare
    Atmosphere.Haze = T.Atmosphere.Haze + W.HazeAdd

    ColorCorrection.Brightness = T.ColorCorrection.Brightness
    ColorCorrection.Contrast = T.ColorCorrection.Contrast
    ColorCorrection.Saturation = T.ColorCorrection.Saturation + W.SaturationAdd
    ColorCorrection.TintColor = T.ColorCorrection.TintColor

    Bloom.Intensity = T.Bloom.Intensity * W.BrightnessMul
    Bloom.Size = T.Bloom.Size
    Bloom.Threshold = T.Bloom.Threshold

    SunRays.Intensity = T.SunRays.Intensity * W.BrightnessMul
    SunRays.Spread = T.SunRays.Spread

    DOF.FocusDistance = T.DOF.FocusDistance
    DOF.InFocusRadius = T.DOF.InFocusRadius
    DOF.NearIntensity = T.DOF.NearIntensity
    DOF.FarIntensity = T.DOF.FarIntensity

    if Terrain then
        Terrain.WaterColor = T.Water.Color
        Terrain.WaterTransparency = T.Water.Transparency
        Terrain.WaterReflectance = T.Water.Reflectance
        Terrain.WaterWaveSize = T.Water.WaveSize
        Terrain.WaterWaveSpeed = T.Water.WaveSpeed
    end

    ApplyCharacterLight(T.Light)
    UpdateWeatherSound(WeatherName)
    UpdateWeatherSky(WeatherName)
    UpdateWeatherParticles(WeatherName)
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

local function lerpLight(a, b, t)
    return {
        Brightness = lerp(a.Brightness, b.Brightness, t),
        Range = lerp(a.Range, b.Range, t),
        Color = lerpColor(a.Color, b.Color, t),
    }
end

local function BlendTime(A, B, t)
    return {
        Lighting = lerpSection(A.Lighting, B.Lighting, t),
        Atmosphere = lerpSection(A.Atmosphere, B.Atmosphere, t),
        ColorCorrection = lerpSection(A.ColorCorrection, B.ColorCorrection, t),
        Bloom = lerpSection(A.Bloom, B.Bloom, t),
        SunRays = lerpSection(A.SunRays, B.SunRays, t),
        DOF = lerpSection(A.DOF, B.DOF, t),
        Water = lerpSection(A.Water, B.Water, t),
        Light = lerpLight(A.Light, B.Light, t),
    }
end

local function GetLocalHour()
    local t = os.date("*t")
    return t.hour + (t.min / 60) + (t.sec / 3600)
end

local function GetBlendForHour(hour)
    local n = #TimeOrder
    for i = 1, n do
        local currName = TimeOrder[i]
        local nextName = TimeOrder[(i % n) + 1]
        local currTime = TimeOfDay[currName].Lighting.ClockTime
        local nextTime = TimeOfDay[nextName].Lighting.ClockTime

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
    return TimeOrder[1], TimeOrder[1], 0
end

local RealisticActive = false
local RealisticConn = nil

local function UpdateRealistic()
    local hour = GetLocalHour()
    local nameA, nameB, t = GetBlendForHour(hour)
    local Blended = BlendTime(TimeOfDay[nameA], TimeOfDay[nameB], t)
    local W = Weather[CurrentWeatherName]

    Lighting.ClockTime = Blended.Lighting.ClockTime
    Lighting.Brightness = Blended.Lighting.Brightness * W.BrightnessMul
    Lighting.ExposureCompensation = Blended.Lighting.ExposureCompensation
    Lighting.Ambient = Blended.Lighting.Ambient
    Lighting.OutdoorAmbient = Blended.Lighting.OutdoorAmbient
    Lighting.ColorShift_Top = Blended.Lighting.ColorShift_Top
    Lighting.ColorShift_Bottom = Blended.Lighting.ColorShift_Bottom
    Lighting.ShadowSoftness = Blended.Lighting.ShadowSoftness

    Atmosphere.Color = Blended.Atmosphere.Color
    Atmosphere.Decay = Blended.Atmosphere.Decay
    Atmosphere.Density = clamp01(Blended.Atmosphere.Density + W.DensityAdd)
    Atmosphere.Offset = Blended.Atmosphere.Offset
    Atmosphere.Glare = Blended.Atmosphere.Glare
    Atmosphere.Haze = Blended.Atmosphere.Haze + W.HazeAdd

    ColorCorrection.Brightness = Blended.ColorCorrection.Brightness
    ColorCorrection.Contrast = Blended.ColorCorrection.Contrast
    ColorCorrection.Saturation = Blended.ColorCorrection.Saturation + W.SaturationAdd
    ColorCorrection.TintColor = Blended.ColorCorrection.TintColor

    Bloom.Intensity = Blended.Bloom.Intensity * W.BrightnessMul
    Bloom.Size = Blended.Bloom.Size
    Bloom.Threshold = Blended.Bloom.Threshold

    SunRays.Intensity = Blended.SunRays.Intensity * W.BrightnessMul
    SunRays.Spread = Blended.SunRays.Spread

    DOF.FocusDistance = Blended.DOF.FocusDistance
    DOF.InFocusRadius = Blended.DOF.InFocusRadius
    DOF.NearIntensity = Blended.DOF.NearIntensity
    DOF.FarIntensity = Blended.DOF.FarIntensity

    if Terrain then
        Terrain.WaterColor = Blended.Water.Color
        Terrain.WaterTransparency = Blended.Water.Transparency
        Terrain.WaterReflectance = Blended.Water.Reflectance
        Terrain.WaterWaveSize = Blended.Water.WaveSize
        Terrain.WaterWaveSpeed = Blended.Water.WaveSpeed
    end

    ApplyCharacterLight(Blended.Light)
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

local function ResetShader()
    StopRealistic()
    StopThunderFlash()
    RainSound:Stop()
    ThunderSound:Stop()

    Lighting.ClockTime = OriginalLighting.ClockTime
    Lighting.Brightness = OriginalLighting.Brightness
    Lighting.ExposureCompensation = OriginalLighting.ExposureCompensation
    Lighting.Ambient = OriginalLighting.Ambient
    Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
    Lighting.ColorShift_Top = OriginalLighting.ColorShift_Top
    Lighting.ColorShift_Bottom = OriginalLighting.ColorShift_Bottom
    Lighting.ShadowSoftness = OriginalLighting.ShadowSoftness

    if Terrain and OriginalWater then
        Terrain.WaterColor = OriginalWater.Color
        Terrain.WaterTransparency = OriginalWater.Transparency
        Terrain.WaterReflectance = OriginalWater.Reflectance
        Terrain.WaterWaveSize = OriginalWater.WaveSize
        Terrain.WaterWaveSpeed = OriginalWater.WaveSpeed
    end

    StormSky.Parent = nil
    if OriginalSky then
        OriginalSky.Parent = Lighting
    end

    StopRainEffects()
    RainPart:Destroy()

    for Puddle in pairs(ActivePuddles) do
        if Puddle.Parent then
            Puddle:Destroy()
        end
    end
    ActivePuddles = {}

    Atmosphere:Destroy()
    ColorCorrection:Destroy()
    Bloom:Destroy()
    SunRays:Destroy()
    DOF:Destroy()
    RainSound:Destroy()
    ThunderSound:Destroy()
    StormSky:Destroy()

    ApplyCharacterLight({ Brightness = 0, Range = 0, Color = Color3.fromRGB(255, 255, 255) })
end

Cmd.Reg(Cmd.new({"setshader", "ss"}, "Changes the current weather and time shader. Supports realistic mode and resetting the shader.", "setshader <weather> <time>", function(Args)
    local first = Args[2]
    local second = Args[3]

    if not first then
        DebugNotif("Usage: .setshader <weather> <time> / .setshader realistic / .setshader off")
        return
    end

    local lowerFirst = first:lower()

    if lowerFirst == "realistic" then
        StartRealistic()
        DebugNotif("Time of Day: Realistic (following local time)")
        return
    end

    if lowerFirst == "off" or lowerFirst == "stop" then
        ResetShader()
        DebugNotif("Shader reset to default")
        return
    end

    StopRealistic()

    local timeName = ResolveTimeName(first)
    local weatherName = ResolveWeatherName(first)

    if second then
        local secondTime = ResolveTimeName(second)
        local secondWeather = ResolveWeatherName(second)
        if secondTime then timeName = secondTime end
        if secondWeather then weatherName = secondWeather end
    end

    if not timeName and not weatherName then
        DebugNotif("Invalid input. Try: .setshader clear noon / .setshader rainy morning")
        return
    end

    if timeName then
        CurrentTimeName = timeName
    end
    if weatherName then
        CurrentWeatherName = weatherName
    end

    ApplyCombined(CurrentTimeName, CurrentWeatherName)

    local TimeEmoji = TimeOfDay[CurrentTimeName].Emoji
    local WeatherEmoji = Weather[CurrentWeatherName].Emoji
    DebugNotif(WeatherEmoji .. " " .. TimeEmoji .. " Shader set to " .. CurrentWeatherName .. " " .. CurrentTimeName)
end))