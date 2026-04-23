local coreGui = game:GetService("CoreGui")
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera

if coreGui:FindFirstChild("KotomYkHub") then coreGui.KotomYkHub:Destroy() end

-- Налаштування Аіму
local aimbotEnabled = false
local fovRadius = 100
local fovColor = Color3.fromRGB(255, 255, 255)

-- Малюємо коло FOV
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1
fovCircle.NumSides = 64
fovCircle.Radius = fovRadius
fovCircle.Filled = false
fovCircle.Visible = false
fovCircle.Color = fovColor

-- Створюємо GUI
local screenGui = Instance.new("ScreenGui", coreGui)
screenGui.Name = "KotomYkHub"

local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 220, 0, 220)
main.Position = UDim2.new(0.5, -110, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "KOTOMYK HUB | AIM"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.Font = Enum.Font.SourceSansBold

-- Кнопка Аімботу
local aimBtn = Instance.new("TextButton", main)
aimBtn.Size = UDim2.new(0.8, 0, 0, 35)
aimBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
aimBtn.Text = "AIM: OFF"
aimBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
aimBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", aimBtn)

-- Текст для FOV
local fovLabel = Instance.new("TextLabel", main)
fovLabel.Size = UDim2.new(0.8, 0, 0, 20)
fovLabel.Position = UDim2.new(0.1, 0, 0.45, 0)
fovLabel.Text = "FOV Radius: " .. fovRadius
fovLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
fovLabel.BackgroundTransparency = 1

-- Кнопки зміни FOV
local fovPlus = Instance.new("TextButton", main)
fovPlus.Size = UDim2.new(0.35, 0, 0, 30)
fovPlus.Position = UDim2.new(0.1, 0, 0.6, 0)
fovPlus.Text = "+ FOV"
fovPlus.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
fovPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", fovPlus)

local fovMinus = Instance.new("TextButton", main)
fovMinus.Size = UDim2.new(0.35, 0, 0, 30)
fovMinus.Position = UDim2.new(0.55, 0, 0.6, 0)
fovMinus.Text = "- FOV"
fovMinus.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
fovMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", fovMinus)

-- Логіка кнопок
aimBtn.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    aimBtn.Text = aimbotEnabled and "AIM: ON" or "AIM: OFF"
    aimBtn.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    fovCircle.Visible = aimbotEnabled
end)

fovPlus.MouseButton1Click:Connect(function()
    fovRadius = math.min(fovRadius + 20, 500)
    fovLabel.Text = "FOV Radius: " .. fovRadius
    fovCircle.Radius = fovRadius
end)

fovMinus.MouseButton1Click:Connect(function()
    fovRadius = math.max(fovRadius - 20, 20)
    fovLabel.Text = "FOV Radius: " .. fovRadius
    fovCircle.Radius = fovRadius
end)

-- Функція пошуку найближчої цілі (в тулуб)
local function getClosestPlayer()
    local target = nil
    local shortestDistance = fovRadius

    for _, v in pairs(players:GetPlayers()) do
        if v ~= localPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local pos, onScreen = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - userInputService:GetMouseLocation()).Magnitude
                if distance < shortestDistance then
                    target = v.Character.HumanoidRootPart
                    shortestDistance = distance
                end
            end
        end
    end
    return target
end

-- Постійне оновлення (Аім і Коло)
runService.RenderStepped:Connect(function()
    fovCircle.Position = userInputService:GetMouseLocation()
    
    if aimbotEnabled then
        local target = getClosestPlayer()
        if target and userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then -- Наводка на ПРАВУ кнопку миші
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
        end
    end
end)
