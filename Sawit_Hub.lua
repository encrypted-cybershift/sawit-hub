-- OBFUSCATED BY SAWIT_HUB ( UPDATE 1.1.4 )
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ========================= --
-- GLOBAL NOTIFICATION
-- ========================= --

local function notify(title, content)
	Rayfield:Notify({
		Title = title,
		Content = content,
		Duration = 2,
		Image = 4483362458,
	})
end

-- AUTO TOGGLE NOTIFY (NO NEED TO EDIT ALL TOGGLES)
local function createToggle(tab, data)
	return tab:CreateToggle({
		Name = data.Name,
		CurrentValue = data.CurrentValue or false,
		Callback = function(v)
			if data.Callback then
				data.Callback(v)
			end

			notify(data.Name, v and "Enabled" or "Disabled")
		end,
	})
end

-- ========================= --
-- SERVICES (FIXED DUPLICATES)
-- ========================= --

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer


local vehicleModifierEnabled = false

local topSpeedValue = 150

local horsepowerValue = 80
local horsepowerEnabled = false

local brakeForceValue = 120
local brakeEnabled = false

local function getVehicleSeat()

	local char = player.Character
	if not char then return end

	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	local seat = hum.SeatPart

	if seat and seat:IsA("VehicleSeat") then
		return seat
	end

end

-- ================================= --
-- 		  SERVER HOP VARIABLE
-- ================================= --

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")


-- ================================= --
-- Walkspeed, Hitbox, Fly Variables
-- ================================= --


local walkEnabled = false
local walkValue = 16


local hitboxEnabled = false
local hitboxSize = 50
local hitboxColor = BrickColor.new("Really blue")


local flying = false
local flySpeed = 50
local flyConnection
local flyKey = Enum.KeyCode.F



-------------------------------------
-- FAKE LAG VARIABLES
-------------------------------------

local fakeLagEnabled = false
local fakeLagDelay = 0.3 -- how long to freeze
local fakeLagIntensity = 1 -- how far snap feels

local lastPosition = nil

task.spawn(function()
	while true do
		if fakeLagEnabled then
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				local hrp = char.HumanoidRootPart
				
				-- SAVE POSITION
				lastPosition = hrp.CFrame
				
				-- FREEZE
				hrp.Anchored = true
				task.wait(fakeLagDelay)
				
				-- UNFREEZE + SNAP
				hrp.Anchored = false
				
				if lastPosition then
					hrp.CFrame = lastPosition * CFrame.new(0,0,-fakeLagIntensity)
				end
			end
		end
		
		task.wait(0.05)
	end
end)



-- ========================= --
-- Main Window
-- ========================= --


local Window = Rayfield:CreateWindow({
   Name = "Sawit Hub",
   Icon = 97357638540694,
   LoadingTitle = "Loading Sawit Hub...",
   LoadingSubtitle = "by {encrypted}",
   ShowText = "Sawit",
   Theme = getgenv().SelectedTheme or "DarkBlue",
   ToggleUIKeybind = "K",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = true,

   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "Sawit Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "Qh8HhBjnhh", -- The Discord invite code, do not include Discord.gg/. E.g. Discord.gg/ ABCD would be ABCD
      RememberJoins = false, -- Set this to false to make them join the Discord every time they load it up
   },
   
   
   KeySystem = true,
   KeySettings = {
      Title = "Sawit Hub Key System",
      Subtitle = "Join Discord Server to obtain the key",
      Note = "Join the Discord Server : discord.gg/Qh8HhBjnhh",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"beta", "1"}
   }
})


-- ========================= --
-- T A B S
-- ========================= --




local MainTab = Window:CreateTab("Player Tools", 128138526770905)
local CombatTab = Window:CreateTab("Combat Tools", 137069456808295)
local VehicleTab = Window:CreateTab("Vehicle Tools", 128389681846305)
local TeleportTab = Window:CreateTab("Teleport & View Tools", 96549740543176)
local TrollTab = Window:CreateTab("Troll Tools", 96010552692244)
local MiscTab = Window:CreateTab("Miscellaneous Tools", 75479199231887)
local ThemeTab = Window:CreateTab("Theme Customization", 138779054264019)




-- ========================= --
-- WalkSpeed Controls
-- ========================= --


local function notify(title, content)
	Rayfield:Notify({
		Title = title,
		Content = content,
		Duration = 2,
		Image = 4483362458,
	})
end


local walkToggle = false
local walkActive = false
local walkValue = 16
local walkKey = Enum.KeyCode.Z

local jumpToggle = false
local jumpActive = false
local jumpValue = 50
local jumpKey = Enum.KeyCode.X

local flyToggle = false
local flyActive = false
local flySpeed = 50
local flyKey = Enum.KeyCode.F
local flyConnection

local bv
local bg
local animateScript


-- ========================= --
-- JumpPower Controls
-- ========================= --

local function applyMovement()
	local char = player.Character
	if not char then return end

	local hum = char:FindFirstChild("Humanoid")
	if not hum then return end

	if walkToggle and walkActive then
		hum.WalkSpeed = walkValue
	else
		hum.WalkSpeed = 16
	end

	hum.UseJumpPower = true
	if jumpToggle and jumpActive then
		hum.JumpPower = jumpValue
	else
		hum.JumpPower = 50
	end
end

player.CharacterAdded:Connect(function()
	task.wait(1)
	applyMovement()
end)

-- ========================= --
-- FLY FUNCTIONS
-- ========================= --

local function stopAnimations(hum)
	local animator = hum:FindFirstChildOfClass("Animator")
	if animator then
		for _,track in pairs(animator:GetPlayingAnimationTracks()) do
			track:Stop(0)
		end
	end
end

local function startFly()
	
	local char = player.Character
	if not char then return end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChild("Humanoid")

	if not hrp or not hum then return end

	animateScript = char:FindFirstChild("Animate")
	if animateScript then
		animateScript.Disabled = true
	end

	stopAnimations(hum)

	hum.PlatformStand = true
	hum.AutoRotate = false
	hum:ChangeState(Enum.HumanoidStateType.Freefall)

	bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(9e9,9e9,9e9)
	bv.Parent = hrp

	bg = Instance.new("BodyGyro")
	bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
	bg.P = 9000
	bg.Parent = hrp

	flyConnection = RunService.RenderStepped:Connect(function()
		local cam = workspace.CurrentCamera
		local moveDir = Vector3.zero

		bg.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.CFrame.LookVector)

		if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir += cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir -= cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir += cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0,1,0) end
		if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir -= Vector3.new(0,1,0) end

		if moveDir.Magnitude > 0 then
			bv.Velocity = moveDir.Unit * flySpeed
		else
			bv.Velocity = Vector3.zero
		end
	end)
