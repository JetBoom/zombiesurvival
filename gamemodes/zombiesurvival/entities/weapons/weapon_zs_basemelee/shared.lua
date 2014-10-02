if SERVER then
	AddCSLuaFile("shared.lua")
	AddCSLuaFile("cl_init.lua")
	AddCSLuaFile("animations.lua")
end

SWEP.ViewModel = "models/weapons/v_axe/v_axe.mdl"
SWEP.WorldModel = "models/weapons/w_axe.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 1

SWEP.MeleeDamage = 30
SWEP.MeleeRange = 65
SWEP.MeleeSize = 1.5
SWEP.MeleeKnockBack = 0

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.WalkSpeed = SPEED_FAST

SWEP.IsMelee = true

SWEP.HoldType = "melee"
SWEP.SwingHoldType = "grenade"

SWEP.DamageType = DMG_SLASH

SWEP.BloodDecal = "Blood"
SWEP.HitDecal = "Impact.Concrete"

SWEP.HitAnim = ACT_VM_HITCENTER
SWEP.MissAnim = ACT_VM_MISSCENTER

SWEP.SwingTime = 0
SWEP.SwingRotation = Angle(0, 0, 0)
SWEP.SwingOffset = Vector(0, 0, 0)

function SWEP:Initialize()
	self:SetDeploySpeed(1.1)
	self:SetWeaponHoldType(self.HoldType)
	self:SetWeaponSwingHoldType(self.SwingHoldType)

	if CLIENT then
		self:Anim_Initialize()
	end
end

function SWEP:SetWeaponSwingHoldType(t)
	local old = self.ActivityTranslate
	self:SetWeaponHoldType(t)
	local new = self.ActivityTranslate
	self.ActivityTranslate = old
	self.ActivityTranslateSwing = new
end

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self.Owner, self)
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	return true
end

function SWEP:Think()
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end

	if self:IsSwinging() and self:GetSwingEnd() <= CurTime() then
		self:StopSwinging()
		self:MeleeSwing()
	end

	--[[if CLIENT then
		self:Anim_Think()
	end]]
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
	return false
end

function SWEP:CanPrimaryAttack()
	if self.Owner:IsHolding() or self.Owner:GetBarricadeGhosting() then return false end

	return self:GetNextPrimaryFire() <= CurTime() and not self:IsSwinging()
end

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
end

function SWEP:PlayStartSwingSound()
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/golf club/golf_hit-0"..math.random(4)..".ogg")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	if self.SwingTime == 0 then
		self:MeleeSwing()
	else
		self:StartSwinging()
	end
end

function SWEP:Holster()
	if CurTime() >= self:GetSwingEnd() then
		if CLIENT then
			self:Anim_Holster()
		end

		return true
	end

	return false
end

function SWEP:StartSwinging()
	if self.StartSwingAnimation then
		self:SendWeaponAnim(self.StartSwingAnimation)
		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end
	self:PlayStartSwingSound()
	self:SetSwingEnd(CurTime() + self.SwingTime)
end

