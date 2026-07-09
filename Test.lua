local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Settings
local FastAttackEnabled = false
local FastAttackRange = 10^1000
local TOGGLE_KEY = Enum.KeyCode.U
local Net = ReplicatedStorage.Modules.Net
local RegisterHit = Net["RE/RegisterHit"]
local RegisterAttack = Net["RE/RegisterAttack"]
local FastAttackConnection = nil

local teleporting = false
local targetPlayer = nil
local teleportCooldown = 0.1

local FlyEnabled = false
local FlySpeed = 250
local FLY_KEY = Enum.KeyCode.G
local FlyConnection = nil
local originalCanCollide = {}

local ESPEnabled = false
local ESPConnection = nil
local ESPObjects = {}

-- UI Theme Colors
local theme = {
    bg = Color3.fromRGB(25, 28, 30),
    card = Color3.fromRGB(32, 35, 38),
    sidebar = Color3.fromRGB(20, 23, 25),
    accentGreen = Color3.fromRGB(0, 255, 136),
    accentBlue = Color3.fromRGB(0, 187, 255),
    textMain = Color3.fromRGB(240, 240, 240),
    textMuted = Color3.fromRGB(120, 120, 125),
    stroke = Color3.fromRGB(255, 255, 255)
}

local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function CreateGradient()
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new(theme.accentGreen, theme.accentBlue)
    grad.Rotation = 90
    return grad
end

local function ApplyHoverEffect(btn)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, tweenInfo, {BackgroundTransparency = 0.7}):Play()
    end)
    btn.MouseLeave:Connect(function()
        if not btn:GetAttribute("Selected") then
            TweenService:Create(btn, tweenInfo, {BackgroundTransparency = 1}):Play()
        end
    end)
end

