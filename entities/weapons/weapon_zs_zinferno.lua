AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = translate.Get("class_boss_inferno")
end

SWEP.Base = "weapon_zs_zombie"

SWEP.MeleeDamage = 20
SWEP.SlowDownScale = 2
SWEP.AlertDelay = 7

function SWEP:Reload()
	if CLIENT then return end

	if CurTime() < self:GetNextSecondaryFire() then return end
	self:SetNextSecondaryFire(CurTime() + self.AlertDelay)

	self:DoAlert()
end

function SWEP:PlayAlertSound()
	self.Owner:EmitSound("ambient/levels/coast/antlion_hill_ambient4.wav", 120 ,math.random(70, 85))
	end
	
SWEP.PlayIdleSound = SWEP.PlayAlertSound

function SWEP:PlayAttackSound()
	self.Owner:EmitSound("npc/barnacle/barnacle_bark"..math.random(2)..".wav", 100, 85)
end

local IsFleshFireDamage = false

function SWEP:MeleeHitEntity(ent, trace, damage, forcescale)
	IsFleshFireDamage = true
	local timeIgnited = math.random(10,14)
	if trace.MatType == MAT_WOOD or MAT_METAL then
		timer.Create(tostring(ent) .. "fleshfire", timeIgnited, 1, function() 
			if IsValid(ent) then 
				ent:Extinguish() 
			end
			if ent.hitdmg then 
				ent.hitdmg = nil
			end 
		end)
		ent:Ignite(timeIgnited, 100)
	end
	
	if not ent:IsPlayer() and trace.MatType == MAT_WOOD then
		ent.hitdmg = self.Owner
		ent.hitinf = self
	end
	IsFleshFireDamage = false
	
	local phys = ent:GetPhysicsObject()
	if phys:IsValid() and phys:IsMoveable() then
		if trace.IsPreHit then
			phys:ApplyForceOffset(damage * 750 * (forcescale or self.MeleeForceScale) * self.Owner:GetAimVector(), (ent:NearestPoint(self.Owner:EyePos()) + ent:GetPos() * 5) / 6)
		else
			phys:ApplyForceOffset(damage * 750 * (forcescale or self.MeleeForceScale) * trace.Normal, (ent:NearestPoint(trace.StartPos) + ent:GetPos() * 2) / 3)
		end
		ent:SetPhysicsAttacker(self.Owner)
	end
end

function SWEP:MeleeHitPlayer(ent, trace, damage, forcescale)
	ent:ThrowFromPositionSetZ(self.Owner:GetPos(), damage * 2.5 * (forcescale or self.MeleeForceScale))
	ent:MeleeViewPunch(damage)
	local nearest = ent:NearestPoint(trace.StartPos)
	util.Blood(nearest, math.Rand(damage * 0.5, damage * 0.75), (nearest - trace.StartPos):GetNormalized(), math.Rand(damage * 5, damage * 10), true)
	IsFleshFireDamage = true
	local timeIgnited = math.random(4, 6.5)
	timer.Create(tostring(ent) .. "fleshfire", timeIgnited, 1, function() 
		if IsValid(ent) then 
			ent:Extinguish() 
		end 
		ent.hitdmg = nil 
	end)
	ent:Ignite(timeIgnited, 100)
	
	if ent:IsPlayer() then
		ent.hitdmg = self.Owner
		ent.hitinf = self
	end
	IsFleshFireDamage = false
end
	
if SERVER then
	local function EntityTakeDamage( ent, info )
  		local e = info:GetInflictor() 		
		
		if ent.hitdmg == nil and e.IsFleshFireDMG and not ent.prevdmg and not ent:IsPlayer() then
			local timeIgnited = 5
		
			if tonumber(ent.fireduration) then
				timeIgnited = tonumber(ent.fireduration)
			else 
				Msg("FIRE DUR NONEXISTENT!!")
			end
			
			timer.Create(tostring(ent) .. "fleshfire", timeIgnited, 1, function() 
				if IsValid(ent) then 
					ent:Extinguish() 
				end 
				ent.hitdmg = nil 
				ent.prevdmg = nil
			end)
			ent.prevdmg = true
		end
		
  		if IsValid(e) and e:GetClass() == "entityflame" and ent.hitdmg and IsValid(ent.hitdmg) and ent.hitdmg:IsPlayer() and ent.hitdmg:Team() == TEAM_UNDEAD and IsValid(ent.hitinf) then
    		info:SetAttacker(ent.hitdmg)
    		info:SetInflictor(ent.hitinf)
			e.IsFleshFireDMG = true
			e.hitdmg = ent.hitdmg
			e.hitinf = ent.hitinf
  		end
		
		if ent:IsPlayer() and ent:Team() == TEAM_UNDEAD and e.IsFleshFireDMG then
			info:SetDamage(0)
			info:SetDamageType(DMG_GENERIC)
		end
		
		if e.IsFleshFireDMG then
			if e.hitdmg ~= nil then 
				ent.hitdmg = e.hitdmg
			end
			
			if e.hitinf ~= nil then 
				ent.hitinf = e.hitinf
			end
		end
	end
	hook.Add( "EntityTakeDamage", "FleshFire.HookEntityDamage", EntityTakeDamage )
	
	local function HookKV(ent, key, value)
		if ent:GetClass() == "entityflame" and key == "Duration" then
			ent.fireduration = value
		end
	end
	
	hook.Add("EntityKeyValue", "FleshFire.HookKV", HookKV)
end

if not CLIENT then return end

function SWEP:ViewModelDrawn()
	render.ModelMaterialOverride(0)
end

local matSheet = Material("models/props_lab/Tank_Glass001")
function SWEP:PreDrawViewModel(vm)
	render.ModelMaterialOverride(matSheet)
end
