local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local function getGuiParent()
    local ok, hui = pcall(function() return gethui and gethui() end)
    if ok and hui then return hui end
    local okCore, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if okCore and coreGui then return coreGui end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local Theme = {
    Main = Color3.fromRGB(0x19, 0x19, 0x19),
    Background = Color3.fromRGB(0x0f, 0x0f, 0x0f),
    Element = Color3.fromRGB(0x19, 0x19, 0x19),
    Accent = Color3.fromRGB(0xff, 0xff, 0xff),
    Text = Color3.fromRGB(0xff, 0xff, 0xff),
    SubText = Color3.fromRGB(0xb0, 0xb0, 0xb0),
    Outline = Color3.fromRGB(0x46, 0x46, 0x46),
    Highlight = Color3.fromRGB(0x24, 0x24, 0x24),
    Font = Enum.Font.Code,
}

local function create(className, props, children)
    local inst = Instance.new(className)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then inst[k] = v end
    end
    if children then
        for _, child in ipairs(children) do child.Parent = inst end
    end
    inst.Parent = props and props.Parent
    return inst
end

local function corner(parent, radius)
    return create("UICorner", { CornerRadius = UDim.new(0, radius or 4), Parent = parent })
end

local function stroke(parent, color)
    return create("UIStroke", { Color = color or Theme.Outline, Thickness = 1, Parent = parent })
end

local function makeMoonAvatar(parent, size)
    local Moon = create("Frame", {
        Size = UDim2.fromOffset(size, size),
        BackgroundColor3 = Color3.fromRGB(26, 26, 30),
        BorderSizePixel = 0,
    }, nil)
    Moon.Parent = parent
    create("UICorner", { CornerRadius = UDim.new(0.5, 0), Parent = Moon })
    create("UIStroke", { Color = Theme.Accent, Thickness = 2, Transparency = 0.1, Parent = Moon })
    local Glow = create("Frame", {
        Size = UDim2.new(1, 6, 1, 6),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Parent = Moon,
    }, nil)
    create("UICorner", { CornerRadius = UDim.new(0.5, 0), Parent = Glow })
    create("UIStroke", { Color = Theme.Accent, Thickness = 1, Transparency = 0.65, Parent = Glow })
    local craters = { { 0.22, 0.30, 0.16 }, { 0.62, 0.20, 0.12 }, { 0.55, 0.62, 0.20 }, { 0.30, 0.68, 0.10 } }
    for _, c in ipairs(craters) do
        local crater = create("Frame", {
            Size = UDim2.fromScale(c[3], c[3]),
            Position = UDim2.fromScale(c[1], c[2]),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(48, 48, 54),
            BorderSizePixel = 0,
            Parent = Moon,
        }, nil)
        create("UICorner", { CornerRadius = UDim.new(0.5, 0), Parent = crater })
    end
    local Letter = create("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "L",
        TextColor3 = Theme.Accent,
        Font = Theme.Font,
        TextScaled = true,
        Parent = Moon,
    }, nil)
    create("UIStroke", { Color = Theme.Accent, Thickness = 1, Transparency = 0.4, Parent = Letter })
    return Moon
end

local function styleObsidian(btn)
    btn.AutoButtonColor = false
    btn.BackgroundColor3 = Theme.Main
    btn.TextColor3 = Theme.Text
    corner(btn, 4)
    create("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = btn })
    create("UIStroke", { Color = Theme.Outline, Thickness = 1, Transparency = 0.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = btn })
    local hoverIn = TweenService:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Theme.Highlight })
    local hoverOut = TweenService:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Theme.Main })
    btn.MouseEnter:Connect(function()
        hoverOut:Cancel()
        hoverIn:Play()
    end)
    btn.MouseLeave:Connect(function()
        hoverIn:Cancel()
        hoverOut:Play()
    end)
end

