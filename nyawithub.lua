local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()


local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")


local player = Players.LocalPlayer


local highlightEnabled = false
local teamCheck = false
local highlightColor = Color3.fromRGB(255,0,0)


local hitboxEnabled = false
local hitboxSize = 50
local hitboxColor = BrickColor.new("Really blue")


local flying = false
local flySpeed = 50
local flyConnection
local flyKey = Enum.KeyCode.F


local Window = Rayfield:CreateWindow({
   Name = "Sawit Hub",
   Icon = 83878464505556,
   LoadingTitle = "Loading Sawit Hub...",
   LoadingSubtitle = "by {encrypted}",
   ShowText = "Sawit",
   Theme = "Ocean",
   ToggleUIKeybind = "K",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = true,

   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "Sawit Hub"
   },

   KeySystem = true,
   KeySettings = {
      Title = "Sawit",
      Subtitle = "Sawit Hub Key System",
      Note = "Join the Discord server to obtain the Sawit key",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"sawitbesthub", "H1DUP_J0K0W1", "M_B_##G"}
   }
})


local MainTab = Window:CreateTab("Player Tools", 128138526770905)
local CombatTab = Window:CreateTab("Combat Tools", 137069456808295)

MainTab:CreateSection("Walk & Jump Controls")

-- WalkSpeed
MainTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {8,1000},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "WalkSpeed",
   Callback = function(Value)
      local char = player.Character
      if char and char:FindFirstChild("Humanoid") then
         char.Humanoid.WalkSpeed = Value
      end
   end,
})

-- Jump Power
MainTab:CreateSlider({
   Name = "Jump Power",
   Range = {20,500},
   Increment = 5,
   Suffix = "Power",
   CurrentValue = 50,
   Flag = "JumpPower",
   Callback = function(Value)
      local char = player.Character
      if char and char:FindFirstChild("Humanoid") then
         local hum = char.Humanoid
         hum.UseJumpPower = true
         hum.JumpPower = Value
      end
   end,
})

--------------------------------------------------
-- FLY SYSTEM
--------------------------------------------------

MainTab:CreateSection("Fly Controls ( ! USE ON YOUR OWN RISK ! )")

local flyEnabled = false
local flying = false
local flySpeed = 50
local flyConnection
local flyKey = Enum.KeyCode.F

local function startFly()
	local char = player.Character
	if not char then return end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChild("Humanoid")

	if not hrp or not hum then return end

	hum.AutoRotate = false
	hum.PlatformStand = false
	hum:ChangeState(Enum.HumanoidStateType.Physics)

	local bv = Instance.new("BodyVelocity")
	bv.Name = "FlyVelocity"
	bv.MaxForce = Vector3.new(9e9,9e9,9e9)
	bv.Velocity = Vector3.zero
	bv.Parent = hrp

	local bg = Instance.new("BodyGyro")
	bg.Name = "FlyGyro"
	bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
	bg.P = 9e4
	bg.CFrame = hrp.CFrame
	bg.Parent = hrp

	flyConnection = RunService.RenderStepped:Connect(function()
		local cam = workspace.CurrentCamera
		local moveDir = Vector3.zero

		hum:ChangeState(Enum.HumanoidStateType.Physics)
		bg.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.CFrame.LookVector)

		if UIS:IsKeyDown(Enum.KeyCode.W) then
			moveDir += cam.CFrame.LookVector
		end
		if UIS:IsKeyDown(Enum.KeyCode.S) then
			moveDir -= cam.CFrame.LookVector
		end
		if UIS:IsKeyDown(Enum.KeyCode.A) then
			moveDir -= cam.CFrame.RightVector
		end
		if UIS:IsKeyDown(Enum.KeyCode.D) then
			moveDir += cam.CFrame.RightVector
		end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then
			moveDir += Vector3.new(0,1,0)
		end
		if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
			moveDir -= Vector3.new(0,1,0)
		end

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

	local hrp = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChild("Humanoid")

	if hum then
		hum.AutoRotate = true
		hum:ChangeState(Enum.HumanoidStateType.GettingUp)
	end

	if hrp then
		if hrp:FindFirstChild("FlyVelocity") then
			hrp.FlyVelocity:Destroy()
		end
		if hrp:FindFirstChild("FlyGyro") then
			hrp.FlyGyro:Destroy()
		end
	end

	if flyConnection then
		flyConnection:Disconnect()
	end
end

UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if not flyEnabled then return end

	if input.KeyCode == flyKey then
		flying = not flying

		if flying then
			startFly()
		else
			stopFly()
		end
	end
end)

MainTab:CreateToggle({
	Name = "Enable Fly System",
	CurrentValue = false,
	Flag = "FlyToggle",
	Callback = function(Value)
		flyEnabled = Value

		if not flyEnabled and flying then
			flying = false
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
	Flag = "FlySpeed",
	Callback = function(Value)
		flySpeed = Value
	end,
})

MainTab:CreateKeybind({
	Name = "Fly Keybind",
	CurrentKeybind = "F",
	HoldToInteract = false,
	Flag = "FlyBind",
	Callback = function(Key)
		if typeof(Key) == "string" then
			flyKey = Enum.KeyCode[Key]
		elseif typeof(Key) == "EnumItem" then
			flyKey = Key
		end
	end,
})


-- Reset Character
MainTab:CreateButton({
   Name = "Reset Character",
   Callback = function()
      local char = player.Character
      if char and char:FindFirstChild("Humanoid") then
         char.Humanoid.Health = 0
      end
   end,
})

--------------------------------------------------
-- ESP
--------------------------------------------------

CombatTab:CreateSection("ESP Tools")

local function clearHighlights()
   for _, plr in pairs(Players:GetPlayers()) do
      if plr.Character and plr.Character:FindFirstChild("DevHighlight") then
         plr.Character.DevHighlight:Destroy()
      end
   end
