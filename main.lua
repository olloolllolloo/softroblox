-- НЕОНОВЫЙ ФЛИНГ - ФИНАЛЬНАЯ ВЕРСИЯ
-- Вы НЕ улетаете, только флингаете других

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

-- СОЗДАНИЕ GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NeonFlingGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 250)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local GlowFrame = Instance.new("Frame")
GlowFrame.Size = MainFrame.Size + UDim2.new(0, 8, 0, 8)
GlowFrame.Position = MainFrame.Position - UDim2.new(0, 4, 0, 4)
GlowFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
GlowFrame.BackgroundTransparency = 0.85
GlowFrame.BorderSizePixel = 0
GlowFrame.Parent = ScreenGui

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 12)
glowCorner.Parent = GlowFrame

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = MainFrame

local function createNeonButton(text, parent, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 200, 0, 40)
    btn.Position = UDim2.new(0.5, -100, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 0, 0)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(255, 0, 0)
    stroke.Transparency = 0.6
    stroke.Parent = btn
    
    return btn
end

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.Text = "💀 АГРЕССИВНЫЙ ФЛИНГ 💀"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -40, 0, 3)
MinBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
MinBtn.BackgroundTransparency = 0.5
MinBtn.Text = "_"
MinBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
MinBtn.TextSize = 20
MinBtn.BorderSizePixel = 0
MinBtn.Parent = MainFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = MinBtn

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

local ProgressLabel = Instance.new("TextLabel")
ProgressLabel.Size = UDim2.new(0, 260, 0, 22)
ProgressLabel.Position = UDim2.new(0.5, -130, 0, 118)
ProgressLabel.BackgroundTransparency = 1
ProgressLabel.Text = "Ожидание..."
ProgressLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ProgressLabel.TextSize = 12
ProgressLabel.Font = Enum.Font.Gotham
ProgressLabel.TextXAlignment = Enum.TextXAlignment.Left
ProgressLabel.Parent = MainFrame

local FlingBtn = createNeonButton("▶ ЗАПУСТИТЬ ФЛИНГ", MainFrame, 150)

local InfoText = Instance.new("TextLabel")
InfoText.Size = UDim2.new(0, 260, 0, 25)
InfoText.Position = UDim2.new(0.5, -130, 0, 200)
InfoText.BackgroundTransparency = 1
InfoText.Text = "3 сек на игрока | Вы не улетаете"
InfoText.TextColor3 = Color3.fromRGB(80, 80, 120)
InfoText.TextSize = 11
InfoText.Font = Enum.Font.Gotham
InfoText.TextXAlignment = Enum.TextXAlignment.Left
InfoText.Parent = MainFrame

-- Переменные
local isFlinging = false
local flingConnection = nil

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
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local isIgnored = false
            for _, name in ipairs(ignoreList) do
                if player.Name:lower() == name then
                    isIgnored = true
                    break
                end
            end
            if not isIgnored then
                table.insert(targets, player)
            end
        end
    end
    
    return targets
end

-- ФЛИНГ БЕЗ ТЕЛЕПОРТАЦИИ ВАС
local function flingTargetOnly(targetPlayer)
    if not targetPlayer or targetPlayer == LocalPlayer then return false end
    
    local targetChar = targetPlayer.Character
    if not targetChar then return false end
    
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return false end
    
    local targetHumanoid = targetChar:FindFirstChild("Humanoid")
    if not targetHumanoid or targetHumanoid.Health <= 0 then return false end
    
    -- Захватываем сетевое владение ТОЛЬКО цели
    pcall(function()
        targetHRP:SetNetworkOwner(nil)
        targetHRP.Anchored = false
    end)
    
    -- Флингуем ТОЛЬКО цель
    pcall(function()
        targetHRP.Velocity = Vector3.new(
            math.random(-100000, 100000),
            math.random(50000, 150000),
            math.random(-100000, 100000)
        )
        targetHRP.RotVelocity = Vector3.new(
            math.random(-10000, 10000),
            math.random(-10000, 10000),
            math.random(-10000, 10000)
        )
        targetHRP.AssemblyLinearVelocity = Vector3.new(
            math.random(-100000, 100000),
            math.random(50000, 150000),
            math.random(-100000, 100000)
        )
    end)
    
    -- Флингуем части тела ТОЛЬКО цели
    for _, part in ipairs(targetChar:GetChildren()) do
        if part:IsA("BasePart") and part ~= targetHRP then
            pcall(function()
                part.Velocity = Vector3.new(
                    math.random(-100000, 100000),
                    math.random(50000, 150000),
                    math.random(-100000, 100000)
                )
                part.RotVelocity = Vector3.new(
                    math.random(-5000, 5000),
                    math.random(-5000, 5000),
                    math.random(-5000, 5000)
                )
            end)
        end
    end
    
    -- Вырубаем Humanoid цели
    pcall(function()
        targetHumanoid.Sit = true
        targetHumanoid.PlatformStand = true
    end)
    
    return true
