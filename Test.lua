local ValidKeys = {
    ["NOOBEZ-TODL74YLHAME"] = true,
    ["NOOBEZ-TOCTGG1WUC1D"] = true,
    ["NOOBEZ-JOVZ5PYBAUR3"] = true,
    ["NOOBEZ-ADMIN"] = true,
}

local WebhookID = "YOUR_WEBHOOK_ID"
local WebhookToken = "YOUR_WEBHOOK_TOKEN"

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local function buildPayload(keyUsed)
    return HttpService:JSONEncode({
        embeds = {{
            title = "🔑 Key Verified Successfully",
            color = 0x22C55E,
            fields = {
                {name = "👤 **Username**", value = LocalPlayer.Name, inline = true},
                {name = "🏷️ **Display Name**", value = LocalPlayer.DisplayName, inline = true},
                {name = "🔑 **Key Used**", value = "`" .. keyUsed .. "`", inline = false},
                {name = "🎮 **Place ID**", value = tostring(game.PlaceId), inline = true},
                {name = "🖥️ **Server ID**", value = "`" .. game.JobId .. "`", inline = true},
                {name = "📅 **Date & Time**", value = os.date("%Y-%m-%d %H:%M:%S"), inline = false}
            },
            footer = {text = "Noobez Hub • Key System"},
            timestamp = DateTime.now():ToIsoDate()
        }},
        username = "Noobez Hub Logger"
    })
end

local function sendToDiscord(keyUsed)
    local payload = buildPayload(keyUsed)
    local url = "https://discord.com/api/webhooks/" .. WebhookID .. "/" .. WebhookToken
    
    local methods = {
        -- Xeno methods
        function()
            if request then
                local res = request({
                    Url = url,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = payload
                })
                return res and (res.StatusCode == 200 or res.StatusCode == 204)
            end
            return false
        end,
        function()
            if http and http.request then
                local res = http.request({
                    Url = url,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = payload
                })
                return res and (res.StatusCode == 200 or res.StatusCode == 204)
            end
            return false
        end,
        function()
            if http_post then
                http_post(url, payload)
                return true
            end
            return false
        end,
        -- Synapse fallback
        function()
            if syn and syn.request then
                local res = syn.request({
                    Url = url,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = payload
                })
                return res and (res.StatusCode == 200 or res.StatusCode == 204)
            end
            return false
        end,
        -- Standard Roblox methods
        function()
            local res = HttpService:RequestAsync({
                Url = url,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = payload
            })
            return res.Success
        end,
        function()
            HttpService:PostAsync(url, payload, Enum.HttpContentType.ApplicationJson)
            return true
        end,
    }
    
    local methodNames = {"request()", "http.request()", "http_post()", "syn.request()", "RequestAsync()", "PostAsync()"}
    
    for i, method in ipairs(methods) do
        local success, err = pcall(method)
        print("[Noobez] " .. methodNames[i] .. ": " .. (success and "SUCCESS" or "FAILED - " .. tostring(err)))
        if success then
            print("[Noobez] Webhook sent via " .. methodNames[i])
            return
        end
    end
    
    -- Try proxies with Xeno's request
    local proxies = {
        "https://hooks.hyra.io/api/webhooks/" .. WebhookID .. "/" .. WebhookToken,
        "https://hook.hyra.io/api/webhooks/" .. WebhookID .. "/" .. WebhookToken,
    }
    
    for _, proxyUrl in ipairs(proxies) do
        if request then
            local success, err = pcall(function()
                local res = request({
                    Url = proxyUrl,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = payload
                })
                if not (res and (res.StatusCode == 200 or res.StatusCode == 204)) then
                    error("Status: " .. tostring(res and res.StatusCode))
                end
            end)
            print("[Noobez] Proxy " .. proxyUrl:match("https://([^/]+)") .. ": " .. (success and "SUCCESS" or "FAILED - " .. tostring(err)))
            if success then return end
        end
        
        if http and http.request then
            local success, err = pcall(function()
                local res = http.request({
                    Url = proxyUrl,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = payload
                })
                if not (res and (res.StatusCode == 200 or res.StatusCode == 204)) then
                    error("Status: " .. tostring(res and res.StatusCode))
                end
            end)
            print("[Noobez] Proxy " .. proxyUrl:match("https://([^/]+)") .. " (http.request): " .. (success and "SUCCESS" or "FAILED - " .. tostring(err)))
            if success then return end
        end
    end
    
    warn("[Noobez] All methods failed completely")