local function addSwitch(btn, initial)
    local swState = initial and true or false
    local Pill = create("Frame", {
        Size = UDim2.fromOffset(34, 18),
        Position = UDim2.new(1, -10, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = swState and Theme.Accent or Theme.Outline,
        BorderSizePixel = 0,
    }, nil)
    Pill.Parent = btn
    corner(Pill, 9)
    local Knob = create("Frame", {
        Size = UDim2.fromOffset(14, 14),
        Position = swState and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = swState and Color3.fromRGB(15, 15, 15) or Theme.Text,
        BorderSizePixel = 0,
    }, nil)
    Knob.Parent = Pill
    corner(Knob, 7)
    local info = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    return function(state)
        swState = state and true or false
        TweenService:Create(Pill, info, { BackgroundColor3 = swState and Theme.Accent or Theme.Outline }):Play()
        TweenService:Create(Knob, info, {
            Position = swState and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
            BackgroundColor3 = swState and Color3.fromRGB(15, 15, 15) or Theme.Text,
        }):Play()
    end
end

local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local langRU = false
local Translations = {}
local TabRuNames = {
    Home = "Главная",
    Combat = "Бой",
    Invincibility = "Неуязвимость",
    Target = "Цель",
    Blobman = "Блобман",
    Toys = "Игрушки",
    Visual = "Визуал",
    ["Auto-Clicker"] = "Авто-кликер",
    Misc = "Разное",
    Lists = "Списки",
    Settings = "Настройки",
}
local function registerText(obj, en, ru)
    table.insert(Translations, { obj = obj, en = en, ru = ru })
    if langRU then obj.Text = ru end
end
local function applyLanguage()
    for _, t in ipairs(Translations) do
        if t.obj and t.obj.Parent then
            t.obj.Text = langRU and t.ru or t.en
        end
    end
end
local function tr(en, ru)
    return langRU and ru or en
end

local function copyText(text)
    local ok = pcall(function() setclipboard(text) end)
    if not ok then
        pcall(function() toclipboard(text) end)
    end
end

local ScreenGui = create("ScreenGui", {
    Name = "ResonancePanel",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
}, nil)
if not pcall(function() ScreenGui.Parent = getGuiParent() end) then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end
ScreenGui.DisplayOrder = 999

local scaleValue = isMobile() and 0.8 or 1

local MainShadow = create("ImageLabel", {
    Size = UDim2.fromOffset(700 * scaleValue + 40, 400 * scaleValue + 40),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundTransparency = 1,
    Image = "rbxassetid://6014261993",
    ImageColor3 = Color3.fromRGB(0, 0, 0),
    ImageTransparency = 0.45,
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(49, 49, 450, 450),
    Visible = false,
}, nil)
MainShadow.Parent = ScreenGui

local Main = create("Frame", {
    Size = UDim2.fromOffset(700 * scaleValue, 400 * scaleValue),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0,
    Active = true,
    Visible = false,
}, nil)
Main.Parent = ScreenGui
corner(Main, 6)
stroke(Main, Theme.Accent)

Main:GetPropertyChangedSignal("Visible"):Connect(function()
    MainShadow.Visible = Main.Visible
end)
Main:GetPropertyChangedSignal("Position"):Connect(function()
    MainShadow.Position = Main.Position
end)
Main:GetPropertyChangedSignal("Size"):Connect(function()
    MainShadow.Size = UDim2.fromOffset(Main.AbsoluteSize.X + 40, Main.AbsoluteSize.Y + 40)
end)

local TopBar = create("Frame", {
    Size = UDim2.new(1, 0, 0, 34),
    BackgroundColor3 = Theme.Main,
    BorderSizePixel = 0,
}, nil)
TopBar.Parent = Main
corner(TopBar, 6)
create("UIGradient", {
    Color = ColorSequence.new(Color3.fromRGB(0x24, 0x24, 0x24), Color3.fromRGB(0x19, 0x19, 0x19)),
    Rotation = 90,
    Parent = TopBar,
})

local MoonTop = makeMoonAvatar(TopBar, 22)
MoonTop.Position = UDim2.fromOffset(12, 17)
MoonTop.AnchorPoint = Vector2.new(0, 0.5)

local Title = create("TextLabel", {
    Size = UDim2.new(1, -120, 1, 0),
    Position = UDim2.fromOffset(42, 0),
    BackgroundTransparency = 1,
    Text = "(BETA Version) REAPER 2.1",
    TextColor3 = Theme.Text,
    Font = Theme.Font,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
}, nil)
Title.Parent = TopBar
registerText(Title, "(BETA Version) REAPER 2.1", "(БЕТА Версия) REAPER 2.1")

local TabToggleButton = create("TextButton", {
    Size = UDim2.fromOffset(26, 26),
    Position = UDim2.new(1, -64, 0.5, 0),
    AnchorPoint = Vector2.new(0, 0.5),
    BackgroundColor3 = Theme.Element,
    Text = "<",
    TextColor3 = Theme.Text,
    Font = Theme.Font,
    TextSize = 13,
    AutoButtonColor = true,
}, nil)
TabToggleButton.Parent = TopBar
corner(TabToggleButton, 4)

local CloseButton = create("TextButton", {
    Size = UDim2.fromOffset(26, 26),
    Position = UDim2.new(1, -32, 0.5, 0),
    AnchorPoint = Vector2.new(0, 0.5),
    BackgroundColor3 = Theme.Element,
    Text = "X",
    TextColor3 = Theme.Text,
    Font = Theme.Font,
    TextSize = 13,
    AutoButtonColor = true,
}, nil)
CloseButton.Parent = TopBar
corner(CloseButton, 4)

local ContentHolder = create("Frame", {
    Size = UDim2.new(1, 0, 1, -58),
    Position = UDim2.fromOffset(0, 34),
    BackgroundTransparency = 1,
}, nil)
ContentHolder.Parent = Main

local Footer = create("Frame", {
    Size = UDim2.new(1, 0, 0, 24),
    Position = UDim2.new(0, 0, 1, -24),
    BackgroundColor3 = Theme.Main,
    BorderSizePixel = 0,
}, nil)
Footer.Parent = Main
corner(Footer, 6)
create("UIGradient", {
    Color = ColorSequence.new(Color3.fromRGB(0x19, 0x19, 0x19), Color3.fromRGB(0x24, 0x24, 0x24)),
    Rotation = 90,
    Parent = Footer,
})

local FooterLabel = create("TextLabel", {
    Size = UDim2.new(1, -24, 1, 0),
    Position = UDim2.fromOffset(12, 0),
    BackgroundTransparency = 1,
    Text = "cracked by InLoad and wraith.dev",
    TextColor3 = Theme.SubText,
    Font = Theme.Font,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd,
}, nil)
FooterLabel.Parent = Footer

local TabHolder = create("ScrollingFrame", {
    Size = UDim2.new(0, 130, 1, 0),
    BackgroundColor3 = Theme.Main,
    BorderSizePixel = 0,
    ScrollBarThickness = 2,
    ScrollBarImageColor3 = Theme.Accent,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, nil)
TabHolder.Parent = ContentHolder

create("UIListLayout", {
    Padding = UDim.new(0, 2),
    SortOrder = Enum.SortOrder.LayoutOrder,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Top,
    Parent = TabHolder,
})
create("UIPadding", { PaddingTop = UDim.new(0, 8), Parent = TabHolder })

local PageFolder = create("Folder", {}, nil)
PageFolder.Parent = ContentHolder

local allTabs = {}
local currentTab = nil

local function switchTab(tab)
    if currentTab then currentTab.Page.Visible = false end
    currentTab = tab
    tab.Page.Visible = true
    local info = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    for _, t in ipairs(allTabs) do
        local active = (t == tab)
        TweenService:Create(t.Stroke, info, { Color = Theme.Accent, Thickness = active and 2 or 1 }):Play()
        TweenService:Create(t.Button, info, { BackgroundColor3 = active and Theme.Highlight or Theme.Element }):Play()
    end
end

local function makeDraggable(handle, target)
    local dragging = false
    local dragStart, startPos, moved
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            dragStart = input.Position
            startPos = target.Position
        end
    end)
    handle.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if delta.Magnitude > 5 then moved = true end
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    return function() return moved == true end
end
makeDraggable(TopBar, Main)

local function onTweenCompleted(tween, fn)
    local conn
    conn = tween.Completed:Connect(function()
        conn:Disconnect()
        fn()
    end)
end

local panelAnimating = false
local function openPanel()
    if panelAnimating or Main.Visible then return end
    panelAnimating = true
    local targetSize = Main.Size
    Main.Size = UDim2.fromOffset(0, 0)
    Main.Visible = true
    local tween = TweenService:Create(Main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = targetSize })
    onTweenCompleted(tween, function() panelAnimating = false end)
    tween:Play()
end

local function closePanel()
    if panelAnimating or not Main.Visible then return end
    panelAnimating = true
    local targetSize = Main.Size
    local tween = TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Size = UDim2.fromOffset(0, 0) })
    onTweenCompleted(tween, function()
        Main.Visible = false
        Main.Size = targetSize
        panelAnimating = false
    end)
    tween:Play()
end

CloseButton.MouseButton1Click:Connect(function()
    closePanel()
end)

local Library
UserInputService.InputBegan:Connect(function(input, processed)
    if processed or Library and Library._unloaded then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if Main.Visible then closePanel() else openPanel() end
    end
end)

