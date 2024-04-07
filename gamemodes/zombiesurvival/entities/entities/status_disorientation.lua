AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"

ENT.LifeTime = 3

ENT.Ephemeral = true

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	if CLIENT then
		hook.Add("CreateMove", self, self.CreateMove)
		hook.Add("RenderScreenspaceEffects", self, self.RenderScreenspaceEffects)

		self.Seed = math.Rand(0, 10)
	end

	local parent = self:GetParent()
	if parent:IsValid() and (SERVER or CLIENT and MySelf == parent) then
		parent:SetDSP(35)
	end

	self.DieTime = CurTime() + self.LifeTime
end

if SERVER then return end

function ENT:GetPower()
	return math.Clamp(self.DieTime - CurTime(), 0, 1)
end

function ENT:CreateMove(cmd)
	if MySelf ~= self:GetOwner() then return end

	local curtime = CurTime()
	local frametime = FrameTime()
	local power = self:GetPower()

	local ang = cmd:GetViewAngles()
	ang.pitch = math.Clamp(ang.pitch + math.sin(curtime) * 40 * frametime * power, -89, 89)
	ang.yaw = math.NormalizeAngle(ang.yaw + math.cos(curtime + self.Seed) * 50 * frametime * power)

	cmd:SetViewAngles(ang)
end

function ENT:RenderScreenspaceEffects()
	if MySelf ~= self:GetOwner() then return end

	local power = self:GetPower()

	DrawMotionBlur(0.1, power, 0.05)
end