end

local function stopFly()
	local char = player.Character
	if not char then return end

	local hum = char:FindFirstChild("Humanoid")

	if hum then
		hum.PlatformStand = false
		hum.AutoRotate = true
		hum:ChangeState(Enum.HumanoidStateType.Running)
		task.wait(0.1)
		hum:ChangeState(Enum.HumanoidStateType.GettingUp)
	end

	if animateScript then
		animateScript.Disabled = false
	end

	if flyConnection then
		flyConnection:Disconnect()
		flyConnection = nil
	end

	if bv then
		bv:Destroy()
		bv = nil
	end

	if bg then
		bg:Destroy()
		bg = nil
	end
end


-- ========================= --
-- WALK, JUMP, FLY KEYBINDS
-- ========================= --

UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

	if input.KeyCode == walkKey and walkToggle then
		walkActive = not walkActive
		applyMovement()

		if walkActive then
			notify("WalkSpeed Enabled", "WalkSpeed activated")
		else
			notify("WalkSpeed Disabled", "WalkSpeed disabled")
		end
	end

	if input.KeyCode == jumpKey and jumpToggle then
		jumpActive = not jumpActive
		applyMovement()

		if jumpActive then
			notify("Jump Enabled", "Jump Power activated")
		else
			notify("Jump Disabled", "Jump Power disabled")
		end
	end

	if input.KeyCode == flyKey and flyToggle then
		flyActive = not flyActive

		if flyActive then
			startFly()
			notify("Fly Enabled", "Fly system activated")
		else
			stopFly()
			notify("Fly Disabled", "Fly system deactivated")
		end
	end
end)

-- ========================= --
-- WALK SECTION
-- ========================= --

MainTab:CreateSection("WalkSpeed Controls")

MainTab:CreateToggle({
	Name = "Enable WalkSpeed",
	CurrentValue = false,
	Callback = function(Value)
		walkToggle = Value
		if not walkToggle then walkActive = false end
		applyMovement()
	end,
})

MainTab:CreateSlider({
	Name = "WalkSpeed",
	Range = {16,1000},
	Increment = 1,
	Suffix = "Speed",
	CurrentValue = 16,
	Callback = function(Value)
		walkValue = Value
		applyMovement()
	end,
})

MainTab:CreateDropdown({
	Name = "WalkSpeed Key",
	Options = {"Z","X","C","V","B","N"},
	CurrentOption = {"Z"},
	MultipleOptions = false,
	Callback = function(Option)
		walkKey = Enum.KeyCode[Option[1]]
	end,
})

-- ========================= --
-- JUMP SECTION
-- ========================= --

MainTab:CreateSection("Jump Power Controls")

MainTab:CreateToggle({
	Name = "Enable Jump Power",
	CurrentValue = false,
	Callback = function(Value)
		jumpToggle = Value
		if not jumpToggle then jumpActive = false end
		applyMovement()
	end,
})

MainTab:CreateSlider({
	Name = "Jump Power",
	Range = {50,500},
	Increment = 5,
	Suffix = "Power",
	CurrentValue = 50,
	Callback = function(Value)
		jumpValue = Value
		applyMovement()
	end,
})

MainTab:CreateDropdown({
	Name = "Jump Key",
	Options = {"X","Z","C","V","B","N"},
	CurrentOption = {"X"},
	MultipleOptions = false,
	Callback = function(Option)
		jumpKey = Enum.KeyCode[Option[1]]
	end,
})

-- ========================= --
-- FLY SECTION
-- ========================= --

MainTab:CreateSection("Fly Controls")

MainTab:CreateToggle({
	Name = "Enable Fly System",
	CurrentValue = false,
	Callback = function(Value)
		flyToggle = Value
		if not flyToggle then
			flyActive = false
			stopFly()
		end
	end,
})

MainTab:CreateSlider({
	Name = "Fly Speed",
	Range = {10,200},
	Increment = 5,
	Suffix = "Speed",
	CurrentValue = 50,
	Callback = function(Value)
		flySpeed = Value
	end,
})

MainTab:CreateDropdown({
	Name = "Fly Key",
	Options = {"F","E","R","Q","T","G","V","C","X","Z"},
	CurrentOption = {"F"},
	MultipleOptions = false,
	Callback = function(Option)
		flyKey = Enum.KeyCode[Option[1]]
	end,
})


local function isSameTeam(localPlayer, targetPlayer)
	if not localPlayer or not targetPlayer then return false end
	if localPlayer.Team == nil or targetPlayer.Team == nil then return false end
	return localPlayer.Team == targetPlayer.Team
end



-- ========================= --
-- NOCLIP
-- ========================= --

MainTab:CreateSection("Movement")

local noclipEnabled = false
local noclipConnection

