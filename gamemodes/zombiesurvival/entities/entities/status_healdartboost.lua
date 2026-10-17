AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"

AccessorFuncDT(ENT, "Duration",  "Float", 0)
AccessorFuncDT(ENT, "StartTime", "Float", 4)

-- One global Move hook. Previously, each instance registered its own hook
-- with an entity ID, and Move (once per frame per player) iterated through
-- N hooks. Now — one hook + a table of active boosts + a counter.
local HealDartBoosts     = {}   -- [owner] = ent
local HealDartBoostCount = 0

if SERVER then
	hook.Add("Move", "ZS_HealDartBoost_Move", function(pl, move)
		if HealDartBoostCount == 0 then return end
		if HealDartBoosts[pl] == nil then return end

		move:SetMaxSpeed(move:GetMaxSpeed() + 50)
		move:SetMaxClientSpeed(move:GetMaxSpeed())
	end)
end

function ENT:PlayerSet()
	self:SetStartTime(CurTime())
end

if SERVER then
	function ENT:RegisterOwner(owner)
		if not IsValid(owner) or not owner:IsPlayer() then return end
		if HealDartBoosts[owner] == self then return end

		if HealDartBoosts[owner] == nil then
			HealDartBoostCount = HealDartBoostCount + 1
		end
		HealDartBoosts[owner] = self
	end

	function ENT:UnregisterOwner()
		local owner = self:GetOwner()
		if IsValid(owner) and HealDartBoosts[owner] == self then
			HealDartBoosts[owner] = nil
			HealDartBoostCount = HealDartBoostCount - 1
		end
	end

	function ENT:SetDie(fTime)
		if fTime == 0 or not fTime then
			self.DieTime = 0
		elseif fTime == -1 then
			self.DieTime = 999999999
		else
			self.DieTime = CurTime() + fTime
			self:SetDuration(fTime)
		end
	end

	function ENT:Initialize()
		self.BaseClass.Initialize(self)
		self:RegisterOwner(self:GetOwner())
	end

	function ENT:OnRemove()
		self:UnregisterOwner()
		if self.BaseClass.OnRemove then
			self.BaseClass.OnRemove(self)
		end
	end
else
	function ENT:Initialize()
		self.BaseClass.Initialize(self)
	end
end