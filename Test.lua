local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Window with custom theme, name, and creator
local Window = Rayfield:CreateWindow({
    Name = "888 Hub",
    LoadingTitle = "888 Hub",
    LoadingSubtitle = "by Sardo",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "888Hub",
        FileName = "Config"
    },
    KeySystem = false,
    DisableKeyBindings = false,
    ToggleKey = Enum.KeyCode.K,
    Theme = {
	    TextColor = Color3.fromRGB(240, 240, 240),

	    Background = Color3.fromRGB(18, 14, 24),
	    Topbar = Color3.fromRGB(26, 18, 38),
	    Shadow = Color3.fromRGB(12, 8, 18),

	    NotificationBackground = Color3.fromRGB(14, 10, 20),
	    NotificationActionsBackground = Color3.fromRGB(220, 206, 245),

	    TabBackground = Color3.fromRGB(52, 36, 72),
	    TabStroke = Color3.fromRGB(66, 46, 92),
	    TabBackgroundSelected = Color3.fromRGB(198, 176, 232),
	    TabTextColor = Color3.fromRGB(240, 240, 240),
	    SelectedTabTextColor = Color3.fromRGB(40, 22, 58),

	    ElementBackground = Color3.fromRGB(28, 20, 40),
	    ElementBackgroundHover = Color3.fromRGB(34, 24, 48),
	    SecondaryElementBackground = Color3.fromRGB(20, 14, 30),
	    ElementStroke = Color3.fromRGB(56, 40, 78),
	    SecondaryElementStroke = Color3.fromRGB(44, 30, 62),

	    SliderBackground = Color3.fromRGB(98, 58, 160),
	    SliderProgress = Color3.fromRGB(144, 84, 228),
	    SliderStroke = Color3.fromRGB(170, 112, 255),

	    ToggleBackground = Color3.fromRGB(22, 16, 32),
	    ToggleEnabled = Color3.fromRGB(102, 52, 184),
	    ToggleDisabled = Color3.fromRGB(82, 72, 106),
	    ToggleEnabledStroke = Color3.fromRGB(144, 88, 238),
	    ToggleDisabledStroke = Color3.fromRGB(104, 92, 130),
	    ToggleEnabledOuterStroke = Color3.fromRGB(86, 60, 118),
	    ToggleDisabledOuterStroke = Color3.fromRGB(54, 40, 74),

	    DropdownSelected = Color3.fromRGB(30, 22, 44),
	    DropdownUnselected = Color3.fromRGB(22, 16, 34),

	    InputBackground = Color3.fromRGB(22, 16, 34),
	    InputStroke = Color3.fromRGB(68, 48, 94),
	    PlaceholderColor = Color3.fromRGB(176, 162, 198)
    }
})

local CorpseMap = {}

local SBRTab = Window:CreateTab("SBR", 4483362458) 
local FarmTab = Window:CreateTab("Farm", 4483362458)

-- =========================================================
-- SBR TAB CONTENT
-- =========================================================

local SpeedSlider = SBRTab:CreateSlider({
   Name = "Tween Speed",
   Range = {50, 500},
   Increment = 10,
   Suffix = "Studs/s",
   CurrentValue = 150,
   Flag = "TweenSpeed",
})

local SelectedCorpseDisplayName = nil

local CorpseDropdown = SBRTab:CreateDropdown({
   Name = "Select Corpse",
   Options = {},
   CurrentOption = {},
   MultipleOptions = false,
   Flag = "CorpseDropdown",
   Callback = function(Value)
      SelectedCorpseDisplayName = Value[1] 
   end,
})

