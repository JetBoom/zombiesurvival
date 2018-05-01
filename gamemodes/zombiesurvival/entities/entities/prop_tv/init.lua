INC_SERVER()

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModel("models/props_c17/tv_monitor01.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end

	self:SetMaxObjectHealth(self.MaxHealth)
	self:SetObjectHealth(self:GetMaxObjectHealth())

	self.Viewers = {}
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(3, health)

	if health <= 0 and not self.Destroyed then
		self.Destroyed = true

		self:EmitSound("npc/manhack/gib.wav")

		local ent = ents.Create("prop_physics")
		if ent:IsValid() then
			ent:SetPos(self:WorldSpaceCenter())
			ent:SetAngles(self:GetAngles())
			ent:SetModel("models/manhack.mdl")
			ent:Spawn()

			ent:Fire("break")
			ent:Fire("kill", "", 0.05)
		end

		if self:GetObjectOwner():IsValidLivingHuman() then
			self:GetObjectOwner():SendDeployableLostMessage(self)
		end

		self:Remove()
	end
end

function ENT:AltUse(activator, tr)
	self:PackUp(activator)
end

function ENT:OnPackedUp(pl)
	pl:GiveEmptyWeapon(self.SWEP)
	pl:GiveAmmo(1, "tv")

	pl:PushPackedItem(self:GetClass(), self:GetObjectHealth())

	self:Remove()
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)

	if dmginfo:GetDamage() <= 0 then return end

	local attacker = dmginfo:GetAttacker()
	if not (attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN) then
		self:ResetLastBarricadeAttacker(attacker, dmginfo)
		self:SetObjectHealth(self:GetObjectHealth() - dmginfo:GetDamage())
	end
end

function ENT:CycleCamera(activator)
	local cameras = {}

	for _, camera in pairs(ents.FindByClass("prop_camera")) do
		if camera:IsValid() then
			table.insert(cameras, camera)
		end
	end

	if #cameras == 0 then return end

	local index
	for i, camera in pairs(cameras) do
		if activator.Camera == camera then
			index = i
			break
		end
	end

	if not index or #cameras == 1 then
		activator.Camera = cameras[1]
		return
	end

	activator.Camera = cameras[index + 1] or cameras[1]
end

function ENT:Use(activator, caller)
	if activator:Team() ~= TEAM_HUMAN or not activator:Alive() then return end

	local owner = self:GetObjectOwner()
	if not owner:IsValid() then
		self:SetObjectOwner(activator)
		self:GetObjectOwner():SendDeployableClaimedMessage(self)
		return
	end

	self:CycleCamera(activator)

	if activator.Camera and activator.Camera:IsValid() then
		self:EmitSound("npc/scanner/combat_scan3.wav", 50, 250)

		self.Viewers[activator] = true

		hook.Add("SetupPlayerVisibility", self, function(tv)
			if not tv.Viewers[activator] or not activator.Camera:IsValid() then return end

			AddOriginToPVS(activator.Camera:WorldSpaceCenter())
		end)

		net.Start("zs_tvcamera")
			net.WriteEntity(activator.Camera)
		net.Send(activator)
	end
end

function ENT:SetMaxObjectHealth(health)
	self:SetDTInt(1, health)
end

function ENT:ClearObjectOwner()
	self:SetObjectOwner(NULL)
end

function ENT:SetObjectOwner(ent)
	self:SetDTEntity(1, ent)
end
