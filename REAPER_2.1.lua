-- ==========================================
-- REAPER 2.1 — OBSIDIAN EDITION + SAVITAR VISUALS
-- ==========================================

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()

pcall(function()
    local Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/lucide-roblox-direct/refs/heads/main/source.lua"))()
    if Icons and Library.SetIconModule then
        Library:SetIconModule(Icons)
    end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Window = Library:CreateWindow({
    Title = "🌙 REAPER 2.1",
    Footer = "Powered by Obsidian",
    Size = UDim2.fromOffset(600, 400),
    Center = true,
    AutoShow = true,
})

local Tabs = {
    { Name = "Home",         Icon = "house" },
    { Name = "Player",       Icon = "user" },
    { Name = "Combat",       Icon = "sword" },
    { Name = "Invincibility", Icon = "shield" },
    { Name = "Target",       Icon = "target" },
    { Name = "Blobman",      Icon = "ghost" },
    { Name = "Toys",         Icon = "blocks" },
    { Name = "Visual",       Icon = "eye" },
    { Name = "Auto-Clicker", Icon = "zap" },
    { Name = "Misc",         Icon = "wrench" },
    { Name = "Lists",        Icon = "list" },
    { Name = "Settings",     Icon = "settings" },
}

local TabObjects = {}
for _, info in ipairs(Tabs) do
    TabObjects[info.Name] = Window:AddTab(info.Name, info.Icon)
end

local HomeGroup = TabObjects["Home"]:AddLeftGroupbox("Main Functions")

HomeGroup:AddImage("LocalAvatar", {
    Image = "rbxthumb://type=Avatar&w=420&h=420&id=" .. LocalPlayer.UserId,
    Height = 150,
})

HomeGroup:AddButton({
    Text = "Список игроков",
    Func = function()
        local names = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            names[#names + 1] = "• " .. plr.Name
        end
        local ok = pcall(function()
            Window:AddDialog("PlayerList", {
                Title = "Игроки в сервере (" .. #names .. ")",
                Description = table.concat(names, "\n"),
                AutoDismiss = true,
                OutsideClickDismiss = true,
                FooterButtons = {
                    Confirm = {
                        Title = "Закрыть",
                        Variant = "Primary",
                        Callback = function() end,
                    },
                },
            })
        end)
        if not ok then
            Library:Notify("Список уже открыт")
        end
    end
})

HomeGroup:AddDivider()

HomeGroup:AddButton({
    Text = "Нажми меня",
    Func = function()
        Library:Notify("Кнопка работает! REAPER + Obsidian = OK")
    end
})

HomeGroup:AddToggle("MyToggle", {
    Text = "Тестовый переключатель",
    Default = false,
    Callback = function(Value)
        print("Toggle:", Value)
    end
})

-- =====================================================================
-- SAVITAR VISUALS — ДВИЖОК (встроено в REAPER 2.1)
-- =====================================================================
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Terrain = Workspace.Terrain

local VisualHeartbeat = nil
local Updaters = {}

local function AddUpdater(fn)
    Updaters[#Updaters + 1] = fn
    if not VisualHeartbeat then
        VisualHeartbeat = RunService.Heartbeat:Connect(function(dt)
            for i = 1, #Updaters do
                pcall(Updaters[i], dt)
            end
        end)
    end
end

-- =====================================================================
-- ШЕЙДЕРЫ
-- =====================================================================
local ShaderPresets = {
    ["Scarlet Atmosphere"] = {
        Lighting = { Brightness=2.14, ColorShift_Bottom=Color3.fromRGB(11,0,20), ColorShift_Top=Color3.fromRGB(240,127,14), OutdoorAmbient=Color3.fromRGB(34,0,49), ClockTime=6.7, FogColor=Color3.fromRGB(94,76,106), FogEnd=1000, FogStart=0, ExposureCompensation=0.24, ShadowSoftness=0, Ambient=Color3.fromRGB(59,33,27) },
        Bloom={Intensity=0.1,Threshold=0,Size=100}, Blur={Size=2},
        ColorCorrection={Saturation=0.05,TintColor=Color3.fromRGB(255,224,219)},
        SunRays={Intensity=0.05},
    },
    ["Golden Hour"] = {
        Lighting = { Brightness=1.8, ClockTime=17.8, FogEnd=100000, ExposureCompensation=-0.03, ShadowSoftness=0.6, Ambient=Color3.fromRGB(38,38,42), OutdoorAmbient=Color3.fromRGB(155,155,170), ColorShift_Top=Color3.fromRGB(255,210,160) },
        Bloom={Intensity=0.55,Threshold=0.95,Size=42},
        ColorCorrection={Brightness=0.03,Saturation=0.16,Contrast=0.44,TintColor=Color3.fromRGB(255,230,200)},
        SunRays={Intensity=0.18,Spread=0.9},
        Atmosphere={Density=0.32,Offset=0.15,Haze=1.4,Glare=0.35,Color=Color3.fromRGB(200,210,255),Decay=Color3.fromRGB(100,110,130)},
    },
    ["Night"] = {
        Lighting = { Brightness=0.8, ClockTime=0, FogEnd=100000, ExposureCompensation=-0.22, ShadowSoftness=0.7, Ambient=Color3.fromRGB(29,29,33) },
        Bloom={Intensity=0.8,Threshold=0.78,Size=38},
        ColorCorrection={Brightness=-0.08,Saturation=-0.15,Contrast=0.37,TintColor=Color3.fromRGB(185,205,255)},
        SunRays={Intensity=0,Spread=0.65},
        Atmosphere={Density=0.5,Offset=0.15,Haze=2.25,Glare=0.15,Color=Color3.fromRGB(200,210,255),Decay=Color3.fromRGB(100,110,130)},
    },
    ["Neon Night"] = {
        Lighting = { Brightness=1, ClockTime=0.4, FogEnd=100000, ExposureCompensation=-0.12, ShadowSoftness=0.5, Ambient=Color3.fromRGB(27,27,30) },
        Bloom={Intensity=1.15,Threshold=0.65,Size=52},
        ColorCorrection={Brightness=-0.04,Saturation=0.3,Contrast=0.65,TintColor=Color3.fromRGB(205,215,255)},
        SunRays={Intensity=0,Spread=0.65},
        Atmosphere={Density=0.38,Offset=0.15,Haze=1.8,Glare=0.15,Color=Color3.fromRGB(200,210,255),Decay=Color3.fromRGB(100,110,130)},
    },
    ["Lost Ocean"] = {
        Lighting = { Brightness=0.65, ClockTime=23.5, FogEnd=100000, ExposureCompensation=-0.28, ShadowSoftness=0.85, Ambient=Color3.fromRGB(21,21,23) },
        Bloom={Intensity=0.2,Threshold=1.1,Size=28}, Blur={Size=0.7},
        ColorCorrection={Brightness=-0.13,Saturation=-0.4,Contrast=0.78,TintColor=Color3.fromRGB(210,225,255)},
        SunRays={Intensity=0.08,Spread=0.65},
        Atmosphere={Density=0.65,Offset=0.15,Haze=3.2,Glare=0.15,Color=Color3.fromRGB(200,210,255),Decay=Color3.fromRGB(100,110,130)},
    },
    ["Dreamy"] = {
        Lighting = { Brightness=2, ClockTime=16.8, FogEnd=100000, ExposureCompensation=0.08, ShadowSoftness=0.9, Ambient=Color3.fromRGB(61,61,68) },
        Bloom={Intensity=0.9,Threshold=0.75,Size=70}, Blur={Size=0.35},
        ColorCorrection={Brightness=0.06,Saturation=0.18,Contrast=0.17,TintColor=Color3.fromRGB(255,230,255)},
        SunRays={Intensity=0.08,Spread=0.65},
        Atmosphere={Density=0.28,Offset=0.15,Haze=1.4,Glare=0.15,Color=Color3.fromRGB(200,210,255),Decay=Color3.fromRGB(100,110,130)},
    },
    ["Colorful"] = {
        Lighting = { Brightness=2.25, ClockTime=13.5, FogEnd=100000, ExposureCompensation=0.04, ShadowSoftness=0.35, Ambient=Color3.fromRGB(51,51,57) },
        Bloom={Intensity=0.5,Threshold=1.1,Size=34},
        ColorCorrection={Brightness=0.04,Saturation=0.45,Contrast=0.27,TintColor=Color3.fromRGB(255,255,255)},
        SunRays={Intensity=0.08,Spread=0.65},
        Atmosphere={Density=0.18,Offset=0.15,Haze=0.6,Glare=0.15,Color=Color3.fromRGB(200,210,255),Decay=Color3.fromRGB(100,110,130)},
    },
}

local ShaderOrder = { "Scarlet Atmosphere", "Golden Hour", "Night", "Neon Night", "Lost Ocean", "Dreamy", "Colorful" }

local Original = { Lighting = {}, Sky = nil, Atmosphere = nil, Saved = false }
local ActiveEffects = {}

local function SaveOriginal()
    if Original.Saved then return end
    Original.Saved = true
    local L = Original.Lighting
    L.Brightness = Lighting.Brightness
    L.ColorShift_Bottom = Lighting.ColorShift_Bottom
    L.ColorShift_Top = Lighting.ColorShift_Top
    L.OutdoorAmbient = Lighting.OutdoorAmbient
    L.ClockTime = Lighting.ClockTime
    L.FogColor = Lighting.FogColor
    L.FogEnd = Lighting.FogEnd
    L.FogStart = Lighting.FogStart
    L.ExposureCompensation = Lighting.ExposureCompensation
    L.ShadowSoftness = Lighting.ShadowSoftness
    L.Ambient = Lighting.Ambient
    local sky = Lighting:FindFirstChildOfClass("Sky")
    if sky then
        Original.Sky = {
            SkyboxBk=sky.SkyboxBk, SkyboxDn=sky.SkyboxDn, SkyboxFt=sky.SkyboxFt,
            SkyboxLf=sky.SkyboxLf, SkyboxRt=sky.SkyboxRt, SkyboxUp=sky.SkyboxUp,
            StarCount=sky.StarCount, SunAngularSize=sky.SunAngularSize,
            MoonAngularSize=sky.MoonAngularSize, CelestialBodiesShown=sky.CelestialBodiesShown,
        }
    end
    local atm = Lighting:FindFirstChildOfClass("Atmosphere")
    if atm then
        Original.Atmosphere = { Density=atm.Density, Offset=atm.Offset, Haze=atm.Haze, Glare=atm.Glare, Color=atm.Color, Decay=atm.Decay }
    end
end

local function DestroyEffects()
    for i = #ActiveEffects, 1, -1 do
        local e = ActiveEffects[i]
        if e and e.Parent then e:Destroy() end
        ActiveEffects[i] = nil
    end
end

local function RestoreOriginal()
    for k, v in pairs(Original.Lighting) do Lighting[k] = v end
    if Original.Sky then
        local sky = Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky")
        for k, v in pairs(Original.Sky) do sky[k] = v end
        sky.Parent = Lighting
    end
    if Original.Atmosphere then
        local atm = Lighting:FindFirstChildOfClass("Atmosphere")
        if atm then
            for k, v in pairs(Original.Atmosphere) do atm[k] = v end
        end
    end
end

local function lerpNum(a, b, t) return a + (b - a) * t end
local function lerpColor(a, b, t)
    local r = a.R + (b.R - a.R) * t
    local g = a.G + (b.G - a.G) * t
    local bl = a.B + (b.B - a.B) * t
    if r < 0 then r = 0 elseif r > 1 then r = 1 end
    if g < 0 then g = 0 elseif g > 1 then g = 1 end
    if bl < 0 then bl = 0 elseif bl > 1 then bl = 1 end
    return Color3.new(r, g, bl)
end

local ShaderState = { Active = false, CurrentName = "Scarlet Atmosphere", Level = 8 }

local function ApplyShader(shaderName, level)
    SaveOriginal()
    DestroyEffects()
    RestoreOriginal()
    local preset = ShaderPresets[shaderName]
    if not preset then return false end

    level = math.clamp(tonumber(level) or 8, 0, 10)
    local t = level / 10
    local orig = Original.Lighting
    local L = preset.Lighting

    if L.Brightness then Lighting.Brightness = lerpNum(orig.Brightness, L.Brightness, t) end
    if L.ClockTime then Lighting.ClockTime = lerpNum(orig.ClockTime, L.ClockTime, t) end
    if L.FogEnd then Lighting.FogEnd = lerpNum(orig.FogEnd, L.FogEnd, t) end
    if L.FogStart then Lighting.FogStart = lerpNum(orig.FogStart, L.FogStart, t) end
    if L.ExposureCompensation then Lighting.ExposureCompensation = lerpNum(orig.ExposureCompensation, L.ExposureCompensation, t) end
    if L.ShadowSoftness then Lighting.ShadowSoftness = lerpNum(orig.ShadowSoftness, L.ShadowSoftness, t) end
    if L.ColorShift_Bottom then Lighting.ColorShift_Bottom = lerpColor(orig.ColorShift_Bottom, L.ColorShift_Bottom, t) end
    if L.ColorShift_Top then Lighting.ColorShift_Top = lerpColor(orig.ColorShift_Top, L.ColorShift_Top, t) end
    if L.OutdoorAmbient then Lighting.OutdoorAmbient = lerpColor(orig.OutdoorAmbient, L.OutdoorAmbient, t) end
    if L.FogColor then Lighting.FogColor = lerpColor(orig.FogColor, L.FogColor, t) end
    if L.Ambient then Lighting.Ambient = lerpColor(orig.Ambient, L.Ambient, t) end

    if preset.Bloom then
        local b = Instance.new("BloomEffect", Lighting)
        b.Name = "SavitarBloom"
        b.Intensity = preset.Bloom.Intensity * t
        b.Threshold = preset.Bloom.Threshold
        b.Size = preset.Bloom.Size * t
        ActiveEffects[#ActiveEffects+1] = b
    end
    if preset.Blur then
        local b = Instance.new("BlurEffect", Lighting)
        b.Name = "SavitarBlur"
        b.Size = preset.Blur.Size * t
        ActiveEffects[#ActiveEffects+1] = b
    end
    local ccData = preset.CC or preset.ColorCorrection
    if ccData then
        local cc = Instance.new("ColorCorrectionEffect", Lighting)
        cc.Name = "SavitarCC"
        cc.Brightness = (ccData.Brightness or 0) * t
        cc.Saturation = (ccData.Saturation or 0) * t
        cc.Contrast = (ccData.Contrast or 0) * t
        cc.TintColor = lerpColor(Color3.new(1,1,1), ccData.TintColor or Color3.new(1,1,1), t)
        ActiveEffects[#ActiveEffects+1] = cc
    end
    if preset.SunRays then
        local sr = Instance.new("SunRaysEffect", Lighting)
        sr.Name = "SavitarSR"
        sr.Intensity = (preset.SunRays.Intensity or 0) * t
        sr.Spread = preset.SunRays.Spread or 0.65
        ActiveEffects[#ActiveEffects+1] = sr
    end
    if preset.Atmosphere then
        local atm = Lighting:FindFirstChildOfClass("Atmosphere")
        if not atm then
            atm = Instance.new("Atmosphere", Lighting)
            atm.Name = "SavitarAtm"
            ActiveEffects[#ActiveEffects+1] = atm
        end
        local A = preset.Atmosphere
        local base = Original.Atmosphere or { Density=0.22, Offset=0.15, Haze=0.8, Glare=0.15, Color=Color3.fromRGB(200,210,255), Decay=Color3.fromRGB(100,110,130) }
        atm.Density = lerpNum(base.Density, A.Density, t)
        atm.Offset = lerpNum(base.Offset, A.Offset, t)
        atm.Haze = lerpNum(base.Haze, A.Haze, t)
        atm.Glare = lerpNum(base.Glare, A.Glare, t)
        atm.Color = lerpColor(base.Color, A.Color, t)
        atm.Decay = lerpColor(base.Decay, A.Decay, t)
    end
    if shaderName == "Scarlet Atmosphere" then
        local sky = Instance.new("Sky", Lighting)
        sky.Name = "SavitarSky"
        sky.SkyboxUp = "rbxassetid://323493360"
        sky.SkyboxLf = "rbxassetid://323494252"
        sky.SkyboxBk = "rbxassetid://323494035"
        sky.SkyboxFt = "rbxassetid://323494130"
        sky.SkyboxDn = "rbxassetid://323494368"
        sky.SkyboxRt = "rbxassetid://323494067"
        sky.SunAngularSize = 14
        ActiveEffects[#ActiveEffects+1] = sky
    end

    ShaderState.Active = true
    ShaderState.CurrentName = shaderName
    ShaderState.Level = level
    return true
end

local function RemoveShader()
    DestroyEffects()
    RestoreOriginal()
    ShaderState.Active = false
end

-- =====================================================================
-- FOREST
-- =====================================================================
local Forest = {
    Active = false, Models = {}, Sounds = {}, SoundEnabled = true,
    AmbientMusicVol = 0.2, BackgroundAmbienceVol = 0.2, RiverSoundMaxVol = 0.5,
    FadeLevel = 0, LastInZone = false,
}

local ForestModels = {
    { name="Model", assetId="128041595717353", cframe=CFrame.new(-226.081299,76.8,-765.237,-0.965930283,0,-0.258802325,0,1,0,0.258802325,0,-0.965930283) },
    { name="Model", assetId="90896795257560", cframe=CFrame.new(-350.424377,151.6,-1376.97949,-0.965929627,0,-0.258804858,0,1,0,0.258804858,0,-0.965929627) },
    { name="SAVITAR", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-396,73,-638),Vector3.new(0.866,0,0.5),Vector3.new(0,1,0),Vector3.new(-0.5,0,0.866)) },
    { name="SAVITAR", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-55,71,-723),Vector3.new(0.5736,0,0.8192),Vector3.new(0,1,0),Vector3.new(-0.8192,0,0.5736)) },
    { name="SAVITAR", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-271,83,-812),Vector3.new(0,0,1),Vector3.new(0,1,0),Vector3.new(-1,0,0)) },
    { name="SAVITAR", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-116,78,-903),Vector3.new(-0.5,0,0.866),Vector3.new(0,1,0),Vector3.new(-0.866,0,-0.5)) },
    { name="SAVITAR", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-220,79,-954),Vector3.new(-0.8192,0,0.5736),Vector3.new(0,1,0),Vector3.new(-0.5736,0,-0.8192)) },
    { name="SAVITAR", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-386,96,-862),Vector3.new(1,0,0),Vector3.new(0,1,0),Vector3.new(0,0,1)) },
    { name="SAVITAR", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-601,105,-1452),Vector3.new(0.7071,0,0.7071),Vector3.new(0,1,0),Vector3.new(-0.7071,0,0.7071)) },
    { name="SAVITAR", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-335,103,-1299),Vector3.new(0.4226,0,0.9063),Vector3.new(0,1,0),Vector3.new(-0.9063,0,0.4226)) },
    { name="SAVITAR", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-349,127,-1268),Vector3.new(-0.4226,0,0.9063),Vector3.new(0,1,0),Vector3.new(-0.9063,0,-0.4226)) },
    { name="SAVITAR", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-763,121,-1265),Vector3.new(0.9063,0,0.4226),Vector3.new(0,1,0),Vector3.new(-0.4226,0,0.9063)) },
    { name="SAVITAR", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-469,177,-1580),Vector3.new(-0.7071,0,0.7071),Vector3.new(0,1,0),Vector3.new(-0.7071,0,-0.7071)) },
    { name="SAVITAR", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(2,151,-1384),Vector3.new(0.5,0,0.866),Vector3.new(0,1,0),Vector3.new(-0.866,0,0.5)) },
    { name="SAVITAR", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-92,146,-1629),Vector3.new(0.8192,0,0.5736),Vector3.new(0,1,0),Vector3.new(-0.5736,0,0.8192)) },
}

