INC_SERVER()

function ENT:Initialize()
	hook.Add("Move", self, self.Move)

	self:DrawShadow(false)

	local owner = self:GetOwner()
	if owner:IsValid() and owner:IsPlayer() then
		owner.status_human_holding = self

		owner:DrawWorldModel(false)

		local info = GAMEMODE:GetHandsModel(owner)
		if info then
			self:SetModel(info.model)
			self:SetSkin(info.skin)
			self:SetBodyGroups(info.body)
		end

		local wep = owner:GetActiveWeapon()
		if wep:IsValid() then
			wep:SendWeaponAnim(ACT_VM_HOLSTER)
			if wep.SetIronsights then
				wep:SetIronsights(false)
			end
		end
	else
		self:SetModel("models/weapons/c_arms_citizen.mdl")
	end

	local object = self:GetObject()
	if object:IsValid() then
		object.IgnoreMeleeTeam = TEAM_HUMAN
		object.IgnoreTraces = true
		object.IgnoreBullets = true

		for _, ent in pairs(ents.FindByClass("logic_pickupdrop")) do
			if ent.EntityToWatch == object:GetName() and ent:IsValid() then
				ent:Input("onpickedup", owner, object, "")
			end
		end

		for _, ent in pairs(ents.FindByClass("point_propnocollide")) do
			if ent:IsValid() and ent:GetProp() == object then
				ent:Remove()
			end
		end

		local objectphys = object:GetPhysicsObject()
		if objectphys:IsValid() then
			objectphys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
			objectphys:AddGameFlag(FVPHYSICS_NO_NPC_IMPACT_DMG)

			self:SetObjectMass(objectphys:GetMass())

			object.PreHoldCollisionGroup = object.PreHoldCollisionGroup or object:GetCollisionGroup()
			object.PreHoldAlpha = object.PreHoldAlpha or object:GetAlpha()
			object.PreHoldRenderMode = object.PreHoldRenderMode or object:GetRenderMode()

			objectphys:AddGameFlag(FVPHYSICS_PLAYER_HELD)
			object._OriginalMass = objectphys:GetMass()

			objectphys:EnableGravity(false)
			objectphys:SetMass(2)

			object:SetOwner(owner)
			object:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			object:SetRenderMode(RENDERMODE_TRANSALPHA)
			object:SetAlpha(180)

			self.StartX = owner.InputMouseX or 0
			self.StartY = owner.InputMouseY or 0

			local children = object:GetChildren()
			for _, child in pairs(children) do
				if not child:IsValid() then continue end

				child.PreHoldCollisionGroup = child.PreHoldCollisionGroup or child:GetCollisionGroup()
				if child:IsPhysicsModel() then -- Stops child sprites from getting fucked up rendering
					child.PreHoldAlpha = child.PreHoldAlpha or child:GetAlpha()
					child.PreHoldRenderMode = child.PreHoldRenderMode or child:GetRenderMode()

					child:SetAlpha(180)
					child:SetRenderMode(RENDERMODE_TRANSALPHA)
				end

				child:SetCollisionGroup(COLLISION_GROUP_WEAPON)
				child:CollisionRulesChanged()
			end

			object:CollisionRulesChanged()
		end
	end
end

local function DoubleCheck(object)
	if not IsValid(object) then return end

	for _, status in pairs(ents.FindByClass("status_human_holding")) do
		if status:IsValid() and not status.Removing and status:GetObject() == object then
			return
		end
	end

	object.IgnoreMeleeTeam = nil
	object.IgnoreTraces = nil
	object.IgnoreBullets = nil
end

function ENT:OnRemove()
	if self.Removing then return end
	self.Removing = true

	local owner = self:GetOwner()
	if owner:IsValid() then
		--owner.status_human_holding = nil

		owner:DrawWorldModel(true)

		if owner:Alive() and owner:Team() == TEAM_HUMAN then
			local wep = owner:GetActiveWeapon()
			if wep:IsValid() then
				wep:SendWeaponAnim(ACT_VM_DRAW)
			end
		end
	end

	local object = self:GetObject()
	if object:IsValid() then
		object.IgnoreMelee = nil
		object.IgnoreTraces = nil
		object.IgnoreBullets = nil

		timer.Simple(0.1, function() DoubleCheck(object) end)

		local objectphys = object:GetPhysicsObject()
		if objectphys:IsValid() then
			objectphys:ClearGameFlag(FVPHYSICS_PLAYER_HELD)
			objectphys:ClearGameFlag(FVPHYSICS_NO_IMPACT_DMG)
			objectphys:ClearGameFlag(FVPHYSICS_NO_NPC_IMPACT_DMG)
			objectphys:EnableGravity(true)
			if object._OriginalMass then
				objectphys:SetMass(object._OriginalMass)
				object._OriginalMass = nil
			end

			if not self:GetIsHeavy() then
				if not object:GhostAllPlayersInMe(4, true) then
					object:SetCollisionGroup(object.PreHoldCollisionGroup or COLLISION_GROUP_NONE)
				end
				object:SetAlpha(object.PreHoldAlpha or 255)
				object:SetRenderMode(object.PreHoldRenderMode or RENDERMODE_NORMAL)

				local children = object:GetChildren()
				for _, child in pairs(children) do
					if not child:IsValid() then continue end

					child:SetCollisionGroup(child.PreHoldCollisionGroup or COLLISION_GROUP_NONE)
					if child:IsPhysicsModel() then
						child:SetAlpha(child.PreHoldAlpha or 255)
						child:SetRenderMode(child.PreHoldRenderMode or RENDERMODE_NORMAL)
					end

					child:CollisionRulesChanged()
				end
			end

			object:SetOwner(NULL)
			object:CollisionRulesChanged()
		end

		object._LastDroppedBy = owner
		object._LastDropped = CurTime()

		for _, ent in pairs(ents.FindByClass("logic_pickupdrop")) do
			if ent.EntityToWatch == object:GetName() and ent:IsValid() then
				ent:Input("ondropped", owner, object, "")
			end
		end
	end
