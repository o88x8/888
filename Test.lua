local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

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

-- Anti-Knockback
local AntiKBEnabled = false
local AntiKBConnection = nil

-- Infinite Jump
local InfiniteJumpEnabled = false
local InfiniteJumpConnection = nil

-- Noclip
local NoclipEnabled = false
local NoclipConnection = nil

-- Spider Climb
local SpiderClimbEnabled = false
local SpiderClimbConnection = nil

-- Box ESP
local BoxESPEnabled = false
local BoxESPConnection = nil
local BoxESPObjects = {}

-- Tracer ESP
local TracerEnabled = false
local TracerConnection = nil
local TracerFrame = nil

-- Fullbright
local FullbrightEnabled = false
local OriginalLighting = {}

-- FOV Changer
local FOVValue = 70
local DefaultFOV = 70

-- Anti AFK
local AntiAFKEnabled = false
local AntiAFKConnection = nil

-- Animation Variables
local isAnimating = false
local HubGui = nil
local MainFrameRef = nil

-- UI Theme Colors
local theme = {
    bg = Color3.fromRGB(25, 28, 30),
    card = Color3.fromRGB(32, 35, 38),
    sidebar = Color3.fromRGB(20, 23, 25),
    accentGreen = Color3.fromRGB(0, 255, 136),
    accentBlue = Color3.fromRGB(0, 187, 255),
    accentRed = Color3.fromRGB(255, 85, 85),
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
    MainFrame.Size = UDim2.new(0, 550, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -225)
    MainFrame.BackgroundColor3 = theme.bg
    MainFrame.BackgroundTransparency = 0.05
    MainFrame.Parent = ScreenGui

    MainFrameRef = MainFrame
    HubGui = ScreenGui

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
    Version.Text = "v2.0"
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
    local TabNames = {"Home", "Combat", "Move", "Visuals", "Utility"}
    local TabIcons = {"◎", "⚔", "✈", "◎", "⚙"}

    for i, name in ipairs(TabNames) do
        local Tab = Instance.new("TextButton")
        Tab.Size = UDim2.new(1, -10, 0, 35)
        Tab.Position = UDim2.new(0, 5, 0, 10 + (i-1)*38)
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
        Content.Size = UDim2.new(1, -20, 0, 0)
        Content.AutomaticSize = Enum.AutomaticSize.Y
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
        Btn.BackgroundTransparency = 0
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

    local function CreateSmallButton(parent, text, posX, posY, width, height)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(0, width or 60, 0, height or 24)
        Btn.Position = UDim2.new(1, -(posX or 60), 0, posY or 32)
        Btn.BackgroundColor3 = theme.bg
        Btn.BorderSizePixel = 0
        Btn.Text = text
        Btn.TextColor3 = theme.textMuted
        Btn.Font = Enum.Font.GothamMedium
        Btn.TextSize = 10
        Btn.AutoButtonColor = false
        Btn.Parent = parent
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)
        
        local BtnStroke = Instance.new("UIStroke", Btn)
        BtnStroke.Color = theme.stroke
        BtnStroke.Transparency = 0.8

        Btn.MouseEnter:Connect(function()
            TweenService:Create(Btn, tweenInfo, {TextColor3 = theme.accentRed}):Play()
            TweenService:Create(BtnStroke, tweenInfo, {Transparency = 0.5}):Play()
        end)
        Btn.MouseLeave:Connect(function()
            TweenService:Create(Btn, tweenInfo, {TextColor3 = theme.textMuted}):Play()
            TweenService:Create(BtnStroke, tweenInfo, {Transparency = 0.8}):Play()
        end)

        return Btn
    end

    local function CreateSlider(parent, title, min, max, default, callback)
        local Container = Instance.new("Frame")
        Container.Size = UDim2.new(1, 0, 0, 50)
        Container.BackgroundTransparency = 1
        Container.Parent = parent
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -110, 0, 20)
        Label.Position = UDim2.new(0, 0, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = title .. ": " .. default
        Label.TextColor3 = theme.textMuted
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 11
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Container
        
        local SliderBg = Instance.new("Frame")
        SliderBg.Size = UDim2.new(1, -110, 0, 6)
        SliderBg.Position = UDim2.new(0, 0, 0, 28)
        SliderBg.BackgroundColor3 = theme.bg
        SliderBg.BorderSizePixel = 0
        SliderBg.Parent = Container
        Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(0, 3)
        
        local SliderFill = Instance.new("Frame")
        SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        SliderFill.BackgroundColor3 = theme.accentGreen
        SliderFill.BorderSizePixel = 0
        SliderFill.Parent = SliderBg
        Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(0, 3)
        CreateGradient().Parent = SliderFill
        
        local SliderBtn = Instance.new("TextButton")
        SliderBtn.Size = UDim2.new(1, -110, 0, 20)
        SliderBtn.Position = UDim2.new(0, 0, 0, 20)
        SliderBtn.BackgroundTransparency = 1
        SliderBtn.Text = ""
        SliderBtn.Parent = Container
        
        local dragging = false
        
        SliderBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local relX = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
                local currentValue = math.floor(min + (max - min) * relX)
                SliderFill.Size = UDim2.new(relX, 0, 1, 0)
                Label.Text = title .. ": " .. currentValue
                callback(currentValue)
            end
        end)
        
        return Container, Label
    end

    -- === BUILD PAGES ===
    
    -- HOME (Page 1)
    local c1, cont1 = CreateCard(Pages[1].Page, "Welcome", 1)
    local WelText = Instance.new("TextLabel")
    WelText.Size = UDim2.new(1, 0, 0, 40)
    WelText.BackgroundTransparency = 1
    WelText.Text = "Made by Sardo.\nKrezzy Top Global!"
    WelText.TextColor3 = theme.textMuted
    WelText.Font = Enum.Font.Gotham
    WelText.TextSize = 11
    WelText.TextXAlignment = Enum.TextXAlignment.Left
    WelText.Parent = cont1

    local c2, cont2 = CreateCard(Pages[1].Page, "Keybinds", 2)
    local KbText = Instance.new("TextLabel")
    KbText.Size = UDim2.new(1, 0, 0, 50)
    KbText.BackgroundTransparency = 1
    KbText.Text = "[U] Fast Attack\n[G] Fly\n[K] Toggle Hub"
    KbText.TextColor3 = theme.textMuted
    KbText.Font = Enum.Font.Gotham
    KbText.TextSize = 11
    KbText.TextXAlignment = Enum.TextXAlignment.Left
    KbText.Parent = cont2

    -- COMBAT (Page 2)
    local c3, cont3 = CreateCard(Pages[2].Page, "Fast Attack", 1)
    local FastAttackBtn = CreateToggle(cont3)

    local c3c, cont3c = CreateCard(Pages[2].Page, "Anti-Knockback", 2)
    local AntiKBBtn = CreateToggle(cont3c)

    -- MOVEMENT (Page 3)
    local c4, cont4 = CreateCard(Pages[3].Page, "Fly", 1)
    local FlyBtn = CreateToggle(cont4)

    local c5, cont5 = CreateCard(Pages[3].Page, "Loop Teleport", 2)
    
    local PlayerScrollFrame = Instance.new("ScrollingFrame")
    PlayerScrollFrame.Size = UDim2.new(1, 0, 0, 80)
    PlayerScrollFrame.Position = UDim2.new(0, 0, 0, 0) 
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
    TPToggleBtn.Position = UDim2.new(1, -100, 0, 90)
    TPToggleBtn.Size = UDim2.new(0, 100, 0, 24)

    local TPStatus = Instance.new("TextLabel")
    TPStatus.Size = UDim2.new(1, -110, 0, 15)
    TPStatus.Position = UDim2.new(0, 0, 0, 94)
    TPStatus.BackgroundTransparency = 1
    TPStatus.Text = "Status: Idle"
    TPStatus.TextColor3 = theme.textMuted
    TPStatus.Font = Enum.Font.Gotham
    TPStatus.TextSize = 10
    TPStatus.TextXAlignment = Enum.TextXAlignment.Left
    TPStatus.Parent = cont5

    local c6, cont6 = CreateCard(Pages[3].Page, "Infinite Jump", 3)
    local InfiniteJumpBtn = CreateToggle(cont6)

    local c8, cont8 = CreateCard(Pages[3].Page, "Noclip", 4)
    local NoclipBtn = CreateToggle(cont8)

    local c9, cont9 = CreateCard(Pages[3].Page, "Spider Climb", 5)
    local SpiderClimbBtn = CreateToggle(cont9)

    -- VISUALS (Page 4)
    local c10, cont10 = CreateCard(Pages[4].Page, "ESP", 1)
    local ESPBtn = CreateToggle(cont10)

    local c11, cont11 = CreateCard(Pages[4].Page, "Box ESP", 2)
    local BoxESPBtn = CreateToggle(cont11)

    local c12, cont12 = CreateCard(Pages[4].Page, "Tracer ESP", 3)
    local TracerBtn = CreateToggle(cont12)

    local c13, cont13 = CreateCard(Pages[4].Page, "Fullbright", 4)
    local FullbrightBtn = CreateToggle(cont13)

    local c14, cont14 = CreateCard(Pages[4].Page, "FOV Changer", 5)
    local FOVSlider, FOVLabel = CreateSlider(cont14, "FOV", 30, 120, 70, function(val) FOVValue = val local cam = workspace.CurrentCamera if cam then cam.FieldOfView = val end end)
    FOVSlider.Position = UDim2.new(0, 0, 0, 0)
    local ResetFOVBtn = CreateSmallButton(cont14, "RESET", 60, 0, 50, 24)

    -- UTILITY (Page 5)
    local c15, cont15 = CreateCard(Pages[5].Page, "Anti AFK", 1)
    local AntiAFKBtn = CreateToggle(cont15)

    local c16, cont16 = CreateCard(Pages[5].Page, "FPS Booster", 2)
    local FPSBoostBtn = CreateSmallButton(cont16, "BOOST", 100, 0, 80, 28)
    FPSBoostBtn.Position = UDim2.new(1, -80, 0, 0)
    local FPSText = Instance.new("TextLabel")
    FPSText.Size = UDim2.new(1, -90, 0, 28)
    FPSText.Position = UDim2.new(0, 0, 0, 0)
    FPSText.BackgroundTransparency = 1
    FPSText.Text = "Reduces graphics for better performance"
    FPSText.TextColor3 = theme.textMuted
    FPSText.Font = Enum.Font.Gotham
    FPSText.TextSize = 10
    FPSText.TextXAlignment = Enum.TextXAlignment.Left
    FPSText.Parent = cont16

    local c17, cont17 = CreateCard(Pages[5].Page, "Server Actions", 3)
    local RejoinBtn = CreateSmallButton(cont17, "REJOIN", 170, 0, 80, 28)
    RejoinBtn.Position = UDim2.new(1, -170, 0, 0)
    local ServerHopBtn = CreateSmallButton(cont17, "SERVER HOP", 80, 0, 80, 28)
    ServerHopBtn.Position = UDim2.new(1, -80, 0, 0)

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
    
    return {
        FastAttackBtn = FastAttackBtn,
        FlyBtn = FlyBtn,
        TPToggleBtn = TPToggleBtn,
        TPStatus = TPStatus,
        PlayerScrollFrame = PlayerScrollFrame,
        ESPBtn = ESPBtn,
        AntiKBBtn = AntiKBBtn,
        InfiniteJumpBtn = InfiniteJumpBtn,
        NoclipBtn = NoclipBtn,
        SpiderClimbBtn = SpiderClimbBtn,
        BoxESPBtn = BoxESPBtn,
        TracerBtn = TracerBtn,
        FullbrightBtn = FullbrightBtn,
        FOVLabel = FOVLabel,
        ResetFOVBtn = ResetFOVBtn,
        AntiAFKBtn = AntiAFKBtn,
        FPSBoostBtn = FPSBoostBtn,
        RejoinBtn = RejoinBtn,
        ServerHopBtn = ServerHopBtn
    }
