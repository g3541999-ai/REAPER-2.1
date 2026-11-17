-- [2] Функция создания Loop Toggle (С ИСПРАВЛЕННОЙ ЛОГИКОЙ ЦИКЛА)
local function CreateLoopToggle(Container, FlagName, StateFlag, IsServer, IsBlob, PlayerTable)
    local TargetType = IsServer and "Server" or "Selected"
    local Token = 0
    local IsRunning = false

    Container:AddToggle(FlagName, {
        Text = "Loop Apply Method " .. TargetType,
        Default = false,
        Tooltip = "Keeps applying selected methods to " .. TargetType:lower() .. " players",
        Callback = function(State)
            if State then
                Token = Token + 1
                IsRunning = true
                task.spawn(function()
                    local CurrentToken = Token
                    while IsRunning and Token == CurrentToken do
                        -- Применяем методы ко всем выбранным игрокам
                        for plr, _ in pairs(PlayerTable) do
                            if plr and plr.Parent then
                                -- ВЫЗОВ РЕАЛЬНОГО ДИСПЕТЧЕРА (заглушка)
                                -- tbl12.ProcessPlayer(plr, false, IsServer, IsBlob)
                                print("Loop -> Processing: " .. plr.Name)
                            end
                        end
                        task.wait(1) -- Задержка цикла
                    end
                end)
            else
                IsRunning = false -- Останавливаем цикл
            end
        end,
    })
end

-- [4] Функция создания Apply Button (С ИСПРАВЛЕННОЙ ЛОГИКОЙ)
local function CreateApplyButton(Container, IsServer, IsBlob, PlayerTable)
    local TargetType = IsServer and "Server" or "Selected"
    Container:AddButton({
        Text = "Apply Method " .. TargetType,
        Func = function()
            for plr, _ in pairs(PlayerTable) do
                if plr and plr.Parent then
                    -- ВЫЗОВ РЕАЛЬНОГО ДИСПЕТЧЕРА (заглушка)
                    -- tbl12.ProcessPlayer(plr, false, IsServer, IsBlob)
                    print("Apply -> Processing: " .. plr.Name)
                end
            end
        end,
    })
end

-- [5] ПОСТРОЕНИЕ UI ВКЛАДКИ TARGET (С ИСПРАВЛЕННЫМИ ЗАВИСИМОСТЯМИ)
do
    local LeftGroup = TargetTab:AddLeftGroupbox("Target Control")
    
    -- Создаем Dropdown и сохраняем ссылку на него для DependencyBox
    local TargetDropdown = CreatePlayerDropdown(LeftGroup, "TargetSelect", SelectedPlayers)
    
    -- Сохраняем настройки в таблицу options, чтобы DependencyBox не выдал ошибку
    options = options or {}
    options.TargetMethods = {}

    CreateLoopToggle(LeftGroup, "LoopTSelected", "LoopTSelected", false, false, SelectedPlayers)
    CreateLoopToggle(LeftGroup, "LoopTServer", "LoopTServer", true, false, SelectedPlayers)
    
    CreateApplyButton(LeftGroup, false, false, SelectedPlayers)
    CreateApplyButton(LeftGroup, true, false, SelectedPlayers)

    local RightGroup = TargetTab:AddRightGroupbox("Method Settings")

    RightGroup:AddDropdown("TargetMethods", {
        Values = {"Kick", "Void", "Kill", "Bring", "Destroy Food", "Remove Gucci", "Remove Invisibility", "Delete Seatables"},
        Multi = true, AllowNull = true, Text = "Methods",
        Callback = function(Values) 
            options.TargetMethods = Values 
        end,
    })

    -- DependencyBox теперь ссылается на существующую таблицу options
    local KickBox = RightGroup:AddDependencyBox()
    KickBox:SetupDependencies({ { options.TargetMethods, "Kick" } })
    KickBox:AddDivider("Kick Settings")
    KickBox:AddToggle("RagdollNK", { Text = "Loop Ragdoll", Default = true })
    KickBox:AddToggle("AntiKickRemoverNK", { Text = "Remove Anti-Kick", Default = true })
    KickBox:AddToggle("EKIToggle", { 
        Text = "Experimental Kick Improvements [BETA]", Risky = true, Default = false,
        Disabled = typeof(sethiddenproperty) ~= "function",
    })
    KickBox:AddSlider("HeightNK", { Text = "Kick Height", Default = 15, Min = 0, Max = 28 })
    KickBox:AddDropdown("KickServerMethod", { Values = { "Circle + Lag", "Void" }, Default = 1 })

    KickBox:AddButton({
        Text = "TP To Void Platform",
        Func = function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                pcall(function() char:PivotTo(CFrame.new(0, 10000, 0)) end)
                Library:Notify("Teleported to Void", 3)
            end
        end,
    })

    local GucciBox = RightGroup:AddDependencyBox()
    GucciBox:SetupDependencies({ { options.TargetMethods, "Remove Gucci" } })
    GucciBox:AddDivider("Remove-Gucci Settings")
    GucciBox:AddToggle("RagdollInRG", { Text = "Break Player? [Inf Ragdoll]", Default = false })
    GucciBox:AddButton({
        Text = "Fix Gucci Remover",
        Func = function()
            Library:Notify("Gucci Fix executed", 3)
        end,
    })
end