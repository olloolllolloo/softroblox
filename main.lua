-- 💗 СЕРВЕРНЫЙ ФЛИНГ + ТП (РОЗОВАЯ КНОПКА) 💗
-- Телепорт теперь виден серверу через SetNetworkOwner(nil)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

if not player.Character then
    player.CharacterAdded:Wait()
end

-- ==================== GUI ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlingGUI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 160)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -80)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 24)
Title.BackgroundTransparency = 1
Title.Text = "💗 NEW SERVER FLING 💗"
Title.TextColor3 = Color3.fromRGB(255, 105, 180)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(0, 220, 0, 30)
InputBox.Position = UDim2.new(0.5, -110, 0, 30)
InputBox.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
InputBox.BorderSizePixel = 0
InputBox.Text = ""
InputBox.PlaceholderText = "Никнеймы через запятую"
InputBox.TextColor3 = Color3.fromRGB(200, 200, 255)
InputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 180)
InputBox.Font = Enum.Font.Gotham
InputBox.TextSize = 11
InputBox.ClearTextOnFocus = false
InputBox.Parent = MainFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 6)
InputCorner.Parent = InputBox

local FlingBtn = Instance.new("TextButton")
FlingBtn.Size = UDim2.new(0, 220, 0, 45)
FlingBtn.Position = UDim2.new(0.5, -110, 0, 70)
FlingBtn.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
FlingBtn.Text = "💗 FLING OFF"
FlingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlingBtn.TextSize = 17
FlingBtn.Font = Enum.Font.GothamBold
FlingBtn.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 10)
BtnCorner.Parent = FlingBtn

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, 0, 0, 20)
StatusText.Position = UDim2.new(0, 0, 0, 125)
StatusText.BackgroundTransparency = 1
StatusText.Text = ""
StatusText.TextColor3 = Color3.fromRGB(255, 192, 203)
StatusText.TextSize = 11
StatusText.Font = Enum.Font.Gotham
StatusText.TextXAlignment = Enum.TextXAlignment.Center
StatusText.Parent = MainFrame

-- ==================== ПЕРЕМЕННЫЕ ====================
local isActive = false
local connection = nil
local targetIndex = 1
local timer = 0
local flingPhase = 0
local flingLastVel = Vector3.zero
local flingMovel = 0.1

-- ==================== ФУНКЦИИ ====================
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

-- ==================== ГЛАВНЫЙ ЦИКЛ (СЕРВЕРНЫЙ ТЕЛЕПОРТ) ====================
local function mainLoop(deltaTime)
    if not isActive then return end

    local myChar = player.Character
    if not myChar then return end
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end

    local targets = getTargets()
    if #targets == 0 then
        StatusText.Text = "😞 Нет целей"
        return
    end

    -- Переключение цели каждые 3 секунды
    timer = timer + deltaTime
    if timer >= 3 then
        timer = timer - 3
        targetIndex = targetIndex % #targets + 1
    end
    if targetIndex > #targets then targetIndex = 1 end

    local target = targets[targetIndex]
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local targetHRP = target.Character.HumanoidRootPart

        -- 1. ЗАХВАТЫВАЕМ ВЛАДЕНИЕ СВОЕЙ HRP (чтобы сервер увидел телепорт)
        pcall(function()
            myHRP:SetNetworkOwner(nil)
        end)

        -- 2. СЕРВЕРНЫЙ ТЕЛЕПОРТ ВНУТРЬ ЦЕЛИ
        pcall(function()
            myHRP.CFrame = targetHRP.CFrame
        end)

        -- 3. ЗАХВАТЫВАЕМ ВЛАДЕНИЕ ЦЕЛИ И ФЛИНГАЕМ ЕЁ
        pcall(function()
            targetHRP:SetNetworkOwner(nil)
            targetHRP.Anchored = false
            targetHRP.Velocity = Vector3.new(
                math.random(-99999, 99999),
                math.random(99999, 999999),
                math.random(-99999, 99999)
            )
        end)

        -- 4. ФЛИНГ-ВИБРАЦИЯ (как в оригинале, для усиления)
        if flingPhase == 0 then
            flingLastVel = myHRP.Velocity
            myHRP.Velocity = flingLastVel * 55000 + Vector3.new(0, 55000, 0)
            flingPhase = 1
        elseif flingPhase == 1 then
            myHRP.Velocity = flingLastVel
            flingPhase = 2
        elseif flingPhase == 2 then
            myHRP.Velocity = flingLastVel + Vector3.new(0, flingMovel, 0)
            flingMovel = flingMovel * -1
            flingPhase = 3
        else
            flingPhase = 0
        end

        -- Возвращаем владение цели и себе (чтобы не глючило)
        pcall(function()
            if targetHRP and targetHRP.Parent then
                targetHRP:SetNetworkOwner(target)
            end
            if myHRP and myHRP.Parent then
                myHRP:SetNetworkOwner(player)
            end
        end)

        StatusText.Text = "💀 " .. target.Name .. " [" .. targetIndex .. "/" .. #targets .. "]  " .. string.format("%.1f", 3 - (timer % 3)) .. "с"
    end
end

-- ==================== ЗАПУСК / ОСТАНОВКА ====================
local function start()
    if isActive then return end
    isActive = true
    timer = 0
    targetIndex = 1
    flingPhase = 0
    flingMovel = 0.1

    connection = RunService.RenderStepped:Connect(mainLoop)

    FlingBtn.Text = "💗 FLING ON"
    FlingBtn.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
    StatusText.Text = "Запуск..."
end

local function stop()
    isActive = false
    if connection then
        connection:Disconnect()
        connection = nil
    end

    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Velocity = Vector3.zero
        hrp.RotVelocity = Vector3.zero
    end

    FlingBtn.Text = "💗 FLING OFF"
    FlingBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    StatusText.Text = "Остановлен"
end

FlingBtn.MouseButton1Click:Connect(function()
    if isActive then
        stop()
    else
        start()
    end
end)

print("💗 СЕРВЕРНЫЙ ФЛИНГ + ТП ЗАГРУЖЕН! (телепорт виден всем)")
