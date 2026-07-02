-- // TOOBERS ULTIMATE EXPLOIT TOOL v8 // --
-- // С ПОЛЁТОМ, ESP, НОКЛИПОМ, СКОРОСТЬЮ И ДРУГИМИ ЧИТАМИ // --

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LogService = game:GetService("LogService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ===== УДАЛЯЕМ СТАРЫЙ GUI =====
if CoreGui:FindFirstChild("ToobersTool") then
    CoreGui:FindFirstChild("ToobersTool"):Destroy()
end

-- ===== ПЕРЕМЕННЫЕ ДЛЯ ЧИТОВ =====
local flyEnabled = false
local flySpeed = 50
local noclipEnabled = false
local speedMultiplier = 1
local infiniteJump = false
local espEnabled = false
local espLines = {}
local espBoxes = {}
local espTexts = {}

local selectedPlayer = nil
local playerList = {}

-- ===== GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ToobersTool"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false
screenGui.Enabled = true

-- ===== ОСНОВНОЕ ОКНО =====
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 850, 0, 620)
frame.Position = UDim2.new(0.5, -425, 0.5, -310)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 32)
frame.BackgroundTransparency = 0.12
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Стеклянная тень
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 12, 1, 12)
shadow.Position = UDim2.new(0, -6, 0, -6)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.6
shadow.BorderSizePixel = 0
shadow.Parent = frame
shadow.ZIndex = -1

-- ===== ЗАГОЛОВОК =====
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.06, 0)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
title.BackgroundTransparency = 0.3
title.Text = "🛠 TOOBERS ULTIMATE HUB v8"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- ===== АВАТАР И НИК В ПРАВОМ ВЕРХНЕМ УГЛУ =====
local avatarFrame = Instance.new("Frame")
avatarFrame.Size = UDim2.new(0, 60, 0, 60)
avatarFrame.Position = UDim2.new(1, -75, 0, 5)
avatarFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
avatarFrame.BackgroundTransparency = 0.3
avatarFrame.BorderSizePixel = 0
avatarFrame.Parent = frame

local avatarImage = Instance.new("ImageLabel")
avatarImage.Size = UDim2.new(1, -4, 1, -4)
avatarImage.Position = UDim2.new(0, 2, 0, 2)
avatarImage.BackgroundTransparency = 1
avatarImage.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
avatarImage.Parent = avatarFrame

local userName = Instance.new("TextLabel")
userName.Size = UDim2.new(0, 120, 0, 20)
userName.Position = UDim2.new(1, -135, 0, 65)
userName.BackgroundTransparency = 1
userName.Text = player.Name
userName.TextColor3 = Color3.fromRGB(255, 255, 255)
userName.TextScaled = true
userName.Font = Enum.Font.GothamBold
userName.Parent = frame

-- ===== КНОПКА СВОРАЧИВАНИЯ =====
local toggleBtn = Instance.new("ImageButton")
toggleBtn.Size = UDim2.new(0, 30, 0, 30)
toggleBtn.Position = UDim2.new(1, -40, 0, 8)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Image = "rbxassetid://6072924773"
toggleBtn.Parent = title

-- ===== ВКЛАДКИ =====
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0.06, 0)
tabFrame.Position = UDim2.new(0, 0, 0.06, 0)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = frame

local tabs = {"📡 Сниффер", "🔍 Сканер", "📤 Отправить", "💻 Консоль", "🧠 Читы", "📋 Логи"}
local currentTab = 1
local tabButtons = {}

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.166, -2, 1, 0)
    btn.Position = UDim2.new((i-1) * 0.166, 0, 0, 0)
    btn.BackgroundColor3 = i == 1 and Color3.fromRGB(60, 60, 90) or Color3.fromRGB(30, 30, 50)
    btn.BackgroundTransparency = 0.2
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.Parent = tabFrame
    tabButtons[i] = btn
    
    btn.MouseButton1Click:Connect(function()
        currentTab = i
        for j, b in ipairs(tabButtons) do
            b.BackgroundColor3 = j == i and Color3.fromRGB(60, 60, 90) or Color3.fromRGB(30, 30, 50)
        end
    end)
end

-- ===== КОНТЕНТ =====
local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 0.78, 0)
content.Position = UDim2.new(0, 0, 0.12, 0)
content.BackgroundTransparency = 1
content.Parent = frame

-- ===== 1. СНИФФЕР =====
local sniffFrame = Instance.new("ScrollingFrame")
sniffFrame.Size = UDim2.new(1, 0, 1, 0)
sniffFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 18)
sniffFrame.BackgroundTransparency = 0.1
sniffFrame.BorderSizePixel = 0
sniffFrame.ScrollBarThickness = 6
sniffFrame.Parent = content