local function CreateGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NoobezHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 550, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
    MainFrame.BackgroundColor3 = theme.bg
    MainFrame.BackgroundTransparency = 0.05
    MainFrame.Parent = ScreenGui

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = theme.stroke
    MainStroke.Transparency = 0.85
    MainStroke.Thickness = 1

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 38)
    TitleBar.BackgroundColor3 = theme.sidebar
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)
    
    local TitleFix = Instance.new("Frame")
    TitleFix.Size = UDim2.new(1, 0, 0, 12)
    TitleFix.Position = UDim2.new(0, 0, 1, -12)
    TitleFix.BackgroundColor3 = theme.sidebar
    TitleFix.BorderSizePixel = 0
    TitleFix.Parent = TitleBar

    local TitleGradientBar = Instance.new("Frame")
    TitleGradientBar.Size = UDim2.new(1, 0, 0, 2)
    TitleGradientBar.Position = UDim2.new(0, 0, 1, -2)
    TitleGradientBar.BackgroundColor3 = theme.accentGreen
    TitleGradientBar.Parent = TitleBar
    CreateGradient().Parent = TitleGradientBar

    local Icon = Instance.new("TextLabel")
    Icon.Size = UDim2.new(0, 20, 0, 20)
    Icon.Position = UDim2.new(0, 15, 0.5, -10)
    Icon.BackgroundTransparency = 1
    Icon.Text = "◆"
    Icon.TextColor3 = theme.accentGreen
    Icon.TextSize = 14
    Icon.Parent = TitleBar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 100, 1, 0)
    Title.Position = UDim2.new(0, 40, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "noobez Hub"
    Title.TextColor3 = theme.textMain
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar

    local Version = Instance.new("TextLabel")
    Version.Size = UDim2.new(0, 40, 1, 0)
    Version.Position = UDim2.new(1, -50, 0, 0)
    Version.BackgroundTransparency = 1
    Version.Text = "v1.0"
    Version.TextColor3 = theme.textMuted
    Version.Font = Enum.Font.GothamMedium
    Version.TextSize = 11
    Version.Parent = TitleBar

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 120, 1, -38)
    Sidebar.Position = UDim2.new(0, 0, 0, 38)
    Sidebar.BackgroundColor3 = theme.sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    local SideStroke = Instance.new("UIStroke", Sidebar)
    SideStroke.Color = theme.stroke
    SideStroke.Transparency = 0.9
    SideStroke.Thickness = 1

    local Pages = {}
    local TabNames = {"Home", "Combat", "Move", "Visuals"}
    local TabIcons = {"◎", "⚔", "✈", "◎"}

    for i, name in ipairs(TabNames) do
        local Tab = Instance.new("TextButton")
        Tab.Size = UDim2.new(1, -10, 0, 35)
        Tab.Position = UDim2.new(0, 5, 0, 10 + (i-1)*40)
        Tab.BackgroundColor3 = theme.accentGreen
        Tab.BackgroundTransparency = 1
        Tab.Text = "  "..TabIcons[i].."  "..name
        Tab.TextColor3 = theme.textMuted
        Tab.Font = Enum.Font.GothamMedium
        Tab.TextSize = 12
        Tab.TextXAlignment = Enum.TextXAlignment.Left
        Tab.AutoButtonColor = false
        Tab.Parent = Sidebar
        Instance.new("UICorner", Tab).CornerRadius = UDim.new(0, 6)
        
        ApplyHoverEffect(Tab)

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, -130, 1, -38)
        Page.Position = UDim2.new(0, 120, 0, 38)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = theme.textMuted
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.Visible = (i == 1)
        Page.Parent = MainFrame

        local PageList = Instance.new("UIListLayout", Page)
        PageList.Padding = UDim.new(0, 10)
        PageList.SortOrder = Enum.SortOrder.LayoutOrder

        local PagePad = Instance.new("UIPadding", Page)
        PagePad.PaddingLeft = UDim.new(0, 15)
        PagePad.PaddingRight = UDim.new(0, 15)
        PagePad.PaddingTop = UDim.new(0, 10)

        Pages[i] = {Tab = Tab, Page = Page}
    end

    local function SwitchTab(idx)
        for i, data in ipairs(Pages) do
            local isSelected = (i == idx)
            data.Page.Visible = isSelected
            data.Tab:SetAttribute("Selected", isSelected)
            
            if isSelected then
                TweenService:Create(data.Tab, tweenInfo, {BackgroundTransparency = 0.6}):Play()
                data.Tab.TextColor3 = theme.textMain
                if not data.Tab:FindFirstChild("Grad") then
                    local g = CreateGradient()
                    g.Name = "Grad"
                    g.Parent = data.Tab
                end
            else
                TweenService:Create(data.Tab, tweenInfo, {BackgroundTransparency = 1}):Play()
                data.Tab.TextColor3 = theme.textMuted
                local g = data.Tab:FindFirstChild("Grad")
                if g then g:Destroy() end
            end
        end
    end

    for i, data in ipairs(Pages) do
        data.Tab.MouseButton1Click:Connect(function() SwitchTab(i) end)
    end
    SwitchTab(1)

    -- Helper to create cards
    local function CreateCard(parent, title, order)
        local Card = Instance.new("Frame")
        Card.Size = UDim2.new(1, 0, 0, 80)
        Card.BackgroundColor3 = theme.card
        Card.BorderSizePixel = 0
        Card.LayoutOrder = order
        Card.AutomaticSize = Enum.AutomaticSize.Y
        Card.Parent = parent

        Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)
        local CardStroke = Instance.new("UIStroke", Card)
        CardStroke.Color = theme.stroke
        CardStroke.Transparency = 0.88
        CardStroke.Thickness = 1

        local Header = Instance.new("TextLabel")
        Header.Size = UDim2.new(1, -20, 0, 25)
        Header.Position = UDim2.new(0, 10, 0, 8)
        Header.BackgroundTransparency = 1
        Header.RichText = true
        Header.Text = '<font color="#00ff88">'..string.sub(title, 1, 1)..'</font><font color="#00bbff">'..string.sub(title, 2)..' </font>'
        Header.TextColor3 = theme.textMain
        Header.Font = Enum.Font.GothamBold
        Header.TextSize = 13
        Header.TextXAlignment = Enum.TextXAlignment.Left
        Header.Parent = Card

        local Content = Instance.new("Frame")
        Content.Size = UDim2.new(1, -20, 0, 30)
        Content.Position = UDim2.new(0, 10, 0, 35)
        Content.BackgroundTransparency = 1
        Content.Parent = Card
        
        local ContentPad = Instance.new("UIPadding", Content)
        ContentPad.PaddingBottom = UDim.new(0, 10)

        return Card, Content
    end

    local function CreateToggle(parent)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(0, 100, 0, 28)
        Btn.Position = UDim2.new(1, -100, 0, 0)
        Btn.BackgroundColor3 = theme.bg
        Btn.BorderSizePixel = 0
        Btn.Text = "OFF"
        Btn.TextColor3 = theme.textMuted
        Btn.Font = Enum.Font.GothamBold
        Btn.TextSize = 12
        Btn.AutoButtonColor = false
        Btn.Parent = parent
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
        
        local BtnStroke = Instance.new("UIStroke", Btn)
        BtnStroke.Color = theme.stroke
        BtnStroke.Transparency = 0.8

        Btn.MouseEnter:Connect(function()
            TweenService:Create(BtnStroke, tweenInfo, {Transparency = 0.5}):Play()
        end)
        Btn.MouseLeave:Connect(function()
            if not Btn:GetAttribute("On") then
                TweenService:Create(BtnStroke, tweenInfo, {Transparency = 0.8}):Play()
            end
        end)

        return Btn
    end

    -- === BUILD PAGES ===
    
    -- HOME (Page 1)
    local c1, cont1 = CreateCard(Pages[1].Page, "Welcome", 1)
    cont1.Size = UDim2.new(1, 0, 0, 40)
    local WelText = Instance.new("TextLabel")
    WelText.Size = UDim2.new(1, 0, 1, 0)
    WelText.BackgroundTransparency = 1
    WelText.Text = "Premium script hub made by Sardo."
    WelText.TextColor3 = theme.textMuted
    WelText.Font = Enum.Font.Gotham
    WelText.TextSize = 11
    WelText.TextXAlignment = Enum.TextXAlignment.Left
    WelText.Parent = cont1

    local c2, cont2 = CreateCard(Pages[1].Page, "Keybinds", 2)
    cont2.Size = UDim2.new(1, 0, 0, 60)
    local KbText = Instance.new("TextLabel")
    KbText.Size = UDim2.new(1, 0, 1, 0)
    KbText.BackgroundTransparency = 1
    KbText.Text = "[U] Fast Attack\n[G] Fly + Noclip\n[K] Toggle Hub"
    KbText.TextColor3 = theme.textMuted
    KbText.Font = Enum.Font.Gotham
    KbText.TextSize = 11
    KbText.TextXAlignment = Enum.TextXAlignment.Left
    KbText.Parent = cont2

    -- COMBAT (Page 2)
    local c3, cont3 = CreateCard(Pages[2].Page, "Fast Attack", 1)
    local FastAttackBtn = CreateToggle(cont3)
    
    -- MOVEMENT (Page 3)
    local c4, cont4 = CreateCard(Pages[3].Page, "Fly + Noclip", 1)
    local FlyBtn = CreateToggle(cont4)

    local c5, cont5 = CreateCard(Pages[3].Page, "Loop Teleport", 2)
    cont5.Size = UDim2.new(1, 0, 0, 160)
    
    local PlayerScrollFrame = Instance.new("ScrollingFrame")
    PlayerScrollFrame.Size = UDim2.new(1, 0, 0, 90)
    PlayerScrollFrame.Position = UDim2.new(0, 0, 0, 30)
    PlayerScrollFrame.BackgroundTransparency = 1
    PlayerScrollFrame.BorderSizePixel = 0
    PlayerScrollFrame.ScrollBarThickness = 2
    PlayerScrollFrame.ScrollBarImageColor3 = theme.textMuted
    PlayerScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    PlayerScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    PlayerScrollFrame.Parent = cont5

    local ListLayout = Instance.new("UIListLayout", PlayerScrollFrame)
    ListLayout.Padding = UDim.new(0, 2)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local TPToggleBtn = CreateToggle(cont5)
    TPToggleBtn.Position = UDim2.new(1, -100, 1, -30)
    TPToggleBtn.Text = "START"
    TPToggleBtn.Size = UDim2.new(0, 100, 0, 24)

    local TPStatus = Instance.new("TextLabel")
    TPStatus.Size = UDim2.new(1, -110, 0, 15)
    TPStatus.Position = UDim2.new(0, 0, 1, -30)
    TPStatus.BackgroundTransparency = 1
    TPStatus.Text = "Status: Idle"
    TPStatus.TextColor3 = theme.textMuted
    TPStatus.Font = Enum.Font.Gotham
    TPStatus.TextSize = 10
    TPStatus.TextXAlignment = Enum.TextXAlignment.Left
    TPStatus.Parent = cont5

    -- VISUALS (Page 4)
    local c6, cont6 = CreateCard(Pages[4].Page, "ESP", 1)
    local ESPBtn = CreateToggle(cont6)

    -- Dragging Logic
    local dragging, dragInput, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    return FastAttackBtn, FlyBtn, TPToggleBtn, TPStatus, PlayerScrollFrame, ESPBtn
