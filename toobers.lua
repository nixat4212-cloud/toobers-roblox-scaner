-- WIA HUB :: ESP + Tracers + Flight + Noclip + TP Tool + Wallhack + Anti-AFK :: whitewia/tordark
-- FIXED: Wallhack toggle, cleaner GUI, status bar

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
local highlightConnections = {}
local whHighlights = {}

-- Anti-AFK variables
local antiAFKEnabled = false
local antiAFKConnection = nil

-- GUI (CoreGui) - CLEANER LAYOUT
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WiaHubGUI"
ScreenGui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 320, 0, 145)
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
Frame.BackgroundTransparency = 0.6
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

-- Title with underline
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 22)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "WIA HUB v3"
Title.TextColor3 = Color3.fromRGB(180, 0, 255)
Title.TextScaled = true
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

local Underline = Instance.new("Frame")
Underline.Size = UDim2.new(1, -20, 0, 1)
Underline.Position = UDim2.new(0, 10, 0, 22)
Underline.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
Underline.BackgroundTransparency = 0.5
Underline.Parent = Frame

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

-- Button creation function
local function createButton(text, x, y, width, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, width or 55, 0, 22)
    btn.Position = UDim2.new(0, x, 0, y)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,55)
    btn.BorderSizePixel = 0
    btn.Parent = parent
    return btn
end

-- Row 1: ESP | TR | FLY | NC | WH | AFK
local EspToggle = createButton("ESP", 5, 27, 48, Frame)
local TracersToggle = createButton("TR", 57, 27, 40, Frame)
local FlightToggle = createButton("FLY", 101, 27, 45, Frame)
local NoclipToggle = createButton("NC", 150, 27, 40, Frame)
local WallhackToggle = createButton("WH", 194, 27, 40, Frame)
local AntiAFKToggle = createButton("AFK", 238, 27, 40, Frame)
local TPToggle = createButton("TP", 282, 27, 32, Frame)

-- Row 2: TP Tool button + Speed slider
local TPToolButton = createButton("GET TP", 5, 53, 85, Frame)
local TPEnableToggle = createButton("OFF", 94, 53, 45, Frame)

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0, 35, 0, 20)
SpeedLabel.Position = UDim2.new(0, 150, 0, 54)
SpeedLabel.Text = "SPD"
SpeedLabel.TextColor3 = Color3.fromRGB(255,255,255)
SpeedLabel.TextScaled = true
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.Parent = Frame

local SpeedSlider = Instance.new("TextBox")
SpeedSlider.Size = UDim2.new(0, 45, 0, 20)
SpeedSlider.Position = UDim2.new(0, 188, 0, 54)
SpeedSlider.Text = "50"
SpeedSlider.TextColor3 = Color3.fromRGB(255,255,255)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(40,40,55)
SpeedSlider.BorderSizePixel = 0
SpeedSlider.Parent = Frame

-- Status bar (full width)
local StatusBar = Instance.new("TextLabel")
StatusBar.Size = UDim2.new(1, -10, 0, 18)
StatusBar.Position = UDim2.new(0, 5, 0, 80)
StatusBar.Text = "READY"
StatusBar.TextColor3 = Color3.fromRGB(150, 150, 180)
StatusBar.TextScaled = true
StatusBar.BackgroundTransparency = 1
StatusBar.Font = Enum.Font.Gotham
StatusBar.Parent = Frame

-- State vars
local espEnabled = true
local tracerEnabled = true
local espLines = {}
local tracerLines = {}

-- Status update
local function setStatus(text, color)
    StatusBar.Text = text
    if color then
        StatusBar.TextColor3 = color
    else
        StatusBar.TextColor3 = Color3.fromRGB(150, 150, 180)
    end
end

-- Toggle functions
EspToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    EspToggle.Text = espEnabled and "ESP" or "OFF"
    setStatus(espEnabled and "ESP ON" or "ESP OFF")
end)

TracersToggle.MouseButton1Click:Connect(function()
    tracerEnabled = not tracerEnabled
    TracersToggle.Text = tracerEnabled and "TR" or "OFF"
    setStatus(tracerEnabled and "TRACERS ON" or "TRACERS OFF")
end)

