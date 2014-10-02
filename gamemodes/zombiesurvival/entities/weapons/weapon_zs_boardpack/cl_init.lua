include("shared.lua")

SWEP.PrintName = "Junk Pack"
SWEP.Description = "It's simply a pack of wooden junk kept together with some duct tape.\nVery useful for making barricades when no materials are around.\nNeeds something like a hammer and nails to keep the things in place."
SWEP.ViewModelFOV = 45
SWEP.ViewModelFlip = false

SWEP.Slot = 4
SWEP.SlotPos = 0

function SWEP:Deploy()
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	return true
end

function SWEP:DrawWorldModel()
	local owner = self.Owner
	if owner:IsValid() and self:GetReplicatedAmmo() > 0 then
		local id = owner:LookupAttachment("anim_attachment_RH")
		if id and id > 0 then
			local attch = owner:GetAttachment(id)
			if attch then
				cam.Start3D(EyePos() + (owner:GetPos() - attch.Pos + Vector(0, 0, 24)), EyeAngles())
					self:DrawModel()
				cam.End3D()
			end
		end
	end
end
SWEP.DrawWorldModelTranslucent = SWEP.DrawWorldModel

function SWEP:Initialize()
	self:SetDeploySpeed(1.1)
end

function SWEP:GetViewModelPosition(pos, ang)
	if self:GetPrimaryAmmoCount() <= 0 then
		return pos + ang:Forward() * -256, ang
	end

	return pos, ang
end

function SWEP:DrawWeaponSelection(...)
	return self:BaseDrawWeaponSelection(...)
end
