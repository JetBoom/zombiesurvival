AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local function DoPlaceTrap(pl)
	if pl:IsValid() and pl:Alive() and pl:GetActiveWeapon():IsValid() then
		pl:ResetSpeed()
		local trace = pl:TraceLine(100, MASK_SOLID)
		if trace.Entity and trace.Entity:IsWorld()then
			pl:EmitSound("npc/roller/mine/rmine_predetonate.wav",75,60)
			local ent = ents.Create("prop_trap")
			if ent:IsValid() then
				ent:SetPos(trace.HitPos)
				ent:SetAngles(trace.HitNormal:Angle())
				ent:Spawn()
				ent:SetOwner(pl)
				ent.Team = pl:Team()
			end
			pl:RawCapLegDamage(CurTime() + 2)
			pl:TakeDamage(60)
		end	
	end
end
local function DoSwing(pl, wep)
	if pl:IsValid() and pl:Alive() and wep:IsValid() then
	
		if wep.SwapAnims then wep:SendWeaponAnim(ACT_VM_HITCENTER) else wep:SendWeaponAnim(ACT_VM_SECONDARYATTACK) end
		wep.IdleAnimation = CurTime() + wep:SequenceDuration()
		wep.SwapAnims = not wep.SwapAnims
	end
end

function SWEP:SecondaryAttack()
	if CurTime() < self:GetNextPrimaryFire() or CurTime() < self:GetNextSecondaryFire() then return end
	local owner = self.Owner
	local trace = owner:TraceLine(200, MASK_SOLID)
	if trace.Entity and trace.Entity:IsWorld()then
		self:SetSwingAnimTime(CurTime() + 1)
		self.Owner:DoAnimationEvent(ACT_RANGE_ATTACK2)
		self.Owner:EmitSound("npc/roller/mine/rmine_blades_out"..math.random(3)..".wav",75,60)
		self.Owner:SetSpeed(1)
		self:SetNextSecondaryFire(CurTime() + 14)
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	timer.Simple(0.6, function() DoSwing(owner, self) end)
	timer.Simple(0.75, function() DoPlaceTrap(owner) end)
	else 		
		if CurTime() >= self.NextMessage then
			self.NextMessage = CurTime() + 2
			owner:CenterNotify(COLOR_RED, "범위 안에 덫을 놓을 곳이 없다!")
		end 
	end
end