local sniffText = Instance.new("TextLabel")
sniffText.Size = UDim2.new(1, -10, 1, -10)
sniffText.Position = UDim2.new(0, 5, 0, 5)
sniffText.BackgroundTransparency = 1
sniffText.Text = "⏳ Сниффер активен...\n"
sniffText.TextColor3 = Color3.fromRGB(180, 180, 200)
sniffText.TextWrapped = true
sniffText.TextScaled = false
sniffText.Font = Enum.Font.Gotham
sniffText.TextXAlignment = Enum.TextXAlignment.Left
sniffText.Parent = sniffFrame

local function logSniff(msg, color)
    sniffText.Text = sniffText.Text .. "\n" .. msg
    sniffText.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    sniffFrame.CanvasPosition = Vector2.new(0, sniffFrame.CanvasSize.Y.Offset)
end

local function startSniffer()
    logSniff("🔍 Сниффер запущен...", Color3.fromRGB(100, 255, 100))
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            pcall(function()
                obj.OnClientEvent:Connect(function(...)
                    logSniff("📥 " .. obj.Name .. " -> " .. tostring({...}), Color3.fromRGB(200, 200, 255))
                end)
            end)
        end
    end
end
startSniffer()

-- ===== 2. СКАНЕР =====
local scanFrame = Instance.new("Frame")
scanFrame.Size = UDim2.new(1, 0, 1, 0)
scanFrame.BackgroundTransparency = 1
scanFrame.Visible = false
scanFrame.Parent = content

local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(0.3, 0, 0.1, 0)
scanBtn.Position = UDim2.new(0.35, 0, 0, 0)
scanBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
scanBtn.BackgroundTransparency = 0.1
scanBtn.Text = "🚀 СКАНИРОВАТЬ"
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanBtn.TextScaled = true
scanBtn.Font = Enum.Font.GothamBold
scanBtn.Parent = scanFrame

local scanReport = Instance.new("ScrollingFrame")
scanReport.Size = UDim2.new(1, 0, 0.78, 0)
scanReport.Position = UDim2.new(0, 0, 0.12, 0)
scanReport.BackgroundColor3 = Color3.fromRGB(8, 8, 18)
scanReport.BackgroundTransparency = 0.1
scanReport.BorderSizePixel = 0
scanReport.ScrollBarThickness = 6
scanReport.Parent = scanFrame

local scanText = Instance.new("TextLabel")
scanText.Size = UDim2.new(1, -10, 1, -10)
scanText.Position = UDim2.new(0, 5, 0, 5)
scanText.BackgroundTransparency = 1
scanText.Text = "Нажми 'Сканировать'"
scanText.TextColor3 = Color3.fromRGB(180, 180, 200)
scanText.TextWrapped = true
scanText.Font = Enum.Font.Gotham
scanText.Parent = scanReport

local foundVulns = {}

local function logScan(msg, color)
    scanText.Text = scanText.Text .. "\n" .. msg
    scanText.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    scanReport.CanvasPosition = Vector2.new(0, scanReport.CanvasSize.Y.Offset)
end

scanBtn.MouseButton1Click:Connect(function()
    scanText.Text = "🔍 Сканирование...\n"
    foundVulns = {}
    task.wait(1)
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            local name = obj.Name
            local path = obj:GetFullName()
            local success, result = pcall(function()
                obj:FireServer("test")
            end)
            if success then
                table.insert(foundVulns, obj)
                logScan("🔴 ОТВЕЧАЕТ: " .. name .. " (" .. path .. ")", Color3.fromRGB(255, 80, 80))
            else
                logScan("🟡 НЕ ОТВЕЧАЕТ: " .. name .. " (" .. path .. ")", Color3.fromRGB(255, 200, 50))
            end
        end
    end
    logScan("\n✅ Найдено рабочих: " .. #foundVulns, Color3.fromRGB(100, 255, 100))
end)

-- ===== 3. ОТПРАВКА ТЕКСТА =====
local sendFrame = Instance.new("Frame")
sendFrame.Size = UDim2.new(1, 0, 1, 0)
sendFrame.BackgroundTransparency = 1
sendFrame.Visible = false
sendFrame.Parent = content

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0.9, 0, 0.15, 0)
textBox.Position = UDim2.new(0.05, 0, 0, 0)
textBox.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
textBox.BackgroundTransparency = 0.2
textBox.Text = "HACKED BY TOOBERS"
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.TextScaled = true
textBox.Font = Enum.Font.Gotham
textBox.Parent = sendFrame

