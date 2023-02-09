INC_SERVER()

function ENT:Initialize()
	local mins, maxs = Vector(-56, -8, -1), Vector(8, 8, 115)

	self:SetModel("models/props_doors/door01_dynamic.mdl")
	self:PhysicsInitBox(mins, maxs)
	self:SetCollisionBounds(mins, maxs)
	self:SetUseType(SIMPLE_USE)

	self:SetTrigger(true)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end

	self:SetCreationTime(CurTime())

	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

	local ent = ents.Create("point_worldhint")
	if ent:IsValid() then
		ent:SetPos(self:LocalToWorld(Vector(-24, 0, 2)))
		ent:SetParent(self)
		ent:Spawn()
		ent:SetViewable(TEAM_HUMAN)
		ent:SetRange(0)
		ent:SetTranslated(true)
		ent:SetHint("prop_obj_exit_h")
	end

	ent = ents.Create("point_worldhint")
	if ent:IsValid() then
		ent:SetPos(self:LocalToWorld(Vector(-24, 0, 2)))
		ent:SetParent(self)
		ent:Spawn()
		ent:SetViewable(TEAM_UNDEAD)
		ent:SetRange(0)
		ent:SetTranslated(true)
		ent:SetHint("prop_obj_exit_z")
	end

	--[[ent = ents.Create("env_projectedtexture")
	if ent:IsValid() then
		ent:SetPos(self:GetPos() + self:GetUp() * 8)
		ent:SetAngles(self:GetRight():Angle())
		ent:SetKeyValue("enableshadows", 0)
		ent:SetKeyValue("farz", 600)
		ent:SetKeyValue("nearz", 2)
		ent:SetKeyValue("lightfov", 70)
		ent:SetKeyValue("lightcolor", "220 240 255 255")
		ent:SetKeyValue("appearance", 5)
		ent:SetParent(self)
		ent:Spawn()
		ent:Input("SpotlightTexture", NULL, NULL, "effects/flashlight001")
		self.SpotLight = ent
	end]]
end

function ENT:Use(activator)
	self:OnUse(activator)
end

function ENT:StartTouch(ent)
	self:OnUse(ent)
end

function ENT:OnUse(activator)
	if activator:IsPlayer() and activator:Alive() and activator:Team() == TEAM_HUMAN and self:GetOpenStartTime() == 0 and self:GetRise() == 1 then
		self:SetOpenStartTime(CurTime())
		self:EmitSound("plats/hall_elev_door.wav")
	end
end

function ENT:Touch(ent)
	if ent:IsPlayer() and ent:Team() == TEAM_HUMAN and ent:Alive() and ent:GetObserverMode() == OBS_MODE_NONE and self:IsOpened() then
		local pos = ent:EyePos()

		ent:Spectate(OBS_MODE_ROAMING)
		ent:SpectateEntity(self)
		ent:StripWeapons()
		ent:GodEnable()
		ent:SetMoveType(MOVETYPE_NOCLIP)

		ent:SetPos(pos)

		gamemode.Call("OnPlayerWin", ent)

		--ent:PrintMessage(HUD_PRINTTALK, "You've managed to survive! Waiting for other survivors...")
		net.Start("zs_survivor")
			net.WriteEntity(ent)
		net.Broadcast()
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end
