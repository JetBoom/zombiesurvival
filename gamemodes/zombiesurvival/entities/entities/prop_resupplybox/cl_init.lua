include("shared.lua")

ENT.Dinged = true

function ENT:Initialize()
	self:SetRenderBounds(Vector(-72, -72, -72), Vector(72, 72, 128))
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)
end

local NextUse = 0
local vOffset = Vector(16, 0, 0)
local vOffset2 = Vector(-16, 0, 0)
local aOffset = Angle(0, 90, 90)
local aOffset2 = Angle(0, 270, 90)
local vOffsetEE = Vector(-15, 0, 8)

function ENT:Think()
	if MySelf:IsValid() and MySelf:Team() == TEAM_HUMAN then
		if self.Dinged then
			if CurTime() < NextUse then
				self.Dinged = false
			end
		elseif CurTime() >= NextUse then
			self.Dinged = true

			self:EmitSound("zombiesurvival/ding.ogg")
		end
	end


	self:NextThink(CurTime() + 0.5)
	return true
end

function ENT:RenderInfo(pos, ang, owner)

	local time = CurTime()
	local remain = math.max(0, NextUse - time)
	local calc = math.Clamp(remain / 30, 0, 1)
	local textcolor = Color(255 * calc, 255 * (1 - calc), 0, 255)
	cam.Start3D2D(pos, ang, 0.075)
	
		draw.RoundedBox(32, -192, -50, 384, 160, color_black_alpha90)
		
		draw.SimpleText(string.FormattedTime(remain, "%02i:%02i'%02i"), "ZS3D2DFont2", 0, -80, textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(translate.Get("resupply_box"), "ZS3D2DFont2", 0, 0, textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		if owner:IsValid() and owner:IsPlayer() then
			draw.SimpleText("("..owner:ClippedName()..")", "ZS3D2DFont2Small", 0, 40, owner == MySelf and COLOR_BLUE or COLOR_GRAY, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		end

	cam.End3D2D()
end

function ENT:Draw()
	self:DrawModel()

	if not MySelf:IsValid() then return end

	local owner = self:GetObjectOwner()
	local ang = self:LocalToWorldAngles(aOffset)

	self:RenderInfo(self:LocalToWorld(vOffset), ang, owner)
	self:RenderInfo(self:LocalToWorld(vOffset2), self:LocalToWorldAngles(aOffset2), owner)

	cam.Start3D2D(self:LocalToWorld(vOffsetEE), ang, 0.01)

		draw.SimpleText("ur a faget", "ZS3D2DFont2", 0, 0, color_white, TEXT_ALIGN_CENTER)

	cam.End3D2D()
end

net.Receive("zs_nextresupplyuse", function(length)
	NextUse = net.ReadFloat()
end)
