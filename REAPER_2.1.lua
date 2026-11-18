-- ==========================================
-- PULSAR 2.3 — OBSIDIAN EDITION + SAVITAR SHADERS
-- ==========================================

-- =====================================================================
-- ЗАГРУЗОЧНЫЙ ЭКРАН (окно по центру, в линию, название скрипта)
-- =====================================================================
local loaderGui = Instance.new("ScreenGui")
loaderGui.Name = "PulsarLoader"
loaderGui.ResetOnSpawn = false
loaderGui.DisplayOrder = 9999
loaderGui.IgnoreGuiInset = true

local loaderFrame = Instance.new("Frame")
loaderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
loaderFrame.Position = UDim2.fromScale(0.5, 0.5)
loaderFrame.Size = UDim2.fromOffset(360, 46)
loaderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
loaderFrame.BorderSizePixel = 0
loaderFrame.Parent = loaderGui

local loaderCorner = Instance.new("UICorner")
loaderCorner.CornerRadius = UDim.new(0, 8)
loaderCorner.Parent = loaderFrame

local loaderStroke = Instance.new("UIStroke")
loaderStroke.Color = Color3.fromRGB(125, 85, 255)
loaderStroke.Thickness = 1
loaderStroke.Parent = loaderFrame

local loaderTitle = Instance.new("TextLabel")
loaderTitle.Size = UDim2.fromScale(1, 1)
loaderTitle.BackgroundTransparency = 1
loaderTitle.Text = "PULSAR 2.3"
loaderTitle.TextColor3 = Color3.new(1, 1, 1)
loaderTitle.Font = Enum.Font.GothamBold
loaderTitle.TextSize = 16
loaderTitle.Parent = loaderFrame

local loaderBar = Instance.new("Frame")
loaderBar.AnchorPoint = Vector2.new(0.5, 1)
loaderBar.Position = UDim2.new(0.5, 0, 1, -5)
loaderBar.Size = UDim2.new(1, -24, 0, 4)
loaderBar.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
loaderBar.BorderSizePixel = 0
loaderBar.Parent = loaderFrame

local loaderFill = Instance.new("Frame")
loaderFill.Size = UDim2.fromScale(0, 1)
loaderFill.BackgroundColor3 = Color3.fromRGB(125, 85, 255)
loaderFill.BorderSizePixel = 0
loaderFill.Parent = loaderBar

local loaderFillCorner = Instance.new("UICorner")
loaderFillCorner.CornerRadius = UDim.new(0, 2)
loaderFillCorner.Parent = loaderFill

if not pcall(function() loaderGui.Parent = (gethui and gethui()) or game:GetService("CoreGui") end) then
    loaderGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

task.spawn(function()
    local progress = 0
    while loaderGui.Parent do
        progress = math.min(progress + 0.015, 0.9)
        pcall(function() loaderFill.Size = UDim2.fromScale(progress, 1) end)
        task.wait(0.05)
    end
end)

function PulsarLoaderComplete()
    if not loaderGui or not loaderGui.Parent then return end
    pcall(function() loaderFill.Size = UDim2.fromScale(1, 1) end)
    task.wait(0.35)
    pcall(function() loaderGui:Destroy() end)
end

-- =====================================================================
-- КАРТОЧКА FPS | ПИНГ (одна строка, чёрная, перетаскиваемая)
-- =====================================================================
local LockGui = Instance.new("ScreenGui")
LockGui.Name = "PulsarLock"
LockGui.ResetOnSpawn = false
LockGui.DisplayOrder = 9998
LockGui.IgnoreGuiInset = true
LockGui.Enabled = false

local LockButton = Instance.new("TextButton")
LockButton.Position = UDim2.fromOffset(10, 10)
LockButton.Size = UDim2.fromOffset(290, 36)
LockButton.BackgroundColor3 = Color3.fromRGB(14, 14, 16)
LockButton.BorderSizePixel = 0
LockButton.Text = ""
LockButton.AutoButtonColor = false
LockButton.Parent = LockGui