local function setNoclip(state)
	noclipEnabled = state

	if noclipEnabled then
		noclipConnection = RunService.Stepped:Connect(function()
			local char = player.Character
			if char then
				for _, v in pairs(char:GetDescendants()) do
					if v:IsA("BasePart") then
						v.CanCollide = false
					end
				end
			end
		end)
	else
		if noclipConnection then
			noclipConnection:Disconnect()
			noclipConnection = nil
		end

		-- restore collision
		local char = player.Character
		if char then
			for _, v in pairs(char:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = true
				end
			end
		end
	end
end

---------------------------------------
-- TOGGLE
---------------------------------------

createToggle(MainTab, {
	Name = "NoClip (Walk Through Walls)",
	CurrentValue = false,
	Callback = function(v)
		setNoclip(v)
	end,
})



-- ========================= --
-- ESP (RAINBOW + BOX FULL)
-- ========================= --
--------------------------------------------------
-- ESP SYSTEM (FINAL FIXED VERSION)
--------------------------------------------------

CombatTab:CreateSection("ESP Tools")

local highlightEnabled = false
local nameESPEnabled = false
local tracerEnabled = false
local boxESPEnabled = false
local rainbowESP = false
local showHealth = true
local teamCheck = false
local highlightColor = Color3.fromRGB(255,0,0)

local espObjects = {}

--------------------------------------------------
-- REMOVE ESP
--------------------------------------------------

local function removeESP(plr)
	if espObjects[plr] then
		for _, data in pairs(espObjects[plr]) do
			if data.obj then
				pcall(function() data.obj:Remove() end)
			end
		end
		espObjects[plr] = nil
	end

	if plr.Character and plr.Character:FindFirstChild("DevHighlight") then
		plr.Character.DevHighlight:Destroy()
	end
end

--------------------------------------------------
-- UPDATE ESP
--------------------------------------------------

local function updateESP()

	for _, plr in pairs(Players:GetPlayers()) do
		if plr == player then continue end

		removeESP(plr)

		if not (highlightEnabled or nameESPEnabled or tracerEnabled or boxESPEnabled) then
			continue
		end

		if teamCheck and player.Team and plr.Team and player.Team == plr.Team then
			continue
		end

		if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
			continue
		end

		local root = plr.Character.HumanoidRootPart

		local color = highlightColor
		if rainbowESP then
			local t = tick() % 5 / 5
			color = Color3.fromHSV(t,1,1)
		end

		--------------------------------------------------
		-- HIGHLIGHT
		--------------------------------------------------
		if highlightEnabled then
			local h = Instance.new("Highlight")
			h.Name = "DevHighlight"
			h.FillColor = color
			h.OutlineColor = color
			h.FillTransparency = 0.5
			h.Parent = plr.Character
		end

		espObjects[plr] = {}

		--------------------------------------------------
		-- NAME ESP
		--------------------------------------------------
		if nameESPEnabled then
			local success, t = pcall(function()
				return Drawing.new("Text")
			end)

			if success then
				t.Size = 14
				t.Center = true
				t.Outline = true
				t.Color = color
				table.insert(espObjects[plr], {type = "name", obj = t})
			end
		end

		--------------------------------------------------
		-- TRACER
		--------------------------------------------------
		if tracerEnabled then
			local success, l = pcall(function()
				return Drawing.new("Line")
			end)

			if success then
				l.Thickness = 1
				l.Color = color
				table.insert(espObjects[plr], {type = "tracer", obj = l})
			end
		end

		--------------------------------------------------
		-- BOX ESP
		--------------------------------------------------
		if boxESPEnabled then
			local success, b = pcall(function()
				return Drawing.new("Square")
			end)

			if success then
				b.Thickness = 1
				b.Color = color
				b.Filled = false
				table.insert(espObjects[plr], {type = "box", obj = b})
			end
		end
	end
end

--------------------------------------------------
-- RENDER LOOP
--------------------------------------------------

RunService.RenderStepped:Connect(function()

	for plr, objects in pairs(espObjects) do

		if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
			removeESP(plr)
			continue
		end

		local root = plr.Character.HumanoidRootPart
		local humanoid = plr.Character:FindFirstChild("Humanoid")

		local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(root.Position)

		local color = highlightColor
		if rainbowESP then
			local t = tick() % 5 / 5
			color = Color3.fromHSV(t,1,1)
		end

		for _, data in pairs(objects) do
			local obj = data.obj
			local typ = data.type

			-- NAME
			if typ == "name" then
				if onScreen then
					local text = plr.Name

					if showHealth and humanoid then
						text = text .. " ["..math.floor(humanoid.Health).."]"
					end

					obj.Text = text
					obj.Position = Vector2.new(pos.X, pos.Y - 25)
					obj.Color = color
					obj.Visible = true
				else
					obj.Visible = false
				end
			end

			-- TRACER
			if typ == "tracer" then
				if onScreen then
					obj.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y)
					obj.To = Vector2.new(pos.X, pos.Y)
					obj.Color = color
					obj.Visible = true
				else
					obj.Visible = false
				end
			end

			-- BOX
			if typ == "box" then
				if onScreen then
					local size = 2000 / pos.Z
					obj.Size = Vector2.new(size, size)
					obj.Position = Vector2.new(pos.X - size/2, pos.Y - size/2)
					obj.Color = color
					obj.Visible = true
				else
					obj.Visible = false
				end
			end
		end
	end
end)

--------------------------------------------------
-- INITIAL LOAD
--------------------------------------------------

task.spawn(function()
	task.wait(1)
	updateESP()
end)

--------------------------------------------------
-- PLAYER EVENTS
--------------------------------------------------

Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		task.wait(1)
		updateESP()
	end)
end)

--------------------------------------------------
-- TOGGLES
--------------------------------------------------

createToggle(CombatTab, {
	Name = "Highlight Players",
	CurrentValue = false,
	Callback = function(v)
		highlightEnabled = v
		updateESP()
	end,
})

createToggle(CombatTab, {
	Name = "Name ESP",
	CurrentValue = false,
	Callback = function(v)
		nameESPEnabled = v
		updateESP()
	end,
})

createToggle(CombatTab, {
	Name = "Tracer ESP",
	CurrentValue = false,
	Callback = function(v)
		tracerEnabled = v
		updateESP()
	end,
})

createToggle(CombatTab, {
	Name = "Box ESP",
	CurrentValue = false,
	Callback = function(v)
		boxESPEnabled = v
		updateESP()
	end,
})

createToggle(CombatTab, {
	Name = "Rainbow ESP",
	CurrentValue = false,
	Callback = function(v)
		rainbowESP = v
	end,
})

createToggle(CombatTab, {
	Name = "Show Health",
	CurrentValue = true,
	Callback = function(v)
		showHealth = v
	end,
})

createToggle(CombatTab, {
	Name = "Team Check",
	CurrentValue = false,
	Callback = function(v)
		teamCheck = v
		updateESP()
	end,
})

CombatTab:CreateColorPicker({
	Name = "ESP Color",
	Color = Color3.fromRGB(255,0,0),
	Callback = function(v)
		highlightColor = v
		updateESP()
	end,
})


-- ================================= --
-- HITBOX (ORIGINAL STYLE - FIXED)
-- ================================= --

CombatTab:CreateSection("Hitbox Modifier")

local hitboxEnabled = false
local hitboxSize = 50
local hitboxColor = BrickColor.new("Really blue")
local hitboxTeamCheck = false

---------------------------------------
-- APPLY
---------------------------------------

local function applyHitbox(plr)
	if plr == player then return end
	if not plr.Character then return end

	local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	-- TEAM CHECK
	if hitboxTeamCheck then
		if player.Team and plr.Team and player.Team == plr.Team then
			hrp.Size = Vector3.new(2,2,1)
			hrp.Transparency = 1
			hrp.Material = Enum.Material.Plastic
			return
		end
	end

	-- APPLY HITBOX
	hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
	hrp.Transparency = 0.7
	hrp.BrickColor = hitboxColor
	hrp.Material = Enum.Material.Neon
	hrp.CanCollide = false
end

---------------------------------------
-- RESET
---------------------------------------

local function resetHitbox(plr)
	if plr == player then return end
	if not plr.Character then return end

	local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	hrp.Size = Vector3.new(2,2,1)
	hrp.Transparency = 1
	hrp.Material = Enum.Material.Plastic
	hrp.CanCollide = true
