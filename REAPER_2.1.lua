-- ==========================================
-- PULSAR 2.3 — OBSIDIAN EDITION + SAVITAR SHADERS
-- ==========================================

-- =====================================================================
-- ЗАГРУЗОЧНЫЙ ЭКРАН (полупрозрачный фон, карточка растёт как у Resonance 2.9)
-- =====================================================================
local TweenService = game:GetService("TweenService")
local loaderGui = Instance.new("ScreenGui")
loaderGui.Name = "PulsarLoader"
loaderGui.ResetOnSpawn = false
loaderGui.DisplayOrder = 9999
loaderGui.IgnoreGuiInset = true

local loaderBack = Instance.new("Frame")
loaderBack.Size = UDim2.fromScale(1, 1)
loaderBack.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
loaderBack.BackgroundTransparency = 1
loaderBack.Active = false
loaderBack.BorderSizePixel = 0
loaderBack.Parent = loaderGui

local loaderFrame = Instance.new("Frame")
loaderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
loaderFrame.Position = UDim2.fromScale(0.5, 0.5)
loaderFrame.Size = UDim2.fromOffset(0, 0)
loaderFrame.ClipsDescendants = true
loaderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
loaderFrame.BorderSizePixel = 0
loaderFrame.Parent = loaderGui

local loaderCorner = Instance.new("UICorner")
loaderCorner.CornerRadius = UDim.new(0, 10)
loaderCorner.Parent = loaderFrame

local loaderTitle = Instance.new("TextLabel")
loaderTitle.Size = UDim2.new(1, 0, 0, 30)
loaderTitle.Position = UDim2.new(0, 0, 0, 12)
loaderTitle.BackgroundTransparency = 1
loaderTitle.Text = "PULSAR"
loaderTitle.TextColor3 = Color3.new(1, 1, 1)
loaderTitle.Font = Enum.Font.GothamBold
loaderTitle.TextSize = 22
loaderTitle.Parent = loaderFrame

local loaderVersion = Instance.new("TextLabel")
loaderVersion.Size = UDim2.new(1, 0, 0, 18)
loaderVersion.Position = UDim2.new(0, 0, 0, 42)
loaderVersion.BackgroundTransparency = 1
loaderVersion.Text = "Версия 2.3"
loaderVersion.TextColor3 = Color3.fromRGB(160, 160, 170)
loaderVersion.Font = Enum.Font.Gotham
loaderVersion.TextSize = 14
loaderVersion.Parent = loaderFrame

local loaderBar = Instance.new("Frame")
loaderBar.AnchorPoint = Vector2.new(0.5, 0)
loaderBar.Position = UDim2.new(0.5, 0, 0.5, 60)
loaderBar.Size = UDim2.new(0, 280, 0, 4)
loaderBar.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
loaderBar.BackgroundTransparency = 1
loaderBar.BorderSizePixel = 0
loaderBar.Parent = loaderGui

local loaderBarCorner = Instance.new("UICorner")
loaderBarCorner.CornerRadius = UDim.new(1, 0)
loaderBarCorner.Parent = loaderBar

local loaderFill = Instance.new("Frame")
loaderFill.Size = UDim2.fromScale(0, 1)
loaderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
loaderFill.BackgroundTransparency = 1
loaderFill.BorderSizePixel = 0
loaderFill.Parent = loaderBar

local loaderFillCorner = Instance.new("UICorner")
loaderFillCorner.CornerRadius = UDim.new(0, 2)
loaderFillCorner.Parent = loaderFill

if not pcall(function() loaderGui.Parent = (gethui and gethui()) or game:GetService("CoreGui") end) then
    loaderGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

task.spawn(function()
    local intro = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local introBack = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    pcall(function()
        TweenService:Create(loaderBack, introBack, { BackgroundTransparency = 0.45 }):Play()
        TweenService:Create(loaderFrame, intro, { Size = UDim2.fromOffset(360, 90) }):Play()
    end)
    task.wait(0.35)
    pcall(function()
        local fadeIn = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(loaderBar, fadeIn, { BackgroundTransparency = 0 }):Play()
        TweenService:Create(loaderFill, fadeIn, { BackgroundTransparency = 0 }):Play()
    end)
end)

