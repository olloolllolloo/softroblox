-- ФЛИНГ + ФОЛЛОУ ТП + СПИСОК ЗАЩИТЫ
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

if not player.Character then
    player.CharacterAdded:Wait()
end

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlingGUI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 160)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -80)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundTransparency = 1
Title.Text = "FLING + FOLLOW TP"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Поле ввода защиты
local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(0, 210, 0, 30)
InputBox.Position = UDim2.new(0.5, -105, 0, 30)
InputBox.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
InputBox.BorderSizePixel = 0
InputBox.Text = ""
InputBox.PlaceholderText = "Никнеймы через запятую"
InputBox.TextColor3 = Color3.fromRGB(200, 200, 255)
InputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 180)
InputBox.Font = Enum.Font.Gotham
InputBox.TextSize = 12
InputBox.ClearTextOnFocus = false
InputBox.Parent = MainFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 5)
InputCorner.Parent = InputBox

-- Кнопка флинга
local FlingBtn = Instance.new("TextButton")
FlingBtn.Size = UDim2.new(0, 210, 0, 40)
FlingBtn.Position = UDim2.new(0.5, -105, 0, 70)
FlingBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
FlingBtn.Text = "FLING + TP OFF"
FlingBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
FlingBtn.TextSize = 16
FlingBtn.Font = Enum.Font.GothamBold
FlingBtn.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = FlingBtn

-- Статус
local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, 0, 0, 20)
StatusText.Position = UDim2.new(0, 0, 0, 120)
StatusText.BackgroundTransparency = 1
StatusText.Text = ""
StatusText.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusText.TextSize = 12
StatusText.Font = Enum.Font.Gotham
StatusText.Parent = MainFrame

-- ПЕРЕМЕННЫЕ
local isActive = false
local flingThread = nil
local followConnection = nil
local currentTargetIndex = 1
local timer = 0
local predictionMultiplier = 0.5 -- Множитель предугадывания (0.5 секунды вперёд)
local lastTargetPos = nil -- Последняя позиция цели для расчёта скорости

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

local function getTargets()
    local ignoreList = getIgnoredList()
    local targets = {}
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            local isIgnored = false
            for _, name in ipairs(ignoreList) do
                if p.Name:lower() == name then
                    isIgnored = true
                    break
                end
            end
            if not isIgnored and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(targets, p)
            end
        end
    end
    
    return targets
end

-- ФЛИНГ (ТОЧНО КАК В ТВОЁМ КОДЕ)
local function doFling()
    local hrp, c, vel, movel = nil, nil, nil, 0.1
    
    while isActive do
        RunService.Heartbeat:Wait()
        
        if isActive then
            while isActive and not (c and c.Parent and hrp and hrp.Parent) do
                RunService.Heartbeat:Wait()
                c = player.Character
                hrp = c and c:FindFirstChild("HumanoidRootPart")
            end
            
            if isActive and c and c.Parent and hrp and hrp.Parent then
                vel = hrp.Velocity
                hrp.Velocity = vel * 55000 + Vector3.new(0, 55000, 0)
                RunService.RenderStepped:Wait()
                
                if c and c.Parent and hrp and hrp.Parent then
                    hrp.Velocity = vel
                end
                
                RunService.Stepped:Wait()
                
                if c and c.Parent and hrp and hrp.Parent then
                    hrp.Velocity = vel + Vector3.new(0, movel, 0)
                    movel = movel * -1
                end
            end
        end
    end
end

-- ФОЛЛОУ ТП С ПРЕДУГАДЫВАНИЕМ ДВИЖЕНИЯ
local function followTPLoop()
    followConnection = RunService.RenderStepped:Connect(function(deltaTime)
        if not isActive then return end
        
        timer = timer + deltaTime
        
        local targets = getTargets()
        
        if #targets == 0 then
            StatusText.Text = "Нет целей..."
            return
        end
        
        -- Каждые 3 секунды переключаем цель
        if timer >= 3 then
            timer = 0
            currentTargetIndex = currentTargetIndex + 1
            if currentTargetIndex > #targets then
                currentTargetIndex = 1
            end
            lastTargetPos = nil -- Сбрасываем позицию при смене цели
        end
        
        -- Текущая цель
        local target = targets[currentTargetIndex]
        if target and target.Character then
            local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
            local myHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            
            if targetHRP and myHRP then
                local targetPos = targetHRP.Position
                local predictedPos = targetPos
                
                -- Предугадываем будущую позицию на основе скорости движения цели
                if lastTargetPos then
                    local velocity = (targetPos - lastTargetPos) / deltaTime
                    
                    -- Учитываем только горизонтальное движение для точности
                    local horizontalVelocity = Vector3.new(velocity.X, 0, velocity.Z)
                    local speed = horizontalVelocity.Magnitude
                    
                    -- Если цель движется достаточно быстро, предугадываем позицию
                    if speed > 5 then
                        -- Предсказываем позицию на 0.5 секунды вперёд
                        predictedPos = targetPos + horizontalVelocity * predictionMultiplier
                        
                        -- Добавляем немного вертикального предугадывания если цель прыгает
                        if velocity.Y > 10 then
                            predictedPos = predictedPos + Vector3.new(0, velocity.Y * 0.3, 0)
                        end
                    end
                end
                
                -- Сохраняем текущую позицию для следующего кадра
                lastTargetPos = targetPos
                
                -- ТЕЛЕПОРТ С ПРЕДУГАДЫВАНИЕМ
                pcall(function()
                    myHRP.CFrame = CFrame.new(predictedPos)
                end)
                
                StatusText.Text = "💀 " .. target.Name .. " (" .. currentTargetIndex .. "/" .. #targets .. ") | " .. string.format("%.1f", 3 - timer) .. "с | 🎯 Предугадывание"
            end
        end
    end)
end

-- ЗАПУСК
local function start()
    if isActive then return end
    isActive = true
    
    timer = 0
    currentTargetIndex = 1
    lastTargetPos = nil
    
    flingThread = task.spawn(doFling)
    followTPLoop()
    
    FlingBtn.Text = "FLING + TP ON"
    FlingBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
    StatusText.Text = "Запуск..."
end

-- СТОП
local function stop()
    isActive = false
    
    if flingThread then
        task.cancel(flingThread)
        flingThread = nil
    end
    
    if followConnection then
        followConnection:Disconnect()
        followConnection = nil
    end
    
    -- Сбрасываем скорость
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Velocity = Vector3.new(0, 0, 0)
        hrp.RotVelocity = Vector3.new(0, 0, 0)
    end
    
    FlingBtn.Text = "FLING + TP OFF"
    FlingBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    StatusText.Text = "Остановлен"
    
    lastTargetPos = nil
end

FlingBtn.MouseButton1Click:Connect(function()
    if isActive then
        stop()
    else
        start()
    end
end)
