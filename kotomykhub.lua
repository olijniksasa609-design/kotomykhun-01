local coreGui = game:GetService("CoreGui")
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera

-- Видаляємо стару версію
if coreGui:FindFirstChild("KotomYkHub") then coreGui.KotomYkHub:Destroy() end

-- Налаштування
local aimbotEnabled = false
local espActive = false
local fovRadius = 100

-- Малюємо коло FOV (тільки для читів)
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1
fovCircle.NumSides = 64
fovCircle.Radius = fovRadius
fovCircle.Filled = false
fovCircle.Visible = false
fovCircle.Color = Color3.fromRGB(255, 255, 255)

-- Створюємо GUI
local screenGui = Instance.new("ScreenGui", coreGui)
screenGui.Name = "KotomYkHub"

local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 220, 0, 260) -- Трохи збільшив висоту
main.Position = UDim2.new(0.5, -110, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "KOTOMYK HUB PRO"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", title)

-- Функція для створення кнопок (щоб код був красивим)
local function createButton(name, pos, text)
    local btn = Instance.new("TextButton", main)
    btn.Name = name
    btn.Size = UDim2.new(0.8, 0, 0, 35)
    btn.Position = pos
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", btn)
    return btn
end

local espBtn = createButton("ESPBtn", UDim2.new(0.1, 0, 0.2, 0), "ESP: OFF")
local aimBtn = createButton("AimBtn", UDim2.new(0.1, 0, 0.37, 0), "AIM: OFF")

-- Текст та кнопки FOV
local fovLabel = Instance.new("TextLabel", main)
fovLabel.Size = UDim2.new(0.8, 0, 0, 20)
fovLabel.Position = UDim2.new(0.1, 0, 0.55, 0)
fovLabel.Text = "FOV Radius: " .. fovRadius
fovLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
fovLabel.BackgroundTransparency = 1

local fovPlus = createButton("FovPlus", UDim2.new(0.1, 0, 0.65, 0), "+ FOV")
fovPlus.Size = UDim2.new(0.35, 0, 0, 30)
local fovMinus = createButton("FovMinus", UDim2.new(0.55, 0, 0.65, 0), "- FOV")
fovMinus.Size = UDim2.new(0.35, 0, 0, 30)

-- Логіка кнопок
espBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    espBtn.Text = espActive and "ESP: ON" or "ESP: OFF"
    espBtn.BackgroundColor3 = espActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

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

-- Функція пошуку цілі
local function getClosestPlayer()
    local target = nil
    local shortestDistance = fovRadius
    for _, v in pairs(players:GetPlayers()) do
        if v ~= localPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
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

-- Постійний цикл
runService.RenderStepped:Connect(function()
    fovCircle.Position = userInputService:GetMouseLocation()
    
    for _, p in pairs(players:GetPlayers()) do
        if p ~= localPlayer and p.Character then
            -- Логіка ESP
            local hl = p.Character:FindFirstChild("KotomHighlight")
            if espActive then
                if not hl then
                    hl = Instance.new("Highlight", p.Character)
                    hl.Name = "KotomHighlight"
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
                hl.Enabled = true
            elseif hl then
                hl.Enabled = false
            end
        end
    end

    -- Логіка Aim (на ПРАВУ кнопку миші)
    if aimbotEnabled then
        local target = getClosestPlayer()
        if target and userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
        end
    end
end)
