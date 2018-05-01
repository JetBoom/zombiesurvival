EFFECT.LifeTime = 1

function EFFECT:Init(data)
	self:SetAngles(Angle(0, math.Rand(0, 360), 0))
	self:SetModel("models/gibs/HGIBS.mdl")
	self:SetModelScale(2, 0)
	self:PhysicsInitSphere(4)

	self.LifeTime = math.Rand(3, 5)
	self.DieTime = CurTime() + self.LifeTime

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(true)
		phys:EnableGravity(false)
		phys:EnableDrag(true)
		phys:Wake()
		phys:SetDragCoefficient(200)
		phys:SetAngleDragCoefficient(9999999)
		phys:SetVelocityInstantaneous((data:GetNormal() + VectorRand()):GetNormalized() * math.Rand(10, 40))
	end
end

function EFFECT:Think()
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:AddVelocity(Vector(0, 0, 15 * FrameTime()))
	end

	return CurTime() < self.DieTime
end

local colGlow = Color(255, 0, 0)
local matGlow = Material("sprites/glow04_noz")
local vecEyeLeft = Vector(5, -3.5, 1)
local vecEyeRight = Vector(5, 3.5, 1)

function EFFECT:Render()
	local dt = math.Clamp((self.DieTime - CurTime()) / self.LifeTime, 0, 1) ^ 0.5

	render.SetBlend(dt)
	render.SetColorModulation(0.5, 0.5, 0.5)

	self:DrawModel()

	render.SetColorModulation(1, 1, 1)
	render.SetBlend(1)

	colGlow.a = dt * 255
	render.SetMaterial(matGlow)
	render.DrawSprite(self:LocalToWorld(vecEyeLeft), 8, 8, colGlow)
	render.DrawSprite(self:LocalToWorld(vecEyeRight), 8, 8, colGlow)
end
