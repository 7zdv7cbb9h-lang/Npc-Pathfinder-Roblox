-- NPC Usage Script - Quick setup guide
local NPCModule = require(script.Parent:WaitForChild("Pathfinding"))

local npcModel = workspace:WaitForChild("CreepyNPC")

local npc = {}
setmetatable(npc, {__index = NPCModule})

local customConfig = {
	FollowSpeed = 25,
	StoppingDistance = 5,
	JumpscareDistance = 15,
	WallAvoidanceRange = 20,
	JumpscareIntensity = 2,
	JumpscareDuration = 3,
	DetectionRayLength = 50
}

npc:Initialize(npcModel, customConfig)

print("🎮 NPC System Started!")

-- Multiple NPCs example:
--[[
local npc1 = {}
setmetatable(npc1, {__index = NPCModule})
npc1:Initialize(workspace:WaitForChild("CreepyNPC1"), {JumpscareDistance = 10})

local npc2 = {}
setmetatable(npc2, {__index = NPCModule})
npc2:Initialize(workspace:WaitForChild("CreepyNPC2"), {JumpscareDistance = 20})
--]]

print("✨ Your creepy NPC is now active!")
