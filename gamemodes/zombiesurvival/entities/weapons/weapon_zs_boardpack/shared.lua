SWEP.ViewModel = "models/weapons/v_aegiskit.mdl"
SWEP.WorldModel = "models/props_debris/wood_board06a.mdl"

SWEP.AmmoIfHas = true

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "SniperRound"
SWEP.Primary.Delay = 1
SWEP.Primary.DefaultClip = 3

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Ammo = "dummy"
SWEP.Secondary.Automatic = true
SWEP.Secondary.Delay = 0.15

SWEP.WalkSpeed = SPEED_NORMAL
SWEP.FullWalkSpeed = SPEED_SLOWEST

SWEP.JunkModels = {
	Model("models/props_debris/wood_board04a.mdl"),
	Model("models/props_debris/wood_board06a.mdl"),
	Model("models/props_debris/wood_board02a.mdl"),
	Model("models/props_debris/wood_board01a.mdl"),
	Model("models/props_debris/wood_board07a.mdl"),
	Model("models/props_c17/furnituredrawer002a.mdl"),
	Model("models/props_c17/furnituredrawer003a.mdl"),
	Model("models/props_c17/furnituredrawer001a_chunk01.mdl"),
	Model("models/props_c17/furniturechair001a_chunk01.mdl"),
	Model("models/props_c17/furnituredrawer001a_chunk02.mdl"),
	Model("models/props_c17/furnituretable003a.mdl"),
	Model("models/props_c17/furniturechair001a.mdl")
}

function SWEP:SetReplicatedAmmo(count)
	self:SetDTInt(0, count)
end

function SWEP:GetReplicatedAmmo()
	return self:GetDTInt(0)
end

function SWEP:GetWalkSpeed()
	if self:GetPrimaryAmmoCount() > 0 then
		return self.FullWalkSpeed
	end
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	local aimvec = self.Owner:GetAimVector()
	local shootpos = self.Owner:GetShootPos()
	local tr = util.TraceLine({start = shootpos, endpos = shootpos + aimvec * 32, filter = self.Owner})

	self:SetNextPrimaryAttack(CurTime() + self.Primary.Delay)

	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(75, 80))

	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:RestartGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE)
	self.IdleAnimation = CurTime() + math.min(self.Primary.Delay, self:SequenceDuration())

	if SERVER then
		local ent = ents.Create("prop_physics")
		if ent:IsValid() then
			local ang = aimvec:Angle()
			ang:RotateAroundAxis(ang:Forward(), 90)
			ent:SetPos(tr.HitPos)
			ent:SetAngles(ang)
			ent:SetModel(table.Random(self.JunkModels))
			ent:Spawn()
			ent:SetHealth(350)
			ent.NoVolumeCarryCheck = true
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:SetMass(math.min(phys:GetMass(), 50))
				phys:SetVelocityInstantaneous(self.Owner:GetVelocity())
			end
			ent:SetPhysicsAttacker(self.Owner)
			self:TakePrimaryAmmo(1)
		end
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:CanPrimaryAttack()
	if self.Owner:IsHolding() or self.Owner:GetBarricadeGhosting() then return false end

	if math.abs(self.Owner:GetVelocity().z) >= 256 then return false end

	if self:GetPrimaryAmmoCount() <= 0 then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		return false
	end

	return true
end

function SWEP:Think()
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end

	if SERVER then
		local count = self:GetPrimaryAmmoCount()
		if count ~= self:GetReplicatedAmmo() then
			self:SetReplicatedAmmo(count)
			self.Owner:ResetSpeed()
		end
	end
end

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self.Owner, self)

	self.IdleAnimation = CurTime() + self:SequenceDuration()

	return true
end

util.PrecacheModel("models/props_debris/wood_board04a.mdl")
