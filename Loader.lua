local Players = game:GetService("Players")
local player = Players.LocalPlayer

local validKeys = {"TEST-KEY-456", "KEY-ABC-123"}

-- GUI (verkürzt damit es weniger Text ist)
local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.5, -100, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Parent = screenGui

local box = Instance.new("TextBox")
box.Size = UDim2.new(0.8, 0, 0, 30)
box.Position = UDim2.new(0.1, 0, 0.2, 0)
box.PlaceholderText = "Key..."
box.Parent = frame

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.8, 0, 0, 30)
btn.Position = UDim2.new(0.1, 0, 0.6, 0)
btn.Text = "Check"
btn.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 30)
status.Position = UDim2.new(0, 0, 0.85, 0)
status.TextColor3 = Color3.fromRGB(255, 255, 255)
status.Parent = frame

-- LOGIK MIT PRINTS
btn.MouseButton1Click:Connect(function()
    print("--- BUTTON GEKLICKT ---")
    local inputKey = box.Text
    print("Dein Input: " .. tostring(inputKey))
    
    status.Text = "Prüfe..."
    print("1. Text auf Prüfe... gesetzt")
    
    task.wait(1)
    print("2. Die 1 Sekunde ist VORBEI!")
    
    local isValid = false
    for _, k in ipairs(validKeys) do
        if string.lower(inputKey) == string.lower(k) then
            isValid = true
            break
        end
    end
    print("3. Schleife beendet. Ergebnis: " .. tostring(isValid))
    
    if isValid then
        status.Text = "Richtig!"
        print("4. ✅ ERFOLG IM GUI")
    else
        status.Text = "Falsch!"
        print("4. ❌ FEHLER IM GUI")
    end
end)