end

local UI = CreateGUI()
local FastAttackBtn = UI.FastAttackBtn
local FlyBtn = UI.FlyBtn
local TPToggleBtn = UI.TPToggleBtn
local TPStatus = UI.TPStatus
local PlayerScrollFrame = UI.PlayerScrollFrame
local ESPBtn = UI.ESPBtn
local AntiKBBtn = UI.AntiKBBtn
local InfiniteJumpBtn = UI.InfiniteJumpBtn
local NoclipBtn = UI.NoclipBtn
local SpiderClimbBtn = UI.SpiderClimbBtn
local BoxESPBtn = UI.BoxESPBtn
local TracerBtn = UI.TracerBtn
local FullbrightBtn = UI.FullbrightBtn
local FOVLabel = UI.FOVLabel
local ResetFOVBtn = UI.ResetFOVBtn
local AntiAFKBtn = UI.AntiAFKBtn
local FPSBoostBtn = UI.FPSBoostBtn
local RejoinBtn = UI.RejoinBtn
local ServerHopBtn = UI.ServerHopBtn

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
        ToggleButtonStyle(TPToggleBtn, false)
        TPStatus.Text = "Status: Player left"
    end
    if ESPObjects[player] then if ESPObjects[player].Parent then ESPObjects[player].Parent:Destroy() end ESPObjects[player] = nil end
    if BoxESPObjects[player] then if BoxESPObjects[player].Parent then BoxESPObjects[player].Parent:Destroy() end BoxESPObjects[player] = nil end
    refreshPlayerList()