local ForestSoundIds = {
    AmbientMusic = "rbxassetid://140087640246134",
    BackgroundAmbience = "rbxassetid://9112781680",
    River = "rbxassetid://9120552671",
}

local ForestZones = {
    { min=Vector3.new(-728,40,-1690), max=Vector3.new(-24,300,-870) },
    { min=Vector3.new(-412,40,-1109), max=Vector3.new(40,300,-428) },
}

local function IsInForestZone(pos)
    for i = 1, #ForestZones do
        local z = ForestZones[i]
        local cx = math.clamp(pos.X, z.min.X, z.max.X)
        local cy = math.clamp(pos.Y, z.min.Y, z.max.Y)
        local cz = math.clamp(pos.Z, z.min.Z, z.max.Z)
        if (pos.X - cx) == 0 and (pos.Y - cy) == 0 and (pos.Z - cz) == 0 then
            return true
        end
    end
    return false
end

local RIVER_A = Vector3.new(-80, 58, -1671)
local RIVER_B = Vector3.new(19, 58, -1307)
local RIVER_MIN_DIST = 40
local RIVER_MAX_DIST = 350
local RIVER_DX = RIVER_B.X - RIVER_A.X
local RIVER_DZ = RIVER_B.Z - RIVER_A.Z
local RIVER_LEN2 = RIVER_DX*RIVER_DX + RIVER_DZ*RIVER_DZ

