local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- SETTINGS
local AIM_DISTANCE = 100
local AIM_RADIUS = 150
local AIM_STRENGTH = 0.1

local FRIEND_COLOR = Color3.fromRGB(0,255,0)
local ENEMY_COLOR = Color3.fromRGB(255,0,0)

local espEnabled = true
local aimEnabled = true
local aiming = false

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ESP_AIM_GUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,250,0,250)
frame.Position = UDim2.new(0,20,0,200)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- BUTTON / INPUT CREATION
local function createButton(text,posY)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1,-20,0,30)
	btn.Position = UDim2.new(0,10,0,posY)
	btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 16
	btn.Text = text
	return btn
end

local function createTextBox(labelText,posY,defaultValue)
	local lbl = Instance.new("TextLabel", frame)
	lbl.Size = UDim2.new(0,120,0,20)
	lbl.Position = UDim2.new(0,10,0,posY)
	lbl.Text = labelText
	lbl.TextColor3 = Color3.new(1,1,1)
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.SourceSansBold
	lbl.TextSize = 14

	local box = Instance.new("TextBox", frame)
	box.Size = UDim2.new(0,100,0,20)
	box.Position = UDim2.new(0,130,0,posY)
	box.Text = tostring(defaultValue)
	box.ClearTextOnFocus = false
	box.TextColor3 = Color3.new(1,1,1)
	box.BackgroundColor3 = Color3.fromRGB(60,60,60)
	box.Font = Enum.Font.SourceSansBold
	box.TextSize = 14
	return box
end

-- Buttons
local espBtn = createButton("ESP: ON",10)
local aimBtn = createButton("AIM: ON",50)
espBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	espBtn.Text = "ESP: "..(espEnabled and "ON" or "OFF")
end)
aimBtn.MouseButton1Click:Connect(function()
	aimEnabled = not aimEnabled
	aimBtn.Text = "AIM: "..(aimEnabled and "ON" or "OFF")
end)

-- Aim Settings
local distanceBox = createTextBox("Aim Distance:",90,AIM_DISTANCE)
local radiusBox   = createTextBox("Aim Radius:",120,AIM_RADIUS)
local strengthBox = createTextBox("Aim Strength:",150,AIM_STRENGTH)

local function updateParams()
	local d = tonumber(distanceBox.Text)
	if d then AIM_DISTANCE = d end
	local r = tonumber(radiusBox.Text)
	if r then AIM_RADIUS = r end
	local s = tonumber(strengthBox.Text)
	if s then AIM_STRENGTH = s end
end
distanceBox.FocusLost:Connect(updateParams)
radiusBox.FocusLost:Connect(updateParams)
strengthBox.FocusLost:Connect(updateParams)

-- AIM RADIUS CIRCLE
local aimCircle = Instance.new("Frame", gui)
aimCircle.Name = "AimCircle"
aimCircle.AnchorPoint = Vector2.new(0.5,0.5)
aimCircle.BackgroundTransparency = 1
aimCircle.BorderSizePixel = 0
aimCircle.ZIndex = 10
local stroke = Instance.new("UIStroke", aimCircle)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(255,0,0)
stroke.Transparency = 0.5

-- ESP FUNCTION
local function addESP(plr)
	if plr == player then return end
	local function setupChar(char)
		local head = char:WaitForChild("Head",5)
		if not head then return end

		local hl = Instance.new("Highlight", char)
		hl.FillTransparency = 1

		local bill = Instance.new("BillboardGui", head)
		bill.Size = UDim2.new(0,200,0,40)
		bill.StudsOffset = Vector3.new(0,2,0)
		bill.AlwaysOnTop = true

		local txt = Instance.new("TextLabel", bill)
		txt.Size = UDim2.new(1,0,1,0)
		txt.BackgroundTransparency = 1
		txt.TextStrokeTransparency = 0
		txt.Font = Enum.Font.SourceSansBold
		txt.TextSize = 14

		RunService.RenderStepped:Connect(function()
			if not char.Parent then return end
			hl.Enabled = espEnabled
			bill.Enabled = espEnabled
			local root = char:FindFirstChild("HumanoidRootPart")
			local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			if root and myRoot then
				local dist = math.floor((root.Position - myRoot.Position).Magnitude)
				txt.Text = plr.Name.." ["..dist.."m]"
				local color = (plr.Team == player.Team) and FRIEND_COLOR or ENEMY_COLOR
				hl.OutlineColor = color
				txt.TextColor3 = color
			end
		end)
	end
	if plr.Character then setupChar(plr.Character) end
	plr.CharacterAdded:Connect(setupChar)
end

-- Add ESP for all current and new players
for _,p in pairs(Players:GetPlayers()) do addESP(p) end
Players.PlayerAdded:Connect(addESP)

-- AIM ASSIST FUNCTION
UserInputService.InputBegan:Connect(function(input,gp)
	if gp then return end
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		aiming = true
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		aiming = false
	end
end)

local function getTarget()
	local best, shortest = nil, AIM_RADIUS
	for _,plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local root = plr.Character.HumanoidRootPart
			local d3 = (root.Position - camera.CFrame.Position).Magnitude
			if d3 <= AIM_DISTANCE then
				local pos,onScreen = camera:WorldToViewportPoint(root.Position)
				if onScreen then
					local center = camera.ViewportSize/2
					local d2 = (Vector2.new(pos.X,pos.Y)-center).Magnitude
					if d2 < shortest then
						shortest = d2
						best = root
					end
				end
			end
		end
	end
	return best
end

-- RENDER STEPPED LOOP
RunService.RenderStepped:Connect(function()
	-- AIM ASSIST
	if aimEnabled and aiming then
		local target = getTarget()
		if target then
			local camPos = camera.CFrame.Position
			local targetPos = target.Position + Vector3.new(0,1.5,0)
			camera.CFrame = camera.CFrame:Lerp(CFrame.new(camPos,targetPos), AIM_STRENGTH)
		end
	end

	
end)
