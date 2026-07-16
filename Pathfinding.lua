-- NPC Pathfinding Script with 3D Jumpscare
local NPC = {}
local pathfindingService = game:GetService("PathfindingService")
local players = game:GetService("Players")
local runService = game:GetService("RunService")

-- Configuration
local CONFIG = {
	FollowSpeed = 25,
	StoppingDistance = 5,
	JumpscareDistance = 15,
	WallAvoidanceRange = 20,
	JumpscareIntensity = 2,
	JumpscareDuration = 3,
	DetectionRayLength = 50
}

function NPC:Initialize(npcModel, customConfig)
	self.Model = npcModel
	self.Humanoid = npcModel:WaitForChild("Humanoid")
	self.HumanoidRootPart = npcModel:WaitForChild("HumanoidRootPart")
	self.Config = customConfig or CONFIG
	self.IsJumpscaring = false
	self.TargetPlayer = nil
	self.IsMoving = false
	
	self:StartBehaviorLoop()
end

function NPC:StartBehaviorLoop()
	while true do
		wait(0.1)
		if not self.IsJumpscaring then
			self:FindTargetPlayer()
			if self.TargetPlayer and self.TargetPlayer.Character then
				self:FollowPlayer()
			end
		end
	end
end

function NPC:FindTargetPlayer()
	local playerList = players:GetPlayers()
	if #playerList > 0 then
		self.TargetPlayer = playerList[1]
	end
end

function NPC:FollowPlayer()
	if not self.TargetPlayer or not self.TargetPlayer.Character then 
		return 
	end
	
	local targetChar = self.TargetPlayer.Character
	local targetHRP = targetChar:FindChild("HumanoidRootPart")
	
	if not targetHRP then 
		return 
	end
	
	local distance = (self.HumanoidRootPart.Position - targetHRP.Position).Magnitude
	
	if distance < self.Config.JumpscareDistance then
		self:TriggerJumpscare(targetHRP)
		return
	end
	
	if distance > self.Config.StoppingDistance then
		local moveDirection = (targetHRP.Position - self.HumanoidRootPart.Position).Unit
		
		if not self:IsPathBlocked(moveDirection) then
			self.Humanoid:MoveTo(targetHRP.Position + Vector3.new(0, 0, 0))
		else
			self:AvoidObstacles(targetHRP)
		end
	end
end

function NPC:IsPathBlocked(direction)
	local rayOrigin = self.HumanoidRootPart.Position
	local rayDirection = direction * self.Config.DetectionRayLength
	
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	raycastParams.FilterDescendantsInstances = {self.Model}
	
	local result = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
	
	return result ~= nil
end

function NPC:AvoidObstacles(targetHRP)
	local angles = {45, -45, 90, -90}
	local moveDirection = (targetHRP.Position - self.HumanoidRootPart.Position).Unit
	
	for _, angle in ipairs(angles) do
		local rotated = self:RotateVector(moveDirection, angle)
		if not self:IsPathBlocked(rotated) then
			self.Humanoid:MoveTo(self.HumanoidRootPart.Position + rotated * 10)
			return
		end
	end
end

function NPC:RotateVector(vector, angleDegrees)
	local angleRad = math.rad(angleDegrees)
	local cos = math.cos(angleRad)
	local sin = math.sin(angleRad)
	
	return Vector3.new(
		vector.X * cos - vector.Z * sin,
		vector.Y,
		vector.X * sin + vector.Z * cos
	)
end

function NPC:TriggerJumpscare(targetHRP)
	if self.IsJumpscaring then 
		return 
	end
	self.IsJumpscaring = true
	
	self.Humanoid:MoveTo(self.HumanoidRootPart.Position)
	self:Create3DJumpscare(targetHRP)
	
	wait(self.Config.JumpscareDuration)
	self.IsJumpscaring = false
end

function NPC:Create3DJumpscare(targetHRP)
	local camera = workspace.CurrentCamera
	local originalCFrame = camera.CFrame
	
	-- Rapid camera zoom
	for i = 1, 8 do
		camera.CFrame = camera.CFrame * CFrame.new(0, 0, -1.5)
		wait(0.05)
	end
	
	-- NPC size distortion
	local originalSize = self.HumanoidRootPart.Size
	for i = 1, 6 do
		if self.Model and self.HumanoidRootPart then
			self.HumanoidRootPart.Size = originalSize * (1 + (i * 0.3))
		end
		wait(0.1)
	end
	
	if self.Model and self.HumanoidRootPart then
		self.HumanoidRootPart.Size = originalSize
	end
	
	-- White flash effect
	local flashPart = Instance.new("Part")
	flashPart.Shape = Enum.PartType.Ball
	flashPart.Color = Color3.fromRGB(255, 255, 255)
	flashPart.Material = Enum.Material.Neon
	flashPart.CanCollide = false
	flashPart.CFrame = camera.CFrame + camera.CFrame.LookVector * 5
	flashPart.Size = Vector3.new(50, 50, 50)
	flashPart.Parent = workspace
	
	for i = 1, 10 do
		if flashPart then
			flashPart.Transparency = i / 10
		end
		wait(0.05)
	end
	
	if flashPart then
		flashPart:Destroy()
	end
	
	camera.CFrame = originalCFrame
	self:PlayScareSound()
end

function NPC:PlayScareSound()
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://12221982"
	sound.Volume = 1
	sound.Parent = self.HumanoidRootPart
	sound:Play()
	game:GetService("Debris"):AddItem(sound, 2)
end

return NPC