local function DistToRiverLine(pos)
    local t = ((pos.X - RIVER_A.X)*RIVER_DX + (pos.Z - RIVER_A.Z)*RIVER_DZ) / RIVER_LEN2
    if t < 0 then t = 0 elseif t > 1 then t = 1 end
    local ex = pos.X - RIVER_A.X + RIVER_DX*t
    local ez = pos.Z - RIVER_A.Z + RIVER_DZ*t
    return math.sqrt(ex*ex + ez*ez)
end

local function CreateSound(soundId)
    local s = Instance.new("Sound", SoundService)
    s.SoundId = soundId
    s.Volume = 0
    s.Looped = true
    s.RollOffMode = Enum.RollOffMode.InverseTapered
    s.MaxDistance = 10000
    return s
end

local function LoadForestModel(info, index)
    local ok, objects = pcall(game.GetObjects, game, "rbxassetid://" .. info.assetId)
    if not ok or not objects or not objects[1] then return nil end
    local model = objects[1]
    model.Name = info.name
    model:SetAttribute("_isForestModel", true)
    model.Parent = Workspace
    Forest.Models[#Forest.Models+1] = model

    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("BasePart") then d.Anchored = true end
    end

    task.defer(function()
        pcall(function() model:PivotTo(info.cframe) end)

        if info.name == "SAVITAR" then
            local ac = model:FindFirstChildWhichIsA("AnimationController", true)
            if ac then
                local animator = ac:FindFirstChildOfClass("Animator")
                if animator then
                    local anim = Instance.new("Animation")
                    anim.AnimationId = "rbxassetid://6409102589"
                    local okA, track = pcall(animator.LoadAnimation, animator, anim)
                    if okA and track then track:Play(0, 1, 0.8 + math.random() * 0.4) end
                    anim:Destroy()
                end
            end

            local basePos = info.cframe.Position
            local radius = 70 + (index % 5) * 8
            local speed = 0.18 + (index % 7) * 0.015
            local ang = (index * 1.37) % 6.2831853071795862

            AddUpdater(function(dt)
                if not model.Parent then return end
                ang = ang + speed * dt
                local swing = math.sin(ang * 2.3) * 4
                local px = basePos.X + math.cos(ang) * radius
                local pz = basePos.Z + math.sin(ang) * radius
                local py = basePos.Y + swing
                local nx = basePos.X + math.cos(ang + 0.05) * radius
                local nz = basePos.Z + math.sin(ang + 0.05) * radius
                model:PivotTo(CFrame.lookAt(Vector3.new(px, py, pz), Vector3.new(nx, py, nz)) * CFrame.Angles(0, 0, -0.20943951023931956))
            end)
        end
    end)
    return model
end

local function DestroyForestSounds()
    for k, s in pairs(Forest.Sounds) do
        if s then s:Stop(); s:Destroy() end
        Forest.Sounds[k] = nil
    end
end

local function StartForestSounds()
    DestroyForestSounds()
    Forest.Sounds.AmbientMusic = CreateSound(ForestSoundIds.AmbientMusic)
    Forest.Sounds.BackgroundAmbience = CreateSound(ForestSoundIds.BackgroundAmbience)
    Forest.Sounds.River = CreateSound(ForestSoundIds.River)
end

local function UpdateForestSounds(dt)
    local lvl = Forest.FadeLevel
    local target = Forest.LastInZone and 1 or 0
    if lvl < target then lvl = math.min(lvl + 0.33*dt, target)
    elseif lvl > target then lvl = math.max(lvl - 0.33*dt, target) end
    Forest.FadeLevel = lvl

    local AM = Forest.Sounds.AmbientMusic
    if AM then
        local v = lvl * Forest.AmbientMusicVol
        if math.abs(AM.Volume - v) > 0.005 then
            AM.Volume = v
            if v > 0.001 and not AM.IsPlaying then AM:Play()
            elseif v <= 0.001 and AM.IsPlaying then AM:Pause() end
        end
    end
    local BA = Forest.Sounds.BackgroundAmbience
    if BA then
        local v = lvl * Forest.BackgroundAmbienceVol
        if math.abs(BA.Volume - v) > 0.005 then
            BA.Volume = v
            if v > 0.001 and not BA.IsPlaying then BA:Play()
            elseif v <= 0.001 and BA.IsPlaying then BA:Pause() end
        end
    end
    local RV = Forest.Sounds.River
    if RV then
        local char = LocalPlayer.Character
        local hrp = char and (char:FindFirstChild("saviHRP") or char:FindFirstChild("HumanoidRootPart"))
        local v = 0
        if hrp and Forest.LastInZone then
            local d = DistToRiverLine(hrp.Position) - RIVER_MIN_DIST
            v = (1 - math.clamp(d / (RIVER_MAX_DIST - RIVER_MIN_DIST), 0, 1)) * Forest.RiverSoundMaxVol
        end
        if math.abs(RV.Volume - v) > 0.005 then
            RV.Volume = v
            if v > 0.001 and not RV.IsPlaying then RV:Play()
            elseif v <= 0.001 and RV.IsPlaying then RV:Pause() end
        end
    end
end

local function DestroyForest()
    Forest.Active = false
    DestroyForestSounds()
    for _, m in ipairs(Forest.Models) do
        if m and m.Parent then m:Destroy() end
    end
    Forest.Models = {}
end

local function LoadForest()
    if Forest.Active then return end
    Forest.Active = true
    Forest.Models = {}

    task.spawn(function()
        for i, info in ipairs(ForestModels) do
            LoadForestModel(info, i)
            task.wait(0.15)
        end
    end)

    if Forest.SoundEnabled then
        StartForestSounds()
        AddUpdater(UpdateForestSounds)
    end
end

-- =====================================================================
-- BEACH
-- =====================================================================
local Beach = {
    Active = false, Models = {}, Sounds = {}, SoundEnabled = true,
    WaveSoundVol = 0.1, SeagullSoundVol = 2, AmbientMusicVol = 0.2,
    WaveSpeed = 8, WaveSize = 0.5, WaterTransparency = 1, WaterReflectance = 0.7,
    FadeLevel = 0, LastInZone = false,
    OrigWater = {
        WaveSpeed = Terrain.WaterWaveSpeed, WaveSize = Terrain.WaterWaveSize,
        Transparency = Terrain.WaterTransparency, Reflectance = Terrain.WaterReflectance,
    },
    TerrainFills = {}, SandColors = {}, HiddenFolder = nil,
}

local BeachSoundIds = {
    Waves = "rbxassetid://137826155053556",
    Seagull = "rbxassetid://9118858002",
    AmbientMusic = "rbxassetid://1846889412",
}

local BeachModels = {
    { name="Model", assetId="126414926053878", cframe=CFrame.fromMatrix(Vector3.new(-662.6217,16.118477,400.51788),Vector3.new(0.766,0,-0.6428),Vector3.new(0,1,0),Vector3.new(0.6428,0,0.766)) },
    { name="Model", assetId="126414926053878", cframe=CFrame.fromMatrix(Vector3.new(-778.7782,13.617236,256.63773),Vector3.new(0.7071,0,-0.7071),Vector3.new(0,1,0),Vector3.new(0.7071,0,0.7071)) },
    { name="Model", assetId="126414926053878", cframe=CFrame.fromMatrix(Vector3.new(-872.18695,14.952764,81.41294),Vector3.new(1,0,0),Vector3.new(0,1,0),Vector3.new(0,0,1)) },
    { name="Model", assetId="126414926053878", cframe=CFrame.fromMatrix(Vector3.new(-829.42505,14.094798,-81.6558),Vector3.new(1,0,0),Vector3.new(0,1,0),Vector3.new(0,0,1)) },
    { name="Model", assetId="126414926053878", cframe=CFrame.fromMatrix(Vector3.new(-803.9319,14.094798,-268.04733),Vector3.new(0.9397,0,0.342),Vector3.new(0,1,0),Vector3.new(-0.342,0,0.9397)) },
    { name="Model", assetId="126414926053878", cframe=CFrame.fromMatrix(Vector3.new(-718.70013,14.318599,-420.68573),Vector3.new(0.766,0,0.6428),Vector3.new(0,1,0),Vector3.new(-0.6428,0,0.766)) },
    { name="Model", assetId="126414926053878", cframe=CFrame.fromMatrix(Vector3.new(-589.9306,15.883186,-557.28827),Vector3.new(0.5736,0,0.8192),Vector3.new(0,1,0),Vector3.new(-0.8192,0,0.5736)) },
    { name="Model", assetId="126414926053878", cframe=CFrame.fromMatrix(Vector3.new(-398.61682,16.020756,-652.1829),Vector3.new(0.342,0,0.9397),Vector3.new(0,1,0),Vector3.new(-0.9397,0,0.342)) },
    { name="Model", assetId="126414926053878", cframe=CFrame.fromMatrix(Vector3.new(-200.72849,14.84903,-703.2258),Vector3.new(0.1736,0,0.9848),Vector3.new(0,1,0),Vector3.new(-0.9848,0,0.1736)) },
    { name="Model", assetId="126414926053878", cframe=CFrame.fromMatrix(Vector3.new(-3.847719,14.788372,-744.23804),Vector3.new(0,0,1),Vector3.new(0,1,0),Vector3.new(-1,0,0)) },
    { name="beach with sea and floaties", assetId="96323724013569", cframe=CFrame.fromMatrix(Vector3.new(-774.5311,-4.750234,13.415283),Vector3.new(0,0,1),Vector3.new(0,1,0),Vector3.new(-1,0,0)) },
    { name="Model", assetId="13183571527", cframe=CFrame.fromMatrix(Vector3.new(-860.5685,-15.31096,-101.19921),Vector3.new(0.3584,0,-0.9336),Vector3.new(0,1,0),Vector3.new(0.9336,0,0.3584)) },
    { name="Boat Spawner", assetId="9737169974", cframe=CFrame.fromMatrix(Vector3.new(-895.7671,-12.176599,-101.0496),Vector3.new(-0.3584,0,0.9336),Vector3.new(0,1,0),Vector3.new(-0.9336,0,-0.3584)) },
    { name="Boat Spawner", assetId="9737169974", cframe=CFrame.fromMatrix(Vector3.new(-873.8541,-12.176599,-92.306755),Vector3.new(-0.3584,0,0.9336),Vector3.new(0,1,0),Vector3.new(-0.9336,0,-0.3584)) },
    { name="SAVITAR1N", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-135.99847,48.15421,-696.5093),Vector3.new(0.8192,0,0.5736),Vector3.new(0,1,0),Vector3.new(-0.5736,0,0.8192)) },
    { name="SAVITAR1N", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-1013.5383,45.542057,-361.37296),Vector3.new(0.9063,0,-0.4226),Vector3.new(0,1,0),Vector3.new(0.4226,0,0.9063)) },
    { name="SAVITAR1N", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-1269.1105,47.283695,-310.23096),Vector3.new(0.5736,0,-0.8192),Vector3.new(0,1,0),Vector3.new(0.8192,0,0.5736)) },
    { name="SAVITAR1N", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-298.02835,48.15421,-809.964),Vector3.new(0.8191,0,0.5736),Vector3.new(0,1,0),Vector3.new(-0.5736,0,0.8191)) },
    { name="SAVITAR1N", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-782.11285,44.236027,-502.80032),Vector3.new(0.4226,0,0.9063),Vector3.new(0,1,0),Vector3.new(-0.9063,0,0.4226)) },
    { name="SAVITAR1N", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-833.2545,19.662569,-758.3734),Vector3.new(0.8191,0,0.5736),Vector3.new(0,1,0),Vector3.new(-0.5736,0,0.8191)) },
    { name="SAVITAR1N", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-971.36127,20.533297,-756.1913),Vector3.new(0.5736,0,-0.8192),Vector3.new(0,1,0),Vector3.new(0.8192,0,0.5736)) },
    { name="SAVITAR1N", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-856.7683,166.51154,-228.75546),Vector3.new(0.5736,0,-0.8192),Vector3.new(0,1,0),Vector3.new(0.8192,0,0.5736)) },
    { name="SAVITAR1N", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-521.63074,163.89938,648.78644),Vector3.new(-0.4226,0,-0.9063),Vector3.new(0,1,0),Vector3.new(0.9063,0,-0.4226)) },
    { name="SAVITAR1N", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-470.4884,165.64102,904.35913),Vector3.new(-0.8192,0,-0.5736),Vector3.new(0,1,0),Vector3.new(0.5736,0,-0.8192)) },
    { name="SAVITAR1N", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-970.2225,166.51152,-66.725624),Vector3.new(0.5736,0,-0.8192),Vector3.new(0,1,0),Vector3.new(0.8192,0,0.5736)) },
    { name="SAVITAR1N", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-663.05835,162.59335,417.36038),Vector3.new(0.9063,0,-0.4226),Vector3.new(0,1,0),Vector3.new(0.4226,0,0.9063)) },
    { name="SAVITAR1N", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-918.6309,138.01988,468.5016),Vector3.new(0.5736,0,-0.8192),Vector3.new(0,1,0),Vector3.new(0.8192,0,0.5736)) },
    { name="SAVITAR1N", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-916.4483,138.89061,606.6085),Vector3.new(-0.8192,0,-0.5736),Vector3.new(0,1,0),Vector3.new(0.5736,0,-0.8192)) },
    { name="SAVITAR1N", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-844.84546,49.49753,22.97348),Vector3.new(0.866,0,-0.5),Vector3.new(0,1,0),Vector3.new(0.5,0,0.866)) },
    { name="SAVITAR1N", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-911.9752,57.403233,166.02487),Vector3.new(0,0,-1),Vector3.new(0,1,0),Vector3.new(1,0,0)) },
    { name="SAVITAR1N", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-973.63464,59.14487,419.26566),Vector3.new(-0.5,0,-0.866),Vector3.new(0,1,0),Vector3.new(0.866,0,-0.5)) },
    { name="SAVITAR1N", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-1251.9766,32.394463,-39.0575),Vector3.new(-0.5,0,-0.866),Vector3.new(0,1,0),Vector3.new(0.866,0,-0.5)) },
    { name="SAVITAR1N", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-844.84644,60.015385,-770.93134),Vector3.new(0.866,0,-0.5),Vector3.new(0,1,0),Vector3.new(0.5,0,0.866)) },
    { name="SAVITAR1N", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-1016.14795,60.01537,-672.0302),Vector3.new(0.866,0,-0.5),Vector3.new(0,1,0),Vector3.new(0.5,0,0.866)) },
    { name="SAVITAR1N", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-1195.5878,31.523737,-165.14702),Vector3.new(0.866,0,-0.5),Vector3.new(0,1,0),Vector3.new(0.5,0,0.866)) },
    { name="SAVITAR1N", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-762.90607,47.755993,183.53406),Vector3.new(1,0,0),Vector3.new(0,1,0),Vector3.new(0,0,1)) },
    { name="SAVITAR1N", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-942.3469,56.09721,-103.48757),Vector3.new(1,0,0),Vector3.new(0,1,0),Vector3.new(0,0,1)) },
    { name="SAVITAR1N", assetId="102653559929681", cframe=CFrame.fromMatrix(Vector3.new(-762.90704,49.497288,-610.3707),Vector3.new(1,0,0),Vector3.new(0,1,0),Vector3.new(0,0,1)) },
    { name="iskele", assetId="13183571527", cframe=CFrame.fromMatrix(Vector3.new(-926.253,-15.311,-126.415),Vector3.new(0.3584,0,-0.9336),Vector3.new(0,1,0),Vector3.new(0.9336,0,0.3584)) },
    { name="Boat", assetId="108948411274431", cframe=CFrame.fromMatrix(Vector3.new(-1004.389,6.746,-164.756),Vector3.new(0.9336,0,0.3584),Vector3.new(0,1,0),Vector3.new(-0.3584,0,0.9336)) },
    { name="dock-with-house", assetId="4879124505", cframe=CFrame.fromMatrix(Vector3.new(-935.173,-13.099,-142.281),Vector3.new(0.4067,0,-0.9135),Vector3.new(0,1,0),Vector3.new(0.9135,0,0.4067)) },
}

