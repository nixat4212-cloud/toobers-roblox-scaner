-- WIA HUB :: ESP + Tracers + Flight + Noclip + TP Tool + Wallhack + Anti-AFK :: whitewia/tordark
-- Optimized, head ESP, purple theme, draggable, LCTRL hide

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

-- TP Tool variables
local tpTool = nil
local tpEnabled = false

-- Wallhack variables
local wallhackEnabled = false
local highlightHandle = nil

-- Anti-AFK variables
local antiAFKEnabled = false
local antiAFKConnection = nil

-- GUI (CoreGui)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WiaHubGUI"
ScreenGui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 380, 0, 190)
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Frame.BackgroundTransparency = 0.5
Frame.Parent = ScreenGui

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 20)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "WIA HUB"
Title.TextColor3 = Color3.fromRGB(180, 0, 255)
Title.TextScaled = true
Title.BackgroundTransparency = 1
Title.Parent = Frame

-- Draggable
local dragging = false
local dragStart, startPos

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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

-- Buttons (row 1)
local EspToggle = Instance.new("TextButton")
EspToggle.Size = UDim2.new(0, 55, 0, 22)
EspToggle.Position = UDim2.new(0, 5, 0, 25)
EspToggle.Text = "ESP"
EspToggle.TextColor3 = Color3.fromRGB(255,255,255)
EspToggle.BackgroundColor3 = Color3.fromRGB(40,40,50)
EspToggle.Parent = Frame

local TracersToggle = Instance.new("TextButton")
TracersToggle.Size = UDim2.new(0, 55, 0, 22)
TracersToggle.Position = UDim2.new(0, 65, 0, 25)
TracersToggle.Text = "TR"
TracersToggle.TextColor3 = Color3.fromRGB(255,255,255)
TracersToggle.BackgroundColor3 = Color3.fromRGB(40,40,50)
TracersToggle.Parent = Frame

local FlightToggle = Instance.new("TextButton")
FlightToggle.Size = UDim2.new(0, 55, 0, 22)
FlightToggle.Position = UDim2.new(0, 125, 0, 25)
FlightToggle.Text = "FLY"
FlightToggle.TextColor3 = Color3.fromRGB(255,255,255)
FlightToggle.BackgroundColor3 = Color3.fromRGB(40,40,50)
FlightToggle.Parent = Frame

local NoclipToggle = Instance.new("TextButton")
NoclipToggle.Size = UDim2.new(0, 55, 0, 22)
NoclipToggle.Position = UDim2.new(0, 185, 0, 25)
NoclipToggle.Text = "NC"
NoclipToggle.TextColor3 = Color3.fromRGB(255,255,255)
NoclipToggle.BackgroundColor3 = Color3.fromRGB(40,40,50)
NoclipToggle.Parent = Frame

local WallhackToggle = Instance.new("TextButton")
WallhackToggle.Size = UDim2.new(0, 55, 0, 22)
WallhackToggle.Position = UDim2.new(0, 245, 0, 25)
WallhackToggle.Text = "WH"
WallhackToggle.TextColor3 = Color3.fromRGB(255,255,255)
WallhackToggle.BackgroundColor3 = Color3.fromRGB(40,40,50)
WallhackToggle.Parent = Frame

local AntiAFKToggle = Instance.new("TextButton")
AntiAFKToggle.Size = UDim2.new(0, 55, 0, 22)
AntiAFKToggle.Position = UDim2.new(0, 305, 0, 25)
AntiAFKToggle.Text = "AFK"
AntiAFKToggle.TextColor3 = Color3.fromRGB(255,255,255)
AntiAFKToggle.BackgroundColor3 = Color3.fromRGB(40,40,50)
AntiAFKToggle.Parent = Frame

-- TP Tool buttons (row 2)
local TPToolButton = Instance.new("TextButton")
TPToolButton.Size = UDim2.new(0, 100, 0, 22)
TPToolButton.Position = UDim2.new(0, 5, 0, 52)
TPToolButton.Text = "GET TP TOOL"
TPToolButton.TextColor3 = Color3.fromRGB(255,255,255)
TPToolButton.BackgroundColor3 = Color3.fromRGB(40,40,50)
TPToolButton.Parent = Frame

local TPEnableToggle = Instance.new("TextButton")
TPEnableToggle.Size = UDim2.new(0, 60, 0, 22)
TPEnableToggle.Position = UDim2.new(0, 110, 0, 52)
TPEnableToggle.Text = "TP OFF"
TPEnableToggle.TextColor3 = Color3.fromRGB(255,255,255)
TPEnableToggle.BackgroundColor3 = Color3.fromRGB(40,40,50)
TPEnableToggle.Parent = Frame

-- Speed slider (row 3)
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0, 50, 0, 20)
SpeedLabel.Position = UDim2.new(0, 5, 0, 80)
SpeedLabel.Text = "SPD:50"
SpeedLabel.TextColor3 = Color3.fromRGB(255,255,255)
SpeedLabel.TextScaled = true
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Parent = Frame

