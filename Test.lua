local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Fast Attack Settings
local FastAttackEnabled = false
local FastAttackRange = 10^1000
local TOGGLE_KEY = Enum.KeyCode.U
local Net = ReplicatedStorage.Modules.Net
local RegisterHit = Net["RE/RegisterHit"]
local RegisterAttack = Net["RE/RegisterAttack"]
local FastAttackConnection = nil

-- Loop TP Settings
local teleporting = false
local targetPlayer = nil
local teleportCooldown = 0.1

-- Fly Settings
local FlyEnabled = false
local FlySpeed = 150
local FLY_KEY = Enum.KeyCode.G
local FlyConnection = nil
local NoclipConnection = nil

local function CreateGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ScriptHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Frame
    local Frame = Instance.new("Frame")
    Frame.Name = "MainFrame"
    Frame.Parent = ScreenGui
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.BorderSizePixel = 0
    Frame.Position = UDim2.new(0.5, -120, 0.1, 0)
    Frame.Size = UDim2.new(0, 240, 0, 425) 
    Frame.ClipsDescendants = false

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = Frame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(55, 55, 55)
    MainStroke.Thickness = 1
    MainStroke.Parent = Frame

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 32)
    TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Frame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 10)
    TitleCorner.Parent = TitleBar

    local TitleFix = Instance.new("Frame")
    TitleFix.Size = UDim2.new(1, 0, 0, 10)
    TitleFix.Position = UDim2.new(0, 0, 1, -10)
    TitleFix.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TitleFix.BorderSizePixel = 0
    TitleFix.Parent = TitleBar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.TextColor3 = Color3.fromRGB(200, 200, 200)
    Title.Text = "888 Hub"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 13
    Title.BackgroundTransparency = 1
    Title.Parent = TitleBar

    -- ===== FAST ATTACK SECTION =====
    local FATitle = Instance.new("TextLabel")
    FATitle.Size = UDim2.new(0.9, 0, 0, 18)
    FATitle.Position = UDim2.new(0.05, 0, 0, 38)
    FATitle.BackgroundTransparency = 1
    FATitle.TextColor3 = Color3.fromRGB(140, 140, 140)
    FATitle.Text = "FAST ATTACK"
    FATitle.Font = Enum.Font.GothamBold
    FATitle.TextSize = 10
    FATitle.Parent = Frame

    local FastAttackBtn = Instance.new("TextButton")
    FastAttackBtn.Name = "FastAttackBtn"
    FastAttackBtn.Size = UDim2.new(0.9, 0, 0, 32)
    FastAttackBtn.Position = UDim2.new(0.05, 0, 0, 58)
    FastAttackBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    FastAttackBtn.BorderSizePixel = 0
    FastAttackBtn.Font = Enum.Font.GothamBold
    FastAttackBtn.Text = "Fast Attack: OFF"
    FastAttackBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    FastAttackBtn.TextSize = 13
    FastAttackBtn.AutoButtonColor = false
    FastAttackBtn.Parent = Frame

    local FACorner = Instance.new("UICorner")
    FACorner.CornerRadius = UDim.new(0, 6)
    FACorner.Parent = FastAttackBtn

    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(0.85, 0, 0, 1)
    Divider.Position = UDim2.new(0.075, 0, 0, 98)
    Divider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Divider.BorderSizePixel = 0
    Divider.Parent = Frame

    -- ===== LOOP TP SECTION =====
    local TPTitle = Instance.new("TextLabel")
    TPTitle.Size = UDim2.new(0.9, 0, 0, 18)
    TPTitle.Position = UDim2.new(0.05, 0, 0, 105)
    TPTitle.BackgroundTransparency = 1
    TPTitle.TextColor3 = Color3.fromRGB(140, 140, 140)
    TPTitle.Text = "LOOP TELEPORT"
    TPTitle.Font = Enum.Font.GothamBold
    TPTitle.TextSize = 10
    TPTitle.Parent = Frame

    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Size = UDim2.new(0.9, 0, 0, 160)
    ScrollFrame.Position = UDim2.new(0.05, 0, 0, 125)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.BorderSizePixel = 0
    ScrollFrame.ScrollBarThickness = 3
    ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(70, 70, 70)
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollFrame.Parent = Frame

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 2)
    ListLayout.Parent = ScrollFrame

    local TPToggleBtn = Instance.new("TextButton")
    TPToggleBtn.Name = "TPToggleBtn"
    TPToggleBtn.Size = UDim2.new(0.9, 0, 0, 30)
    TPToggleBtn.Position = UDim2.new(0.05, 0, 0, 292)
    TPToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 130, 50)
    TPToggleBtn.BorderSizePixel = 0
    TPToggleBtn.Font = Enum.Font.GothamBold
    TPToggleBtn.Text = "START TP"
    TPToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TPToggleBtn.TextSize = 13
    TPToggleBtn.AutoButtonColor = false
    TPToggleBtn.Parent = Frame

    local TPCorner = Instance.new("UICorner")
    TPCorner.CornerRadius = UDim.new(0, 6)
    TPCorner.Parent = TPToggleBtn

    local TPStatus = Instance.new("TextLabel")
    TPStatus.Size = UDim2.new(0.9, 0, 0, 14)
    TPStatus.Position = UDim2.new(0.05, 0, 0, 328)
    TPStatus.BackgroundTransparency = 1
    TPStatus.TextColor3 = Color3.fromRGB(90, 90, 90)
    TPStatus.Text = "Off"
    TPStatus.Font = Enum.Font.Gotham
    TPStatus.TextSize = 9
    TPStatus.Parent = Frame

    local Divider2 = Instance.new("Frame")
    Divider2.Size = UDim2.new(0.85, 0, 0, 1)
    Divider2.Position = UDim2.new(0.075, 0, 0, 348)
    Divider2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Divider2.BorderSizePixel = 0
    Divider2.Parent = Frame

    -- ===== FLY SECTION =====
    local FlyTitle = Instance.new("TextLabel")
    FlyTitle.Size = UDim2.new(0.9, 0, 0, 18)
    FlyTitle.Position = UDim2.new(0.05, 0, 0, 355)
    FlyTitle.BackgroundTransparency = 1
    FlyTitle.TextColor3 = Color3.fromRGB(140, 140, 140)
    FlyTitle.Text = "FLY [G]"
    FlyTitle.Font = Enum.Font.GothamBold
    FlyTitle.TextSize = 10
    FlyTitle.Parent = Frame

    local FlyBtn = Instance.new("TextButton")
    FlyBtn.Name = "FlyBtn"
    FlyBtn.Size = UDim2.new(0.9, 0, 0, 32)
    FlyBtn.Position = UDim2.new(0.05, 0, 0, 375)
    FlyBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    FlyBtn.BorderSizePixel = 0
    FlyBtn.Font = Enum.Font.GothamBold
    FlyBtn.Text = "Fly: OFF"
    FlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    FlyBtn.TextSize = 13
    FlyBtn.AutoButtonColor = false
    FlyBtn.Parent = Frame

    local FlyCorner = Instance.new("UICorner")
    FlyCorner.CornerRadius = UDim.new(0, 6)
    FlyCorner.Parent = FlyBtn

    local Divider3 = Instance.new("Frame")
    Divider3.Size = UDim2.new(0.85, 0, 0, 1)
    Divider3.Position = UDim2.new(0.075, 0, 0, 412)
    Divider3.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Divider3.BorderSizePixel = 0
    Divider3.Parent = Frame

    local Credit = Instance.new("TextLabel")
    Credit.Size = UDim2.new(1, 0, 0, 13)
    Credit.Position = UDim2.new(0, 0, 1, -13)
    Credit.BackgroundTransparency = 1
    Credit.TextColor3 = Color3.fromRGB(60, 60, 60)
    Credit.Text = "Made by Sardo"
    Credit.Font = Enum.Font.Gotham
    Credit.FontFace = Font.new("rbxassetid://FjwW7ZQRfhtGpRLb9vBFXw", Enum.FontWeight.Medium)
    Credit.TextSize = 10
    Credit.Parent = Frame

    -- Draggable
    local dragging = false
    local dragInput, dragStart, startPos

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    return FastAttackBtn, TPToggleBtn, TPStatus, ScrollFrame, FlyBtn
end

