AddCSLuaFile()

SWEP.Base = "weapon_zs_stubber"

SWEP.Primary.Damage = 750
SWEP.Primary.ClipSize = 5

SWEP.WalkSpeed = SPEED_ZOMBIEESCAPE_SLOW

SWEP.Primary.KnockbackScale = ZE_KNOCKBACKSCALE
SWEP.Primary.DefaultClip = 99999

if CLIENT then
	local ghostlerp = 0
	function SWEP:GetViewModelPosition(pos, ang)
		if self:IsScoped() then
			return pos + ang:Up() * 256
		end

		local bIron = self:GetIronsights()

		if bIron ~= self.bLastIron then
			self.bLastIron = bIron 
			self.fIronTime = CurTime()

			if bIron then 
				self.SwayScale = 0.3
				self.BobScale = 0.1
			else 
				self.SwayScale = 2.0
				self.BobScale = 1.5
			end
		end

		local Mul = math.Clamp((CurTime() - (self.fIronTime or 0)) * 4, 0, 1)
		if not bIron then Mul = 1 - Mul end

		if Mul > 0 then
			local Offset = self.IronSightsPos
			if self.IronSightsAng then
				ang = Angle(ang.p, ang.y, ang.r)
				ang:RotateAroundAxis(ang:Right(), self.IronSightsAng.x * Mul)
				ang:RotateAroundAxis(ang:Up(), self.IronSightsAng.y * Mul)
				ang:RotateAroundAxis(ang:Forward(), self.IronSightsAng.z * Mul)
			end

			pos = pos + Offset.x * Mul * ang:Right() + Offset.y * Mul * ang:Forward() + Offset.z * Mul * ang:Up()
		end

		if self.Owner:GetBarricadeGhosting() then
			ghostlerp = math.min(1, ghostlerp + FrameTime() * 4)
		elseif ghostlerp > 0 then
			ghostlerp = math.max(0, ghostlerp - FrameTime() * 5)
		end

		if ghostlerp > 0 then
			pos = pos + 3.5 * ghostlerp * ang:Up()
			ang:RotateAroundAxis(ang:Right(), -30 * ghostlerp)
		end

		return pos, ang
	end
end
