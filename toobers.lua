-- WIA HUB :: FULL GUI WITH SCROLLING + GODMODE + IMPROVED NOCLIP :: whitewia/tordark
-- MM2 MENU REMOVED COMPLETELY

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Flight & Noclip variables
local flightEnabled = false
local noclipEnabled = false
local flySpeed = 50
local bodyVelocity = nil
local bodyGyro = nil
local noclipConnection = nil
local originalCollisions = {}

-- Noclip improved (Force mode)
local noclipForceMode = false
local noclipForceConnection = nil

-- Movement variables
local walkSpeedEnabled = false
local walkSpeedValue = 16
local jumpPowerEnabled = false
local jumpPowerValue = 50
local infiniteJumpEnabled = false
local originalWalkSpeed = 16
local originalJumpPower = 50

-- Godmode variables
local godmodeEnabled = false
local godmodeConnection = nil
local godmodeHealthConnection = nil
local godmodeHumanoid = nil

-- TP Tool variables
local tpTool = nil
local tpEnabled = false

-- Wallhack variables
local wallhackEnabled = false
local highlightConnections = {}
local whHighlights = {}

-- Anti-AFK variables
local antiAFKEnabled = false
local antiAFKConnection = nil

-- GUI (CoreGui) - MAIN
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WiaHubGUI"
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 340, 0, 460)
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
MainFrame.BackgroundTransparency = 0.7
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "WIA HUB v5"
Title.TextColor3 = Color3.fromRGB(180, 0, 255)
Title.TextScaled = true
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local Underline = Instance.new("Frame")
Underline.Size = UDim2.new(1, -20, 0, 1)
Underline.Position = UDim2.new(0, 10, 0, 30)
Underline.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
Underline.BackgroundTransparency = 0.3
Underline.Parent = MainFrame

-- Scrollable container
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, 0, 1, -40)
ScrollingFrame.Position = UDim2.new(0, 0, 0, 35)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ScrollBarThickness = 6
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(180, 0, 255)
ScrollingFrame.Parent = MainFrame

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, 0, 0, 0)
Container.BackgroundTransparency = 1
Container.Parent = ScrollingFrame
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

-- Draggable
local dragging = false
local dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Hide on LCTRL
local guiVisible = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftControl then
        guiVisible = not guiVisible
        ScreenGui.Enabled = guiVisible
    end
end)

-- TUMBLER CREATION
local function createTumbler(labelText, x, y, parent, defaultState)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 160, 0, 30)
    container.Position = UDim2.new(0, x, 0, y)
    container.BackgroundTransparency = 1
    container.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 80, 0, 30)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.TextScaled = true
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 50, 0, 24)
    bg.Position = UDim2.new(0, 85, 0, 3)
    bg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    bg.BorderSizePixel = 0
    bg.Parent = container

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = UDim2.new(0, 2, 0, 2)
    knob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    knob.BorderSizePixel = 0
    knob.Parent = bg

    local state = defaultState or false

    local function updateTumbler()
        if state then
            bg.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
            knob.Position = UDim2.new(0, 28, 0, 2)
            knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
        else
            bg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            knob.Position = UDim2.new(0, 2, 0, 2)
            knob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        end
    end

    updateTumbler()

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Parent = container

    local toggleEvent = Instance.new("BindableEvent")
    btn.MouseButton1Click:Connect(function()
        state = not state
        updateTumbler()
        toggleEvent:Fire(state)
    end)

    return {
        container = container,
        bg = bg,
        knob = knob,
        getState = function() return state end,
        setState = function(newState)
            state = newState
            updateTumbler()
            toggleEvent:Fire(state)
        end,
        onToggle = function(callback)
            toggleEvent.Event:Connect(callback)
        end
    }
end

-- SLIDER CREATION
local function createSlider(labelText, x, y, parent, minVal, maxVal, defaultVal, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 160, 0, 30)
    container.Position = UDim2.new(0, x, 0, y)
    container.BackgroundTransparency = 1
    container.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 70, 0, 30)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.TextScaled = true
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 50, 0, 24)
    textBox.Position = UDim2.new(0, 80, 0, 3)
    textBox.Text = tostring(defaultVal)
    textBox.TextColor3 = Color3.fromRGB(255,255,255)
    textBox.BackgroundColor3 = Color3.fromRGB(40,40,55)
    textBox.BorderSizePixel = 0
    textBox.Font = Enum.Font.Gotham
    textBox.Parent = container

    textBox.FocusLost:Connect(function()
        local num = tonumber(textBox.Text)
        if num and num >= minVal and num <= maxVal then
            callback(num)
            textBox.Text = tostring(num)
        else
            textBox.Text = tostring(defaultVal)
            callback(defaultVal)
        end
    end)

    return {
        container = container,
        textBox = textBox,
        setValue = function(val)
            textBox.Text = tostring(val)
        end
    }
