-- НЕОНОВЫЙ ФЛИНГ - ИСПРАВЛЕННАЯ ВЕРСИЯ
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
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Главное окно (УМЕНЬШЕННЫЙ РАЗМЕР)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 280) -- Уменьшен с 420x320
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -140)
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
    btn.Size = UDim2.new(0, 200, 0, 40) -- Уменьшен размер кнопки
    btn.Position = UDim2.new(0.5, -100, 0, posY)
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
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.Text = "⚡ НЕОНОВЫЙ ФЛИНГ 1.2⚡"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Кнопка сворачивания
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -40, 0, 3)
MinBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
MinBtn.BackgroundTransparency = 0.5
MinBtn.Text = "_"
MinBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
MinBtn.TextSize = 20
MinBtn.BorderSizePixel = 0
MinBtn.Parent = MainFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = MinBtn

-- Кнопка закрытия (НОВАЯ)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -75, 0, 3)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.BackgroundTransparency = 0.5
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 16
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = MainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = CloseBtn

-- Поле ввода (УМЕНЬШЕНО)
local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(0, 260, 0, 35)
InputBox.Position = UDim2.new(0.5, -130, 0, 45)
InputBox.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
InputBox.BackgroundTransparency = 0.3
InputBox.BorderSizePixel = 0
InputBox.Text = ""
InputBox.PlaceholderText = "Никнеймы через запятую"
InputBox.TextColor3 = Color3.fromRGB(200, 200, 255)
InputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 180)
InputBox.Font = Enum.Font.Gotham
InputBox.TextSize = 14
InputBox.TextXAlignment = Enum.TextXAlignment.Left
InputBox.ClearTextOnFocus = false
InputBox.Parent = MainFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = InputBox

-- Строка статуса
local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(0, 260, 0, 25)
StatusText.Position = UDim2.new(0.5, -130, 0, 90)
StatusText.BackgroundTransparency = 1
StatusText.Text = "● СТАТУС: ОСТАНОВЛЕН"
StatusText.TextColor3 = Color3.fromRGB(255, 100, 100)
StatusText.TextSize = 13
StatusText.Font = Enum.Font.GothamBold
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.Parent = MainFrame

-- Статистика
local StatsText = Instance.new("TextLabel")
StatsText.Size = UDim2.new(0, 260, 0, 22)
StatsText.Position = UDim2.new(0.5, -130, 0, 118)
StatsText.BackgroundTransparency = 1
StatsText.Text = "Игроков: 0 | Защищено: 0 | Флингнуто: 0"
StatsText.TextColor3 = Color3.fromRGB(150, 150, 200)
StatsText.TextSize = 12
StatsText.Font = Enum.Font.Gotham
StatsText.TextXAlignment = Enum.TextXAlignment.Left
StatsText.Parent = MainFrame

-- Прогресс флинга
local ProgressLabel = Instance.new("TextLabel")
ProgressLabel.Size = UDim2.new(0, 260, 0, 22)
ProgressLabel.Position = UDim2.new(0.5, -130, 0, 143)
ProgressLabel.BackgroundTransparency = 1
ProgressLabel.Text = "Ожидание..."
ProgressLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ProgressLabel.TextSize = 12
ProgressLabel.Font = Enum.Font.Gotham
ProgressLabel.TextXAlignment = Enum.TextXAlignment.Left
ProgressLabel.Parent = MainFrame

-- Кнопка запуска
local FlingBtn = createNeonButton("▶ ЗАПУСТИТЬ ФЛИНГ", MainFrame, 175)

-- Информация
local InfoText = Instance.new("TextLabel")
InfoText.Size = UDim2.new(0, 260, 0, 25)
InfoText.Position = UDim2.new(0.5, -130, 0, 228)
InfoText.BackgroundTransparency = 1
InfoText.Text = "Флинг каждые 10 сек | v2.1"
InfoText.TextColor3 = Color3.fromRGB(80, 80, 120)
InfoText.TextSize = 11
InfoText.Font = Enum.Font.Gotham
InfoText.TextXAlignment = Enum.TextXAlignment.Left
InfoText.Parent = MainFrame

-- Переменные состояния
local isFlinging = false
local isFlingingNow = false
local flingConnection = nil

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

