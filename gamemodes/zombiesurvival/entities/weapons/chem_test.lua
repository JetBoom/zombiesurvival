AddCSLuaFile()

SWEP.Base = "weapon_zs_zombie"

SWEP.ChargeTime = 2
SWEP.Delayed = 1
SWEP.CanExplode = false
function SWEP:Deploy()
	self.Delayed = 1
	self.CanExplode = false
	if (!SERVER) then return end
	timer.Simple(2.5,function() self.Delayed = 0 end )
end

function SWEP:PrimaryAttack()
	if self:GetChargeStart() == 0 and self.Delayed == 0 then
		self:SetChargeStart(CurTime())
		local numb = 1
		if math.random(1,2) == 2 then numb = 3 end
		self.Owner:EmitSound("npc/dog/dog_alarmed"..numb..".wav", 75, math.random(76, 100))
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:Think()
	if self:GetCharge() >= 1 then
		self.CanExplode = true
		self.Owner:Kill()
	end

	self:NextThink(CurTime())
	return true
end

function SWEP:IsMoaning()
	return false
end

function SWEP:Move(mv)
	local charge = self:GetCharge()
	if charge > 0 then
		mv:SetMaxSpeed(mv:GetMaxSpeed() * math.max(0, 1 - charge * 2))
		mv:SetMaxClientSpeed(mv:GetMaxSpeed())
	end
end

function SWEP:SetChargeStart(time)
	self:SetDTFloat(0, time)
end

function SWEP:GetChargeStart()
	return self:GetDTFloat(0)
end

function SWEP:GetCharge()
	if self:GetChargeStart() == 0 then return 0 end
	return math.Clamp((CurTime() - self:GetChargeStart()) / self.ChargeTime, 0, 1)
end

if not CLIENT then return end

function SWEP:ViewModelDrawn()
	render.ModelMaterialOverride(0)
end

local matSheet = Material("models/weapons/v_zombiearms/ghoulsheet")
function SWEP:PreDrawViewModel(vm)
	render.ModelMaterialOverride(matSheet)
end