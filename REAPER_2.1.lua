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

local loaderStroke = Instance.new("UIStroke")
loaderStroke.Color = Color3.fromRGB(125, 85, 255)
loaderStroke.Thickness = 1
loaderStroke.Parent = loaderFrame

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
        if loaderStroke then loaderStroke.Transparency = 1 end
    end)
    task.wait(0.3)
    pcall(function() loaderGui:Destroy() end)
    loaderGui = nil
end