local OpenButton
if isMobile() then
    OpenButton = create("TextButton", {
        Size = UDim2.fromOffset(84, 40),
        Position = UDim2.new(0.5, 0, 0, 70),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Theme.Main,
        Text = "Toggle",
        TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 14,
    }, nil)
    OpenButton.Parent = ScreenGui
    corner(OpenButton, 6)
    stroke(OpenButton, Theme.Accent)
    registerText(OpenButton, "Toggle", "Открыть")

    local wasDragged = makeDraggable(OpenButton, OpenButton)
    OpenButton.MouseButton1Click:Connect(function()
        if wasDragged() then return end
        if Main.Visible then closePanel() else openPanel() end
    end)
end

local ResizeGrip = create("Frame", {
    Size = UDim2.fromOffset(24, 24),
    Position = UDim2.new(1, 0, 1, 0),
    AnchorPoint = Vector2.new(1, 1),
    BackgroundColor3 = Theme.Element,
    BorderSizePixel = 0,
    ZIndex = 5,
}, nil)
ResizeGrip.Parent = Main
corner(ResizeGrip, 4)
create("Frame", {
    Size = UDim2.new(1, -8, 0, 2),
    Position = UDim2.new(0, 4, 1, -6),
    BackgroundColor3 = Theme.Accent,
    BorderSizePixel = 0,
    ZIndex = 6,
    Parent = ResizeGrip,
})
create("Frame", {
    Size = UDim2.new(0, 2, 1, -8),
    Position = UDim2.new(1, -6, 0, 4),
    BackgroundColor3 = Theme.Accent,
    BorderSizePixel = 0,
    ZIndex = 6,
    Parent = ResizeGrip,
})

local MIN_W, MIN_H = 420, 260
local BASE_W, BASE_H = 700, 400
local resizing = false
local resizeStart, startSize
ResizeGrip.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = true
        resizeStart = input.Position
        startSize = Main.Size
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - resizeStart
        local w = math.clamp(startSize.X.Offset + delta.X, MIN_W * scaleValue, BASE_W * scaleValue * 1.6)
        local h = math.clamp(startSize.Y.Offset + delta.Y, MIN_H * scaleValue, BASE_H * scaleValue * 1.6)
        Main.Size = UDim2.fromOffset(w, h)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = false
    end
end)

local sidebarCollapsed = false
local sidebarAnimating = false
local SIDEBAR_W, SIDEBAR_MINI_W = 130, 36
local PAGE_X, PAGE_MINI_X = 135, 41
local PAGE_PAD, PAGE_MINI_PAD = 140, 46

local function setSidebar(collapsed)
    if sidebarAnimating or sidebarCollapsed == collapsed then return end
    sidebarAnimating = true
    sidebarCollapsed = collapsed
    TabToggleButton.Text = collapsed and ">" or "<"
    local info = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(TabHolder, info, {
        Size = UDim2.new(0, collapsed and SIDEBAR_MINI_W or SIDEBAR_W, 1, 0),
    }):Play()
    for _, t in ipairs(allTabs) do
        t.Label.Visible = not collapsed
        TweenService:Create(t.Icon, info, {
            Position = collapsed and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0, 16, 0.5, 0),
        }):Play()
        TweenService:Create(t.Page, info, {
            Position = UDim2.new(0, collapsed and PAGE_MINI_X or PAGE_X, 0, 6),
            Size = UDim2.new(1, collapsed and -PAGE_MINI_PAD or -PAGE_PAD, 1, -12),
        }):Play()
    end
    task.delay(0.32, function() sidebarAnimating = false end)
end

TabToggleButton.MouseButton1Click:Connect(function()
    setSidebar(not sidebarCollapsed)
end)

local StatsMenu = create("Frame", {
    Size = UDim2.fromOffset(190, 32),
    Position = UDim2.new(0, 12, 0, 12),
    BackgroundColor3 = Theme.Main,
    BorderSizePixel = 0,
    ZIndex = 50,
}, nil)
StatsMenu.Parent = ScreenGui
corner(StatsMenu, 6)
stroke(StatsMenu, Theme.Outline)

local StatsPlayers = create("TextLabel", {
    Size = UDim2.new(1, -12, 0, 16),
    Position = UDim2.fromOffset(6, 8),
    BackgroundTransparency = 1,
    Text = "FPS: 0 | Ping: 0 ms",
    TextColor3 = Theme.SubText,
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 51,
}, nil)
StatsPlayers.Parent = StatsMenu

makeDraggable(StatsMenu, StatsMenu)

local frameCount = 0
local windowStart = os.clock()
local currentFps = 0

local fpsConn = RunService.RenderStepped:Connect(function()
    frameCount += 1
    local now = os.clock()
    local elapsed = now - windowStart
    if elapsed >= 0.1 then
        currentFps = math.floor(frameCount / elapsed + 0.5)
        frameCount = 0
        windowStart = now
    end
end)

task.spawn(function()
    while ScreenGui.Parent do
        local ping = 0
        pcall(function() ping = math.floor(LocalPlayer:GetNetworkPing() * 1000) end)
        local text = tr(
            "FPS: " .. currentFps .. " | Ping: " .. ping .. " ms",
            "ФПС: " .. currentFps .. " | Пинг: " .. ping .. " мс"
        )
        if StatsPlayers.Text ~= text then
            StatsPlayers.Text = text
        end
        task.wait(1)
    end
end)

local Loading = create("Frame", {
    Size = UDim2.fromOffset(320 * scaleValue, 90 * scaleValue),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Theme.Main,
    BorderSizePixel = 0,
    ZIndex = 100,
}, nil)
Loading.Parent = ScreenGui
corner(Loading, 6)
stroke(Loading, Theme.Accent)

local LoadingTitle = create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 26),
    Position = UDim2.new(0.5, 0, 0.5, -20),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundTransparency = 1,
    Text = "(BETA Version) REAPER 2.1",
    TextColor3 = Theme.Text,
    Font = Theme.Font,
    TextSize = 20,
    ZIndex = 101,
}, nil)
LoadingTitle.Parent = Loading
registerText(LoadingTitle, "(BETA Version) REAPER 2.1", "(БЕТА Версия) REAPER 2.1")

local LoadingBarBG = create("Frame", {
    Size = UDim2.new(1, -40, 0, 2),
    Position = UDim2.new(0.5, 0, 0.5, 18),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Theme.Outline,
    BorderSizePixel = 0,
    ZIndex = 101,
}, nil)
LoadingBarBG.Parent = Loading

local LoadingBarFill = create("Frame", {
    Size = UDim2.new(0, 0, 1, 0),
    BackgroundColor3 = Theme.Accent,
    BorderSizePixel = 0,
    ZIndex = 102,
}, nil)
LoadingBarFill.Parent = LoadingBarBG
corner(LoadingBarFill, 2)

