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
-- FARM TAB CONTENT (CHESTS)
-- =========================================================

-- TEST BUTTON - Click this and tell me what it says
FarmTab:CreateButton({
   Name = "🧪 TEST: Try TP to First Chest",
   Callback = function()
      local Character = LocalPlayer.Character
      if not Character or not Character:FindFirstChild("HumanoidRootPart") then
         Rayfield:Notify({Title = "Error", Content = "No character!", Duration = 3})
         return
      end
      
      local SpawnedChests = workspace:FindFirstChild("Chests") and workspace.Chests:FindFirstChild("SpawnedChests")
      
      if not SpawnedChests then
         Rayfield:Notify({Title = "Error", Content = "SpawnedChests not found!", Duration = 3})
         print("❌ workspace.Chests.SpawnedChests does NOT exist")
         return
      end
      
      local children = SpawnedChests:GetChildren()
      print("SpawnedChests has " .. #children .. " children")
      
      if #children == 0 then
         Rayfield:Notify({Title = "Empty", Content = "SpawnedChests has 0 children! No chests spawned?", Duration = 5})
         print("❌ SpawnedChests is EMPTY")
         return
      end
      
      -- Find first valid model
      for i, child in pairs(children) do
         print("Child " .. i .. ": " .. child.Name .. " (" .. child.ClassName .. ")")
         
         if child:IsA("Model") then
            print("  Is Model: YES")
            
            -- Check for WoodTop
            local woodTop = child:FindFirstChild("WoodTop", true)
            if woodTop then
               print("  WoodTop found: " .. woodTop.Name .. " at " .. tostring(woodTop.Position))
            else
               print("  WoodTop: NOT FOUND")
            end
            
            -- Check PrimaryPart
            print("  PrimaryPart: " .. tostring(child.PrimaryPart))
            
            -- Find ANY BasePart/MeshPart
            local anyPart = child:FindFirstChildWhichIsA("BasePart") or child:FindFirstChildWhichIsA("MeshPart")
            print("  First BasePart/MeshPart: " .. tostring(anyPart))
            
            -- List all parts
            print("  All parts inside:")
            for _, desc in pairs(child:GetDescendants()) do
               if desc:IsA("BasePart") or desc:IsA("MeshPart") then
                  print("    - " .. desc.Name .. " (" .. desc.ClassName .. ")")
               end
            end
            
            -- Try to teleport
            local targetPart = woodTop or child.PrimaryPart or anyPart
            
            if targetPart then
               print("  ✅ Attempting TP to: " .. targetPart.Name)
               Character.HumanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
               Rayfield:Notify({Title = "Test", Content = "TP'd to " .. child.Name .. "! Check F9 for details.", Duration = 5})
            else
               print("  ❌ No valid part to TP to!")
               Rayfield:Notify({Title = "Failed", Content = "No valid part found! Check F9.", Duration = 5})
            end
            
            break -- Only test first one
         else
            print("  Is Model: NO")
         end
      end
   end,
})

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
   while true do
      if _G.AutoFarmChests then
         local Character = LocalPlayer.Character
         if Character and Character:FindFirstChild("HumanoidRootPart") then
            local RootPart = Character.HumanoidRootPart
            local SpawnedChests = workspace:FindFirstChild("Chests") and workspace.Chests:FindFirstChild("SpawnedChests")
            
            if not SpawnedChests then
               print("[Farm] SpawnedChests not found, stopping.")
               Rayfield:Notify({Title = "Error", Content = "SpawnedChests not found!", Duration = 3})
               _G.AutoFarmChests = false
               task.wait(1)
            else
               local chestCount = #SpawnedChests:GetChildren()
               print("[Farm] Found " .. chestCount .. " chests")
               
               if chestCount == 0 then
                  print("[Farm] No chests spawned, waiting...")
                  task.wait(2)
               else
                  for _, model in pairs(SpawnedChests:GetChildren()) do
                     if not _G.AutoFarmChests then break end
                     
                     print("[Farm] Checking: " .. model.Name)
                     
                     if model:IsA("Model") then
                        local targetPart = model:FindFirstChild("WoodTop", true)
                        
                        if not targetPart then
                           targetPart = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart") or model:FindFirstChildWhichIsA("MeshPart")
                        end
                        
                        if targetPart then
                           print("[Farm] TPing to " .. targetPart.Name)
                           RootPart.AssemblyLinearVelocity = Vector3.zero
                           RootPart.AssemblyAngularVelocity = Vector3.zero
                           RootPart.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
                           
                           local prompt = model:FindFirstChildWhichIsA("ProximityPrompt", true)
                           if prompt then
                              print("[Farm] Found prompt, firing it")
                              fireproximityprompt(prompt)
                           end
                           
                           VirtualInputManager:SendKeyEvent(true, "E", false, game)
                           task.wait(1)
                           VirtualInputManager:SendKeyEvent(false, "E", false, game)
                           task.wait(0.3)
                        else
                           print("[Farm] No valid part found for " .. model.Name)
                        end
                     end
                  end
               end
            end
         end
         task.wait(0.5)
      else
         task.wait(0.5)
      end
   end
end)
