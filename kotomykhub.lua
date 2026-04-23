-- Визначаємо куди пхати меню: в CoreGui для читів, або в PlayerGui для Studio
local parentObj = nil
local success, coreGui = pcall(function() return game:GetService("CoreGui") end)

if success and coreGui then
    parentObj = coreGui
else
    parentObj = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

-- Видаляємо стару версію, щоб не плодити копії
local oldUI = parentObj:FindFirstChild("KotomYkHub")
if oldUI then oldUI:Destroy() end

-- Створюємо ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KotomYkHub"
screenGui.Parent = parentObj
screenGui.ResetOnSpawn = false

-- Головне вікно
local mainFrame = Instance.new("Frame")
mainFrame.Name = "Main"
mainFrame.Size = UDim2.new(0, 200, 0, 120)
mainFrame.Position = UDim2.new(0.5, -100, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Active = true
mainFrame.Draggable = true 
mainFrame.Parent = screenGui

-- Закруглення
local corner = Instance.new("UICorner", mainFrame)

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "KOTOMYK HUB"
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = mainFrame

-- Кнопка
local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0.8, 0, 0, 40)
espButton.Position = UDim2.new(0.1, 0, 0.45, 0)
espButton.Text = "ESP: OFF"
espButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.Parent = mainFrame

-- Логіка
local espActive = false
espButton.MouseButton1Click:Connect(function()
    espActive = not espActive
    espButton.Text = espActive and "ESP: ON" or "ESP: OFF"
    espButton.BackgroundColor3 = espActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer and p.Character then
            local hl = p.Character:FindFirstChild("ESPHl") or Instance.new("Highlight", p.Character)
            hl.Name = "ESPHl"
            hl.Enabled = espActive
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        end
    end
end)

print("KOTOMYK HUB: Ready for Studio and Solara!")
