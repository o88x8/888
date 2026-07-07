-- 1. Load the Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 2. Create the Main Window
local Window = Rayfield:CreateWindow({
   Name = "My Awesome Hub",
   LoadingTitle = "My Hub",
   LoadingSubtitle = "by YourName",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "MyHubConfigs", -- Folder where your settings save
      FileName = "MyHubConfig"
   },
   Discord = {
      Enabled = false, -- Set to true if you have a Discord server
      Invite = "noinvitelink", 
      GuildId = "noid",
      ChannelId = "noid"
   },
   KeySystem = false, -- Set to true if you want a key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      Key = {"Hello"}
   }
})

-- 3. Create a Tab
local MainTab = Window:CreateTab("Main", 4483362458) -- The second number is the icon ID (you can change it)

-- 4. Create UI Elements

-- NOTIFICATION
Rayfield:Notify({
   Title = "Welcome!",
   Content = "Your script has successfully loaded.",
   Duration = 5,
   Image = 4483362458,
})

-- BUTTON
local MyButton = MainTab:CreateButton({
   Name = "Kill All (Example)",
   Callback = function()
      -- Put your code here that runs when the button is clicked
      Rayfield:Notify({
         Title = "Button Clicked",
         Content = "You pressed the example button!",
         Duration = 3,
         Image = 4483362458,
      })
   end,
})

-- TOGGLE
local SpeedToggle = MainTab:CreateToggle({
   Name = "Enable Fast Speed",
   CurrentValue = false,
   Flag = "SpeedToggle", -- A unique identifier for saving configs
   Callback = function(Value)
      -- 'Value' is true or false based on the toggle state
      if Value then
         print("Speed enabled!")
      else
         print("Speed disabled!")
      end
   end,
})

-- SLIDER
local WalkSpeedSlider = MainTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 200},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "WalkSpeedSlider",
   Callback = function(Value)
      -- 'Value' is the current number on the slider
      print("WalkSpeed set to: " .. tostring(Value))
   end,
})

-- DROPDOWN
local MyDropdown = MainTab:CreateDropdown({
   Name = "Select Player",
   Options = {"Player1", "Player2", "Player3"},
   CurrentOption = {"Player1"},
   MultipleOptions = false, -- True if you want to select multiple things at once
   Flag = "PlayerDropdown",
   Callback = function(Value)
      -- Value is a table of selected options
      print("Selected: " .. Value[1])
   end,
})

-- 5. Optional: Create a second tab for organization
local MiscTab = Window:CreateTab("Misc", 4483362458)

local DestroyUI = MiscTab:CreateButton({
   Name = "Destroy UI",
   Callback = function()
      Rayfield:Destroy()
   end,
})
