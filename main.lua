-- СУПЕР ПРОСТОЙ ФЛИНГ - ОДНА КНОПКА
-- Работает как в вашем Morph Cheat коде

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlingGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 100)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "FLING"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local FlingBtn = Instance.new("TextButton")
FlingBtn.Size = UDim2.new(0, 150, 0, 40)
FlingBtn.Position = UDim2.new(0.5, -75, 0, 45)
FlingBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
FlingBtn.Text = "FLING OFF"
FlingBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
FlingBtn.TextSize = 18
FlingBtn.Font = Enum.Font.GothamBold
FlingBtn.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = FlingBtn

-- ЛОГИКА ФЛИНГА (ТОЧНО КАК В ТВОЁМ КОДЕ)
local States = {
    Fling = false,
    FlingPower = 10000
}

local flingThread = nil

local function flingLoop()
    local hrp, c, vel, movel = nil, nil, nil, 0.1

    while States.Fling do
        RunService.Heartbeat:Wait()

        if States.Fling then
            while States.Fling and not (c and c.Parent and hrp and hrp.Parent) do
                RunService.Heartbeat:Wait()
                c = LocalPlayer.Character
                hrp = c and c:FindFirstChild("HumanoidRootPart")
            end

            if States.Fling and c and c.Parent and hrp and hrp.Parent then
                vel = hrp.Velocity
                hrp.Velocity = vel * States.FlingPower + Vector3.new(0, States.FlingPower, 0)
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
    FlingBtn.Text = "FLING ON"
    FlingBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
end

local function stopFling()
    States.Fling = false
    if flingThread then
        task.cancel(flingThread)
        flingThread = nil
    end

    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Velocity = Vector3.new(0, 0, 0)
        hrp.RotVelocity = Vector3.new(0, 0, 0)
    end

    FlingBtn.Text = "FLING OFF"
    FlingBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
end

FlingBtn.MouseButton1Click:Connect(function()
    if States.Fling then
        stopFling()
    else
        startFling()
    end
end)
