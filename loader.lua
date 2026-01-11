local KEYS_URL = "https://raw.githubusercontent.com/CoderAlsoChilledGuy/the-filckRoblox-ESP-AIM/refs/heads/main/keys.lua"
local SCRIPT_URL = "https://raw.githubusercontent.com/CoderAlsoChilledGuy/the-filckRoblox-ESP-AIM/refs/heads/main/esp_aim.lua"

-- Key input GUI
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "KeySystem"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,300,0,150)
frame.Position = UDim2.new(0.5,-150,0.5,-75)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(1,-20,0,40)
box.Position = UDim2.new(0,10,0,20)
box.PlaceholderText = "KEY daxil et"
box.Text = ""
box.TextColor3 = Color3.new(1,1,1)
box.BackgroundColor3 = Color3.fromRGB(50,50,50)
box.ClearTextOnFocus = false

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(1,-20,0,40)
btn.Position = UDim2.new(0,10,0,80)
btn.Text = "YOXLA"
btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
btn.TextColor3 = Color3.new(1,1,1)

-- Key yoxlama
local function checkKey(inputKey)
	local success, keys = pcall(function()
		return loadstring(game:HttpGet(KEYS_URL))()
	end)
	if not success then return false end

	for _,k in pairs(keys) do
		if k == inputKey then
			return true
		end
	end
	return false
end

btn.MouseButton1Click:Connect(function()
	if checkKey(box.Text) then
		gui:Destroy()
		loadstring(game:HttpGet(SCRIPT_URL))()
	else
		btn.Text = "YANLIŞ KEY"
		wait(1)
		btn.Text = "YOXLA"
	end
end)
