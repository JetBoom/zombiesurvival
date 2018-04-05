AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	hook.Add("Move", self, self.Move)
	hook.Add("EntityTakeDamage", self, self.EntityTakeDamage)

	if CLIENT then
		hook.Add("PrePlayerDraw", self, self.PrePlayerDraw)
		hook.Add("PostPlayerDraw", self, self.PostPlayerDraw)
	end
end

function ENT:Move(pl, move)
	if pl ~= self:GetOwner() then return end

	move:SetMaxSpeed(move:GetMaxSpeed() * 1.25)
	move:SetMaxClientSpeed(move:GetMaxSpeed())
end

function ENT:EntityTakeDamage(ent, dmginfo)
	if ent ~= self:GetOwner() then return end

	local attacker = dmginfo:GetAttacker()
	if attacker:IsValid() and attacker:IsPlayer() then
		dmginfo:SetDamage(dmginfo:GetDamage() * 0.4)
	end
end

if not CLIENT then return end

function ENT:PrePlayerDraw(pl)
	if pl ~= self:GetOwner() then return end

	local r = math.abs(math.sin((CurTime() + self:EntIndex()) * 3)) * 0.6
	render.SetColorModulation(r, 1, r)
end

function ENT:PostPlayerDraw(pl)
	if pl ~= self:GetOwner() then return end

	render.SetColorModulation(1, 1, 1)
end
