INC_CLIENT()

include("animations.lua")

SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = true
SWEP.BobScale = 1
SWEP.SwayScale = 1
SWEP.Slot = 0

SWEP.IronsightsMultiplier = 0.6

SWEP.HUD3DScale = 0.01
SWEP.HUD3DBone = "base"
SWEP.HUD3DAng = Angle(180, 0, 0)

function SWEP:Deploy()
	return true
end

function SWEP:TranslateFOV(fov)
	return (GAMEMODE.FOVLerp + (self.IsScoped and not GAMEMODE.DisableScopes and 0 or (1 - GAMEMODE.FOVLerp) * (1 - GAMEMODE.IronsightZoomScale))) * fov
end

function SWEP:AdjustMouseSensitivity()
	if self:GetIronsights() then return GAMEMODE.FOVLerp + (self.IsScoped and not GAMEMODE.DisableScopes and 0 or (1 - GAMEMODE.FOVLerp) * (1 - GAMEMODE.IronsightZoomScale)) end
end

function SWEP:PreDrawViewModel(vm)
	if self.ShowViewModel == false then
		render.SetBlend(0)
	end
end

function SWEP:PostDrawViewModel(vm)
	if self.ShowViewModel == false then
		render.SetBlend(1)
	end

	if self.HUD3DPos and GAMEMODE:ShouldDraw3DWeaponHUD() then
		local pos, ang = self:GetHUD3DPos(vm)
		if pos then
			self:Draw3DHUD(vm, pos, ang)
		end
	end
end

function SWEP:GetHUD3DPos(vm)
	local bone = vm:LookupBone(self.HUD3DBone)
	if not bone then return end

	local m = vm:GetBoneMatrix(bone)
	if not m then return end

	local pos, ang = m:GetTranslation(), m:GetAngles()

	if self.ViewModelFlip then
		ang.r = -ang.r
	end

	local offset = self.HUD3DPos
	local aoffset = self.HUD3DAng

	pos = pos + ang:Forward() * offset.x + ang:Right() * offset.y + ang:Up() * offset.z

	if aoffset.yaw ~= 0 then ang:RotateAroundAxis(ang:Up(), aoffset.yaw) end
	if aoffset.pitch ~= 0 then ang:RotateAroundAxis(ang:Right(), aoffset.pitch) end
	if aoffset.roll ~= 0 then ang:RotateAroundAxis(ang:Forward(), aoffset.roll) end

	return pos, ang
end

local colBG = Color(16, 16, 16, 90)
local colRed = Color(220, 0, 0, 230)
local colYellow = Color(220, 220, 0, 230)
local colWhite = Color(220, 220, 220, 230)
local colAmmo = Color(255, 255, 255, 230)
local function GetAmmoColor(clip, maxclip)
	if clip == 0 then
		colAmmo.r = 255 colAmmo.g = 0 colAmmo.b = 0
	else
		local sat = clip / maxclip
		colAmmo.r = 255
		colAmmo.g = sat ^ 0.3 * 255
		colAmmo.b = sat * 255
	end
end

function SWEP:GetDisplayAmmo(clip, spare, maxclip)
	if self.RequiredClip ~= 1 then
		clip = math.floor(clip / self.RequiredClip)
		spare = math.floor(spare / self.RequiredClip)
		maxclip = math.ceil(maxclip / self.RequiredClip)
	end

	if self.AmmoUse then
		clip = math.floor(clip / self.AmmoUse)
		spare = math.floor(spare / self.AmmoUse)
		maxclip = math.ceil(maxclip / self.AmmoUse)
	end

	return clip, spare, maxclip
end

