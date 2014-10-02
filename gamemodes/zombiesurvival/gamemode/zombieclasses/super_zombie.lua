CLASS.Name = "Super Zombie"
CLASS.TranslationName = "class_super_zombie"
CLASS.Base = "freshdead"

CLASS.Health = 1500
CLASS.Speed = SPEED_ZOMBIEESCAPE_ZOMBIE
CLASS.Points = 5

CLASS.SWEP = "weapon_zs_superzombie"

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
