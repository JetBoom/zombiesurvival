AddCSLuaFile()

if _FIXEDEMITTERS_ or not CLIENT then return end
_FIXEDEMITTERS_ = true

local emitter3d, emitter2d
local ParticleEmitterOld = ParticleEmitter

function ParticleEmitter(vec, threedee)
	if threedee then
		if emitter3d == nil then
			emitter3d = ParticleEmitterOld(vec, true)
		else
			emitter3d:SetPos(vec)
		end

		return emitter3d
	end

	if emitter2d == nil then
		emitter2d = ParticleEmitterOld(vec)
	else
		emitter2d:SetPos(vec)
	end

	return emitter2d
end

local meta = FindMetaTable("CLuaEmitter")
if not meta then return end

local oldadd = meta.Add
function meta:Add(a, b, c)
	self:SetPos(b)

	return oldadd(self, a, b, c)
end