task.delay(10, function()
    if loaderGui then pcall(function() PulsarLoaderComplete() end) end
end)

task.spawn(function()
    local progress = 0
    while loaderGui and loaderGui.Parent do
        progress = math.min(progress + 0.015, 0.9)
        pcall(function()
            TweenService:Create(
                loaderFill,
                TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { Size = UDim2.fromScale(progress, 1) }
            ):Play()
        end)
        task.wait(0.05)
    end
end)

local loaderDone = false
function PulsarLoaderComplete()
    if loaderDone then return end
    if not loaderGui or typeof(loaderGui) ~= "Instance" then return end
    loaderDone = true
    pcall(function()
        TweenService:Create(
            loaderFill,
            TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { Size = UDim2.fromScale(1, 1) }
        ):Play()
    end)
    task.wait(0.4)
    if not loaderGui or typeof(loaderGui) ~= "Instance" then return end
    pcall(function()
        local out = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        TweenService:Create(loaderBack, out, { BackgroundTransparency = 1 }):Play()
        TweenService:Create(loaderFrame, out, { Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1 }):Play()
        TweenService:Create(loaderBar, out, { BackgroundTransparency = 1 }):Play()
        TweenService:Create(loaderFill, out, { BackgroundTransparency = 1 }):Play()
    end)
    task.wait(0.3)
    pcall(function() loaderGui:Destroy() end)
    loaderGui = nil
end

-- =====================================================================
-- КАРТОЧКА FPS | ПИНГ (одна строка, чёрная, сверху по центру, перетаскиваемая)
-- =====================================================================
local LockGui = Instance.new("ScreenGui")
LockGui.Name = "PulsarLock"
LockGui.ResetOnSpawn = false
LockGui.DisplayOrder = 100
LockGui.IgnoreGuiInset = true
LockGui.Enabled = false

local LockButton = Instance.new("TextButton")
LockButton.Position = UDim2.new(0.5, -145, 0, 10)
LockButton.Size = UDim2.fromOffset(290, 36)
LockButton.BackgroundColor3 = Color3.fromRGB(14, 14, 16)
LockButton.BackgroundTransparency = 0
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
        frames = 0
        acc = 0
    end
    pcall(function() conn:Disconnect() end)
end)

local okLib, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
end)
if not okLib or type(Library) ~= "table" then
    pcall(function() PulsarLoaderComplete() end)
    warn("[PULSAR] Не удалось загрузить библиотеку Obsidian")
    return
end

pcall(function()
    local Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/lucide-roblox-direct/refs/heads/main/source.lua"))()
    if type(Icons) == "table" and Library.SetIconModule then
        Library:SetIconModule(Icons)
    end
end)