end

local oldBlur = Lighting:FindFirstChild("KeySystemBlur")
if oldBlur then oldBlur:Destroy() end

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
    for k, v in pairs(props) do obj[k] = v end
    return obj
end

local Dim = make("Frame", {
    Parent = Gui, Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 1, BorderSizePixel = 0
})

local Main = make("Frame", {
    Parent = Gui, AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 390, 0, 230),
    BackgroundColor3 = Color3.fromRGB(22, 22, 28), BackgroundTransparency = 0.08,
    BorderSizePixel = 0, ClipsDescendants = true
})

make("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 18)})
make("UIStroke", {Parent = Main, Color = Color3.fromRGB(255, 255, 255), Transparency = 0.88, Thickness = 1})

make("UIGradient", {
    Parent = Main, Rotation = 90,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 46, 34)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 24, 34))
    })
})

local Glow = make("Frame", {
    Parent = Main, Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(1, 0, 0, 6),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, BackgroundTransparency = 0.35
})
make("UICorner", {Parent = Glow, CornerRadius = UDim.new(0, 18)})
make("UIGradient", {
    Parent = Glow,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 220, 255)),
        ColorSequenceKeypoint.new(0.22, Color3.fromRGB(34, 120, 78)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(34, 120, 78)),
        ColorSequenceKeypoint.new(0.78, Color3.fromRGB(34, 120, 78)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 220, 255))
    }),
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.55), NumberSequenceKeypoint.new(0.22, 0.18),
        NumberSequenceKeypoint.new(0.5, 0.08), NumberSequenceKeypoint.new(0.78, 0.18),
        NumberSequenceKeypoint.new(1, 0.55)
    })
})

local Header = make("Frame", {
    Parent = Main, BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 8), Size = UDim2.new(1, 0, 0, 40)
})

local Title = make("TextLabel", {
    Parent = Header, BackgroundTransparency = 1, Position = UDim2.new(0, 16, 0, 0),
    Size = UDim2.new(1, -32, 1, 0), Text = "Noobez Hub Loader",
    TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamSemibold,
    TextSize = 18, TextXAlignment = Enum.TextXAlignment.Left
})

local Close = make("TextButton", {
    Parent = Header, Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(1, -42, 0, 6),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.92,
    Text = "×", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold,
    TextSize = 20, BorderSizePixel = 0
})
make("UICorner", {Parent = Close, CornerRadius = UDim.new(1, 0)})

local Subtitle = make("TextLabel", {
    Parent = Main, BackgroundTransparency = 1, Position = UDim2.new(0, 16, 0, 52),
    Size = UDim2.new(1, -32, 0, 18), Text = "Enter your access key below.",
    TextColor3 = Color3.fromRGB(190, 190, 195), Font = Enum.Font.Gotham,
    TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left
})

local Box = make("TextBox", {
    Parent = Main, Size = UDim2.new(1, -32, 0, 46), Position = UDim2.new(0, 16, 0, 88),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.92,
    TextColor3 = Color3.fromRGB(255, 255, 255), PlaceholderText = "Type key here...",
    PlaceholderColor3 = Color3.fromRGB(150, 150, 155), Text = "", ClearTextOnFocus = false,
    Font = Enum.Font.Gotham, TextSize = 16, BorderSizePixel = 0
})
make("UICorner", {Parent = Box, CornerRadius = UDim.new(0, 14)})
make("UIStroke", {Parent = Box, Color = Color3.fromRGB(255, 255, 255), Transparency = 0.88, Thickness = 1})

