local KEYS_URL   = "https://raw.githubusercontent.com/CoderAlsoChilledGuy/the-filckRoblox-ESP-AIM/refs/heads/main/keys.lua"
local SCRIPT_URL = "https://raw.githubusercontent.com/CoderAlsoChilledGuy/the-filckRoblox-ESP-AIM/refs/heads/main/esp_aim.lua"

local WORKINK_LINK     = "https://work.ink/2bQt/s"
local LINKVERTISE_LINK = "https://link-target.net/1313083/ULj3vbxvdZ2I"

-- Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "KeySystem"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,340,0,260)
frame.Position = UDim2.new(0.5,-170,0.5,-130)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,32)
title.Position = UDim2.new(0,0,0,0)
title.Text = "Key System"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

-- TextBox
local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(1,-20,0,36)
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
btnCheck.Size = UDim2.new(1,-20,0,36)
btnCheck.Position = UDim2.new(0,10,0,85)
btnCheck.Text = "Check Key"
btnCheck.BackgroundColor3 = Color3.fromRGB(70,70,70)
btnCheck.TextColor3 = Color3.new(1,1,1)
btnCheck.Font = Enum.Font.SourceSansBold
btnCheck.TextSize = 16

-- Get Key (Work.ink)
local btnWorkInk = Instance.new("TextButton", frame)
btnWorkInk.Size = UDim2.new(1,-20,0,36)
btnWorkInk.Position = UDim2.new(0,10,0,130)
btnWorkInk.Text = "Get Key (Work.ink)"
btnWorkInk.BackgroundColor3 = Color3.fromRGB(60,120,60)
btnWorkInk.TextColor3 = Color3.new(1,1,1)
btnWorkInk.Font = Enum.Font.SourceSansBold
btnWorkInk.TextSize = 16

-- Get Key (Linkvertise)
local btnLinkvertise = Instance.new("TextButton", frame)
btnLinkvertise.Size = UDim2.new(1,-20,0,36)
btnLinkvertise.Position = UDim2.new(0,10,0,175)
btnLinkvertise.Text = "Get Key (Linkvertise)"
btnLinkvertise.BackgroundColor3 = Color3.fromRGB(60,60,120)
btnLinkvertise.TextColor3 = Color3.new(1,1,1)
btnLinkvertise.Font = Enum.Font.SourceSansBold
btnLinkvertise.TextSize = 16

-- Footer hint
local hint = Instance.new("TextLabel", frame)
hint.Size = UDim2.new(1,-20,0,20)
hint.Position = UDim2.new(0,10,0,220)
hint.Text = "Choose one link to get your key"
hint.TextColor3 = Color3.fromRGB(200,200,200)
hint.BackgroundTransparency = 1
hint.Font = Enum.Font.SourceSans
hint.TextSize = 14

-- Copy functions
local function copyLink(link, button, originalText)
	if setclipboard then
		setclipboard(link)
		button.Text = "Link Copied!"
		task.wait(1)
		button.Text = originalText
	else
		button.Text = "Clipboard not supported"
	end
end

btnWorkInk.MouseButton1Click:Connect(function()
	copyLink(WORKINK_LINK, btnWorkInk, "Get Key (Work.ink)")
end)

btnLinkvertise.MouseButton1Click:Connect(function()
	copyLink(LINKVERTISE_LINK, btnLinkvertise, "Get Key (Linkvertise)")
end)

-- Key check
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

-- Check button logic
btnCheck.MouseButton1Click:Connect(function()
	if checkKey(box.Text) then
		gui:Destroy()
		loadstring(game:HttpGet(SCRIPT_URL))()
	else
		btnCheck.Text = "Invalid Key"
		task.wait(1)
		btnCheck.Text = "Check Key"
	end
end)
