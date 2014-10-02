-- This is a special class which is essentially just Fresh Dead made to be a bit stronger so people can put it in their maps.
-- It also has a climbing function although not as good as the Fast Zombie. Only so you don't have people exploiting high places.

CLASS.Name = "Classic Zombie"
CLASS.TranslationName = "class_classic_zombie"
CLASS.Base = "freshdead"

CLASS.Health = 150
CLASS.Speed = 200
CLASS.Points = 4

CLASS.SWEP = "weapon_zs_classiczombie"

CLASS.UsePlayerModel = true
CLASS.UsePreviousModel = false
CLASS.NoFallDamage = true

if SERVER then
	function CLASS:OnKilled(pl, attacker, inflictor, suicide, headshot, dmginfo) end
end

function CLASS:Move(pl, mv)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.Move and wep:Move(mv) then
		return true
	end
end

function CLASS:CalcMainActivity(pl, velocity)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.GetClimbing and wep:GetClimbing() then
		pl.CalcIdeal = ACT_ZOMBIE_CLIMB_UP
		return true
	end

	return self.BaseClass.CalcMainActivity(self, pl, velocity)
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.GetClimbing and wep:GetClimbing() then
		local vel = pl:GetVelocity()
		local speed = vel:Length()
		if speed > 8 then
			pl:SetPlaybackRate(math.Clamp(speed / 60, 0, 1) * (vel.z < 0 and -1 or 1) * 0.25)
		else
			pl:SetPlaybackRate(0)
		end

		return true
	end

	return self.BaseClass.UpdateAnimation(self, pl, velocity, maxseqgroundspeed)
end

--[[if SERVER then return end

function CLASS:CreateMove(pl, cmd)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.IsClimbing and wep:IsClimbing() then
		local buttons = cmd:GetButtons()
		if bit.band(buttons, IN_DUCK) ~= 0 then
			cmd:SetButtons(buttons - IN_DUCK)
		end
	end
end]]
