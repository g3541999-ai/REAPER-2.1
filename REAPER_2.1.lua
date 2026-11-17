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
    local Lighting = game:GetService("Lighting")
    local origClock = Lighting.ClockTime

    local function setNight(on)
        Lighting.ClockTime = on and 0 or origClock
    end

    local visualState = {}
    local VisualMenuButton = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 26),
        BackgroundColor3 = Theme.Main,
        Text = "Visuals Menu",
        TextColor3 = Theme.Text,
        Font = Theme.Font,
        TextSize = 13,
        AutoButtonColor = false,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1,
    }, nil)
    VisualMenuButton.Parent = col1.Page
    styleObsidian(VisualMenuButton)
    local setVisualsMenu = addSwitch(VisualMenuButton, false)

    local VisualListHolder = create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Visible = false,
        LayoutOrder = 2,
    }, nil)
    VisualListHolder.Parent = col1.Page
    create("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = VisualListHolder })

    local visuals = {
        { "Make Night", setNight },
    }

    for _, item in ipairs(visuals) do
        local name, setter = item[1], item[2]
        local Row = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = Theme.Main,
            Text = "",
            AutoButtonColor = true,
            LayoutOrder = #VisualListHolder:GetChildren(),
        }, nil)
        Row.Parent = VisualListHolder
        corner(Row, 4)
        local setSwitch = addSwitch(Row, false)

        local Label = create("TextLabel", {
            Size = UDim2.new(1, -60, 1, 0),
            Position = UDim2.fromOffset(8, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = Theme.Text,
            Font = Theme.Font,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, nil)
        Label.Parent = Row

        Row.MouseButton1Click:Connect(function()
            local newState = not visualState[name]
            visualState[name] = newState
            pcall(setter, newState)
            setSwitch(newState)
        end)
    end

    VisualMenuButton.MouseButton1Click:Connect(function()
        VisualListHolder.Visible = not VisualListHolder.Visible
        setVisualsMenu(VisualListHolder.Visible)
    end)

    local desiredFov = (workspace.CurrentCamera and workspace.CurrentCamera.FieldOfView) or 70
    col2:AddSlider("Time of Day", 0, 24, math.floor(Lighting.ClockTime * 2) / 2, function(v)
        Lighting.ClockTime = v
    end, 0.5)
    col2:AddSlider("FOV", 70, 120, math.floor(desiredFov), function(v)
        desiredFov = v
        pcall(function() workspace.CurrentCamera.FieldOfView = v end)
    end)

    task.spawn(function()
        while col1.Page.Parent do
            pcall(function()
                local cam = workspace.CurrentCamera
                if cam and cam.FieldOfView ~= desiredFov then
                    cam.FieldOfView = desiredFov
                end
            end)
            task.wait(0.5)
        end
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