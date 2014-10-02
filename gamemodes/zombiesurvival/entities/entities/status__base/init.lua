AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self.DieTime = self.DieTime or 0

	self:OnInitialize()
end

function ENT:SetPlayer(pPlayer, bExists)
	if bExists then
		self:PlayerSet(pPlayer, bExists)
	else
		local bValid = pPlayer and pPlayer:IsValid()
		if bValid then
			self:SetPos(pPlayer:GetPos() + Vector(0,0,16))
		end
		self.Owner = pPlayer
		pPlayer[self:GetClass()] = self
		self:SetOwner(pPlayer)
		self:SetParent(pPlayer)
		if bValid then
			self:PlayerSet(pPlayer)
		end
	end
end

function ENT:PlayerSet(pPlayer, bExists)
end

function ENT:Think()
	-- Any kind of active effect.

	if self.DieTime <= CurTime() then
		self:Remove()
	end
end

function ENT:KeyValue(key, value)
	if key == "dietime" then
		self:SetDie(tonumber(value))
		return true
	end
end

function ENT:PhysicsCollide(data, physobj)
end

function ENT:Touch(ent)
end

function ENT:OnRemove()
	--[[if not self.SilentRemove and self:GetParent():IsValid() then
		-- Emit death sound
	end]]
end

function ENT:SetDie(fTime)
	if fTime == 0 or not fTime then
		self.DieTime = 0
	elseif fTime == -1 then
		self.DieTime = 999999999
	else
		self.DieTime = CurTime() + fTime
	end
end
