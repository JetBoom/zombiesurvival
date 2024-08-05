AddCSLuaFile()

SWEP.Base = "weapon_zs_zombie"

SWEP.MeleeDelay = 0.25
SWEP.MeleeReach = 40
SWEP.MeleeDamage = 15
SWEP.Primary.Delay = 1.5
SWEP.DelayWhenDeployed = true

function SWEP:Reload()
	self:SecondaryAttack()
end

function SWEP:StartMoaning()
end

function SWEP:StopMoaning()
end

function SWEP:IsMoaning()
	return false
end
function SWEP:PlayAlertSound()
	self.Owner:EmitSound("npc/dog/dog_angry"..math.random(3)..".wav",55,180,0.7)
end
SWEP.PlayIdleSound = SWEP.PlayAlertSound

function SWEP:PlayAttackSound()
	self.Owner:EmitSound(math.random(2) == 1 and "npc/dog/dog_alarmed1.wav" or "npc/dog/dog_alarmed3.wav",55,180,0.8)
end
function SWEP:SendAttackAnim()
	if self.SwapAnims then
		self.Owner:GetViewModel():SetPlaybackRate(6)
		self:SendWeaponAnim(ACT_VM_HITCENTER)
	else
		self.Owner:GetViewModel():SetPlaybackRate(6)
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	end
	self.SwapAnims = not self.SwapAnims
end
function SWEP:ApplyMeleeDamage(ent, trace, damage)
	if ent:IsPlayer() then
		ent:TakeSpecialDamage(15, DMG_BURN, self.Owner, self, trace.HitPos)
	else
		local dmgtype, owner, hitpos = self.MeleeDamageType, self.Owner, trace.HitPos
		timer.Simple(0, function() -- Avoid prediction errors.
			if ent:IsValid() then
				ent:TakeSpecialDamage(30, dmgtype, owner, self, hitpos)
			end
		end)
	end
end
if not CLIENT then return end

function SWEP:ViewModelDrawn()
	render.ModelMaterialOverride(0)
end

local matSheet = Material("Models/Charple/Charple1_sheet")
function SWEP:PreDrawViewModel(vm)
	render.ModelMaterialOverride(matSheet)
end
