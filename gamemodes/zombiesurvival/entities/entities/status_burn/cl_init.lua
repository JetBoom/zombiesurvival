INC_CLIENT()

local function GetRandomBonePos(pl)
	if pl ~= MySelf or pl:ShouldDrawLocalPlayer() then
		local bone = pl:GetBoneMatrix(math.random(0,25))
		if bone then
			return bone:GetTranslation()
		end
	end

	return pl:GetShootPos()
end

function ENT:Draw()
	local ent = self:GetOwner()
	if not ent:IsValid() then return end
	
	local pos
	if ent == MySelf and not ent:ShouldDrawLocalPlayer() then
		local aa, bb = ent:WorldSpaceAABB()
		pos = Vector(math.Rand(aa.x, bb.x), math.Rand(aa.y, bb.y), math.Rand(aa.z, bb.z))
	else
		pos = GetRandomBonePos(ent)
	end

	local emitter = ParticleEmitter(self:GetPos())
	emitter:SetNearClip(24, 32)
	
	for i = 1, 2 do
		local particle = emitter:Add("sprites/flamelet"..math.random(4), pos + VectorRand():GetNormalized() * 2)
		particle:SetDieTime(math.Rand(0.2, 0.5))
		particle:SetStartSize(5)
		particle:SetEndSize(10)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetVelocity(ent:GetVelocity())
		particle:SetAirResistance(32)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1.5, 1.5))
	end
	
	emitter:Finish()
end