end

-- ROW 1: ESP
local espTumbler = createTumbler("ESP Box", 10, 5, Container, true)
-- ROW 2: Tracers
local trTumbler = createTumbler("Tracers", 10, 40, Container, true)
-- ROW 3: Flight
local flyTumbler = createTumbler("Flight", 10, 75, Container, false)
-- ROW 4: Noclip
local ncTumbler = createTumbler("Noclip", 10, 110, Container, false)
-- ROW 5: Noclip Force
local ncForceTumbler = createTumbler("Noclip Force", 10, 145, Container, false)
-- ROW 6: Wallhack
local whTumbler = createTumbler("Wallhack", 10, 180, Container, false)
-- ROW 7: Anti-AFK
local afkTumbler = createTumbler("Anti-AFK", 10, 215, Container, false)
-- ROW 8: Godmode
local godTumbler = createTumbler("Godmode", 10, 250, Container, false)
-- ROW 9: Infinite Jump
local infJumpTumbler = createTumbler("Infinite Jump", 10, 285, Container, false)
-- ROW 10: TP Tool
local tpToolTumbler = createTumbler("TP Tool", 10, 320, Container, false)

-- Speed Controls
local wsSlider = createSlider("Walk Speed", 10, 355, Container, 10, 200, 16, function(val)
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

local jpSlider = createSlider("Jump Power", 10, 390, Container, 10, 200, 50, function(val)
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

-- Fly Speed
local SpeedContainer = Instance.new("Frame")
SpeedContainer.Size = UDim2.new(0, 160, 0, 30)
SpeedContainer.Position = UDim2.new(0, 10, 0, 425)
SpeedContainer.BackgroundTransparency = 1
SpeedContainer.Parent = Container

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0, 70, 0, 30)
SpeedLabel.Position = UDim2.new(0, 0, 0, 0)
SpeedLabel.Text = "Fly Speed"
SpeedLabel.TextColor3 = Color3.fromRGB(255,255,255)
SpeedLabel.TextScaled = true
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = SpeedContainer

local SpeedSlider = Instance.new("TextBox")
SpeedSlider.Size = UDim2.new(0, 60, 0, 24)
SpeedSlider.Position = UDim2.new(0, 80, 0, 3)
SpeedSlider.Text = "50"
SpeedSlider.TextColor3 = Color3.fromRGB(255,255,255)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(40,40,55)
SpeedSlider.BorderSizePixel = 0
SpeedSlider.Font = Enum.Font.Gotham
SpeedSlider.Parent = SpeedContainer

-- TP Controls
local TPControls = Instance.new("Frame")
TPControls.Size = UDim2.new(0, 160, 0, 30)
TPControls.Position = UDim2.new(0, 10, 0, 460)
TPControls.BackgroundTransparency = 1
TPControls.Parent = Container

local TPToolButton = Instance.new("TextButton")
TPToolButton.Size = UDim2.new(0, 70, 0, 24)
TPToolButton.Position = UDim2.new(0, 0, 0, 3)
TPToolButton.Text = "Get Tool"
TPToolButton.TextColor3 = Color3.fromRGB(255,255,255)
TPToolButton.BackgroundColor3 = Color3.fromRGB(40,40,55)
TPToolButton.BorderSizePixel = 0
TPToolButton.Font = Enum.Font.Gotham
TPToolButton.Parent = TPControls

local TPEnableToggle = Instance.new("TextButton")
TPEnableToggle.Size = UDim2.new(0, 60, 0, 24)
TPEnableToggle.Position = UDim2.new(0, 80, 0, 3)
TPEnableToggle.Text = "OFF"
TPEnableToggle.TextColor3 = Color3.fromRGB(255,255,255)
TPEnableToggle.BackgroundColor3 = Color3.fromRGB(40,40,55)
TPEnableToggle.BorderSizePixel = 0
TPEnableToggle.Font = Enum.Font.Gotham
TPEnableToggle.Parent = TPControls

-- Status bar
local StatusBar = Instance.new("TextLabel")
StatusBar.Size = UDim2.new(1, -20, 0, 25)
StatusBar.Position = UDim2.new(0, 10, 0, 495)
StatusBar.Text = "Ready"
StatusBar.TextColor3 = Color3.fromRGB(150, 150, 180)
StatusBar.TextScaled = true
StatusBar.BackgroundTransparency = 1
StatusBar.Font = Enum.Font.Gotham
StatusBar.Parent = Container

-- Update canvas size
local function updateCanvas()
    local children = Container:GetChildren()
    local maxY = 0
    for _, child in pairs(children) do
        if child:IsA("Frame") and child ~= StatusBar then
            local pos = child.Position.Y.Offset
            local size = child.Size.Y.Offset
            if pos + size > maxY then
                maxY = pos + size
            end
        end
    end
    if StatusBar then
        local pos = StatusBar.Position.Y.Offset
        local size = StatusBar.Size.Y.Offset
        if pos + size > maxY then
            maxY = pos + size
        end
    end
    Container.Size = UDim2.new(1, 0, 0, maxY + 20)
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, maxY + 30)
end