end

local function updateHighlights()
   clearHighlights()

   if not highlightEnabled then return end

   for _, plr in pairs(Players:GetPlayers()) do
      if plr ~= player and plr.Character then
         if teamCheck and plr.Team == player.Team then
            continue
         end

         local h = Instance.new("Highlight")
         h.Name = "DevHighlight"
         h.FillColor = highlightColor
         h.OutlineColor = highlightColor
         h.FillTransparency = 0.5
         h.Parent = plr.Character
      end
   end
end

CombatTab:CreateToggle({
   Name = "Highlight Players",
   CurrentValue = false,
   Flag = "HighlightToggle",
   Callback = function(Value)
      highlightEnabled = Value
      updateHighlights()
   end,
})

CombatTab:CreateToggle({
   Name = "Team Check",
   CurrentValue = false,
   Flag = "TeamCheck",
   Callback = function(Value)
      teamCheck = Value
      updateHighlights()
   end,
})

CombatTab:CreateColorPicker({
   Name = "Highlight Color",
   Color = Color3.fromRGB(255,0,0),
   Flag = "HighlightColor",
   Callback = function(Value)
      highlightColor = Value
      updateHighlights()
   end,
})

--------------------------------------------------
-- HITBOX
--------------------------------------------------

CombatTab:CreateSection("Hitbox Modifier")

local hitboxEnabled = false
local hitboxSize = 50
local hitboxColor = BrickColor.new("Really blue")
local hitboxTeamCheck = false

local function applyHitbox(plr)
	if plr == player then return end
	if not plr.Character then return end

	local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	if hitboxTeamCheck then
		if player.TeamColor == plr.TeamColor then
			hrp.Size = Vector3.new(2,2,1)
			hrp.Transparency = 1
			hrp.Material = Enum.Material.Plastic
			return
		end
	end

	hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
	hrp.Transparency = 0.7
	hrp.BrickColor = hitboxColor
	hrp.Material = Enum.Material.Neon
	hrp.CanCollide = false
end

local function resetHitbox(plr)
	if plr == player then return end
	if not plr.Character then return end

	local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	hrp.Size = Vector3.new(2,2,1)
	hrp.Transparency = 1
	hrp.Material = Enum.Material.Plastic
end

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

CombatTab:CreateToggle({
	Name = "Enable Hitbox",
	CurrentValue = false,
	Flag = "HitboxToggle",
	Callback = function(Value)
		hitboxEnabled = Value
	end,
})

CombatTab:CreateToggle({
	Name = "Hitbox Team Check",
	CurrentValue = false,
	Flag = "HitboxTeamCheck",
	Callback = function(Value)
		hitboxTeamCheck = Value
	end,
})

CombatTab:CreateSlider({
	Name = "Hitbox Size",
	Range = {2,50},
	Increment = 1,
	Suffix = "Size",
	CurrentValue = 50,
	Flag = "HitboxSize",
	Callback = function(Value)
		hitboxSize = Value
	end,
})

CombatTab:CreateColorPicker({
	Name = "Hitbox Color",
	Color = Color3.fromRGB(0,0,255),
	Flag = "HitboxColor",
	Callback = function(Value)
		hitboxColor = BrickColor.new(Value)
	end,
})


--------------------------------------------------
-- INSTANT HEAL (Improved)
--------------------------------------------------

local instantHeal = false
local healConnection
local healInterval = 0.1 -- seconds between checks (adjustable via slider)
local healAccumulator = 0

local function getLocalHumanoid()
	local char = player and player.Character
	if not char then return nil end
	return char:FindFirstChildOfClass("Humanoid")
end

local function tryHealOnce()
	local hum = getLocalHumanoid()
	if not hum then return false end
	if hum.Health <= 0 then return false end
	if hum.Health >= hum.MaxHealth then return false end

	local ok, err = pcall(function()
		hum.Health = hum.MaxHealth
	end)
	if not ok then
		warn("InstantHeal: failed to set health - " .. tostring(err))
		return false
	end
	return true
end

local function onHeartbeat(dt)
	if not instantHeal then return end
	healAccumulator = healAccumulator + dt
	if healAccumulator < healInterval then return end
	healAccumulator = 0
	tryHealOnce()
end

local function startInstantHeal()
	if healConnection then return end
	healAccumulator = 0
	healConnection = RunService.Heartbeat:Connect(onHeartbeat)
end

local function stopInstantHeal()
	if healConnection then
		healConnection:Disconnect()
		healConnection = nil
	end
end

-- Reset accumulator on respawn so healing resumes cleanly
player.CharacterAdded:Connect(function()
	healAccumulator = 0
end)

CombatTab:CreateSection("Instant Heal (! WIP !)")

CombatTab:CreateToggle({
	Name = "Enable Instant Heal",
	CurrentValue = false,
	Flag = "InstantHealToggle",
	Callback = function(Value)
		instantHeal = Value
		if instantHeal then
			startInstantHeal()
		else
			stopInstantHeal()
		end
	end,
})

CombatTab:CreateSlider({
	Name = "Heal Check Interval",
	Range = {50,500}, -- milliseconds
	Increment = 25,
	Suffix = "ms",
	CurrentValue = 100,
	Flag = "HealInterval",
	Callback = function(Value)
		healInterval = math.max(0.01, Value / 1000)
	end,
})

CombatTab:CreateButton({
	Name = "Heal Now",
	Callback = function()
		local ok = tryHealOnce()
		if not ok then
			warn("Heal Now: could not heal (maybe dead or no humanoid)")
		end
	end,
})

--------------------------------------------------

Rayfield:SetVisibility(true)
Rayfield:LoadConfiguration()
