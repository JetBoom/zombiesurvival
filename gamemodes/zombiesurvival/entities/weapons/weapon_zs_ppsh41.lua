AddCSLuaFile()
sound.Add(
{
    name = "Grub_Ppsh.Draw",
    channel = CHAN_STATIC,
    volume = 1.0,
    soundlevel = 80,
    sound = "Uni/draw.wav"
})
sound.Add(
{
    name = "Grub_PPSH.MagR",
    channel = CHAN_STATIC,
    volume = 1.0,
    soundlevel = 80,
    sound = "grub_ppsh/SMG_PPSH41_Foley_Click.wav"
})
sound.Add(
{
    name = "Grub_PPSH.Magout",
    channel = CHAN_STATIC,
    volume = 1.0,
    soundlevel = 80,
    sound = "grub_ppsh/SMG_PPSH_MagOut.wav"
})
sound.Add(
{
    name = "Grub_PPSH.Magin",
    channel = CHAN_STATIC,
    volume = 1.0,
    soundlevel = 80,
    sound = "grub_ppsh/SMG_PPSH_MagIn.wav"
})
sound.Add(
{
    name = "Grub_PPSH.Boltback",
    channel = CHAN_STATIC,
    volume = 1.0,
    soundlevel = 80,
    sound = "grub_ppsh/SMG_PPSH_Bolt_back.wav"
})
sound.Add(
{
    name = "Grub_PPSH.Boltreturn",
    channel = CHAN_STATIC,
    volume = 1.0,
    soundlevel = 80,
    sound = "grub_ppsh/SMG_PPSH_Bolt_click.wav"
})
sound.Add(
{
	name = "Weapon_PPSH.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 100,
	pitch = {110,120},
	sound = "grub_ppsh/ppsh41_shoot1.wav"
})
sound.Add(
{
	name = "Weapon_PPSH.MeleeSwing",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 100,
	pitch = {40,45},
	sound = "weapons/iceaxe/iceaxe_swing1.wav"
})

local Bash_Butt = {
	"physics/body/body_medium_impact_hard1.wav",
	"physics/body/body_medium_impact_hard2.wav",
	"physics/body/body_medium_impact_hard3.wav",
	"physics/body/body_medium_impact_hard4.wav",
	"physics/body/body_medium_impact_hard5.wav",
	"physics/body/body_medium_impact_hard6.wav"
}
local Bash_Miss = { 
	"physics/metal/weapon_impact_hard1.wav",
	"physics/metal/weapon_impact_hard2.wav",
	"physics/metal/weapon_impact_hard3.wav"
}

if CLIENT then
	SWEP.PrintName = "'Shpagina' SMG"
	SWEP.Description = "보조 공격으로 개머리판 공격을 할 수 있다."
	SWEP.Slot = 2
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 75
	
	SWEP.HUD3DBone = "sov_ppsh"
	SWEP.HUD3DPos = Vector(14.215, -1.484, 1.562)
	SWEP.HUD3DAng = Angle(0, -90, 90)
	SWEP.HUD3DScale = 0.025
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "smg"
SWEP.MeleeHoldType = "melee2"

SWEP.ViewModel	= "models/weapons/c_ppsh_stick.mdl"
SWEP.WorldModel	= "models/weapons/w_grub_ppsh_stick.mdl"
SWEP.UseHands = true
SWEP.Primary.Damage = 18
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.09
SWEP.TracerName = "Tracer"
SWEP.Primary.ClipSize = 35
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
GAMEMODE:SetupDefaultClip(SWEP.Primary)
SWEP.BloodDecal = "Blood"
SWEP.Primary.Recoil = 5

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Damage = 50
SWEP.Secondary.Delay = 2
SWEP.MeleeRange = 60
SWEP.MeleeSize = 1.7
SWEP.MeleeKnockBack = 80
SWEP.IsMelee = nil

SWEP.Primary.Sound = Sound("Weapon_PPSH.Single")
SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SMG1

SWEP.ConeMax = 0.2
SWEP.ConeMin = 0.05

SWEP.WalkSpeed = SPEED_NORMAL
SWEP.ReloadSound = Sound("Grub_PPSH.Magout")
local sound_int = false
local sound_end = false
	
