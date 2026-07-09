local ValidKeys = {
	["KEY123"] = true,
	["MYSECRET"] = true,
	["ABC-999"] = true,
}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local oldBlur = Lighting:FindFirstChild("KeySystemBlur")
if oldBlur then
	oldBlur:Destroy()
end

local Blur = Instance.new("BlurEffect")
Blur.Name = "KeySystemBlur"
Blur.Size = 0
Blur.Parent = Lighting

local Gui = Instance.new("ScreenGui")
Gui.Name = "KeySystemGui"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 380, 0, 230)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(120, 120, 140)
MainStroke.Transparency = 0.72
MainStroke.Thickness = 1
MainStroke.Parent = Main

local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 30)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 16))
})
MainGradient.Rotation = 90
MainGradient.Parent = Main

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 46)
TopBar.BackgroundTransparency = 1
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -24, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "noobez Hub loader"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamSemibold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 28, 0, 28)
Close.Position = UDim2.new(1, -38, 0, 9)
Close.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(240, 240, 240)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 20
Close.BorderSizePixel = 0
Close.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = Close

local CloseStroke = Instance.new("UIStroke")
CloseStroke.Color = Color3.fromRGB(255, 255, 255)
CloseStroke.Transparency = 0.9
CloseStroke.Thickness = 1
CloseStroke.Parent = Close

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -28, 0, 20)
Subtitle.Position = UDim2.new(0, 14, 0, 52)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Enter your access key below"
Subtitle.TextColor3 = Color3.fromRGB(170, 170, 180)
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 14
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Main

local Box = Instance.new("TextBox")
Box.Size = UDim2.new(1, -28, 0, 46)
Box.Position = UDim2.new(0, 14, 0, 90)
Box.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
Box.TextColor3 = Color3.fromRGB(255, 255, 255)
Box.PlaceholderText = "Type key here..."
Box.PlaceholderColor3 = Color3.fromRGB(130, 130, 140)
Box.Text = ""
Box.ClearTextOnFocus = false
Box.Font = Enum.Font.Gotham
Box.TextSize = 16
Box.BorderSizePixel = 0
Box.Parent = Main

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 12)
BoxCorner.Parent = Box

local BoxStroke = Instance.new("UIStroke")
BoxStroke.Color = Color3.fromRGB(130, 130, 150)
BoxStroke.Transparency = 0.75
BoxStroke.Thickness = 1
BoxStroke.Parent = Box

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(1, -28, 0, 46)
Button.Position = UDim2.new(0, 14, 0, 146)
Button.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
Button.Text = "Verify"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Font = Enum.Font.GothamBold
Button.TextSize = 16
Button.BorderSizePixel = 0
Button.Parent = Main

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 12)
ButtonCorner.Parent = Button

local ButtonGradient = Instance.new("UIGradient")
ButtonGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 180, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 105, 220))
})
ButtonGradient.Rotation = 0
ButtonGradient.Parent = Button

local ButtonStroke = Instance.new("UIStroke")
ButtonStroke.Color = Color3.fromRGB(255, 255, 255)
ButtonStroke.Transparency = 0.82
ButtonStroke.Thickness = 1
ButtonStroke.Parent = Button

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -28, 0, 18)
Status.Position = UDim2.new(0, 14, 0, 198)
Status.BackgroundTransparency = 1
Status.Text = ""
Status.TextColor3 = Color3.fromRGB(255, 120, 120)
Status.Font = Enum.Font.Gotham
Status.TextSize = 13
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = Main

local Credit = Instance.new("TextLabel")
Credit.Size = UDim2.new(1, -28, 0, 16)
Credit.Position = UDim2.new(0, 14, 1, -20)
Credit.BackgroundTransparency = 1
Credit.Text = "Made By Sardo"
Credit.TextColor3 = Color3.fromRGB(145, 145, 155)
Credit.Font = Enum.Font.Gotham
Credit.TextSize = 12
Credit.TextXAlignment = Enum.TextXAlignment.Right
Credit.Parent = Main

local function tween(obj, info, props)
	return TweenService:Create(obj, info, props)
end