end

local FastAttackBtn, FlyBtn, TPToggleBtn, TPStatus, PlayerScrollFrame, ESPBtn = CreateGUI()
local playerButtons = {}

-- Loop TP Player List
local function createPlayerButton(player, index)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 22)
    btn.BackgroundColor3 = theme.bg
    btn.TextColor3 = theme.textMuted
    btn.Text = "  "..player.DisplayName
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 0
    btn.LayoutOrder = index
    btn.AutoButtonColor = false
    btn.Parent = PlayerScrollFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    btn.MouseEnter:Connect(function() if targetPlayer ~= player then btn.BackgroundColor3 = theme.card end end)
    btn.MouseLeave:Connect(function() if targetPlayer ~= player then btn.BackgroundColor3 = theme.bg end end)

    btn.MouseButton1Click:Connect(function()
        for p, b in pairs(playerButtons) do
            b.BackgroundColor3 = theme.bg
            b.TextColor3 = theme.textMuted
        end
        targetPlayer = player
        btn.BackgroundColor3 = theme.card
        btn.TextColor3 = theme.accentGreen
        if teleporting then TPStatus.Text = "Target: "..player.DisplayName end
    end)
    playerButtons[player] = btn
end

local function refreshPlayerList()
    for _, child in pairs(PlayerScrollFrame:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
    playerButtons = {}
    local sorted = {}
    for _, p in pairs(Players:GetPlayers()) do if p ~= Players.LocalPlayer then table.insert(sorted, p) end end
    table.sort(sorted, function(a, b) return a.DisplayName:lower() < b.DisplayName:lower() end)
    for i, player in pairs(sorted) do createPlayerButton(player, i) end
    if targetPlayer and playerButtons[targetPlayer] then
        playerButtons[targetPlayer].BackgroundColor3 = theme.card
        playerButtons[targetPlayer].TextColor3 = theme.accentGreen
    end
end

Players.PlayerAdded:Connect(function(p) refreshPlayerList() end)
Players.PlayerRemoving:Connect(function(player)
    if player == targetPlayer then
        teleporting = false; targetPlayer = nil
        TPToggleBtn.Text = "START"; TPToggleBtn:SetAttribute("On", false)
        TweenService:Create(TPToggleBtn, tweenInfo, {BackgroundColor3 = theme.bg, TextColor3 = theme.textMuted}):Play()
        TPToggleBtn.UIStroke.Transparency = 0.8
        TPStatus.Text = "Status: Player left"
    end
    if ESPObjects[player] then if ESPObjects[player].Parent then ESPObjects[player].Parent:Destroy() end ESPObjects[player] = nil end
    refreshPlayerList()
end)
refreshPlayerList()

-- Toggle UI Style Helper
local function ToggleButtonStyle(Btn, state)
    Btn:SetAttribute("On", state)
    if state then
        Btn.Text = "ON"
        TweenService:Create(Btn, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        Btn.UIStroke.Transparency = 0.4
        if not Btn:FindFirstChild("Grad") then CreateGradient().Parent = Btn end
    else
        Btn.Text = "OFF"
        TweenService:Create(Btn, tweenInfo, {TextColor3 = theme.textMuted}):Play()
        Btn.UIStroke.Transparency = 0.8
        local g = Btn:FindFirstChild("Grad") if g then g:Destroy() end
    end
end

-- === STANDALONE LOGIC FUNCTIONS ===

-- Fast Attack Logic
local function AttackMultipleTargets(targets)
    pcall(function()
        if not targets or #targets == 0 then return end
        local allTargets = {}
        for _, t in pairs(targets) do local h = t:FindFirstChild("Head") if h then table.insert(allTargets, {t, h}) end end
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
            local myChar = Players.LocalPlayer.Character; local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myHRP then continue end
            local t = {}
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= Players.LocalPlayer and p.Character then
                    local h, hr = p.Character:FindFirstChild("Humanoid"), p.Character:FindFirstChild("HumanoidRootPart")
                    if h and hr and h.Health > 0 and (hr.Position - myHRP.Position).Magnitude <= FastAttackRange then table.insert(t, p.Character) end
                end
            end
            local e = workspace:FindFirstChild("Enemies")
            if e then for _, n in pairs(e:GetChildren()) do
                local h, hr = n:FindFirstChild("Humanoid"), n:FindFirstChild("HumanoidRootPart")
                if h and hr and h.Health > 0 and (hr.Position - myHRP.Position).Magnitude <= FastAttackRange then table.insert(t, n) end
            end end
            if #t > 0 then AttackMultipleTargets(t) end
        end
    end)
end

local function StopFastAttack() 
    if FastAttackConnection then task.cancel(FastAttackConnection) FastAttackConnection = nil end 
end

-- Fly Logic
local function EnableNoclip(c) originalCanCollide = {} for _, p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then originalCanCollide[p] = p.CanCollide p.CanCollide = false end end end
local function DisableNoclip(c) for p, v in pairs(originalCanCollide) do if p and p.Parent then p.CanCollide = v end end originalCanCollide = {} end
local function MaintainNoclip(c) for _, p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end

local function StartFly()
    local c = Players.LocalPlayer.Character; local h = c and c:FindFirstChildOfClass("Humanoid"); local r = c and c:FindFirstChild("HumanoidRootPart")
    if not h or not r then return end
    h.PlatformStand = true; EnableNoclip(c)
    FlyConnection = RunService.Heartbeat:Connect(function()
        if not FlyEnabled or not c or not c.Parent then StopFly() return end
        MaintainNoclip(c)
        local cam = workspace.CurrentCamera; local d = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then d = d + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then d = d - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then d = d - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then d = d + cam.CFrame.RightVector end
        if d.Magnitude > 0 then d = d.Unit end
        r.AssemblyLinearVelocity = d * FlySpeed
    end)
end

local function StopFly()
    if FlyConnection then FlyConnection:Disconnect() FlyConnection = nil end
    local c = Players.LocalPlayer.Character; local h = c and c:FindFirstChildOfClass("Humanoid"); local r = c and c:FindFirstChild("HumanoidRootPart")
    if h then h.PlatformStand = false end if r then r.AssemblyLinearVelocity = Vector3.zero end if c then DisableNoclip(c) end
end

-- ESP Logic
local function ClearESP() for _, o in pairs(ESPObjects) do if o and o.Parent then o.Parent:Destroy() end end ESPObjects = {} end

local function UpdateESP()
    local mc = Players.LocalPlayer.Character; local mhr = mc and mc:FindFirstChild("HumanoidRootPart")
    if not mhr then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Players.LocalPlayer then
            local c = p.Character; local h = c and c:FindFirstChild("Head"); local hm = c and c:FindFirstChild("Humanoid"); local hr = c and c:FindFirstChild("HumanoidRootPart")
            if h and hm and hr and hm.Health > 0 then
                local dist, hp = math.floor((hr.Position - mhr.Position).Magnitude), math.floor(hm.Health)
                if not ESPObjects[p] then
                    local bb = Instance.new("BillboardGui"); bb.Adornee = h; bb.Size = UDim2.new(0, 120, 0, 40); bb.StudsOffset = Vector3.new(0, 3, 0); bb.AlwaysOnTop = true; bb.Parent = h
                    local l = Instance.new("TextLabel"); l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1; l.TextColor3 = theme.textMain; l.TextStrokeTransparency = 0.5; l.TextStrokeColor3 = Color3.new(0,0,0); l.Font = Enum.Font.GothamBold; l.TextSize = 11; l.TextScaled = true
                    l.RichText = true
                    l.Text = '<font color="#00ff88">'..p.DisplayName..'</font>\n<font color="#00bbff">HP: '..hp..' | '..dist..'m</font>'
                    l.Parent = bb
                    ESPObjects[p] = l
                else
                    ESPObjects[p].Text = '<font color="#00ff88">'..p.DisplayName..'</font>\n<font color="#00bbff">HP: '..hp..' | '..dist..'m</font>'
                    ESPObjects[p].Parent.Adornee = h
                end
            else
                if ESPObjects[p] then if ESPObjects[p].Parent then ESPObjects[p].Parent:Destroy() end ESPObjects[p] = nil end
            end
        end
    end
end

-- === EXPLICIT TOGGLE FUNCTIONS (Buttons & Hotkeys call these) ===

local function ToggleFastAttack()
    FastAttackEnabled = not FastAttackEnabled
    ToggleButtonStyle(FastAttackBtn, FastAttackEnabled)
    if FastAttackEnabled then StartFastAttack() else StopFastAttack() end
end

local function ToggleFly()
    FlyEnabled = not FlyEnabled
    ToggleButtonStyle(FlyBtn, FlyEnabled)
    if FlyEnabled then StartFly() else StopFly() end
end

local function ToggleTP()
    if not targetPlayer then TPStatus.Text = "Status: Select a player"; return end
    teleporting = not teleporting
    if teleporting then
        TPToggleBtn.Text = "STOP"
        ToggleButtonStyle(TPToggleBtn, true)
        TPStatus.Text = "Target: "..targetPlayer.DisplayName
    else
        TPToggleBtn.Text = "START"
        ToggleButtonStyle(TPToggleBtn, false)
        TPStatus.Text = "Status: Idle"
    end
end

local function ToggleESP()
    ESPEnabled = not ESPEnabled
    ToggleButtonStyle(ESPBtn, ESPEnabled)
    if ESPEnabled then
        if ESPConnection then ESPConnection:Disconnect() end
        ESPConnection = RunService.RenderStepped:Connect(UpdateESP)
    else
        if ESPConnection then ESPConnection:Disconnect() ESPConnection = nil end
        ClearESP()
    end
end

-- Connect UI Buttons to the explicit functions
FastAttackBtn.MouseButton1Click:Connect(ToggleFastAttack)
FlyBtn.MouseButton1Click:Connect(ToggleFly)
TPToggleBtn.MouseButton1Click:Connect(ToggleTP)
ESPBtn.MouseButton1Click:Connect(ToggleESP)

-- Loop TP Heartbeat
local lastTP = 0
RunService.Heartbeat:Connect(function()
    if teleporting and targetPlayer then
        local n = tick()
        if n - lastTP >= teleportCooldown then
            local c, t = Players.LocalPlayer.Character, targetPlayer.Character
            if c and t then
                local h1, h2 = c:FindFirstChild("HumanoidRootPart"), t:FindFirstChild("HumanoidRootPart")
                if h1 and h2 then h1.CFrame = h2.CFrame * CFrame.new(0, 0, 3) lastTP = n end
            end
        end
    end
end)

-- === KEYBINDS ===
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == TOGGLE_KEY then
        ToggleFastAttack()
    elseif input.KeyCode == FLY_KEY then
        ToggleFly()
    elseif input.KeyCode == Enum.KeyCode.K then
        local gui = Players.LocalPlayer.PlayerGui:FindFirstChild("NoobezHub")
        if gui then gui.Enabled = not gui.Enabled end
    end
end)

print("=================================")
print("noobez Hub v1.0 Loaded!")
print("Made by Sardo")
print("=================================")
