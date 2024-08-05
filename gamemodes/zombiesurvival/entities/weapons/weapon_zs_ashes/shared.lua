SWEP.Base = "weapon_zs_zombie"

SWEP.MeleeReach = 48
SWEP.MeleeDelay = 0.7
SWEP.MeleeSize = 1.5
SWEP.MeleeDamage = 5
SWEP.MeleeDamageType = DMG_SLASH
SWEP.MeleeAnimationDelay = 0.1
SWEP.FrozenWhileSwinging = false
SWEP.NextMessage = 0
SWEP.Primary.Delay = 1.7
SWEP.ViewModel = "models/Weapons/v_zombiearms.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
function SWEP:CheckMoaning()
end
function SWEP:PrimaryAttack()
	if CurTime() < self:GetNextPrimaryFire() or IsValid(self.Owner.FeignDeath) then return end

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	self:StartSwinging()
end
function SWEP:SendAttackAnim()
	if self.SwapAnims then
		self:SendWeaponAnim(ACT_VM_HITCENTER)
	else
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	end
	self.SwapAnims = not self.SwapAnims
end
function SWEP:ApplyMeleeDamage(ent, trace, damage)
	if ent:IsPlayer() then
		ent:TakeSpecialDamage(damage, self.MeleeDamageType, self.Owner, self, trace.HitPos)
		if SERVER then
			local status = ent:GetStatus("branded")
			if status and status:IsValid() then
				
			else
				ent:GiveStatus("branded")	
			end
		end
	else
		local dmgtype, owner, hitpos = self.MeleeDamageType, self.Owner, trace.HitPos
		timer.Simple(0, function() -- Avoid prediction errors.
			if ent:IsValid() then
				ent:TakeSpecialDamage(damage, dmgtype, owner, self, hitpos)
			end
		end)
	end

end
function SWEP:StopMoaningSound()
end

function SWEP:StartMoaningSound()
end

function SWEP:PlayHitSound()
	self.Owner:EmitSound("npc/zombie/claw_strike"..math.random(3)..".wav", 75, 80)
end

function SWEP:PlayMissSound()
	self.Owner:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 75, 80)
end

function SWEP:PlayAttackSound()
	self.Owner:EmitSound(math.random(2) == 1 and "npc/dog/dog_alarmed1.wav" or "npc/dog/dog_alarmed3.wav",75,120,0.8)
end


function SWEP:SetSwingAnimTime(time)
	self:SetDTFloat(3, time)
end

function SWEP:GetSwingAnimTime()
	return self:GetDTFloat(3)
end

function SWEP:StartSwinging()
	self.BaseClass.StartSwinging(self)
	self:SetSwingAnimTime(CurTime() + 0.5)
end
