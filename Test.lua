local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Window with K as toggle key
local Window = Rayfield:CreateWindow({
    Name = "SBR Hub",
    LoadingTitle = "SBR Hub",
    LoadingSubtitle = "Loading...",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SBRHub",
        FileName = "Config"
    },
    KeySystem = false,
    DisableKeyBindings = false,
    ToggleKey = Enum.KeyCode.K,
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
-- FARM TAB CONTENT (CHESTS) - FIXED COLLECTION
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

task.spawn(function()
   while task.wait(0.1) do
      if not _G.AutoFarmChests then continue end
      
      local Character = LocalPlayer.Character
      if not Character or not Character:FindFirstChild("HumanoidRootPart") then continue end
      
      local RootPart = Character.HumanoidRootPart
      local SpawnedChests = workspace:FindFirstChild("Chests") and workspace.Chests:FindFirstChild("SpawnedChests")
      
      if not SpawnedChests then continue end
      
      -- Collect all chest models
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
               -- Stop velocity
               RootPart.AssemblyLinearVelocity = Vector3.zero
               RootPart.AssemblyAngularVelocity = Vector3.zero
               
               -- Teleport EXACTLY to the part (no offset, no height)
               RootPart.CFrame = targetPart.CFrame
               
               -- IMPORTANT: Wait for server to register your position
               task.wait(0.25)
               
               -- Find and fire the prompt
               local prompt = model:FindFirstChildWhichIsA("ProximityPrompt", true)
               if prompt then
                  -- Fire with actual hold duration (not 0)
                  -- This is more reliable and less likely to be flagged
                  fireproximityprompt(prompt)
                  
                  -- Extra: Also try pressing E as backup
                  VirtualInputManager:SendKeyEvent(true, "E", false, game)
                  task.wait(0.2)
                  VirtualInputManager:SendKeyEvent(false, "E", false, game)
               end
               
               -- Wait a tiny bit for collection to process
               task.wait(0.15)
            end
         end
      end
   end
end)
