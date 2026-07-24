-- Permanent Target Attachment Script
-- Uses event-driven structural alignment

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Config
local TARGET_NAME = "morphix46"
local REFRESH_INTERVAL = 0.05 -- Частота принудительного обновления физического кадра

-- Internal state
local followConnection = nil

-- Helpers
local function getTargetRoot()
    local target = Players:FindFirstChild(TARGET_NAME)
    if target and target.Character then
        return target.Character:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

local function syncPhysics(myHRP, targetHRP)
    if not myHRP or not targetHRP then return end
    
    -- Принудительное обнуление импульса для исключения серверной интерполяции (пинга)
    myHRP.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    myHRP.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    
    -- Прямая запись CFrame, игнорируя буферы рендеринга
    myHRP.CFrame = targetHRP.CFrame
end

local function startAttachment()
    if followConnection then return end
    
    -- Использование PreRender для фиксации позиции до отправки пакетов на сервер
    followConnection = RunService.PreRender:Connect(function()
        local myChar = LocalPlayer.Character
        if not myChar then return end
        
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        local targetHRP = getTargetRoot()
        
        if myHRP and targetHRP then
            syncPhysics(myHRP, targetHRP)
        end
    end)
end

local function setupCharacterListener(char)
    -- Отключение коллизий персонажа для предотвращения десинхронизации хитбоксов
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    startAttachment()
end

-- Event Handling (Аналогично структуре предоставленного ESP)
LocalPlayer.CharacterAdded:Connect(function(char)
    task.delay(0.03, function()
        setupCharacterListener(char)
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    if player.Name == TARGET_NAME and followConnection then
        followConnection:Disconnect()
        followConnection = nil
    end
end)

-- Initial Setup
if LocalPlayer.Character then
    setupCharacterListener(LocalPlayer.Character)
end

-- Periodic Verification Loop
while true do
    task.wait(REFRESH_INTERVAL)
    local targetHRP = getTargetRoot()
    local myChar = LocalPlayer.Character
    
    if targetHRP and myChar then
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        if myHRP then
            syncPhysics(myHRP, targetHRP)
        end
    end
end
