AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.LifeTime = 60

ENT.Model = Model("models/humans/charple03.mdl")

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	self:SetModel(self.Model)
	self:DrawShadow(false)
	if SERVER then
		hook.Add("PlayerCanBeHealed", self, self.PlayerCanBeHealed)
		hook.Add("Move", self, self.Move)
		hook.Add("PostPlayerDeath",self,self.PostPlayerDeath)
		self:EmitSound("ambient/energy/whiteflash.wav", 85, 120)
	end

	if CLIENT then
		hook.Add("PrePlayerDraw", self, self.PrePlayerDraw)
		hook.Add("PostPlayerDraw", self, self.PostPlayerDraw)
		hook.Add("RenderScreenspaceEffects", self, self.RenderScreenspaceEffects)
	end

	self.DieTime = CurTime() + self.LifeTime
end

function ENT:Move(pl, move)
	if pl ~= self:GetOwner() then return end
	if pl:GetBarricadeGhosting() then
		move:SetMaxSpeed(move:GetMaxSpeed()*0.2)
		move:SetMaxClientSpeed(move:GetMaxClientSpeed()*0.2)
	end
	if pl:Health() <= pl:GetMaxHealth() * 0.4 then
		move:SetMaxSpeed(move:GetMaxSpeed()*0.5)
		move:SetMaxClientSpeed(move:GetMaxClientSpeed()*0.5)
	end
end
function ENT:PostPlayerDeath(pl)
	if pl ~= self:GetOwner() then return end
	self:Remove()
end
function ENT:PlayerCanBeHealed(pl)
	if pl ~= self:GetOwner() then return end
	return false
end

if not CLIENT then return end

function ENT:PrePlayerDraw(pl)
	if pl ~= self:GetOwner() then return end
	render.SetColorModulation(0.3,0.3,0.3)
end

function ENT:DrawTranslucent()
	local owner = self:GetOwner()
	if not owner:IsValid() then return end

	render.SetColorModulation(0, 0, 0)
	render.SetBlend(self:GetPower() * 0.95)
	render.SuppressEngineLighting(true)

	self:SetRenderOrigin(owner:GetPos() + Vector(0, 0, owner:OBBMaxs().z-10 + math.abs(math.sin(CurTime() * 2))))
	self:SetRenderAngles(Angle(0, CurTime() * 270, 0))
	self:SetModelScale(0.5, 0)
	
	self:DrawModel()
	
	render.SuppressEngineLighting(false)
	render.SetBlend(1)
	render.SetColorModulation(1, 1, 1)
end

function ENT:GetPower()
	return math.Clamp(self.DieTime - CurTime(), 0, 1)
end
function ENT:PostPlayerDraw(pl)
	if pl ~= self:GetOwner() then return end
	render.SetColorModulation(1, 1, 1)
end
function ENT:RenderScreenspaceEffects()
	if LocalPlayer() ~= self:GetOwner() then return end

	DrawSharpen( 1.1, 1.8 )
end