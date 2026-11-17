-- ==========================================
-- REAPER 2.1 — OBSIDIAN EDITION
-- ==========================================

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()

local Window = Library:CreateWindow({
    Title = "🌙 REAPER 2.1",
    Footer = "Powered by Obsidian",
    Size = UDim2.fromOffset(600, 400),
    Center = true,
    AutoShow = true,
})

local Tab = Window:AddTab("Main", "home")
local Group = Tab:AddLeftGroupbox("Main Functions")

Group:AddButton({
    Text = "Нажми меня",
    Func = function()
        Library:Notify("Кнопка работает! REAPER + Obsidian = OK")
    end
})

Group:AddToggle("MyToggle", {
    Text = "Тестовый переключатель",
    Default = false,
    Callback = function(Value)
        print("Toggle:", Value)
    end
})