-- State vars
local espEnabled = true
local tracerEnabled = true
local espLines = {}
local tracerLines = {}

-- Status update
local function setStatus(text, color)
    StatusBar.Text = text
    StatusBar.TextColor3 = color or Color3.fromRGB(150, 150, 180)
end

-- IMPROVED NOCLIP FUNCTIONS
local function enableNoclipForce()
    if noclipForceConnection then noclipForceConnection:Disconnect() end
    noclipForceConnection = RunService.Heartbeat:Connect(function()
        if not noclipForceMode or not noclipEnabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local moveDirection = Vector3.new(0, 0, 0)
        local forward = Camera.CFrame.LookVector
        local right = Camera.CFrame.RightVector
        local up = Camera.CFrame.UpVector
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + forward end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - forward end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - right end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + right end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + up end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection - up end
        
        if moveDirection.Magnitude > 0 then
            local speed = flySpeed * 0.5
            local newPos = root.Position + moveDirection.Unit * speed
            root.CFrame = CFrame.new(newPos, root.Position + moveDirection.Unit)
        end
    end)
end

-- GODMODE FUNCTIONS
local function enableGodmode()
    local char = LocalPlayer.Character
    if not char then return end

    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end

    godmodeHumanoid = humanoid
    humanoid.BreakJointsOnDeath = false

    if godmodeHealthConnection then
        godmodeHealthConnection:Disconnect()
        godmodeHealthConnection = nil
    end

    godmodeHealthConnection = humanoid.HealthChanged:Connect(function(health)
        if not godmodeEnabled then return end
        if health < humanoid.MaxHealth then
            humanoid.Health = humanoid.MaxHealth
        end
    end)

    if godmodeConnection then
        godmodeConnection:Disconnect()
        godmodeConnection = nil
    end

    godmodeConnection = RunService.Heartbeat:Connect(function()
        if not godmodeEnabled then return end
        if humanoid and humanoid.Health < humanoid.MaxHealth then
            humanoid.Health = humanoid.MaxHealth
        end
    end)

    humanoid.Health = humanoid.MaxHealth
end

local function disableGodmode()
    if godmodeHealthConnection then
        godmodeHealthConnection:Disconnect()
        godmodeHealthConnection = nil
    end

    if godmodeConnection then
        godmodeConnection:Disconnect()
        godmodeConnection = nil
    end

    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.BreakJointsOnDeath = true
        end
    end

    godmodeHumanoid = nil
end

-- TUMBLER EVENTS
espTumbler.onToggle(function(state)
    espEnabled = state
    setStatus(state and "ESP ON" or "ESP OFF")
end)

trTumbler.onToggle(function(state)
    tracerEnabled = state
    setStatus(state and "Tracers ON" or "Tracers OFF")
end)

flyTumbler.onToggle(function(state)
    flightEnabled = state
    setStatus(state and "Flight ON" or "Flight OFF", state and Color3.fromRGB(0,255,200) or nil)

    if state then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
            bodyVelocity.Parent = char.HumanoidRootPart

            bodyGyro = Instance.new("BodyGyro")
            bodyGyro.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
            bodyGyro.CFrame = char.HumanoidRootPart.CFrame
            bodyGyro.Parent = char.HumanoidRootPart
        end
    else
        if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
        if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    end
end)

