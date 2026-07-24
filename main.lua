local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local TARGET_NAME = "morphix46"

RunService.Stepped:Connect(function()
    -- Поиск конкретного игрока по нику
    local targetPlayer = Players:FindFirstChild(TARGET_NAME)
    
    if targetPlayer and targetPlayer.Character then
        local myChar = LocalPlayer.Character
        local targetChar = targetPlayer.Character
        
        if myChar and targetChar then
            local myHRP = myChar:FindFirstChild("HumanoidRootPart")
            local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
            
            if myHRP and targetHRP then
                -- Полное отключение физики и инерции вашего персонажа
                myHRP.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                myHRP.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                
                -- Жесткая фиксация CFrame прямо внутри игрока morphix46
                myHRP.CFrame = targetHRP.CFrame
            end
        end
    end
end)
