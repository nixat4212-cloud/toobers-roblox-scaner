-- WIA HUB :: RAYFIELD STYLE + AIMBOT + INVISIBLE :: whitewia/tordark

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

-- ========== ПЕРЕМЕННЫЕ ==========
local flightEnabled = false
local noclipEnabled = false
local flySpeed = 50
local bodyVelocity = nil
local bodyGyro = nil
local noclipConnection = nil
local originalCollisions = {}

local noclipForceMode = false
local noclipForceConnection = nil

local walkSpeedEnabled = false
local walkSpeedValue = 16
local jumpPowerEnabled = false
local jumpPowerValue = 50
local infiniteJumpEnabled = false
local originalWalkSpeed = 16
local originalJumpPower = 50

local godmodeEnabled = false
local godmodeConnection = nil
local godmodeHealthConnection = nil
local godmodeHumanoid = nil

local tpTool = nil
local tpEnabled = false

local wallhackEnabled = false
local highlightConnections = {}
local whHighlights = {}

local antiAFKEnabled = false
local antiAFKConnection = nil

local playerListEnabled = false
local playerButtons = {}

local antiVoidEnabled = false
local antiVoidConnection = nil

local fullBrightEnabled = false
local originalBrightness = nil
local originalAmbient = nil

local fovEnabled = false
local fovValue = 90
local originalFOV = 70

local hitboxEnabled = false
local hitboxConnection = nil
local hitboxSize = 5

local autoClickerEnabled = false
local autoClickerDelay = 100
local autoClickerConnection = nil

local chatSpamEnabled = false
local chatSpamMessage = "WIA HUB"
local chatSpamDelay = 5
local chatSpamConnection = nil

local bhopEnabled = false
local bhopConnection = nil

local antiFallEnabled = false
local antiFallConnection = nil

-- ========== НОВЫЕ ПЕРЕМЕННЫЕ ==========
local aimbotEnabled = false
local aimbotFOV = 90
local aimbotSmoothness = 5
local aimbotTarget = nil
local aimbotConnection = nil

local invisibleEnabled = false
local invisibleConnection = nil
local originalTransparency = {}

-- ========== GUI (RAYFIELD STYLE) ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WiaHubGUI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 480)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Shadow
local Shadow = Instance.new("Frame")
Shadow.Size = UDim2.new(1, 10, 1, 10)
Shadow.Position = UDim2.new(0, -5, 0, -5)
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.5
Shadow.BorderSizePixel = 0
Shadow.Parent = MainFrame

local ShadowCorner = Instance.new("UICorner")
ShadowCorner.CornerRadius = UDim.new(0, 14)
ShadowCorner.Parent = Shadow

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "WIA HUB v7"
Title.TextColor3 = Color3.fromRGB(180, 0, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ToggleBtn.Visible = true
end)

-- Toggle Button
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
ToggleBtn.Text = "W"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 20
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Visible = false
ToggleBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn

-- Tab Container
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 35)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

-- Content Container (scrollable)
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, -10, 1, -85)
ContentFrame.Position = UDim2.new(0, 5, 0, 75)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 4
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(180, 0, 255)
ContentFrame.Parent = MainFrame

local ContentList = Instance.new("Frame")
ContentList.Size = UDim2.new(1, 0, 0, 0)
ContentList.BackgroundTransparency = 1
ContentList.Parent = ContentFrame
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 6)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Parent = ContentList

-- Status Bar
local StatusBar = Instance.new("TextLabel")
StatusBar.Size = UDim2.new(1, -20, 0, 22)
StatusBar.Position = UDim2.new(0, 10, 1, -28)
StatusBar.BackgroundTransparency = 1
StatusBar.Text = "Ready"
StatusBar.TextColor3 = Color3.fromRGB(150, 150, 180)
StatusBar.Font = Enum.Font.Gotham
StatusBar.TextSize = 12
StatusBar.Parent = MainFrame

-- ========== ВКЛАДКИ ==========
local tabs = {}
local currentTab = "Main"

