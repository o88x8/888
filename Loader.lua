local Players = game:GetService("Players")
local player = Players.LocalPlayer

local validKeys = {"TEST-KEY-456", "KEY-ABC-123"}

-- Minimal-GUI
local sg = Instance.new("ScreenGui")
sg.ResetOnSpawn = false
sg.Parent = player:WaitForChild("PlayerGui")

local f = Instance.new("Frame")
f.Size = UDim2.new(0, 200, 0, 120)
f.Position = UDim2.new(0.5, -100, 0.5, -60)
f.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
f.Parent = sg

local b = Instance.new("TextBox")
b.Size = UDim2.new(0.8, 0, 0, 30)
b.Position = UDim2.new(0.1, 0, 0.1, 0)
b.PlaceholderText = "Key..."
b.Parent = f

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.8, 0, 0, 30)
btn.Position = UDim2.new(0.1, 0, 0.5, 0)
btn.Text = "Check"
btn.Parent = f

local s = Instance.new("TextLabel")
s.Size = UDim2.new(1, 0, 0, 30)
s.Position = UDim2.new(0, 0, 0.8, 0)
s.TextColor3 = Color3.fromRGB(255, 255, 255)
s.Parent = f

-- LOGIK
btn.MouseButton1Click:Connect(function()
    -- WICHTIG: Entfernt versehentliche Leerzeichen beim Kopieren!
    local inputKey = string.gsub(b.Text, "%s+", "") 
    b.Text = inputKey 
    
    print("=== GEKLICKT ===")
    print("Eingabe: [" .. inputKey .. "]")
    
    s.Text = "Prüfe..."
    s.TextColor3 = Color3.fromRGB(255, 255, 0)
    btn.Enabled = false
    
    -- KEIN task.wait(1) mehr! Es geht sofort weiter.
    
    local isValid = false
    for _, k in ipairs(validKeys) do
        if string.lower(inputKey) == string.lower(k) then
            isValid = true
            break
        end
    end
    
    print("Ergebnis: " .. tostring(isValid))
    
    if isValid then
        print("ERFOLG!")
        s.Text = "✅ Richtig!"
        s.TextColor3 = Color3.fromRGB(0, 255, 0)
        
        -- Wenn das hier steht, bauen wir das loadstring ein
    else
        print("FEHLER!")
        s.Text = "❌ Falsch!"
        s.TextColor3 = Color3.fromRGB(255, 0, 0)
        btn.Enabled = true
    end
end)
