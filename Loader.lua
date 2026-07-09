local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ==========================================
-- 1. HIER DEINE KEYS EINTRAGEN
-- ==========================================
local validKeys = {
    "TEST-KEY-456",
    "KEY-ABC-123"
}
-- ==========================================

-- === SAUBERES GUI ERSTELLEN ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SchluesselGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 180)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "Script Login"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.Parent = mainFrame

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(0.8, 0, 0, 35)
inputBox.Position = UDim2.new(0.1, 0, 0.3, 0)
inputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.PlaceholderText = "Key eingeben..."
inputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
inputBox.Font = Enum.Font.Gotham
inputBox.TextSize = 14
inputBox.ClearTextOnFocus = false
inputBox.Parent = mainFrame
Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0, 6)

local checkBtn = Instance.new("TextButton")
checkBtn.Size = UDim2.new(0.8, 0, 0, 35)
checkBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
checkBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
checkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
checkBtn.Text = "Entsperren"
checkBtn.Font = Enum.Font.GothamBold
checkBtn.TextSize = 14
checkBtn.Parent = mainFrame
Instance.new("UICorner", checkBtn).CornerRadius = UDim.new(0, 6)

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 30)
statusLabel.Position = UDim2.new(0.05, 0, 0.85, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Text = ""
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.TextWrapped = true
statusLabel.Parent = mainFrame
-- === GUI ENDE ===


-- === LOGIK ===
checkBtn.MouseButton1Click:Connect(function()
    -- %s+ entfernt versehentlich mitkopierte Leerzeichen am Anfang/Ende
    local inputKey = string.gsub(inputBox.Text, "%s+", "") 
    inputBox.Text = inputKey 
    
    if inputKey == "" then
        statusLabel.Text = "Bitte einen Key eingeben!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end
    
    statusLabel.Text = "Prüfe..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    checkBtn.Enabled = false
    
    local keyIsValid = false
    
    for _, validKey in ipairs(validKeys) do
        if string.lower(inputKey) == string.lower(validKey) then
            keyIsValid = true
            break
        end
    end
    
    if keyIsValid then
        statusLabel.Text = "✅ Erfolg! Lade Skript..."
        statusLabel.TextColor3 = Color3.fromRGB(80, 255, 80)
        
        task.wait(0.5) -- Kurze Pause, damit man den grünen Text sieht
        
        -- GUI sofort schließen, BEVOR das loadstring lädt
        screenGui:Destroy()
        
        -- ==========================================
        -- 2. HIER DEIN LOADSTRING EINFÜGEN
        -- ==========================================
        local success, errorMsg = pcall(function()
            -- Ersetze diese URL mit deinem Pastebin/Raw GitHub Link!
            loadstring(game:HttpGet("https://raw.githubusercontent.com/o88x8/888/refs/heads/888-Hub/Test.lua"))()
        end)
        
        if not success then
            -- Wenn das Laden fehlschlägt, wird es im Output-Fenster (F9) als Warnung angezeigt
            warn("Fehler beim Laden des Skripts via loadstring: " .. tostring(errorMsg))
        end
        -- ==========================================
        
    else
        statusLabel.Text = "❌ Falscher Key!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        checkBtn.Enabled = true -- Button wieder freigeben für neuen Versuch
    end
end)
