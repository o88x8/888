--// Keys you want to accept
local ValidKeys = {
	["KEY123"] = true,
	["MYSECRET"] = true,
	["ABC-999"] = true,
}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Gui = Instance.new("ScreenGui")
Gui.Name = "KeySystemGui"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Parent = PlayerGui

local Shadow = Instance.new("Frame")
Shadow.Size = UDim2.new(0, 340, 0, 210)
Shadow.Position = UDim2.new(0.5, -170, 0.5, -105)
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.35
Shadow.BorderSizePixel = 0
Shadow.Parent = Gui

local ShadowCorner = Instance.new("UICorner")
ShadowCorner.CornerRadius = UDim.new(0, 16)
ShadowCorner.Parent = Shadow

local Main = Instance.new("Frame")
Main.Size = UDim2.new(1, -8, 1, -8)
Main.Position = UDim2.new(0, 4, 0, 4)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Main.BorderSizePixel = 0
Main.Parent = Shadow

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(70, 70, 90)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.2
MainStroke.Parent = Main

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 16)
TopCorner.Parent = TopBar

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 18)
TitleFix.Position = UDim2.new(0, 0, 1, -18)
TitleFix.BackgroundColor3 = TopBar.BackgroundColor3
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Key Verification"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -20, 0, 20)
Subtitle.Position = UDim2.new(0, 10, 0, 55)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Enter your access key below"
Subtitle.TextColor3 = Color3.fromRGB(180, 180, 190)
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 14
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Main

local Box = Instance.new("TextBox")
Box.Size = UDim2.new(1, -20, 0, 42)
Box.Position = UDim2.new(0, 10, 0, 85)
Box.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
Box.TextColor3 = Color3.fromRGB(255, 255, 255)
Box.PlaceholderText = "Type key here..."
Box.PlaceholderColor3 = Color3.fromRGB(140, 140, 150)
Box.Text = ""
Box.ClearTextOnFocus = false
Box.Font = Enum.Font.Gotham
Box.TextSize = 16
Box.BorderSizePixel = 0
Box.Parent = Main

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 10)
BoxCorner.Parent = Box

local BoxStroke = Instance.new("UIStroke")
BoxStroke.Color = Color3.fromRGB(80, 80, 100)
BoxStroke.Thickness = 1
BoxStroke.Transparency = 0.35
BoxStroke.Parent = Box

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(1, -20, 0, 42)
Button.Position = UDim2.new(0, 10, 0, 138)
Button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Text = "Verify"
Button.Font = Enum.Font.GothamBold
Button.TextSize = 16
Button.BorderSizePixel = 0
Button.Parent = Main

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 10)
ButtonCorner.Parent = Button

local ButtonGradient = Instance.new("UIGradient")
ButtonGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 120, 255))
})
ButtonGradient.Rotation = 0
ButtonGradient.Parent = Button

local ButtonStroke = Instance.new("UIStroke")
ButtonStroke.Color = Color3.fromRGB(255, 255, 255)
ButtonStroke.Thickness = 1
ButtonStroke.Transparency = 0.75
ButtonStroke.Parent = Button

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -20, 0, 18)
Status.Position = UDim2.new(0, 10, 0, 186)
Status.BackgroundTransparency = 1
Status.Text = ""
Status.TextColor3 = Color3.fromRGB(255, 120, 120)
Status.Font = Enum.Font.Gotham
Status.TextSize = 13
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = Main

local function tween(obj, props)
	TweenService:Create(obj, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

Button.MouseEnter:Connect(function()
	tween(Button, {BackgroundTransparency = 0.05})
end)

Button.MouseLeave:Connect(function()
	tween(Button, {BackgroundTransparency = 0})
end)

local function loadMainScript()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/o88x8/888/refs/heads/888-Hub/Test.lua"))()
end

local function verifyKey()
	local entered = string.lower((Box.Text or ""):gsub("^%s*(.-)%s*$", "%1"))

	for key, allowed in pairs(ValidKeys) do
		if allowed and entered == string.lower(key) then
			Status.TextColor3 = Color3.fromRGB(120, 255, 140)
			Status.Text = "Key accepted."
			task.wait(0.4)
			Gui:Destroy()
			loadMainScript()
			return
		end
	end

	Status.TextColor3 = Color3.fromRGB(255, 120, 120)
	Status.Text = "Invalid key."
	Button.Text = "Try Again"
	task.wait(1.2)
	Button.Text = "Verify"
end

Button.MouseButton1Click:Connect(verifyKey)
Box.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		verifyKey()
	end
end)