-- NOCLIP IMPROVED
ncTumbler.onToggle(function(state)
    noclipEnabled = state
    setStatus(state and "Noclip ON" or "Noclip OFF", state and Color3.fromRGB(0,200,255) or nil)

    if state then
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    originalCollisions[part] = part.CanCollide
                    part.CanCollide = false
                end
            end
        end

        if noclipConnection then noclipConnection:Disconnect() end
        noclipConnection = RunService.Heartbeat:Connect(function()
            if not noclipEnabled then return end
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)

        if noclipForceMode then
            enableNoclipForce()
        end
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        if noclipForceConnection then
            noclipForceConnection:Disconnect()
            noclipForceConnection = nil
        end
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = originalCollisions[part] ~= nil and originalCollisions[part] or true
                end
            end
        end
        originalCollisions = {}
    end
end)

-- NOCLIP FORCE MODE
ncForceTumbler.onToggle(function(state)
    noclipForceMode = state
    setStatus(state and "Noclip Force ON - Move through walls with WASD" or "Noclip Force OFF", state and Color3.fromRGB(255, 150, 0) or nil)
    
    if state and noclipEnabled then
        enableNoclipForce()
    else
        if noclipForceConnection then
            noclipForceConnection:Disconnect()
            noclipForceConnection = nil
        end
    end
end)

-- WALLHACK
local function clearWallhack()
    for _, conn in pairs(highlightConnections) do
        conn:Disconnect()
    end
    highlightConnections = {}

    for _, highlight in pairs(whHighlights) do
        if highlight and highlight.Parent then
            highlight:Destroy()
        end
    end
    whHighlights = {}

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local wh = plr.Character:FindFirstChild("WIA_WH")
            if wh then wh:Destroy() end
        end
    end
end

local function applyWallhackToChar(char)
    if not char or not wallhackEnabled then return end
    local old = char:FindFirstChild("WIA_WH")
    if old then old:Destroy() end

    local highlight = Instance.new("Highlight")
    highlight.Name = "WIA_WH"
    highlight.FillColor = Color3.fromRGB(180, 0, 255)
    highlight.FillTransparency = 0.2
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0.1
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = char
    whHighlights[char] = highlight
end

local function updateWallhack()
    if not wallhackEnabled then
        clearWallhack()
        return
    end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            applyWallhackToChar(plr.Character)
        end
    end
end

whTumbler.onToggle(function(state)
    wallhackEnabled = state
    setStatus(state and "Wallhack ON" or "Wallhack OFF", state and Color3.fromRGB(180,0,255) or nil)

    if state then
        clearWallhack()
        updateWallhack()

        local conn1 = Players.PlayerAdded:Connect(function(plr)
            local conn2 = plr.CharacterAdded:Connect(function(char)
                task.wait(0.3)
                if wallhackEnabled then
                    applyWallhackToChar(char)
                end
            end)
            table.insert(highlightConnections, conn2)
        end)
        table.insert(highlightConnections, conn1)

        local conn3 = LocalPlayer.CharacterAdded:Connect(function()
            task.wait(0.5)
            if wallhackEnabled then
                updateWallhack()
            end
        end)
        table.insert(highlightConnections, conn3)
    else
        clearWallhack()
    end
end)