local RefreshButton = SBRTab:CreateButton({
   Name = "Refresh Corpse List",
   Callback = function()
      local CorpseFolder = workspace:FindFirstChild("CorpseParts") and workspace.CorpseParts:FindFirstChild("SpawnedCorpseParts")
      
      if not CorpseFolder then
         Rayfield:Notify({Title = "Error", Content = "Folder not found!", Duration = 3})
         return
      end

      local DisplayNames = {}
      CorpseMap = {}

      for _, Child in pairs(CorpseFolder:GetChildren()) do
         local targetPart = nil
         local stageValue = nil

         if Child:IsA("Model") then
            for _, Descendant in pairs(Child:GetDescendants()) do
               if Descendant:IsA("BasePart") then
                  local stage = Descendant:GetAttribute("Stage") 
                  if stage then
                     targetPart = Descendant
                     stageValue = stage
                     break
                  end
               end
            end
            
            if not targetPart then
               targetPart = Child.PrimaryPart or Child:FindFirstChildWhichIsA("BasePart")
            end
         
         elseif Child:IsA("BasePart") then
            targetPart = Child
            stageValue = Child:GetAttribute("Stage")
         end

         if targetPart then
            local displayName = Child.Name
            if stageValue then
               displayName = Child.Name .. " [Stage: " .. tostring(stageValue) .. "]"
            end
            
            table.insert(DisplayNames, displayName)
            CorpseMap[displayName] = targetPart
         end
      end

      CorpseDropdown:Refresh(DisplayNames, true)
      Rayfield:Notify({Title = "Updated", Content = "Found " .. #DisplayNames .. " corpses!", Duration = 3})
   end,
})

local TweenButton = SBRTab:CreateButton({
   Name = "Tween to Selected Corpse",
   Callback = function()
      local Character = LocalPlayer.Character
      
      if not Character or not Character:FindFirstChild("HumanoidRootPart") then
         Rayfield:Notify({Title = "Error", Content = "Character not found!", Duration = 3})
         return
      end

      if not SelectedCorpseDisplayName then
         Rayfield:Notify({Title = "Error", Content = "Please select a corpse first!", Duration = 3})
         return
      end

      local TargetPart = CorpseMap[SelectedCorpseDisplayName]

      if TargetPart and TargetPart:IsA("BasePart") then
         local RootPart = Character.HumanoidRootPart
         local Distance = (RootPart.Position - TargetPart.Position).Magnitude
         local Speed = SpeedSlider.CurrentValue
         local TweenTime = Distance / Speed

         local TweenInfo = TweenInfo.new(TweenTime, Enum.EasingStyle.Linear)
         local Tween = TweenService:Create(RootPart, TweenInfo, {CFrame = TargetPart.CFrame})
         
         Tween:Play()
         Rayfield:Notify({Title = "Tweening", Content = "Moving to " .. SelectedCorpseDisplayName, Duration = 3})
      else
         Rayfield:Notify({Title = "Error", Content = "Part is missing or was deleted!", Duration = 3})
      end
   end,
})

-- =========================================================
-- FARM TAB CONTENT (CHESTS)
-- =========================================================

local AutoFarmChestsToggle = FarmTab:CreateToggle({
   Name = "Auto Farm Chests",
   CurrentValue = false,
   Flag = "AutoFarmChests",
   Callback = function(Value)
      _G.AutoFarmChests = Value
      if Value then
         Rayfield:Notify({Title = "Farm", Content = "Chest farming started.", Duration = 3})
      else
         Rayfield:Notify({Title = "Farm", Content = "Chest farming stopped.", Duration = 3})
      end
   end,
})

-- Separator Label
FarmTab:CreateLabel("─────────────────────")

-- Chest Rewards List (Paragraph)
local ChestListParagraph = FarmTab:CreateParagraph({
   Title = "Chest Rewards",
   Content = "Click 'Refresh' below to load chest rewards...",
})

-- Refresh Chest Rewards Button
FarmTab:CreateButton({
   Name = "🔄 Refresh Chest Rewards",
   Callback = function()
      local SpawnedChests = workspace:FindFirstChild("Chests") and workspace.Chests:FindFirstChild("SpawnedChests")
      
      if not SpawnedChests then
         ChestListParagraph:Set("Chest Rewards", "❌ SpawnedChests folder not found!")
         return
      end
      
      local chests = {}
      for _, child in pairs(SpawnedChests:GetChildren()) do
         if child:IsA("Model") then
            table.insert(chests, child)
         end
      end
      
      if #chests == 0 then
         ChestListParagraph:Set("Chest Rewards", "No chests currently spawned.")
         return
      end
      
      local listText = ""
      local chestCount = 0
      
      for _, model in pairs(chests) do
         local reward = model:GetAttribute("Reward")
         local chestName = model.Name
         
         chestCount = chestCount + 1
         
         if reward then
            listText = listText .. "• " .. chestName .. ": " .. tostring(reward) .. "\n"
         else
            local foundReward = false
            for _, desc in pairs(model:GetDescendants()) do
               local descReward = desc:GetAttribute("Reward")
               if descReward then
                  listText = listText .. "• " .. chestName .. ": " .. tostring(descReward) .. "\n"
                  foundReward = true
                  break
               end
            end
            if not foundReward then
               listText = listText .. "• " .. chestName .. ": [No Reward Found]\n"
            end
         end
      end
      
      ChestListParagraph:Set("Chest Rewards (" .. chestCount .. ")", listText)
      Rayfield:Notify({Title = "Updated", Content = "Found " .. chestCount .. " chests!", Duration = 3})
   end,
})

-- Auto-refresh chest list every 10 seconds
task.spawn(function()
   while task.wait(10) do
      local SpawnedChests = workspace:FindFirstChild("Chests") and workspace.Chests:FindFirstChild("SpawnedChests")
      
      if not SpawnedChests then continue end
      
      local chests = {}
      for _, child in pairs(SpawnedChests:GetChildren()) do
         if child:IsA("Model") then
            table.insert(chests, child)
         end
      end
      
      if #chests == 0 then continue end
      
      local listText = ""
      local chestCount = 0
      
      for _, model in pairs(chests) do
         local reward = model:GetAttribute("Reward")
         local chestName = model.Name
         
         chestCount = chestCount + 1
         
         if reward then
            listText = listText .. "• " .. chestName .. ": " .. tostring(reward) .. "\n"
         else
            local foundReward = false
            for _, desc in pairs(model:GetDescendants()) do
               local descReward = desc:GetAttribute("Reward")
               if descReward then
                  listText = listText .. "• " .. chestName .. ": " .. tostring(descReward) .. "\n"
                  foundReward = true
                  break
               end
            end
            if not foundReward then
               listText = listText .. "• " .. chestName .. ": [No Reward]\n"
            end
         end
      end
      
      ChestListParagraph:Set("Chest Rewards (" .. chestCount .. ")", listText)
   end
end)

task.spawn(function()
   while task.wait(0.1) do
      if not _G.AutoFarmChests then continue end
      
      local Character = LocalPlayer.Character
      if not Character or not Character:FindFirstChild("HumanoidRootPart") then continue end
      
      local RootPart = Character.HumanoidRootPart
      local SpawnedChests = workspace:FindFirstChild("Chests") and workspace.Chests:FindFirstChild("SpawnedChests")
      
      if not SpawnedChests then continue end
      
      local chests = {}
      for _, child in pairs(SpawnedChests:GetChildren()) do
         if child:IsA("Model") then
            table.insert(chests, child)
         end
      end
      
      for _, model in pairs(chests) do
         if not _G.AutoFarmChests then break end
         
         if model and model.Parent then
            local targetPart = model:FindFirstChild("WoodTop", true) 
                         or model.PrimaryPart 
                         or model:FindFirstChildWhichIsA("BasePart") 
                         or model:FindFirstChildWhichIsA("MeshPart")
            
            if targetPart then
               local safeCFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
               
               RootPart.AssemblyLinearVelocity = Vector3.zero
               RootPart.AssemblyAngularVelocity = Vector3.zero
               RootPart.CFrame = safeCFrame
               
               local maxDistance = 10 
               local safetyTimer = 0
               
               while (RootPart.Position - targetPart.Position).Magnitude > maxDistance do
                  RootPart.AssemblyLinearVelocity = Vector3.zero
                  RootPart.CFrame = safeCFrame
                  task.wait(0.05)
                  safetyTimer = safetyTimer + 0.05
                  
                  if safetyTimer > 2 then 
                     break 
                  end
               end
               
               task.wait(0.25)
               
               local prompt = model:FindFirstChildWhichIsA("ProximityPrompt", true)
               if prompt then
                  RootPart.AssemblyLinearVelocity = Vector3.zero
                  RootPart.CFrame = safeCFrame
                  task.wait(0.05)
                  
                  fireproximityprompt(prompt)
                  
                  VirtualInputManager:SendKeyEvent(true, "E", false, game)
                  task.wait(0.2)
                  VirtualInputManager:SendKeyEvent(false, "E", false, game)
               end
               
               task.wait(0.15)
            end
         end
      end
   end
end)