pcall(function() Library.ForceCheckbox = true end)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Window = Library:CreateWindow({
    Title = "PULSAR 2.3",
    Footer = "Powered by Obsidian",
    ToggleKeybind = Enum.KeyCode.RightShift,
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
pcall(function() Library.CantDragForced = false end)
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

pcall(function()
    HomeGroup:AddImage("LocalAvatar", {
        Image = "rbxthumb://type=Avatar&w=420&h=420&id=" .. LocalPlayer.UserId,
        Height = 150,
    })
end)

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
    local opts = Library.Options and Library.Options.CopyPlayerDropdown
    if not opts then return end
    local values = BuildPlayerValues()
    pcall(function() opts.ValueImages = PlayerImages end)
    local ok = pcall(function() opts:SetValues(values) end)
    if not ok then
        pcall(function() opts.Values = values end)
    end
    pcall(function() opts:SetValue(nil) end)
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
            local opts = Library.Options.CopyPlayerDropdown
            local values = opts and opts.Values
            for _, v in ipairs(values or {}) do
                if val[v] then name = v break end
            end
            if not name then
                for n in pairs(val) do
                    if type(n) == "string" then name = n break end
                end
            end
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
    ["Thunderstorm"] = {
        Lighting = { Brightness=1.7, ClockTime=19.4, FogEnd=900, FogStart=0, FogColor=Color3.fromRGB(70,75,90), ExposureCompensation=-0.02, ShadowSoftness=0.4, Ambient=Color3.fromRGB(45,47,55), ColorShift_Top=Color3.fromRGB(120,128,150), OutdoorAmbient=Color3.fromRGB(90,95,115) },
        ColorCorrection={Saturation=-0.12,Contrast=0.18,TintColor=Color3.fromRGB(215,220,235)},
        Atmosphere={Density=0.3,Offset=0.2,Haze=1.6,Glare=0.05,Color=Color3.fromRGB(90,95,115),Decay=Color3.fromRGB(80,85,105)},
    },
}

local ShaderOrder = { "Scarlet Atmosphere", "Golden Hour", "Night", "Neon Night", "Lost Ocean", "Dreamy", "Colorful", "Thunderstorm" }

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
local StormStart, StormStop

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
    if shaderName == "Thunderstorm" then
        local stormSky = Instance.new("Sky", Lighting)
        stormSky.Name = "SavitarStormSky"
        stormSky.CelestialBodiesShown = false
        stormSky.StarCount = 0
        ActiveEffects[#ActiveEffects+1] = stormSky
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            local clouds = terrain:FindFirstChildOfClass("Clouds")
            if not clouds then
                clouds = Instance.new("Clouds")
                clouds.Parent = terrain
                ActiveEffects[#ActiveEffects+1] = clouds
            end
            clouds.Enabled = true
            clouds.Cover = math.clamp(0.4 + t * 0.5, 0, 1)
            clouds.Density = 0.7
            clouds.Color = Color3.fromRGB(120, 125, 135)
        end
    end

    if shaderName == "Thunderstorm" then
        StormStart(level)
    else
        StormStop()
    end

    ShaderState.Active = true
    ShaderState.CurrentName = shaderName
    ShaderState.Level = level
    return true
end

local function RemoveShader()
    DestroyEffects()
    RestoreOriginal()
    StormStop()
    ShaderState.Active = false
end

-- ============ СЕКЦИЯ ГРОЗА ============
local STORM_THUNDER_IDS = { 98719867425764, 133426162, 4961240438 }
local SoundService = game:GetService("SoundService")

local Storm = { Zone = nil, Sound = nil, MoveConn = nil, FlashConn = nil, FlashTask = nil }

StormStop = function()
    if Storm.Zone then
        pcall(function() Storm.Zone:Destroy() end)
        Storm.Zone = nil
    end
    if Storm.Sound then
        pcall(function() Storm.Sound:Stop() end)
        pcall(function() Storm.Sound:Destroy() end)
        Storm.Sound = nil
    end
    if Storm.MoveConn then
        pcall(function() Storm.MoveConn:Disconnect() end)
        Storm.MoveConn = nil
    end
    if Storm.FlashConn then
        pcall(function() Storm.FlashConn:Disconnect() end)
        Storm.FlashConn = nil
    end
    if Storm.FlashTask then
        pcall(function() task.cancel(Storm.FlashTask) end)
        Storm.FlashTask = nil
    end
end

StormStart = function(level)
    StormStop()
    level = level or 8

    -- зона дождя над камерой
    local cam = workspace.CurrentCamera
    if cam then
        local zone = Instance.new("Part")
        zone.Name = "PulsarRainZone"
        zone.Size = Vector3.new(60, 1, 60)
        zone.Anchored = true
        zone.CanCollide = false
        zone.Transparency = 1
        zone.Position = cam.CFrame.Position + cam.CFrame.LookVector * 20 + Vector3.new(0, 40, 0)
        zone.Parent = workspace
        Storm.Zone = zone

        local rain = Instance.new("ParticleEmitter")
        rain.Name = "PulsarRain"
        rain.Texture = "rbxasset://textures/particles/smoke_main.dds"
        rain.Rate = 40 * level
        rain.Lifetime = NumberRange.new(0.8, 1.2)
        rain.Speed = NumberRange.new(90, 110)
        rain.SpreadAngle = Vector2.new(4, 4)
        rain.Size = NumberSequence.new(0.35)
        rain.Color = ColorSequence.new(Color3.fromRGB(200, 210, 230))
        rain.Transparency = NumberSequence.new(0.55)
        rain.Parent = zone

        Storm.MoveConn = RunService.Heartbeat:Connect(function()
            pcall(function()
                local c = workspace.CurrentCamera
                if c and Storm.Zone then
                    Storm.Zone.Position = c.CFrame.Position + c.CFrame.LookVector * 20 + Vector3.new(0, 40, 0)
                end
            end)
        end)
    end

    -- подбор звука грома: перебор кандидатов с ожиданием загрузки (PreloadAsync в Delta не надёжен)
    task.spawn(function()
        local chosen = nil
        for _, id in ipairs(STORM_THUNDER_IDS) do
            local s = nil
            pcall(function()
                s = Instance.new("Sound")
                s.SoundId = "rbxassetid://" .. tostring(id)
                s.Volume = 1
                s.Parent = SoundService
            end)
            if s then
                local waited = 0
                while not s.IsLoaded and waited < 2.5 do
                    task.wait(0.1)
                    waited = waited + 0.1
                end
                local len = nil
                pcall(function() len = s.TimeLength end)
                if s.IsLoaded and (len or 0) > 0 then
                    chosen = s
                    break
                end
                pcall(function() s:Destroy() end)
            end
        end
        if chosen then
            if ShaderState.Active and ShaderState.CurrentName == "Thunderstorm" then
                Storm.Sound = chosen
                pcall(function() chosen:Play() end)
            else
                pcall(function() chosen:Destroy() end)
            end
        end
        -- если ни один кандидат не загрузился — гроза работает без звука
    end)

    -- вспышки молний: 3-8 c, тройной удар, гром через 0.3 c
    Storm.FlashTask = task.spawn(function()
        while true do
            task.wait(3 + math.random() * 5)
            if not (ShaderState.Active and ShaderState.CurrentName == "Thunderstorm") then break end
            local baseBrightness = Lighting.Brightness or 2
            local baseExposure = Lighting.ExposureCompensation or 0
            pcall(function() Lighting.Brightness = baseBrightness + 3 end)
            task.wait(0.11)
            pcall(function() Lighting.Brightness = baseBrightness + 1 end)
            pcall(function() Lighting.ExposureCompensation = baseExposure + 0.2 end)
            task.wait(0.11)
            pcall(function() Lighting.Brightness = baseBrightness + 2.5 end)
            pcall(function() Lighting.ExposureCompensation = baseExposure + 0.6 end)
            task.wait(0.11)
            pcall(function() Lighting.Brightness = baseBrightness end)
            pcall(function() Lighting.ExposureCompensation = baseExposure end)
            -- гром с задержкой 0.3 c
            task.delay(0.3, function()
                if Storm.Sound then pcall(function() Storm.Sound:Play() end) end
            end)
        end
    end)
end

-- ============ ОЧИСТКА ============
local PulsarSoundMuteOff

local function VisualsCleanup()
    pcall(function() StormStop() end)
    pcall(function() PulsarSoundMuteOff() end)
    pcall(function() RemoveShader() end)
    pcall(function() Updaters = {} end)
    pcall(function()
        if VisualHeartbeat then VisualHeartbeat:Disconnect() end
    end)
    pcall(function() if LockGui then LockGui:Destroy() end end)
    pcall(function() if loaderGui then loaderGui:Destroy() end end)
end

Library:OnUnload(VisualsCleanup)

-- ============ ВКЛАДКА VISUAL ============
local ShaderGroup = TabObjects["Visual"]:AddLeftGroupbox("Shaders")

ShaderGroup:AddDropdown("SavitarShader", {
    Values = ShaderOrder,
    Default = "Scarlet Atmosphere",
    Multi = false,
    Text = "Пресет",
    Tooltip = "Выбор визуального пресета",
})
ShaderGroup:AddSlider("SavitarIntensity", {
    Text = "Интенсивность",
    Default = 8,
    Min = 0,
    Max = 10,
    Rounding = 0,
    Compact = false,
})
ShaderGroup:AddToggle("SavitarShaderOn", {
    Text = "Включить шейдер",
    Default = false,
    Callback = function(v)
        if v then
            task.spawn(function()
                local name = Library.Options.SavitarShader and Library.Options.SavitarShader.Value or "Scarlet Atmosphere"
                local lvl = Library.Options.SavitarIntensity and Library.Options.SavitarIntensity.Value or 8
                local ok = ApplyShader(name, lvl)
                if ok then
                    pcall(function() Library:Notify("Шейдер: " .. name) end)
                else
                    pcall(function() Library:Notify("Не удалось применить шейдер") end)
                end
            end)
        else
            RemoveShader()
        end
    end,
})

-- ============ ВКЛАДКА VISUAL: БЛОК ЗВУКИ ============
local SoundMuteCatGroup = TabObjects["Visual"]:AddLeftGroupbox("Звуки")

local SoundCategories = {
    { Name = "Ambience",     Text = "Mute Ambience",              Patterns = { "ambien", "wind", "birds" } },
    { Name = "Boombox",      Text = "Mute Boomboxes & Jukeboxes", Patterns = { "boombox", "jukebox" } },
    { Name = "Screams",      Text = "Mute Screams",               Patterns = { "scream", "yell", "panic" } },
    { Name = "Explosions",   Text = "Mute Explosions",            Patterns = { "explos", "boom" } },
    { Name = "Soundwaves",   Text = "Mute Soundwaves",            Patterns = { "soundwave", "sound wave" } },
    { Name = "RhythmMakers", Text = "Mute Rhythm Makers",         Patterns = { "rhythm" } },
    { Name = "Instruments",  Text = "Mute Instruments",           Patterns = { "instrument", "piano", "drum", "guitar", "trumpet", "flute", "violin" } },
    { Name = "Ragdoll",      Text = "Mute Ragdoll Sounds",        Patterns = { "ragdoll", "bodyfall", "thud", "splat", "bonk" } },
}

local function MatchesPatterns(sound, patterns)
    local ok, res = pcall(function()
        local name = string.lower(tostring(sound.Name))
        for _, p in ipairs(patterns) do
            if string.find(name, string.lower(p), 1, true) then
                return true
            end
        end
        -- обход ВСЕЙ цепочки родителей до game (звуки в FTAP лежат глубоко)
        local node = sound.Parent
        while node and node ~= game do
            local pname = string.lower(tostring(node.Name))
            for _, p in ipairs(patterns) do
                if string.find(pname, string.lower(p), 1, true) then
                    return true
                end
            end
            node = node.Parent
        end
        return false
    end)
    return ok and res or false
end

local function UninstallGroup(group)
    pcall(function()
        for _, s in ipairs(game:GetDescendants()) do
            if s:IsA("Sound") and s.SoundGroup == group then
                s.SoundGroup = nil
            end
        end
    end)
    pcall(function() group:Destroy() end)
end

local MuteWatcher = nil

local function UpdateMuteWatcher()
    local anyActive = false
    for _, cat in ipairs(SoundCategories) do
        local opt = Library.Options["PulsarMute_" .. cat.Name]
        if opt and opt.Value then
            anyActive = true
            break
        end
    end
    if anyActive and not MuteWatcher then
        MuteWatcher = game.DescendantAdded:Connect(function(d)
            pcall(function()
                if d:IsA("Sound") then
                    task.defer(function()
                        for _, cat in ipairs(SoundCategories) do
                            local opt = Library.Options["PulsarMute_" .. cat.Name]
                            if opt and opt.Value and MatchesPatterns(d, cat.Patterns) then
                                pcall(function() d.SoundGroup = SoundService:FindFirstChild("PulsarMute_" .. cat.Name) end)
                            end
                        end
                    end)
                end
            end)
        end)
    elseif not anyActive and MuteWatcher then
        pcall(function() MuteWatcher:Disconnect() end)
        MuteWatcher = nil
    end
end

PulsarSoundMuteOff = function()
    for _, cat in ipairs(SoundCategories) do
        local g = SoundService:FindFirstChild("PulsarMute_" .. cat.Name)
        if g then UninstallGroup(g) end
        local opt = Library.Options["PulsarMute_" .. cat.Name]
        if opt then pcall(function() opt:SetValue(false) end) end
    end
    if MuteWatcher then
        pcall(function() MuteWatcher:Disconnect() end)
        MuteWatcher = nil
    end
end

for _, cat in ipairs(SoundCategories) do
    SoundMuteCatGroup:AddToggle("PulsarMute_" .. cat.Name, {
        Text = cat.Text,
        Default = false,
        Callback = function(v)
            local gname = "PulsarMute_" .. cat.Name
            if v then
                local g = SoundService:FindFirstChild(gname)
                if not g then
                    g = Instance.new("SoundGroup")
                    g.Name = gname
                    g.Volume = 0
                    g.Parent = SoundService
                end
                task.spawn(function()
                    for _, s in ipairs(game:GetDescendants()) do
                        pcall(function()
                            if s:IsA("Sound") and not s.SoundGroup and MatchesPatterns(s, cat.Patterns) then
                                s.SoundGroup = g
                            end
                        end)
                    end
                end)
                UpdateMuteWatcher()
            else
                local g = SoundService:FindFirstChild(gname)
                if g then UninstallGroup(g) end
                UpdateMuteWatcher()
            end
        end,
    })
end

-- ============ ВКЛАДКА PLAYER ============
local PlayerMoveGroup = TabObjects["Player"]:AddLeftGroupbox("Movement")

-- #101 Infinite Jump
PlayerMoveGroup:AddToggle("InfiniteJump", {
    Text = "Infinite Jump",
    Default = false,
    Callback = function(v)
        task.spawn(function()
            if v then
                _G.PulsarInfJumpConn = UserInputService.JumpRequest:Connect(function()
                    local char = LocalPlayer.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if hum then pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end) end
                end)
            else
                pcall(function()
                    if _G.PulsarInfJumpConn then _G.PulsarInfJumpConn:Disconnect() end
                end)
                _G.PulsarInfJumpConn = nil
            end
        end)
    end,
})

-- #102 Noclip
PlayerMoveGroup:AddToggle("PulsarNoclip", {
    Text = "Noclip",
    Default = false,
    Callback = function(v)
        task.spawn(function()
            if v then
                _G.PulsarNoclipConn = RunService.Stepped:Connect(function()
                    local char = LocalPlayer.Character
                    if not char then return end
                    for _, part in ipairs(char:GetDescendants()) do
                        pcall(function()
                            if part:IsA("BasePart") and part.CanCollide then
                                part.CanCollide = false
                            end
                        end)
                    end
                end)
            else
                pcall(function()
                    if _G.PulsarNoclipConn then _G.PulsarNoclipConn:Disconnect() end
                end)
                _G.PulsarNoclipConn = nil
            end
        end)
    end,
})

-- #103 Fly
PlayerMoveGroup:AddSlider("PulsarFlySpeed", {
    Text = "Fly Speed",
    Default = 50,
    Min = 10,
    Max = 200,
    Rounding = 0,
    Compact = false,
})
PlayerMoveGroup:AddSlider("PulsarFlyForce", {
    Text = "Fly Force",
    Default = 5000,
    Min = 1000,
    Max = 20000,
    Rounding = 0,
    Compact = false,
})
PlayerMoveGroup:AddToggle("PulsarFly", {
    Text = "Fly",
    Default = false,
    Callback = function(v)
        task.spawn(function()
            if v then
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not (hum and hrp) then
                    pcall(function() Library:Notify("Персонаж не найден") end)
                    return
                end
                local bv = Instance.new("BodyVelocity")
                bv.Name = "PulsarFlyBV"
                bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                bv.Velocity = Vector3.zero
                bv.Parent = hrp
                local bg = Instance.new("BodyGyro")
                bg.Name = "PulsarFlyBG"
                bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
                bg.P = 9e4
                bg.CFrame = hrp.CFrame
                bg.Parent = hrp
                _G.PulsarFlyConn = RunService.Heartbeat:Connect(function()
                    pcall(function()
                        local c = LocalPlayer.Character
                        local h = c and c:FindFirstChildOfClass("Humanoid")
                        local root = c and c:FindFirstChild("HumanoidRootPart")
                        local bodyVel = root and root:FindFirstChild("PulsarFlyBV")
                        local bodyGyro = root and root:FindFirstChild("PulsarFlyBG")
                        if not (h and root and bodyVel and bodyGyro) then return end
                        bodyGyro.CFrame = workspace.CurrentCamera.CFrame
                        local move = h.MoveDirection
                        local speed = (Library.Options.PulsarFlySpeed and Library.Options.PulsarFlySpeed.Value) or 50
                        if move.Magnitude > 0 then
                            bodyVel.Velocity = move * speed
                        else
                            bodyVel.Velocity = Vector3.zero
                        end
                    end)
                end)
            else
                pcall(function()
                    if _G.PulsarFlyConn then _G.PulsarFlyConn:Disconnect() end
                end)
                _G.PulsarFlyConn = nil
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    pcall(function() local b = hrp:FindFirstChild("PulsarFlyBV") if b then b:Destroy() end end)
                    pcall(function() local b = hrp:FindFirstChild("PulsarFlyBG") if b then b:Destroy() end end)
                end
            end
        end)
    end,
})

-- #104 Speed Boost
PlayerMoveGroup:AddSlider("PulsarSpeedBoost", {
    Text = "Speed Boost (WalkSpeed)",
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 0,
    Compact = false,
})
PlayerMoveGroup:AddToggle("PulsarSpeedOn", {
    Text = "Speed Boost",
    Default = false,
    Callback = function(v)
        task.spawn(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                if v then
                    local spd = (Library.Options.PulsarSpeedBoost and Library.Options.PulsarSpeedBoost.Value) or 16
                    pcall(function() hum.WalkSpeed = spd end)
                else
                    pcall(function() hum.WalkSpeed = 16 end)
                end
            end
        end)
    end,
})

-- #105 High Jump
PlayerMoveGroup:AddSlider("PulsarJumpPower", {
    Text = "High Jump (JumpPower)",
    Default = 50,
    Min = 50,
    Max = 300,
    Rounding = 0,
    Compact = false,
})
PlayerMoveGroup:AddToggle("PulsarJumpOn", {
    Text = "High Jump",
    Default = false,
    Callback = function(v)
        task.spawn(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                if v then
                    local p = (Library.Options.PulsarJumpPower and Library.Options.PulsarJumpPower.Value) or 50
                    pcall(function()
                        hum.UseJumpPower = true
                        hum.JumpPower = p
                    end)
                else
                    pcall(function() hum.JumpPower = 50 end)
                end
            end
        end)
    end,
})

-- #106 Low Gravity / #107 Zero Gravity
PlayerMoveGroup:AddToggle("PulsarLowGravity", {
    Text = "Low Gravity",
    Default = false,
    Callback = function(v)
        pcall(function() workspace.Gravity = v and 60 or 196.2 end)
    end,
})
PlayerMoveGroup:AddToggle("PulsarZeroGravity", {
    Text = "Zero Gravity",
    Default = false,
    Callback = function(v)
        pcall(function() workspace.Gravity = v and 0 or 196.2 end)
    end,
})

-- #108 Auto Jump
PlayerMoveGroup:AddToggle("PulsarAutoJump", {
    Text = "Auto Jump",
    Default = false,
    Callback = function(v)
        task.spawn(function()
            if v then
                _G.PulsarAutoJumpConn = RunService.Heartbeat:Connect(function()
                    pcall(function()
                        local char = LocalPlayer.Character
                        local hum = char and char:FindFirstChildOfClass("Humanoid")
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        if hum and hrp and hum.FloorMaterial ~= Enum.Material.Air then
                            local rayParams = RaycastParams.new()
                            rayParams.FilterDescendantsInstances = { char }
                            rayParams.FilterType = Enum.RaycastFilterType.Exclude
                            local result = workspace:Raycast(hrp.Position, hrp.CFrame.LookVector * 3, rayParams)
                            if result then
                                hum.Jump = true
                            end
                        end
                    end)
                end)
            else
                pcall(function()
                    if _G.PulsarAutoJumpConn then _G.PulsarAutoJumpConn:Disconnect() end
                end)
                _G.PulsarAutoJumpConn = nil
            end
        end)
    end,
})

-- #114-119 Телепорты
local PlayerTpGroup = TabObjects["Player"]:AddRightGroupbox("Teleports")

local function TeleportTo(cframe)
    task.spawn(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            pcall(function() hrp.CFrame = cframe end)
        end
    end)
end

PlayerTpGroup:AddButton({
    Text = "TP Spawn",
    Func = function()
        local spawnLoc = workspace:FindFirstChildOfClass("SpawnLocation")
        if spawnLoc then
            TeleportTo(spawnLoc.CFrame + Vector3.new(0, 5, 0))
        end
    end,
})
PlayerTpGroup:AddButton({
    Text = "TP Random Player",
    Func = function()
        local others = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(others, p) end
        end
        local target = others[math.random(#others)]
        local char = target and target.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            TeleportTo(hrp.CFrame + Vector3.new(0, 3, 0))
        end
    end,
})
PlayerTpGroup:AddButton({
    Text = "TP Forward 20",
    Func = function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            TeleportTo(hrp.CFrame + hrp.CFrame.LookVector * 20)
        end
    end,
})
PlayerTpGroup:AddButton({
    Text = "TP Up 20",
    Func = function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            TeleportTo(hrp.CFrame + Vector3.new(0, 20, 0))
        end
    end,
})
PlayerTpGroup:AddButton({
    Text = "TP Down 20",
    Func = function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            TeleportTo(hrp.CFrame - Vector3.new(0, 20, 0))
        end
    end,
})
PlayerTpGroup:AddButton({
    Text = "TP Cursor",
    Func = function()
        local cam = workspace.CurrentCamera
        local mouse = LocalPlayer:GetMouse()
        if cam and mouse and mouse.Hit then
            TeleportTo(CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0)))
        end
    end,
})

-- ============ ВКЛАДКА SETTINGS ============
local SettingsGroup = TabObjects["Settings"]:AddLeftGroupbox("Настройки меню")

SettingsGroup:AddToggle("HideTabText", {
    Text = "Скрыть текст вкладок",
    Default = false,
    Callback = function(v)
        task.spawn(function()
            local ok = pcall(function()
                if Window.SetSidebarCompacted then
                    Window:SetSidebarCompacted(v)
                end
            end)
            if not ok or not Window.SetSidebarCompacted then
                pcall(function() Window.SidebarCompacted = v end)
            end
        end)
    end,
})