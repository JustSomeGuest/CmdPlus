local Lighting = GetService("Lighting")
local SoundService = GetService("SoundService")
local TweenService = GetService("TweenService")
local Workspace = GetService("Workspace")
local Players = GetService("Players")
local RunService = GetService("RunService")

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
    Technology = Lighting.Technology,
    GlobalShadows = Lighting.GlobalShadows,
    EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
    EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
}

local OriginalWater = nil
if Terrain then
    OriginalWater = {
        Color = Terrain.WaterColor,
        Transparency = Terrain.WaterTransparency,
        Reflectance = Terrain.WaterReflectance,
        WaveSize = Terrain.WaterWaveSize,
        WaveSpeed = Terrain.WaterWaveSpeed
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

local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Parent = Lighting

local RainSound = Instance.new("Sound")
RainSound.Name = "WeatherRain"
RainSound.SoundId = GetAsset("CmdPlus/Assets/CmdPlus_Rain.mp3") or ""
RainSound.Looped = true
RainSound.Volume = 0.5
RainSound.Parent = SoundService

local ThunderSound = Instance.new("Sound")
ThunderSound.Name = "WeatherThunder"
ThunderSound.SoundId = GetAsset("CmdPlus/Assets/CmdPlus_Thunder.mp3") or ""
ThunderSound.Looped = true
ThunderSound.Volume = 0.35
ThunderSound.Parent = SoundService

local Player = Plr
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
    NumberSequenceKeypoint.new(1, 0.05)
})
RainEmitter.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.2),
    NumberSequenceKeypoint.new(1, 0.5)
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
RainRaycastFilter.FilterDescendantsInstances = {RainPart}

local RainIntensityConfig = {
    Rain = {Rate = 300, Speed = 60, PuddleInterval = 0.2, PuddleChance = 0.5, PuddleRadius = 30},
    Thunderstorm = {Rate = 550, Speed = 80, PuddleInterval = 0.12, PuddleChance = 0.75, PuddleRadius = 35}
}