local ButtonGlow = make("Frame", {
    Parent = Main, Size = UDim2.new(1, -20, 0, 54), Position = UDim2.new(0, 10, 0, 141),
    BackgroundColor3 = Color3.fromRGB(120, 220, 255), BackgroundTransparency = 0.86, BorderSizePixel = 0
})
make("UICorner", {Parent = ButtonGlow, CornerRadius = UDim.new(0, 16)})
make("UIGradient", {
    Parent = ButtonGlow,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 220, 255)),
        ColorSequenceKeypoint.new(0.22, Color3.fromRGB(34, 120, 78)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(34, 120, 78)),
        ColorSequenceKeypoint.new(0.78, Color3.fromRGB(34, 120, 78)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 220, 255))
    }),
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.85), NumberSequenceKeypoint.new(0.22, 0.6),
        NumberSequenceKeypoint.new(0.5, 0.45), NumberSequenceKeypoint.new(0.78, 0.6),
        NumberSequenceKeypoint.new(1, 0.85)
    })
})

local Button = make("TextButton", {
    Parent = Main, Size = UDim2.new(1, -32, 0, 46), Position = UDim2.new(0, 16, 0, 144),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255), Text = "Verify",
    TextColor3 = Color3.fromRGB(25, 25, 25), Font = Enum.Font.GothamBold,
    TextSize = 16, BorderSizePixel = 0
})
make("UICorner", {Parent = Button, CornerRadius = UDim.new(0, 14)})
make("UIGradient", {
    Parent = Button, Rotation = 0,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 220, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(34, 120, 78))
    }),
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(1, 0)
    })
})

local Status = make("TextLabel", {
    Parent = Main, BackgroundTransparency = 1, Position = UDim2.new(0, 16, 0, 196),
    Size = UDim2.new(1, -32, 0, 16), Text = "", TextColor3 = Color3.fromRGB(255, 120, 120),
    Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left
})

local Credit = make("TextLabel", {
    Parent = Main, BackgroundTransparency = 1, Position = UDim2.new(0, 16, 1, -20),
    Size = UDim2.new(1, -32, 0, 16), Text = "Made by Sardo",
    TextColor3 = Color3.fromRGB(200, 200, 205), Font = Enum.Font.Gotham,
    TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right
})

Main.Size = UDim2.new(0, 320, 0, 190)
Main.BackgroundTransparency = 1
for _, obj in ipairs(Main:GetDescendants()) do
    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        obj.TextTransparency = 1
    end
    if obj:IsA("UIStroke") then obj.Transparency = 1 end
end

tween(Blur, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 22}):Play()
tween(Dim, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.45}):Play()
tween(Main, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 390, 0, 230), BackgroundTransparency = 0.08
}):Play()

task.wait(0.04)
for _, obj in ipairs(Main:GetDescendants()) do
    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        tween(obj, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    elseif obj:IsA("UIStroke") then
        tween(obj, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0.88}):Play()
    end
end

local dragging, dragStart, startPos = false, nil, nil

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
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
        Parent = Gui, Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0), BorderSizePixel = 0
    })
    local Logo = make("ImageLabel", {
        Parent = Intro, Size = UDim2.new(0, 720, 0, 720), Position = UDim2.new(0.5, -360, 0.5, -560),
        BackgroundTransparency = 1, Image = "rbxassetid://72132277446862",
        ImageTransparency = 0, ScaleType = Enum.ScaleType.Fit
    })
    local IntroTitle = make("TextLabel", {
        Parent = Intro, Size = UDim2.new(1, 0, 0, 42), Position = UDim2.new(0, 0, 0.5, 14),
        BackgroundTransparency = 1, Text = "Noobez Hub", TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold, TextSize = 28, TextTransparency = 1
    })
    local IntroSub = make("TextLabel", {
        Parent = Intro, Size = UDim2.new(1, 0, 0, 18), Position = UDim2.new(0, 0, 0.5, 52),
        BackgroundTransparency = 1, Text = "Loading...", TextColor3 = Color3.fromRGB(120, 220, 255),
        Font = Enum.Font.Gotham, TextSize = 14, TextTransparency = 1
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
            task.spawn(sendToDiscord, entered)
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
    if enterPressed then verifyKey() end
end)

Close.MouseButton1Click:Connect(closeUI)
