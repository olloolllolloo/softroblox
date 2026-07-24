-- Создание простого перетаскиваемого интерфейса
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MinimalFollowGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 110)
Frame.Position = UDim2.new(0.5, -110, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderSizePixel = 1
Frame.Active = true
Frame.Draggable = true -- Позволяет переносить интерфейс мышкой
Frame.Parent = ScreenGui

local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(1, 0, 0, 25)
Label.Text = "Введи точный ник:"
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.BackgroundTransparency = 1
Label.Parent = Frame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0.9, 0, 0, 30)
TextBox.Position = UDim2.new(0.05, 0, 0, 30)
TextBox.PlaceholderText = "Никнейм игрока..."
TextBox.Text = ""
TextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.Parent = Frame

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0.9, 0, 0, 35)
Button.Position = UDim2.new(0.05, 0, 0, 65)
Button.Text = "СТАРТ ПРИЛИПАНИЯ"
Button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Font = Enum.Font.SourceSansBold
Button.TextSize = 16
Button.Parent = Frame

-- Логика намертво следующего прилипания
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local targetName = ""
local isFollowing = false
local followConnection = nil

Button.MouseButton1Click:Connect(function()
    if isFollowing then
        -- Отключение
        isFollowing = false
        Button.Text = "СТАРТ ПРИЛИПАНИЯ"
        Button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        if followConnection then
            followConnection:Disconnect()
            followConnection = nil
        end
    else
        -- Включение
        targetName = TextBox.Text
        local targetPlayer = Players:FindFirstChild(targetName)
        
        if targetPlayer and targetPlayer ~= LocalPlayer then
            isFollowing = true
            Button.Text = "СТОП (ПРИЛИПШЕ)"
            Button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            
            -- Самый современный метод: привязка до просчета физики кадров
            followConnection = RunService.Stepped:Connect(function()
                local myChar = LocalPlayer.Character
                local targetChar = targetPlayer.Character
                
                if myChar and targetChar then
                    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
                    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
                    
                    if myHRP and targetHRP then
                        -- Обнуляем скорость, чтобы не было тряски и пинга
                        myHRP.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        myHRP.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        -- Намертво копируем CFrame прямо внутрь игрока
                        myHRP.CFrame = targetHRP.CFrame
                    end
                end
            end)
        else
            Button.Text = "Игрок не найден!"
            task.wait(1)
            if not isFollowing then Button.Text = "СТАРТ ПРИЛИПАНИЯ" end
        end
    end
end)