function SWEP:Draw3DHUD(vm, pos, ang)
	local wid, hei = 180, 200
	local x, y = wid * -0.6, hei * -0.5
	local clip = self:Clip1()
	local spare = self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType())
	local maxclip = self.Primary.ClipSize

	local dclip, dspare, dmaxclip = self:GetDisplayAmmo(clip, spare, maxclip)

	cam.Start3D2D(pos, ang, self.HUD3DScale / 2)
		draw.RoundedBoxEx(32, x, y, wid, hei, colBG, true, false, true, false)

		local displayspare = dmaxclip > 0 and self.Primary.DefaultClip ~= 99999
		if displayspare then
			draw.SimpleTextBlurry(dspare, dspare >= 1000 and "ZS3D2DFontSmall" or "ZS3D2DFont", x + wid * 0.5, y + hei * 0.75, dspare == 0 and colRed or dspare <= dmaxclip and colYellow or colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		GetAmmoColor(dclip, dmaxclip)
		draw.SimpleTextBlurry(dclip, dclip >= 100 and "ZS3D2DFont" or "ZS3D2DFontBig", x + wid * 0.5, y + hei * (displayspare and 0.3 or 0.5), colAmmo, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

function SWEP:Draw2DHUD()
	local screenscale = BetterScreenScale()

	local wid, hei = 180 * screenscale, 64 * screenscale
	local x, y = ScrW() - wid - screenscale * 128, ScrH() - hei - screenscale * 72
	local clip = self:Clip1()
	local spare = self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType())
	local maxclip = self.Primary.ClipSize

	local dclip, dspare, dmaxclip = self:GetDisplayAmmo(clip, spare, maxclip)

	draw.RoundedBox(16, x, y, wid, hei, colBG)

	local displayspare = dmaxclip > 0 and self.Primary.DefaultClip ~= 99999
	if displayspare then
		draw.SimpleTextBlurry(dspare, dspare >= 1000 and "ZSHUDFontSmall" or "ZSHUDFont", x + wid * 0.75, y + hei * 0.5, dspare == 0 and colRed or dspare <= dmaxclip and colYellow or colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	GetAmmoColor(dclip, dmaxclip)
	draw.SimpleTextBlurry(dclip, dclip >= 100 and "ZSHUDFont" or "ZSHUDFontBig", x + wid * (displayspare and 0.25 or 0.5), y + hei * 0.5, colAmmo, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function SWEP:Think()
	if self:GetIronsights() and not self:GetOwner():KeyDown(IN_ATTACK2) then
		self:SetIronsights(false)
	end

	if self:GetReloadFinish() > 0 then
		if CurTime() >= self:GetReloadFinish() then
			self:FinishReload()
		end

		return
	elseif self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(self.IdleActivity)
	end
end

function SWEP:GetIronsightsDeltaMultiplier()
	local bIron = self:GetIronsights()
	local fIronTime = self.fIronTime or 0

	if not bIron and fIronTime < CurTime() - 0.25 then
		return 0
	end

	local Mul = 1

	if fIronTime > CurTime() - 0.25 then
		Mul = math.Clamp((CurTime() - fIronTime) * 4, 0, 1)
		if not bIron then Mul = 1 - Mul end
	end

	return Mul
end

local ghostlerp = 0
function SWEP:CalcViewModelView(vm, oldpos, oldang, pos, ang)
	local bIron = self:GetIronsights() and not GAMEMODE.NoIronsights

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

	if self:GetOwner():GetBarricadeGhosting() then
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

function SWEP:DrawWeaponSelection(x, y, w, h, alpha)
	self:BaseDrawWeaponSelection(x, y, w, h, alpha)
end

function SWEP:DrawHUD()
	self:DrawWeaponCrosshair()

	if GAMEMODE:ShouldDraw2DWeaponHUD() then
		self:Draw2DHUD()
	end
end

local OverrideIronSights = {}
function SWEP:CheckCustomIronSights()
	local class = self:GetClass()
	if OverrideIronSights[class] then
		if type(OverrideIronSights[class]) == "table" then
			self.IronSightsPos = OverrideIronSights[class].Pos
			self.IronSightsAng = OverrideIronSights[class].Ang
		end

		return
	end

	local filename = "ironsights/"..class..".txt"
	if file.Exists(filename, "MOD") then
		local pos = Vector(0, 0, 0)
		local ang = Vector(0, 0, 0)

		local tab = string.Explode(" ", file.Read(filename, "MOD"))
		pos.x = tonumber(tab[1]) or 0
		pos.y = tonumber(tab[2]) or 0
		pos.z = tonumber(tab[3]) or 0
		ang.x = tonumber(tab[4]) or 0
		ang.y = tonumber(tab[5]) or 0
		ang.z = tonumber(tab[6]) or 0

		OverrideIronSights[class] = {Pos = pos, Ang = ang}

		self.IronSightsPos = pos
		self.IronSightsAng = ang
	else
		OverrideIronSights[class] = true
	end
end

function SWEP:OnRemove()
	self:Anim_OnRemove()
end

function SWEP:ViewModelDrawn()
	self:Anim_ViewModelDrawn()
end

function SWEP:DrawWorldModel()
	local owner = self:GetOwner()
	if owner:IsValid() and (owner.ShadowMan or owner.SpawnProtection) then return end

	self:Anim_DrawWorldModel()
end
