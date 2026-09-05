-- WIA HUB :: ESP + Tracers + Flight :: whitewia/tordark
-- Optimized, fixed head ESP, purple theme, draggable, LCTRL hide

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Flight variables
local flightEnabled = false
local flySpeed = 50
local bodyVelocity = nil
local bodyGyro = nil

-- GUI (CoreGui)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WiaHubGUI"
ScreenGui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 240, 0, 130)
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

-- Buttons
local EspToggle = Instance.new("TextButton")
EspToggle.Size = UDim2.new(0, 70, 0, 25)
EspToggle.Position = UDim2.new(0, 5, 0, 25)
EspToggle.Text = "ESP: ON"
EspToggle.TextColor3 = Color3.fromRGB(255,255,255)
EspToggle.BackgroundColor3 = Color3.fromRGB(40,40,50)
EspToggle.Parent = Frame

local TracersToggle = Instance.new("TextButton")
TracersToggle.Size = UDim2.new(0, 70, 0, 25)
TracersToggle.Position = UDim2.new(0, 80, 0, 25)
TracersToggle.Text = "TR: ON"
TracersToggle.TextColor3 = Color3.fromRGB(255,255,255)
TracersToggle.BackgroundColor3 = Color3.fromRGB(40,40,50)
TracersToggle.Parent = Frame

local FlightToggle = Instance.new("TextButton")
FlightToggle.Size = UDim2.new(0, 70, 0, 25)
FlightToggle.Position = UDim2.new(0, 155, 0, 25)
FlightToggle.Text = "FLY: OFF"
FlightToggle.TextColor3 = Color3.fromRGB(255,255,255)
FlightToggle.BackgroundColor3 = Color3.fromRGB(40,40,50)
FlightToggle.Parent = Frame

-- Speed slider
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0, 50, 0, 20)
SpeedLabel.Position = UDim2.new(0, 5, 0, 55)
SpeedLabel.Text = "SPD: 50"
SpeedLabel.TextColor3 = Color3.fromRGB(255,255,255)
SpeedLabel.TextScaled = true
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Parent = Frame

local SpeedSlider = Instance.new("TextBox")
SpeedSlider.Size = UDim2.new(0, 60, 0, 20)
SpeedSlider.Position = UDim2.new(0, 60, 0, 55)
SpeedSlider.Text = "50"
SpeedSlider.TextColor3 = Color3.fromRGB(255,255,255)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(40,40,50)
SpeedSlider.Parent = Frame

SpeedSlider.FocusLost:Connect(function()
    local num = tonumber(SpeedSlider.Text)
    if num and num > 0 and num < 500 then
        flySpeed = num
        SpeedLabel.Text = "SPD: " .. num
    else
        SpeedSlider.Text = tostring(flySpeed)
    end
end)

-- State vars
local espEnabled = true
local tracerEnabled = true

EspToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    EspToggle.Text = espEnabled and "ESP: ON" or "ESP: OFF"
end)

TracersToggle.MouseButton1Click:Connect(function()
    tracerEnabled = not tracerEnabled
    TracersToggle.Text = tracerEnabled and "TR: ON" or "TR: OFF"
end)

FlightToggle.MouseButton1Click:Connect(function()
    flightEnabled = not flightEnabled
    FlightToggle.Text = flightEnabled and "FLY: ON" or "FLY: OFF"
    
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

-- Flight update (optimized)
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
        
        -- Face movement direction
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
end)

-- Purple
local PURPLE = Color3.fromRGB(180, 0, 255)

-- Drawing (optimized)
local espLines = {}
local tracerLines = {}

RunService.RenderStepped:Connect(function()
    -- clear old
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
                    
                    -- ESP box around HEAD
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
                    
                    -- Tracer to HEAD
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