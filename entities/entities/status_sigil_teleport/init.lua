AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:PlayerSet(pPlayer, bExists)
	if self:GetStartTime() == 0 then
		self:SetStartTime(CurTime())
	end
end

function ENT:GetSigilAngle(aimSigil)
	local owner = self:GetOwner()
	if not IsValid(owner) then return end
	return math.acos(owner:GetAimVector():Dot(((aimSigil:GetPos() + Vector(0,0,64)) - owner:EyePos()):GetNormalized()))
end

function ENT:GetAimSigil()
	local currentSigil = self:GetCurrentSigil()
	local sigils = ents.FindByClass("prop_obj_sigil")
	for k, v in ipairs(sigils) do if v == currentSigil then table.remove(sigils, k) end end
	table.sort(sigils, function(a, b) return self:GetSigilAngle(a) < self:GetSigilAngle(b) end)
	return sigils[1]
end

local function GhostProps(pl, newPos)
	local tempFilter = {pl}
	
	while true do
		local hitEnt = util.TraceEntity({
			start = newPos,
			endpos = newPos,
			filter = tempFilter,
			mask = MASK_PLAYERSOLID,
			collisiongroup = COLLISION_GROUP_PLAYER
		}, pl).Entity
		if not IsValid(hitEnt) then return end
		if hitEnt:GetMoveType() == MOVETYPE_VPHYSICS and hitEnt:GetClass() ~= "prop_obj_sigil" and not hitEnt:IsNailed() then
			hitEnt:GhostAllPlayersInMe(30, true)
		end
		table.insert(tempFilter, hitEnt)
	end
end

-- Set pos in hook, to prevent the position from being overwritten by something else
hook.Add("FinishMove", "SigilTeleporting", function(ply, mv)
	if ply.TeleportTo then
		ply:SetPos(ply.TeleportTo)
		ply:SetBarricadeGhosting(true)
		GhostProps(ply, ply.TeleportTo)
		
		ply.TeleportTo = nil
		return true
	end 
end)

local function sigilTeleport(status, owner, currentSigil)
	local sigil = status:GetAimSigil()
	if not sigil then return end
	
	local sigilPos = sigil:GetPos()
	
	owner:EmitSound("friends/friend_online.wav")
	
	owner.TeleportTo = sigilPos
end

function ENT:Think()
	if self.Removing then return end
	
	local owner = self:GetOwner()
	local sigil = self:GetCurrentSigil()
	local aimSigil = self:GetAimSigil()
	
	if self:GetDestSigil() ~= aimSigil then self:SetDestSigil(aimSigil) end
	
	if IsValid(sigil) and IsValid(owner) and owner:Alive() and owner:GetPos():Distance(sigil:GetPos() + Vector(0,0,64)) < (sigil.MaxDistance or 100) and not owner:KeyDown(IN_SPEED) and owner:Team() == TEAM_SURVIVORS then
		if not self.PlayedPreTelSound and CurTime() >= self:GetEndTime() - 2.2 then
			self.PlayedPreTelSound = true
			owner:EmitSound("ambient/levels/labs/teleport_preblast_suckin1.wav")
		end
		if CurTime() >= self:GetEndTime() then
			sigilTeleport(self, owner, sigil)
			self.Removing = true
			self:Remove()
		end
	else
		owner:EmitSound("items/medshotno1.wav")
		self.Removing = true
		self:Remove()
	end

	self:NextThink(CurTime())
	return true
end