end

concommand.Add("_zs_rotateang", function(sender, command, arguments)
	local x = tonumbersafe(arguments[1])
	local y = tonumbersafe(arguments[2])

	if x and y then
		sender.InputMouseX = math.NormalizeAngle(x)--sender.InputMouseX + math.Clamp(x * 0.02, -180, 180)
		sender.InputMouseY = math.NormalizeAngle(y)--sender.InputMouseY + math.Clamp(y * 0.02, -180, 180)
	end
end)

local ShadowParams = {secondstoarrive = 0.01, maxangular = 1000, maxangulardamp = 10000, maxspeed = 500, maxspeeddamp = 1000, dampfactor = 0.65, teleportdistance = 0}
function ENT:Think()
	local ct = CurTime()

	local frametime = ct - (self.LastThink or ct)
	self.LastThink = ct

	local object = self:GetObject()
	local owner = self:GetOwner()
	if not object:IsValid() or object:IsNailed() or not owner:IsValid() or not owner:Alive() or owner:Team() ~= TEAM_HUMAN then
		self:Remove()
		return
	end

	local shootpos = owner:GetShootPos()
	local nearestpoint = object:NearestPoint(shootpos)

	local objectphys = object:GetPhysicsObject()
	if object:GetMoveType() ~= MOVETYPE_VPHYSICS or not objectphys:IsValid() or owner:GetGroundEntity() == object then
		self:Remove()
		return
	end

	if self:GetIsHeavy() then
		if self:GetHingePos():DistToSqr(self:GetPullPos()) >= 4096 then
			self:Remove()
			return
		end
	elseif nearestpoint:DistToSqr(shootpos) >= 4096 then
		self:Remove()
		return
	end

	objectphys:Wake()

	if owner:KeyPressed(IN_ATTACK) then
		object:SetPhysicsAttacker(owner)

		self:Remove()
		return
	elseif self:GetIsHeavy() then
		local pullpos = self:GetPullPos()
		local hingepos = self:GetHingePos()
		objectphys:ApplyForceOffset(objectphys:GetMass() * frametime * 450 * (pullpos - hingepos):GetNormalized(), hingepos)
	elseif owner:KeyDown(IN_ATTACK2) and not owner:GetActiveWeapon().NoPropThrowing then
		owner:ConCommand("-attack2")
		objectphys:ApplyForceCenter(objectphys:GetMass() * math.Clamp(1.25 - math.min(1, (object:OBBMins():Length() + object:OBBMaxs():Length()) / CARRY_DRAG_VOLUME), 0.25, 1) * 500 * owner:GetAimVector() * (owner.ObjectThrowStrengthMul or 1))
		object:SetPhysicsAttacker(owner)

		self:Remove()
		return
	else
		if not self.ObjectPosition or not owner:KeyDown(IN_SPEED) then
			local obbcenter = object:OBBCenter()
			local objectpos = shootpos + owner:GetAimVector() * 48
			objectpos = objectpos - obbcenter.z * object:GetUp()
			objectpos = objectpos + obbcenter.y * object:GetRight()
			objectpos = objectpos - obbcenter.x * object:GetForward()
			self.ObjectPosition = objectpos
			if not self.ObjectAngles then
				self.ObjectAngles = object:GetAngles()
			end
		end

		if owner:KeyDown(IN_SPEED) then
			if owner:KeyPressed(IN_SPEED) then
				self.ObjectAngles = object:GetAngles()
			end
		elseif owner:KeyDown(IN_WALK) then
			local xdiff = math.NormalizeAngle(self.StartX - (owner.InputMouseX or 0))
			local ydiff = math.NormalizeAngle(self.StartY - (owner.InputMouseY or 0))
			local sxdiff = xdiff * FrameTime() * 8
			local sydiff = ydiff * FrameTime() * 8

			self.ObjectAngles:RotateAroundAxis(owner:GetUp(), sxdiff)
			self.ObjectAngles:RotateAroundAxis(owner:GetRight(), sydiff)

			self.StartX = math.NormalizeAngle(self.StartX - (sxdiff))
			self.StartY = math.NormalizeAngle(self.StartY - (sydiff))
		end

		ShadowParams.pos = self.ObjectPosition
		ShadowParams.angle = self.ObjectAngles
		ShadowParams.deltatime = frametime
		objectphys:ComputeShadowControl(ShadowParams)
	end

	object:SetPhysicsAttacker(owner)
	object.LastHeld = CurTime()

	self:NextThink(ct)
	return true
end
