-- Неоновый Fling Скрипт с Переносимым Интерфейсом
-- Работает путем изменения сетевого владения и применения огромной скорости к RootPart

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Переменные для интерфейса
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer.PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.Name = "NeonFlingGUI"

-- Функция для создания неоновой кнопки
local function createNeonButton(text, parent, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 180, 0, 35)
    button.Position = UDim2.new(0, 10, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(0, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.GothamBold
    button.Parent = parent

    -- Неоновый эффект
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(0, 255, 255)
    stroke.Transparency = 0.5
    stroke.Parent = button

    button.MouseButton1Click:Connect(callback)
    return button
end

-- Создание главного окна
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 250)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Затенение / свечение
local glow = Instance.new("Frame")
glow.Size = MainFrame.Size + UDim2.new(0, 10, 0, 10)
glow.Position = MainFrame.Position - UDim2.new(0, 5, 0, 5)
glow.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
glow.BackgroundTransparency = 0.9
glow.BorderSizePixel = 0
glow.Parent = ScreenGui

local cornerGlow = Instance.new("UICorner")
cornerGlow.CornerRadius = UDim.new(0, 12)
cornerGlow.Parent = glow

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = MainFrame

-- Кнопка для сворачивания
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -40, 0, 5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
minimizeButton.Text = "_"
minimizeButton.TextColor3 = Color3.fromRGB(0, 255, 255)
minimizeButton.TextSize = 20
minimizeButton.BorderSizePixel = 0
minimizeButton.Parent = MainFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minimizeButton

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "⚡ НЕОНОВЫЙ ФЛИНГ ⚡"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Поле для ввода никнеймов
local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(0, 330, 0, 40)
InputBox.Position = UDim2.new(0, 10, 0, 40)
InputBox.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
InputBox.BorderSizePixel = 0
InputBox.Text = ""
InputBox.PlaceholderText = "Никнеймы через запятую (игнорировать)"
InputBox.TextColor3 = Color3.fromRGB(200, 200, 255)
InputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 150)
InputBox.Font = Enum.Font.Gotham
InputBox.TextSize = 14
InputBox.TextXAlignment = Enum.TextXAlignment.Left
InputBox.ClearTextOnFocus = false
InputBox.Parent = MainFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = InputBox

-- Кнопка запуска/остановки
local toggleButton = createNeonButton("▶ ЗАПУСТИТЬ ФЛИНГ", MainFrame, nil)
toggleButton.Position = UDim2.new(0, 10, 0, 95)

-- Статус
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0, 330, 0, 30)
StatusLabel.Position = UDim2.new(0, 10, 0, 145)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Статус: Остановлен"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 14
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainFrame

-- Статистика
local StatsLabel = Instance.new("TextLabel")
StatsLabel.Size = UDim2.new(0, 330, 0, 30)
StatsLabel.Position = UDim2.new(0, 10, 0, 180)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Text = "Всего игроков: 0 | Игнорируется: 0"
StatsLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
StatsLabel.TextSize = 12
StatsLabel.Font = Enum.Font.Gotham
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
StatsLabel.Parent = MainFrame

-- Логика сворачивания
local isMinimized = false
local originalSize = MainFrame.Size
local originalGlowSize = glow.Size
local content = {InputBox, toggleButton, StatusLabel, StatsLabel, Title}

minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame.Size = UDim2.new(0, 350, 0, 40)
        glow.Size = UDim2.new(0, 360, 0, 50)
        minimizeButton.Text = "+"
        for _, v in pairs(content) do
            v.Visible = false
        end
        Title.Visible = true
        Title.Size = UDim2.new(1, -40, 0, 40)
        Title.Text = "⚡ НЕОНОВЫЙ ФЛИНГ [СВЕРНУТ] ⚡"
    else
        MainFrame.Size = originalSize
        glow.Size = originalGlowSize
        minimizeButton.Text = "_"
        for _, v in pairs(content) do
            v.Visible = true
        end
        Title.Size = UDim2.new(1, 0, 0, 30)
        Title.Text = "⚡ НЕОНОВЫЙ ФЛИНГ ⚡"
    end
end)

-- ОСНОВНАЯ ЛОГИКА ФЛИНГА
local isFlinging = false
local flingLoopConnection = nil
local ignoreList = {}

-- Функция для получения защищенных игроков
local function getIgnoredPlayers()
    local inputText = InputBox.Text
    local names = {}
    if inputText ~= "" then
        for name in string.gmatch(inputText, "([^,]+)") do
            local trimmed = name:gsub("^%s*(.-)%s*$", "%1")
            if trimmed ~= "" then
                table.insert(names, string.lower(trimmed))
            end
        end
    end
    return names
