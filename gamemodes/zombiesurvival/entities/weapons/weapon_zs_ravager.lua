AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "구울"
end

SWEP.Base = "weapon_zs_zombie"
SWEP.ViewModel = Model("models/weapons/v_pza.mdl")
SWEP.ViewModelFOV = 47
SWEP.MeleeDamage = 30
SWEP.MeleeForceScale = 3.5
SWEP.SlowDownScale = 2
SWEP.MeleeDelay = 0.74
SWEP.Primary.Delay = 2
--SWEP.MeleeForceScale = 0.1
--SWEP.SlowDownScale = 2.25
SWEP.SlowDownImmunityTime = 2
SWEP.MeleeAnimationDelay = 0.35
function SWEP:ApplyMeleeDamage(ent, trace, damage)
	ent:PoisonDamage(damage, self.Owner, self, trace.HitPos)
	if SERVER and ent:IsNailed() then
		local status = ents.Create("status_weakbarricade")
		if status:IsValid() then
			status:SetOwner(ent)
			status:Spawn()
		end
	end
end

function SWEP:Reload()
	self.BaseClass.SecondaryAttack(self)
end

function SWEP:PlayAlertSound()
	self.Owner:EmitSound("npc/barnacle/barnacle_die1.wav", 75, math.Rand(90, 120))
end
SWEP.PlayIdleSound = SWEP.PlayAlertSound

function SWEP:PlayAttackSound()
	self.Owner:EmitSound("npc/antlion_guard/angry"..math.random(1,3)..".wav", 77, math.Rand(80, 110))
end

local function DoFleshThrow(pl, wep)
	if pl:IsValid() and pl:Alive() and wep:IsValid() then
		pl:ResetSpeed()

		if SERVER then
			local startpos = pl:GetShootPos()
			local aimang = pl:EyeAngles()

			for i=1, 4 do
				local ang = Angle(aimang.p, aimang.y, aimang.r)
				ang:RotateAroundAxis(ang:Up(), math.Rand(-8, 8))
				ang:RotateAroundAxis(ang:Right(), math.Rand(-8, 8))

				local ent = ents.Create("projectile_poisonflesh")
				if ent:IsValid() then
					ent:SetPos(startpos)
					ent:SetOwner(pl)
					ent:Spawn()

					local phys = ent:GetPhysicsObject()
					if phys:IsValid() then
						phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(320, 380))
					end
				end
			end

			pl:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(85, 95))
		end

		if CurTime() >= (pl.GhoulImmunity or 0) then
			pl.GhoulImmunity = CurTime() + 2
			pl:RawCapLegDamage(CurTime() + 2)
		end
	end
end

function SWEP:SecondaryAttack()
	local owner = self.Owner
	if CurTime() < self:GetNextPrimaryFire() or CurTime() < self:GetNextSecondaryFire() or IsValid(owner.FeignDeath) then return end

	self:SetNextSecondaryFire(CurTime() + 3)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	self.Owner:DoAttackEvent()
	self:EmitSound("npc/fast_zombie/leap1.wav", 74, math.Rand(110, 130))
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(85, 95))
	self.Owner:RawCapLegDamage(CurTime() + 3)
	self:SendWeaponAnim(ACT_VM_HITCENTER)
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	timer.Simple(0.7, function() DoFleshThrow(owner, self) end)
end

if not CLIENT then return end

function SWEP:ViewModelDrawn()
	render.ModelMaterialOverride(0)
end

local matSheet = Material("Models/Barnacle/barnacle_sheet")
function SWEP:PreDrawViewModel(vm)
	render.ModelMaterialOverride(matSheet)
end