local RainEffectActive = false
local RainLoopConn = nil
local PuddleLoopThread = nil
local ActivePuddles = {}
local RainUpdateConnections = {}

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

    local FadeIn = TweenService:Create(Puddle, TweenInfo.new(0.4), {Transparency = 0.35})
    FadeIn:Play()

    task.delay(math.random(4, 8), function()
        if not Puddle.Parent then
            ActivePuddles[Puddle] = nil
            return
        end
        local FadeOut = TweenService:Create(Puddle, TweenInfo.new(1.2), {Transparency = 1})
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
        local function UpdateRainPosition()
            local Character = Player.Character
            local Root = Character and Character:FindFirstChild("HumanoidRootPart")
            if Root then
                RainPart.CFrame = CFrame.new(Root.Position + Vector3.new(0, 45, 0))
            end
        end

        RainLoopConn = Player.CharacterAdded:Connect(function(Char)
            local Root = Char:WaitForChild("HumanoidRootPart")
            if Root then
                RainPart.CFrame = CFrame.new(Root.Position + Vector3.new(0, 45, 0))
            end
            local conn
            conn = Root:GetPropertyChangedSignal("CFrame"):Connect(function()
                UpdateRainPosition()
            end)
            table.insert(RainUpdateConnections, conn)
            Char.AncestryChanged:Connect(function()
                if not Char.Parent then
                    conn:Disconnect()
                end
            end)
        end)

        UpdateRainPosition()
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
    
    for _, Conn in ipairs(RainUpdateConnections) do
        Conn:Disconnect()
    end
    RainUpdateConnections = {}
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

local CharacterAddedConnection = Player.CharacterAdded:Connect(SetupLight)

local function ApplyCharacterLight(LightConfig)
    CurrentLightConfig = LightConfig

    local Character = Player.Character
    if not Character then return end

    local Root = Character:FindFirstChild("HumanoidRootPart")
    if not Root then return end

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

local function ApplyGlobalLighting(Tech, DiffuseScale, SpecularScale)
    Lighting.Technology = Tech or "ShadowMap"
    Lighting.GlobalShadows = true
    Lighting.EnvironmentDiffuseScale = DiffuseScale or 1
    Lighting.EnvironmentSpecularScale = SpecularScale or 1
end

local TimeOfDay = {
    Night = {
        Emoji = "🌙",
        Tech = "ShadowMap",
        DiffuseScale = 0.6,
        SpecularScale = 1.4,
        Lighting = {
            ClockTime = 0,
            Brightness = 0.3,
            ExposureCompensation = -0.5,
            Ambient = Color3.fromRGB(8, 10, 22),
            OutdoorAmbient = Color3.fromRGB(18, 22, 48),
            ColorShift_Top = Color3.fromRGB(30, 45, 100),
            ColorShift_Bottom = Color3.fromRGB(4, 6, 16),
            ShadowSoftness = 0.05
        },
        Atmosphere = {
            Color = Color3.fromRGB(30, 40, 90),
            Decay = Color3.fromRGB(6, 8, 22),
            Density = 0.45,
            Offset = 0,
            Glare = 0,
            Haze = 2.2
        },
        ColorCorrection = {
            Brightness = -0.12,
            Contrast = 0.35,
            Saturation = -0.3,
            TintColor = Color3.fromRGB(160, 180, 240)
        },
        Bloom = {Intensity = 0.8, Size = 56, Threshold = 0.7},
        SunRays = {Intensity = 0, Spread = 1},
        DOF = {FocusDistance = 60, InFocusRadius = 55, NearIntensity = 0.08, FarIntensity = 0.18},
        Blur = 0,
        Water = {
            Color = Color3.fromRGB(8, 18, 45),
            Transparency = 0.1,
            Reflectance = 0.9,
            WaveSize = 0.08,
            WaveSpeed = 5
        },
        Light = {Brightness = 2.5, Range = 18, Color = Color3.fromRGB(255, 210, 140)}
    },
    Sunrise = {
        Emoji = "🌅",
        Tech = "ShadowMap",
        DiffuseScale = 0.8,
        SpecularScale = 1.2,
        Lighting = {
            ClockTime = 6,
            Brightness = 1.2,
            ExposureCompensation = -0.1,
            Ambient = Color3.fromRGB(55, 38, 30),
            OutdoorAmbient = Color3.fromRGB(110, 80, 68),
            ColorShift_Top = Color3.fromRGB(255, 155, 80),
            ColorShift_Bottom = Color3.fromRGB(255, 120, 60),
            ShadowSoftness = 0.12
        },
        Atmosphere = {
            Color = Color3.fromRGB(255, 155, 90),
            Decay = Color3.fromRGB(160, 70, 45),
            Density = 0.42,
            Offset = 0.08,
            Glare = 0.55,
            Haze = 2.4
        },
        ColorCorrection = {
            Brightness = -0.04,
            Contrast = 0.32,
            Saturation = 0.38,
            TintColor = Color3.fromRGB(255, 210, 170)
        },
        Bloom = {Intensity = 1.2, Size = 56, Threshold = 0.72},
        SunRays = {Intensity = 0.45, Spread = 1},
        DOF = {FocusDistance = 80, InFocusRadius = 75, NearIntensity = 0.05, FarIntensity = 0.12},
        Blur = 0,
        Water = {
            Color = Color3.fromRGB(120, 90, 60),
            Transparency = 0.15,
            Reflectance = 0.75,
            WaveSize = 0.1,
            WaveSpeed = 6
        },
        Light = {Brightness = 0.6, Range = 14, Color = Color3.fromRGB(255, 200, 140)}
    },
    Morning = {
        Emoji = "🌄",
        Tech = "ShadowMap",
        DiffuseScale = 1.0,
        SpecularScale = 1.0,
        Lighting = {
            ClockTime = 8.5,
            Brightness = 2.4,
            ExposureCompensation = 0.08,
            Ambient = Color3.fromRGB(72, 70, 75),
            OutdoorAmbient = Color3.fromRGB(140, 138, 140),
            ColorShift_Top = Color3.fromRGB(245, 232, 210),
            ColorShift_Bottom = Color3.fromRGB(238, 230, 220),
            ShadowSoftness = 0.08
        },
        Atmosphere = {
            Color = Color3.fromRGB(210, 205, 195),
            Decay = Color3.fromRGB(130, 128, 135),
            Density = 0.18,
            Offset = 0.04,
            Glare = 0.12,
            Haze = 1.2
        },
        ColorCorrection = {
            Brightness = 0.0,
            Contrast = 0.22,
            Saturation = 0.12,
            TintColor = Color3.fromRGB(255, 248, 238)
        },
        Bloom = {Intensity = 0.45, Size = 36, Threshold = 0.88},
        SunRays = {Intensity = 0.18, Spread = 0.9},
        DOF = {FocusDistance = 120, InFocusRadius = 110, NearIntensity = 0.02, FarIntensity = 0.06},
        Blur = 0,
        Water = {
            Color = Color3.fromRGB(55, 130, 215),
            Transparency = 0.12,
            Reflectance = 0.55,
            WaveSize = 0.1,
            WaveSpeed = 7
        },
        Light = {Brightness = 0, Range = 10, Color = Color3.fromRGB(255, 248, 238)}
    },
    Noon = {
        Emoji = "☀️",
        Tech = "ShadowMap",
        DiffuseScale = 1.0,
        SpecularScale = 1.0,
        Lighting = {
            ClockTime = 12,
            Brightness = 4.5,
            ExposureCompensation = 0.45,
            Ambient = Color3.fromRGB(95, 96, 108),
            OutdoorAmbient = Color3.fromRGB(175, 175, 178),
            ColorShift_Top = Color3.fromRGB(252, 252, 255),
            ColorShift_Bottom = Color3.fromRGB(230, 238, 255),
            ShadowSoftness = 0.04
        },
        Atmosphere = {
            Color = Color3.fromRGB(175, 210, 252),
            Decay = Color3.fromRGB(80, 95, 115),
            Density = 0.09,
            Offset = 0.02,
            Glare = 0.08,
            Haze = 0.55
        },
        ColorCorrection = {
            Brightness = 0.04,
            Contrast = 0.18,
            Saturation = 0.1,
            TintColor = Color3.fromRGB(255, 255, 255)
        },
        Bloom = {Intensity = 0.55, Size = 32, Threshold = 0.95},
        SunRays = {Intensity = 0.22, Spread = 0.85},
        DOF = {FocusDistance = 200, InFocusRadius = 180, NearIntensity = 0, FarIntensity = 0.02},
        Blur = 0,
        Water = {
            Color = Color3.fromRGB(15, 120, 255),
            Transparency = 0.08,
            Reflectance = 0.65,
            WaveSize = 0.1,
            WaveSpeed = 8
        },
        Light = {Brightness = 0, Range = 10, Color = Color3.fromRGB(255, 255, 255)}
    },
    Afternoon = {
        Emoji = "🌞",
        Tech = "ShadowMap",
        DiffuseScale = 1.0,
        SpecularScale = 1.0,
        Lighting = {
            ClockTime = 15.5,
            Brightness = 3.2,
            ExposureCompensation = 0.28,
            Ambient = Color3.fromRGB(85, 84, 88),
            OutdoorAmbient = Color3.fromRGB(155, 152, 148),
            ColorShift_Top = Color3.fromRGB(252, 242, 225),
            ColorShift_Bottom = Color3.fromRGB(245, 235, 215),
            ShadowSoftness = 0.06
        },
        Atmosphere = {
            Color = Color3.fromRGB(225, 208, 182),
            Decay = Color3.fromRGB(108, 100, 92),
            Density = 0.14,
            Offset = 0.03,
            Glare = 0.1,
            Haze = 0.95
        },
        ColorCorrection = {
            Brightness = 0.02,
            Contrast = 0.2,
            Saturation = 0.14,
            TintColor = Color3.fromRGB(255, 246, 232)
        },
        Bloom = {Intensity = 0.48, Size = 34, Threshold = 0.92},
        SunRays = {Intensity = 0.2, Spread = 0.88},
        DOF = {FocusDistance = 150, InFocusRadius = 140, NearIntensity = 0, FarIntensity = 0.03},
        Blur = 0,
        Water = {
            Color = Color3.fromRGB(22, 115, 240),
            Transparency = 0.1,
            Reflectance = 0.6,
            WaveSize = 0.1,
            WaveSpeed = 7
        },
        Light = {Brightness = 0, Range = 10, Color = Color3.fromRGB(255, 246, 232)}
    },
    Sunset = {
        Emoji = "🌇",
        Tech = "ShadowMap",
        DiffuseScale = 0.75,
        SpecularScale = 1.3,
        Lighting = {
            ClockTime = 18.5,
            Brightness = 1.1,
            ExposureCompensation = -0.08,
            Ambient = Color3.fromRGB(50, 35, 28),
            OutdoorAmbient = Color3.fromRGB(95, 70, 58),
            ColorShift_Top = Color3.fromRGB(255, 110, 45),
            ColorShift_Bottom = Color3.fromRGB(255, 60, 30),
            ShadowSoftness = 0.14
        },
        Atmosphere = {
            Color = Color3.fromRGB(255, 118, 65),
            Decay = Color3.fromRGB(140, 48, 38),
            Density = 0.52,
            Offset = 0.1,
            Glare = 0.65,
            Haze = 2.6
        },
        ColorCorrection = {
            Brightness = -0.06,
            Contrast = 0.4,
            Saturation = 0.5,
            TintColor = Color3.fromRGB(255, 185, 140)
        },
        Bloom = {Intensity = 1.4, Size = 60, Threshold = 0.68},
        SunRays = {Intensity = 0.55, Spread = 1},
        DOF = {FocusDistance = 70, InFocusRadius = 65, NearIntensity = 0.06, FarIntensity = 0.16},
        Blur = 0,
        Water = {
            Color = Color3.fromRGB(160, 72, 40),
            Transparency = 0.14,
            Reflectance = 0.85,
            WaveSize = 0.1,
            WaveSpeed = 6
        },
        Light = {Brightness = 1.4, Range = 16, Color = Color3.fromRGB(255, 160, 100)}
    },
    Evening = {
        Emoji = "🌆",
        Tech = "ShadowMap",
        DiffuseScale = 0.65,
        SpecularScale = 1.35,
        Lighting = {
            ClockTime = 20.5,
            Brightness = 0.7,
            ExposureCompensation = -0.28,
            Ambient = Color3.fromRGB(22, 20, 38),
            OutdoorAmbient = Color3.fromRGB(40, 40, 68),
            ColorShift_Top = Color3.fromRGB(70, 72, 138),
            ColorShift_Bottom = Color3.fromRGB(18, 14, 36),
            ShadowSoftness = 0.08
        },
        Atmosphere = {
            Color = Color3.fromRGB(78, 85, 158),
            Decay = Color3.fromRGB(18, 18, 40),
            Density = 0.48,
            Offset = 0.02,
            Glare = 0.08,
            Haze = 2.0
        },
        ColorCorrection = {
            Brightness = -0.08,
            Contrast = 0.38,
            Saturation = -0.1,
            TintColor = Color3.fromRGB(195, 198, 248)
        },
        Bloom = {Intensity = 0.9, Size = 52, Threshold = 0.72},
        SunRays = {Intensity = 0.04, Spread = 0.95},
        DOF = {FocusDistance = 80, InFocusRadius = 72, NearIntensity = 0.06, FarIntensity = 0.2},
        Blur = 0,
        Water = {
            Color = Color3.fromRGB(18, 22, 58),
            Transparency = 0.12,
            Reflectance = 0.88,
            WaveSize = 0.08,
            WaveSpeed = 5
        },
        Light = {Brightness = 2.0, Range = 18, Color = Color3.fromRGB(255, 210, 155)}
    }
}

local TimeOrder = {"Night", "Sunrise", "Morning", "Noon", "Afternoon", "Sunset", "Evening"}

local TimeAliases = {
    dawn = "Sunrise",
    dusk = "Evening",
    midday = "Noon",
    midnight = "Night"
}

local Weather = {
    Clear = {
        Emoji = "🌤️",
        BrightnessMul = 1,
        SaturationAdd = 0,
        HazeAdd = 0,
        DensityAdd = 0,
        ContrastAdd = 0,
        BlurAdd = 0,
        Sound = nil
    },
    Cloudy = {
        Emoji = "☁️",
        BrightnessMul = 0.72,
        SaturationAdd = -0.18,
        HazeAdd = 0.8,
        DensityAdd = 0.14,
        ContrastAdd = 0.08,
        BlurAdd = 0,
        Sound = nil
    },
    Rain = {
        Emoji = "🌧️",
        BrightnessMul = 0.55,
        SaturationAdd = -0.22,
        HazeAdd = 1.1,
        DensityAdd = 0.22,
        ContrastAdd = 0.12,
        BlurAdd = 0,
        Sound = "Rain"
    },
    Thunderstorm = {
        Emoji = "⛈️",
        BrightnessMul = 0.38,
        SaturationAdd = -0.32,
        HazeAdd = 1.6,
        DensityAdd = 0.32,
        ContrastAdd = 0.18,
        BlurAdd = 0,
        Sound = "Thunderstorm"
    },
    Fog = {
        Emoji = "🌫️",
        BrightnessMul = 0.78,
        SaturationAdd = -0.14,
        HazeAdd = 2.2,
        DensityAdd = 0.42,
        ContrastAdd = -0.05,
        BlurAdd = 4,
        Sound = nil
    }
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
    misty = "Fog"
}

local function clamp01(v)
    if v < 0 then return 0 end
    if v > 1 then return 1 end
    return v
end

local function ResolveTimeName(input)
    local lower = input:lower()
    if TimeAliases[lower] then return TimeAliases[lower] end
    for key, _ in pairs(TimeOfDay) do
        if key:lower() == lower then return key end
    end
    return nil
end

local function ResolveWeatherName(input)
    local lower = input:lower()
    if WeatherAliases[lower] then return WeatherAliases[lower] end
    for key, _ in pairs(Weather) do
        if key:lower() == lower then return key end
    end
    return nil
end

local CurrentTimeName = "Morning"
local CurrentWeatherName = "Clear"
local ThunderFlashActive = false
local ThunderFlashConn = nil
local ThunderFlashThread = nil

local function StopThunderFlash()
    ThunderFlashActive = false
    if ThunderFlashConn then
        ThunderFlashConn:Disconnect()
        ThunderFlashConn = nil
    end
    ThunderFlashThread = nil
end

local function StartThunderFlash()
    if ThunderFlashActive then return end
    ThunderFlashActive = true

    ThunderFlashThread = task.spawn(function()
        while ThunderFlashActive do
            task.wait(math.random(4, 11))
            if not ThunderFlashActive then break end

            local OriginalBrightness = ColorCorrection.Brightness
            local OriginalBloom = Bloom.Intensity

            ColorCorrection.Brightness = OriginalBrightness + 0.7
            Bloom.Intensity = OriginalBloom + 0.6
            task.wait(0.05)
            ColorCorrection.Brightness = OriginalBrightness
            Bloom.Intensity = OriginalBloom
            task.wait(0.07)
            ColorCorrection.Brightness = OriginalBrightness + 0.4
            task.wait(0.04)
            ColorCorrection.Brightness = OriginalBrightness
        end
    end)
end

local function UpdateWeatherSound(WeatherName)
    local W = Weather[WeatherName]

    if W.Sound == "Rain" then
        if not RainSound.IsPlaying then RainSound:Play() end
        ThunderSound:Stop()
        StopThunderFlash()
    elseif W.Sound == "Thunderstorm" then
        if not RainSound.IsPlaying then RainSound:Play() end
        if not ThunderSound.IsPlaying then ThunderSound:Play() end
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
        if OriginalSky then OriginalSky.Parent = nil end
        StormSky.Parent = Lighting
    else
        StormSky.Parent = nil
        if OriginalSky then OriginalSky.Parent = Lighting end
    end
end

local function ApplyCombined(TimeName, WeatherName)
    local T = TimeOfDay[TimeName]
    local W = Weather[WeatherName]
    if not T or not W then return end

    ApplyGlobalLighting(T.Tech, T.DiffuseScale, T.SpecularScale)

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
    ColorCorrection.Contrast = T.ColorCorrection.Contrast + W.ContrastAdd
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

    Blur.Size = T.Blur + W.BlurAdd

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
    return Color3.new(lerp(a.R, b.R, t), lerp(a.G, b.G, t), lerp(a.B, b.B, t))
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
        Color = lerpColor(a.Color, b.Color, t)
    }
