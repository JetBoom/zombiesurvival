AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:AddEffects(bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL, EF_PARENT_ANIMATES))
	self:SetRenderMode(RENDERMODE_NORMAL)

	local pPlayer = self:GetOwner()
	if IsValid(pPlayer) then
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
	if SERVER and IsValid(pPlayer) then
		pPlayer:SetRenderMode(RENDERMODE_NORMAL)
	end
end

function ENT:Think()
end

if CLIENT then
	function ENT:Draw()
		local owner = self:GetOwner()
		if not IsValid(owner) then return end
		if owner:IsPlayer() and not owner:Alive() then return end

		local spawnProt = owner.SpawnProtection
		local r, g, b
		local suppressLighting = false
		local blend = 1

		if spawnProt then
			blend = 0.02 + (CurTime() + self:EntIndex() * 0.2) % 0.05
			r, g, b = 0, 255, 0
			suppressLighting = true
			render.SuppressEngineLighting(true)
		else
			local pcolor = owner:GetColor()
			r, g, b = pcolor.r, pcolor.g, pcolor.b

			local MySelf = LocalPlayer()
			if IsValid(MySelf) and owner ~= MySelf and owner:Team() == MySelf:Team() then
				local radius = GAMEMODE.TransparencyRadius
				if radius and radius > 0 then
					local dist = owner:GetPos():DistToSqr(EyePos())
					if dist < radius then
						blend = (dist / radius) ^ 1.4
					end
				end
			end
		end

		if blend <= 0.05 then
			if suppressLighting then
				render.SuppressEngineLighting(false)
			end
			return
		end

		local c = self._lastColorCache
		if not c or c[1] ~= r or c[2] ~= g or c[3] ~= b then
			self:SetColor(Color(r, g, b, 255))
			self._lastColorCache = {r, g, b}
		end

		if blend < 1 then
			render.SetBlend(blend)
		end

		if not (spawnProt and owner:GetZombieClassTable().NoHideMainModel) then
			if not owner:CallZombieFunction1("PrePlayerDrawOverrideModel", self) then
				if blend < 1 then
					render.SetBlend(blend)
				end
				self:DrawModel()
				owner:CallZombieFunction1("PostPlayerDrawOverrideModel", self)
			end
		end

		if blend < 1 then
			render.SetBlend(1)
		end

		if suppressLighting then
			render.SuppressEngineLighting(false)
		end
	end
	ENT.DrawTranslucent = ENT.Draw
end