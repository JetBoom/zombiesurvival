AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"

ENT.DamageScale = 1.4

ENT.Model = Model("models/gibs/HGIBS.mdl")

ENT.Ephemeral = true

AccessorFuncDT(ENT, "Duration", "Float", 0)
AccessorFuncDT(ENT, "StartTime", "Float", 4)

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	self:SetModel(self.Model)
	self:DrawShadow(false)

	if SERVER then
		hook.Add("EntityTakeDamage", self, self.EntityTakeDamage)
		hook.Add("PlayerHurt", self, self.PlayerHurt)

		self:EmitSound("beams/beamstart5.wav", 65, 140)
	end

	if CLIENT then
		hook.Add("PrePlayerDraw", self, self.PrePlayerDraw)
		hook.Add("PostPlayerDraw", self, self.PostPlayerDraw)
		hook.Add("RenderScreenspaceEffects", self, self.RenderScreenspaceEffects)
	end
end

function ENT:PlayerSet()
	self:SetStartTime(CurTime())
end
