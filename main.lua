local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local TARGET_NAME = "morphix46"

-- Функция жесткой физической склейки
local function hardAttach()
    local myChar = LocalPlayer.Character
    if not myChar then return end
    
    -- Убираем гуманоид, чтобы отключить просчет стандартного движения Roblox
    local humanoid = myChar:FindFirstChildOfClass("Humanoid")
    if humanoid then 
        humanoid:Destroy() 
    end
    
    local myHRP = myChar:WaitForChild("HumanoidRootPart", 5)
    if not myHRP then return end

    -- Очищаем старые физические соединения, если они были
    for _, obj in ipairs(myHRP:GetChildren()) do
        if obj:IsA("Attachment") or obj:IsA("AlignPosition") or obj:IsA("AlignOrientation") then
            obj:Destroy()
        end
    end

    -- Создаем локальную физическую привязку
    local myAttachment = Instance.new("Attachment")
    myAttachment.Name = "LocalFollowAttachment"
    myAttachment.Parent = myHRP

    -- Основной цикл, который намертво удерживает вас в хитбоксе цели перед рендером каждого кадра
    local connection
    connection = RunService.RenderStepped:Connect(function()
        local targetPlayer = Players:FindFirstChild(TARGET_NAME)
        
        -- Если цель или ваш персонаж пропали/умерли — сбрасываем цикл
        if not targetPlayer or not targetPlayer.Character or not myChar.Parent then
            connection:Disconnect()
            return
        end
        
        local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetHRP then
            -- Намертво гасим любую скорость, чтобы античит сервера не лагал
            myHRP.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            myHRP.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            
            -- Принудительное склеивание CFrame без задержек пинга
            myHRP.CFrame = targetHRP.CFrame
        end
    end)
end

-- Запуск привязки
hardAttach()

-- Авто-перепривязка, если ваш персонаж возродился (респнулся)
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5) -- короткая пауза для прогрузки персонажа
    hardAttach()
end)
