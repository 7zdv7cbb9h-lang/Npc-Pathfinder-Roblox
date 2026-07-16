-- Main Server Script - Place this in ServerScriptService
local NPCModule = require(script:WaitForChild("Pathfinding"))
local players = game:GetService("Players")

local NPC_CONFIG = {
	NpcName = "CreepyNPC",
	FollowSpeed = 25,
	StoppingDistance = 5,
	JumpscareDistance = 15,
	WallAvoidanceRange = 20,
	JumpscareIntensity = 2,
	JumpscareDuration = 3,
	DetectionRayLength = 50
}

local function InitializeNPC()
	local npcModel = workspace:WaitForChild(NPC_CONFIG.NpcName)
	
	local npc = {}
	setmetatable(npc, {__index = NPCModule})
	npc:Initialize(npcModel, NPC_CONFIG)
	
	print("✅ Creepy NPC Initialized!")
	print("   - Follow Speed: " .. NPC_CONFIG.FollowSpeed)
	print("   - Jumpscare Distance: " .. NPC_CONFIG.JumpscareDistance .. " studs")
	print("   - Jumpscare Duration: " .. NPC_CONFIG.JumpscareDuration .. " seconds")
	
	return npc
end

local success, error = pcall(function()
	InitializeNPC()
end)

if not success then
	warn("❌ Failed to initialize NPC: " .. error)
	warn("Make sure you have:")
	warn("1. A model named '" .. NPC_CONFIG.NpcName .. "' in workspace")
	warn("2. Pathfinding.lua as a ModuleScript in the same folder")
	warn("3. The model has a Humanoid and HumanoidRootPart")
end