-- ANTI-AFK
afkTumbler.onToggle(function(state)
    antiAFKEnabled = state
    setStatus(state and "Anti-AFK ON" or "Anti-AFK OFF", state and Color3.fromRGB(255,200,0) or nil)

    if state then
        if antiAFKConnection then antiAFKConnection:Disconnect() end
        antiAFKConnection = RunService.Heartbeat:Connect(function()
            if not antiAFKEnabled then return end
            if not antiAFKConnection.lastTime then
                antiAFKConnection.lastTime = tick()
            end
            if tick() - antiAFKConnection.lastTime >= 15 then
                antiAFKConnection.lastTime = tick()
                local keys = {Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.Space}
                local key = keys[math.random(1, #keys)]
                UserInputService:SetKeyDown(key)
                task.wait(0.1)
                UserInputService:SetKeyUp(key)
            end
        end)
    else
        if antiAFKConnection then
            antiAFKConnection:Disconnect()
            antiAFKConnection = nil
        end
    end
end)

-- GODMODE
godTumbler.onToggle(function(state)
    godmodeEnabled = state
    setStatus(state and "Godmode ON - You are immortal!" or "Godmode OFF", state and Color3.fromRGB(255, 0, 200) or nil)

    if state then
        enableGodmode()
    else
        disableGodmode()
    end
end)

-- INFINITE JUMP
infJumpTumbler.onToggle(function(state)
    infiniteJumpEnabled = state
    setStatus(state and "Infinite Jump ON" or "Infinite Jump OFF", state and Color3.fromRGB(0, 255, 255) or nil)

    if state then
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not infiniteJumpEnabled then return end
            if gameProcessed then return end
            if input.KeyCode == Enum.KeyCode.Space then
                local char = LocalPlayer.Character
                if char then
                    local humanoid = char:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end
        end)
    end
end)

-- TP Tool functions
local function createTPTool()
    local tool = Instance.new("Tool")
    tool.Name = "WIA_TP"
    tool.RequiresHandle = false
    tool.CanBeDropped = false

    local function teleport(mousePos)
        if not tpEnabled then return end
        local targetPos = mousePos.Hit.Position
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            root.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))

            local part = Instance.new("Part")
            part.Size = Vector3.new(2, 0.5, 2)
            part.Position = targetPos
            part.Anchored = true
            part.CanCollide = false
            part.BrickColor = BrickColor.new("Bright violet")
            part.Material = Enum.Material.Neon
            part.Transparency = 0.5
            part.Parent = workspace
            game:GetService("Debris"):AddItem(part, 0.5)
        end
    end

    tool.Equipped:Connect(function()
        tpEnabled = true
        TPEnableToggle.Text = "ON"
        Mouse.Icon = "rbxasset://SystemCursors/Crosshair"
        setStatus("TP Ready - Click to teleport", Color3.fromRGB(0,255,150))
    end)

    tool.Unequipped:Connect(function()
        tpEnabled = false
        TPEnableToggle.Text = "OFF"
        Mouse.Icon = "rbxasset://SystemCursors/Arrow"
        setStatus("TP Off")
    end)

    tool.Activated:Connect(function()
        if tpEnabled then
            teleport(Mouse)
        end
    end)

    return tool
end

tpToolTumbler.onToggle(function(state)
    if not state then
        if tpTool then
            tpTool:Destroy()
            tpTool = nil
        end
        TPToolButton.Text = "Get Tool"
        TPEnableToggle.Text = "OFF"
        tpEnabled = false
        Mouse.Icon = "rbxasset://SystemCursors/Arrow"
        setStatus("TP Tool removed")
        return
    end

    if not tpTool then
        tpTool = createTPTool()
        tpTool.Parent = LocalPlayer.Backpack
        TPToolButton.Text = "Remove"
        setStatus("TP Tool added", Color3.fromRGB(0,255,150))

        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:EquipTool(tpTool)
        end
    else
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") and tpTool then
            char.Humanoid:EquipTool(tpTool)
        end
    end
end)

TPToolButton.MouseButton1Click:Connect(function()
    local state = tpToolTumbler.getState()
    if state then
        if tpTool then
            tpTool:Destroy()
            tpTool = nil
        end
        TPToolButton.Text = "Get Tool"
        TPEnableToggle.Text = "OFF"
        tpEnabled = false
        Mouse.Icon = "rbxasset://SystemCursors/Arrow"
        setStatus("TP Tool removed")
        tpToolTumbler.setState(false)
    else
        tpTool = createTPTool()
        tpTool.Parent = LocalPlayer.Backpack
        TPToolButton.Text = "Remove"
        setStatus("TP Tool added", Color3.fromRGB(0,255,150))
        tpToolTumbler.setState(true)

        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:EquipTool(tpTool)
        end
    end
end)

TPEnableToggle.MouseButton1Click:Connect(function()
    if not tpTool then
        setStatus("Get TP Tool first!", Color3.fromRGB(255,100,100))
        return
    end
    tpEnabled = not tpEnabled
    TPEnableToggle.Text = tpEnabled and "ON" or "OFF"
    Mouse.Icon = tpEnabled and "rbxasset://SystemCursors/Crosshair" or "rbxasset://SystemCursors/Arrow"
    setStatus(tpEnabled and "TP Active" or "TP Inactive", tpEnabled and Color3.fromRGB(0,255,150) or nil)
end)

SpeedSlider.FocusLost:Connect(function()
    local num = tonumber(SpeedSlider.Text)
    if num and num > 0 and num < 500 then
        flySpeed = num
        SpeedSlider.Text = tostring(num)
        setStatus("Fly Speed set to " .. num)
    else
        SpeedSlider.Text = tostring(flySpeed)
    end
end)