-- МОЩНЫЙ ФЛИНГ ДЛЯ ОДНОГО ИГРОКА
local function flingPlayer(player)
    if not player or player == LocalPlayer then return false end
    
    local character = player.Character
    if not character then return false end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not rootPart or not humanoid then return false end
    if humanoid.Health <= 0 then return false end
    
    -- Сохраняем позицию для возврата
    local oldPos = rootPart.Position
    
    -- Пытаемся изменить сетевое владение
    pcall(function()
        rootPart:SetNetworkOwner(nil)
    end)
    
    -- ОГРОМНАЯ СИЛА ФЛИНГА
    local x = math.random(-5000, 5000)
    local y = math.random(2000, 10000)
    local z = math.random(-5000, 5000)
    
    -- Применяем скорость
    pcall(function()
        rootPart.Velocity = Vector3.new(x, y, z)
        rootPart.RotVelocity = Vector3.new(
            math.random(-500, 500),
            math.random(-500, 500),
            math.random(-500, 500)
        )
    end)
    
    -- Толкаем другие части
    for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") and part ~= rootPart then
            pcall(function()
                part.Velocity = Vector3.new(
                    math.random(-3000, 3000),
                    math.random(1000, 5000),
                    math.random(-3000, 3000)
                )
            end)
        end
    end
    
    -- Ждем и возвращаем владельца
    task.wait(0.05)
    pcall(function()
        if rootPart and rootPart.Parent then
            rootPart:SetNetworkOwner(player)
        end
    end)
    
    return true
end

-- Флинг всех игроков ПО ОЧЕРЕДИ
local function flingAll()
    if isFlingingNow then return end
    isFlingingNow = true
    
    local ignoreList = getIgnoredList()
    local players = Players:GetPlayers()
    local flingedCount = 0
    
    -- Фильтруем игроков
    local targets = {}
    for _, player in ipairs(players) do
        if player ~= LocalPlayer then
            local isIgnored = false
            for _, name in ipairs(ignoreList) do
                if player.Name:lower() == name then
                    isIgnored = true
                    break
                end
            end
            if not isIgnored and player.Character then
                table.insert(targets, player)
            end
        end
    end
    
    local totalTargets = #targets
    
    if totalTargets == 0 then
        StatusText.Text = "⚠ НЕТ ЦЕЛЕЙ"
        StatusText.TextColor3 = Color3.fromRGB(255, 200, 0)
        isFlingingNow = false
        return
    end
    
    -- Флингаем каждого с задержкой
    for i, player in ipairs(targets) do
        if not isFlinging then break end -- Проверяем, не остановлен ли флинг
        
        ProgressLabel.Text = "🎯 " .. player.Name .. " (" .. i .. "/" .. totalTargets .. ")"
        StatusText.Text = "🔄 ФЛИНГ: " .. i .. "/" .. totalTargets
        StatusText.TextColor3 = Color3.fromRGB(0, 255, 255)
        
        local success = flingPlayer(player)
        if success then
            flingedCount = flingedCount + 1
        end
        
        updateStats(flingedCount)
        
        -- Задержка между игроками
        if i < totalTargets then
            task.wait(0.35)
        end
    end
    
    -- Завершение
    if isFlinging then
        StatusText.Text = "✅ ГОТОВО: " .. flingedCount .. "/" .. totalTargets
        StatusText.TextColor3 = Color3.fromRGB(0, 255, 100)
        ProgressLabel.Text = "Следующий флинг через 10 сек..."
    end
    
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
    ProgressLabel.Text = "Запуск..."
    
    -- Функция цикла
    local function flingCycle()
        while isFlinging do
            if not isFlingingNow then
                flingAll()
            end
            -- Ждем 10 секунд до следующего флинга
            local waited = 0
            while waited < 10 and isFlinging do
                local remaining = 10 - waited
                ProgressLabel.Text = "Следующий флинг через " .. math.ceil(remaining) .. " сек..."
                task.wait(1)
                waited = waited + 1
            end
        end
    end
    
    -- Запускаем цикл
    task.spawn(flingCycle)
end

-- Остановка цикла
local function stopFlinging()
    isFlinging = false
    
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

-- Сворачивание (ИСПРАВЛЕНО)
local minimized = false
local originalSize = MainFrame.Size
local originalGlowSize = GlowFrame.Size
local elementsToHide = {}

MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        -- Сохраняем элементы, которые нужно скрыть
        elementsToHide = {InputBox, StatsText, StatusText, FlingBtn, InfoText, ProgressLabel}
        for _, elem in ipairs(elementsToHide) do
            elem.Visible = false
        end
        MainFrame.Size = UDim2.new(0, 300, 0, 50)
        GlowFrame.Size = UDim2.new(0, 308, 0, 58)
        MinBtn.Text = "+"
        Title.Text = "⚡ НЕОНОВЫЙ ФЛИНГ [▼]"
    else
        MainFrame.Size = originalSize
        GlowFrame.Size = originalGlowSize
        MinBtn.Text = "_"
        for _, elem in ipairs(elementsToHide) do
            elem.Visible = true
        end
        Title.Text = "⚡ НЕОНОВЫЙ ФЛИНГ ⚡"
    end
end)

-- Закрытие (НОВОЕ)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
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

print("✅ НЕОНОВЫЙ ФЛИНГ v2.1 ЗАГРУЖЕН!")
print("📌 Флингает игроков ПО ОЧЕРЕДИ с задержкой 0.35 сек!")
print("⚡ Исправлены все баги интерфейса!")