-- Build GUI
local FastAttackBtn, TPToggleBtn, TPStatus, PlayerScrollFrame, FlyBtn = CreateGUI()
local playerButtons = {}

-- ===== PLAYER LIST =====
local function createPlayerButton(player, index)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 24)
    btn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    btn.TextColor3 = Color3.fromRGB(170, 170, 170)
    btn.Text = player.DisplayName
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 0
    btn.LayoutOrder = index
    btn.AutoButtonColor = false
    btn.Parent = PlayerScrollFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 10)
    pad.Parent = btn

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 3, 0.5, 0)
    indicator.Position = UDim2.new(0, 0, 0.25, 0)
    indicator.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    indicator.BorderSizePixel = 0
    indicator.Visible = false
    indicator.Parent = btn

    local indCorner = Instance.new("UICorner")
    indCorner.CornerRadius = UDim.new(0, 2)
    indCorner.Parent = indicator

    btn.MouseEnter:Connect(function()
        if targetPlayer ~= player then
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end
    end)
    btn.MouseLeave:Connect(function()
        if targetPlayer ~= player then
            btn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
        end
    end)

    btn.MouseButton1Click:Connect(function()
        for p, b in pairs(playerButtons) do
            b.Button.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
            b.Indicator.Visible = false
            b.Button.TextColor3 = Color3.fromRGB(170, 170, 170)
        end
        targetPlayer = player
        btn.BackgroundColor3 = Color3.fromRGB(40, 50, 40)
        indicator.Visible = true
        btn.TextColor3 = Color3.fromRGB(100, 220, 100)
        if teleporting then
            TPStatus.Text = "TP > " .. player.DisplayName
        end
    end)

    playerButtons[player] = {Button = btn, Indicator = indicator}