local BeachZones = {
    { min=Vector3.new(-1300,-100,-1100), max=Vector3.new(100,400,1000) },
}

local function IsInBeachZone(pos)
    for i = 1, #BeachZones do
        local z = BeachZones[i]
        local cx = math.clamp(pos.X, z.min.X, z.max.X)
        local cy = math.clamp(pos.Y, z.min.Y, z.max.Y)
        local cz = math.clamp(pos.Z, z.min.Z, z.max.Z)
        if (pos.X - cx) == 0 and (pos.Y - cy) == 0 and (pos.Z - cz) == 0 then return true end
    end
    return false
end

local function GetPartBounds(container)
    local parts = {}
    if container:IsA("BasePart") then parts[#parts+1] = container end
    for _, d in ipairs(container:GetDescendants()) do
        if d:IsA("BasePart") then parts[#parts+1] = d end
    end
    if #parts == 0 then return nil end
    local minX, maxX, minZ, maxZ = math.huge, -math.huge, math.huge, -math.huge
    for i = 1, #parts do
        local p = parts[i]
        local cf = p.CFrame
        local hx, hz = p.Size.X/2, p.Size.Z/2
        local w = cf:PointToWorldSpace(Vector3.new(hx,0,hz)); if w.X<minX then minX=w.X end; if w.X>maxX then maxX=w.X end; if w.Z<minZ then minZ=w.Z end; if w.Z>maxZ then maxZ=w.Z end
        w = cf:PointToWorldSpace(Vector3.new(-hx,0,hz)); if w.X<minX then minX=w.X end; if w.X>maxX then maxX=w.X end; if w.Z<minZ then minZ=w.Z end; if w.Z>maxZ then maxZ=w.Z end
        w = cf:PointToWorldSpace(Vector3.new(hx,0,-hz)); if w.X<minX then minX=w.X end; if w.X>maxX then maxX=w.X end; if w.Z<minZ then minZ=w.Z end; if w.Z>maxZ then maxZ=w.Z end
        w = cf:PointToWorldSpace(Vector3.new(-hx,0,-hz)); if w.X<minX then minX=w.X end; if w.X>maxX then maxX=w.X end; if w.Z<minZ then minZ=w.Z end; if w.Z>maxZ then maxZ=w.Z end
    end
    return minX, maxX, minZ, maxZ
end

local function FillRegion(minX, maxX, minZ, maxZ)
    local pad = 8
    local floorX = math.floor((minX - pad) / 4) * 4
    local ceilX  = math.ceil((maxX + pad) / 4) * 4
    local floorZ = math.floor((minZ - pad) / 4) * 4
    local sizeX = ceilX - floorX
    local sizeZ = math.ceil((maxZ + pad) / 4) * 4 - floorZ
    local y = -12.038 - 30
    local cx = math.ceil(sizeX / 2040)
    local cz = math.ceil(sizeZ / 2040)
    for i = 0, cx - 1 do
        for j = 0, cz - 1 do
            local rx = math.min(2040, sizeX - i*2040)
            local rz = math.min(2040, sizeZ - j*2040)
            local center = CFrame.new(floorX + i*2040 + rx/2, y, floorZ + j*2040 + rz/2)
            local size = Vector3.new(rx, 60, rz)
            pcall(function() Terrain:FillBlock(center, size, Enum.Material.Water) end)
            Beach.TerrainFills[#Beach.TerrainFills+1] = { cf = center, size = size }
        end
    end
end

local function ApplyOceanWater()
    local ok, objectModel = pcall(function()
        return Workspace.Map.AlwaysHereTweenedObjects.Ocean.Object.ObjectModel
    end)
    if not ok or not objectModel then return end
    local children = objectModel:GetChildren()
    for i = 1, #children do
        local minX, maxX, minZ, maxZ = GetPartBounds(children[i])
        if minX then FillRegion(minX, maxX, minZ, maxZ) end
    end
    local folder = Instance.new("Folder")
    folder.Name = "_BeachHiddenOcean"
    folder.Parent = ReplicatedStorage
    Beach.HiddenFolder = folder
    for i = 1, #children do
        pcall(function() children[i].Parent = folder end)
    end
    pcall(function()
        Terrain.WaterWaveSpeed = Beach.WaveSpeed
        Terrain.WaterWaveSize = Beach.WaveSize
        Terrain.WaterTransparency = Beach.WaterTransparency
        Terrain.WaterReflectance = Beach.WaterReflectance
    end)
end

local function ApplyBeachColors()
    local ok, baseGround = pcall(function() return Workspace.Map.BaseGround end)
    if not ok or not baseGround then return end
    local colors = { Color3.fromRGB(219,207,165), Color3.fromRGB(240,230,198), Color3.fromRGB(208,199,171) }
    local newColor = Color3.fromRGB(255,204,153)
    local function matches(c)
        for i = 1, 3 do
            local col = colors[i]
            if math.abs(c.R*255 - col.R*255) <= 2 and math.abs(c.G*255 - col.G*255) <= 2 and math.abs(c.B*255 - col.B*255) <= 2 then return true end
        end
        return false
    end
    for _, child in ipairs(baseGround:GetChildren()) do
        if child.Name == "Sand" then
            if child:IsA("BasePart") and matches(child.Color) then
                Beach.SandColors[#Beach.SandColors+1] = { part = child, color = child.Color }
                child.Color = newColor
            end
            for _, d in ipairs(child:GetDescendants()) do
                if d:IsA("BasePart") and matches(d.Color) then
                    Beach.SandColors[#Beach.SandColors+1] = { part = d, color = d.Color }
                    d.Color = newColor
                end
            end
        end
    end
end

local function DeleteWaterBlock(container)
    local function try()
        local wb = container:FindFirstChild("Water Block", true)
        if wb then wb:Destroy(); return true end
        return false
    end
    if not try() then task.wait(0.5); try() end
end

local function LoadBeachModel(info, index)
    local ok, objects = pcall(game.GetObjects, game, "rbxassetid://" .. info.assetId)
    if not ok or not objects or not objects[1] then return nil end
    local model = objects[1]
    model.Name = info.name
    local folder = Workspace:FindFirstChild("SAVITARMAP")
    if not folder then
        folder = Instance.new("Folder")
        folder.Name = "SAVITARMAP"
        folder.Parent = Workspace
    end
    model:SetAttribute("_isBeachModel", true)
    model.Parent = folder
    Beach.Models[#Beach.Models+1] = model

    local isSeat = info.name == "Boat Spawner" or info.name == "Boat"
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("BasePart") and not (isSeat or d:IsA("Seat") or d:IsA("VehicleSeat")) then
            d.Anchored = true
        end
        if d:IsA("ParticleEmitter") then d.Enabled = true end
    end

    task.defer(function()
        pcall(function() model:PivotTo(info.cframe) end)
        DeleteWaterBlock(model)

        if info.name == "SAVITAR1N" then
            local ac = model:FindFirstChildWhichIsA("AnimationController", true)
            if ac then
                local animator = ac:FindFirstChildOfClass("Animator")
                if animator then
                    local anim = Instance.new("Animation")
                    anim.AnimationId = "rbxassetid://6409102589"
                    local okA, track = pcall(animator.LoadAnimation, animator, anim)
                    if okA and track then track:Play(0, 1, 0.8 + math.random() * 0.4) end
                    anim:Destroy()
                end
            end
            local basePos = info.cframe.Position
            local radius = 70 + (index % 5) * 8
            local speed = 0.18 + (index % 7) * 0.015
            local ang = (index * 1.37) % 6.2831853071795862

            AddUpdater(function(dt)
                if not model.Parent then return end
                ang = ang + speed * dt
                local swing = math.sin(ang * 2.3) * 4
                local px = basePos.X + math.cos(ang) * radius
                local pz = basePos.Z + math.sin(ang) * radius
                local py = basePos.Y + swing
                local nx = basePos.X + math.cos(ang + 0.05) * radius
                local nz = basePos.Z + math.sin(ang + 0.05) * radius
                model:PivotTo(CFrame.lookAt(Vector3.new(px, py, pz), Vector3.new(nx, py, nz)) * CFrame.Angles(0, 0, -0.20943951023931956))
            end)
        end
    end)
    return model
end

local function DestroyBeachSounds()
    for k, s in pairs(Beach.Sounds) do
        if s then s:Stop(); s:Destroy() end
        Beach.Sounds[k] = nil
    end
end

local function StartBeachSounds()
    DestroyBeachSounds()
    Beach.Sounds.Waves = CreateSound(BeachSoundIds.Waves)
    Beach.Sounds.Seagull = CreateSound(BeachSoundIds.Seagull)
    Beach.Sounds.AmbientMusic = CreateSound(BeachSoundIds.AmbientMusic)
end

local function UpdateBeachSounds(dt)
    local target = Beach.LastInZone and 1 or 0
    local lvl = Beach.FadeLevel
    if lvl < target then lvl = math.min(lvl + 0.33*dt, target)
    elseif lvl > target then lvl = math.max(lvl - 0.33*dt, target) end
    Beach.FadeLevel = lvl

    local W = Beach.Sounds.Waves
    if W then
        local v = lvl * Beach.WaveSoundVol
        if math.abs(W.Volume - v) > 0.005 then
            W.Volume = v
            if v > 0.001 and not W.IsPlaying then W:Play()
            elseif v <= 0.001 and W.IsPlaying then W:Pause() end
        end
    end
    local S = Beach.Sounds.Seagull
    if S then
        local v = lvl * Beach.SeagullSoundVol
        if math.abs(S.Volume - v) > 0.005 then
            S.Volume = v
            if v > 0.001 and not S.IsPlaying then S:Play()
            elseif v <= 0.001 and S.IsPlaying then S:Pause() end
        end
    end
    local M = Beach.Sounds.AmbientMusic
    if M then
        local v = lvl * Beach.AmbientMusicVol
        if math.abs(M.Volume - v) > 0.005 then
            M.Volume = v
            if v > 0.001 and not M.IsPlaying then M:Play()
            elseif v <= 0.001 and M.IsPlaying then M:Pause() end
        end
    end
end

local function DestroyBeach()
    Beach.Active = false
    DestroyBeachSounds()
    for _, m in ipairs(Beach.Models) do
        if m and m.Parent then m:Destroy() end
    end
    Beach.Models = {}
    for i = 1, #Beach.TerrainFills do
        local f = Beach.TerrainFills[i]
        pcall(function() Terrain:FillBlock(f.cf, f.size, Enum.Material.Air) end)
    end
    Beach.TerrainFills = {}
    for i = 1, #Beach.SandColors do
        local sc = Beach.SandColors[i]
        if sc.part and sc.part.Parent then sc.part.Color = sc.color end
    end
    Beach.SandColors = {}
    if Beach.HiddenFolder then
        pcall(function()
            local objectModel = Workspace.Map.AlwaysHereTweenedObjects.Ocean.Object.ObjectModel
            for _, child in ipairs(Beach.HiddenFolder:GetChildren()) do child.Parent = objectModel end
            Beach.HiddenFolder:Destroy()
        end)
        Beach.HiddenFolder = nil
    end
    pcall(function()
        Terrain.WaterWaveSpeed = Beach.OrigWater.WaveSpeed
        Terrain.WaterWaveSize = Beach.OrigWater.WaveSize
        Terrain.WaterTransparency = Beach.OrigWater.Transparency
        Terrain.WaterReflectance = Beach.OrigWater.Reflectance
    end)
end

local function LoadBeach()
    if Beach.Active then return end
    Beach.Active = true
    Beach.Models = {}
    Beach.TerrainFills = {}
    Beach.SandColors = {}

    task.spawn(function()
        ApplyOceanWater()
        ApplyBeachColors()
        for i, info in ipairs(BeachModels) do
            if info.name == "SAVITAR1N" then
                task.spawn(function() LoadBeachModel(info, i) end)
            else
                LoadBeachModel(info, i)
                task.wait(0.15)
            end
        end
    end)

    if Beach.SoundEnabled then
        StartBeachSounds()
        AddUpdater(UpdateBeachSounds)
    end
end

-- Наблюдатель зон (включает звуки, когда вы в зоне Forest/Beach)
AddUpdater(function()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        if Forest.Active then
            Forest.LastInZone = IsInForestZone(hrp.Position)
        end
        if Beach.Active then
            Beach.LastInZone = IsInBeachZone(hrp.Position)
        end
    end
end)

local function VisualsCleanup()
    RemoveShader()
    DestroyForest()
    DestroyBeach()
    Updaters = {}
    if VisualHeartbeat then
        VisualHeartbeat:Disconnect()
        VisualHeartbeat = nil
    end
end

pcall(function()
    Library:OnUnload(VisualsCleanup)
end)

-- =====================================================================
-- ВКЛАДКА VISUAL (управление через Obsidian)
-- =====================================================================
local VisualTab = TabObjects["Visual"]
local currentShader = "Scarlet Atmosphere"
local currentLevel = 8

local ShaderGroup = VisualTab:AddLeftGroupbox("Shaders")

ShaderGroup:AddDropdown("SavitarShader", {
    Values = ShaderOrder,
    Default = 1,
    Multi = false,
    Text = "Шейдер",
    Callback = function(v)
        currentShader = v
        if ShaderState.Active then ApplyShader(currentShader, currentLevel) end
    end,
})

ShaderGroup:AddSlider("SavitarIntensity", {
    Text = "Интенсивность",
    Default = 8,
    Min = 0,
    Max = 10,
    Rounding = 0,
    Callback = function(v)
        currentLevel = v
        if ShaderState.Active then ApplyShader(currentShader, currentLevel) end
    end,
})

ShaderGroup:AddToggle("SavitarShaderOn", {
    Text = "Включить шейдер",
    Default = false,
    Callback = function(on)
        if on then
            ApplyShader(currentShader, currentLevel)
        else
            RemoveShader()
        end
    end,
})

local BeachGroup = VisualTab:AddLeftGroupbox("Beach")

BeachGroup:AddToggle("SavitarBeachOn", {
    Text = "Включить Beach",
    Default = false,
    Callback = function(on)
        if on then LoadBeach() else DestroyBeach() end
    end,
})

BeachGroup:AddSlider("SavitarWaveVol", { Text = "Wave Vol", Default = 10, Min = 0, Max = 100, Rounding = 0, Callback = function(v) Beach.WaveSoundVol = v/100 end })
BeachGroup:AddSlider("SavitarSeagullVol", { Text = "Seagull Vol", Default = 40, Min = 0, Max = 100, Rounding = 0, Callback = function(v) Beach.SeagullSoundVol = v/100*5 end })
BeachGroup:AddSlider("SavitarBeachMusic", { Text = "Beach Music", Default = 20, Min = 0, Max = 100, Rounding = 0, Callback = function(v) Beach.AmbientMusicVol = v/100 end })
BeachGroup:AddSlider("SavitarWaveSpeed", { Text = "Wave Speed", Default = 80, Min = 0, Max = 100, Rounding = 0, Callback = function(v) Beach.WaveSpeed = v/10 pcall(function() Terrain.WaterWaveSpeed = Beach.WaveSpeed end) end })
BeachGroup:AddSlider("SavitarWaveSize", { Text = "Wave Size", Default = 50, Min = 0, Max = 100, Rounding = 0, Callback = function(v) Beach.WaveSize = v/100 pcall(function() Terrain.WaterWaveSize = Beach.WaveSize end) end })
BeachGroup:AddSlider("SavitarWaterTransp", { Text = "Water Transp.", Default = 100, Min = 0, Max = 100, Rounding = 0, Callback = function(v) Beach.WaterTransparency = v/100 pcall(function() Terrain.WaterTransparency = Beach.WaterTransparency end) end })
BeachGroup:AddSlider("SavitarWaterRefl", { Text = "Water Refl.", Default = 70, Min = 0, Max = 100, Rounding = 0, Callback = function(v) Beach.WaterReflectance = v/100 pcall(function() Terrain.WaterReflectance = Beach.WaterReflectance end) end })

local ForestGroup = VisualTab:AddRightGroupbox("Forest")

ForestGroup:AddToggle("SavitarForestOn", {
    Text = "Включить Forest",
    Default = false,
    Callback = function(on)
        if on then LoadForest() else DestroyForest() end
    end,
})

ForestGroup:AddSlider("SavitarForestAmbient", { Text = "Forest Ambient", Default = 20, Min = 0, Max = 100, Rounding = 0, Callback = function(v) Forest.AmbientMusicVol = v/100 end })
ForestGroup:AddSlider("SavitarForestAmbience", { Text = "Forest Ambience", Default = 20, Min = 0, Max = 100, Rounding = 0, Callback = function(v) Forest.BackgroundAmbienceVol = v/100 end })
ForestGroup:AddSlider("SavitarForestRiver", { Text = "Forest River", Default = 50, Min = 0, Max = 100, Rounding = 0, Callback = function(v) Forest.RiverSoundMaxVol = v/100 end })