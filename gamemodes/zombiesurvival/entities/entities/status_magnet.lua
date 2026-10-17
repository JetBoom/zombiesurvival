AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"

ENT.Radius = 400

if CLIENT then return end

ENT.Classes = table.ToAssoc(
	{"prop_ammo", "prop_invitem", "prop_weapon"}
)
ENT.Force = 50
ENT.ForceDelay = 0.25

-- If the object is already flying toward us — WorldVisible isn't needed: physics will
-- pull it in anyway. Tracing is the most expensive part of this Think.
local FAST_ENOUGH_SQR = 1000   -- ~31 units/s

function ENT:Think()
	local owner = self:GetOwner()
	if not IsValid(owner) then return end

	if owner:Team() == TEAM_UNDEAD then
		self:Remove()
		return
	end

	local activeweapon = owner:GetActiveWeapon()
	if not activeweapon:IsValid() or not activeweapon.IsMagnet then
		self:NextThink(CurTime() + self.ForceDelay)
		return true
	end

	local pos      = self:GetPos()
	local classes  = self.Classes
	local force    = self.Force
	local curtime  = CurTime()
	local radius   = self.Radius

	for _, ent in pairs(ents.FindInSphere(pos, radius)) do
		if not ent:IsValid() then continue end

		if not classes[ent:GetClass()] then continue end

		local phys = ent:GetPhysicsObject()
		if not phys:IsValid() or not phys:IsMoveable() then continue end

		if ent.NoPickupsOwner and ent.NoPickupsOwner ~= owner then continue end
		if ent.DroppedTime and ent.DroppedTime + 4 >= curtime then continue end

		local nearest = ent:NearestPoint(pos)
		local vel     = phys:GetVelocity()

		-- It's already moving toward us pretty fast — we're skipping the trace.
		if vel:LengthSqr() < FAST_ENOUGH_SQR and not WorldVisible(pos, nearest) then
			continue
		end

		local dir = (pos - nearest):GetNormalized()
		phys:ApplyForceCenter(phys:GetMass() * force * dir)
		ent:SetPhysicsAttacker(owner, 4)

		if (ent:GetPos() - pos):LengthSqr() <= 5600 and ent.GiveToActivator then
			ent:GiveToActivator(owner)
		end
	end

	self:NextThink(curtime + self.ForceDelay)
	return true
end