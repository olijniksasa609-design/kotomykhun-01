local coreGui = game:GetService("CoreGui")
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera

-- Повне видалення старих залишків
for _, v in pairs(coreGui:GetChildren()) do
    if v.Name == "KotomYkHub" then v:Destroy() end
end

local aimbotEnabled = false
local espActive = false
local fovRadius = 120

-- Коло FOV
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1
fovCircle.NumSides = 64
fovCircle.Radius = fovRadius
fovCircle.Visible = false
fovCircle.Color = Color3.fromRGB(255, 255, 255)

-- Створюємо GUI
local screenGui = Instance.new("ScreenGui", coreGui)
screenGui.Name = "KotomYkHub"

local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 220, 0, 260)
main.Position = UDim2.new(0.5, -110, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "KOTOMYK HUB | STABLE"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
title.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", title)

local function createButton(pos, text)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0.8, 0, 0, 35)
    btn.Position = pos
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(130, 0, 0)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", btn)
    return btn
end

local espBtn = createButton(UDim2.new(0.1, 0, 0.2, 0), "ESP: OFF")
local aimBtn = createButton(UDim2.new(0.1, 0, 0.37, 0), "AIM: OFF")

-- Логіка кнопок
espBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    espBtn.Text = espActive and "ESP: ON" or "ESP: OFF"
    espBtn.BackgroundColor3 = espActive and Color3.fromRGB(0, 130, 0) or Color3.fromRGB(130, 0, 0)
end)

aimBtn.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    aimBtn.Text = aimbotEnabled and "AIM: ON" or "AIM: OFF"
    aimBtn.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(0, 130, 0) or Color3.fromRGB(130, 0, 0)
    fovCircle.Visible = aimbotEnabled
end)

-- Основний цикл
runService.RenderStepped:Connect(function()
    fovCircle.Position = userInputService:GetMouseLocation()
    
    for _, p in pairs(players:GetPlayers()) do
        if p ~= localPlayer and p.Character then
            local char = p.Character
            local hl = char:FindFirstChild("KotomHighlight")
            
            if espActive then
                if not hl then
                    hl = Instance.new("Highlight", char)
                    hl.Name = "KotomHighlight"
                    hl.FillColor = Color3.fromRGB(255, 0, 0) -- Завжди червоний для надійності
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.5
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
                hl.Enabled = true
            elseif hl then
                hl.Enabled = false
            end
        end
    end

    -- Аім Assist
    if aimbotEnabled and userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = nil
        local shortestDistance = fovRadius
        for _, v in pairs(players:GetPlayers()) do
            if v ~= localPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local pos, onScreen = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - userInputService:GetMouseLocation()).Magnitude
                    if dist < shortestDistance then
                        target = v.Character.HumanoidRootPart
                        shortestDistance = dist
                    end
                end
            end
        end
        if target then
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
        end
    end
end)