local function createTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 60, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.Parent = TabContainer
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, -10, 0, 2)
    line.Position = UDim2.new(0, 5, 1, -2)
    line.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
    line.BackgroundTransparency = 1
    line.Parent = btn
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 0, 0)
    content.BackgroundTransparency = 1
    content.Visible = false
    content.Parent = ContentList
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = content
    
    tabs[name] = {
        btn = btn,
        line = line,
        content = content,
        layout = layout
    }
    
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.content.Visible = false
            t.line.BackgroundTransparency = 1
            t.btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        content.Visible = true
        line.BackgroundTransparency = 0
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        currentTab = name
        updateContentSize()
    end)
    
    return content
end

-- ========== ФУНКЦИИ GUI ==========
local function updateContentSize()
    local totalHeight = 0
    for _, tab in pairs(tabs) do
        local children = tab.content:GetChildren()
        for _, child in pairs(children) do
            if child:IsA("Frame") then
                totalHeight = totalHeight + child.Size.Y.Offset + 6
            end
        end
    end
    ContentList.Size = UDim2.new(1, 0, 0, totalHeight + 20)
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 30)
end

local function createToggle(parent, name, defaultState, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -10, 0, 34)
    holder.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    holder.BorderSizePixel = 0
    holder.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = holder
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0, 35, 1, 0)
    statusLabel.Position = UDim2.new(0.6, 0, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = defaultState and "ON" or "OFF"
    statusLabel.TextColor3 = defaultState and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextSize = 12
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center
    statusLabel.Parent = holder
    
    local switchBg = Instance.new("Frame")
    switchBg.Size = UDim2.new(0, 40, 0, 20)
    switchBg.Position = UDim2.new(1, -48, 0.5, -10)
    switchBg.BackgroundColor3 = defaultState and Color3.fromRGB(0, 170, 90) or Color3.fromRGB(70, 70, 75)
    switchBg.Parent = holder
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switchBg
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = defaultState and UDim2.new(0, 22, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = switchBg
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = switchBg
    
    local state = defaultState or false
    
    local function setState(newState)
        state = newState
        local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad)
        local knobGoal = state and {Position = UDim2.new(0, 22, 0.5, -8)} or {Position = UDim2.new(0, 2, 0.5, -8)}
        local bgGoal = state and {BackgroundColor3 = Color3.fromRGB(0, 170, 90)} or {BackgroundColor3 = Color3.fromRGB(70, 70, 75)}
        
        TweenService:Create(knob, tweenInfo, knobGoal):Play()
        TweenService:Create(switchBg, tweenInfo, bgGoal):Play()
        statusLabel.Text = state and "ON" or "OFF"
        statusLabel.TextColor3 = state and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        
        if callback then
            callback(state)
        end
    end
    
    btn.MouseButton1Click:Connect(function()
        setState(not state)
    end)
    
    -- Возвращаем функции управления
    return {
        holder = holder,
        setState = setState,
        getState = function() return state end
    }
end

local function createSlider(parent, name, minVal, maxVal, defaultVal, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -10, 0, 34)
    holder.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    holder.BorderSizePixel = 0
    holder.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = holder
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. tostring(defaultVal)
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder
    
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0, 50, 0, 24)
    input.Position = UDim2.new(1, -60, 0.5, -12)
    input.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    input.Text = tostring(defaultVal)
    input.TextColor3 = Color3.new(1, 1, 1)
    input.Font = Enum.Font.Gotham
    input.TextSize = 13
    input.Parent = holder
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 4)
    inputCorner.Parent = input
    
    local value = defaultVal
    
    input.FocusLost:Connect(function()
        local num = tonumber(input.Text)
        if num and num >= minVal and num <= maxVal then
            value = num
            label.Text = name .. ": " .. tostring(num)
            if callback then
                callback(num)
            end
        else
            input.Text = tostring(value)
        end
    end)
    
    return {
        holder = holder,
        setValue = function(val)
            value = val
            label.Text = name .. ": " .. tostring(val)
            input.Text = tostring(val)
        end,
        getValue = function() return value end
    }
end

-- ========== СОЗДАНИЕ ВКЛАДОК ==========
local mainTab = createTab("Main")
local combatTab = createTab("Combat")
local visualTab = createTab("Visual")
local miscTab = createTab("Misc")