end

local function refreshPlayerList()
    for _, child in pairs(PlayerScrollFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    playerButtons = {}

    local sorted = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Players.LocalPlayer then
            table.insert(sorted, p)
        end
    end
    table.sort(sorted, function(a, b)
        return a.DisplayName:lower() < b.DisplayName:lower()
    end)

    for i, player in pairs(sorted) do
        createPlayerButton(player, i)
    end

    if targetPlayer and playerButtons[targetPlayer] then
        playerButtons[targetPlayer].Button.BackgroundColor3 = Color3.fromRGB(40, 50, 40)
        playerButtons[targetPlayer].Indicator.Visible = true
        playerButtons[targetPlayer].Button.TextColor3 = Color3.fromRGB(100, 220, 100)
    end
end

Players.PlayerAdded:Connect(function() refreshPlayerList() end)
Players.PlayerRemoving:Connect(function(player)
    if player == targetPlayer then
        teleporting = false
        targetPlayer = nil
        TPToggleBtn.Text = "START TP"
        TPToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 130, 50)
        TPStatus.Text = "Player left"
    end
    refreshPlayerList()
end)
refreshPlayerList()

-- ===== FAST ATTACK LOGIC =====
local function AttackMultipleTargets(targets)
    pcall(function()
        if not targets or #targets == 0 then return end
        local allTargets = {}
        for _, targetChar in pairs(targets) do
            local head = targetChar:FindFirstChild("Head")
            if head then
                table.insert(allTargets, {targetChar, head})
            end
        end
        if #allTargets == 0 then return end
        RegisterAttack:FireServer(0)
        RegisterHit:FireServer(allTargets[1][2], allTargets)
    end)
end

local function StartFastAttack()
    if FastAttackConnection then task.cancel(FastAttackConnection) end
    FastAttackConnection = task.spawn(function()
        while FastAttackEnabled do
            task.wait(0.01)
            local myChar = Players.LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myHRP then continue end
            local targetsInRange = {}
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= Players.LocalPlayer and player.Character then
                    local humanoid = player.Character:FindFirstChild("Humanoid")
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if humanoid and hrp and humanoid.Health > 0 then
                        if (hrp.Position - myHRP.Position).Magnitude <= FastAttackRange then
                            table.insert(targetsInRange, player.Character)
                        end
                    end
                end
            end
            local enemiesFolder = workspace:FindFirstChild("Enemies")
            if enemiesFolder then
                for _, npc in pairs(enemiesFolder:GetChildren()) do
                    local humanoid = npc:FindFirstChild("Humanoid")
                    local hrp = npc:FindFirstChild("HumanoidRootPart")
                    if humanoid and hrp and humanoid.Health > 0 then
                        if (hrp.Position - myHRP.Position).Magnitude <= FastAttackRange then
                            table.insert(targetsInRange, npc)
                        end
                    end
                end
            end
            if #targetsInRange > 0 then
                AttackMultipleTargets(targetsInRange)
            end
        end
    end)
end

