local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ==========================================
-- HIER DEINE KEYS EINTRAGEN
-- ==========================================
local validKeys = {
    "TEST-KEY-456",
    "KEY-ABC-123",
    "DEIN-GEHEIMER-KEY"
}
-- ==========================================

-- === GUI ERSTELLEN ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LoginGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 180)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "Login"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = mainFrame

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(0.8, 0, 0, 35)
inputBox.Position = UDim2.new(0.1, 0, 0.3, 0)
inputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.PlaceholderText = "Key eingeben..."
inputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
inputBox.Font = Enum.Font.Gotham
inputBox.TextSize = 14
inputBox.ClearTextOnFocus = false
inputBox.Parent = mainFrame
Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0, 5)

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.8, 0, 0, 35)
btn.Position = UDim2.new(0.1, 0, 0.6, 0)
btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Text = "Entsperren"
btn.Font = Enum.Font.GothamBold
btn.TextSize = 14
btn.Parent = mainFrame
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(0.9, 0, 0, 30)
status.Position = UDim2.new(0.05, 0, 0.85, 0)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(200, 200, 200)
status.Text = ""
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.TextWrapped = true
status.Parent = mainFrame
-- === GUI ENDE ===


-- === LOGIK ===
btn.MouseButton1Click:Connect(function()
    local inputKey = inputBox.Text
    
    if inputKey == "" then
        status.Text = "Bitte einen Key eingeben!"
        status.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end
    
    status.Text = "Prüfe..."
    status.TextColor3 = Color3.fromRGB(255, 255, 100)
    btn.Enabled = false
    
    task.wait(1)
    
    local keyIsValid = false
    
    for _, validKey in ipairs(validKeys) do
        if string.lower(inputKey) == string.lower(validKey) then
            keyIsValid = true
            break
        end
    end
    
    if keyIsValid then
        status.Text = "✅ Erfolg! Lade Skript..."
        status.TextColor3 = Color3.fromRGB(80, 255, 80)
        
        -- Wir warten kurz, damit der Spieler den Erfolg noch sieht
        task.wait(0.5)
        
        -- GUI schließen
        screenGui:Destroy()
        
        -- ==========================================
        -- LADSTRING AUFRUFEN
        -- Ersetze die URL unten mit deinem echten Pastebin/Raw Link!
        -- ==========================================
        local success, errorMsg = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/o88x8/888/refs/heads/888-Hub/Test.lua"))()
        end)
        
        -- Falls das Laden fehlschlägt (z.B. Link kaputt oder HTTP Requests nicht erlaubt)
        if not success then
            warn("Fehler beim Laden des Skripts: " .. tostring(errorMsg))
        end
        -- ==========================================
        
    else
        status.Text = "❌ Falscher Key!"
        status.TextColor3 = Color3.fromRGB(255, 80, 80)
        btn.Enabled = true
    end
end)