-- Walk Speed & Jump Power toggle (auto-enable when value changes)
walkSpeedEnabled = true
jumpPowerEnabled = true

-- Set initial values
task.wait(0.5)
local char = LocalPlayer.Character
if char then
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
        originalWalkSpeed = humanoid.WalkSpeed
        originalJumpPower = humanoid.JumpPower
    end
end

-- Flight update
RunService.Heartbeat:Connect(function()
    if not flightEnabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local moveDirection = Vector3.new(0, 0, 0)
    local forward = Camera.CFrame.LookVector
    local right = Camera.CFrame.RightVector
    local up = Camera.CFrame.UpVector

    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + forward end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - forward end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - right end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + right end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + up end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection - up end

    if moveDirection.Magnitude > 0 then
        moveDirection = moveDirection.Unit * flySpeed
        bodyVelocity.Velocity = moveDirection
        local lookAt = root.Position + moveDirection
        bodyGyro.CFrame = CFrame.new(root.Position, lookAt)
    else
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
end)

-- Cleanup on death
LocalPlayer.CharacterAdded:Connect(function()
    if flightEnabled then
        task.wait(0.5)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            if not bodyVelocity then
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                bodyVelocity.Parent = char.HumanoidRootPart
            end
            if not bodyGyro then
                bodyGyro = Instance.new("BodyGyro")
                bodyGyro.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
                bodyGyro.CFrame = char.HumanoidRootPart.CFrame
                bodyGyro.Parent = char.HumanoidRootPart
            end
        end
    end

    if noclipEnabled then
        task.wait(0.3)
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end

    if godmodeEnabled then
        task.wait(0.3)
        enableGodmode()
    end

    if walkSpeedEnabled then
        task.wait(0.3)
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = walkSpeedValue
            end
        end
    end

    if jumpPowerEnabled then
        task.wait(0.3)
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.JumpPower = jumpPowerValue
            end
        end
    end

    if tpTool then
        task.wait(0.5)
        tpTool.Parent = LocalPlayer.Backpack
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:EquipTool(tpTool)
        end
    end

    if wallhackEnabled then
        task.wait(0.5)
        updateWallhack()
    end
end)

-- Purple
local PURPLE = Color3.fromRGB(180, 0, 255)

-- Drawing
RunService.RenderStepped:Connect(function()
    for i = #espLines, 1, -1 do espLines[i]:Remove() espLines[i] = nil end
    for i = #tracerLines, 1, -1 do tracerLines[i]:Remove() tracerLines[i] = nil end

    if not (espEnabled or tracerEnabled) then return end

    local players = Players:GetPlayers()
    local camPos = Camera.CFrame.Position
    local viewport = Camera.ViewportSize

    for i = 1, #players do
        local plr = players[i]
        if plr ~= LocalPlayer and plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            if head then
                local pos, onScreen = Camera:WorldToScreenPoint(head.Position)
                if onScreen then
                    local dist = (head.Position - camPos).Magnitude
                    local size = math.clamp(100 / dist * 10, 15, 40)

                    if espEnabled then
                        local lines = {
                            Drawing.new("Line"), Drawing.new("Line"),
                            Drawing.new("Line"), Drawing.new("Line")
                        }
                        local x, y = pos.X - size/2, pos.Y - size/2
                        local w, h = size, size
                        lines[1].From = Vector2.new(x, y)
                        lines[1].To = Vector2.new(x + w, y)
                        lines[2].From = Vector2.new(x + w, y)
                        lines[2].To = Vector2.new(x + w, y + h)
                        lines[3].From = Vector2.new(x + w, y + h)
                        lines[3].To = Vector2.new(x, y + h)
                        lines[4].From = Vector2.new(x, y + h)
                        lines[4].To = Vector2.new(x, y)

                        for j = 1, 4 do
                            lines[j].Color = PURPLE
                            lines[j].Thickness = 2
                            lines[j].Transparency = 1
                            espLines[#espLines + 1] = lines[j]
                        end
                    end

                    if tracerEnabled then
                        local tracer = Drawing.new("Line")
                        tracer.From = Vector2.new(viewport.X/2, viewport.Y)
                        tracer.To = Vector2.new(pos.X, pos.Y)
                        tracer.Color = PURPLE
                        tracer.Thickness = 1.5
                        tracer.Transparency = 0.7
                        tracerLines[#tracerLines + 1] = tracer
                    end
                end
            end
        end
    end
end)

-- Update canvas after everything
task.wait(0.1)
updateCanvas()