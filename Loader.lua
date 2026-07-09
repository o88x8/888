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

local function tween(obj, info, props)
	return TweenService:Create(obj, info, props)
end

local function make(className, props)
	local obj = Instance.new(className)
	for k, v in pairs(props) do
		obj[k] = v
	end
	return obj
end

local Dim = make("Frame", {
	Parent = Gui,
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	BackgroundTransparency = 1,
	BorderSizePixel = 0
})

local Main = make("Frame", {
	Parent = Gui,
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.new(0, 390, 0, 230),
	BackgroundColor3 = Color3.fromRGB(24, 24, 30),
	BackgroundTransparency = 0.12,
	BorderSizePixel = 0,
	ClipsDescendants = true
})

make("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 18)})
make("UIStroke", {Parent = Main, Color = Color3.fromRGB(255, 255, 255), Transparency = 0.88, Thickness = 1})
make("UIGradient", {
	Parent = Main,
	Rotation = 90,
	Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(34, 35, 43)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 19, 24))
	})
})

local Glow = make("Frame", {
	Parent = Main,
	Size = UDim2.new(1, 0, 0, 4),
	BackgroundColor3 = Color3.fromRGB(0, 145, 255),
	BorderSizePixel = 0
})
make("UIGradient", {
	Parent = Glow,
	Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 110, 220))
	})
})

local Header = make("Frame", {
	Parent = Main,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0, 8),
	Size = UDim2.new(1, 0, 0, 40)
})

local Title = make("TextLabel", {
	Parent = Header,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 16, 0, 0),
	Size = UDim2.new(1, -32, 1, 0),
	Text = "noobez Hub loader",
	TextColor3 = Color3.fromRGB(255, 255, 255),
	Font = Enum.Font.GothamSemibold,
	TextSize = 18,
	TextXAlignment = Enum.TextXAlignment.Left
})

local Close = make("TextButton", {
	Parent = Header,
	Size = UDim2.new(0, 28, 0, 28),
	Position = UDim2.new(1, -42, 0, 6),
	BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	BackgroundTransparency = 0.9,
	Text = "×",
	TextColor3 = Color3.fromRGB(240, 240, 240),
	Font = Enum.Font.GothamBold,
	TextSize = 20,
	BorderSizePixel = 0
})
make("UICorner", {Parent = Close, CornerRadius = UDim.new(1, 0)})

local Subtitle = make("TextLabel", {
	Parent = Main,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 16, 0, 52),
	Size = UDim2.new(1, -32, 0, 18),
	Text = "Enter your access key below.",
	TextColor3 = Color3.fromRGB(175, 178, 186),
	Font = Enum.Font.Gotham,
	TextSize = 13,
	TextXAlignment = Enum.TextXAlignment.Left
})

local Box = make("TextBox", {
	Parent = Main,
	Size = UDim2.new(1, -32, 0, 46),
	Position = UDim2.new(0, 16, 0, 88),
	BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	BackgroundTransparency = 0.92,
	TextColor3 = Color3.fromRGB(255, 255, 255),
	PlaceholderText = "Type key here...",
	PlaceholderColor3 = Color3.fromRGB(140, 144, 152),
	Text = "",
	ClearTextOnFocus = false,
	Font = Enum.Font.Gotham,
	TextSize = 16,
	BorderSizePixel = 0
})
make("UICorner", {Parent = Box, CornerRadius = UDim.new(0, 14)})
make("UIStroke", {Parent = Box, Color = Color3.fromRGB(255, 255, 255), Transparency = 0.9, Thickness = 1})

local Button = make("TextButton", {
	Parent = Main,
	Size = UDim2.new(1, -32, 0, 46),
	Position = UDim2.new(0, 16, 0, 144),
	BackgroundColor3 = Color3.fromRGB(0, 135, 255),
	Text = "Verify",
	TextColor3 = Color3.fromRGB(255, 255, 255),
	Font = Enum.Font.GothamBold,
	TextSize = 16,
	BorderSizePixel = 0
})
make("UICorner", {Parent = Button, CornerRadius = UDim.new(0, 14)})
make("UIGradient", {
	Parent = Button,
	Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 190, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 110, 220))
	})
})

local Status = make("TextLabel", {
	Parent = Main,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 16, 0, 196),
	Size = UDim2.new(1, -32, 0, 16),
	Text = "",
	TextColor3 = Color3.fromRGB(255, 120, 120),
	Font = Enum.Font.Gotham,
	TextSize = 13,
	TextXAlignment = Enum.TextXAlignment.Left
})

local Credit = make("TextLabel", {
	Parent = Main,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 16, 1, -20),
	Size = UDim2.new(1, -32, 0, 16),
	Text = "Made By Sardo",
	TextColor3 = Color3.fromRGB(145, 148, 156),
	Font = Enum.Font.Gotham,
	TextSize = 12,
	TextXAlignment = Enum.TextXAlignment.Right
})

Main.Size = UDim2.new(0, 320, 0, 190)
Main.BackgroundTransparency = 1
for _, obj in ipairs(Main:GetDescendants()) do
	if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
		obj.TextTransparency = 1
	end
	if obj:IsA("UIStroke") then
		obj.Transparency = 1
	end
end

tween(Blur, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 22}):Play()
tween(Dim, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.45}):Play()
tween(Main, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	Size = UDim2.new(0, 390, 0, 230),
	BackgroundTransparency = 0.12
}):Play()

task.wait(0.04)
for _, obj in ipairs(Main:GetDescendants()) do
	if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
		tween(obj, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
	elseif obj:IsA("UIStroke") then
		tween(obj, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0.88}):Play()
	end
end

local dragging = false
local dragStart
local startPos

Header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

local function showIntro()
	local Intro = make("Frame", {
		Parent = Gui,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0
	})

	local Logo = make("ImageLabel", {
		Parent = Intro,
		Size = UDim2.new(0, 100, 0, 100),
		Position = UDim2.new(0.5, -50, 0.5, -86),
		BackgroundTransparency = 1,
		Image = "rbxassetid://91418903947836",
		ImageTransparency = 1
	})

	local IntroTitle = make("TextLabel", {
		Parent = Intro,
		Size = UDim2.new(1, 0, 0, 42),
		Position = UDim2.new(0, 0, 0.5, 14),
		BackgroundTransparency = 1,
		Text = "noobez Hub",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.GothamBold,
		TextSize = 28,
		TextTransparency = 1
	})

	local IntroSub = make("TextLabel", {
		Parent = Intro,
		Size = UDim2.new(1, 0, 0, 18),
		Position = UDim2.new(0, 0, 0.5, 52),
		BackgroundTransparency = 1,
		Text = "Loading...",
		TextColor3 = Color3.fromRGB(180, 180, 190),
		Font = Enum.Font.Gotham,
		TextSize = 14,
		TextTransparency = 1
	})

	tween(Logo, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
	tween(IntroTitle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
	tween(IntroSub, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
	task.wait(1.1)
	Intro:Destroy()
end

local function loadMainScript()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/o88x8/888/refs/heads/888-Hub/Test.lua"))()
end

local function closeUI()
	tween(Blur, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 0}):Play()
	tween(Dim, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
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
			task.wait(0.2)
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
