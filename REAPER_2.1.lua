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
local loaderShownAt = os.clock()
function PulsarLoaderComplete()
    if loaderDone then return end
    if not loaderGui or typeof(loaderGui) ~= "Instance" then return end
    loaderDone = true

    local left = 2 - (os.clock() - loaderShownAt)
    if left > 0 then
        task.wait(left)
    end

    pcall(function()
        TweenService:Create(
            loaderFill,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { Size = UDim2.fromScale(1, 1) }
        ):Play()
    end)
    task.wait(0.6)
    if not loaderGui or typeof(loaderGui) ~= "Instance" then return end

    local out = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    pcall(function()
        TweenService:Create(loaderBack, out, { BackgroundTransparency = 1 }):Play()
        TweenService:Create(loaderFrame, out, { BackgroundTransparency = 1 }):Play()
        TweenService:Create(loaderTitle, out, { TextTransparency = 1 }):Play()
        TweenService:Create(loaderVersion, out, { TextTransparency = 1 }):Play()
        TweenService:Create(loaderBar, out, { BackgroundTransparency = 1 }):Play()
        TweenService:Create(loaderFill, out, { BackgroundTransparency = 1 }):Play()
    end)
    task.wait(0.7)
    pcall(function() loaderGui:Destroy() end)
    loaderGui = nil
end

-- =====================================================================
-- КАРТОЧКА FPS | ПИНГ (одна строка, чёрная, сверху по центру, перетаскиваемая)
-- =====================================================================
local LockGui = Instance.new("ScreenGui")
LockGui.Name = "PulsarLock"
LockGui.ResetOnSpawn = false
LockGui.DisplayOrder = 9998
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
    ToggleKeybind = Enum.KeyCode.M,
    ShowMobileButtons = true,
    SearchbarSize = UDim2.fromOffset(36, 36),
})
pcall(function() Window:SetCornerRadius(8) end)
pcall(function() PulsarLoaderComplete() end)
pcall(function() LockGui.Enabled = true end)

-- ПОИСК: квадратик 36x36 с лупой рядом с кнопкой перетаскивания панели, при клике разворачивается в строку
local SearchCollapseSize = UDim2.fromOffset(36, 36)
task.spawn(function()
    local root = (gethui and gethui()) or game:GetService("CoreGui")
    local searchBox
    for _ = 1, 60 do
        for _, d in ipairs(root:GetDescendants()) do
            if d:IsA("TextBox") and d.PlaceholderText == "Search" then
                searchBox = d
                break
            end
        end
        if searchBox then break end
        task.wait(0.1)
    end
    if not searchBox then return end
    pcall(function()
        local topBar = searchBox.Parent and searchBox.Parent.Parent
        if topBar and topBar:IsA("GuiObject") then
            searchBox.Parent = topBar
            searchBox.AnchorPoint = Vector2.new(1, 0.5)
            searchBox.Position = UDim2.new(1, -44, 0.5, 0)
            searchBox.ZIndex = 3
        end
    end)
    searchBox.PlaceholderText = ""
    Library:GiveSignal(searchBox.Focused:Connect(function()
        searchBox.PlaceholderText = "Search"
        pcall(function()
            TweenService:Create(searchBox, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(220, 36),
            }):Play()
        end)
    end))
    Library:GiveSignal(searchBox.FocusLost:Connect(function()
        searchBox.Text = ""
        searchBox.PlaceholderText = ""
        pcall(function()
            TweenService:Create(searchBox, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = SearchCollapseSize,
            }):Play()
        end)
    end))
end)

-- ПЕРЕКЛЮЧАТЕЛИ: квадратные чекбоксы без ползунка, при включении загораются цветом панели
task.spawn(function()
    local root = (gethui and gethui()) or game:GetService("CoreGui")
    local function FindSwitchParts(d)
        if not d:IsA("Frame") then return nil end
        if d.Size.X.Offset ~= 32 or d.Size.Y.Offset ~= 18 then return nil end
        local corner = d:FindFirstChildOfClass("UICorner")
        local stroke = d:FindFirstChildOfClass("UIStroke")
        if not corner or not stroke then return nil end
        for _, ch in ipairs(d:GetChildren()) do
            if ch:IsA("Frame") and ch.SizeConstraint == Enum.SizeConstraint.RelativeYY and ch:FindFirstChildOfClass("UICorner") then
                return { Frame = d, Corner = corner, Ball = ch }
            end
        end
        return nil
    end
    local function SquareSwitch(sw)
        sw.Frame:SetAttribute("PulsarSquare", true)
        sw.Ball.Visible = false
        sw.Corner.CornerRadius = UDim.new(0, 0)
        sw.Frame.Size = UDim2.fromOffset(18, 18)
    end
    pcall(function()
        Library:GiveSignal(root.DescendantAdded:Connect(function(d)
            task.defer(function()
                local sw = FindSwitchParts(d)
                if sw and not sw.Frame:GetAttribute("PulsarSquare") then
                    SquareSwitch(sw)
                end
            end)
        end))
    end)
    local emptyPasses = 0
    for _ = 1, 40 do
        local processed = 0
        for _, d in ipairs(root:GetDescendants()) do
            local sw = FindSwitchParts(d)
            if sw and not sw.Frame:GetAttribute("PulsarSquare") then
                SquareSwitch(sw)
                processed = processed + 1
            end
        end
        if processed == 0 then
            emptyPasses = emptyPasses + 1
            if emptyPasses >= 3 then break end
        else
            emptyPasses = 0
        end
        task.wait(0.3)
    end
end)