local SpeedSlider = Instance.new("TextBox")
SpeedSlider.Size = UDim2.new(0, 60, 0, 20)
SpeedSlider.Position = UDim2.new(0, 60, 0, 80)
SpeedSlider.Text = "50"
SpeedSlider.TextColor3 = Color3.fromRGB(255,255,255)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(40,40,50)
SpeedSlider.Parent = Frame

SpeedSlider.FocusLost:Connect(function()
    local num = tonumber(SpeedSlider.Text)
    if num and num > 0 and num < 500 then
        flySpeed = num
        SpeedLabel.Text = "SPD:" .. num
    else
        SpeedSlider.Text = tostring(flySpeed)
    end
end)

-- Status bar (row 4)
local StatusBar = Instance.new("TextLabel")
StatusBar.Size = UDim2.new(1, -10, 0, 20)
StatusBar.Position = UDim2.new(0, 5, 0, 105)
StatusBar.Text = "STATUS: READY"
StatusBar.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusBar.TextScaled = true
StatusBar.BackgroundTransparency = 1
StatusBar.Parent = Frame

-- State vars
local espEnabled = true
local tracerEnabled = true
local espLines = {}
local tracerLines = {}

-- Toggle functions
EspToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    EspToggle.Text = espEnabled and "ESP" or "OFF"
end)

TracersToggle.MouseButton1Click:Connect(function()
    tracerEnabled = not tracerEnabled
    TracersToggle.Text = tracerEnabled and "TR" or "OFF"
end)