end)
refreshPlayerList()

-- Toggle UI Style Helper
local function ToggleButtonStyle(Btn, state)
    Btn:SetAttribute("On", state)
    if state then
        Btn.Text = "ON"
        Btn.BackgroundColor3 = theme.bg -- Ensure base color is set under gradient
        if not Btn:FindFirstChild("Grad") then CreateGradient().Parent = Btn end
        TweenService:Create(Btn, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        Btn.UIStroke.Transparency = 0.4
    else
        Btn.Text = "OFF"
        -- Destroy gradient FIRST to prevent color snapping glitches
        local g = Btn:FindFirstChild("Grad") 
        if g then g:Destroy() end
        -- Set normal background color explicitly
        Btn.BackgroundColor3 = theme.bg
        -- Tween text back to normal
        TweenService:Create(Btn, tweenInfo, {TextColor3 = theme.textMuted}):Play()
        Btn.UIStroke.Transparency = 0.8
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

-- Anti-Knockback Logic
local function StartAntiKB()
    if AntiKBConnection then AntiKBConnection:Disconnect() end
    AntiKBConnection = RunService.Heartbeat:Connect(function()
        if not AntiKBEnabled then return end
        local char = Players.LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and hrp.Parent then
            hrp.AssemblyLinearVelocity = Vector3.new(
                hrp.AssemblyLinearVelocity.X * 0.05,
                hrp.AssemblyLinearVelocity.Y > 5 and hrp.AssemblyLinearVelocity.Y * 0.5 or hrp.AssemblyLinearVelocity.Y,
                hrp.AssemblyLinearVelocity.Z * 0.05
            )
        end
    end)
end

local function StopAntiKB()
    if AntiKBConnection then AntiKBConnection:Disconnect() AntiKBConnection = nil end
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

-- Infinite Jump Logic
local function StartInfiniteJump()
    if InfiniteJumpConnection then InfiniteJumpConnection:Disconnect() end
    InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
        local char = Players.LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

local function StopInfiniteJump()
    if InfiniteJumpConnection then InfiniteJumpConnection:Disconnect() InfiniteJumpConnection = nil end
end

-- Noclip Logic
local function StartNoclip()
    if NoclipConnection then NoclipConnection:Disconnect() end
    NoclipConnection = RunService.Stepped:Connect(function()
        if not NoclipEnabled then return end
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
    if NoclipConnection then NoclipConnection:Disconnect() NoclipConnection = nil end
    local char = Players.LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Spider Climb Logic
local function StartSpiderClimb()
    if SpiderClimbConnection then SpiderClimbConnection:Disconnect() end
    SpiderClimbConnection = RunService.Stepped:Connect(function()
        if not SpiderClimbEnabled then return end
        local char = Players.LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local rootPart = char and char:FindFirstChild("HumanoidRootPart")
        if not humanoid or not rootPart then return end
        
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {char}
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        
        local directions = {
            rootPart.CFrame.LookVector,
            -rootPart.CFrame.LookVector,
            rootPart.CFrame.RightVector,
            -rootPart.CFrame.RightVector
        }
        
        for _, dir in pairs(directions) do
            local result = workspace:Raycast(rootPart.Position, dir * 3, rayParams)
            if result then
                humanoid:ChangeState(Enum.HumanoidStateType.Climbing)
                rootPart.AssemblyLinearVelocity = rootPart.CFrame.UpVector * 20
                break
            end
        end
    end)
end

local function StopSpiderClimb()
    if SpiderClimbConnection then SpiderClimbConnection:Disconnect() SpiderClimbConnection = nil end
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

-- Box ESP Logic
local function ClearBoxESP()
    for _, obj in pairs(BoxESPObjects) do
        if obj and obj.Parent then obj.Parent:Destroy() end
    end
    BoxESPObjects = {}
end

local function CreateBoxForPlayer(player)
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if BoxESPObjects[player] then
        BoxESPObjects[player].Parent.Adornee = hrp
        return
    end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "BoxESP_" .. player.Name
    billboard.Adornee = hrp
    billboard.Size = UDim2.new(4, 0, 5, 0)
    billboard.StudsOffset = Vector3.new(0, 0.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = char
    
    local boxColor = theme.accentGreen
    
    local top = Instance.new("Frame")
    top.Name = "Top"
    top.Size = UDim2.new(1, 0, 0, 2)
    top.Position = UDim2.new(0, 0, 0, 0)
    top.BackgroundColor3 = boxColor
    top.BackgroundTransparency = 0.2
    top.BorderSizePixel = 0
    top.Parent = billboard
    
    local bottom = Instance.new("Frame")
    bottom.Name = "Bottom"
    bottom.Size = UDim2.new(1, 0, 0, 2)
    bottom.Position = UDim2.new(0, 0, 1, -2)
    bottom.BackgroundColor3 = boxColor
    bottom.BackgroundTransparency = 0.2
    bottom.BorderSizePixel = 0
    bottom.Parent = billboard
    
    local left = Instance.new("Frame")
    left.Name = "Left"
    left.Size = UDim2.new(0, 2, 1, 0)
    left.Position = UDim2.new(0, 0, 0, 0)
    left.BackgroundColor3 = boxColor
    left.BackgroundTransparency = 0.2
    left.BorderSizePixel = 0
    left.Parent = billboard
    
    local right = Instance.new("Frame")
    right.Name = "Right"
    right.Size = UDim2.new(0, 2, 1, 0)
    right.Position = UDim2.new(1, -2, 0, 0)
    right.BackgroundColor3 = boxColor
    right.BackgroundTransparency = 0.2
    right.BorderSizePixel = 0
    right.Parent = billboard
    
    BoxESPObjects[player] = billboard
end

local function UpdateBoxESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            local char = player.Character
            local humanoid = char and char:FindFirstChild("Humanoid")
            if char and humanoid and humanoid.Health > 0 then
                CreateBoxForPlayer(player)
            else
                if BoxESPObjects[player] then
                    BoxESPObjects[player]:Destroy()
                    BoxESPObjects[player] = nil
                end
            end
        end
    end
end

-- Tracer ESP Logic
local function CreateTracerFrame()
    if TracerFrame then TracerFrame:Destroy() end
    TracerFrame = Instance.new("Frame")
    TracerFrame.Name = "Tracers"
    TracerFrame.Size = UDim2.new(1, 0, 1, 0)
    TracerFrame.BackgroundTransparency = 1
    TracerFrame.ZIndex = 0
    TracerFrame.Parent = HubGui
end

local function ClearTracers()
    if TracerFrame then
        TracerFrame:ClearAllChildren()
    end
end

local function UpdateTracers()
    if not TracerFrame then return end
    TracerFrame:ClearAllChildren()
    
    local camera = workspace.CurrentCamera
    local localChar = Players.LocalPlayer.Character
    local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")
    if not localHRP then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            local char = player.Character
            local head = char and char:FindFirstChild("Head")
            local humanoid = char and char:FindFirstChild("Humanoid")
            if head and humanoid and humanoid.Health > 0 then
                local screenPos, onScreen = camera:WorldToScreenPoint(head.Position)
                if onScreen then
                    local line = Instance.new("Frame")
                    line.BackgroundColor3 = theme.accentGreen
                    line.BackgroundTransparency = 0.5
                    line.BorderSizePixel = 0
                    line.AnchorPoint = Vector2.new(0.5, 1)
                    line.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y)
                    
                    local angle = math.deg(math.atan2(screenPos.X - camera.ViewportSize.X/2, camera.ViewportSize.Y - screenPos.Y))
                    line.Rotation = angle
                    
                    local length = camera.ViewportSize.Y - screenPos.Y
                    line.Size = UDim2.new(0, 1, 0, length)
                    line.ZIndex = 0
                    line.Parent = TracerFrame
                end
            end
        end
    end
end

-- Fullbright Logic
local function EnableFullbright()
    OriginalLighting = {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        FogEnd = Lighting.FogEnd,
        FogStart = Lighting.FogStart,
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        GlobalShadows = Lighting.GlobalShadows
    }
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.FogStart = 0
    Lighting.Ambient = Color3.fromRGB(178, 178, 178)
    Lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
    Lighting.GlobalShadows = false
end

local function DisableFullbright()
    for prop, value in pairs(OriginalLighting) do
        pcall(function()
            Lighting[prop] = value
        end)
    end
    OriginalLighting = {}
end

-- Anti AFK Logic
local function StartAntiAFK()
    if AntiAFKConnection then AntiAFKConnection:Disconnect() end
    AntiAFKConnection = Players.LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

local function StopAntiAFK()
    if AntiAFKConnection then AntiAFKConnection:Disconnect() AntiAFKConnection = nil end
end

-- FPS Booster Logic
local function BoostFPS()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 100000
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    
    for _, obj in pairs(Lighting:GetChildren()) do
        if obj:IsA("PostEffect") or obj:IsA("Atmosphere") then
            obj.Enabled = false
        end
    end
    
    pcall(function()
        settings().QualityLevel = Enum.QualityLevel.Level01
    end)
end

-- Rejoin Server Logic
local function RejoinServer()
    pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
    end)
end

-- Server Hop Logic
local function ServerHop()
    pcall(function()
        local servers = HttpService:JSONDecode(game:HttpGet(
            "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        ))
        
        for _, server in pairs(servers.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, Players.LocalPlayer)
                return
            end
        end
    end)
end

-- === EXPLICIT TOGGLE FUNCTIONS ===

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
    ToggleButtonStyle(TPToggleBtn, teleporting)
    if teleporting then
        TPStatus.Text = "Target: "..targetPlayer.DisplayName
    else
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

local function ToggleAntiKB()
    AntiKBEnabled = not AntiKBEnabled
    ToggleButtonStyle(AntiKBBtn, AntiKBEnabled)
    if AntiKBEnabled then StartAntiKB() else StopAntiKB() end
end

local function ToggleInfiniteJump()
    InfiniteJumpEnabled = not InfiniteJumpEnabled
    ToggleButtonStyle(InfiniteJumpBtn, InfiniteJumpEnabled)
    if InfiniteJumpEnabled then StartInfiniteJump() else StopInfiniteJump() end
end

local function ToggleNoclip()
    NoclipEnabled = not NoclipEnabled
    ToggleButtonStyle(NoclipBtn, NoclipEnabled)
    if NoclipEnabled then StartNoclip() else StopNoclip() end
end

local function ToggleSpiderClimb()
    SpiderClimbEnabled = not SpiderClimbEnabled
    ToggleButtonStyle(SpiderClimbBtn, SpiderClimbEnabled)
    if SpiderClimbEnabled then StartSpiderClimb() else StopSpiderClimb() end
end

local function ToggleBoxESP()
    BoxESPEnabled = not BoxESPEnabled
    ToggleButtonStyle(BoxESPBtn, BoxESPEnabled)
    if BoxESPEnabled then
        if BoxESPConnection then BoxESPConnection:Disconnect() end
        BoxESPConnection = RunService.RenderStepped:Connect(UpdateBoxESP)
    else
        if BoxESPConnection then BoxESPConnection:Disconnect() BoxESPConnection = nil end
        ClearBoxESP()
    end
end

local function ToggleTracer()
    TracerEnabled = not TracerEnabled
    ToggleButtonStyle(TracerBtn, TracerEnabled)
    if TracerEnabled then
        CreateTracerFrame()
        if TracerConnection then TracerConnection:Disconnect() end
        TracerConnection = RunService.RenderStepped:Connect(UpdateTracers)
    else
        if TracerConnection then TracerConnection:Disconnect() TracerConnection = nil end
        ClearTracers()
        if TracerFrame then TracerFrame:Destroy() TracerFrame = nil end
    end
end

local function ToggleFullbright()
    FullbrightEnabled = not FullbrightEnabled
    ToggleButtonStyle(FullbrightBtn, FullbrightEnabled)
    if FullbrightEnabled then EnableFullbright() else DisableFullbright() end
end

local function ResetFOV()
    FOVValue = DefaultFOV
    FOVLabel.Text = "FOV: " .. DefaultFOV
    local cam = workspace.CurrentCamera
    if cam then cam.FieldOfView = DefaultFOV end
end

local function ToggleAntiAFK()
    AntiAFKEnabled = not AntiAFKEnabled
    ToggleButtonStyle(AntiAFKBtn, AntiAFKEnabled)
    if AntiAFKEnabled then StartAntiAFK() else StopAntiAFK() end
end

-- Connect UI Buttons
FastAttackBtn.MouseButton1Click:Connect(ToggleFastAttack)
FlyBtn.MouseButton1Click:Connect(ToggleFly)
TPToggleBtn.MouseButton1Click:Connect(ToggleTP)
ESPBtn.MouseButton1Click:Connect(ToggleESP)
AntiKBBtn.MouseButton1Click:Connect(ToggleAntiKB)
InfiniteJumpBtn.MouseButton1Click:Connect(ToggleInfiniteJump)
NoclipBtn.MouseButton1Click:Connect(ToggleNoclip)
SpiderClimbBtn.MouseButton1Click:Connect(ToggleSpiderClimb)
BoxESPBtn.MouseButton1Click:Connect(ToggleBoxESP)
TracerBtn.MouseButton1Click:Connect(ToggleTracer)
FullbrightBtn.MouseButton1Click:Connect(ToggleFullbright)
ResetFOVBtn.MouseButton1Click:Connect(ResetFOV)
AntiAFKBtn.MouseButton1Click:Connect(ToggleAntiAFK)
FPSBoostBtn.MouseButton1Click:Connect(BoostFPS)
RejoinBtn.MouseButton1Click:Connect(RejoinServer)
ServerHopBtn.MouseButton1Click:Connect(ServerHop)

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

-- === OPEN / CLOSE ANIMATION ===
local function ToggleHubVisibility()
    if isAnimating or not HubGui or not MainFrameRef then return end
    isAnimating = true
    
    local targetSize = UDim2.new(0, 550, 0, 450)
    local hiddenSize = UDim2.new(0, 480, 0, 380)
    local targetTransparency = 0.05
    local hiddenTransparency = 0.8

    if HubGui.Enabled then
        local tweenOut = TweenService:Create(MainFrameRef, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = hiddenSize,
            BackgroundTransparency = hiddenTransparency
        })
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            HubGui.Enabled = false
            isAnimating = false
        end)
    else
        HubGui.Enabled = true
        MainFrameRef.Size = hiddenSize
        MainFrameRef.BackgroundTransparency = hiddenTransparency
        
        local tweenIn = TweenService:Create(MainFrameRef, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = targetSize,
            BackgroundTransparency = targetTransparency
        })
        tweenIn:Play()
        tweenIn.Completed:Connect(function()
            isAnimating = false
        end)
    end
end

-- === KEYBINDS ===
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == TOGGLE_KEY then
        ToggleFastAttack()
    elseif input.KeyCode == FLY_KEY then
        ToggleFly()
    elseif input.KeyCode == Enum.KeyCode.K then
        ToggleHubVisibility()
    end
end)

-- Store default FOV when camera loads
local camera = workspace.CurrentCamera
if camera then
    DefaultFOV = camera.FieldOfView
    FOVValue = camera.FieldOfView
    FOVLabel.Text = "FOV: " .. math.floor(FOVValue)
end

print("=================================")
print("noobez Hub v2.0 Loaded!")
print("Made by Sardo")
print("=================================")