end

---------------------------------------
-- LOOP (UNCHANGED STYLE)
---------------------------------------

task.spawn(function()
	while true do
		for _, plr in pairs(Players:GetPlayers()) do
			if hitboxEnabled then
				applyHitbox(plr)
			else
				resetHitbox(plr)
			end
		end
		task.wait(0.1)
	end
end)

---------------------------------------
-- UI (UNCHANGED STYLE)
---------------------------------------

createToggle(CombatTab, {
	Name = "Enable Hitbox",
	CurrentValue = false,
	Callback = function(Value)
		hitboxEnabled = Value
	end,
})

createToggle(CombatTab, {
	Name = "Team Check",
	CurrentValue = false,
	Callback = function(Value)
		hitboxTeamCheck = Value
	end,
})

CombatTab:CreateSlider({
	Name = "Hitbox Size",
	Range = {5,50},
	Increment = 1,
	CurrentValue = 20,
	Callback = function(Value)
		hitboxSize = Value
	end,
})

CombatTab:CreateColorPicker({
	Name = "Hitbox Color",
	Color = Color3.fromRGB(0,0,255),
	Callback = function(Value)
		hitboxColor = BrickColor.new(Value)
	end,
})



-- ================================= --
-- SILENT AIM
-- ================================= --

CombatTab:CreateSection("Aim Assist")

local aimEnabled = false
local aimFOV = 150
local aimSmoothness = 0.15
local aimHolding = false

---------------------------------------
-- FOV CIRCLE
---------------------------------------

local circle = Drawing.new("Circle")
circle.Radius = aimFOV
circle.Thickness = 2
circle.Filled = false
circle.Visible = false
circle.Color = Color3.fromRGB(255,255,255)

---------------------------------------
-- GET CLOSEST TARGET TO CROSSHAIR
---------------------------------------

local function getClosestTarget()
	local closest = nil
	local shortest = aimFOV

	local mousePos = Vector2.new(
		workspace.CurrentCamera.ViewportSize.X/2,
		workspace.CurrentCamera.ViewportSize.Y/2
	)

	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			
			local hrp = plr.Character.HumanoidRootPart
			local pos, visible = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)

			if visible then
				local dist = (Vector2.new(pos.X,pos.Y) - mousePos).Magnitude

				if dist < shortest then
					shortest = dist
					closest = plr
				end
			end
		end
	end

	return closest
end


-- ================================= --
-- ADVANCED KEYBIND SYSTEM (REAL DETECTOR)
-- ================================= --

local aimKey = Enum.KeyCode.E
local aimMouse = nil
local aimHolding = false

local waitingForBind = false

--------------------------------------------------
-- FORMAT NAME (MB1, MB2, KEY)
--------------------------------------------------