local function setHidden()
	Main.BackgroundTransparency = 1
	MainStroke.Transparency = 1
	Title.TextTransparency = 1
	Subtitle.TextTransparency = 1
	Box.BackgroundTransparency = 1
	Box.TextTransparency = 1
	Button.BackgroundTransparency = 1
	Button.TextTransparency = 1
	Status.TextTransparency = 1
	Credit.TextTransparency = 1
	Close.BackgroundTransparency = 1
	Close.TextTransparency = 1
end

setHidden()
Main.Size = UDim2.new(0, 280, 0, 160)

tween(Blur, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 22}):Play()
tween(Main, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	Size = UDim2.new(0, 380, 0, 230),
	BackgroundTransparency = 0
}):Play()

task.wait(0.03)

for _, obj in ipairs({MainStroke, Title, Subtitle, Box, Button, Status, Credit, Close}) do
	if obj:IsA("UIStroke") then
		tween(obj, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = obj == ButtonStroke and 0.82 or 0.72}):Play()
	elseif obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
		tween(obj, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0, BackgroundTransparency = obj.BackgroundTransparency}):Play()
	end
end

local dragToggle = false
local dragStart
local startPos

TopBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragToggle = true
		dragStart = input.Position
		startPos = Main.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragToggle = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

local function showIntro()
	local Intro = Instance.new("Frame")
	Intro.Size = UDim2.new(1, 0, 1, 0)
	Intro.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Intro.BorderSizePixel = 0
	Intro.Parent = Gui

	local IntroImage = Instance.new("ImageLabel")
	IntroImage.Size = UDim2.new(0, 120, 0, 120)
	IntroImage.Position = UDim2.new(0.5, -60, 0.5, -90)
	IntroImage.BackgroundTransparency = 1
	IntroImage.Image = "rbxassetid://91418903947836"
	IntroImage.ImageTransparency = 1
	IntroImage.Parent = Intro

	local IntroTitle = Instance.new("TextLabel")
	IntroTitle.Size = UDim2.new(1, 0, 0, 44)
	IntroTitle.Position = UDim2.new(0, 0, 0.5, 20)
	IntroTitle.BackgroundTransparency = 1
	IntroTitle.Text = "noobez Hub"
	IntroTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	IntroTitle.Font = Enum.Font.GothamBold
	IntroTitle.TextSize = 28
	IntroTitle.TextTransparency = 1
	IntroTitle.Parent = Intro

	local IntroSub = Instance.new("TextLabel")
	IntroSub.Size = UDim2.new(1, 0, 0, 20)
	IntroSub.Position = UDim2.new(0, 0, 0.5, 58)
	IntroSub.BackgroundTransparency = 1
	IntroSub.Text = "Loading..."
	IntroSub.TextColor3 = Color3.fromRGB(180, 180, 190)
	IntroSub.Font = Enum.Font.Gotham
	IntroSub.TextSize = 14
	IntroSub.TextTransparency = 1
	IntroSub.Parent = Intro

	tween(IntroTitle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
	tween(IntroImage, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
	tween(IntroSub, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()

	task.wait(1.2)
	Intro:Destroy()
end

local function loadMainScript()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/o88x8/888/refs/heads/888-Hub/Test.lua"))()
end

local function closeUI()
	tween(Blur, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 0}):Play()
	task.wait(0.12)
	Gui:Destroy()
	Blur:Destroy()
end

local function verifyKey()
	local entered = string.lower((Box.Text or ""):gsub("^%s*(.-)%s*$", "%1"))
	for key, allowed in pairs(ValidKeys) do
		if allowed and entered == string.lower(key) then
			Status.TextColor3 = Color3.fromRGB(120, 255, 140)
			Status.Text = "Key accepted."
			task.wait(0.25)
			showIntro()
			closeUI()
			loadMainScript()
			return
		end
	end

	Status.TextColor3 = Color3.fromRGB(255, 120, 120)
	Status.Text = "Invalid key."
	Button.Text = "Try Again"
	task.wait(1)
	Button.Text = "Verify"
end

Button.MouseButton1Click:Connect(verifyKey)
Box.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		verifyKey()
	end
end)

Close.MouseButton1Click:Connect(closeUI)