local LockLabel = Instance.new("TextLabel")
LockLabel.Size = UDim2.new(1, -20, 1, 0)
LockLabel.Position = UDim2.fromOffset(10, 0)
LockLabel.BackgroundTransparency = 1
LockLabel.Text = "PULSAR 2.3 | FPS: 0 || Пинг: 0 мс"
LockLabel.TextColor3 = Color3.new(1, 1, 1)
LockLabel.Font = Enum.Font.Gotham
LockLabel.TextSize = 12
LockLabel.TextXAlignment = Enum.TextXAlignment.Left
LockLabel.Parent = LockButton

local LockCorner = Instance.new("UICorner")
LockCorner.CornerRadius = UDim.new(0, 8)
LockCorner.Parent = LockButton

local LockStroke = Instance.new("UIStroke")
LockStroke.Color = Color3.fromRGB(45, 45, 50)
LockStroke.Thickness = 1
LockStroke.Parent = LockButton

local LockInput = game:GetService("UserInputService")
local lockDragging = false
local lockDragStart = nil
local lockStartPos = nil

LockButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        lockDragging = true
        lockDragStart = input.Position
        lockStartPos = LockButton.Position
    end
end)

LockInput.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        lockDragging = false
    end
end)

LockInput.InputChanged:Connect(function(input)
    if lockDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - lockDragStart
        LockButton.Position = UDim2.new(
            lockStartPos.X.Scale, lockStartPos.X.Offset + delta.X,
            lockStartPos.Y.Scale, lockStartPos.Y.Offset + delta.Y
        )
    end
end)

if not pcall(function() LockGui.Parent = (gethui and gethui()) or game:GetService("CoreGui") end) then
    LockGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

task.spawn(function()
    local RunServiceS = game:GetService("RunService")
    local StatsService = game:GetService("Stats")
    local frames = 0
    local acc = 0
    local ping = 0
    local conn = RunServiceS.Heartbeat:Connect(function(dt)
        frames = frames + 1
        acc = acc + dt
    end)
    while LockGui.Parent do
        task.wait(1)
        local fps = 0
        if acc > 0 then fps = math.floor(frames / acc + 0.5) end
        pcall(function()
            ping = StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()
        end)
        pcall(function()
            LockLabel.Text = "PULSAR 2.3 | FPS: " .. fps .. " || Пинг: " .. math.floor(ping) .. " мс"
        end)
        pcall(function()
            LockButton.Text = "PULSAR 2.3 | FPS: " .. fps .. " || Пинг: " .. math.floor(ping) .. " мс"
        end)
        frames = 0
        acc = 0
    end
    pcall(function() conn:Disconnect() end)
end)

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
    Title = "PULSAR 2.3",
    Footer = "Powered by Obsidian",
    Size = UDim2.fromOffset(540, 420),
    Center = true,
    AutoShow = true,
    Resizable = true,
    EnableSidebarResize = true,
    EnableCompacting = true,
    SidebarCompacted = true,
    MinSidebarWidth = 200,
    SidebarCompactWidth = 56,
})
pcall(function() Window:SetCornerRadius(8) end)
pcall(function() PulsarLoaderComplete() end)
pcall(function() LockGui.Enabled = true end)

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

local HotkeyGroup = TabObjects["Home"]:AddLeftGroupbox("Горячие клавиши")
HotkeyGroup:AddLabel("Right Shift — открыть/закрыть меню")

