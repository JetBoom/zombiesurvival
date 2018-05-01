AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:AddEffects(bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL, EF_PARENT_ANIMATES))
	self:SetRenderMode(RENDERMODE_TRANSALPHA)

	local pPlayer = self:GetOwner()
	if pPlayer:IsValid() then
		pPlayer.status_overridemodel = self
		if SERVER and pPlayer:Team() ~= TEAM_UNDEAD or not pPlayer:GetZombieClassTable().NoHideMainModel then
			pPlayer:SetRenderMode(RENDERMODE_NONE)
		end
	end
end

function ENT:PlayerSet(pPlayer, bExists)
	if SERVER and pPlayer:Team() ~= TEAM_UNDEAD or not pPlayer:GetZombieClassTable().NoHideMainModel then
		pPlayer:SetRenderMode(RENDERMODE_NONE)
	end
end

function ENT:OnRemove()
	local pPlayer = self:GetOwner()
	if SERVER and pPlayer:IsValid() then
		pPlayer:SetRenderMode(RENDERMODE_NORMAL)
	end
end

function ENT:Think()
end

if CLIENT then
	function ENT:Draw()
		local owner = self:GetOwner()
		if owner:IsValid() and (not owner:IsPlayer() or owner:Alive()) then
			local pcolor = owner:GetColor()
			if owner.SpawnProtection then
				pcolor.a = (0.02 + (CurTime() + self:EntIndex() * 0.2) % 0.05) * 255
				pcolor.r = 0
				pcolor.b = 0
				pcolor.g = 255
				render.SuppressEngineLighting(true)
			end
			self:SetColor(pcolor)

			if not (owner.SpawnProtection and owner:GetZombieClassTable().NoHideMainModel) then
				if not owner:CallZombieFunction1("PrePlayerDrawOverrideModel", self) then
					self:DrawModel()

					owner:CallZombieFunction1("PostPlayerDrawOverrideModel", self)
				end
			end

			if owner.SpawnProtection then
				render.SuppressEngineLighting(false)
			end
		end
	end
	ENT.DrawTranslucent = ENT.Draw
end
