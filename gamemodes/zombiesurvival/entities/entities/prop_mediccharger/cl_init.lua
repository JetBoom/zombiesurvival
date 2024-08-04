include("shared.lua")

function ENT:Initialize()
	self:SetRenderBounds(Vector(-72, -72, -72), Vector(72, 72, 128))
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)
end
local NextUse = 0
function ENT:Think()
	if MySelf:IsValid() and MySelf:Team() == TEAM_HUMAN then
		if self.Dinged then
			if CurTime() < NextUse then
				self.Dinged = false
			end
		elseif CurTime() >= NextUse then
			self.Dinged = true

			self:EmitSound("items/suitchargeok1.wav")
		end
	end

	self:NextThink(CurTime() + 0.5)
	return true
end
local colFlash = Color(30, 255, 30)
function ENT:Draw()
	self:DrawModel()
	local time = CurTime()
	local remain = math.max(0, NextUse - time)
	local calc = math.Clamp(remain / 30, 0, 1)
	local textcolor = Color(255 * calc, 255 * (1 - calc), 0, 255)
	if not MySelf:IsValid() then return end

	local owner = self:GetObjectOwner()
	local ang = self:LocalToWorldAngles(Angle(0, 90, 90))
	local w, h = 400, 420

	cam.Start3D2D(self:LocalToWorld(Vector(7.3,0, self:OBBMaxs().z - 20)),ang, 0.05)
		draw.RoundedBox(32, -192, -400, 384, 560, color_black_alpha90)
		draw.SimpleText("자동 치료기", "ZS3D2DFont2", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		if owner:IsValid() and owner:IsPlayer() then
			draw.SimpleText(string.FormattedTime(remain, "%02i:%02i'%02i"), "ZS3D2DFont2", 0, -150, textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("("..owner:ClippedName()..")", "ZS3D2DFont2Small", 0, -270, owner == MySelf and COLOR_BLUE or COLOR_GRAY, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			draw.SimpleText(self:GetAmmoCount().." 에너지", "ZS3D2DFont2", 0,60, self:GetAmmoCount() > 30 and color_white or color_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	cam.End3D2D()
end

net.Receive("zs_nextchargeruse", function(length)
	NextUse = net.ReadFloat()
end)