FlightToggle.MouseButton1Click:Connect(function()
    flightEnabled = not flightEnabled
    FlightToggle.Text = flightEnabled and "FLY" or "OFF"
    StatusBar.Text = flightEnabled and "STATUS: FLY ON" or "STATUS: FLY OFF"
    
    if flightEnabled then
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

NoclipToggle.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    NoclipToggle.Text = noclipEnabled and "NC" or "OFF"
    StatusBar.Text = noclipEnabled and "STATUS: NOCLIP ON" or "STATUS: NOCLIP OFF"
    
    if noclipEnabled then
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
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

-- WALLHACK
WallhackToggle.MouseButton1Click:Connect(function()
    wallhackEnabled = not wallhackEnabled
    WallhackToggle.Text = wallhackEnabled and "WH" or "OFF"
    StatusBar.Text = wallhackEnabled and "STATUS: WALLHACK ON" or "STATUS: WALLHACK OFF"
    
    if wallhackEnabled then
        -- Создаём Highlight для всех игроков
        if not highlightHandle then
            highlightHandle = Instance.new("Highlight")
            highlightHandle.Name = "WIA_Wallhack"
            highlightHandle.FillColor = Color3.fromRGB(180, 0, 255)
            highlightHandle.FillTransparency = 0.3
            highlightHandle.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlightHandle.OutlineTransparency = 0.2
            highlightHandle.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlightHandle.Parent = game:GetService("CoreGui")
        end
        
        -- Обновляем список игроков
        local function updateWallhack()
            if not wallhackEnabled then return end
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    if not plr.Character:FindFirstChild("WIA_WH") then
                        local clone = highlightHandle:Clone()
                        clone.Name = "WIA_WH"
                        clone.Parent = plr.Character
                    end
                end
            end
        end
        
        updateWallhack()
        
        -- Автообновление при появлении новых игроков
        Players.PlayerAdded:Connect(function(plr)
            if wallhackEnabled then
                plr.CharacterAdded:Connect(function(char)
                    task.wait(0.5)
                    if wallhackEnabled and char then
                        local clone = highlightHandle:Clone()
                        clone.Name = "WIA_WH"
                        clone.Parent = char
                    end
                end)
            end
        end)
        
        -- Очистка при смерти
        local function cleanupCharacters()
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local wh = plr.Character:FindFirstChild("WIA_WH")
                    if wh then wh:Destroy() end
                end
            end
        end
        
        -- Обновление каждый раз при респавне
        LocalPlayer.CharacterAdded:Connect(function()
            task.wait(0.5)
            if wallhackEnabled then
                cleanupCharacters()
                task.wait(0.2)
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character then
                        if not plr.Character:FindFirstChild("WIA_WH") then
                            local clone = highlightHandle:Clone()
                            clone.Name = "WIA_WH"
                            clone.Parent = plr.Character
                        end
                    end
                end
            end
        end)
        
        -- Первичное применение
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local clone = highlightHandle:Clone()
                clone.Name = "WIA_WH"
                clone.Parent = plr.Character
            end
        end
    else
        -- Удаляем все Highlight
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local wh = plr.Character:FindFirstChild("WIA_WH")
                if wh then wh:Destroy() end
            end
        end
    end
end)

-- ANTI-AFK
AntiAFKToggle.MouseButton1Click:Connect(function()
    antiAFKEnabled = not antiAFKEnabled
    AntiAFKToggle.Text = antiAFKEnabled and "AFK" or "OFF"
    StatusBar.Text = antiAFKEnabled and "STATUS: AFK ON" or "STATUS: AFK OFF"
    
    if antiAFKEnabled then
        if antiAFKConnection then antiAFKConnection:Disconnect() end
        
        -- Цикл анти-AFK
        antiAFKConnection = RunService.Heartbeat:Connect(function()
            if not antiAFKEnabled then return end
            
            -- Симуляция движения каждые 15 секунд
            local currentTime = tick()
            if not antiAFKConnection.lastTime then
                antiAFKConnection.lastTime = currentTime
            end
            
            if currentTime - antiAFKConnection.lastTime >= 15 then
                antiAFKConnection.lastTime = currentTime
                
                -- Случайное движение
                local keys = {
                    Enum.KeyCode.W,
                    Enum.KeyCode.A,
                    Enum.KeyCode.S,
                    Enum.KeyCode.D,
                    Enum.KeyCode.Space
                }
                
                local key = keys[math.random(1, #keys)]
                
                -- Имитируем нажатие и отпускание
                UserInputService:SetKeyDown(key)
                task.wait(0.1)
                UserInputService:SetKeyUp(key)
                
                -- Иногда прыжок
                if math.random(1, 3) == 1 then
                    UserInputService:SetKeyDown(Enum.KeyCode.Space)
                    task.wait(0.05)
                    UserInputService:SetKeyUp(Enum.KeyCode.Space)
                end
            end
        end)
    else
        if antiAFKConnection then
            antiAFKConnection:Disconnect()
            antiAFKConnection = nil
        end
    end
end)

-- TP Tool functions
local function createTPTool()
    local tool = Instance.new("Tool")
    tool.Name = "WIA_TP_Tool"
    tool.RequiresHandle = false
    tool.CanBeDropped = false
    
    local function teleport(mousePos)
        if not tpEnabled then return end
        local targetPos = mousePos.Hit.Position
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            root.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
            
            -- Visual feedback
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
            
            -- Sound
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://9120107390"
            sound.Volume = 1
            sound.Parent = root
            sound:Play()
            game:GetService("Debris"):AddItem(sound, 1)
        end
    end
    
    tool.Equipped:Connect(function()
        tpEnabled = true
        TPEnableToggle.Text = "TP ON"
        Mouse.Icon = "rbxasset://SystemCursors/Crosshair"
        StatusBar.Text = "STATUS: TP READY"
    end)
    
    tool.Unequipped:Connect(function()
        tpEnabled = false
        TPEnableToggle.Text = "TP OFF"
        Mouse.Icon = "rbxasset://SystemCursors/Arrow"
        StatusBar.Text = "STATUS: TP OFF"
    end)
    
    tool.Activated:Connect(function()
        if tpEnabled then
            teleport(Mouse)
        end
    end)
    
    return tool
end

TPToolButton.MouseButton1Click:Connect(function()
    if tpTool then
        tpTool:Destroy()
        tpTool = nil
        TPToolButton.Text = "GET TP TOOL"
        TPEnableToggle.Text = "TP OFF"
        tpEnabled = false
        Mouse.Icon = "rbxasset://SystemCursors/Arrow"
        StatusBar.Text = "STATUS: TOOL REMOVED"
        return
    end
    
    tpTool = createTPTool()
    tpTool.Parent = LocalPlayer.Backpack
    TPToolButton.Text = "REMOVE"
    StatusBar.Text = "STATUS: TP TOOL ADDED"
    
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid:EquipTool(tpTool)
    end
end)

TPEnableToggle.MouseButton1Click:Connect(function()
    if not tpTool then return end
    tpEnabled = not tpEnabled
    TPEnableToggle.Text = tpEnabled and "TP ON" or "TP OFF"
    Mouse.Icon = tpEnabled and "rbxasset://SystemCursors/Crosshair" or "rbxasset://SystemCursors/Arrow"
    StatusBar.Text = tpEnabled and "STATUS: TP ACTIVE" or "STATUS: TP INACTIVE"
end)

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
        local newCFrame = CFrame.new(root.Position, lookAt)
        bodyGyro.CFrame = newCFrame
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
    
    if tpTool then
        task.wait(0.5)
        tpTool.Parent = LocalPlayer.Backpack
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:EquipTool(tpTool)
        end
    end
    
    -- Reapply wallhack
    if wallhackEnabled then
        task.wait(0.5)
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                if not plr.Character:FindFirstChild("WIA_WH") and highlightHandle then
                    local clone = highlightHandle:Clone()
                    clone.Name = "WIA_WH"
                    clone.Parent = plr.Character
                end
            end
        end
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