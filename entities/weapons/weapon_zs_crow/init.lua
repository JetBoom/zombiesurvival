INC_SERVER()

function SWEP:Deploy()
	self:GetOwner().SkipCrow = true
	return true
end

function SWEP:Holster()
	local owner = self:GetOwner()
	if owner:IsValid() then
		owner:StopSound("NPC_Crow.Flap")
		owner:SetAllowFullRotation(false)
	end
end
SWEP.OnRemove = SWEP.Holster

function SWEP:Think()
	local owner = self:GetOwner()

	local fullrot = not owner:OnGround()
	if owner:GetAllowFullRotation() ~= fullrot then
		owner:SetAllowFullRotation(fullrot)
	end

	if owner:IsOnGround() or not owner:KeyDown(IN_JUMP) or not owner:KeyDown(IN_FORWARD) then
		if self.PlayFlap then
			owner:StopSound("NPC_Crow.Flap")
			self.PlayFlap = nil
		end
	else
		if not self.PlayFlap then
			owner:EmitSound("NPC_Crow.Flap")
			self.PlayFlap = true
		end
	end

	local peckend = self:GetPeckEndTime()
	if peckend == 0 or CurTime() < peckend then return end
	self:SetPeckEndTime(0)

	local trace = owner:TraceLine(14, MASK_SOLID)
	local ent = NULL
	if trace.Entity then
		ent = trace.Entity
	end

	owner:ResetSpeed()

	if ent:IsValidLivingZombie() and ent:GetZombieClassTable().Name == "Crow" then -- Crows can team kill other crows as something to do.
		ent:TakeSpecialDamage(2, DMG_SLASH, owner, self)
	end
end

function SWEP:PrimaryAttack()
	if CurTime() < self:GetNextPrimaryFire() or not self:GetOwner():IsOnGround() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	self:GetOwner():EmitSound("NPC_Crow.Squawk")
	self:GetOwner().EatAnim = CurTime() + 2

	self:SetPeckEndTime(CurTime() + 1)

	self:GetOwner():SetSpeed(1)
end

function SWEP:SecondaryAttack()
	if CurTime() < self:GetNextSecondaryFire() then return end
	self:SetNextSecondaryFire(CurTime() + 1.6)

	self:GetOwner():EmitSound("NPC_Crow.Alert")
end

function SWEP:Reload()
	self:SecondaryAttack()
	return false
end
