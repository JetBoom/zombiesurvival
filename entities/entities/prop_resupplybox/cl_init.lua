include("shared.lua")

ENT.Dinged = true

function ENT:Initialize()
	self:SetRenderBounds(Vector(-72, -72, -72), Vector(72, 72, 128))
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)
end

local NextUse = 0
local NextUseStart = 0
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

function ENT:DrawBar(x, y, w, h, factor, text)
	factor = math.Clamp(factor, 0, 1)
	
	local barwidth = w * factor
	local startx = x - w / 2
	local red, green
	if factor == 1 then
		red, green = 0, 255
	else
		red, green = 255, 0
	end
	
	surface.SetDrawColor(0, 0, 0, 220)
	surface.DrawRect(startx, y, w, h)
	surface.SetDrawColor(red, green, 0, 220)
	surface.DrawRect(startx + 4, y + 4, barwidth - 8, h - 8)
	surface.DrawOutlinedRect(startx, y, w, h)
	draw.SimpleText(text, "DermaLarge", x, y + h/2, Color(red, red, red, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function ENT:RenderInfo(pos, ang, owner)
	cam.Start3D2D(pos, ang, 0.075)

		draw.RoundedBox(32, -350, -175, 700, 350, color_black_alpha90)

		draw.SimpleText(translate.Get("resupply_box"), "ZS3D2DFont2", 0, 0, NextUse <= CurTime() and COLOR_GREEN or COLOR_DARKRED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		local healthfactor = self:GetObjectHealth() / self:GetMaxObjectHealth()
		--local healthfactor = math.sin(CurTime() * 0.5)
		if healthfactor < 1 then
			self:DrawBar(0, -120, 600, 40, healthfactor, string.format("%i", healthfactor*100).."%")
		end
		
		local factor = 1 - (NextUse - CurTime()) / (NextUse - NextUseStart)
		if factor >= 1 then
			self:DrawBar(0, -80, 600, 40, factor, translate.Get"res_box_ready")
		else
			self:DrawBar(0, -80, 600, 40, factor, string.format("%i", NextUse - CurTime()).." "..translate.Get"res_box_seconds")
		end
		
		if owner:IsValid() and owner:IsPlayer() then
			draw.SimpleText("("..owner:ClippedName()..")", "ZS3D2DFont2Small", 0, 70, owner == MySelf and COLOR_BLUE or COLOR_GRAY, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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
end

net.Receive("zs_nextresupplyuse", function(length)
	NextUse = net.ReadFloat()
	NextUseStart = CurTime()
end)