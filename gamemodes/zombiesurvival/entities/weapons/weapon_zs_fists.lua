AddCSLuaFile()

SWEP.PrintName = "Fists"

if GAMEMODE.ZombieEscape then
	SWEP.WalkSpeed = SPEED_ZOMBIEESCAPE_NORMAL
else
	SWEP.WalkSpeed = SPEED_NORMAL
end

SWEP.IsMelee = true

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/c_arms_citizen.mdl"
SWEP.WorldModel	= ""

SWEP.Damage = 5
SWEP.UppercutDamageMultiplier = 3
SWEP.HitDistance = 40

SWEP.ViewModelFOV = 52

SWEP.AutoSwitchFrom = true

SWEP.NoMagazine = true
SWEP.Undroppable = true
SWEP.NoPickupNotification = true

SWEP.Primary.Ammo = "none"
SWEP.Secondary.Ammo = "none"

local SwingSound = Sound( "weapons/slam/throw.wav" )
local HitSound = Sound( "Flesh.ImpactHard" )

function SWEP:Initialize()
	--self:SetWeaponHoldType("normal")
	self:SetWeaponHoldType("fist")
end

function SWEP:PreDrawViewModel(vm, wep, pl)
	vm:SetMaterial("engine/occlusionproxy")
end

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "NextMeleeAttack")
	self:NetworkVar("Float", 1, "NextIdle")
	self:NetworkVar("Float", 2, "NextIdleHoldType")
	self:NetworkVar("Int", 2, "Combo")
end

function SWEP:UpdateNextIdle()
	local vm = self.Owner:GetViewModel()
	self:SetNextIdle( CurTime() + vm:SequenceDuration() )
end

function SWEP:PrimaryAttack(right)
	--self:SetWeaponHoldType("fist")
	self:SetNextIdleHoldType(CurTime() + 2)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.WalkSpeed = 165
	self.Owner:ResetSpeed()

	local anim = "fists_left"
	if ( right ) then anim = "fists_right" end
	if ( self:GetCombo() >= 2 ) then
		anim = "fists_uppercut"
	end

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )

	self:EmitSound( SwingSound )

	self:UpdateNextIdle()
	self:SetNextMeleeAttack( CurTime() + 0.2 )
	
	self:SetNextPrimaryFire( CurTime() + 0.9 )
	self:SetNextSecondaryFire( CurTime() + 0.9 )
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack( true )
end

function SWEP:DealDamage()
	local owner = self.Owner
	local shootpos = owner:GetShootPos()
	local aimvector = owner:GetAimVector()
	local anim = self:GetSequenceName(owner:GetViewModel():GetSequence())
	local filter = owner:GetMeleeFilter()

	owner:LagCompensation( true )
	
	local tr = util.TraceLine( {
		start = shootpos,
		endpos = shootpos + aimvector * self.HitDistance,
		filter = filter
	} )

	if not IsValid( tr.Entity ) then 
		tr = util.TraceHull( {
			start = shootpos,
			endpos = shootpos + aimvector * self.HitDistance,
			filter = filter,
			mins = Vector( -3, -3, -3 ),
			maxs = Vector( 3, 3, 3 )
		} )
	end

	local hitent = tr.Entity

	-- We need the second part for single player because SWEP:Think is ran shared in SP.
	if tr.Hit and not ( game.SinglePlayer() and CLIENT ) then
		self:EmitSound( HitSound )
	end

	local hit = false
	local hitplayer = false

	if SERVER and IsValid( hitent ) then
		hitplayer = hitent:IsNPC() or hitent:IsPlayer()

		local dmginfo = DamageInfo()
		dmginfo:SetAttacker(IsValid(owner) and owner or self)
		dmginfo:SetInflictor(self)
		dmginfo:SetDamageType(DMG_CLUB)
		dmginfo:SetDamagePosition(tr.HitPos)
		if anim == "fists_uppercut" then
			dmginfo:SetDamage(self.Damage * self.UppercutDamageMultiplier)
		else
			dmginfo:SetDamage(self.Damage)
		end

		if hitent:IsPlayer() and hitent:WouldDieFrom(dmginfo:GetDamage(), dmginfo:GetDamagePosition()) then
			if anim == "fists_left" then
				dmginfo:SetDamageForce(owner:GetRight() * 4912 + owner:GetForward() * 9998)
			elseif anim == "fists_right" then
				dmginfo:SetDamageForce(owner:GetRight() * -4912 + owner:GetForward() * 9989)
			elseif anim == "fists_uppercut" then
				dmginfo:SetDamageForce(owner:GetUp() * 5158 + owner:GetForward() * 10012)
			end
		end

		hitent:TakeDamageInfo( dmginfo )
		hit = true
	end

	if SERVER and IsValid( hitent ) and hitent:GetMoveType() == MOVETYPE_VPHYSICS then
		local phys = hitent:GetPhysicsObject()
		if IsValid( phys ) then
			phys:ApplyForceOffset( aimvector * 2000, tr.HitPos )
			hitent:SetPhysicsAttacker(owner)
		end
	end

	if SERVER then
		if hitplayer and anim ~= "fists_uppercut" then
			self:SetCombo( self:GetCombo() + 1 )
		else
			self:SetCombo( 0 )
		end
	end

	owner:LagCompensation(false)
end

function SWEP:OnRemove()
	if CLIENT and self.Owner:IsValid() and self.Owner:IsPlayer() then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then vm:SetMaterial("") end
	end
end

function SWEP:Holster(wep)
	if CurTime() >= self:GetNextPrimaryFire() then
		self:OnRemove()

		return true
	end

	return false
end

function SWEP:Deploy()
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_draw"))
	
	self:UpdateNextIdle()
	
	if SERVER then
		self:SetCombo(0)
	end
	self.Owner:ResetSpeed()
	return true
end

function SWEP:Think()
	local vm = self.Owner:GetViewModel()
	local curtime = CurTime()
	local idletime = self:GetNextIdle()
	local idle_holdtype_time = self:GetNextIdleHoldType()

	if idle_holdtype_time > 0 and curtime >= idle_holdtype_time then
		--self:SetWeaponHoldType("normal")
		self:SetNextIdleHoldType(0)
		if GAMEMODE.ZombieEscape then 
			self.WalkSpeed = SPEED_ZOMBIEESCAPE_NORMAL
		else
			self.WalkSpeed = SPEED_NORMAL
		end
		self.Owner:ResetSpeed()
	end
	
	if idletime > 0 and curtime >= idletime then
		vm:SendViewModelMatchingSequence( vm:LookupSequence("fists_idle_0"..math.random(2)))

		self:UpdateNextIdle()
	end
	
	local meleetime = self:GetNextMeleeAttack()
	
	if meleetime > 0 and curtime >= meleetime then
		self:DealDamage()
		self:SetNextMeleeAttack( 0 )
	end
	
	if SERVER and curtime >= self:GetNextPrimaryFire() + 0.1 then
		self:SetCombo( 0 )
	end
end

if not CLIENT then return end

function SWEP:DrawWeaponSelection(...)
	return self:BaseDrawWeaponSelection(...)
end

function SWEP:GetViewModelPosition(pos, ang)
	pos = pos - ang:Up() * 3

	return pos, ang
end
