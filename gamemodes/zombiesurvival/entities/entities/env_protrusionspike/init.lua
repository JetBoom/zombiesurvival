INC_SERVER()

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModel("models/props_wasteland/rockcliff06d.mdl")
	self:SetMaterial("models/shadertest/shader2")
	self:SetColor(Color(30, 150, 255, 255))
	self:PhysicsInit(SOLID_NONE)

	self:Explode()

	self:Fire("kill", "", 0.75)
end

function ENT:Explode()
	local pos = self:GetPos()
	local owner = self:GetOwner()
	local rad = 36

	for _, ent in pairs(util.BlastAlloc(self, owner, pos + Vector(0, 0, rad), rad)) do
		if ent:IsValidLivingZombie() and gamemode.Call("PlayerShouldTakeDamage", ent, owner) and ent ~= owner then
			ent:TakeSpecialDamage(self.Damage or 113.4, DMG_DROWN, owner, self, pos)
			ent:AddLegDamageExt(18, owner, self, SLOWTYPE_COLD)
		end
	end
end
