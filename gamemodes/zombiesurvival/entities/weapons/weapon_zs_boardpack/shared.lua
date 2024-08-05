SWEP.ViewModel = "models/weapons/v_aegiskit.mdl"
SWEP.WorldModel = "models/props_debris/wood_board06a.mdl"

SWEP.AmmoIfHas = true

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "SniperRound"
SWEP.Primary.Delay = 1
SWEP.Primary.DefaultClip = 7

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Ammo = "dummy"
SWEP.Secondary.Automatic = true
SWEP.Secondary.Delay = 0.15

SWEP.WalkSpeed = SPEED_NORMAL
SWEP.FullWalkSpeed = SPEED_SLOWEST

// 넓적판자 확률증가 딜레이
SWEP.INCREASE_BOARD_DELAY_KEY = "IncreaseBoardDelay"
SWEP.INCREASE_BOARD_DELAY = 45
// 마지막 판자 소환 시간
SWEP.LAST_BOARD_TIME_KEY = "LastBoardTime"

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "IncreaseBoardDelay")
	self:NetworkVar("Float", 1, "LastBoardTime")
end

SWEP.JunkModels = {
	Model("models/props_debris/wood_board04a.mdl"),
	Model("models/props_debris/wood_board02a.mdl"),
	Model("models/props_debris/wood_board01a.mdl"),
	Model("models/props_debris/wood_board07a.mdl"),
	Model("models/props_c17/furnituredrawer002a.mdl"),
	Model("models/props_c17/furnituredrawer003a.mdl"),
	Model("models/props_c17/furnituredrawer001a_chunk01.mdl"),
	Model("models/props_c17/furniturechair001a_chunk01.mdl"),
	Model("models/props_c17/furnituretable003a.mdl"),
	Model("models/props_c17/furniturechair001a.mdl"),
	Model("models/props_debris/wood_board06a.mdl")
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

	local curtime = CurTime()
	
	local aimvec = self.Owner:GetAimVector()
	local shootpos = self.Owner:GetShootPos()
	local tr = util.TraceLine({start = shootpos, endpos = shootpos + aimvec * 32, filter = self.Owner})

	self:SetNextPrimaryAttack(curtime + self.Primary.Delay)

	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(75, 80))

	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	if SERVER then
		self.Owner:RestartGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE)
	end
	self.IdleAnimation = curtime + math.min(self.Primary.Delay, self:SequenceDuration())

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
		
		if self:GetLastBoardTime() + self:GetIncreaseBoardDelay() <= CurTime() then
		
			local elapsedtime = CurTime() - (self:GetLastBoardTime() + self:GetIncreaseBoardDelay())
			
			while (elapsedtime >= 0) do
			
				table.remove(self.JunkModels, 1)
				table.insert(self.JunkModels, Model("models/props_debris/wood_board06a.mdl"))
				
				elapsedtime = elapsedtime - self:GetIncreaseBoardDelay()				
			end
			
			self:SetLastBoardTime(CurTime())
		end		
	end
end

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self.Owner, self)

	self.IdleAnimation = CurTime() + self:SequenceDuration()

	return true
end

util.PrecacheModel("models/props_debris/wood_board04a.mdl")
