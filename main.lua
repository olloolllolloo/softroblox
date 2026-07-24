-- НЕОНОВЫЙ ФЛИНГ - РАБОЧАЯ ВЕРСИЯ С ЗАДЕРЖКОЙ
-- Флингает каждого игрока с интервалом 0.3-0.5 секунды

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Ожидаем загрузки персонажа
if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

-- СОЗДАНИЕ GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NeonFlingGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer.PlayerGui

if not ScreenGui.Parent then
    ScreenGui.Parent = game:GetService("CoreGui")
end

-- Главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 320)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Эффект свечения
local GlowFrame = Instance.new("Frame")
GlowFrame.Size = MainFrame.Size + UDim2.new(0, 8, 0, 8)
GlowFrame.Position = MainFrame.Position - UDim2.new(0, 4, 0, 4)
GlowFrame.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
GlowFrame.BackgroundTransparency = 0.85
GlowFrame.BorderSizePixel = 0
GlowFrame.Parent = ScreenGui

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 12)
glowCorner.Parent = GlowFrame

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = MainFrame

-- Функция создания неоновой кнопки
local function createNeonButton(text, parent, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 220, 0, 45)
    btn.Position = UDim2.new(0.5, -110, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(0, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(0, 255, 255)
    stroke.Transparency = 0.6
    stroke.Parent = btn
    
    return btn
end

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "⚡ НЕОНОВЫЙ ФЛИНГ ⚡"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Кнопка сворачивания
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 35, 0, 35)
MinBtn.Position = UDim2.new(1, -45, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
MinBtn.BackgroundTransparency = 0.5
MinBtn.Text = "_"
MinBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
MinBtn.TextSize = 25
MinBtn.BorderSizePixel = 0
MinBtn.Parent = MainFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = MinBtn

-- Поле ввода
local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(0, 380, 0, 45)
InputBox.Position = UDim2.new(0.5, -190, 0, 55)
InputBox.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
InputBox.BackgroundTransparency = 0.3
InputBox.BorderSizePixel = 0
InputBox.Text = ""
InputBox.PlaceholderText = "Никнеймы через запятую (защита)"
InputBox.TextColor3 = Color3.fromRGB(200, 200, 255)
InputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 180)
InputBox.Font = Enum.Font.Gotham
InputBox.TextSize = 15
InputBox.TextXAlignment = Enum.TextXAlignment.Left
InputBox.ClearTextOnFocus = false
InputBox.Parent = MainFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = InputBox

-- Строка статуса
local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(0, 380, 0, 30)
StatusText.Position = UDim2.new(0.5, -190, 0, 115)
StatusText.BackgroundTransparency = 1
StatusText.Text = "● СТАТУС: ОСТАНОВЛЕН"
StatusText.TextColor3 = Color3.fromRGB(255, 100, 100)
StatusText.TextSize = 15
StatusText.Font = Enum.Font.GothamBold
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.Parent = MainFrame

-- Статистика
local StatsText = Instance.new("TextLabel")
StatsText.Size = UDim2.new(0, 380, 0, 25)
StatsText.Position = UDim2.new(0.5, -190, 0, 150)
StatsText.BackgroundTransparency = 1
StatsText.Text = "Игроков: 0 | Защищено: 0 | Флингнуто: 0"
StatsText.TextColor3 = Color3.fromRGB(150, 150, 200)
StatsText.TextSize = 13
StatsText.Font = Enum.Font.Gotham
StatsText.TextXAlignment = Enum.TextXAlignment.Left
StatsText.Parent = MainFrame

-- Прогресс флинга
local ProgressLabel = Instance.new("TextLabel")
ProgressLabel.Size = UDim2.new(0, 380, 0, 25)
ProgressLabel.Position = UDim2.new(0.5, -190, 0, 180)
ProgressLabel.BackgroundTransparency = 1
ProgressLabel.Text = "Ожидание..."
ProgressLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ProgressLabel.TextSize = 13
ProgressLabel.Font = Enum.Font.Gotham
ProgressLabel.TextXAlignment = Enum.TextXAlignment.Left
ProgressLabel.Parent = MainFrame

-- Кнопка запуска
local FlingBtn = createNeonButton("▶ ЗАПУСТИТЬ ФЛИНГ", MainFrame, 220)

-- Информация
local InfoText = Instance.new("TextLabel")
InfoText.Size = UDim2.new(0, 380, 0, 30)
InfoText.Position = UDim2.new(0.5, -190, 0, 280)
InfoText.BackgroundTransparency = 1
InfoText.Text = "Флинг каждые 10 сек | v2.0 (с задержкой между игроками)"
InfoText.TextColor3 = Color3.fromRGB(80, 80, 120)
InfoText.TextSize = 11
InfoText.Font = Enum.Font.Gotham
InfoText.TextXAlignment = Enum.TextXAlignment.Left
InfoText.Parent = MainFrame

-- Переменные состояния
local isFlinging = false
local flingTimer = nil
local isFlingingNow = false

-- Получение игнорируемых игроков
local function getIgnoredList()
    local text = InputBox.Text
    local list = {}
    if text ~= "" then
        for name in string.gmatch(text, "([^,]+)") do
            local clean = name:gsub("^%s*(.-)%s*$", "%1"):lower()
            if clean ~= "" then
                table.insert(list, clean)
            end
        end
    end
    return list
end

-- Обновление статистики
local function updateStats(flingedCount)
    local total = #Players:GetPlayers()
    local ignored = #getIgnoredList()
    local flinged = flingedCount or 0
    StatsText.Text = "Игроков: " .. total .. " | Защищено: " .. ignored .. " | Флингнуто: " .. flinged
end

-- МОЩНЫЙ ФЛИНГ ДЛЯ ОДНОГО ИГРОКА (С ЗАДЕРЖКОЙ)
local function flingPlayer(player, delay)
    if not player or player == LocalPlayer then return false end
    if not player.Character then return false end
    
    local humanoid = player.Character:FindFirstChild("Humanoid")
    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
    
    if not rootPart or not humanoid then return false end
    if humanoid.Health <= 0 then return false end
    
    -- Ждем задержку перед флингом
    if delay and delay > 0 then
        task.wait(delay)
    end
    
    -- Проверяем что игрок все еще существует
    if not player.Character or not rootPart.Parent then return false end
    
    -- Смена сетевого владельца
    rootPart:SetNetworkOwner(nil)
    
    -- ОГРОМНАЯ СИЛА ФЛИНГА
    local x = math.random(-1200, 1200)
    local y = math.random(500, 1500)
    local z = math.random(-1200, 1200)
    
    -- Применяем скорость к RootPart
    rootPart.AssemblyLinearVelocity = Vector3.new(x, y, z)
    rootPart.AssemblyAngularVelocity = Vector3.new(
        math.random(-200, 200),
        math.random(-200, 200),
        math.random(-200, 200)
    )
    
    -- Толкаем все части тела для максимального эффекта
    for _, part in ipairs(player.Character:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.AssemblyLinearVelocity = Vector3.new(
                math.random(-400, 400),
                math.random(300, 800),
                math.random(-400, 400)
            )
        end
    end
    
    -- Возвращаем владельца
    task.wait(0.1)
    if rootPart and rootPart.Parent then
        rootPart:SetNetworkOwner(player)
    end
    
    return true
end

-- Флинг всех игроков ПО ОЧЕРЕДИ
local function flingAll()
    if isFlingingNow then return end
    isFlingingNow = true
    
    local ignoreList = getIgnoredList()
    local players = Players:GetPlayers()
    local flingedCount = 0
    local totalPlayers = 0
    
    -- Считаем сколько игроков будем флингать
    for _, player in ipairs(players) do
        if player ~= LocalPlayer and player.Character then
            local isIgnored = false
            for _, name in ipairs(ignoreList) do
                if player.Name:lower() == name then
                    isIgnored = true
                    break
                end
            end
            if not isIgnored then
                totalPlayers = totalPlayers + 1
            end
        end
    end
    
    if totalPlayers == 0 then
        StatusText.Text = "⚠ НЕТ ИГРОКОВ ДЛЯ ФЛИНГА"
        StatusText.TextColor3 = Color3.fromRGB(255, 200, 0)
        isFlingingNow = false
        return
    end
    
    StatusText.Text = "🔄 ФЛИНГ НАЧАЛСЯ (0/" .. totalPlayers .. ")"
    StatusText.TextColor3 = Color3.fromRGB(0, 255, 255)
    ProgressLabel.Text = "Начинаем флинг..."
    
    local current = 0
    for _, player in ipairs(players) do
        if player ~= LocalPlayer and player.Character then
            local isIgnored = false
            for _, name in ipairs(ignoreList) do
                if player.Name:lower() == name then
                    isIgnored = true
                    break
                end
            end
            
            if not isIgnored then
                current = current + 1
                ProgressLabel.Text = "Флингую: " .. player.Name .. " (" .. current .. "/" .. totalPlayers .. ")"
                StatusText.Text = "🔄 ФЛИНГ: " .. current .. "/" .. totalPlayers
                
                -- Задержка между флингами (0.2-0.4 секунды)
                local success = flingPlayer(player, 0)
                if success then
                    flingedCount = flingedCount + 1
                end
                
                updateStats(flingedCount)
                
                -- Небольшая задержка между игроками
                task.wait(0.3)
            end
        end
    end
    
    -- Завершение
    StatusText.Text = "✅ ФЛИНГ ЗАВЕРШЕН! (" .. flingedCount .. "/" .. totalPlayers .. ")"
    StatusText.TextColor3 = Color3.fromRGB(0, 255, 100)
    ProgressLabel.Text = "Готово! Следующий флинг через 10 сек"
    updateStats(flingedCount)
    
    isFlingingNow = false
end

-- Запуск цикла
local function startFlinging()
    if isFlinging then return end
    isFlinging = true
    
    FlingBtn.Text = "⏹ ОСТАНОВИТЬ"
    FlingBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    StatusText.Text = "● ФЛИНГ АКТИВЕН"
    StatusText.TextColor3 = Color3.fromRGB(0, 255, 255)
    ProgressLabel.Text = "Ожидание первого флинга..."
    
    -- Первый флинг сразу
    task.spawn(function()
        flingAll()
    end)
    
    -- Таймер на 10 секунд
    flingTimer = RunService.Heartbeat:Connect(function()
        if not isFlinging then return end
        if not flingTimer._last then
            flingTimer._last = tick()
        end
        if tick() - flingTimer._last >= 10 then
            flingTimer._last = tick()
            if not isFlingingNow then
                task.spawn(flingAll)
            end
        end
    end)
end

-- Остановка цикла
local function stopFlinging()
    if not isFlinging then return end
    isFlinging = false
    
    if flingTimer then
        flingTimer:Disconnect()
        flingTimer = nil
    end
    
    FlingBtn.Text = "▶ ЗАПУСТИТЬ ФЛИНГ"
    FlingBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
    StatusText.Text = "● СТАТУС: ОСТАНОВЛЕН"
    StatusText.TextColor3 = Color3.fromRGB(255, 100, 100)
    ProgressLabel.Text = "Остановлен"
end

-- Кнопка запуска/остановки
FlingBtn.MouseButton1Click:Connect(function()
    if isFlinging then
        stopFlinging()
    else
        startFlinging()
    end
end)

-- Сворачивание
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainFrame.Size = UDim2.new(0, 420, 0, 50)
        GlowFrame.Size = UDim2.new(0, 430, 0, 60)
        MinBtn.Text = "+"
        InputBox.Visible = false
        StatsText.Visible = false
        StatusText.Visible = false
        FlingBtn.Visible = false
        InfoText.Visible = false
        ProgressLabel.Visible = false
        Title.Text = "⚡ НЕОНОВЫЙ ФЛИНГ [▼]"
    else
        MainFrame.Size = UDim2.new(0, 420, 0, 320)
        GlowFrame.Size = UDim2.new(0, 430, 0, 330)
        MinBtn.Text = "_"
        InputBox.Visible = true
        StatsText.Visible = true
        StatusText.Visible = true
        FlingBtn.Visible = true
        InfoText.Visible = true
        ProgressLabel.Visible = true
        Title.Text = "⚡ НЕОНОВЫЙ ФЛИНГ 1.1⚡"
    end
end)

-- Обновление статистики при вводе
InputBox:GetPropertyChangedSignal("Text"):Connect(function()
    updateStats(0)
end)

-- Обновление при изменении игроков
Players.PlayerAdded:Connect(function()
    updateStats(0)
end)
Players.PlayerRemoving:Connect(function()
    updateStats(0)
end)

-- Инициализация
updateStats(0)

print("✅ НЕОНОВЫЙ ФЛИНГ v2.0 ЗАГРУЖЕН!")
print("📌 Теперь флингает игроков ПО ОЧЕРЕДИ с задержкой!")
print("⚡ Каждые 10 секунд проходит по всем игрокам")
