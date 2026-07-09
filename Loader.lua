local Players = game:GetService("Players")
local player = Players.LocalPlayer

local validKeys = {"TEST-KEY-456"}

-- KNALLPINKES GUI
local sg = Instance.new("ScreenGui")
sg.Parent = player:WaitForChild("PlayerGui")

local f = Instance.new("Frame")
f.Size = UDim2.new(0, 300, 0, 150)
f.Position = UDim2.new(0.5, -150, 0.5, -75)
f.BackgroundColor3 = Color3.fromRGB(255, 0, 200) -- PINK
f.Parent = sg

local t = Instance.new("TextLabel")
t.Size = UDim2.new(1, 0, 0, 30)
t.BackgroundTransparency = 1
t.TextColor3 = Color3.new(1,1,1)
t.Text = "NEUES SKRIPT 123"
t.Font = Enum.Font.GothamBold
t.Parent = f

local b = Instance.new("TextBox")
b.Size = UDim2.new(0.8, 0, 0, 30)
b.Position = UDim2.new(0.1, 0, 0.3, 0)
b.Text = ""
b.PlaceholderText = "TIPP: TEST-KEY-456"
b.Parent = f

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.8, 0, 0, 30)
btn.Position = UDim2.new(0.1, 0, 0.65, 0)
btn.Text = "KLICK MICH"
btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
btn.TextColor3 = Color3.new(1,1,1)
btn.Parent = f

local s = Instance.new("TextLabel")
s.Size = UDim2.new(1, 0, 0, 30)
s.Position = UDim2.new(0, 0, 0.9, 0)
s.TextColor3 = Color3.new(1,1,1)
s.Text = ""
s.Parent = f

-- LOGIK
btn.MouseButton1Click:Connect(function()
    print("BANANE 1 - Button geklickt")
    local k = b.Text
    print("BANANE 2 - Dein Text: " .. k)
    
    s.Text = "Prüfe..."
    print("BANANE 3 - Text gesetzt")
    
    local ok = false
    if k == "TEST-KEY-456" then
        ok = true
    end
    
    print("BANANE 4 - Check beendet: " .. tostring(ok))
    
    if ok then
        s.Text = "GEKLAPPT!"
        print("BANANE 5 - SUCCESS")
    else
        s.Text = "FALSCH!"
        print("BANANE 6 - FAIL")
    end
end)