end

-- Обновление статистики
local function updateStats()
    local total = #Players:GetPlayers()
    local ignored = #getIgnoredPlayers()
    StatsLabel.Text = "Всего игроков: " .. total .. " | Игнорируется: " .. ignored
end

-- Функция флинга для одного игрока
local function flingPlayer(player)
    if not player or player == LocalPlayer then return end
    if not player.Character then return end

    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    -- Меняем владельца сети на nil, чтобы сервер не блокировал изменения
    rootPart:SetNetworkOwner(nil)

    -- Огромная скорость для мощного флинга
    local flingVelocity = Vector3.new(
        math.random(-500, 500),
        math.random(300, 800),
        math.random(-500, 500)
    )

    -- Применяем скорость
    rootPart.AssemblyLinearVelocity = flingVelocity
    rootPart.AssemblyAngularVelocity = Vector3.new(
        math.random(-100, 100),
        math.random(-100, 100),
        math.random(-100, 100)
    )

    -- Возвращаем владельца обратно игроку (опционально, но помогает стабильности)
    task.wait(0.1)
    rootPart:SetNetworkOwner(player)
end

-- Основной цикл флинга
local function flingAllPlayers()
    local ignoredNames = getIgnoredPlayers()
    local players = Players:GetPlayers()

    local flingCount = 0
    for _, player in ipairs(players) do
        if player ~= LocalPlayer and player.Character then
            local isIgnored = false
            for _, name in ipairs(ignoredNames) do
                if string.lower(player.Name) == name then
                    isIgnored = true
                    break
                end
            end
            if not isIgnored then
                flingPlayer(player)
                flingCount = flingCount + 1
            end
        end
    end

    StatusLabel.Text = "Статус: Флинг выполнен (" .. flingCount .. " игроков)"
    updateStats()
end

-- Запуск/остановка
local function startFling()
    if isFlinging then return end
    isFlinging = true
    toggleButton.Text = "⏹ ОСТАНОВИТЬ"
    toggleButton.TextColor3 = Color3.fromRGB(255, 100, 100)

    -- Меняем обводку на красную
    local stroke = toggleButton:FindFirstChildWhichIsA("UIStroke")
    if stroke then
        stroke.Color = Color3.fromRGB(255, 100, 100)
    end

    StatusLabel.Text = "Статус: Запущен (каждые 10 сек)"
    updateStats()

    -- Первый флинг сразу
    task.spawn(flingAllPlayers)

    -- Цикл каждые 10 секунд
    flingLoopConnection = RunService.Heartbeat:Connect(function()
        if not isFlinging then return end
        -- Считаем время между флингами вручную через tick()
        if not flingLoopConnection._lastFling then
            flingLoopConnection._lastFling = tick()
        end
        if tick() - flingLoopConnection._lastFling >= 10 then
            flingLoopConnection._lastFling = tick()
            task.spawn(flingAllPlayers)
        end
    end)
end

local function stopFling()
    if not isFlinging then return end
    isFlinging = false
    if flingLoopConnection then
        flingLoopConnection:Disconnect()
        flingLoopConnection = nil
    end

    toggleButton.Text = "▶ ЗАПУСТИТЬ ФЛИНГ"
    toggleButton.TextColor3 = Color3.fromRGB(0, 255, 255)
    local stroke = toggleButton:FindFirstChildWhichIsA("UIStroke")
    if stroke then
        stroke.Color = Color3.fromRGB(0, 255, 255)
    end
    StatusLabel.Text = "Статус: Остановлен"
end

-- Обработчик кнопки
toggleButton.MouseButton1Click:Connect(function()
    if isFlinging then
        stopFling()
    else
        startFling()
    end
end)

-- Автоматическое обновление статистики при изменении текста
InputBox:GetPropertyChangedSignal("Text"):Connect(function()
    updateStats()
end)

-- Обновление при изменении списка игроков
Players.PlayerAdded:Connect(function()
    updateStats()
end)
Players.PlayerRemoving:Connect(function()
    updateStats()
end)

-- Остановка при уничтожении GUI
ScreenGui.AncestryChanged:Connect(function()
    if not ScreenGui.Parent then
        stopFling()
    end
end)

-- Первоначальное обновление
updateStats()

print("⚡ Неоновый Fling GUI загружен! Введи никнеймы через запятую для защиты.")