task.spawn(function()
    TweenService:Create(LoadingBarFill, TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 1, 0) }):Play()
    task.wait(1.8)
    local fadeOut = TweenService:Create(Loading, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 1 })
    TweenService:Create(LoadingTitle, TweenInfo.new(0.5), { TextTransparency = 1 }):Play()
    TweenService:Create(LoadingBarBG, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(LoadingBarFill, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
    fadeOut:Play()
    fadeOut.Completed:Wait()
    Loading:Destroy()
    openPanel()
end)

Library = {}
local ToggleGetters = {}

local NotifyHolder = create("Frame", {
    Size = UDim2.new(0, 220, 0, 300),
    Position = UDim2.new(1, -232, 0, 12),
    BackgroundTransparency = 1,
    ZIndex = 60,
}, nil)
NotifyHolder.Parent = ScreenGui
create("UIListLayout", {
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    VerticalAlignment = Enum.VerticalAlignment.Top,
    Parent = NotifyHolder,
})

function Library:Notify(text, duration)
    duration = duration or 3
    local Note = create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 34),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Main,
        Text = tostring(text),
        TextColor3 = Theme.Text,
        Font = Theme.Font,
        TextSize = 12,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        TextTransparency = 1,
        ZIndex = 61,
    }, nil)
    Note.Parent = NotifyHolder
    local noteStroke = stroke(Note, Theme.Accent)
    noteStroke.Transparency = 1
    corner(Note, 6)
    create("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), Parent = Note })
    TweenService:Create(Note, TweenInfo.new(0.25), { BackgroundTransparency = 0, TextTransparency = 0 }):Play()
    TweenService:Create(noteStroke, TweenInfo.new(0.25), { Transparency = 0 }):Play()
    task.delay(duration, function()
        local out = TweenService:Create(Note, TweenInfo.new(0.25), { BackgroundTransparency = 1, TextTransparency = 1 })
        TweenService:Create(noteStroke, TweenInfo.new(0.25), { Transparency = 1 }):Play()
        out:Play()
        out.Completed:Wait()
        Note:Destroy()
    end)
end

function Library:Unload()
    if Library._unloaded then return end
    Library._unloaded = true
    if fpsConn then fpsConn:Disconnect() end
    if Library._visualsCleanup then pcall(Library._visualsCleanup) end
    pcall(function() ScreenGui:Destroy() end)
end

local function drawIcon(parent, name)
    local holder = create("Frame", {
        Size = UDim2.fromOffset(18, 18),
        Position = UDim2.new(0, 16, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Parent = parent,
    })
    local function rect(x, y, w, h, rot, color, radius)
        local r = create("Frame", {
            Size = UDim2.fromOffset(w, h),
            Position = UDim2.new(0, x, 0, y),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Rotation = rot or 0,
            BackgroundColor3 = color or Theme.Text,
            BorderSizePixel = 0,
            Parent = holder,
        })
        if radius then corner(r, radius) end
        return r
    end
    local function circle(x, y, d, color)
        local c = create("Frame", {
            Size = UDim2.fromOffset(d, d),
            Position = UDim2.new(0, x, 0, y),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = color or Theme.Text,
            BorderSizePixel = 0,
            Parent = holder,
        })
        corner(c, d / 2)
        return c
    end
    if name == "Home" then
        rect(6.5, 6, 8.5, 2, -45)
        rect(11.5, 6, 8.5, 2, 45)
        rect(9, 12, 9, 8, 0, nil, 1)
        rect(9, 14, 3, 4, 0, Theme.Element, 1)
    elseif name == "Player" then
        circle(9, 5.5, 6.5)
        rect(9, 13, 10, 6.5, 0, nil, 3)
        rect(3.5, 12.5, 2, 6, 0, nil, 1)
        rect(14.5, 12.5, 2, 6, 0, nil, 1)
    elseif name == "Combat" then
        rect(9, 6, 2.5, 9)
        rect(9, 12.5, 7, 2)
        rect(9, 15.5, 2.5, 3, 0, nil, 1)
    elseif name == "Invincibility" then
        rect(9, 6.5, 12, 9, 0, nil, 2)
        circle(9, 11, 12)
        rect(9, 10, 8, 2, 0, Theme.Element, 1)
    elseif name == "Target" then
        circle(9, 9, 13)
        circle(9, 9, 8, Theme.Element)
        circle(9, 9, 4)
        rect(9, 1.5, 2, 3)
        rect(9, 16.5, 2, 3)
        rect(1.5, 9, 3, 2)
        rect(16.5, 9, 3, 2)
    elseif name == "Blobman" then
        circle(9, 9, 13)
        circle(6.5, 7.5, 3, Theme.Element)
        circle(11.5, 7.5, 3, Theme.Element)
        rect(9, 12.5, 5, 2, 0, nil, 1)
    elseif name == "Toys" then
        rect(9, 12, 11, 7, 0, nil, 1)
        rect(9, 7.5, 13, 3, 0, nil, 1)
        rect(9, 12, 2.5, 7, 0, Theme.Element)
        rect(9, 7.5, 2.5, 3, 0, Theme.Element)
    elseif name == "Visual" then
        circle(9, 9, 13)
        circle(9, 9, 7, Theme.Element)
        circle(9, 9, 3)
    elseif name == "Auto-Clicker" then
        rect(9, 9, 10, 14, 0, nil, 5)
        rect(9, 6, 2, 5, 0, Theme.Element, 1)
        rect(9, 9, 10, 1.5, 0, Theme.Element)
    elseif name == "Misc" then
        rect(9, 9, 13, 13, 0, nil, 3)
        circle(5.5, 5.5, 3, Theme.Element)
        circle(12.5, 5.5, 3, Theme.Element)
        circle(5.5, 12.5, 3, Theme.Element)
        circle(12.5, 12.5, 3, Theme.Element)
        circle(9, 9, 3, Theme.Element)
    elseif name == "Lists" then
        circle(3.5, 5, 3)
        circle(3.5, 9, 3)
        circle(3.5, 13, 3)
        rect(11.5, 5, 10, 2)
        rect(11.5, 9, 10, 2)
        rect(11.5, 13, 10, 2)
    elseif name == "Settings" then
        circle(9, 9, 11)
        rect(9, 2, 3, 4)
        rect(9, 16, 3, 4)
        rect(2, 9, 4, 3)
        rect(16, 9, 4, 3)
        circle(9, 9, 5, Theme.Element)
    end
    return holder
end

function Library:AddTab(name, icon)
    local TabButton = create("TextButton", {
        Size = UDim2.new(1, -10, 0, 24),
        BackgroundColor3 = Theme.Element,
        Text = "",
        AutoButtonColor = true,
        LayoutOrder = #allTabs + 1,
    }, nil)
    TabButton.Parent = TabHolder
    corner(TabButton, 4)
    local TabIcon = drawIcon(TabButton, name)

    local TabLabel = create("TextLabel", {
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 30, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Theme.Text,
        Font = Theme.Font,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = TabButton,
    })
    registerText(TabLabel, name, TabRuNames[name] or name)

    local Page = create("Frame", {
        Size = UDim2.new(1, -140, 1, -12),
        Position = UDim2.new(0, 135, 0, 6),
        BackgroundTransparency = 1,
        Visible = false,
    }, nil)
    Page.Parent = PageFolder

    local function makeColumn(order)
        local Col = create("ScrollingFrame", {
            Size = UDim2.new(0.5, -4, 1, 0),
            Position = UDim2.new(order == 1 and 0 or 0.5, order == 1 and 0 or 4, 0, 0),
            BackgroundColor3 = Theme.Background,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Accent,
            ScrollBarImageTransparency = 0.35,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
        }, nil)
        Col.Parent = Page
        corner(Col, 6)
        stroke(Col)
        create("UIGradient", {
            Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(200, 200, 200)),
            Rotation = 90,
            Parent = Col,
        })
        create("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Col })
        create("UIPadding", { PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 8), PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6), Parent = Col })
        return Col
    end

    local Col1 = makeColumn(1)
    local Col2 = makeColumn(2)

    local TabStroke = create("UIStroke", { Color = Theme.Accent, Thickness = 1, Parent = TabButton })
    local tab = { Name = name, Button = TabButton, Page = Page, Stroke = TabStroke, Label = TabLabel, Icon = TabIcon }
    table.insert(allTabs, tab)
    TabButton.MouseButton1Click:Connect(function() switchTab(tab) end)
    if not currentTab then switchTab(tab) end

    local function makeSection(target)
        local sectionAPI = {}
        local Page = target

        function sectionAPI:AddButton(label, callback)
            local Button = create("TextButton", {
                Size = UDim2.new(1, 0, 0, 26),
                BackgroundColor3 = Theme.Main,
                Text = label,
                TextColor3 = Theme.Accent,
                Font = Theme.Font,
                TextSize = 13,
                AutoButtonColor = false,
                TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = #Page:GetChildren(),
            }, nil)
            Button.Parent = Page
            styleObsidian(Button)
            Button.MouseButton1Click:Connect(function()
                if callback then pcall(callback) end
            end)
            return Button
        end

        function sectionAPI:AddToggle(label, default, callback)
            local state = default or false
            table.insert(ToggleGetters, function() return state end)
            local Toggle = create("TextButton", {
                Size = UDim2.new(1, 0, 0, 34),
                BackgroundColor3 = Theme.Main,
                Text = "",
                AutoButtonColor = false,
                LayoutOrder = #Page:GetChildren(),
            }, nil)
            Toggle.Parent = Page
            corner(Toggle, 4)
            stroke(Toggle)

            local Label = create("TextLabel", {
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.fromOffset(10, 0),
                BackgroundTransparency = 1,
                Text = label,
                TextColor3 = Theme.Text,
                Font = Theme.Font,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, nil)
            Label.Parent = Toggle

            local Pill = create("Frame", {
                Size = UDim2.fromOffset(34, 18),
                Position = UDim2.new(1, -40, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = state and Theme.Accent or Theme.Outline,
                BorderSizePixel = 0,
            }, nil)
            Pill.Parent = Toggle
            corner(Pill, 9)

            local Knob = create("Frame", {
                Size = UDim2.fromOffset(14, 14),
                Position = state and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = state and Color3.fromRGB(15, 15, 15) or Theme.Text,
                BorderSizePixel = 0,
            }, nil)
            Knob.Parent = Pill
            corner(Knob, 7)

            local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local function render()
                TweenService:Create(Pill, tweenInfo, { BackgroundColor3 = state and Theme.Accent or Theme.Outline }):Play()
                TweenService:Create(Knob, tweenInfo, {
                    Position = state and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                    BackgroundColor3 = state and Color3.fromRGB(15, 15, 15) or Theme.Text,
                }):Play()
            end

            local function setState(v)
                state = v and true or false
                render()
                if callback then pcall(callback, state) end
            end

            Toggle.MouseButton1Click:Connect(function()
                setState(not state)
            end)
            return { Set = setState, Get = function() return state end }
        end

        function sectionAPI:AddSlider(label, min, max, default, callback, step)
            local value = default or min
            local step = step or 1
            local Slider = create("Frame", {
                Size = UDim2.new(1, 0, 0, 46),
                BackgroundColor3 = Theme.Main,
                BorderSizePixel = 0,
                LayoutOrder = #Page:GetChildren(),
            }, nil)
            Slider.Parent = Page
            corner(Slider, 4)
            stroke(Slider)

            local Label = create("TextLabel", {
                Size = UDim2.new(1, -20, 0, 20),
                Position = UDim2.fromOffset(10, 2),
                BackgroundTransparency = 1,
                Text = label,
                TextColor3 = Theme.Text,
                Font = Theme.Font,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, nil)
            Label.Parent = Slider

            local ValueLabel = create("TextLabel", {
                Size = UDim2.fromOffset(60, 20),
                Position = UDim2.new(1, -66, 0, 2),
                BackgroundTransparency = 1,
                Text = tostring(value),
                TextColor3 = Theme.SubText,
                Font = Theme.Font,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Right,
            }, nil)
            ValueLabel.Parent = Slider

            local Track = create("Frame", {
                Size = UDim2.new(1, -20, 0, 6),
                Position = UDim2.new(0, 10, 1, -12),
                BackgroundColor3 = Theme.Outline,
                BorderSizePixel = 0,
            }, nil)
            Track.Parent = Slider
            corner(Track, 3)

            local Fill = create("Frame", {
                Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = Theme.Accent,
                BorderSizePixel = 0,
            }, nil)
            Fill.Parent = Track
            corner(Fill, 3)

            local dragging = false
            local function update(input)
                local rel = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                value = math.clamp(min + math.floor((max - min) * rel / step + 0.5) * step, min, max)
                Fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                ValueLabel.Text = tostring(value)
                if callback then pcall(callback, value) end
            end
            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    update(input)
                end
            end)
            Track.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    update(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            return { Get = function() return value end }
        end

        function sectionAPI:AddDropdown(label, options, callback)
            local Dropdown = create("TextButton", {
                Size = UDim2.new(1, 0, 0, 34),
                BackgroundColor3 = Theme.Main,
                Text = label .. ": " .. tostring(options[1]),
                TextColor3 = Theme.Text,
                Font = Theme.Font,
                TextSize = 13,
                AutoButtonColor = false,
                LayoutOrder = #Page:GetChildren(),
            }, nil)
            Dropdown.Parent = Page
            corner(Dropdown, 4)
            stroke(Dropdown)

            local listOpen = false
            local ListFrame = create("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundColor3 = Theme.Element,
                BorderSizePixel = 0,
                Visible = false,
                LayoutOrder = #Page:GetChildren(),
            }, nil)
            ListFrame.Parent = Page
            corner(ListFrame, 4)
            create("UIListLayout", { Parent = ListFrame })

            for _, opt in ipairs(options) do
                local OptButton = create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 28),
                    BackgroundTransparency = 1,
                    Text = tostring(opt),
                    TextColor3 = Theme.SubText,
                    Font = Theme.Font,
                    TextSize = 12,
                    AutoButtonColor = true,
                }, nil)
                OptButton.Parent = ListFrame
                OptButton.MouseButton1Click:Connect(function()
                    Dropdown.Text = label .. ": " .. tostring(opt)
                    listOpen = false
                    ListFrame.Visible = false
                    ListFrame.Size = UDim2.new(1, 0, 0, 0)
                    if callback then pcall(callback, opt) end
                end)
            end

            Dropdown.MouseButton1Click:Connect(function()
                listOpen = not listOpen
                ListFrame.Visible = listOpen
                ListFrame.Size = listOpen and UDim2.new(1, 0, 0, #options * 28) or UDim2.new(1, 0, 0, 0)
            end)
            return Dropdown
        end

        function sectionAPI:AddGroupbox(title)
            local Box = create("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Theme.Background,
                BorderSizePixel = 0,
                LayoutOrder = #Page:GetChildren(),
            }, nil)
            Box.Parent = Page
            corner(Box, 4)
            stroke(Box)
            create("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Box })
            create("UIPadding", { PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6), Parent = Box })

            local Header = create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 18),
                BackgroundTransparency = 1,
                Text = title,
                TextColor3 = Theme.Text,
                Font = Theme.Font,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = 0,
            }, nil)
            Header.Parent = Box
            create("Frame", {
                Size = UDim2.new(1, 0, 0, 1),
                BackgroundColor3 = Theme.Outline,
                BorderSizePixel = 0,
                LayoutOrder = 1,
                Parent = Box,
            })

            local boxAPI = {}
            for _, methodName in ipairs({ "AddButton", "AddToggle", "AddSlider", "AddDropdown" }) do
                boxAPI[methodName] = function(_, ...)
                    local saved = Page
                    Page = Box
                    local result = sectionAPI[methodName](sectionAPI, ...)
                    Page = saved
                    return result
                end
            end
            boxAPI.Page = Box
            return boxAPI
        end

        sectionAPI.Page = target
        return sectionAPI
    end

    local Col1Section = makeSection(Col1)
    local Col2Section = makeSection(Col2)
    return Col1Section, Col2Section