-- ========== MAIN TAB ==========
createToggle(mainTab, "ESP Box", true, function(state)
    espEnabled = state
    setStatus(state and "ESP ON" or "ESP OFF")
end)

createToggle(mainTab, "Tracers", true, function(state)
    tracerEnabled = state
    setStatus(state and "Tracers ON" or "Tracers OFF")
end)

createToggle(mainTab, "Flight", false, function(state)
    flightEnabled = state
    setStatus(state and "Flight ON" or "Flight OFF")
    -- Flight logic here (same as before)
end)

createToggle(mainTab, "Noclip", false, function(state)
    noclipEnabled = state
    setStatus(state and "Noclip ON" or "Noclip OFF")
    -- Noclip logic here
end)

createToggle(mainTab, "Noclip Force", false, function(state)
    noclipForceMode = state
    setStatus(state and "Noclip Force ON" or "Noclip Force OFF")
end)

createToggle(mainTab, "Godmode", false, function(state)
    godmodeEnabled = state
    setStatus(state and "Godmode ON" or "Godmode OFF")
    -- Godmode logic here
end)

createToggle(mainTab, "Infinite Jump", false, function(state)
    infiniteJumpEnabled = state
    setStatus(state and "Infinite Jump ON" or "Infinite Jump OFF")
end)

-- Speed sliders
local wsSlider = createSlider(mainTab, "Walk Speed", 10, 200, 16, function(val)
    walkSpeedValue = val
    if walkSpeedEnabled then
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = val
            end
        end
    end
end)

local jpSlider = createSlider(mainTab, "Jump Power", 10, 200, 50, function(val)
    jumpPowerValue = val
    if jumpPowerEnabled then
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.JumpPower = val
            end
        end
    end
end)

local flySlider = createSlider(mainTab, "Fly Speed", 10, 200, 50, function(val)
    flySpeed = val
end)

-- ========== COMBAT TAB ==========
createToggle(combatTab, "Aimbot", false, function(state)
    aimbotEnabled = state
    setStatus(state and "Aimbot ON" or "Aimbot OFF")
    -- Aimbot logic below
end)

createSlider(combatTab, "Aimbot FOV", 10, 180, 90, function(val)
    aimbotFOV = val
end)

createSlider(combatTab, "Aimbot Smooth", 1, 20, 5, function(val)
    aimbotSmoothness = val
end)

createToggle(combatTab, "AutoClicker", false, function(state)
    autoClickerEnabled = state
    setStatus(state and "AutoClicker ON" or "AutoClicker OFF")
    -- AutoClicker logic
end)

createSlider(combatTab, "Click Delay (ms)", 10, 1000, 100, function(val)
    autoClickerDelay = val
end)

createToggle(combatTab, "Bhop", false, function(state)
    bhopEnabled = state
    setStatus(state and "Bhop ON" or "Bhop OFF")
    -- Bhop logic
end)

-- ========== VISUAL TAB ==========
createToggle(visualTab, "Wallhack", false, function(state)
    wallhackEnabled = state
    setStatus(state and "Wallhack ON" or "Wallhack OFF")
    -- Wallhack logic
end)

createToggle(visualTab, "FullBright", false, function(state)
    fullBrightEnabled = state
    setStatus(state and "FullBright ON" or "FullBright OFF")
    -- FullBright logic
end)

createToggle(visualTab, "FOV", false, function(state)
    fovEnabled = state
    setStatus(state and "FOV ON" or "FOV OFF")
    -- FOV logic
end)

createSlider(visualTab, "FOV Value", 50, 120, 90, function(val)
    fovValue = val
    if fovEnabled then
        Camera.FieldOfView = val
    end
end)

createToggle(visualTab, "Hitbox", false, function(state)
    hitboxEnabled = state
    setStatus(state and "Hitbox ON" or "Hitbox OFF")
    -- Hitbox logic
end)

