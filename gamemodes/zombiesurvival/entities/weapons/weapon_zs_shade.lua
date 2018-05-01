AddCSLuaFile()

SWEP.Base = "weapon_zs_zombie"

SWEP.PrintName = "Shade"

SWEP.ViewModel = Model("models/weapons/v_fza.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

if CLIENT then
	SWEP.ViewModelFOV = 70
end

SWEP.Primary.Automatic = false
SWEP.Secondary.Automatic = false

SWEP.ShadeControl = "env_shadecontrol"
SWEP.ShadeProjectile = "projectile_shaderock"

function SWEP:Initialize()
	self:HideWorldModel()
end

function SWEP:Think()
end

function SWEP:PrimaryAttack()
	local owner = self:GetOwner()
	if CurTime() <= self:GetNextPrimaryFire() or (owner.ShadeShield and owner.ShadeShield:IsValid()) then return end

	for _, ent in pairs(ents.FindByClass(self.ShadeControl)) do
		if ent:IsValid() and ent:GetOwner() == owner then
			local obj = ent:GetParent()
			if obj:IsValid() then
				self:SetNextSecondaryFire(CurTime() + 0.65)

				owner:DoAttackEvent()

				if CLIENT then return end

				local vel = owner:GetAimVector() * 1000

				local phys = obj:GetPhysicsObject()
				if phys:IsValid() and phys:IsMoveable() and phys:GetMass() <= 300 then
					phys:Wake()
					phys:SetVelocity(vel)
					obj:SetPhysicsAttacker(owner)
					phys:AddGameFlag(FVPHYSICS_WAS_THROWN)

					obj:EmitSound(")weapons/physcannon/superphys_launch"..math.random(4)..".wav")
					obj.LastShadeLaunch = CurTime()
				end
			end

			ent:Remove()
		end
	end
end

function SWEP:CanGrab()
	local owner = self:GetOwner()
	if CurTime() <= self:GetNextSecondaryFire() or (owner.ShadeShield and owner.ShadeShield:IsValid()) then return end
	self:SetNextSecondaryFire(CurTime() + 0.1)

	if SERVER then
		for _, ent in pairs(ents.FindByClass(self.ShadeControl)) do
			if ent:IsValid() and ent:GetOwner() == owner then
				ent:Remove()
				return
			end
		end
	end

	return true
end

function SWEP:SecondaryAttack()
	if not self:CanGrab() then return end

	local owner = self:GetOwner()
	local ent = owner:CompensatedMeleeTrace(400, 4).Entity
	if ent:IsValid() and (ent:IsPhysicsModel() or ent.IsShadeGrabbable or ent.IsPhysbox) then
		self:SetNextPrimaryFire(CurTime() + 0.25)
		self:SetNextSecondaryFire(CurTime() + 0.4)

		if SERVER then
		local phys = ent:GetPhysicsObject()
		if phys:IsValid() and phys:IsMoveable() and phys:GetMass() <= 300 then
			for _, ent2 in pairs(ents.FindByClass(self.ShadeControl)) do
				if ent2:IsValid() and ent2:GetParent() == ent then
					ent2:Remove()
					return
				end
			end

			for _, status in pairs(ents.FindByClass("status_human_holding")) do
				if status:IsValid() and status:GetObject() == ent then
					status:Remove()
				end
			end

			local con = ents.Create(self.ShadeControl)
			if con:IsValid() then
				con:Spawn()
				con:SetOwner(owner)
				con:AttachTo(ent)

				ent:EmitSound(")weapons/physcannon/physcannon_claws_close.wav")
			end
		end
		end
	end
end

function SWEP:Reload()
	if not self:CanGrab() then return end

	local owner = self:GetOwner()

	local vStart = owner:GetShootPos()
	local vEnd = vStart + owner:GetForward() * 40

	local tr = util.TraceHull({start=vStart, endpos=vEnd, filter=owner, mins=owner:OBBMins()/2, maxs=owner:OBBMaxs()/2})
	self:SetNextPrimaryFire(CurTime() + 0.9)
	self:SetNextSecondaryFire(CurTime() + 0.9)

	if SERVER then
		local rock = ents.Create(self.ShadeProjectile)
		if rock:IsValid() then
			local pos = owner:GetPos() - owner:GetForward() * 5
			if not tr.Hit then
				pos = pos + owner:GetForward() * 30
			end

			rock:SetPos(pos)
			rock:SetOwner(owner)
			rock:Spawn()
			local con = ents.Create(self.ShadeControl)
			if con:IsValid() then
				con:Spawn()
				con:SetOwner(owner)
				con:AttachTo(rock)
				rock.Control = con

				util.ScreenShake(owner:GetPos(), 3, 1, 0.75, 400)

				con:EmitSound("physics/concrete/concrete_break3.wav", 85, 60)
				rock:EmitSound(")weapons/physcannon/physcannon_claws_close.wav")

				owner.LastRangedAttack = CurTime()
			end
		end
	end
end

function SWEP:OnRemove()
end

function SWEP:Holster()
end

if not CLIENT then return end

function SWEP:PreDrawViewModel(vm)
	local owner = self:GetOwner()
	if owner:IsValid() then
		owner:CallZombieFunction1("PreRenderEffects", vm)
	end
end

function SWEP:PostDrawViewModel(vm)
	local owner = self:GetOwner()
	if owner:IsValid() then
		owner:CallZombieFunction1("PostRenderEffects", vm)
	end
end
