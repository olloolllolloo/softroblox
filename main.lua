-- ФЛИНГ + ТЕЛЕПОРТ БЕЗ ОТСТАВАНИЯ
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
Title.Text = "FLING + TP (NO DELAY)"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

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

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, 0, 0, 20)
StatusText.Position = UDim2.new(0, 0, 0, 120)
StatusText.BackgroundTransparency = 1
StatusText.Text = ""
StatusText.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusText.TextSize = 12
StatusText.Font = Enum.Font.Gotham
StatusText.Parent = MainFrame

local isActive = false
local connection = nil
local targetIndex = 1
local switchTimer = 0

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

-- ГЛАВНЫЙ ЦИКЛ - ИСПОЛЬЗУЕМ RenderStepped (60 FPS)
local function mainLoop(deltaTime)
    if not isActive then return end
    
    local myChar = player.Character
    if not myChar then return end
    
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    
    local targets = getTargets()
    
    if #targets == 0 then
        StatusText.Text = "Нет целей..."
        return
    end
    
    -- Переключение цели каждые 3 секунды
    switchTimer = switchTimer + deltaTime
    if switchTimer >= 3 then
        switchTimer = 0
        targetIndex = targetIndex + 1
        if targetIndex > #targets then
            targetIndex = 1
        end
    end
    
    local target = targets[targetIndex]
    if not target or not target.Character then return end
    
    local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end
    
    -- МГНОВЕННЫЙ ТЕЛЕПОРТ (без task.wait вообще)
    pcall(function()
        myHRP.CFrame = targetHRP.CFrame
    end)
    
    -- МГНОВЕННЫЙ ФЛИНГ
    pcall(function()
        myHRP.Velocity = myHRP.Velocity * 55000 + Vector3.new(0, 55000, 0)
    end)
    
    -- ЗАХВАТ ЦЕЛИ
    pcall(function()
        targetHRP:SetNetworkOwner(nil)
        targetHRP.Anchored = false
        targetHRP.Velocity = Vector3.new(
            math.random(-99999, 99999),
            math.random(99999, 999999),
            math.random(-99999, 99999)
        )
    end)
    
    StatusText.Text = "💀 " .. target.Name .. " (" .. targetIndex .. "/" .. #targets .. ") | " .. string.format("%.1f", 3 - switchTimer) .. "с"
end

local function start()
    if isActive then return end
    isActive = true
    switchTimer = 0
    targetIndex = 1
    
    connection = RunService.RenderStepped:Connect(mainLoop)
    
    FlingBtn.Text = "!FLING + TP ON"
    FlingBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
end

local function stop()
    isActive = false
    
    if connection then
        connection:Disconnect()
        connection = nil
    end
    
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Velocity = Vector3.new(0, 0, 0)
        hrp.RotVelocity = Vector3.new(0, 0, 0)
    end
    
    FlingBtn.Text = "!FLING + TP OFF"
    FlingBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    StatusText.Text = "Остановлен"
end

FlingBtn.MouseButton1Click:Connect(function()
    if isActive then
        stop()
    else
        start()
    end
end)