local Tabs = {
    { Name = "Home",         Icon = "house" },
    { Name = "Player",       Icon = "user" },
    { Name = "Combat",       Icon = "sword" },
    { Name = "Invincibility", Icon = "shield" },
    { Name = "Target",       Icon = "target" },
    { Name = "Blobman",      Icon = "ghost" },
    { Name = "Toys",         Icon = "blocks" },
    { Name = "Visual",       Icon = "eye" },
    { Name = "Music",        Icon = "music" },
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
HotkeyGroup:AddLabel("Клавиша M — открыть/закрыть меню (на телефоне — экранные кнопки)")

local StatsGroup = TabObjects["Home"]:AddRightGroupbox("Статистика")
StatsGroup:AddLabel("Вкладок: 13")
StatsGroup:AddLabel("Шейдеров: 15")
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
    ["Синтвейв"] = {
        Lighting = { Brightness=2.3, ClockTime=18.3, FogEnd=3500, FogStart=0, FogColor=Color3.fromRGB(180,80,200), ExposureCompensation=0.15, ShadowSoftness=0.3, Ambient=Color3.fromRGB(90,40,120), ColorShift_Bottom=Color3.fromRGB(70,0,95), ColorShift_Top=Color3.fromRGB(255,110,230), OutdoorAmbient=Color3.fromRGB(150,60,140) },
        Bloom={Intensity=0.9,Threshold=0.75,Size=60},
        ColorCorrection={Saturation=0.35,Contrast=0.25,TintColor=Color3.fromRGB(255,205,255)},
        SunRays={Intensity=0.12,Spread=0.7},
        Atmosphere={Density=0.35,Offset=0.15,Haze=2.0,Glare=0.3,Color=Color3.fromRGB(255,150,220),Decay=Color3.fromRGB(140,60,150)},
    },
    ["Cotton Candy"] = {
        Lighting = { Brightness=2.1, ClockTime=14.2, FogEnd=8000, ExposureCompensation=0.05, ShadowSoftness=0.5, Ambient=Color3.fromRGB(120,105,130), OutdoorAmbient=Color3.fromRGB(180,170,200), ColorShift_Bottom=Color3.fromRGB(170,200,255), ColorShift_Top=Color3.fromRGB(255,170,220) },
        Bloom={Intensity=0.6,Threshold=0.72,Size=55},
        ColorCorrection={Brightness=0.03,Saturation=0.3,Contrast=0.15,TintColor=Color3.fromRGB(255,225,245)},
        SunRays={Intensity=0.08,Spread=0.7},
        Atmosphere={Density=0.2,Offset=0.15,Haze=1.2,Glare=0.2,Color=Color3.fromRGB(255,200,235),Decay=Color3.fromRGB(180,150,200)},
    },
    ["Pastel Sky"] = {
        Lighting = { Brightness=2.3, ClockTime=12, FogEnd=4000, FogColor=Color3.fromRGB(220,225,240), ExposureCompensation=0.03, ShadowSoftness=0.55, Ambient=Color3.fromRGB(90,90,100), OutdoorAmbient=Color3.fromRGB(160,160,175) },
        Bloom={Intensity=0.35,Threshold=0.85,Size=40},
        ColorCorrection={Brightness=0.04,Saturation=-0.08,Contrast=0.1,TintColor=Color3.fromRGB(245,242,255)},
        SunRays={Intensity=0.1,Spread=0.7},
        Atmosphere={Density=0.28,Offset=0.15,Haze=1.1,Glare=0.18,Color=Color3.fromRGB(225,225,245),Decay=Color3.fromRGB(150,155,180)},
    },
    ["Cherry Blossom"] = {
        Lighting = { Brightness=2.15, ClockTime=15.3, FogEnd=7000, ExposureCompensation=0.06, ShadowSoftness=0.5, Ambient=Color3.fromRGB(95,65,80), OutdoorAmbient=Color3.fromRGB(185,150,165), ColorShift_Top=Color3.fromRGB(255,190,210) },
        Bloom={Intensity=0.55,Threshold=0.75,Size=50},
        ColorCorrection={Brightness=0.03,Saturation=0.22,Contrast=0.12,TintColor=Color3.fromRGB(255,222,232)},
        SunRays={Intensity=0.12,Spread=0.75},
        Atmosphere={Density=0.24,Offset=0.15,Haze=1.3,Glare=0.22,Color=Color3.fromRGB(255,205,225),Decay=Color3.fromRGB(190,140,160)},
    },
    ["Amber Dusk"] = {
        Lighting = { Brightness=1.95, ClockTime=17.6, FogEnd=7000, ExposureCompensation=0.02, ShadowSoftness=0.65, Ambient=Color3.fromRGB(80,68,52), OutdoorAmbient=Color3.fromRGB(160,140,115), ColorShift_Top=Color3.fromRGB(255,200,120) },
        Bloom={Intensity=0.55,Threshold=0.78,Size=48},
        ColorCorrection={Brightness=0.02,Saturation=0.2,Contrast=0.3,TintColor=Color3.fromRGB(255,212,160)},
        SunRays={Intensity=0.16,Spread=0.85},
        Atmosphere={Density=0.3,Offset=0.15,Haze=1.5,Glare=0.3,Color=Color3.fromRGB(255,215,160),Decay=Color3.fromRGB(160,125,90)},
    },
    ["Lavender Fields"] = {
        Lighting = { Brightness=1.9, ClockTime=19, FogEnd=6000, FogColor=Color3.fromRGB(170,150,200), ExposureCompensation=0.04, ShadowSoftness=0.6, Ambient=Color3.fromRGB(75,65,100), OutdoorAmbient=Color3.fromRGB(140,125,170), ColorShift_Top=Color3.fromRGB(205,165,255) },
        Bloom={Intensity=0.6,Threshold=0.74,Size=52},
        ColorCorrection={Brightness=0.03,Saturation=0.2,Contrast=0.18,TintColor=Color3.fromRGB(232,218,255)},
        SunRays={Intensity=0.1,Spread=0.75},
        Atmosphere={Density=0.3,Offset=0.15,Haze=1.5,Glare=0.25,Color=Color3.fromRGB(215,195,255),Decay=Color3.fromRGB(140,110,180)},
    },
    ["Inferno"] = {
        Lighting = { Brightness=2.15, ClockTime=18.8, FogEnd=2500, FogStart=0, FogColor=Color3.fromRGB(160,65,30), ExposureCompensation=0.04, ShadowSoftness=0.5, Ambient=Color3.fromRGB(95,50,30), OutdoorAmbient=Color3.fromRGB(160,95,60), ColorShift_Bottom=Color3.fromRGB(70,20,10), ColorShift_Top=Color3.fromRGB(255,95,35) },
        Bloom={Intensity=0.8,Threshold=0.68,Size=58},
        ColorCorrection={Brightness=0.02,Saturation=0.4,Contrast=0.35,TintColor=Color3.fromRGB(255,185,130)},
        SunRays={Intensity=0.25,Spread=0.9},
        Atmosphere={Density=0.35,Offset=0.18,Haze=1.8,Glare=0.35,Color=Color3.fromRGB(255,150,90),Decay=Color3.fromRGB(140,60,35)},
    },
    ["Rose Twilight"] = {
        Lighting = { Brightness=1.85, ClockTime=19.4, FogEnd=6500, ExposureCompensation=0.05, ShadowSoftness=0.65, Ambient=Color3.fromRGB(85,60,75), OutdoorAmbient=Color3.fromRGB(150,120,135), ColorShift_Top=Color3.fromRGB(255,150,175) },
        Bloom={Intensity=0.65,Threshold=0.73,Size=54},
        ColorCorrection={Brightness=0.03,Saturation=0.22,Contrast=0.2,TintColor=Color3.fromRGB(255,205,220)},
        SunRays={Intensity=0.12,Spread=0.8},
        Atmosphere={Density=0.32,Offset=0.15,Haze=1.6,Glare=0.28,Color=Color3.fromRGB(255,185,210),Decay=Color3.fromRGB(150,100,125)},
    },
    ["Moonlight Silver"] = {
        Lighting = { Brightness=1.6, ClockTime=0.2, FogEnd=12000, ExposureCompensation=0.06, ShadowSoftness=0.7, Ambient=Color3.fromRGB(58,63,75), OutdoorAmbient=Color3.fromRGB(125,135,155) },
        Bloom={Intensity=0.6,Threshold=0.72,Size=48},
        ColorCorrection={Brightness=0.02,Saturation=-0.2,Contrast=0.25,TintColor=Color3.fromRGB(226,233,255)},
        SunRays={Intensity=0.05,Spread=0.65},
        Atmosphere={Density=0.3,Offset=0.15,Haze=1.2,Glare=0.2,Color=Color3.fromRGB(210,220,250),Decay=Color3.fromRGB(120,135,170)},
    },
    ["Toxic Zone"] = {
        Lighting = { Brightness=1.6, ClockTime=2, FogEnd=3000, FogColor=Color3.fromRGB(95,125,70), ExposureCompensation=0.03, ShadowSoftness=0.6, Ambient=Color3.fromRGB(45,65,40), OutdoorAmbient=Color3.fromRGB(95,125,85), ColorShift_Bottom=Color3.fromRGB(30,55,25), ColorShift_Top=Color3.fromRGB(150,255,70) },
        Bloom={Intensity=0.75,Threshold=0.66,Size=55},
        ColorCorrection={Brightness=0.01,Saturation=0.35,Contrast=0.35,TintColor=Color3.fromRGB(226,255,215)},
        SunRays={Intensity=0.06,Spread=0.7},
        Atmosphere={Density=0.4,Offset=0.18,Haze=2.0,Glare=0.25,Color=Color3.fromRGB(160,255,110),Decay=Color3.fromRGB(85,130,60)},
    },
}