end

local function BlendTime(A, B, t)
    return {
        Tech = A.Tech,
        DiffuseScale = lerp(A.DiffuseScale, B.DiffuseScale, t),
        SpecularScale = lerp(A.SpecularScale, B.SpecularScale, t),
        Lighting = lerpSection(A.Lighting, B.Lighting, t),
        Atmosphere = lerpSection(A.Atmosphere, B.Atmosphere, t),
        ColorCorrection = lerpSection(A.ColorCorrection, B.ColorCorrection, t),
        Bloom = lerpSection(A.Bloom, B.Bloom, t),
        SunRays = lerpSection(A.SunRays, B.SunRays, t),
        DOF = lerpSection(A.DOF, B.DOF, t),
        Blur = lerp(A.Blur, B.Blur, t),
        Water = lerpSection(A.Water, B.Water, t),
        Light = lerpLight(A.Light, B.Light, t)
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
        if span <= 0 then span = span + 24 end

        local delta = hour - currTime
        if delta < 0 then delta = delta + 24 end

        if delta <= span then
            local t = span > 0 and (delta / span) or 0
            return currName, nextName, t
        end
    end
    return TimeOrder[1], TimeOrder[1], 0
end

local RealisticActive = false
local RealisticConn = nil
local RealisticThread = nil

local function UpdateRealistic()
    local hour = GetLocalHour()
    local nameA, nameB, t = GetBlendForHour(hour)
    local Blended = BlendTime(TimeOfDay[nameA], TimeOfDay[nameB], t)
    local W = Weather[CurrentWeatherName]

    ApplyGlobalLighting(Blended.Tech, Blended.DiffuseScale, Blended.SpecularScale)

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
    ColorCorrection.Contrast = Blended.ColorCorrection.Contrast + W.ContrastAdd
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

    Blur.Size = Blended.Blur + W.BlurAdd

    if Terrain then
        Terrain.WaterColor = Blended.Water.Color
        Terrain.WaterTransparency = Blended.Water.Transparency
        Terrain.WaterReflectance = Blended.Water.Reflectance
        Terrain.WaterWaveSize = Blended.Water.WaveSize
        Terrain.WaterWaveSpeed = Blended.Water.WaveSpeed
    end

    ApplyCharacterLight(Blended.Light)
    UpdateWeatherSound(CurrentWeatherName)
    UpdateWeatherSky(CurrentWeatherName)
    UpdateWeatherParticles(CurrentWeatherName)
end

local function StartRealistic()
    if RealisticActive then return end
    RealisticActive = true
    UpdateRealistic()
    local lastUpdate = 0
    RealisticConn = Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function()
        local now = os.clock()
        if now - lastUpdate >= 1 then
            lastUpdate = now
            UpdateRealistic()
        end
    end)

    RealisticThread = task.spawn(function()
        while RealisticActive do
            UpdateRealistic()
            task.wait(5)
        end
    end)
