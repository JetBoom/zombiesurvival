util.PrecacheModel("models/props/cs_italy/orange.mdl")

EFFECT.LifeTime = 2

function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local angles = data:GetAngles()

	self.Offset = data:GetStart()
	self.Ent = data:GetEntity()

	sound.Play("weapons/fx/rics/ric"..math.random(5)..".wav", pos, 68, math.Rand(150, 170))

	self.Entity:SetModel("models/props/cs_italy/orange.mdl")
	self.Entity:SetMoveType(MOVETYPE_NONE)
	self.Entity:SetModelScale(2, 0)
	self.Entity:SetAngles(angles)

	if self.Ent:IsValid() then
		local offset = self.Ent:LocalToWorld(self.Offset)

		local emitter = ParticleEmitter(offset)
		emitter:SetNearClip(24, 32)

		for i=1, 2 do
			local particle = emitter:Add("sprites/glow04_noz", offset)
			particle:SetDieTime(1)
			particle:SetColor(90,130,255)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetStartSize(4)
			particle:SetEndSize(15)
			particle:SetVelocity((angles:Up() + VectorRand()):GetNormal() * 300)
			particle:SetGravity(VectorRand() * 20 + Vector(0, 0, -400))
			particle:SetCollide(true)
			particle:SetBounce(0.75)
			particle:SetAirResistance(12)
		end
		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end

	self.DieTime = CurTime() + self.LifeTime
end

function EFFECT:Think()
	return CurTime() < self.DieTime
end

local matRefract = Material("models/spawn_effect")
function EFFECT:Render()
	local ent = self.Ent
	if ent:IsValid() then
		self:SetPos(ent:LocalToWorld(self.Offset))
	end

	render.UpdateRefractTexture()
	matRefract:SetFloat("$refractamount", math.Clamp((self.DieTime - CurTime()) / self.LifeTime, 0, 1) ^ 2 * 0.05)

	render.ModelMaterialOverride(matRefract)

	self.Entity:DrawModel()

	render.ModelMaterialOverride(0)
end