local sendBtn = Instance.new("TextButton")
sendBtn.Size = UDim2.new(0.25, 0, 0.08, 0)
sendBtn.Position = UDim2.new(0.375, 0, 0.18, 0)
sendBtn.BackgroundColor3 = Color3.fromRGB(70, 200, 70)
sendBtn.BackgroundTransparency = 0.1
sendBtn.Text = "📤 ОТПРАВИТЬ"
sendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
sendBtn.TextScaled = true
sendBtn.Font = Enum.Font.GothamBold
sendBtn.Parent = sendFrame

sendBtn.MouseButton1Click:Connect(function()
    local msg = textBox.Text
    for _, remote in ipairs(foundVulns) do
        pcall(function()
            remote:FireServer(msg)
            remote:FireServer("ALL", msg)
            remote:FireServer("Broadcast", msg)
            remote:FireServer("Announce", msg)
            remote:FireServer("Say", msg)
        end)
    end
    logSniff("📤 Отправлено: " .. msg, Color3.fromRGB(100, 255, 100))
end)

-- ===== 4. КОНСОЛЬ =====
local consoleFrame = Instance.new("Frame")
consoleFrame.Size = UDim2.new(1, 0, 1, 0)
consoleFrame.BackgroundTransparency = 1
consoleFrame.Visible = false
consoleFrame.Parent = content

local consoleInput = Instance.new("TextBox")
consoleInput.Size = UDim2.new(0.9, 0, 0.1, 0)
consoleInput.Position = UDim2.new(0.05, 0, 0.87, 0)
consoleInput.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
consoleInput.BackgroundTransparency = 0.2
consoleInput.PlaceholderText = "Введи Lua-код здесь..."
consoleInput.Text = ""
consoleInput.TextColor3 = Color3.fromRGB(255, 255, 255)
consoleInput.TextScaled = true
consoleInput.Font = Enum.Font.Gotham
consoleInput.ClearTextOnFocus = false
consoleInput.Parent = consoleFrame

local consoleOutput = Instance.new("ScrollingFrame")
consoleOutput.Size = UDim2.new(1, 0, 0.82, 0)
consoleOutput.BackgroundColor3 = Color3.fromRGB(8, 8, 18)
consoleOutput.BackgroundTransparency = 0.1
consoleOutput.BorderSizePixel = 0
consoleOutput.ScrollBarThickness = 6
consoleOutput.Parent = consoleFrame

local consoleText = Instance.new("TextLabel")
consoleText.Size = UDim2.new(1, -10, 1, -10)
consoleText.Position = UDim2.new(0, 5, 0, 5)
consoleText.BackgroundTransparency = 1
consoleText.Text = "> Добро пожаловать в консоль!\n> Вводи код и нажимай Enter\n"
consoleText.TextColor3 = Color3.fromRGB(100, 255, 100)
consoleText.TextWrapped = true
consoleText.TextScaled = false
consoleText.Font = Enum.Font.Gotham
consoleText.TextXAlignment = Enum.TextXAlignment.Left
consoleText.Parent = consoleOutput

local function logConsole(msg, color)
    consoleText.Text = consoleText.Text .. "\n" .. msg
    consoleText.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    consoleOutput.CanvasPosition = Vector2.new(0, consoleOutput.CanvasSize.Y.Offset)
end

consoleInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local code = consoleInput.Text
        if code ~= "" then
            logConsole("> " .. code, Color3.fromRGB(200, 200, 255))
            local success, result = pcall(loadstring(code))
            if success then
                logConsole("✅ " .. tostring(result), Color3.fromRGB(100, 255, 100))
            else
                logConsole("❌ " .. tostring(result), Color3.fromRGB(255, 80, 80))
            end
            consoleInput.Text = ""
        end
    end
end)

-- ===== 5. ЧИТЫ (НОВАЯ ВКЛАДКА) =====
local cheatsFrame = Instance.new("Frame")
cheatsFrame.Size = UDim2.new(1, 0, 1, 0)
cheatsFrame.BackgroundTransparency = 1
cheatsFrame.Visible = false
cheatsFrame.Parent = content

-- Функции для читов
local function toggleFly()
    flyEnabled = not flyEnabled
    if flyEnabled then
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = true
            local bp = Instance.new("BodyPosition")
            bp.MaxForce = Vector3.new(0, 1, 0) * 10000
            bp.P = 1000
            bp.D = 100
            bp.Parent = char.HumanoidRootPart
            char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end
    else
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = false
            local bp = char.HumanoidRootPart:FindFirstChild("BodyPosition")
            if bp then bp:Destroy() end
        end
    end
end

