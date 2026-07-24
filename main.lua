local OrionLib = loadstring(game:HttpGet(('https://githubusercontent.com')))()
local Window = OrionLib:MakeWindow({Name = "Target Teleporter", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local selectedPlayerName = ""
local teleportLoop = nil

-- Функция для получения списка ников игроков
local function getPlayerNames()
    local names = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    return names
end

local Tab = Window:MakeTab({
    Name = "Главная",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Выпадающий список игроков
local PlayerDropdown = Tab:AddDropdown({
    Name = "Выбери игрока",
    Default = "",
    Options = getPlayerNames(),
    Callback = function(Value)
        selectedPlayerName = Value
    end
})

-- Кнопка обновления списка (если кто-то зашел/вышел)
Tab:AddButton({
    Name = "Обновить список игроков",
    Callback = function()
        PlayerDropdown:Refresh(getPlayerNames(), true)
    end
})

-- Переключатель для жесткой телепортации
Tab:AddToggle({
    Name = "Прилипнуть к игроку (Каждый кадр)",
    Default = false,
    Callback = function(Value)
        if Value then
            -- Включаем цикл привязки
            teleportLoop = RunService.Heartbeat:Connect(function()
                local targetPlayer = Players:FindFirstChild(selectedPlayerName)
                if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        -- Копируем позицию вплоть до миллиметров
                        LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                    end
                end
            end)
        else
            -- Выключаем цикл
            if teleportLoop then
                teleportLoop:Disconnect()
                teleportLoop = nil
            end
        end
    end
})

OrionLib:Init()
