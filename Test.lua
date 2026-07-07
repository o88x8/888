local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Table to link our Dropdown display name to the actual part in the game
local CorpseMap = {}

-- Create Tabs (Replace "Window" with your Rayfield Window variable if it's different)
local SBRTab = Window:CreateTab("SBR", 4483362458) 
local FarmTab = Window:CreateTab("Farm", 4483362458)

-- =========================================================
-- SBR TAB CONTENT
-- =========================================================

-- 1. Speed Slider
local SpeedSlider = SBRTab:CreateSlider({
   Name = "Tween Speed",
   Range = {50, 500},
   Increment = 10,
   Suffix = "Studs/s",
   CurrentValue = 150,
   Flag = "TweenSpeed",
})

-- 2. Dropdown (Now will show the Stage!)
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

-- 3. Button to Refresh the List (Reads Attributes!)
local RefreshButton = SBRTab:CreateButton({
   Name = "Refresh Corpse List",
   Callback = function()
      local CorpseFolder = workspace:FindFirstChild("CorpseParts") and workspace.CorpseParts:FindFirstChild("SpawnedCorpseParts")
      
      if not CorpseFolder then
         Rayfield:Notify({Title = "Error", Content = "Folder not found!", Duration = 3})
         return
      end

      local DisplayNames = {}
      CorpseMap = {} -- Reset the map

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

-- 4. The Tween Button
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

-- Background loop for Chest Farming
task.spawn(function()
   while true do
      if _G.AutoFarmChests then
         local Character = LocalPlayer.Character
         if Character and Character:FindFirstChild("HumanoidRootPart") then
            local RootPart = Character.HumanoidRootPart
            local SpawnedChests = workspace:FindFirstChild("Chests") and workspace.Chests:FindFirstChild("SpawnedChests")
            
            if SpawnedChests then
               -- Loop through all folders inside SpawnedChests
               for _, folder in pairs(SpawnedChests:GetChildren()) do
                  if not _G.AutoFarmChests then break end -- Stop immediately if toggled off
                  
                  if folder:IsA("Folder") then
                     -- Loop through all models inside the folder
                     for _, model in pairs(folder:GetChildren()) do
                        if not _G.AutoFarmChests then break end
                        
                        if model:IsA("Model") then
                           -- Find the WoodTop MeshPart
                           local woodTop = model:FindFirstChild("WoodTop", true)
                           
                           if woodTop and woodTop:IsA("MeshPart") then
                              -- Stop momentum so we don't get flung
                              RootPart.AssemblyLinearVelocity = Vector3.zero
                              RootPart.AssemblyAngularVelocity = Vector3.zero
                              
                              -- Instant TP to the WoodTop position
                              RootPart.CFrame = woodTop.CFrame
                              
                              -- Look for a ProximityPrompt to fire (fallback if game uses it)
                              local prompt = model:FindFirstChildWhichIsA("ProximityPrompt", true) or woodTop:FindFirstChildWhichIsA("ProximityPrompt", true)
                              if prompt then
                                 fireproximityprompt(prompt)
                              end
                              
                              -- Simulate holding 'E' for 1 second
                              VirtualInputManager:SendKeyEvent(true, "E", false, game)
                              task.wait(1)
                              VirtualInputManager:SendKeyEvent(false, "E", false, game)
                              
                              -- Wait a tiny bit before teleporting to the next chest
                              task.wait(0.2)
                           end
                        end
                     end
                  end
               end
            end
         end
         task.wait(0.5) -- Short delay before re-scanning the folder for new chests
      else
         task.wait(0.5)
      end
   end
end)
