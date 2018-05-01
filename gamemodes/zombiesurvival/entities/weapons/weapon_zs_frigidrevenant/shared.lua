SWEP.Base = "weapon_zs_zombie"

SWEP.PrintName = "Frigid Revenant"

SWEP.MeleeDamage = 32

local Spread = {
	{0, 0},
	{-0.5, 0},
	{0.5, 0}
}
local function DoFleshThrow(pl, wep)
	if pl:IsValid() and pl:Alive() and wep:IsValid() then
		pl:ResetSpeed()
		pl.LastRangedAttack = CurTime()

		if SERVER then
			local startpos = pl:GetShootPos()
			local aimang = pl:EyeAngles()
			local ang

			for _, spr in pairs(Spread) do
				ang = Angle(aimang.p, aimang.y, aimang.r)
				ang:RotateAroundAxis(ang:Up(), spr[1] * 5)
				ang:RotateAroundAxis(ang:Right(), spr[2] * 5)

				local ent = ents.Create("projectile_ghoulfleshfr")
				if ent:IsValid() then
					ent:SetPos(startpos)
					ent:SetOwner(pl)
					ent:Spawn()

					local phys = ent:GetPhysicsObject()
					if phys:IsValid() then
						phys:SetVelocityInstantaneous(ang:Forward() * 750)
					end
				end
			end

			pl:EmitSound(string.format("physics/body/body_medium_break%d.wav", math.random(2, 4)), 72, math.Rand(85, 95))
		end
	end
end

function SWEP:SecondaryAttack()
	local owner = self:GetOwner()
	if CurTime() < self:GetNextPrimaryFire() or CurTime() < self:GetNextSecondaryFire() or IsValid(owner.FeignDeath) then return end

	self:SetNextSecondaryFire(CurTime() + 3)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	self:GetOwner():DoZombieEvent()
	self:EmitSound("npc/fast_zombie/leap1.wav", 74, math.Rand(110, 130))
	self:EmitSound(string.format("physics/body/body_medium_break%d.wav", math.random(2, 4)), 72, math.Rand(85, 95))
	self:SendWeaponAnim(ACT_VM_HITCENTER)
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	timer.Simple(0.7, function() DoFleshThrow(owner, self) end)
end

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

function SWEP:PlayHitSound()
	self:EmitSound("NPC_FastZombie.AttackHit", nil, nil, nil, CHAN_AUTO)
end

function SWEP:PlayMissSound()
	self:EmitSound("NPC_FastZombie.AttackMiss", nil, nil, nil, CHAN_AUTO)
end

function SWEP:PlayAttackSound()
	self:EmitSound("npc/zombie_poison/pz_warn"..math.random(2)..".wav", 70, math.random(140, 145), 0.65, CHAN_AUTO)
	self:EmitSound("npc/metropolice/pain"..math.random(4)..".wav", 74, math.Rand(125, 135), 0.65, CHAN_WEAPON + 20)
end

function SWEP:PlayIdleSound()
	self:GetOwner():EmitSound("npc/antlion/idle"..math.random(5)..".wav", 70, math.random(60, 66))
end

function SWEP:PlayAlertSound()
	self:GetOwner():EmitSound("npc/stalker/breathing3.wav", 70, math.random(80, 90))
end
