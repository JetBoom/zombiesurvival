AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self.Owner, self)

	self.IdleAnimation = CurTime() + self:SequenceDuration()

	return true
end

function SWEP:Initialize()
	self.ActivityTranslate = {}
	self.ActivityTranslate[ACT_HL2MP_IDLE] = ACT_HL2MP_IDLE_MELEE2
	self.ActivityTranslate[ACT_HL2MP_WALK] = ACT_HL2MP_WALK_MELEE2
	self.ActivityTranslate[ACT_HL2MP_RUN] = ACT_HL2MP_RUN_MELEE2
	self.ActivityTranslate[ACT_HL2MP_IDLE_CROUCH] = ACT_HL2MP_IDLE_CROUCH_MELEE2
	self.ActivityTranslate[ACT_HL2MP_WALK_CROUCH] = ACT_HL2MP_WALK_CROUCH_MELEE2
	self.ActivityTranslate[ACT_HL2MP_GESTURE_RANGE_ATTACK] = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2
	self.ActivityTranslate[ACT_HL2MP_GESTURE_RELOAD] = ACT_HL2MP_GESTURE_RELOAD_MELEE2
	self.ActivityTranslate[ACT_HL2MP_JUMP] = ACT_HL2MP_JUMP_MELEE2
	self.ActivityTranslate[ACT_RANGE_ATTACK1] = ACT_RANGE_ATTACK_MELEE2
	self:SetDeploySpeed(1.1)
end
