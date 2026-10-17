ENT.Type = "anim"

ENT.IgnoreBullets = true

AccessorFuncDT(ENT, "HitTime",     "Float", 0)
AccessorFuncDT(ENT, "TimeCreated", "Float", 1)
AccessorFuncDT(ENT, "ChargeTime",  "Float", 2)

function ENT:ShouldNotCollide(ent)
	return ent:IsPlayer() or ent:IsProjectile()
end

function ENT:GetCharge()
	if self:GetTimeCreated() == 0 then return 0 end

	local chargetime = self:GetChargeTime()
	if chargetime <= 0 then chargetime = 3 end

	return math.Clamp(0.5 + (CurTime() - self:GetTimeCreated()) / chargetime / 2, 0, 1)
end

util.PrecacheModel("models/combine_helicopter/helicopter_bomb01.mdl")