AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	-- We don't touch DieTime: the base Initialize sets it to 0, and SetDie
	-- will then correctly set the actual death time.

	-- Seed is used somewhere — leave it as it was.
	self.Seed = math.Rand(0, 10)

	-- On the SERVER, GetOwner() is still NULL here (owner is set later,
	-- in SetPlayer). On the CLIENT — it's already the actual player (owner is networked),
	-- which is why the visual green tint on bosses is enabled here.
	-- We also cache _owner for OnRemove.
	local owner = self:GetOwner()
	if IsValid(owner) then
		self._owner = owner
		owner.SpawnProtection = true
	end
end

function ENT:PlayerSet(pl)
	-- Called both on initial spawn and on reapplication
	-- (SetPlayer(pl, true)) — pl is always guaranteed to be valid here.
	if IsValid(pl) then
		self._owner = pl
		pl.SpawnProtection = true
	end
end

function ENT:OnRemove()
	local owner = self._owner
	if IsValid(owner) then
		owner.SpawnProtection = false
	end

	self.BaseClass.OnRemove(self)
end

function ENT:SetDie(fTime)
	if fTime == 0 or not fTime then
		self.DieTime = 0
	elseif fTime == -1 then
		self.DieTime = 999999999
	elseif self.DieTime < CurTime() + fTime then
		self.DieTime = CurTime() + fTime
	end
end