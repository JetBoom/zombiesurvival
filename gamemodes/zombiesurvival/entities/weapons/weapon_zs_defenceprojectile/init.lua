AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self.Owner, self)

	self.IdleAnimation = CurTime() + self:SequenceDuration()

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
		owner:GiveStatus("ghost_defenceprojectile")
	end
end

function SWEP:RemoveGhost()
	local owner = self.Owner
	if owner and owner:IsValid() then
		owner:RemoveStatus("ghost_defenceprojectile", false, true)
	end
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	local owner = self.Owner

	local status = owner.status_ghost_defenceprojectile
	
	if not (status and status:IsValid()) then return end
	status:RecalculateValidity()
	if not status:GetValidPlacement() then return end

	local pos, ang = status:RecalculateValidity()
	if not pos or not ang then return end

	self:SetNextPrimaryAttack(CurTime() + self.Primary.Delay)

	local ent = ents.Create("prop_defenceprojectile")
	if ent:IsValid() then
		ent:SetPos(pos)
		ent:SetAngles(ang)
		ent:Spawn()
		ent:SetOwner(owner)

		ent:SetObjectOwner(owner)

		ent:EmitSound("npc/dog/dog_servo12.wav")

		ent:GhostAllPlayersInMe(5)

		self:TakePrimaryAmmo(1)

		local stored = owner:PopPackedItem(ent:GetClass())
		if stored then
			ent:SetObjectHealth(stored[1])
		end

		if not owner:HasWeapon("weapon_zs_defenceprojectile") then
			owner:Give("weapon_zs_defenceprojectile")
		end

		if self:GetPrimaryAmmoCount() <= 0 then
			owner:StripWeapon(self:GetClass())
		end
	end
end