local ShaderOrder = { "Scarlet Atmosphere", "Golden Hour", "Night", "Dreamy", "Colorful", "Синтвейв", "Cotton Candy", "Pastel Sky", "Cherry Blossom", "Amber Dusk", "Lavender Fields", "Inferno", "Rose Twilight", "Moonlight Silver", "Toxic Zone" }

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
    if shaderName == "Синтвейв" then
        local swSky = Instance.new("Sky", Lighting)
        swSky.Name = "SavitarSynthSky"
        swSky.SkyboxUp = "rbxassetid://323493360"
        swSky.SkyboxLf = "rbxassetid://323494252"
        swSky.SkyboxBk = "rbxassetid://323494035"
        swSky.SkyboxFt = "rbxassetid://323494130"
        swSky.SkyboxDn = "rbxassetid://323494368"
        swSky.SkyboxRt = "rbxassetid://323494067"
        swSky.SunAngularSize = 30
        swSky.StarCount = 1500
        ActiveEffects[#ActiveEffects+1] = swSky
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
-- ЗВУКОВЫЙ СЕРВИС (используется Mute-категориями ниже)
-- =====================================================================
local SoundService = game:GetService("SoundService")

local PulsarSoundMuteOff
local GfxUnload
local PulsarMusicStop

local function VisualsCleanup()
    if PulsarSoundMuteOff then pcall(PulsarSoundMuteOff) end
    RemoveShader()
    if GfxUnload then pcall(GfxUnload) end
    if PulsarMusicStop then pcall(PulsarMusicStop) end
    Updaters = {}
    if VisualHeartbeat then
        VisualHeartbeat:Disconnect()
        VisualHeartbeat = nil
    end
    pcall(function()
        LockGui:Destroy()
        loaderGui:Destroy()
    end)
end

pcall(function()
    Library:OnUnload(VisualsCleanup)
end)

-- =====================================================================
-- ВКЛАДКА MUSIC — плеер с сохранёнными треками (публичные аудио Roblox)
-- =====================================================================
local MusicTracks = {
    ["TOMA FUNK PHONK"] = 129098116998483,
    ["AURA = ∞ (Brazilian Phonk)"] = 95131770144654,
    ["ROBLOX PHONK"] = 136932193331774,
    ["FUNK FESTA"] = 103409297553965,
    ["67 KID PHONK"] = 125476440612900,
    ["DRIFT NIGHT PHONK (Car Motion Edit)"] = 85735197482652,
    ["Rat Dance Phonk"] = 119598380829349,
    ["Lost Phonk"] = 139266399633943,
    ["Noisestorm - Crab Rave"] = 5410086218,
    ["LIKE THE MOONLIGHT (Funky House Mix)"] = 111560286322896,
    ["sad violin"] = 135308045,
    ["Funky Stepper"] = 1835422714,
    ["Terranova"] = 1835422879,
    ["Russian Run"] = 1836175982,
    ["Russian Sorrow"] = 1836176147,
    ["Russian Celebration"] = 1836732530,
    ["Tokyo Drift"] = 1837015626,
    ["Paradise Falls"] = 1837879082,
    ["Clair De Lune"] = 1838457617,
    ["Russian Folk Dance"] = 1840183276,
    ["Soviet March"] = 1841140365,
    ["Life in an Elevator"] = 1841647093,
    ["Believer"] = 1845016505,
    ["Montage No. 19"] = 1845091827,
    ["Schweben Im Raum"] = 1845728301,
    ["Town Talk"] = 1845756489,
    ["National Anthem Of China B"] = 1845918434,
    ["Kalinka"] = 1845924062,
    ["Morning Mood (peer Gynt Suite No.1)"] = 1846088038,
    ["Wake Up"] = 1846293018,
    ["The Nutcracker (D) Russian Dance"] = 1846627685,
    ["Nutcracker Suite Op.71a, The @ Russian Dance"] = 1848059091,
    ["Horror"] = 9039981149,
    ["State Anthem of the Russian Federation (a)"] = 9040163991,
    ["State Anthem of the Russian Federation (b 60)"] = 9040168257,
    ["Just a Russian Waltz - No intro"] = 9044560194,
    ["Phonk Vol. 2 - The Final Phonk"] = 14145620056,
    ["PHONK DRIFT"] = 72653741821355,
    ["alone"] = 75485931767123,
    ["SHADOW PHONK BRAZIL (Dark Atmosphere Edit)"] = 77701977147898,
    ["Wheel"] = 87871612084824,
    ["Miguel Phonk"] = 92299938059573,
    ["Bao Bao"] = 95796504549340,
    ["ELECTRIC PHANTOM (Phonk)"] = 103415930328599,
    ["Rogue City Phonk"] = 111109407506851,
    ["Tung Tung Tung Sahur Phonk"] = 128438366056581,
    ["TIKI TIKI FUNK (Sped Up)"] = 128510578554487,
    ["Phonk Roblox Meme"] = 135209837340816,
    ["Blood on the Asphalt"] = 140439256760765,
    ["Football Edit – Phonk Trap"] = 140504265985079,
    ["Voltstorm (Overload Phonk Energy)"] = 140580823167015,
    ["Desprezo, (Aggressive Phonk), Slowed + Reverb"] = 140667339171815,
    ["HYDERABADI PHONK (MARFA STYLE)"] = 140691985128867,
}

local MusicPlayer = { Sound = nil, Track = nil, Volume = 50, Paused = false }
local MusicPlayBtn = nil
local MusicPlay = nil

local function SetPlayBtnText(text)
    if MusicPlayBtn then
        pcall(function() MusicPlayBtn:SetText(text) end)
    end
end

local function MusicStop()
    if MusicPlayer.Sound then
        pcall(function() MusicPlayer.Sound:Stop() end)
        pcall(function() MusicPlayer.Sound:Destroy() end)
        MusicPlayer.Sound = nil
    end
    MusicPlayer.Paused = false
    SetPlayBtnText("▶")
end
PulsarMusicStop = MusicStop

local function MusicTogglePlay()
    local s = MusicPlayer.Sound
    if s then
        if MusicPlayer.Paused then
            pcall(function() s:Resume() end)
            MusicPlayer.Paused = false
            SetPlayBtnText("| |")
        else
            pcall(function() s:Pause() end)
            MusicPlayer.Paused = true
            SetPlayBtnText("▶")
        end
        return
    end
    MusicPlay()
end

local function MusicSkip(dir)
    local order = {}
    for name in pairs(MusicTracks) do
        order[#order + 1] = name
    end
    if #order == 0 then
        Library:Notify("Плейлист пуст — треки добавим позже")
        return
    end
    table.sort(order)
    local idx = 1
    for i, name in ipairs(order) do
        if name == MusicPlayer.Track then idx = i break end
    end
    idx = ((idx - 1 + dir) % #order) + 1
    MusicPlayer.Track = order[idx]
    MusicPlay()
end

function MusicPlay()
    MusicStop()
    local id = MusicTracks[MusicPlayer.Track]
    if not id then
        Library:Notify("Плейлист пуст — треки добавим позже")
        return
    end
    local s = Instance.new("Sound")
    s.Name = "PulsarMusic"
    s.SoundId = "rbxassetid://" .. id
    s.Volume = MusicPlayer.Volume / 50
    s.Parent = SoundService
    local t0 = os.clock()
    while not s.IsLoaded and os.clock() - t0 < 5 do
        task.wait(0.1)
    end
    if not s.IsLoaded or s.TimeLength == 0 then
        pcall(function() s:Destroy() end)
        Library:Notify("Трек не загрузился (ограничение Roblox)")
        return
    end
    MusicPlayer.Sound = s
    MusicPlayer.Paused = false
    s:Play()
    SetPlayBtnText("| |")
end

local MusicGroup = TabObjects["Music"]:AddLeftGroupbox("Плеер")

local MusicOrder = {}
for name in pairs(MusicTracks) do
    MusicOrder[#MusicOrder + 1] = name
end
table.sort(MusicOrder)

MusicGroup:AddDropdown("PulsarMusicTrack", {
    Values = MusicOrder,
    Multi = false,
    AllowNull = true,
    Searchable = true,
    Text = "Трек",
    Callback = function(value)
        if type(value) ~= "string" or not MusicTracks[value] then return end
        MusicPlayer.Track = value
        MusicPlay()
    end,
})

MusicGroup:AddSlider("PulsarMusicVolume", {
    Text = "Громкость (%)",
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Callback = function(v)
        MusicPlayer.Volume = v
        if MusicPlayer.Sound then
            pcall(function() MusicPlayer.Sound.Volume = v / 50 end)
        end
    end,
})

local PlayBtn = MusicGroup:AddButton({ Text = "▶", Func = MusicTogglePlay })
MusicPlayBtn = PlayBtn
local PrevBtn = PlayBtn:AddButton({ Text = "<<", Func = function() MusicSkip(-1) end })
local NextBtn = PlayBtn:AddButton({ Text = ">>", Func = function() MusicSkip(1) end })

PrevBtn.Base.LayoutOrder = 0
PlayBtn.Base.LayoutOrder = 1
NextBtn.Base.LayoutOrder = 2

for _, btn in ipairs({ PlayBtn, PrevBtn, NextBtn }) do
    pcall(function()
        btn.Base.BackgroundColor3 = Library.Scheme.BackgroundColor
        btn.Label.TextColor3 = Color3.new(1, 1, 1)
        btn.Label.TextTransparency = 0
    end)
end

-- =====================================================================
-- ВКЛАДКА VISUAL (управление через Obsidian)
-- =====================================================================
local VisualTab = TabObjects["Visual"]

-- SHADERS (верх вкладки Visual)
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
-- ЗВУКИ (правая колонка вкладки Visual) — категории Mute
-- =====================================================================
local SoundMuteCatGroup = VisualTab:AddRightGroupbox("Звуки")
local MuteSoundConn = nil
local MutedOriginals = {}

local function TryMuteSound(obj, cat)
    local current = obj.SoundGroup
    if current and string.find(current.Name, "PulsarMute", 1, true) then
        return
    end
    if MutedOriginals[obj] ~= nil then
        return
    end
    MutedOriginals[obj] = current or false
    obj.SoundGroup = cat.Group
end

local function RestoreSound(obj)
    local prev = MutedOriginals[obj]
    if prev == nil then return end
    MutedOriginals[obj] = nil
    pcall(function()
        if prev ~= false then
            obj.SoundGroup = prev
        else
            obj.SoundGroup = nil
        end
    end)
end

local SoundCategories = {
    { Name = "Ambience",     Text = "Mute Ambience",              Patterns = { "ambien", "wind", "birds", "bird", "nature", "crowd", "city", "forest", "ocean", "rain" } },
    { Name = "Boombox",      Text = "Mute Boomboxes & Jukeboxes", Patterns = { "boombox", "jukebox", "radio", "speaker", "stereo", "music", "cassette", "tape", "gramophone" } },
    { Name = "Screams",      Text = "Mute Screams",               Patterns = { "scream", "yell", "shout", "panic", "horror", "crying", "squeal" } },
    { Name = "Explosions",   Text = "Mute Explosions",            Patterns = { "explos", "blast", "grenade", "bomb", "rocket", "cannon", "firework", "gunshot", "shot", "bang" } },
    { Name = "Soundwaves",   Text = "Mute Soundwaves",            Patterns = { "soundwave", "sound wave", "siren", "alarm", "airhorn", "megaphone" } },
    { Name = "RhythmMakers", Text = "Mute Rhythm Makers",         Patterns = { "rhythm", "beatbox", "metronome", "melody", "tempo", "beat" } },
    { Name = "Instruments",  Text = "Mute Instruments",           Patterns = { "instrument", "piano", "drum", "guitar", "trumpet", "flute", "violin", "sax", "banjo", "harp", "xylophone", "accordion", "chime" } },
    { Name = "Ragdoll",      Text = "Mute Ragdoll Sounds",        Patterns = { "ragdoll", "bodyfall", "thud", "splat", "bonk" } },
}

local function MatchesPatterns(sound, patterns)
    local node = sound
    local names = {}
    while node and node ~= game do
        names[#names + 1] = string.lower(node.Name)
        node = node.Parent
    end
    for _, pattern in ipairs(patterns) do
        for _, name in ipairs(names) do
            if string.find(name, pattern, 1, true) then return true end
        end
    end
    return false
end

local function UninstallGroup(group)
    if not group then return end
    pcall(function()
        for obj, _prev in pairs(MutedOriginals) do
            if not obj.Parent or not obj:IsA("Sound") then
                MutedOriginals[obj] = nil
            elseif obj.SoundGroup == group then
                RestoreSound(obj)
            end
        end
    end)
    pcall(function() group:Destroy() end)
end

local MuteScanRunning = false

local function MuteScanOnce()
    pcall(function()
        for obj in pairs(MutedOriginals) do
            if typeof(obj) ~= "Instance" or not obj.Parent then
                MutedOriginals[obj] = nil
            end
        end
    end)
    local t0 = os.clock()
    pcall(function()
        for _, obj in ipairs(game:GetDescendants()) do
            if obj:IsA("Sound") then
                for _, cat2 in ipairs(SoundCategories) do
                    if cat2.Group and MatchesPatterns(obj, cat2.Patterns) then
                        TryMuteSound(obj, cat2)
                    end
                end
            end
            if os.clock() - t0 > 0.15 then
                task.wait()
                t0 = os.clock()
            end
        end
    end)
end

local function UpdateMuteWatcher()
    local anyActive = false
    for _, cat in ipairs(SoundCategories) do
        if cat.Group then anyActive = true break end
    end
    if anyActive and not MuteScanRunning then
        MuteScanRunning = true
        task.spawn(function()
            while true do
                task.wait(3)
                local any = false
                for _, c in ipairs(SoundCategories) do
                    if c.Group then any = true break end
                end
                if not any then break end
                MuteScanOnce()
            end
            MuteScanRunning = false
        end)
    end
    if anyActive and not MuteSoundConn then
        MuteSoundConn = game.DescendantAdded:Connect(function(obj)
            if not obj:IsA("Sound") then return end
            task.defer(function()
                for _, cat2 in ipairs(SoundCategories) do
                    pcall(function()
                        if cat2.Group and MatchesPatterns(obj, cat2.Patterns) then
                            TryMuteSound(obj, cat2)
                        end
                    end)
                end
            end)
        end)
        task.defer(MuteScanOnce)
    elseif not anyActive and MuteSoundConn then
        MuteSoundConn:Disconnect()
        MuteSoundConn = nil
    end
end

PulsarSoundMuteOff = function()
    for _, cat in ipairs(SoundCategories) do
        UninstallGroup(cat.Group)
        cat.Group = nil
    end
    if MuteSoundConn then
        MuteSoundConn:Disconnect()
        MuteSoundConn = nil
    end
end

for _, cat in ipairs(SoundCategories) do
    cat.Group = nil
    SoundMuteCatGroup:AddToggle("PulsarMute_" .. cat.Name, {
        Text = cat.Text,
        Default = false,
        Callback = function(on)
            if on then
                if not cat.Group then
                    cat.Group = Instance.new("SoundGroup")
                    cat.Group.Name = "PulsarMute_" .. cat.Name
                    cat.Group.Volume = 0
                    cat.Group.Parent = SoundService
                end
                local group = cat.Group
                pcall(function()
                    for _, obj in ipairs(game:GetDescendants()) do
                        if obj:IsA("Sound") and MatchesPatterns(obj, cat.Patterns) then
                            TryMuteSound(obj, cat)
                        end
                    end
                end)
                UpdateMuteWatcher()
            else
                UninstallGroup(cat.Group)
                cat.Group = nil
                UpdateMuteWatcher()
            end
        end,
    })
end

-- =====================================================================
-- VISUAL — GRAPHICS (скопировано с Resonance 2.9 — окно Graphics вкладки Visual)
-- =====================================================================
do

    local GfxWaterTimeSlice = 0.1

    local GfxState = {
        RuntimeConnections = {},
        ParticleSettings = {
            Enabled = false,
            BoxSize = 500,
            Texture = "rbxassetid://5857892330",
            Color = Color3.fromRGB(255, 255, 255),
            Transparency = 0,
            ParticleSize = 1,
            Count = 2500,
            SpeedMin = 0.5,
            SpeedMax = 2,
            LifeTime = 10,
        },
    }

    local function GfxQueryDescendants(inst, classNames)
        if not inst then return {} end
        local ok, result = pcall(function() return inst:QueryDescendants(classNames) end)
        if ok and type(result) == "table" then
            return result
        end
        local wanted = {}
        for cls in string.gmatch(classNames or "", "[^,%s]+") do
            wanted[cls] = true
        end
        local list = {}
        pcall(function()
            for _, obj in ipairs(inst:GetDescendants()) do
                if wanted[obj.ClassName] then
                    list[#list + 1] = obj
                end
            end
        end)
        return list
    end

    local function GfxSetConn(name, event, enabled, fn)
        local existing = GfxState.RuntimeConnections[name]

        if not enabled then
            if existing then
                pcall(function() existing:Disconnect() end)
            end
            GfxState.RuntimeConnections[name] = nil
            return
        end

        if existing and existing.Connected then
            return
        end
        GfxState.RuntimeConnections[name] = event:Connect(fn)
    end

    local GfxPart = Instance.new("Part")
    pcall(function()
        GfxPart.Name = "partcieslyes"
        GfxPart.Transparency = 1
        GfxPart.CanCollide = false
        GfxPart.CanQuery = false
        GfxPart.CanTouch = false
        GfxPart.Anchored = true
        GfxPart.Parent = workspace
    end)

    local GfxEmitter = Instance.new("ParticleEmitter")
    pcall(function()
        GfxEmitter.Enabled = false
        GfxEmitter.Shape = Enum.ParticleEmitterShape.Box
        GfxEmitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
        GfxEmitter.LightEmission = 0
        GfxEmitter.LightInfluence = 0
        GfxEmitter.ZOffset = 0
        GfxEmitter.Parent = GfxPart
    end)

    local function GfxUpdateParticles(prop)
        local settings = GfxState.ParticleSettings
        local all = not prop

        pcall(function()
            if all or prop == "BoxSize" then
                GfxPart.Size = Vector3.one * settings.BoxSize
            end
            if all or prop == "Texture" then
                GfxEmitter.Texture = settings.Texture
            end
            if all or prop == "Count" then
                GfxEmitter.Rate = settings.Count
            end
            if all or prop == "LifeTime" then
                GfxEmitter.Lifetime = NumberRange.new(settings.LifeTime)
            end
            if all or prop == "SpeedMin" or prop == "SpeedMax" then
                GfxEmitter.Speed = NumberRange.new(settings.SpeedMin, settings.SpeedMax)
            end
            if all or prop == "Color" then
                GfxEmitter.Color = ColorSequence.new(settings.Color)
            end
            if all or prop == "ParticleSize" then
                GfxEmitter.Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(0.1, settings.ParticleSize),
                    NumberSequenceKeypoint.new(0.9, settings.ParticleSize),
                    NumberSequenceKeypoint.new(1, 0),
                })
            end
            if all or prop == "Transparency" then
                GfxEmitter.Transparency = NumberSequence.new(settings.Transparency)
            end
        end)
    end

    local function GfxUpdateParticlePosition()
        local camera = workspace.CurrentCamera
        if camera then
            pcall(function() GfxPart.CFrame = camera.CFrame end)
        end
    end

    local function GfxSetParticlesEnabled(enabled)
        GfxState.ParticleSettings.Enabled = enabled
        pcall(function()
            local camera = workspace.CurrentCamera
            GfxSetConn("Particles", camera:GetPropertyChangedSignal("CFrame"), enabled, GfxUpdateParticlePosition)
        end)
        pcall(function() GfxEmitter.Enabled = enabled end)

        if enabled then
            GfxUpdateParticles()
            GfxUpdateParticlePosition()
        else
            pcall(function() GfxEmitter:Clear() end)
        end
    end

    local function GfxSetParticleProp(prop, value)
        GfxState.ParticleSettings[prop] = value
        if GfxState.ParticleSettings.Enabled then
            GfxUpdateParticles(prop)
        end
    end

    local GfxBoost = {
        Revert = {},
        Active = false,
        Applied = false,
        Busy = false,
        Stale = false,
        Options = { Materials = true, Textures = true, Reflections = true, Shadows = true },
    }

    local function GfxSetProp(inst, prop, value)
        local original
        pcall(function() original = inst[prop] end)
        if original == value then
            return
        end

        local ok = pcall(function()
            inst[prop] = value
        end)
        if not ok then
            return
        end

        local slot = GfxBoost.Revert[inst]
        if not slot then
            slot = {}
            GfxBoost.Revert[inst] = slot
        end
        if not slot[prop] then
            slot[prop] = { original, value }
        end
    end

    local function GfxBoostApply(inst)
        if not GfxBoost.Active then
            return
        end
        local opts = GfxBoost.Options

        if inst:IsA("BasePart") and not inst:IsA("Terrain") then
            if opts.Materials and inst.Material ~= Enum.Material.ForceField then
                GfxSetProp(inst, "Material", Enum.Material.SmoothPlastic)
                GfxSetProp(inst, "MaterialVariant", "")
            end
            if opts.Reflections then
                GfxSetProp(inst, "Reflectance", 0)
            end
            if opts.Shadows then
                GfxSetProp(inst, "CastShadow", false)
            end
            if opts.Textures and inst:IsA("MeshPart") then
                GfxSetProp(inst, "TextureID", "")
            end
        elseif opts.Textures and (inst:IsA("Decal") or inst:IsA("Texture")) then
            GfxSetProp(inst, "Transparency", 1)
        elseif opts.Textures and inst:IsA("SpecialMesh") then
            GfxSetProp(inst, "TextureId", "")
        end
    end

    local function GfxSetBoostFPS(enabled)
        GfxBoost.Active = enabled and not Library.Unloaded

        local skip
        if GfxBoost.Busy then
            skip = GfxBoost.Busy
        else
            skip = (GfxBoost.Active == GfxBoost.Applied) and not GfxBoost.Stale
        end
        if skip then
            return
        end
        GfxBoost.Busy = true

        task.spawn(function()
            while true do
                local now = os.clock()

                if GfxBoost.Active and not GfxBoost.Applied then
                    GfxBoost.Applied = true
                    GfxBoost.Stale = false

                    if GfxBoost.Options.Shadows then
                        GfxSetProp(Lighting, "GlobalShadows", false)
                    end

                    GfxSetConn("BoostFPSAdded", workspace.DescendantAdded, true, function(desc)
                        pcall(GfxBoostApply, desc)
                    end)

                    for _, desc in ipairs(GfxQueryDescendants(workspace, "BasePart, Decal, Texture, SpecialMesh")) do
                        if GfxBoost.Active then
                            pcall(GfxBoostApply, desc)
                            if os.clock() - now > GfxWaterTimeSlice then
                                task.wait()
                                now = os.clock()
                            end
                        else
                            break
                        end
                    end
                else
                    GfxSetConn("BoostFPSAdded", nil, false)

                    for inst, props in pairs(GfxBoost.Revert) do
                        if inst.Parent then
                            for prop, entry in pairs(props) do
                                local ok, current = pcall(function() return inst[prop] end)
                                if ok and current == entry[2] then
                                    pcall(function()
                                        inst[prop] = entry[1]
                                    end)
                                end
                            end
                        end

                        if not Library.Unloaded and os.clock() - now > GfxWaterTimeSlice then
                            task.wait()
                            now = os.clock()
                        end
                    end

                    table.clear(GfxBoost.Revert)
                    GfxBoost.Applied = false

                    if not GfxBoost.Active then
                        GfxBoost.Stale = false
                    end
                end

                if not (GfxBoost.Active == GfxBoost.Applied and not GfxBoost.Stale) then
                    continue
                end
                break
            end

            GfxBoost.Busy = false
        end)
    end

    local function GfxSetBoostFPSOptions(selected)
        if type(selected) ~= "table" then
            selected = {}
        end
        GfxBoost.Options = selected
        GfxBoost.Stale = GfxBoost.Active
        GfxSetBoostFPS(GfxBoost.Active)
    end

    local Graphics
    local okGraphics = pcall(function()
        Graphics = VisualTab:AddLeftGroupbox("Graphics", "file-image")
    end)
    if not okGraphics or not Graphics then
        Graphics = VisualTab:AddLeftGroupbox("Graphics")
    end

    local function GfxDivider(name)
        local ok = false
        pcall(function()
            Graphics:AddDivider(name)
            ok = true
        end)
        if not ok then
            pcall(function() Graphics:AddDivider() end)
        end
    end

    local function GfxDepbox(deps)
        local ok, box = pcall(function()
            local b = Graphics:AddDependencyBox()
            b:SetupDependencies(deps)
            return b
        end)
        if ok and box then
            return box
        end
        return nil
    end

    GfxDivider("Particles")

    local ParticlesToggle = Graphics:AddToggle("ParticlesT", {
        Text = "Particles",
        Default = false,
        Callback = GfxSetParticlesEnabled,
    })

    pcall(function()
        ParticlesToggle:AddColorPicker("ParticlesCo", {
            Default = GfxState.ParticleSettings.Color,
            Title = "Color",
            Callback = function(value)
                GfxSetParticleProp("Color", value)
            end,
        })
    end)

    local ParticleTextures = {
        ["Dot"] = "rbxassetid://5857892330",
        ["Sparkles"] = "rbxasset://textures/particles/sparkles_main.dds",
        ["Fire"] = "rbxasset://textures/particles/fire_main.dds",
        ["Smoke"] = "rbxasset://textures/particles/smoke_main.dds",
        ["Sparks"] = "rbxassetid://6711256324",
        ["Star"] = "rbxassetid://6772783963",
        ["Star Small"] = "rbxassetid://5860841663",
        ["Heart"] = "rbxassetid://5857851618",
        ["Diamond"] = "rbxassetid://6772766413",
        ["Leaf"] = "rbxassetid://6703369286",
        ["Paw"] = "rbxassetid://6803084085",
        ["Lightning"] = "rbxassetid://6772766551",
        ["Explosion"] = "rbxassetid://5833235272",
    }
    local ParticleTextureOrder = { "Dot", "Sparkles", "Fire", "Smoke", "Sparks", "Star", "Star Small", "Heart", "Diamond", "Leaf", "Paw", "Lightning", "Explosion" }

    local ParticlesBox = GfxDepbox({ { Library.Options.ParticlesT, true } })

    if not ParticlesBox then
        ParticlesBox = Graphics
    end

    if ParticlesBox then
        ParticlesBox:AddDropdown("ParticlesDropdown", {
            Values = ParticleTextureOrder,
            Multi = false,
            Default = "Dot",
            Searchable = true,
            Text = "Texture",
            Callback = function(value)
                local tex = ParticleTextures[value]
                if tex then
                    GfxSetParticleProp("Texture", tex)
                end
            end,
        })

        ParticlesBox:AddSlider("PDensity", {
            Text = "Density (Count)",
            Default = GfxState.ParticleSettings.Count,
            Min = 100,
            Max = 5000,
            Compact = true,
            Callback = function(value)
                GfxSetParticleProp("Count", value)
            end,
        })

        ParticlesBox:AddSlider("PSize", {
            Text = "Size",
            Default = GfxState.ParticleSettings.ParticleSize,
            Min = 0.1,
            Max = 5,
            Rounding = 1,
            Compact = true,
            Callback = function(value)
                GfxSetParticleProp("ParticleSize", value)
            end,
        })

        ParticlesBox:AddSlider("PMaxSp", {
            Text = "Max Speed",
            Default = GfxState.ParticleSettings.SpeedMax,
            Min = 0,
            Max = 10,
            Rounding = 1,
            Compact = true,
            Callback = function(value)
                GfxSetParticleProp("SpeedMax", value)
            end,
        })

        ParticlesBox:AddSlider("PBoxSize", {
            Text = "Box Size",
            Default = GfxState.ParticleSettings.BoxSize,
            Min = 50,
            Max = 2000,
            Compact = true,
            Callback = function(value)
                GfxSetParticleProp("BoxSize", value)
            end,
        })
    end

    GfxDivider("Boost FPS")

    Graphics:AddToggle("BoostFPS", {
        Text = "Boost FPS",
        Default = false,
        Callback = GfxSetBoostFPS,
    })

    Graphics:AddDropdown("BoostFPSOptions", {
        Text = "Disable",
        Values = { "Materials", "Textures", "Reflections", "Shadows" },
        Default = { "Materials", "Textures", "Reflections", "Shadows" },
        Multi = true,
        AllowNull = true,
        Callback = GfxSetBoostFPSOptions,
    })

    GfxUnload = function()
        pcall(function() GfxSetParticlesEnabled(false) end)
        pcall(function() GfxSetBoostFPS(false) end)
        pcall(function() GfxSetConn("BoostFPSAdded", nil, false) end)
        pcall(function() GfxPart:Destroy() end)
        for _, conn in pairs(GfxState.RuntimeConnections) do
            pcall(function() conn:Disconnect() end)
        end
        table.clear(GfxState.RuntimeConnections)
    end
end

-- =====================================================================
-- ВКЛАДКА PLAYER — пустая (все функции удалены)
-- =====================================================================