local StatsGroup = TabObjects["Home"]:AddRightGroupbox("Статистика")
StatsGroup:AddLabel("Вкладок: 12")
StatsGroup:AddLabel("Шейдеров: 7")
StatsGroup:AddLabel("Игроков в сервере: " .. #Players:GetPlayers())

HomeGroup:AddImage("LocalAvatar", {
    Image = "rbxthumb://type=Avatar&w=420&h=420&id=" .. LocalPlayer.UserId,
    Height = 150,
})

HomeGroup:AddLabel("PULSAR 2.3 — Obsidian Edition")

local ScriptStartTime = os.clock()

local TimeLabel = HomeGroup:AddLabel("Время: " .. os.date("%H:%M:%S"))
local UptimeLabel = HomeGroup:AddLabel("Запущено: 0:00")

task.spawn(function()
    while not Library.Unloaded do
        task.wait(1)
        local t = "Время: " .. os.date("%H:%M:%S")
        pcall(function() TimeLabel:SetText(t) end)
        pcall(function() TimeLabel.Text = t end)
        pcall(function() TimeLabel.TextLabel.Text = t end)

        local secs = math.floor(os.clock() - ScriptStartTime)
        local h = math.floor(secs / 3600)
        local m = math.floor((secs % 3600) / 60)
        local s = secs % 60
        local up
        if h > 0 then
            up = string.format("%d:%02d:%02d", h, m, s)
        else
            up = string.format("%d:%02d", m, s)
        end
        local u = "Запущено: " .. up
        pcall(function() UptimeLabel:SetText(u) end)
        pcall(function() UptimeLabel.Text = u end)
        pcall(function() UptimeLabel.TextLabel.Text = u end)
    end
end)

local function CopyText(text)
    if type(text) ~= "string" or text == "" then return false end
    local ok = pcall(function() setclipboard(text) end)
    if not ok then
        ok = pcall(function() toclipboard(text) end)
    end
    return ok
end

local PlayerImages = {}
local function BuildPlayerValues()
    local values = {}
    PlayerImages = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        values[#values + 1] = plr.Name
        PlayerImages[plr.Name] = "rbxthumb://type=AvatarHeadShot&w=48&h=48&id=" .. plr.UserId
    end
    return values
end

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

HomeGroup:AddDropdown("CopyPlayerDropdown", {
    Values = BuildPlayerValues(),
    ValueImages = PlayerImages,
    Multi = true,
    AllowNull = true,
    Searchable = true,
    MaxVisibleDropdownItems = 4,
    Text = "Игроки (аватарки)",
    Callback = function() end,
})

local function RefreshPlayerList()
    pcall(function()
        local opts = Library.Options.CopyPlayerDropdown
        if not opts then return end
        opts.Values = BuildPlayerValues()
        opts.ValueImages = PlayerImages
        opts:SetValue(nil)
    end)
end

Players.PlayerAdded:Connect(function() task.defer(RefreshPlayerList) end)
Players.PlayerRemoving:Connect(function() task.defer(RefreshPlayerList) end)

HomeGroup:AddButton({
    Text = "Копировать ник",
    Func = function()
        local val = nil
        pcall(function() val = Library.Options.CopyPlayerDropdown.Value end)
        local name = nil
        if type(val) == "table" then
            for n in pairs(val) do name = n break end
        elseif type(val) == "string" then
            name = val
        end
        if type(name) ~= "string" or name == "" then
            Library:Notify("Сначала выбери игрока в списке выше")
            return
        end
        if CopyText(name) then
            Library:Notify("Скопировано: " .. name)
        else
            Library:Notify("Копирование не поддерживается инжектором")
        end
    end
})

HomeGroup:AddButton({
    Text = "Копировать все ники",
    Func = function()
        local names = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            names[#names + 1] = plr.Name
        end
        if CopyText(table.concat(names, "\n")) then
            Library:Notify("Скопировано ников: " .. #names)
        else
            Library:Notify("Копирование не поддерживается инжектором")
        end
    end
})

-- =====================================================================
-- SAVITAR SHADERS — ДВИЖОК (встроено в PULSAR 2.3)
-- =====================================================================
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

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

local function VisualsCleanup()
    RemoveShader()
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


-- =====================================================================
-- ВКЛАДКА SETTINGS (Interface)
-- =====================================================================
local SettingsGroup = TabObjects["Settings"]:AddLeftGroupbox("Interface")

SettingsGroup:AddToggle("HideTabText", {
    Text = "Скрывать текст вкладок",
    Default = true,
    Callback = function(on)
        local ok = pcall(function() Window:SetSidebarCompacted(on) end)
        if not ok then
            ok = pcall(function()
                Window.SidebarCompacted = on
                if Window.UpdateCompacting then Window:UpdateCompacting() end
            end)
        end
        Library:Notify(ok and (on and "Текст вкладок скрыт" or "Текст вкладок показан") or "Не поддерживается этой версией Obsidian")
    end,
})