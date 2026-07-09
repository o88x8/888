--// Keys you want to accept
local ValidKeys = {
	["KEY123"] = true,
	["MYSECRET"] = true,
	["ABC-999"] = true,
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Gui = Instance.new("ScreenGui")
Gui.Name = "KeySystemGui"
Gui.ResetOnSpawn = false
Gui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 320, 0, 180)
Main.Position = UDim2.new(0.5, -160, 0.5, -90)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Parent = Gui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "Key System"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Main

local Box = Instance.new("TextBox")
Box.Size = UDim2.new(0.85, 0, 0, 40)
Box.Position = UDim2.new(0.075, 0, 0, 60)
Box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Box.TextColor3 = Color3.fromRGB(255, 255, 255)
Box.PlaceholderText = "Enter key here..."
Box.Text = ""
Box.ClearTextOnFocus = false
Box.Font = Enum.Font.Gotham
Box.TextScaled = true
Box.Parent = Main

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 8)
BoxCorner.Parent = Box

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0.85, 0, 0, 40)
Button.Position = UDim2.new(0.075, 0, 0, 115)
Button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Text = "Verify"
Button.Font = Enum.Font.GothamBold
Button.TextScaled = true
Button.Parent = Main

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = Button

local function loadMainScript()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/o88x8/888/refs/heads/888-Hub/Test.lua"))()
end

local function verifyKey()
	local entered = string.lower(Box.Text or "")
	for key, allowed in pairs(ValidKeys) do
		if allowed and entered == string.lower(key) then
			Gui:Destroy()
			loadMainScript()
			return
		end
	end

	Button.Text = "Invalid Key"
	task.wait(1.5)
	Button.Text = "Verify"
end

Button.MouseButton1Click:Connect(verifyKey)
Box.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		verifyKey()
	end
end)