local function formatInput(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		return "MB1"
	elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
		return "MB2"
	elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
		return "MB3"
	elseif tostring(input.UserInputType):find("MouseButton") then
		return input.UserInputType.Name -- MB4 / MB5
	elseif input.KeyCode ~= Enum.KeyCode.Unknown then
		return input.KeyCode.Name
	end
	return "Unknown"
end

--------------------------------------------------
-- INPUT DETECTION (BINDING ONLY)
--------------------------------------------------

UIS.InputBegan:Connect(function(input, gp)
	if gp then return end

	-- BIND MODE
	if waitingForBind then
		waitingForBind = false

		-- MOUSE FIRST (IMPORTANT)
		if tostring(input.UserInputType):find("MouseButton") then
			aimMouse = input.UserInputType
			aimKey = nil

			notify("Aim Assist", "Bound to: " .. formatInput(input))
			return
		end

		-- KEYBOARD
		if input.KeyCode ~= Enum.KeyCode.Unknown then
			aimKey = input.KeyCode
			aimMouse = nil

			notify("Aim Assist", "Bound to: " .. formatInput(input))
			return
		end
	end
end)

--------------------------------------------------
-- HOLD DETECTION (SUPER RELIABLE)
--------------------------------------------------

RunService.RenderStepped:Connect(function()

	-- MOUSE (works for MB1–MB5)
	if aimMouse then
		aimHolding = UIS:IsMouseButtonPressed(aimMouse)
	end

	-- KEYBOARD
	if aimKey then
		aimHolding = UIS:IsKeyDown(aimKey)
	end

end)

--------------------------------------------------
-- KEYBIND BUTTON
--------------------------------------------------

CombatTab:CreateButton({
	Name = "Set Aim Keybind",
	Callback = function()
		waitingForBind = true
		notify("Aim Assist", "Press any key or mouse button...")
	end,
})


---------------------------------------
-- MAIN LOOP
---------------------------------------

RunService.RenderStepped:Connect(function()

	-- UPDATE CIRCLE
	circle.Position = Vector2.new(
		workspace.CurrentCamera.ViewportSize.X/2,
		workspace.CurrentCamera.ViewportSize.Y/2
	)
	circle.Radius = aimFOV
	circle.Visible = aimEnabled

	-- AIM LOGIC
	if not aimEnabled or not aimHolding then return end

	local target = getClosestTarget()
	if not target then return end

	local char = target.Character
	if not char then return end

	local part = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
	if not part then return end

	local cam = workspace.CurrentCamera
	local targetCF = CFrame.new(cam.CFrame.Position, part.Position)

	-- SMOOTH AIM
	cam.CFrame = cam.CFrame:Lerp(targetCF, aimSmoothness)

end)

---------------------------------------
-- UI
---------------------------------------

createToggle(CombatTab, {
	Name = "Enable Aim Assist",
	CurrentValue = false,
	Callback = function(v)
		aimEnabled = v
	end,
})

CombatTab:CreateSlider({
	Name = "FOV Size",
	Range = {50, 400},
	Increment = 1,
	CurrentValue = 150,
	Callback = function(v)
		aimFOV = v
	end,
})

CombatTab:CreateSlider({
	Name = "Smoothness",
	Range = {1, 100},
	Increment = 1,
	CurrentValue = 15,
	Callback = function(v)
		aimSmoothness = v / 100 -- converts to 0.01 - 1
	end,
})



-- ========================= --
-- VEHICLE TOOLS
-- ========================= --

VehicleTab:CreateSection("Vehicle Tools ( ! Use At Your Own Risk ! )")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

---------------------------------------
-- VARIABLES
---------------------------------------

local vehicleModifierEnabled = false

local topSpeedValue = 150

local horsepowerEnabled = false
local horsepowerValue = 80

local brakeEnabled = false
local brakeForceValue = 120

local turboEnabled = false
local instantAccel = false

---------------------------------------
-- GET CURRENT VEHICLE
---------------------------------------

local function getVehicleSeat()
	local char = player.Character
	if not char then return end

	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	local seat = hum.SeatPart

	if seat and seat:IsA("VehicleSeat") then
		return seat
	end
end

-- ========================= --
-- VEHICLE ENGINE LOOP
-- ========================= --

RunService.Heartbeat:Connect(function()

	local seat = getVehicleSeat()
	if not seat then return end

	local velocity = seat.AssemblyLinearVelocity
	local forward = seat.CFrame.LookVector
	local currentSpeed = velocity:Dot(forward)

---------------------------------------
	-- VEHICLE MODIFIER ONLY
---------------------------------------

	if vehicleModifierEnabled then

		if currentSpeed > topSpeedValue then
			local limited = forward * topSpeedValue
			seat.AssemblyLinearVelocity = Vector3.new(
				limited.X,
				velocity.Y,
				limited.Z
			)
		end

		if turboEnabled and UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
			seat.AssemblyLinearVelocity *= Vector3.new(1.08,1,1.08)
		end

		if instantAccel and seat.Throttle == 1 then
			seat.AssemblyLinearVelocity *= Vector3.new(1.05,1,1.05)
		end

	end

---------------------------------------
	-- HORSEPOWER (Independent)
---------------------------------------

	if horsepowerEnabled and seat.Throttle == 1 then
		local targetSpeed = math.min(
			currentSpeed + horsepowerValue * 0.1,
			topSpeedValue
		)

		local newVelocity = forward * targetSpeed

		seat.AssemblyLinearVelocity = Vector3.new(
			newVelocity.X,
			velocity.Y,
			newVelocity.Z
		)
	end

---------------------------------------
	-- BRAKE (Independent)
---------------------------------------

	if brakeEnabled and seat.Throttle == -1 then
		local targetSpeed = math.max(
			currentSpeed - brakeForceValue * 0.1,
			0
		)

		local newVelocity = forward * targetSpeed

		seat.AssemblyLinearVelocity = Vector3.new(
			newVelocity.X,
			velocity.Y,
			newVelocity.Z
		)
	end

end)

---------------------------------------
-- UI CONTROLS
---------------------------------------

createToggle(VehicleTab, {
	Name = "Enable Vehicle Modifier",
	CurrentValue = false,
	Flag = "VehicleModifier",
	Callback = function(Value)
		vehicleModifierEnabled = Value
	end,
})

VehicleTab:CreateSlider({
	Name = "Top Speed",
	Range = {50,400},
	Increment = 5,
	Suffix = "mph",
	CurrentValue = 150,
	Flag = "TopSpeed",
	Callback = function(Value)
		topSpeedValue = Value
	end,
})

createToggle(VehicleTab, {
	Name = "Enable Horsepower",
	CurrentValue = false,
	Flag = "HorsepowerToggle",
	Callback = function(Value)
		horsepowerEnabled = Value
	end,
})

VehicleTab:CreateSlider({
	Name = "Horsepower",
	Range = {20,200},
	Increment = 5,
	Suffix = "Power",
	CurrentValue = 80,
	Flag = "Horsepower",
	Callback = function(Value)
		horsepowerValue = Value
	end,
})

createToggle(VehicleTab, {
	Name = "Enable Brake Modifier",
	CurrentValue = false,
	Flag = "BrakeToggle",
	Callback = function(Value)
		brakeEnabled = Value
	end,
})

VehicleTab:CreateSlider({
	Name = "Brake Strength",
	Range = {50,300},
	Increment = 5,
	Suffix = "Force",
	CurrentValue = 120,
	Flag = "BrakeForce",
	Callback = function(Value)
		brakeForceValue = Value
	end,
})



-- ============================================== --
-- TELEPORTATION + SPECTATE (FULL SYSTEM FIXED)
-- ============================================== --

TeleportTab:CreateSection("Player Teleport & View")

local selectedPlayer = nil
local playerInput = ""

---------------------------------------
-- GET PLAYER LIST
---------------------------------------

local function getPlayerNames()
	local names = {}
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player then
			table.insert(names, plr.Name)
		end
	end
	return names
end

---------------------------------------
-- FIND PLAYER FROM INPUT (PARTIAL SUPPORT)
---------------------------------------

local function getPlayerFromInput(name)
	name = string.lower(name)

	for _, plr in pairs(Players:GetPlayers()) do
		if string.lower(plr.Name):find(name) then
			return plr
		end
	end

	return nil
end

---------------------------------------
-- DROPDOWN
---------------------------------------

local playerDropdown = TeleportTab:CreateDropdown({
	Name = "Select Player",
	Options = getPlayerNames(),
	CurrentOption = nil,
	MultipleOptions = false,
	Callback = function(Option)
		if Option and Option[1] then
			selectedPlayer = Players:FindFirstChild(Option[1])
		end
	end,
})

---------------------------------------
-- REFRESH BUTTON
---------------------------------------

TeleportTab:CreateButton({
	Name = "Refresh Player List",
	Callback = function()
		local names = getPlayerNames()
		playerDropdown:Refresh(names)

		notify("Teleport", "Player list refreshed")

		-- reset invalid selection
		if selectedPlayer and not selectedPlayer.Parent then
			selectedPlayer = nil
		end
	end,
})

---------------------------------------
-- INPUT (LIVE SEARCH)
---------------------------------------

TeleportTab:CreateInput({
	Name = "Search Player",
	PlaceholderText = "Type player name...",
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
		playerInput = Text

		local filtered = {}
		local firstMatch = nil

		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= player then
				if Text == "" or string.lower(plr.Name):find(string.lower(Text)) then
					table.insert(filtered, plr.Name)

					if not firstMatch then
						firstMatch = plr
					end
				end
			end
		end

		-- UPDATE DROPDOWN
		playerDropdown:Refresh(filtered)

		-- AUTO SELECT FIRST MATCH (THIS IS THE MAGIC)
		if firstMatch then
			selectedPlayer = firstMatch
		else
			selectedPlayer = nil
		end
	end,
	
})

---------------------------------------
-- GET TARGET
---------------------------------------

local function getTarget()
	if selectedPlayer and selectedPlayer.Parent then
		return selectedPlayer
	end

	if playerInput ~= "" then
		local found = getPlayerFromInput(playerInput)

		if not found then
			notify("Teleport/Spectate", "Player not found")
		end

		return found
	end

	notify("Teleport/Spectate", "No player selected")
	return nil
end

---------------------------------------
-- TELEPORT BUTTON
---------------------------------------

TeleportTab:CreateButton({
	Name = "Teleport to Player",
	Callback = function()
		local target = getTarget()
		if not target then return end

		if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			player.Character:PivotTo(
				target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
			)

			notify("Teleport", "Teleported to " .. target.Name)
		else
			notify("Teleport", "Target not spawned / dead")
		end
	end,
})

---------------------------------------
-- SPECTATE SYSTEM
---------------------------------------

local spectating = false
local currentTarget = nil

TeleportTab:CreateToggle({
	Name = "Spectate Player",
	CurrentValue = false,
	Callback = function(Value)
		spectating = Value

		if not Value then
			if player.Character and player.Character:FindFirstChild("Humanoid") then
				workspace.CurrentCamera.CameraSubject = player.Character.Humanoid
			end
			currentTarget = nil
			return
		end

		local target = getTarget()
		if target then
			notify("Spectate", "Viewing " .. target.Name)
		end
	end,
})

---------------------------------------
-- SPECTATE LOOP
---------------------------------------

RunService.RenderStepped:Connect(function()

	if not spectating then return end

	local target = getTarget()
	if not target then return end

	if target ~= currentTarget then
		currentTarget = target
	end

	if target.Character and target.Character:FindFirstChild("Humanoid") then
		workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
	else
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			workspace.CurrentCamera.CameraSubject = player.Character.Humanoid
		end
	end

end)


-- ================================= --
-- Troll Tools
-- ================================= --

-------------------------------------
-- SPINBOT (TROLL)
-------------------------------------

TrollTab:CreateSection("Spinbot")

local spinbotEnabled = false
local spinSpeed = 20

RunService.RenderStepped:Connect(function()
	if not spinbotEnabled then return end
	
	local char = player.Character
	if not char then return end
	
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	
	-- rotate
	hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
end)

-------------------------------------
-- TOGGLE
-------------------------------------

createToggle(TrollTab, {
	Name = "Spinbot",
	CurrentValue = false,
	Callback = function(v)
		spinbotEnabled = v
	end,
})

-------------------------------------
-- SPEED SLIDER
-------------------------------------

TrollTab:CreateSlider({
	Name = "Spin Speed",
	Range = {1, 200},
	Increment = 1,
	CurrentValue = 20,
	Suffix = "Speed",
	Callback = function(v)
		spinSpeed = v
	end,
})


-------------------------------------
-- Fake Lag
-------------------------------------

TrollTab:CreateSection("Fake Lag")

createToggle(TrollTab, {
	Name = "Fake Lag",
	CurrentValue = false,
	Callback = function(v)
		fakeLagEnabled = v
	end,
})

TrollTab:CreateSlider({
	Name = "Lag Delay",
	Range = {1, 10},
	Increment = 1,
	CurrentValue = 3,
	Callback = function(v)
		fakeLagDelay = v / 10 -- converts to 0.1 - 1.0
	end,
})

TrollTab:CreateSlider({
	Name = "Lag Intensity",
	Range = {1, 10},
	Increment = 1,
	CurrentValue = 1,
	Callback = function(v)
		fakeLagIntensity = v
	end,
})


-------------------------------------
-- FAKE AFK WALK
-------------------------------------

TrollTab:CreateSection("Troll - AFK")

local afkWalkEnabled = false

task.spawn(function()
	while true do
		if afkWalkEnabled then
			local char = player.Character
			if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
				
				local humanoid = char.Humanoid
				local hrp = char.HumanoidRootPart
				
				-- RANDOM DIRECTION
				local randomOffset = Vector3.new(
					math.random(-20,20),
					0,
					math.random(-20,20)
				)
				
				local targetPos = hrp.Position + randomOffset
				
				-- WALK TO POSITION
				humanoid:MoveTo(targetPos)
				
				-- WAIT RANDOM TIME
				task.wait(math.random(1,3))
			end
		else
			task.wait(0.2)
		end
	end
end)

-------------------------------------
-- TOGGLE
-------------------------------------

createToggle(TrollTab, {
	Name = "Fake AFK Walk",
	CurrentValue = false,
	Callback = function(v)
		afkWalkEnabled = v
		
		-- STOP MOVEMENT WHEN DISABLED
		if not v then
			local char = player.Character
			if char and char:FindFirstChild("Humanoid") then
				char.Humanoid:Move(Vector3.zero)
			end
		end
	end,
})




-------------------------------------
-- MISC FEATURES
-------------------------------------

MiscTab:CreateSection("Utility")

-------------------------------------
-- ANTI AFK
-------------------------------------

local antiAFK = false
local VirtualUser = game:GetService("VirtualUser")

createToggle(MiscTab, {
	Name = "Anti AFK",
	CurrentValue = false,
	Callback = function(v)
		antiAFK = v
		notify("Misc", v and "Anti AFK Enabled" or "Anti AFK Disabled")
	end,
})

player.Idled:Connect(function()
	if antiAFK then
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
	end
end)

-------------------------------------
-- FULLBRIGHT
-------------------------------------

local lighting = game:GetService("Lighting")

createToggle(MiscTab, {
	Name = "Fullbright",
	CurrentValue = false,
	Callback = function(v)
		if v then
			lighting.Brightness = 2
			lighting.ClockTime = 14
			lighting.FogEnd = 100000
			lighting.GlobalShadows = false
		else
			lighting.GlobalShadows = true
		end
		
		notify("Misc", v and "Fullbright Enabled" or "Fullbright Disabled")
	end,
})

-------------------------------------
-- FPS BOOST
-------------------------------------

--------------------------------------------------
-- FPS BOOST (REVERSIBLE)
--------------------------------------------------

local fpsBoost = false
local savedParts = {}
local savedTextures = {}

createToggle(MiscTab, {
	Name = "FPS Boost",
	CurrentValue = false,
	Callback = function(v)
		fpsBoost = v
		
		if v then
			-- SAVE + APPLY BOOST
			for _, obj in pairs(game:GetDescendants()) do
				
				if obj:IsA("BasePart") then
					if not savedParts[obj] then
						savedParts[obj] = {
							Material = obj.Material,
							Reflectance = obj.Reflectance
						}
					end
					
					obj.Material = Enum.Material.Plastic
					obj.Reflectance = 0
					
				elseif obj:IsA("Decal") or obj:IsA("Texture") then
					if not savedTextures[obj] then
						savedTextures[obj] = obj.Transparency
					end
					
					obj.Transparency = 1 -- hide instead of destroy ✅
				end
				
			end
			
			notify("Misc", "FPS Boost Enabled")
			
		else
			-- RESTORE EVERYTHING
			for obj, data in pairs(savedParts) do
				if obj and obj.Parent then
					obj.Material = data.Material
					obj.Reflectance = data.Reflectance
				end
			end
			
			for obj, transparency in pairs(savedTextures) do
				if obj and obj.Parent then
					obj.Transparency = transparency
				end
			end
			
			notify("Misc", "FPS Boost Disabled (Restored)")
		end
	end,
})

-------------------------------------
-- PLAYER
-------------------------------------

MiscTab:CreateSection("Player")

MiscTab:CreateButton({
	Name = "Rejoin Server",
	Callback = function()
		notify("Misc", "Rejoining...")
		game:GetService("TeleportService"):Teleport(game.PlaceId, player)
	end,
})

MiscTab:CreateButton({
	Name = "Server Hop",
	Callback = function()
		notify("Misc", "Searching for new server...")
		
		local placeId = game.PlaceId
		local currentJobId = game.JobId
		
		local servers = {}
		local cursor = ""
		
		-- GET SERVERS
		local success, result = pcall(function()
			return HttpService:JSONDecode(game:HttpGet(
				"https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100"
			))
		end)
		
		if success and result and result.data then
			for _, server in pairs(result.data) do
				if server.id ~= currentJobId and server.playing < server.maxPlayers then
					table.insert(servers, server.id)
				end
			end
		end
		
		-- TELEPORT TO RANDOM SERVER
		if #servers > 0 then
			local randomServer = servers[math.random(1, #servers)]
			notify("Misc", "Joining new server...")
			TeleportService:TeleportToPlaceInstance(placeId, randomServer, player)
		else
			notify("Misc", "No servers found!")
		end
	end,
})

MiscTab:CreateButton({
	Name = "Reset Character",
	Callback = function()
		player.Character:BreakJoints()
	end,
})


-------------------------------------
-- JOB ID JOINER
-------------------------------------

MiscTab:CreateSection("Job ID Joiner")

MiscTab:CreateButton({
	Name = "Copy Job ID",
	Callback = function()
		setclipboard(game.JobId)
		notify("Misc", "Copied Job ID!")
	end,
})

local jobIdInput = ""

-- INPUT BOX
MiscTab:CreateInput({
	Name = "Enter Job ID",
	PlaceholderText = "Paste JobId here...",
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
		jobIdInput = Text
	end,
})

-- JOIN BUTTON
MiscTab:CreateButton({
	Name = "Join Server by Job ID",
	Callback = function()
		if jobIdInput == "" then
			notify("Job Joiner", "Please enter a Job ID")
			return
		end
		
		notify("Job Joiner", "Joining server...")
		
		local success, err = pcall(function()
			game:GetService("TeleportService"):TeleportToPlaceInstance(
				game.PlaceId,
				jobIdInput,
				player
			)
		end)
		
		if not success then
			notify("Job Joiner", "Failed to join server")
		end
	end,
})


-------------------------------------
-- FUN
-------------------------------------

MiscTab:CreateSection("Fun")

createToggle(MiscTab, {
	Name = "Low Gravity",
	CurrentValue = false,
	Callback = function(v)
		workspace.Gravity = v and 50 or 196.2
		notify("Misc", v and "Low Gravity Enabled" or "Gravity Reset")
	end,
})

createToggle(MiscTab, {
	Name = "Invisible (Client)",
	CurrentValue = false,
	Callback = function(v)
		local char = player.Character
		if char then
			for _, part in pairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					part.LocalTransparencyModifier = v and 1 or 0
				end
			end
		end
		
		notify("Misc", v and "Invisible Enabled" or "Invisible Disabled")
	end,
})



--------------------------------------------------
-- ADVANCED FREECAM (FIXED CONTROLS)
--------------------------------------------------

MiscTab:CreateSection("Freecam")

local freecamEnabled = false

local camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local baseSpeed = 1
local slowSpeed = 0.3
local speed = baseSpeed

local moveDir = Vector3.zero

local savedCameraType
local savedSubject
local savedCFrame

local humanoid
local hrp

local rotation = Vector2.new(0,0)
local mouseSensitivity = 0.2

--------------------------------------------------
-- INPUT
--------------------------------------------------

UIS.InputBegan:Connect(function(input, gp)
	if gp or not freecamEnabled then return end
	
	if input.KeyCode == Enum.KeyCode.W then moveDir += Vector3.new(0,0,1) end
	if input.KeyCode == Enum.KeyCode.S then moveDir += Vector3.new(0,0,-1) end
	if input.KeyCode == Enum.KeyCode.A then moveDir += Vector3.new(-1,0,0) end
	if input.KeyCode == Enum.KeyCode.D then moveDir += Vector3.new(1,0,0) end
	if input.KeyCode == Enum.KeyCode.E then moveDir += Vector3.new(0,0.5,0) end
	if input.KeyCode == Enum.KeyCode.Q then moveDir += Vector3.new(0,-0.5,0) end
	
	-- HOLD SHIFT = SLOW
	if input.KeyCode == Enum.KeyCode.LeftShift then
		speed = slowSpeed
	end
end)

UIS.InputEnded:Connect(function(input)
	if not freecamEnabled then return end
	
	if input.KeyCode == Enum.KeyCode.W then moveDir -= Vector3.new(0,0,1) end
	if input.KeyCode == Enum.KeyCode.S then moveDir -= Vector3.new(0,0,-1) end
	if input.KeyCode == Enum.KeyCode.A then moveDir -= Vector3.new(-1,0,0) end
	if input.KeyCode == Enum.KeyCode.D then moveDir -= Vector3.new(1,0,0) end
	if input.KeyCode == Enum.KeyCode.E then moveDir -= Vector3.new(0,0.5,0) end
	if input.KeyCode == Enum.KeyCode.Q then moveDir -= Vector3.new(0,-0.5,0) end
	
	if input.KeyCode == Enum.KeyCode.LeftShift then
		speed = baseSpeed
	end
end)

--------------------------------------------------
-- MOUSE LOOK
--------------------------------------------------

UIS.InputChanged:Connect(function(input)
	if not freecamEnabled then return end
	
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		rotation += Vector2.new(-input.Delta.Y, -input.Delta.X) * mouseSensitivity
	end
end)

--------------------------------------------------
-- LOOP
--------------------------------------------------

RunService.RenderStepped:Connect(function()
	if not freecamEnabled then return end
	
	-- APPLY ROTATION
	local camCF = CFrame.new(camera.CFrame.Position)
		* CFrame.Angles(0, math.rad(rotation.Y), 0)
		* CFrame.Angles(math.rad(rotation.X), 0, 0)
	
	-- FIXED MOVEMENT (NOW FORWARD IS REAL FORWARD)
	local move =
		(camCF.LookVector * moveDir.Z +
		camCF.RightVector * moveDir.X +
		Vector3.new(0, moveDir.Y, 0)) * speed
	
	camera.CFrame = camCF + move
end)

--------------------------------------------------
-- TOGGLE
--------------------------------------------------

createToggle(MiscTab, {
	Name = "Freecam",
	CurrentValue = false,
	Callback = function(v)
		freecamEnabled = v
		
		if v then
			-- SAVE CAMERA
			savedCameraType = camera.CameraType
			savedSubject = camera.CameraSubject
			savedCFrame = camera.CFrame
			
			rotation = Vector2.new(0,0)
			
			-- FREEZE CHARACTER
			local char = player.Character
			if char then
				humanoid = char:FindFirstChild("Humanoid")
				hrp = char:FindFirstChild("HumanoidRootPart")
				
				if humanoid then
					humanoid.WalkSpeed = 0
					humanoid.JumpPower = 0
				end
				
				if hrp then
					hrp.Anchored = true
				end
			end
			
			-- LOCK MOUSE
			UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
			
			camera.CameraType = Enum.CameraType.Scriptable
			
			notify("Freecam", "Enabled (Shift = Slow)")
			
		else
			-- RESTORE CHARACTER
			if humanoid then
				humanoid.WalkSpeed = 16
				humanoid.JumpPower = 50
			end
			
			if hrp then
				hrp.Anchored = false
			end
			
			-- RESTORE CAMERA
			camera.CameraType = savedCameraType or Enum.CameraType.Custom
			camera.CameraSubject = savedSubject
			camera.CFrame = savedCFrame
			
			-- UNLOCK MOUSE
			UIS.MouseBehavior = Enum.MouseBehavior.Default
			
			moveDir = Vector3.zero
			
			notify("Freecam", "Disabled")
		end
	end,
})



--------------------------------------------------
-- ADVANCED MACRO SYSTEM
--------------------------------------------------

MiscTab:CreateSection("Macro System")

local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

local recording = false
local playing = false
local loopEnabled = false

local macro = {}
local startTime = 0

--------------------------------------------------
-- RECORD INPUT (KEY + MOUSE)
--------------------------------------------------

UIS.InputBegan:Connect(function(input, gp)
	if not recording or gp then return end
	
	table.insert(macro, {
		type = "begin",
		key = input.KeyCode,
		mouse = input.UserInputType,
		time = tick() - startTime
	})
end)

UIS.InputEnded:Connect(function(input)
	if not recording then return end
	
	table.insert(macro, {
		type = "end",
		key = input.KeyCode,
		mouse = input.UserInputType,
		time = tick() - startTime
	})
end)

--------------------------------------------------
-- RECORD MOUSE MOVEMENT (SIMULATED)
--------------------------------------------------

UIS.InputChanged:Connect(function(input)
	if not recording then return end
	
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		table.insert(macro, {
			type = "move",
			delta = input.Delta,
			time = tick() - startTime
		})
	end
end)

--------------------------------------------------
-- START RECORDING
--------------------------------------------------

MiscTab:CreateButton({
	Name = "Start Recording",
	Callback = function()
		macro = {}
		recording = true
		startTime = tick()
		
		notify("Macro", "Recording started")
	end,
})

--------------------------------------------------
-- STOP RECORDING
--------------------------------------------------

MiscTab:CreateButton({
	Name = "Stop Recording",
	Callback = function()
		recording = false
		notify("Macro", "Recorded "..#macro.." actions")
	end,
})

--------------------------------------------------
-- LOOP TOGGLE
--------------------------------------------------

createToggle(MiscTab, {
	Name = "Loop Macro",
	CurrentValue = false,
	Callback = function(v)
		loopEnabled = v
	end,
})

--------------------------------------------------
-- PLAY MACRO
--------------------------------------------------

MiscTab:CreateButton({
	Name = "Play Macro",
	Callback = function()
		if #macro == 0 then
			notify("Macro", "No macro recorded")
			return
		end
		
		if playing then return end
		playing = true
		
		notify("Macro", "Playing macro")
		
		task.spawn(function()
			repeat
				local lastTime = 0
				
				for _, action in ipairs(macro) do
					if not playing then break end
					
					local delay = action.time - lastTime
					task.wait(delay)
					lastTime = action.time
					
					-- KEY INPUT
					if action.type == "begin" or action.type == "end" then
						
						local isDown = action.type == "begin"
						
						-- KEYBOARD
						if action.key ~= Enum.KeyCode.Unknown then
							VIM:SendKeyEvent(isDown, action.key, false, game)
						end
						
						-- MOUSE BUTTONS
						if action.mouse == Enum.UserInputType.MouseButton1 then
							VIM:SendMouseButtonEvent(0, 0, 0, isDown, game, 0)
						elseif action.mouse == Enum.UserInputType.MouseButton2 then
							VIM:SendMouseButtonEvent(0, 0, 1, isDown, game, 0)
						end
					end
					
					-- MOUSE MOVE (CAMERA ROTATION SIM)
					if action.type == "move" then
						local cam = workspace.CurrentCamera
						local sensitivity = 0.002
						
						cam.CFrame = cam.CFrame * CFrame.Angles(
							-action.delta.Y * sensitivity,
							-action.delta.X * sensitivity,
							0
						)
					end
				end
				
				task.wait(0.1)
			until not loopEnabled or not playing
			
			playing = false
			notify("Macro", "Finished")
		end)
	end,
})

--------------------------------------------------
-- STOP MACRO
--------------------------------------------------

MiscTab:CreateButton({
	Name = "Stop Macro",
	Callback = function()
		playing = false
		notify("Macro", "Stopped")
	end,
})



--------------------------------------------------
-- RAYFIELD THEME SWITCHER (RELOAD METHOD)
--------------------------------------------------

ThemeTab:CreateSection("Rayfield Themes")

local themes = {
	"Default",
	"AmberGlow",
	"Amethyst",
	"Bloom",
	"DarkBlue",
	"Green",
	"Light",
	"Ocean",
	"Serenity"
}

ThemeTab:CreateDropdown({
	Name = "Select Theme",
	Options = themes,
	CurrentOption = {"DarkBlue"},
	MultipleOptions = false,
	Callback = function(Option)
		local selected = Option[1]
		
		notify("Theme", "Re-Execute script to apply: "..selected)
		
		-- SAVE THEME (GLOBAL)
		getgenv().SelectedTheme = selected
	end,
})



-- == == == == == == == == == == == == == --

Rayfield:SetVisibility(true)
Rayfield:LoadConfiguration()

-- == == == == == == == == == == == == == --
