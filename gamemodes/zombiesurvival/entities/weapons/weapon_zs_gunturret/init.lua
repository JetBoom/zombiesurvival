INC_SERVER()

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self:GetOwner(), self)

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
	local owner = self:GetOwner()
	if owner and owner:IsValid() then
		owner:GiveStatus(self.GhostStatus)
	end
end

function SWEP:RemoveGhost()
	local owner = self:GetOwner()
	if owner and owner:IsValid() then
		owner:RemoveStatus(self.GhostStatus, false, true)
	end
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	local owner = self:GetOwner()

	local status = owner:GetStatus(self.GhostStatus)
	if not (status and status:IsValid()) then return end
	status:RecalculateValidity()
	if not status:GetValidPlacement() then return end

	local pos, ang = status:RecalculateValidity()
	if not pos or not ang then return end

	self:SetNextPrimaryAttack(CurTime() + self.Primary.Delay)

	local channel = GAMEMODE:GetFreeChannel(self.Channel)
	if channel == -1 then
		owner:SendLua("surface.PlaySound(\"buttons/button8.wav\")")
		owner:CenterNotify(COLOR_RED, translate.ClientGet(owner, "no_free_channel"))
		return
	end

	local ent = ents.Create(self.DeployClass)
	if ent:IsValid() then
		ent:SetPos(pos)
		ent:SetAngles(ang)
		ent.PreOwn = owner
		ent:Spawn()

		ent:SetObjectOwner(owner)
		ent:SetChannel(channel)

		ent:EmitSound("npc/dog/dog_servo12.wav")

		--ent:GhostAllPlayersInMe(5)

		self:TakePrimaryAmmo(1)

		local stored = owner:PopPackedItem(ent:GetClass())
		if stored then
			ent:SetObjectHealth(stored[1])
		end

		local ammo = math.min(owner:GetAmmoCount(self.TurretAmmoType), self.TurretAmmoStartAmount)
		ent:SetAmmo(ammo)
		owner:RemoveAmmo(ammo, self.TurretAmmoType)

		ent.TurretDeployableAmmo = self.Primary.Ammo
		ent.Damage = self.Primary.Damage
		ent.Spread = self.TurretSpread
		ent.SWEP = self:GetClass()

		if not owner:HasWeapon("weapon_zs_gunturretcontrol") then
			owner:Give("weapon_zs_gunturretcontrol")
		end
		owner:SelectWeapon("weapon_zs_gunturretcontrol")

		if self:GetPrimaryAmmoCount() <= 0 then
			owner:StripWeapon(self:GetClass())
		end
	end
end