function SWEP:Reload()
	self:SetHoldType( self.HoldType ) 
	if self.Owner:IsHolding() then return end

	if self:GetIronsights() then
		self:SetIronsights(false)
	end

	if self:GetNextReload() <= CurTime() and self:DefaultReload(ACT_VM_RELOAD) then
		self.IdleAnimation = CurTime() + self:SequenceDuration()
		self:SetNextReload(self.IdleAnimation)

		self.Owner:DoReloadEvent()
		if self.ReloadSound then
			self:EmitSound(self.ReloadSound)
		end
	end
end
function SWEP:PrimaryAttack()
	self:SetHoldType( self.HoldType ) 
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay*0.5)
	self:EmitFireSound()
	self:TakeAmmo()
	self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
	--self:MuzzleFlash()
	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:SecondaryAttack()
	if not self.Owner:KeyDown(IN_ATTACK) then 
	self:SetHoldType( self.MeleeHoldType ) 
	self.IsMelee = true
	self.Owner:DoAttackEvent()
	timer.Create( "holdtypereset", 1, 1, function() if self.Owner:IsValid() then self:SetHoldType( self.HoldType ) end end )
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	self:SetNextPrimaryFire(CurTime() + self.Secondary.Delay*0.5)
	self:EmitSound("Weapon_PPSH.MeleeSwing")
	self.Owner:GetViewModel():SetPlaybackRate(2)
	self.Weapon:SendWeaponAnim( ACT_IDLE_ANGRY_MELEE )
	local owner = self.Owner
	local filter = owner:GetMeleeFilter()
	owner:LagCompensation(true)
	timer.Create( "dohit", 0.41, 1, function()
	local tr = owner:MeleeTrace(self.MeleeRange, self.MeleeSize, filter)
	if tr.Hit then
		local damagemultiplier = (owner.BuffMuscular and owner:Team()==TEAM_HUMAN) and 1.2 or 1
		local damage = self.Secondary.Damage * damagemultiplier
		local hitent = tr.Entity
		local hitflesh = tr.MatType == MAT_FLESH or tr.MatType == MAT_BLOODYFLESH or tr.MatType == MAT_ANTLION or tr.MatType == MAT_ALIENFLESH
		if hitflesh then
			util.Decal(self.BloodDecal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
			self.Owner:EmitSound(Sound(table.Random(Bash_Butt)))	
			if SERVER and not (hitent:IsValid() and hitent:IsPlayer() and hitent:Team() == owner:Team()) then
				util.Blood(tr.HitPos, math.Rand(damage * 0.25, damage * 0.6), (tr.HitPos - owner:GetShootPos()):GetNormalized(), math.Rand(damage * 6, damage * 12), true)
			end
			if not self.NoHitSoundFlesh then
				self.Owner:EmitSound(Sound(table.Random(Bash_Butt)))
				self.Owner:EmitSound(Sound(table.Random(Bash_Miss)))
			end
		else
				self.Owner:EmitSound(Sound(table.Random(Bash_Butt)))
				self.Owner:EmitSound(Sound(table.Random(Bash_Miss)))
		end

		if self.OnMeleeHit and self:OnMeleeHit(hitent, hitflesh, tr) then
			owner:LagCompensation(false)
			return
		end

		if SERVER and hitent:IsValid() then
			damage = self.Secondary.Damage * damagemultiplier
			if hitent:GetClass() == "func_breakable_surf" then
				hitent:Fire("break", "", 0.01)
			else
				local dmginfo = DamageInfo()
				dmginfo:SetDamagePosition(tr.HitPos)
				dmginfo:SetDamage(damage)
				dmginfo:SetAttacker(owner)
				dmginfo:SetInflictor(self)
				dmginfo:SetDamageType(DMG_CLUB)
				if hitent:IsPlayer() then
					hitent:MeleeViewPunch(damage)
					if hitent:IsHeadcrab() then
						damage = damage * 2
						dmginfo:SetDamage(damage)
					end
					gamemode.Call("ScalePlayerDamage", hitent, tr.HitGroup, dmginfo)
					hitent:ThrowFromPositionSetZ(tr.HitPos, self.MeleeKnockBack, nil, true)
				end

				if hitent:IsPlayer() then
					hitent:TakeDamageInfo(dmginfo)
				else
					timer.Simple(0, function()
						if hitent:IsValid() then
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
		self.IdleAnimation = CurTime() + self:SequenceDuration()
		if self.PostOnMeleeMiss then self:PostOnMeleeMiss(tr) end
	end
	end )
	self.IsMelee = false
	owner:LagCompensation(false)
end
end