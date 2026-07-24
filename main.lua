-- ФЛИНГ ИЗ ТВОЕГО КОДА - МАКС МОЩНОСТЬ
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

if not player.Character then
    player.CharacterAdded:Wait()
end

-- Простая кнопка
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Fling"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Btn = Instance.new("TextButton")
Btn.Size = UDim2.new(0, 150, 0, 50)
Btn.Position = UDim2.new(0.5, -75, 0.5, -25)
Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Btn.Text = "FLING OFF"
Btn.TextColor3 = Color3.fromRGB(255, 0, 0)
Btn.TextSize = 20
Btn.Font = Enum.Font.GothamBold
Btn.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = Btn

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(255, 0, 0)
Stroke.Thickness = 2
Stroke.Parent = Btn

-- ТОЧНО ТАКОЙ ЖЕ ФЛИНГ КАК В ТВОЁМ КОДЕ
local States = {Fling = false}
local flingThread = nil

local function flingLoop()
    local hrp, c, vel, movel = nil, nil, nil, 0.1

    while States.Fling do
        RunService.Heartbeat:Wait()

        if States.Fling then
            while States.Fling and not (c and c.Parent and hrp and hrp.Parent) do
                RunService.Heartbeat:Wait()
                c = player.Character
                hrp = c and c:FindFirstChild("HumanoidRootPart")
            end

            if States.Fling and c and c.Parent and hrp and hrp.Parent then
                vel = hrp.Velocity
                -- МАКСИМАЛЬНАЯ МОЩНОСТЬ 55000
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

local function startFling()
    if flingThread then
        States.Fling = false
        task.cancel(flingThread)
        flingThread = nil
    end

    States.Fling = true
    flingThread = task.spawn(flingLoop)
    Btn.Text = "FLING ON"
    Btn.TextColor3 = Color3.fromRGB(0, 255, 0)
    Stroke.Color = Color3.fromRGB(0, 255, 0)
end

local function stopFling()
    States.Fling = false
    if flingThread then
        task.cancel(flingThread)
        flingThread = nil
    end

    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Velocity = Vector3.new(0, 0, 0)
        hrp.RotVelocity = Vector3.new(0, 0, 0)
    end

    Btn.Text = "FLING OFF"
    Btn.TextColor3 = Color3.fromRGB(255, 0, 0)
    Stroke.Color = Color3.fromRGB(255, 0, 0)
end

Btn.MouseButton1Click:Connect(function()
    if States.Fling then
        stopFling()
    else
        startFling()
    end
end)