end

local function StopRealistic()
    RealisticActive = false
    if RealisticConn then
        RealisticConn:Disconnect()
        RealisticConn = nil
    end
    RealisticThread = nil
end

local function ResetShader()
    StopRealistic()
    StopThunderFlash()
    RainSound:Stop()
    ThunderSound:Stop()

    Lighting.Technology = OriginalLighting.Technology
    Lighting.GlobalShadows = OriginalLighting.GlobalShadows
    Lighting.EnvironmentDiffuseScale = OriginalLighting.EnvironmentDiffuseScale
    Lighting.EnvironmentSpecularScale = OriginalLighting.EnvironmentSpecularScale
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
    if OriginalSky then OriginalSky.Parent = Lighting end

    StopRainEffects()
    RainPart:Destroy()

    for Puddle in pairs(ActivePuddles) do
        if Puddle.Parent then Puddle:Destroy() end
    end
    ActivePuddles = {}

    Atmosphere:Destroy()
    ColorCorrection:Destroy()
    Bloom:Destroy()
    SunRays:Destroy()
    DOF:Destroy()
    Blur:Destroy()
    RainSound:Destroy()
    ThunderSound:Destroy()
    StormSky:Destroy()

    if CharacterAddedConnection then
        CharacterAddedConnection:Disconnect()
        CharacterAddedConnection = nil
    end

    ApplyCharacterLight({Brightness = 0, Range = 0, Color = Color3.fromRGB(255, 255, 255)})
end

Cmd.new({"setshader", "ss"}, "Changes the current weather and time shader. Supports realistic mode and resetting the shader.", "setshader <weather> <time>", function(Args)
    local first = Args[2]
    local second = Args[3]

    if not first then
        Notify("Usage: .setshader <weather> <time> / .setshader realistic / .setshader off")
        return
    end

    local lowerFirst = first:lower()

    if lowerFirst == "realistic" then
        StartRealistic()
        Notify("Time of Day: Realistic (following local time)")
        return
    end

    if lowerFirst == "off" or lowerFirst == "stop" then
        ResetShader()
        Notify("Shader reset to default")
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
        Notify("Invalid input. Try: .setshader clear noon / .setshader rainy morning")
        return
    end

    if timeName then CurrentTimeName = timeName end
    if weatherName then CurrentWeatherName = weatherName end

    ApplyCombined(CurrentTimeName, CurrentWeatherName)

    local TimeEmoji = TimeOfDay[CurrentTimeName].Emoji
    local WeatherEmoji = Weather[CurrentWeatherName].Emoji

    Notify(WeatherEmoji .. " " .. TimeEmoji .. " Shader set to " .. CurrentWeatherName .. " " .. CurrentTimeName)
end)