AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"

-- One global hook on EntityTakeDamage instead of an entity hook for each
-- debuff instance. With N active debuffs, EntityTakeDamage previously
-- iterated through N additional hooks on every call in the game.
-- Now — one hook + one table + a counter to exit immediately
-- if there are no active debuffs.

local ZombieDartDebuffs     = {}   -- [owner] = ent
local ZombieDartDebuffCount = 0

if SERVER then
	hook.Add("EntityTakeDamage", "ZS_ZombieDartDebuff", function(ent, dmginfo)
		if ZombieDartDebuffCount == 0 then return end

		local attacker = dmginfo:GetAttacker()
		if not IsValid(attacker) or not attacker:IsPlayer() then return end

		if ZombieDartDebuffs[attacker] == nil then return end

		dmginfo:SetDamage(dmginfo:GetDamage() * 0.75)
	end)
end

function ENT:RegisterOwner(owner)
	if not IsValid(owner) or not owner:IsPlayer() then return end
	if ZombieDartDebuffs[owner] == self then return end

	if ZombieDartDebuffs[owner] == nil then
		ZombieDartDebuffCount = ZombieDartDebuffCount + 1
	end
	ZombieDartDebuffs[owner] = self
end

function ENT:UnregisterOwner()
	local owner = self:GetOwner()
	if IsValid(owner) and ZombieDartDebuffs[owner] == self then
		ZombieDartDebuffs[owner] = nil
		ZombieDartDebuffCount = ZombieDartDebuffCount - 1
	end
end

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	if SERVER then
		self:RegisterOwner(self:GetOwner())
		self:SetDTInt(1, 0)
	end
end

function ENT:PlayerSet(pl)
	if SERVER then
		self:RegisterOwner(pl)
	end
end

function ENT:OnRemove()
	if SERVER then
		self:UnregisterOwner()
	end
	if self.BaseClass.OnRemove then
		self.BaseClass.OnRemove(self)
	end
end