local function StopFastAttack()
    if FastAttackConnection then
        task.cancel(FastAttackConnection)
        FastAttackConnection = nil
    end
end

local function ToggleFastAttack()
    FastAttackEnabled = not FastAttackEnabled
    if FastAttackEnabled then
        FastAttackBtn.Text = "Fast Attack: ON"
        FastAttackBtn.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
        StartFastAttack()
    else
        FastAttackBtn.Text = "Fast Attack: OFF"
        FastAttackBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        StopFastAttack()
    end
end

FastAttackBtn.MouseButton1Click:Connect(ToggleFastAttack)

-- ===== LOOP TP LOGIC =====
TPToggleBtn.MouseButton1Click:Connect(function()
    if not targetPlayer then
        TPStatus.Text = "Pick a player first!"
        return
    end
    teleporting = not teleporting
    if teleporting then
        TPToggleBtn.Text = "STOP TP"
        TPToggleBtn.BackgroundColor3 = Color3.fromRGB(160, 45, 45)
        TPStatus.Text = "TP > " .. targetPlayer.DisplayName
    else
        TPToggleBtn.Text = "START TP"
        TPToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 130, 50)
        TPStatus.Text = "Off"
    end
end)

local lastTeleport = 0
RunService.Heartbeat:Connect(function()
    if teleporting and targetPlayer then
        local now = tick()
        if now - lastTeleport >= teleportCooldown then
            local char = Players.LocalPlayer.Character
            local tChar = targetPlayer.Character
            if char and tChar then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local tHrp = tChar:FindFirstChild("HumanoidRootPart")
                if hrp and tHrp then
                    hrp.CFrame = tHrp.CFrame * CFrame.new(0, 0, 3)
                    lastTeleport = now
                end
            end
        end
    end
end)

-- ===== NOCLIP LOGIC =====
local function StartNoclip()
    if NoclipConnection then return end
    NoclipConnection = RunService.Stepped:Connect(function()
        local char = Players.LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function StopNoclip()
    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end
    -- Wait a tiny bit before turning collision back on so you don't get stuck in walls
    task.delay(0.2, function()
        local char = Players.LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end)
end

-- ===== FLY LOGIC (REVERTED TO VELOCITY + NOCLIP + NO ANIMATIONS) =====
local function StartFly()
    local char = Players.LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if not hum or not hrp then return end
    
    -- Freeze character and disable animations
    hum.PlatformStand = true
    local animator = hum:FindFirstChildOfClass("Animator")
    if animator then animator.Enabled = false end
    
    -- Enable Noclip so you don't get stuck on parts
    StartNoclip()
    
    FlyConnection = RunService.Heartbeat:Connect(function()
        -- Safety checks
        if not FlyEnabled or not char or not char.Parent then
            StopFly()
            return
        end

        local cam = workspace.CurrentCamera
        local moveDir = Vector3.zero

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end

        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit
        end

        -- Apply the velocity (Old working method)
        hrp.AssemblyLinearVelocity = moveDir * FlySpeed
    end)
end

local function StopFly()
    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end
    
    StopNoclip()
    
    local char = Players.LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if hum then
        hum.PlatformStand = false
        -- Re-enable animations
        local animator = hum:FindFirstChildOfClass("Animator")
        if animator then animator.Enabled = true end
    end
    if hrp then
        hrp.AssemblyLinearVelocity = Vector3.zero
    end
end

local function ToggleFly()
    FlyEnabled = not FlyEnabled
    if FlyEnabled then
        FlyBtn.Text = "Fly: ON"
        FlyBtn.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
        StartFly()
    else
        FlyBtn.Text = "Fly: OFF"
        FlyBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        StopFly()
    end
end

FlyBtn.MouseButton1Click:Connect(ToggleFly)

-- ===== KEYBINDS =====
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == TOGGLE_KEY then
        ToggleFastAttack()
    end
    if input.KeyCode == FLY_KEY then
        ToggleFly()
    end
    if input.KeyCode == Enum.KeyCode.T and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        local gui = FastAttackBtn:FindFirstAncestorOfClass("ScreenGui")
        if gui then gui.Enabled = not gui.Enabled end
    end
end)

print("=================================")
print("Script Hub Loaded!")
print("Made by sardo")
print("U = Toggle Fast Attack")
print("G = Toggle Fly")
print("Ctrl+T = Hide/Show GUI")
print("=================================")
