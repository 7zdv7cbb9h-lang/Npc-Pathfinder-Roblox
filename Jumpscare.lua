-- Jumpscare Module - Dedicated 3D Jumpscare Effects
local Jumpscare = {}

-- Configuration for jumpscare effects
local JUMPSCARE_CONFIG = {
	CameraZoomIterations = 8,
	CameraZoomDistance = 1.5,
	CameraZoomWait = 0.05,
	
	SizeDistortionFrames = 6,
	SizeDistortionMultiplier = 0.3,
	SizeDistortionWait = 0.1,
	
	FlashFadeFrames = 10,
	FlashFadeWait = 0.05,
	
	DefaultScareSound = "rbxassetid://12221982"
}

-- ============================================
-- Camera Zoom Effect
-- ============================================
function Jumpscare:CameraZoom(camera)
	local originalCFrame = camera.CFrame
	
	for i = 1, JUMPSCARE_CONFIG.CameraZoomIterations do
		camera.CFrame = camera.CFrame * CFrame.new(0, 0, -JUMPSCARE_CONFIG.CameraZoomDistance)
		wait(JUMPSCARE_CONFIG.CameraZoomWait)
	end
	
	return originalCFrame
end

-- ============================================
-- Size Distortion Effect
-- ============================================
function Jumpscare:SizeDistortion(humanoidRootPart)
	local originalSize = humanoidRootPart.Size
	
	for i = 1, JUMPSCARE_CONFIG.SizeDistortionFrames do
		if humanoidRootPart and humanoidRootPart.Parent then
			humanoidRootPart.Size = originalSize * (1 + (i * JUMPSCARE_CONFIG.SizeDistortionMultiplier))
		end
		wait(JUMPSCARE_CONFIG.SizeDistortionWait)
	end
	
	-- Reset size
	if humanoidRootPart and humanoidRootPart.Parent then
		humanoidRootPart.Size = originalSize
	end
	
	return originalSize
end

-- ============================================
-- Flash Effect
-- ============================================
function Jumpscare:FlashEffect(camera)
	local flashPart = Instance.new("Part")
	flashPart.Shape = Enum.PartType.Ball
	flashPart.Color = Color3.fromRGB(255, 255, 255)
	flashPart.Material = Enum.Material.Neon
	flashPart.CanCollide = false
	flashPart.CFrame = camera.CFrame + camera.CFrame.LookVector * 5
	flashPart.Size = Vector3.new(50, 50, 50)
	flashPart.Parent = workspace
	
	for i = 1, JUMPSCARE_CONFIG.FlashFadeFrames do
		if flashPart then
			flashPart.Transparency = i / JUMPSCARE_CONFIG.FlashFadeFrames
		end
		wait(JUMPSCARE_CONFIG.FlashFadeWait)
	end
	
	if flashPart then
		flashPart:Destroy()
	end
end

-- ============================================
-- Sound Effect
-- ============================================
function Jumpscare:PlaySound(humanoidRootPart, soundId)
	soundId = soundId or JUMPSCARE_CONFIG.DefaultScareSound
	
	local sound = Instance.new("Sound")
	sound.SoundId = soundId
	sound.Volume = 1
	sound.Parent = humanoidRootPart
	sound:Play()
	game:GetService("Debris"):AddItem(sound, 2)
end

-- ============================================
-- Full Jumpscare Sequence
-- ============================================
function Jumpscare:Trigger(humanoidRootPart, customConfig)
	local config = customConfig or JUMPSCARE_CONFIG
	local camera = workspace.CurrentCamera
	
	-- Store original camera position
	local originalCFrame = self:CameraZoom(camera)
	
	-- Size distortion
	self:SizeDistortion(humanoidRootPart)
	
	-- Flash effect
	self:FlashEffect(camera)
	
	-- Reset camera
	camera.CFrame = originalCFrame
	
	-- Play sound
	self:PlaySound(humanoidRootPart, config.DefaultScareSound)
end

-- ============================================
-- Individual Effect Customization
-- ============================================
function Jumpscare:CustomZoom(camera, iterations, distance, waitTime)
	iterations = iterations or JUMPSCARE_CONFIG.CameraZoomIterations
	distance = distance or JUMPSCARE_CONFIG.CameraZoomDistance
	waitTime = waitTime or JUMPSCARE_CONFIG.CameraZoomWait
	
	local originalCFrame = camera.CFrame
	
	for i = 1, iterations do
		camera.CFrame = camera.CFrame * CFrame.new(0, 0, -distance)
		wait(waitTime)
	end
	
	return originalCFrame
end

function Jumpscare:CustomDistortion(humanoidRootPart, frames, multiplier, waitTime)
	frames = frames or JUMPSCARE_CONFIG.SizeDistortionFrames
	multiplier = multiplier or JUMPSCARE_CONFIG.SizeDistortionMultiplier
	waitTime = waitTime or JUMPSCARE_CONFIG.SizeDistortionWait
	
	local originalSize = humanoidRootPart.Size
	
	for i = 1, frames do
		if humanoidRootPart and humanoidRootPart.Parent then
			humanoidRootPart.Size = originalSize * (1 + (i * multiplier))
		end
		wait(waitTime)
	end
	
	if humanoidRootPart and humanoidRootPart.Parent then
		humanoidRootPart.Size = originalSize
	end
	
	return originalSize
end

function Jumpscare:CustomFlash(camera, color, fadeFrames, waitTime)
	color = color or Color3.fromRGB(255, 255, 255)
	fadeFrames = fadeFrames or JUMPSCARE_CONFIG.FlashFadeFrames
	waitTime = waitTime or JUMPSCARE_CONFIG.FlashFadeWait
	
	local flashPart = Instance.new("Part")
	flashPart.Shape = Enum.PartType.Ball
	flashPart.Color = color
	flashPart.Material = Enum.Material.Neon
	flashPart.CanCollide = false
	flashPart.CFrame = camera.CFrame + camera.CFrame.LookVector * 5
	flashPart.Size = Vector3.new(50, 50, 50)
	flashPart.Parent = workspace
	
	for i = 1, fadeFrames do
		if flashPart then
			flashPart.Transparency = i / fadeFrames
		end
		wait(waitTime)
	end
	
	if flashPart then
		flashPart:Destroy()
	end
end

-- ============================================
-- Config Getters and Setters
-- ============================================
function Jumpscare:GetConfig()
	return JUMPSCARE_CONFIG
end

function Jumpscare:SetConfig(newConfig)
	for key, value in pairs(newConfig) do
		if JUMPSCARE_CONFIG[key] ~= nil then
			JUMPSCARE_CONFIG[key] = value
		end
	end
end

function Jumpscare:ResetConfig()
	JUMPSCARE_CONFIG = {
		CameraZoomIterations = 8,
		CameraZoomDistance = 1.5,
		CameraZoomWait = 0.05,
		
		SizeDistortionFrames = 6,
		SizeDistortionMultiplier = 0.3,
		SizeDistortionWait = 0.1,
		
		FlashFadeFrames = 10,
		FlashFadeWait = 0.05,
		
		DefaultScareSound = "rbxassetid://12221982"
	}
end

return Jumpscare
