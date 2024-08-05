include("shared.lua")

SWEP.PrintName = "까마귀"
SWEP.DrawCrosshair = false

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:Think()
	if (self:GetPhoenixKey()) then
		local ed = EffectData()
		ed:SetOrigin(self:LocalToWorld(self:OBBCenter()))
		ed:SetMagnitude(3)
		util.Effect("explosion", ed)
	end
end
