INC_CLIENT()

ENT.NextEmit = 0

local matTrail = Material("cable/rope")
local matGlow = Material("sprites/light_glow02_add")

function ENT:Initialize()
	self.AmbientSound = CreateSound(self, "npc/strider/strider_skewer1.wav")
	self.Created = CurTime()
end

function ENT:Think()
	self.AmbientSound:PlayEx(1, 50 + math.min(1, CurTime() - self.Created) * 30)

	self:NextThink(CurTime())
	return true
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
end

local matWhite = Material("models/shiny")
local colGlow = Color(125, 10, 10, 120)
local colBeam = Color(75, 0, 0, 255)
function ENT:Draw()
	render.ModelMaterialOverride(matWhite)
	render.SetColorModulation(1, 0.5, 0.3)

	local hooked = self:GetParent():IsValid()

	if hooked then
		self:SetLocalPos(Vector(0, 0, -48))
	end

	self:DrawModel()

	if hooked then
		self:SetLocalPos(vector_origin)
	end

	render.SetColorModulation(1, 1, 1)
	render.ModelMaterialOverride(nil)

	local owner = self:GetOwner()
	if not owner:IsValid() then return end

	local handpos
	local hookpos = self:WorldSpaceCenter()

	if hooked then
		hookpos.z = hookpos.z - 48
	end

	local boneid = (owner ~= LocalPlayer() or owner:ShouldDrawLocalPlayer()) and owner:LookupBone("ValveBiped.Bip01_R_Hand")
	if boneid and boneid > 0 then
		local p, a = owner:GetBonePositionMatrixed(boneid)
		handpos = p
	else
		handpos = owner:WorldSpaceCenter()
	end

	self:SetRenderBoundsWS(handpos, hookpos, 128)

	render.SetMaterial(matTrail)
	render.DrawBeam(handpos, hookpos, 3, 4, 0, colBeam)

	render.SetMaterial(matGlow)
	render.DrawSprite(hookpos, 35, 35, colGlow)
	render.DrawSprite(handpos, 35, 35, colGlow)

	if CurTime() >= self.NextEmit and self:GetVelocity():LengthSqr() >= 256 then
		self.NextEmit = CurTime() + 0.06

		local emitter = ParticleEmitter(hookpos)
		emitter:SetNearClip(16, 24)

		for i = 1, 3 do
			local particle = emitter:Add("!sprite_bloodspray"..math.random(8), hookpos)
			particle:SetVelocity(VectorRand():GetNormalized() * math.Rand(12, 22))
			particle:SetDieTime(2)
			particle:SetStartAlpha(230)
			particle:SetEndAlpha(0)
			particle:SetStartSize(5)
			particle:SetEndSize(0)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-25, 25))
			particle:SetGravity(Vector(0, 0, -100))
			particle:SetColor(150, 0, 0)
		end

		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end
end