function SWEP:MeleeSwing()
	local owner = self.Owner

	owner:DoAttackEvent()

	local filter = owner:GetMeleeFilter()

	owner:LagCompensation(true)

	local tr = owner:MeleeTrace(self.MeleeRange, self.MeleeSize, filter)
	if tr.Hit then
		local damagemultiplier = owner.BuffMuscular and 1.2 or 1
		local damage = self.MeleeDamage * damagemultiplier
		local hitent = tr.Entity
		local hitflesh = tr.MatType == MAT_FLESH or tr.MatType == MAT_BLOODYFLESH or tr.MatType == MAT_ANTLION or tr.MatType == MAT_ALIENFLESH

		if self.HitAnim then
			self:SendWeaponAnim(self.HitAnim)
		end
		self.IdleAnimation = CurTime() + self:SequenceDuration()

		if hitflesh then
			util.Decal(self.BloodDecal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
			self:PlayHitFleshSound()
			if SERVER and not (hitent:IsValid() and hitent:IsPlayer() and hitent:Team() == owner:Team()) then
				util.Blood(tr.HitPos, math.Rand(damage * 0.25, damage * 0.6), (tr.HitPos - owner:GetShootPos()):GetNormalized(), math.Rand(damage * 6, damage * 12), true)
			end
			if not self.NoHitSoundFlesh then
				self:PlayHitSound()
			end
		else
			util.Decal(self.HitDecal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
			self:PlayHitSound()
		end

		if self.OnMeleeHit and self:OnMeleeHit(hitent, hitflesh, tr) then
			owner:LagCompensation(false)
			return
		end

		if SERVER and hitent:IsValid() then
			damage = self.MeleeDamage * damagemultiplier

			if hitent:GetClass() == "func_breakable_surf" then
				hitent:Fire("break", "", 0.01) -- Delayed because no way to do prediction.
			else
				local dmginfo = DamageInfo()
				dmginfo:SetDamagePosition(tr.HitPos)
				dmginfo:SetDamage(damage)
				dmginfo:SetAttacker(owner)
				dmginfo:SetInflictor(self)
				dmginfo:SetDamageType(self.DamageType)
				dmginfo:SetDamageForce(self.MeleeDamage * 20 * owner:GetAimVector())
				if hitent:IsPlayer() then
					hitent:MeleeViewPunch(damage)
					if hitent:IsHeadcrab() then
						damage = damage * 2
						dmginfo:SetDamage(damage)
					end
					gamemode.Call("ScalePlayerDamage", hitent, tr.HitGroup, dmginfo)

					if self.MeleeKnockBack > 0 then
						hitent:ThrowFromPositionSetZ(tr.HitPos, self.MeleeKnockBack, nil, true)
					end
				end

				if hitent:IsPlayer() then
					hitent:TakeDamageInfo(dmginfo)
				else
					-- Again, no way to do prediction.
					timer.Simple(0, function()
						if hitent:IsValid() then
							-- Workaround for propbroken not calling.
							local h = hitent:Health()

							hitent:TakeDamageInfo(dmginfo)

							if hitent:Health() <= 0 and h ~= hitent:Health() then
								gamemode.Call("PropBroken", hitent, owner)
							end

							local phys = hitent:GetPhysicsObject()
							if hitent:GetMoveType() == MOVETYPE_VPHYSICS and phys:IsValid() and phys:IsMoveable() then
								hitent:SetPhysicsAttacker(owner)
							end
						end
					end)
				end
			end
		end

		if self.PostOnMeleeHit then self:PostOnMeleeHit(hitent, hitflesh, tr) end
	else
		if self.MissAnim then
			self:SendWeaponAnim(self.MissAnim)
		end
		self.IdleAnimation = CurTime() + self:SequenceDuration()
		self:PlaySwingSound()

		if self.PostOnMeleeMiss then self:PostOnMeleeMiss(tr) end
	end

	owner:LagCompensation(false)
end

function SWEP:StopSwinging()
	self:SetSwingEnd(0)
end

function SWEP:IsSwinging()
	return self:GetSwingEnd() > 0
end

function SWEP:SetSwingEnd(swingend)
	self:SetDTFloat(0, swingend)
end

function SWEP:GetSwingEnd()
	return self:GetDTFloat(0)
end

local ActIndex = {
	[ "pistol" ] 		= ACT_HL2MP_IDLE_PISTOL,
	[ "smg" ] 			= ACT_HL2MP_IDLE_SMG1,
	[ "grenade" ] 		= ACT_HL2MP_IDLE_GRENADE,
	[ "ar2" ] 			= ACT_HL2MP_IDLE_AR2,
	[ "shotgun" ] 		= ACT_HL2MP_IDLE_SHOTGUN,
	[ "rpg" ]	 		= ACT_HL2MP_IDLE_RPG,
	[ "physgun" ] 		= ACT_HL2MP_IDLE_PHYSGUN,
	[ "crossbow" ] 		= ACT_HL2MP_IDLE_CROSSBOW,
	[ "melee" ] 		= ACT_HL2MP_IDLE_MELEE,
	[ "slam" ] 			= ACT_HL2MP_IDLE_SLAM,
	[ "normal" ]		= ACT_HL2MP_IDLE,
	[ "fist" ]			= ACT_HL2MP_IDLE_FIST,
	[ "melee2" ]		= ACT_HL2MP_IDLE_MELEE2,
	[ "passive" ]		= ACT_HL2MP_IDLE_PASSIVE,
	[ "knife" ]			= ACT_HL2MP_IDLE_KNIFE,
	[ "duel" ]      = ACT_HL2MP_IDLE_DUEL
}

function SWEP:SetWeaponHoldType( t )

	t = string.lower( t )
	local index = ActIndex[ t ]
	
	if ( index == nil ) then
		Msg( "SWEP:SetWeaponHoldType - ActIndex[ \""..t.."\" ] isn't set! (defaulting to normal)\n" )
		t = "normal"
		index = ActIndex[ t ]
	end

	self.ActivityTranslate = {}
	self.ActivityTranslate [ ACT_MP_STAND_IDLE ] 				= index
	self.ActivityTranslate [ ACT_MP_WALK ] 						= index+1
	self.ActivityTranslate [ ACT_MP_RUN ] 						= index+2
	self.ActivityTranslate [ ACT_MP_CROUCH_IDLE ] 				= index+3
	self.ActivityTranslate [ ACT_MP_CROUCHWALK ] 				= index+4
	self.ActivityTranslate [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= index+5
	self.ActivityTranslate [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] = index+5
	self.ActivityTranslate [ ACT_MP_RELOAD_STAND ]		 		= index+6
	self.ActivityTranslate [ ACT_MP_RELOAD_CROUCH ]		 		= index+6
	self.ActivityTranslate [ ACT_MP_JUMP ] 						= index+7
	self.ActivityTranslate [ ACT_RANGE_ATTACK1 ] 				= index+8
	self.ActivityTranslate [ ACT_MP_SWIM_IDLE ] 				= index+8
	self.ActivityTranslate [ ACT_MP_SWIM ] 						= index+9
	
	-- "normal" jump animation doesn't exist
	if t == "normal" then
		self.ActivityTranslate [ ACT_MP_JUMP ] = ACT_HL2MP_JUMP_SLAM
	end
	
	-- these two aren't defined in ACTs for whatever reason
	if t == "knife" || t == "melee2" then
		self.ActivityTranslate [ ACT_MP_CROUCH_IDLE ] = nil
	end
end

SWEP:SetWeaponHoldType("pistol")

function SWEP:TranslateActivity( act )
	if self:GetSwingEnd() ~= 0 and self.ActivityTranslateSwing[act] then
		return self.ActivityTranslateSwing[act] or -1
	end

	return self.ActivityTranslate and self.ActivityTranslate[act] or -1
end
