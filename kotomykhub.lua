local player = game.Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")

-- 1. СТВОРЕННЯ ІНТЕРФЕЙСУ (GUI) АВТОМАТИЧНО
local screenGui = script.Parent -- Використовуємо твій існуючий ScreenGui
if not screenGui:IsA("ScreenGui") then
	screenGui = Instance.new("ScreenGui", pGui)
end

-- Основне вікно
local mainFrame = Instance.new("Frame")
mainFrame.Name = "CheatMenu"
mainFrame.Size = UDim2.new(0, 200, 0, 100)
mainFrame.Position = UDim2.new(0.5, -100, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 2
mainFrame.Active = true
mainFrame.Draggable = true -- Меню можна перетягувати мишкою
mainFrame.Parent = screenGui

-- Заголовок
local title = Instance.new("TextLabel")
title.Text = "KOTOMYK HUB"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = mainFrame

-- Кнопка ESP
local espButton = Instance.new("TextButton")
espButton.Name = "ESPButton"
espButton.Text = "ESP: OFF"
espButton.Size = UDim2.new(0.8, 0, 0, 40)
espButton.Position = UDim2.new(0.1, 0, 0.45, 0)
espButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.Font = Enum.Font.SourceSansBold
espButton.TextSize = 18
espButton.Parent = mainFrame

-- 2. ЛОГІКА ВХ (ESP)
local espActive = false

local function updateESP()
	for _, otherPlayer in pairs(game.Players:GetPlayers()) do
		if otherPlayer ~= player and otherPlayer.Character then
			local char = otherPlayer.Character
			local highlight = char:FindFirstChild("ESPHighlight")

			if espActive then
				if not highlight then
					highlight = Instance.new("Highlight")
					highlight.Name = "ESPHighlight"
					highlight.Parent = char
				end
				highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				highlight.FillColor = Color3.fromRGB(255, 0, 0)
				highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
				highlight.Enabled = true
			elseif highlight then
				highlight.Enabled = false
			end
		end
	end
end

-- Обробка кнопки
espButton.MouseButton1Click:Connect(function()
	espActive = not espActive

	if espActive then
		espButton.Text = "ESP: ON"
		espButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
	else
		espButton.Text = "ESP: OFF"
		espButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	end

	updateESP()
end)

-- Постійне оновлення (щоб підсвітка не зникала при респавні)
task.spawn(function()
	while task.wait(2) do
		if espActive then
			updateESP()
		end
	end
end)