createSlider(visualTab, "Hitbox Size", 2, 15, 5, function(val)
    hitboxSize = val
    if hitboxEnabled then
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and (part.Name == "Head" or part.Name == "UpperTorso" or part.Name == "LowerTorso" or part.Name == "Torso") then
                    part.Size = Vector3.new(val, val, val)
                end
            end
        end
    end
end)

createToggle(visualTab, "Invisible", false, function(state)
    invisibleEnabled = state
    setStatus(state and "Invisible ON" or "Invisible OFF")
    -- Invisible logic below
end)

-- ========== MISC TAB ==========
createToggle(miscTab, "Player List", false, function(state)
    playerListEnabled = state
    setStatus(state and "Player List ON" or "Player List OFF")
end)

createToggle(miscTab, "Anti-AFK", false, function(state)
    antiAFKEnabled = state
    setStatus(state and "Anti-AFK ON" or "Anti-AFK OFF")
end)

createToggle(miscTab, "Anti-Void", false, function(state)
    antiVoidEnabled = state
    setStatus(state and "Anti-Void ON" or "Anti-Void OFF")
end)

createToggle(miscTab, "Anti-Fall", false, function(state)
    antiFallEnabled = state
    setStatus(state and "Anti-Fall ON" or "Anti-Fall OFF")
end)

createToggle(miscTab, "Chat Spam", false, function(state)
    chatSpamEnabled = state
    setStatus(state and "Chat Spam ON" or "Chat Spam OFF")
end)

createSlider(miscTab, "Spam Delay (s)", 1, 60, 5, function(val)
    chatSpamDelay = val
end)

-- ========== AIMBOT LOGIC ==========
local function getClosestPlayer()
    local closest = nil
    local minDist = aimbotFOV
    local localPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localPos then return nil end
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            if head then
                local pos, onScreen = Camera:WorldToScreenPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if dist < minDist then
                        minDist = dist
                        closest = plr
                    end
                end
            end
        end
    end
    return closest
end

local function aimbotLoop()
    if not aimbotEnabled then return end
    local target = getClosestPlayer()
    if target and target.Character then
        local head = target.Character:FindFirstChild("Head")
        if head then
            local targetPos = head.Position
            local currentCFrame = Camera.CFrame
            local newCFrame = CFrame.new(currentCFrame.Position, targetPos)
            Camera.CFrame = newCFrame
        end
    end
end

-- ========== INVISIBLE LOGIC ==========
local function toggleInvisible(state)
    invisibleEnabled = state
    local char = LocalPlayer.Character
    if not char then return end
    
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            if state then
                originalTransparency[part] = part.Transparency
                part.Transparency = 1
            else
                part.Transparency = originalTransparency[part] or 0
            end
        end
    end
end

-- ========== RUNSERVICE CONNECTIONS ==========
-- Aimbot
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        aimbotLoop()
    end
end)

-- Invisible (keep applied)
RunService.Heartbeat:Connect(function()
    if invisibleEnabled then
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1
                end
            end
        end
    end
end)

-- ========== GUI TOGGLE ==========
local menuVisible = true
ToggleBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible
    ToggleBtn.Visible = not menuVisible
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.LeftControl then
        menuVisible = not menuVisible
        MainFrame.Visible = menuVisible
        ToggleBtn.Visible = not menuVisible
    end
end)

-- ========== STATUS FUNCTION ==========
local function setStatus(text, color)
    StatusBar.Text = text
    StatusBar.TextColor3 = color or Color3.fromRGB(150, 150, 180)
end

-- ========== INIT ==========
-- Активируем первую вкладку
for _, t in pairs(tabs) do
    t.content.Visible = false
    t.line.BackgroundTransparency = 1
end
tabs["Main"].content.Visible = true
tabs["Main"].line.BackgroundTransparency = 0
tabs["Main"].btn.TextColor3 = Color3.fromRGB(255, 255, 255)

updateContentSize()
setStatus("WIA HUB v7 loaded | LCTRL to toggle")

print("WIA HUB v7 loaded successfully!")

-- ========== ПЕРЕМЕННЫЕ ДЛЯ СТАРОГО КОДА ==========
espEnabled = true
tracerEnabled = true
walkSpeedEnabled = true
jumpPowerEnabled = true