FlightToggle.MouseButton1Click:Connect(function()
    flightEnabled = not flightEnabled
    FlightToggle.Text = flightEnabled and "FLY" or "OFF"
    setStatus(flightEnabled and "FLY ON" or "FLY OFF", flightEnabled and Color3.fromRGB(0,255,200) or nil)
    
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
    setStatus(noclipEnabled and "NOCLIP ON" or "NOCLIP OFF", noclipEnabled and Color3.fromRGB(0,200,255) or nil)
    
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

-- WALLHACK - FIXED
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
    
    -- Clean all characters
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local wh = plr.Character:FindFirstChild("WIA_WH")
            if wh then wh:Destroy() end
        end
    end
end

local function applyWallhackToChar(char)
    if not char or not wallhackEnabled then return end
    
    -- Remove old
    local old = char:FindFirstChild("WIA_WH")
    if old then old:Destroy() end
    
    -- Create new Highlight
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
    
    -- Apply to all players
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            applyWallhackToChar(plr.Character)
        end
    end
end

WallhackToggle.MouseButton1Click:Connect(function()
    wallhackEnabled = not wallhackEnabled
    WallhackToggle.Text = wallhackEnabled and "WH" or "OFF"
    setStatus(wallhackEnabled and "WALLHACK ON" or "WALLHACK OFF", wallhackEnabled and Color3.fromRGB(180,0,255) or nil)
    
    if wallhackEnabled then
        -- Clean old first
        clearWallhack()
        
        -- Apply to existing players
        updateWallhack()
        
        -- Listen for new players
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
        
        -- Reapply on respawn
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
AntiAFKToggle.MouseButton1Click:Connect(function()
    antiAFKEnabled = not antiAFKEnabled
    AntiAFKToggle.Text = antiAFKEnabled and "AFK" or "OFF"
    setStatus(antiAFKEnabled and "ANTI-AFK ON" or "ANTI-AFK OFF", antiAFKEnabled and Color3.fromRGB(255,200,0) or nil)
    
    if antiAFKEnabled then
        if antiAFKConnection then antiAFKConnection:Disconnect() end
        
        antiAFKConnection = RunService.Heartbeat:Connect(function()
            if not antiAFKEnabled then return end
            
            if not antiAFKConnection.lastTime then
                antiAFKConnection.lastTime = tick()
            end
            
            if tick() - antiAFKConnection.lastTime >= 15 then
                antiAFKConnection.lastTime = tick()
                
                local keys = {
                    Enum.KeyCode.W,
                    Enum.KeyCode.A,
                    Enum.KeyCode.S,
                    Enum.KeyCode.D,
                    Enum.KeyCode.Space
                }
                
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
        setStatus("TP READY - Click to teleport", Color3.fromRGB(0,255,150))
    end)
    
    tool.Unequipped:Connect(function()
        tpEnabled = false
        TPEnableToggle.Text = "OFF"
        Mouse.Icon = "rbxasset://SystemCursors/Arrow"
        setStatus("TP OFF")
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
        TPToolButton.Text = "GET TP"
        TPEnableToggle.Text = "OFF"
        tpEnabled = false
        Mouse.Icon = "rbxasset://SystemCursors/Arrow"
        setStatus("TP Tool removed")
        return
    end
    
    tpTool = createTPTool()
    tpTool.Parent = LocalPlayer.Backpack
    TPToolButton.Text = "REMOVE"
    setStatus("TP Tool added to backpack", Color3.fromRGB(0,255,150))
    
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid:EquipTool(tpTool)
    end
end)

TPToggle.MouseButton1Click:Connect(function()
    if not tpTool then
        setStatus("Get TP Tool first!", Color3.fromRGB(255,100,100))
        return
    end
    tpEnabled = not tpEnabled
    TPToggle.Text = tpEnabled and "TP" or "OFF"
    Mouse.Icon = tpEnabled and "rbxasset://SystemCursors/Crosshair" or "rbxasset://SystemCursors/Arrow"
    setStatus(tpEnabled and "TP ACTIVE" or "TP INACTIVE", tpEnabled and Color3.fromRGB(0,255,150) or nil)
end)

SpeedSlider.FocusLost:Connect(function()
    local num = tonumber(SpeedSlider.Text)
    if num and num > 0 and num < 500 then
        flySpeed = num
        SpeedSlider.Text = tostring(num)
        setStatus("Speed set to " .. num)
    else
        SpeedSlider.Text = tostring(flySpeed)
    end
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