end

-- =====================================================================
-- SAVITAR VISUALS ENGINE (встроено в REAPER, без отдельного окна)
-- =====================================================================
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local StatsService = game:GetService("Stats")
local Workspace = game:GetService("Workspace")
local Terrain = Workspace.Terrain
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local VisualUpdaters = {}
local VisualHeartConn = nil
local function AddVisualUpdater(fn)
    VisualUpdaters[#VisualUpdaters + 1] = fn
    if not VisualHeartConn then
        VisualHeartConn = RunService.Heartbeat:Connect(function(dt)
            for i = 1, #VisualUpdaters do
                pcall(VisualUpdaters[i], dt)
            end
        end)
    end
end

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
        b.Name = "ReaperBloom"
        b.Intensity = preset.Bloom.Intensity * t
        b.Threshold = preset.Bloom.Threshold
        b.Size = preset.Bloom.Size * t
        ActiveEffects[#ActiveEffects+1] = b
    end
    if preset.Blur then
        local b = Instance.new("BlurEffect", Lighting)
        b.Name = "ReaperBlur"
        b.Size = preset.Blur.Size * t
        ActiveEffects[#ActiveEffects+1] = b
    end
    local ccData = preset.CC or preset.ColorCorrection
    if ccData then
        local cc = Instance.new("ColorCorrectionEffect", Lighting)
        cc.Name = "ReaperCC"
        cc.Brightness = (ccData.Brightness or 0) * t
        cc.Saturation = (ccData.Saturation or 0) * t
        cc.Contrast = (ccData.Contrast or 0) * t
        cc.TintColor = lerpColor(Color3.new(1,1,1), ccData.TintColor or Color3.new(1,1,1), t)
        ActiveEffects[#ActiveEffects+1] = cc
    end
    if preset.SunRays then
        local sr = Instance.new("SunRaysEffect", Lighting)
        sr.Name = "ReaperSR"
        sr.Intensity = (preset.SunRays.Intensity or 0) * t
        sr.Spread = preset.SunRays.Spread or 0.65
        ActiveEffects[#ActiveEffects+1] = sr
    end
    if preset.Atmosphere then
        local atm = Lighting:FindFirstChildOfClass("Atmosphere")
        if not atm then
            atm = Instance.new("Atmosphere", Lighting)
            atm.Name = "ReaperAtm"
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
        sky.Name = "ReaperSky"
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

local Forest = {
    Active = false, Models = {}, Sounds = {}, SoundEnabled = true,
    AmbientMusicVol = 0.2, BackgroundAmbienceVol = 0.2, RiverSoundMaxVol = 0.5,
    RiverSoundSelected = true, FadeLevel = 0, LastInZone = false, Watching = false,
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

            AddVisualUpdater(function(dt)
                if not model.Parent then return end
                ang += speed * dt
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
    if RV and Forest.RiverSoundSelected then
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

    if not Forest.Watching then
        Forest.Watching = true
        AddVisualUpdater(function()
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                Forest.LastInZone = IsInForestZone(hrp.Position)
            end
        end)
    end

    task.spawn(function()
        for i, info in ipairs(ForestModels) do
            LoadForestModel(info, i)
            task.wait(0.15)
        end
    end)

    if Forest.SoundEnabled then
        StartForestSounds()
        AddVisualUpdater(UpdateForestSounds)
    end
end

local Beach = {
    Active = false, Models = {}, Sounds = {}, SoundEnabled = true,
    WaveSoundVol = 0.1, SeagullSoundVol = 2, AmbientMusicVol = 0.2,
    WaveSpeed = 8, WaveSize = 0.5, WaterTransparency = 1, WaterReflectance = 0.7,
    FadeLevel = 0, LastInZone = false, Watching = false,
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
    local folder = Workspace:FindFirstChild("REAPERMAP")
    if not folder then
        folder = Instance.new("Folder")
        folder.Name = "REAPERMAP"
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

            AddVisualUpdater(function(dt)
                if not model.Parent then return end
                ang += speed * dt
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

    if not Beach.Watching then
        Beach.Watching = true
        AddVisualUpdater(function()
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                Beach.LastInZone = IsInBeachZone(hrp.Position)
            end
        end)
    end

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
        AddVisualUpdater(UpdateBeachSounds)
    end
end

Library._visualsCleanup = function()
    pcall(RemoveShader)
    pcall(DestroyForest)
    pcall(DestroyBeach)
    if VisualHeartConn then
        VisualHeartConn:Disconnect()
        VisualHeartConn = nil
    end
    VisualUpdaters = {}
end

local TabNames = {
    "Home", "Player", "Combat", "Invincibility", "Target", "Blobman",
    "Toys", "Visual", "Auto-Clicker", "Misc", "Lists", "Settings",
}

local function buildTabContent(tabName, col1, col2)
if tabName == "Home" then
    local Card = create("Frame", {
        Size = UDim2.new(1, 0, 0, 122),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        LayoutOrder = 1,
    }, nil)
    Card.Parent = col1.Page
    corner(Card, 4)
    stroke(Card)

    local Avatar = create("ImageLabel", {
        Size = UDim2.fromOffset(70, 70),
        Position = UDim2.new(0.5, 0, 0, 10),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Theme.Element,
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150",
        BorderSizePixel = 0,
    }, nil)
    Avatar.Parent = Card
    corner(Avatar, 4)
    stroke(Avatar, Theme.Accent)

    local Nick = create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 16),
        Position = UDim2.new(0, 0, 0, 84),
        BackgroundTransparency = 1,
        Text = LocalPlayer.DisplayName,
        TextColor3 = Theme.Text,
        Font = Theme.Font,
        TextSize = 13,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, nil)
    Nick.Parent = Card

    local Handle = create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 0, 0, 100),
        BackgroundTransparency = 1,
        Text = "@" .. LocalPlayer.Name,
        TextColor3 = Theme.SubText,
        Font = Theme.Font,
        TextSize = 11,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, nil)
    Handle.Parent = Card

    local HomeListHolder = create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Visible = false,
        LayoutOrder = 2,
    }, nil)
    HomeListHolder.Parent = col1.Page
    corner(HomeListHolder, 4)
    stroke(HomeListHolder)
    create("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = HomeListHolder })
    create("UIPadding", { PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6), Parent = HomeListHolder })

    local homeRows = {}
    local function addHomeRow(plr)
        if plr == LocalPlayer or homeRows[plr] then return end
        local Row = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = Theme.Main,
            Text = "",
            AutoButtonColor = true,
            LayoutOrder = #HomeListHolder:GetChildren(),
        }, nil)
        Row.Parent = HomeListHolder
        corner(Row, 4)

        local Avatar = create("ImageLabel", {
            Size = UDim2.fromOffset(24, 24),
            Position = UDim2.new(0, 4, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Theme.Element,
            Image = "rbxthumb://type=AvatarHeadShot&id=" .. plr.UserId .. "&w=48&h=48",
            BorderSizePixel = 0,
        }, nil)
        Avatar.Parent = Row
        corner(Avatar, 4)

        local Label = create("TextLabel", {
            Size = UDim2.new(1, -108, 1, 0),
            Position = UDim2.fromOffset(34, 0),
            BackgroundTransparency = 1,
            Text = plr.DisplayName .. " (@" .. plr.Name .. ")",
            TextColor3 = Theme.Text,
            Font = Theme.Font,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, nil)
        Label.Parent = Row

        local CopyBtn = create("TextButton", {
            Size = UDim2.fromOffset(56, 22),
            Position = UDim2.new(1, -6, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = Theme.Highlight,
            Text = "Copy",
            TextColor3 = Theme.Text,
            Font = Theme.Font,
            TextSize = 11,
            AutoButtonColor = false,
        }, nil)
        CopyBtn.Parent = Row
        corner(CopyBtn, 4)
        CopyBtn.MouseButton1Click:Connect(function()
            copyText(plr.Name)
            Library:Notify(tr("Copied: ", "Скопировано: ") .. "@" .. plr.Name)
        end)

        homeRows[plr] = Row
    end

    local function refreshHomeList()
        for plr, row in pairs(homeRows) do
            if not plr.Parent then
                row:Destroy()
                homeRows[plr] = nil
            end
        end
        for _, plr in ipairs(Players:GetPlayers()) do
            addHomeRow(plr)
        end
    end
    refreshHomeList()

    Players.PlayerAdded:Connect(function()
        task.wait(0.5)
        refreshHomeList()
    end)
    Players.PlayerRemoving:Connect(function(plr)
        if homeRows[plr] then
            homeRows[plr]:Destroy()
            homeRows[plr] = nil
        end
    end)

    local OpenListButton = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 26),
        BackgroundColor3 = Theme.Main,
        Text = "Player List",
        TextColor3 = Theme.Text,
        Font = Theme.Font,
        TextSize = 13,
        AutoButtonColor = false,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 3,
    }, nil)
    OpenListButton.Parent = col1.Page
    styleObsidian(OpenListButton)
    local setOpenList = addSwitch(OpenListButton, false)
    OpenListButton.MouseButton1Click:Connect(function()
        HomeListHolder.Visible = not HomeListHolder.Visible
        setOpenList(HomeListHolder.Visible)
    end)

    local LanguageButton = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 26),
        BackgroundColor3 = Theme.Main,
        Text = "Language",
        TextColor3 = Theme.Text,
        Font = Theme.Font,
        TextSize = 13,
        AutoButtonColor = false,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 4,
    }, nil)
    LanguageButton.Parent = col1.Page
    styleObsidian(LanguageButton)
    local setLang = addSwitch(LanguageButton, false)
    LanguageButton.MouseButton1Click:Connect(function()
        langRU = not langRU
        setLang(langRU)
        applyLanguage()
    end)

    local startTime = os.clock()
    local gameName = "Unknown"
    pcall(function()
        gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    end)

    local function addRow(text, order, isHeader)
        local row = create("TextLabel", {
            Size = UDim2.new(1, 0, 0, text == "" and 6 or (isHeader and 24 or 26)),
            BackgroundColor3 = Theme.Main,
            BackgroundTransparency = (isHeader or text == "") and 1 or 0,
            Text = text,
            TextColor3 = isHeader and Theme.Text or Theme.SubText,
            Font = Theme.Font,
            TextSize = isHeader and 13 or 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            LayoutOrder = order,
        }, nil)
        row.Parent = col2.Page
        if isHeader then
            create("Frame", {
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.new(0, 0, 1, -1),
                BackgroundColor3 = Theme.Accent,
                BackgroundTransparency = 0.6,
                BorderSizePixel = 0,
                Parent = row,
            })
        else
            corner(row, 4)
        end
        if text ~= "" then
            create("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = row })
        end
        return row
    end

    registerText(addRow("Statistics", 1, true), "Statistics", "Статистика")
    local TimeRow = addRow("Current time: --:--:--", 2)
    registerText(addRow("Current script version: v2.1", 3), "Current script version: v2.1", "Версия скрипта: v2.1")
    local TogglesRow = addRow("Toggles currently on: 0", 4)
    addRow("", 5)
    registerText(addRow("Server Statistics", 6, true), "Server Statistics", "Статистика сервера")
    registerText(addRow("Game name: " .. gameName, 7), "Game name: " .. gameName, "Название игры: " .. gameName)
    local ElapsedRow = addRow("Elapsed time: 0 seconds", 8)
    registerText(addRow("Kicked players: 0", 9), "Kicked players: 0", "Кикнуто игроков: 0")

    task.spawn(function()
        while col2.Page.Parent do
            TimeRow.Text = tr("Current time: ", "Текущее время: ") .. os.date("%H:%M:%S")
            local on = 0
            for _, get in ipairs(ToggleGetters) do
                if get() then on += 1 end
            end
            TogglesRow.Text = tr("Toggles currently on: ", "Включено тумблеров: ") .. on
            local elapsed = math.floor(os.clock() - startTime)
            local elapsedText
            if elapsed >= 60 then
                elapsedText = math.floor(elapsed / 60) .. tr(" min ", " мин ") .. (elapsed % 60) .. tr(" sec", " сек")
            else
                elapsedText = elapsed .. tr(" seconds", " сек")
            end
            ElapsedRow.Text = tr("Elapsed time: ", "Время сессии: ") .. elapsedText
            task.wait(1)
        end
    end)
elseif tabName == "Visual" then
    local currentShader = "Scarlet Atmosphere"
    local currentLevel = 8

    col1:AddDropdown("Shader", ShaderOrder, function(v)
        currentShader = v
        if ShaderState.Active then ApplyShader(currentShader, currentLevel) end
    end)

    col1:AddSlider("Intensity", 0, 10, 8, function(v)
        currentLevel = v
        if ShaderState.Active then ApplyShader(currentShader, currentLevel) end
    end)

    local ShaderBtn = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 26),
        BackgroundColor3 = Theme.Main,
        Text = "Shader",
        TextColor3 = Theme.Text,
        Font = Theme.Font,
        TextSize = 13,
        AutoButtonColor = false,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 3,
    }, nil)
    ShaderBtn.Parent = col1.Page
    styleObsidian(ShaderBtn)
    local setShaderSw = addSwitch(ShaderBtn, false)
    ShaderBtn.MouseButton1Click:Connect(function()
        if ShaderState.Active then
            RemoveShader()
        else
            ApplyShader(currentShader, currentLevel)
        end
        setShaderSw(ShaderState.Active)
    end)

    local ForestBtn = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 26),
        BackgroundColor3 = Theme.Main,
        Text = "Forest",
        TextColor3 = Theme.Text,
        Font = Theme.Font,
        TextSize = 13,
        AutoButtonColor = false,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 4,
    }, nil)
    ForestBtn.Parent = col1.Page
    styleObsidian(ForestBtn)
    local setForestSw = addSwitch(ForestBtn, false)
    ForestBtn.MouseButton1Click:Connect(function()
        if Forest.Active then DestroyForest() else LoadForest() end
        setForestSw(Forest.Active)
    end)

    local BeachBtn = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 26),
        BackgroundColor3 = Theme.Main,
        Text = "Beach",
        TextColor3 = Theme.Text,
        Font = Theme.Font,
        TextSize = 13,
        AutoButtonColor = false,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 5,
    }, nil)
    BeachBtn.Parent = col1.Page
    styleObsidian(BeachBtn)
    local setBeachSw = addSwitch(BeachBtn, false)
    BeachBtn.MouseButton1Click:Connect(function()
        if Beach.Active then DestroyBeach() else LoadBeach() end
        setBeachSw(Beach.Active)
    end)

    col2:AddSlider("Forest Music", 0, 100, 20, function(v)
        Forest.AmbientMusicVol = v / 100
    end)
    col2:AddSlider("Forest Ambience", 0, 100, 20, function(v)
        Forest.BackgroundAmbienceVol = v / 100
    end)
    col2:AddSlider("Forest River", 0, 100, 50, function(v)
        Forest.RiverSoundMaxVol = v / 100
    end)
    col2:AddSlider("Beach Waves", 0, 100, 10, function(v)
        Beach.WaveSoundVol = v / 100
    end)
    col2:AddSlider("Beach Seagulls", 0, 100, 40, function(v)
        Beach.SeagullSoundVol = v / 100 * 5
    end)
    col2:AddSlider("Beach Music", 0, 100, 20, function(v)
        Beach.AmbientMusicVol = v / 100
    end)
    col2:AddSlider("Wave Speed", 0, 100, 80, function(v)
        Beach.WaveSpeed = v / 10
        pcall(function() Terrain.WaterWaveSpeed = Beach.WaveSpeed end)
    end)
    col2:AddSlider("Wave Size", 0, 100, 50, function(v)
        Beach.WaveSize = v / 100
        pcall(function() Terrain.WaterWaveSize = Beach.WaveSize end)
    end)
    col2:AddSlider("Water Transp", 0, 100, 100, function(v)
        Beach.WaterTransparency = v / 100
        pcall(function() Terrain.WaterTransparency = Beach.WaterTransparency end)
    end)
    col2:AddSlider("Water Refl", 0, 100, 70, function(v)
        Beach.WaterReflectance = v / 100
        pcall(function() Terrain.WaterReflectance = Beach.WaterReflectance end)
    end)
else
    local emptyLabel = create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        Text = "— empty —",
        TextColor3 = Theme.SubText,
        Font = Theme.Font,
        TextSize = 11,
        LayoutOrder = 9999,
        Parent = col1.Page,
    })
    registerText(emptyLabel, "— empty —", "— пусто —")
end
end

for _, tabName in ipairs(TabNames) do
    local ok, err = pcall(function()
        local col1, col2 = Library:AddTab(tabName)
        buildTabContent(tabName, col1, col2)
    end)
    if not ok then
        warn("[REAPER] Tab '" .. tabName .. "' error: " .. tostring(err))
        pcall(function() Library:Notify("Tab error: " .. tabName) end)
    end
end

return Library