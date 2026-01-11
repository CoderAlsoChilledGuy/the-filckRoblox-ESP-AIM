local KEYS_URL = "https://raw.githubusercontent.com/CoderAlsoChilledGuy/the-filckRoblox-ESP-AIM/refs/heads/main/keys.lua"
local SCRIPT_URL = "https://raw.githubusercontent.com/CoderAlsoChilledGuy/the-filckRoblox-ESP-AIM/refs/heads/main/esp_aim.lua"
local KEY_LINK = "https://work.ink/2bQt/s"

-- Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "KeySystem"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,320,0,200)
frame.Position = UDim2.new(0.5,-160,0.5,-100)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Position = UDim2.new(0,0,0,0)
title.Text = "Key System"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

-- TextBox
local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(1,-20,0,35)
box.Position = UDim2.new(0,10,0,40)
box.PlaceholderText = "Enter your key here"
box.Text = ""
box.TextColor3 = Color3.new(1,1,1)
box.BackgroundColor3 = Color3.fromRGB(50,50,50)
box.ClearTextOnFocus = false
box.Font = Enum.Font.SourceSans
box.TextSize = 16

-- Check Key Button
local btnCheck = Instance.new("TextButton", frame)
btnCheck.Size = UDim2.new(1,-20,0,35)
btnCheck.Position = UDim2.new(0,10,0,85)
btnCheck.Text = "Check Key"
btnCheck.BackgroundColor3 = Color3.fromRGB(70,70,70)
btnCheck.TextColor3 = Color3.new(1,1,1)
btnCheck.Font = Enum.Font.SourceSansBold
btnCheck.TextSize = 16

-- Get Key Button
local btnGetKey = Instance.new("TextButton", frame)
btnGetKey.Size = UDim2.new(1,-20,0,35)
btnGetKey.Position = UDim2.new(0,10,0,130)
btnGetKey.Text = "Get Key (Copy Link)"
btnGetKey.BackgroundColor3 = Color3.fromRGB(50,90,50)
btnGetKey.TextColor3 = Color3.new(1,1,1)
btnGetKey.Font = Enum.Font.SourceSansBold
btnGetKey.TextSize = 16

-- Copy key link
btnGetKey.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(KEY_LINK)
		btnGetKey.Text = "Link Copied!"
		wait(1)
		btnGetKey.Text = "Get Key (Copy Link)"
	else
		btnGetKey.Text = "Clipboard not supported"
	end
end)

-- Key check function
local function checkKey(inputKey)
	local success, keys = pcall(function()
		return loadstring(game:HttpGet(KEYS_URL))()
	end)
	if not success or type(keys) ~= "table" then
		return false
	end

	for _,k in pairs(keys) do
		if k == inputKey then
			return true
		end
	end
	return false
end

-- Button logic
btnCheck.MouseButton1Click:Connect(function()
	if checkKey(box.Text) then
		gui:Destroy()
		loadstring(game:HttpGet(SCRIPT_URL))()
	else
		btnCheck.Text = "Invalid Key"
		wait(1)
		btnCheck.Text = "Check Key"
	end
end)