local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        RunService.Stepped:Connect(function()
            if noclipEnabled and player.Character then
                for _, part in ipairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

local function toggleInfiniteJump()
    infiniteJump = not infiniteJump
    if infiniteJump then
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = 100
        end
    else
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = 50
        end
    end
end

local function setSpeed(speed)
    speedMultiplier = speed
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = 16 * speedMultiplier
    end
end

-- ===== GUI для читов =====
local cheatsList = {
    {"🚀 Полёт", toggleFly},
    {"🧱 Ноклип", toggleNoclip},
    {"🦘 Бесконечный прыжок", toggleInfiniteJump},
}

for i, cheat in ipairs(cheatsList) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.3, -10, 0.12, 0)
    btn.Position = UDim2.new((i-1) % 3 * 0.333 + 0.01, 0, math.floor((i-1)/3) * 0.15 + 0.02, 0)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
    btn.BackgroundTransparency = 0.1
    btn.Text = cheat[1]
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.Parent = cheatsFrame
    
    btn.MouseButton1Click:Connect(cheat[2])
end

-- Регулятор скорости
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.3, 0, 0.06, 0)
speedLabel.Position = UDim2.new(0.35, 0, 0.5, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Скорость: x1"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = cheatsFrame

local speedSlider = Instance.new("TextBox")
speedSlider.Size = UDim2.new(0.3, 0, 0.06, 0)
speedSlider.Position = UDim2.new(0.35, 0, 0.56, 0)
speedSlider.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
speedSlider.BackgroundTransparency = 0.2
speedSlider.Text = "1"
speedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
speedSlider.TextScaled = true
speedSlider.Font = Enum.Font.Gotham
speedSlider.Parent = cheatsFrame

speedSlider.FocusLost:Connect(function()
    local val = tonumber(speedSlider.Text)
    if val then
        setSpeed(val)
        speedLabel.Text = "Скорость: x" .. val
    end
end)

-- ===== 6. ЛОГИ ROBLOX =====
local logsFrame = Instance.new("ScrollingFrame")
logsFrame.Size = UDim2.new(1, 0, 1, 0)
logsFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 18)
logsFrame.BackgroundTransparency = 0.1
logsFrame.BorderSizePixel = 0
logsFrame.ScrollBarThickness = 6
logsFrame.Visible = false
logsFrame.Parent = content

local logsText = Instance.new("TextLabel")
logsText.Size = UDim2.new(1, -10, 1, -10)
logsText.Position = UDim2.new(0, 5, 0, 5)
logsText.BackgroundTransparency = 1
logsText.Text = "⏳ Ожидание логов Roblox...\n"
logsText.TextColor3 = Color3.fromRGB(200, 200, 200)
logsText.TextWrapped = true
logsText.TextScaled = false
logsText.Font = Enum.Font.Gotham
logsText.TextXAlignment = Enum.TextXAlignment.Left
logsText.Parent = logsFrame

local function addLog(msg, color)
    logsText.Text = logsText.Text .. "\n" .. msg
    logsText.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    logsFrame.CanvasPosition = Vector2.new(0, logsFrame.CanvasSize.Y.Offset)
end

LogService.MessageOut:Connect(function(message, messageType)
    local prefix = messageType == 1 and "❌ ОШИБКА: " or messageType == 2 and "⚠️ ПРЕДУПРЕЖДЕНИЕ: " or "📢 ИНФО: "
    local color = messageType == 1 and Color3.fromRGB(255, 50, 50) 
                or messageType == 2 and Color3.fromRGB(255, 200, 50) 
                or Color3.fromRGB(200, 200, 255)
    addLog(prefix .. message, color)
end)
addLog("✅ Перехват логов Roblox активирован!", Color3.fromRGB(100, 255, 100))

-- ===== ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК =====
for i, btn in ipairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        for j, tab in ipairs({sniffFrame, scanFrame, sendFrame, consoleFrame, cheatsFrame, logsFrame}) do
            tab.Visible = (j == i)
        end
    end)
end

-- ===== СВОРАЧИВАНИЕ =====
local isMinimized = false
toggleBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        frame.Size = UDim2.new(0, 60, 0, 40)
        frame.Position = UDim2.new(1, -70, 0, 10)
        title.Text = "🛠"
        title.TextScaled = true
        toggleBtn.Image = "rbxassetid://6072924768"
        tabFrame.Visible = false
        content.Visible = false
        avatarFrame.Visible = false
        userName.Visible = false
    else
        frame.Size = UDim2.new(0, 850, 0, 620)
        frame.Position = UDim2.new(0.5, -425, 0.5, -310)
        title.Text = "🛠 TOOBERS ULTIMATE HUB v8"
        title.TextScaled = true
        toggleBtn.Image = "rbxassetid://6072924773"
        tabFrame.Visible = true
        content.Visible = true
        avatarFrame.Visible = true
        userName.Visible = true
    end
end)

print("[TOOBERS] УЛЬТИМАТИВНЫЙ ХАБ ЗАГРУЖЕН! ВСЕ ФУНКЦИИ АКТИВНЫ.")
