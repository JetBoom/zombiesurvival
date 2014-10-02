AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self.Owner, self)

	self:SpawnGhost()

	return true
end

function SWEP:OnRemove()
	self:RemoveGhost()
end

function SWEP:Holster()
	self:RemoveGhost()
	return true
end

function SWEP:SpawnGhost()
	local owner = self.Owner
	if owner and owner:IsValid() then
		owner:GiveStatus("ghost_detpack")
	end
end

function SWEP:RemoveGhost()
	local owner = self.Owner
	if owner and owner:IsValid() then
		owner:RemoveStatus("ghost_detpack", false, true)
	end
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	local owner = self.Owner

	local status = owner.status_ghost_detpack
	if not (status and status:IsValid()) then return end
	status:RecalculateValidity()
	if not status:GetValidPlacement() then return end

	local pos, ang, entity = status:RecalculateValidity()
	if not pos or not ang then return end

	self:SetNextPrimaryAttack(CurTime() + self.Primary.Delay)

	local ent = ents.Create("prop_detpack")
	if ent:IsValid() then
		ent:SetPos(pos)
		ent:SetAngles(ang)
		ent:Spawn()
		if entity and entity:IsValid() then
			ent:SetParent(entity)
		end

		ent:EmitSound("weapons/c4/c4_plant.wav")

		self:TakePrimaryAmmo(1)

		ent:SetOwner(self.Owner)

		if self:GetPrimaryAmmoCount() <= 0 then
			owner:StripWeapon(self:GetClass())
		end

		if not owner:HasWeapon("weapon_zs_detpackremote") then
			owner:Give("weapon_zs_detpackremote")
		end
		owner:SelectWeapon("weapon_zs_detpackremote")
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Think()
	local count = self:GetPrimaryAmmoCount()
	if count ~= self:GetReplicatedAmmo() then
		self:SetReplicatedAmmo(count)
		self.Owner:ResetSpeed()
	end
end
