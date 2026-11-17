-- ==========================================
-- REAPER 2.1 — OBSIDIAN EDITION
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