end

-- ЗАЩИТА ВАШЕГО ПЕРСОНАЖА ОТ ФЛИНГА
local function protectMyself()
    local myChar = LocalPlayer.Character
    if not myChar then return end
    
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    
    -- Обнуляем скорость СЕБЯ каждый кадр
    pcall(function()
        myHRP.Velocity = Vector3.new(0, 0, 0)
        myHRP.RotVelocity = Vector3.new(0, 0, 0)
        myHRP.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        myHRP.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end)
    
    -- Обнуляем скорость всех своих частей
    for _, part in ipairs(myChar:GetChildren()) do
        if part:IsA("BasePart") then
            pcall(function()
                part.Velocity = Vector3.new(0, 0, 0)
                part.RotVelocity = Vector3.new(0, 0, 0)
            end)
        end
    end
    
    -- Возвращаем себе сетевое владение
    pcall(function()
        myHRP:SetNetworkOwner(LocalPlayer)
        myHRP.Anchored = false
    end)
end

-- Основной цикл
local function flingLoop()
    local targetIndex = 1
    local targets = getTargets()
    local timeOnTarget = 0
    
    if #targets == 0 then
        StatusText.Text = "⚠ НЕТ ЦЕЛЕЙ"
        StatusText.TextColor3 = Color3.fromRGB(255, 200, 0)
        return
    end
    
    StatusText.Text = "💀 ФЛИНГ АКТИВЕН"
    StatusText.TextColor3 = Color3.fromRGB(255, 0, 0)
    
    flingConnection = RunService.RenderStepped:Connect(function(deltaTime)
        if not isFlinging then return end
        
        -- СНАЧАЛА ЗАЩИЩАЕМ СЕБЯ
        protectMyself()
        
        timeOnTarget = timeOnTarget + deltaTime
        targets = getTargets()
        
        if #targets == 0 then
            ProgressLabel.Text = "Нет целей..."
            return
        end
        
        if timeOnTarget >= 3 then
            timeOnTarget = 0
            targetIndex = targetIndex + 1
            if targetIndex > #targets then
                targetIndex = 1
            end
        end
        
        local target = targets[targetIndex]
        if target then
            ProgressLabel.Text = "💀 " .. target.Name .. " (" .. targetIndex .. "/" .. #targets .. ") | " .. string.format("%.1f", 3 - timeOnTarget) .. "с"
            flingTargetOnly(target)
        end
    end)
end

local function startFlinging()
    if isFlinging then return end
    isFlinging = true
    
    FlingBtn.Text = "⏹ ОСТАНОВИТЬ"
    FlingBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    
    flingLoop()
end

local function stopFlinging()
    isFlinging = false
    
    if flingConnection then
        flingConnection:Disconnect()
        flingConnection = nil
    end
    
    FlingBtn.Text = "▶ ЗАПУСТИТЬ ФЛИНГ"
    FlingBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
    StatusText.Text = "● СТАТУС: ОСТАНОВЛЕН"
    StatusText.TextColor3 = Color3.fromRGB(255, 100, 100)
    ProgressLabel.Text = "Остановлен"
end

FlingBtn.MouseButton1Click:Connect(function()
    if isFlinging then
        stopFlinging()
    else
        startFlinging()
    end
end)

local minimized = false
local originalSize = MainFrame.Size
local originalGlowSize = GlowFrame.Size
local elementsToHide = {}

MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        elementsToHide = {InputBox, StatusText, FlingBtn, InfoText, ProgressLabel}
        for _, elem in ipairs(elementsToHide) do
            elem.Visible = false
        end
        MainFrame.Size = UDim2.new(0, 300, 0, 50)
        GlowFrame.Size = UDim2.new(0, 308, 0, 58)
        MinBtn.Text = "+"
        Title.Text = "💀 АГРЕССИВНЫЙ ФЛИНГ [▼]"
    else
        MainFrame.Size = originalSize
        GlowFrame.Size = originalGlowSize
        MinBtn.Text = "_"
        for _, elem in ipairs(elementsToHide) do
            elem.Visible = true
        end
        Title.Text = "💀 АГРЕССИВНЫЙ ФЛИНГ 1.7💀"
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    stopFlinging()
    ScreenGui:Destroy()
end)

print("💀 АГРЕССИВНЫЙ ФЛИНГ ЗАГРУЖЕН!")
print("🛡 ВЫ НЕ УЛЕТАЕТЕ - защита от флинга себя!")
print("🎯 Флингует только других игроков!")
