AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local function BusterDamage(inflictor, attacker, epicenter, radius, damage, noreduce)
	local filter = inflictor
	local self = filter
	for _, ent in pairs(ents.FindInSphere(epicenter, radius)) do
		if ent and ent:IsValid() then
			local nearest = ent:NearestPoint(epicenter)
			if TrueVisibleFilters(epicenter, nearest, inflictor, ent) then
				if ent:IsNailed() then
					damage = damage
					ent:TakeDamage(damage, attacker, self)
				else
					ent:PoisonDamage(((radius - nearest:Distance(epicenter)) / radius) * damage * 0, attacker, inflictor, nil, noreduce)
				end
			end
		end
	end
end

local function BusterBomb(pl, pos)
	local effectdata = EffectData()
		effectdata:SetOrigin(pos)
	util.Effect("chemzombieexplode", effectdata, true)

	if DUMMY_CHEMZOMBIE:IsValid() then
		DUMMY_CHEMZOMBIE:SetPos(pos)
	end
	BusterDamage(DUMMY_CHEMZOMBIE, pl, pos, 128, 33, true)

	pl:CheckRedeem()
end

function SWEP:Think()
	local owner = self.Owner
	if self:GetCharge() >= 1 then
		self.Owner:Kill()
		BusterBomb(owner, owner:LocalToWorld(owner:OBBCenter()))
	end

	self:NextThink(CurTime())
	return true
end

function SWEP:PrimaryAttack()
	if self:GetChargeStart() == 0 then
		self:SetChargeStart(CurTime())
		self.Owner:EmitSound("weapons/cguard/charging.wav", 80, 60)
	end
end
