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

local Tabs = {
    { Name = "Home",         Icon = "home" },
    { Name = "Player",       Icon = "user" },
    { Name = "Combat",       Icon = "swords" },
    { Name = "Invincibility", Icon = "shield" },
    { Name = "Target",       Icon = "target" },
    { Name = "Blobman",      Icon = "ghost" },
    { Name = "Toys",         Icon = "toy-brick" },
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