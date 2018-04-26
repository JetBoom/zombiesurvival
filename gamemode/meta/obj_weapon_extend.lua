local meta = FindMetaTable("Weapon")
if not meta then return end

meta.GetNextPrimaryAttack = meta.GetNextPrimaryFire
meta.GetNextSecondaryAttack = meta.GetNextSecondaryFire
meta.SetNextPrimaryAttack = meta.SetNextPrimaryFire
meta.SetNextSecondaryAttack = meta.SetNextSecondaryFire

function meta:EmptyAll()
	if self.Primary and string.lower(self.Primary.Ammo or "") ~= "none" then
		local owner = self:GetOwner()
		if owner:IsValid() then
			if self:Clip1() >= 1 then
				owner:GiveAmmo(self:Clip1(), self.Primary.Ammo, true)
			end
			owner:RemoveAmmo(self.Primary.DefaultClip, self.Primary.Ammo)
		end
		self:SetClip1(0)
	end
	if self.Secondary and string.lower(self.Secondary.Ammo or "") ~= "none" then
		local owner = self:GetOwner()
		if owner:IsValid() then
			if self:Clip2() >= 1 then
				owner:GiveAmmo(self:Clip2(), self.Secondary.Ammo, true)
			end
			owner:RemoveAmmo(self.Secondary.DefaultClip, self.Secondary.Ammo)
		end
		self:SetClip2(0)
	end
end

function meta:ValidPrimaryAmmo()
	local ammotype = self:GetPrimaryAmmoTypeString()
	if ammotype and ammotype ~= "none" then
		return ammotype
	end
end

function meta:ValidSecondaryAmmo()
	local ammotype = self:GetSecondaryAmmoTypeString()
	if ammotype and ammotype ~= "none" then
		return ammotype
	end
end

function meta:SetNextReload(fTime)
	self.m_NextReload = fTime
end

function meta:GetNextReload()
	return self.m_NextReload or 0
end

function meta:GetPrimaryAmmoCount()
	return self.Owner:GetAmmoCount(self.Primary.Ammo) + self:Clip1()
end

function meta:GetSecondaryAmmoCount()
	return self.Owner:GetAmmoCount(self.Secondary.Ammo) + self:Clip2()
end

function meta:HideViewAndWorldModel()
	self:HideViewModel()
	self:HideWorldModel()
end
meta.HideWorldAndViewModel = meta.HideViewAndWorldModel

if SERVER then
	function meta:HideWorldModel()
		self:DrawShadow(false)
	end

	function meta:HideViewModel()
	end
end

function meta:TakeCombinedPrimaryAmmo(amount)
	local ammotype = self.Primary.Ammo
	local owner = self.Owner
	local clip = self:Clip1()
	local reserves = owner:GetAmmoCount(ammotype)

	amount = math.min(reserves + clip, amount)

	local fromreserves = math.min(reserves, amount)
	if fromreserves > 0 then
		amount = amount - fromreserves
		self.Owner:RemoveAmmo(fromreserves, ammotype)
	end

	local fromclip = math.min(clip, amount)
	if fromclip > 0 then
		self:SetClip1(clip - fromclip)
	end
end

function meta:TakeCombinedSecondaryAmmo(amount)
	local ammotype = self.Secondary.Ammo
	local owner = self.Owner
	local clip = self:Clip2()
	local reserves = owner:GetAmmoCount(ammotype)

	amount = math.min(reserves + clip, amount)

	local fromreserves = math.min(reserves, amount)
	if fromreserves > 0 then
		amount = amount - fromreserves
		self.Owner:RemoveAmmo(fromreserves, ammotype)
	end

	local fromclip = math.min(clip, amount)
	if fromclip > 0 then
		self:SetClip2(clip - fromclip)
	end
end

local TranslatedAmmo = {}
TranslatedAmmo[-1] = "none"
TranslatedAmmo[0] = "none"
TranslatedAmmo[1] = "ar2"
TranslatedAmmo[2] = "alyxgun"
TranslatedAmmo[3] = "pistol"
TranslatedAmmo[4] = "smg1"
TranslatedAmmo[5] = "357"
TranslatedAmmo[6] = "xbowbolt"
TranslatedAmmo[7] = "buckshot"
TranslatedAmmo[8] = "rpg_round"
TranslatedAmmo[9] = "smg1_grenade"
TranslatedAmmo[10] = "sniperround"
TranslatedAmmo[11] = "sniperpenetratedround"
TranslatedAmmo[12] = "grenade"
TranslatedAmmo[13] = "thumper"
TranslatedAmmo[14] = "gravity"
TranslatedAmmo[14] = "battery"
TranslatedAmmo[15] = "gaussenergy"
TranslatedAmmo[16] = "combinecannon"
TranslatedAmmo[17] = "airboatgun"
TranslatedAmmo[18] = "striderminigun"
TranslatedAmmo[19] = "helicoptergun"
TranslatedAmmo[20] = "ar2altfire"
TranslatedAmmo[21] = "slam"

function meta:GetPrimaryAmmoTypeString()
	if self.Primary and self.Primary.Ammo then return string.lower(self.Primary.Ammo) end
	return TranslatedAmmo[self:GetPrimaryAmmoType()] or "none"
end

function meta:GetSecondaryAmmoTypeString()
	if self.Secondary and self.Secondary.Ammo then return string.lower(self.Secondary.Ammo) end
	return TranslatedAmmo[self:GetSecondaryAmmoType()] or "none"
end

if not CLIENT then return end

function meta:DrawCrosshair()
	if GetConVarNumber("zs_crosshair") ~= 0 then return end

	self:DrawCrosshairCross()
	self:DrawCrosshairDot()
end

local ironsightscrosshair = CreateClientConVar("zs_ironsightscrosshair", "0", true, false):GetBool()
cvars.AddChangeCallback("zs_ironsightscrosshair", function(cvar, oldvalue, newvalue)
	ironsightscrosshair = tonumber(newvalue) == 1
end)

local CrossHairScale = 1
local function DrawDot(x, y)
	surface.SetDrawColor(GAMEMODE.CrosshairColor)
	surface.DrawRect(x - 2, y - 2, 4, 4)
	surface.SetDrawColor(0, 0, 0, 220)
	surface.DrawOutlinedRect(x - 2, y - 2, 4, 4)
end

local matGrad = Material("VGUI/gradient-r")
local function DrawLine(x, y, rot)
	rot = 270 - rot
	surface.SetMaterial(matGrad)
	surface.SetDrawColor(0, 0, 0, 220)
	surface.DrawTexturedRectRotated(x, y, 14, 4, rot)
	surface.SetDrawColor(GAMEMODE.CrosshairColor)
	surface.DrawTexturedRectRotated(x, y, 12, 2, rot)
end

local baserot = 0
function meta:DrawCrosshairCross()
	local thirdperson = self.useThirdPerson or GAMEMODE.PlayerThirdPerson
	local pos = Vector(ScrW() * 0.5, ScrH() * 0.5)
	
	if thirdperson then
		local MtoH = util.TraceLine({start = LocalPlayer():GetShootPos(), endpos = LocalPlayer():GetShootPos() + (LocalPlayer():GetAimVector() * 9999),filter = LocalPlayer()})
		pos = MtoH.HitPos:ToScreen()
	end
	
	local ironsights = self.GetIronsights and self:GetIronsights()

	local owner = self.Owner

	local cone = self:GetCone()

	if cone <= 0 or ironsights and not ironsightscrosshair then return end

	cone = ScrH() / 76.8 * cone

	CrossHairScale = math.Approach(CrossHairScale, cone, FrameTime() * math.max(5, math.abs(CrossHairScale - cone) * 0.02))

	local midarea = 40 * CrossHairScale

	local vel = LocalPlayer():GetVelocity()
	local len = vel:Length()
	if GAMEMODE.NoCrosshairRotate then
		baserot = 0
	else
		baserot = math.NormalizeAngle(baserot + vel:GetNormalized():Dot(EyeAngles():Right()) * math.min(10, len / 200))
	end
	
	baserot = 0

	local ang = Angle(0, 0, baserot)
	for i=0, 359, 360 / 4 do
		ang.roll = baserot + i
		local p = ang:Up() * midarea
		DrawLine(math.Round(pos.x + p.y), math.Round(pos.y + p.z), ang.roll)
	end

end

local pl
function meta:DrawCrosshairDot()
	pl = LocalPlayer()
	local classtab = pl:GetZombieClassTable()
	local thirdperson = self.useThirdPerson or GAMEMODE.PlayerThirdPerson or pl:CallZombieFunction("ShouldDrawLocalPlayer")
	local pos = Vector(ScrW() * 0.5, ScrH() * 0.5)
	if thirdperson then
		local MtoH = util.TraceLine({start = LocalPlayer():GetShootPos(), endpos = LocalPlayer():GetShootPos() + (LocalPlayer():GetAimVector() * 9999),filter = LocalPlayer()})
		pos = MtoH.HitPos:ToScreen()
	end
	
	surface.SetDrawColor(GAMEMODE.CrosshairColor2)
	--surface.SetDrawColor( team.GetColor( pl:Team() ) or GAMEMODE.CrosshairColor2 )
	surface.DrawRect(pos.x - 2, pos.y - 2, 4, 4)
	surface.SetDrawColor(0, 0, 0, 220)
	surface.DrawOutlinedRect(pos.x - 2, pos.y - 2, 4, 4)
end

local dt
local pl, wep
function meta:DrawHitMarkerDots()

	if GetConVarNumber("zs_hitmarkers") ~= 0 then return end

	dt = FrameTime()

	x, y = ScrW() / 2, ScrH() / 2

	local scale = (10 * self.ConeMax)* (2 - math.Clamp( ( CurTime() ) * 5, 0.0, 1.0 ))

	pl = LocalPlayer()
	
	if IsValid(pl) then
		wep = pl:GetActiveWeapon()
		if IsValid(wep) and wep.Markers then
		   for k,v in pairs( wep.Markers )do
		      if v.alpha < 5 then
		         table.remove( wep.Markers )
		         continue
		      end
		      local pos = v.pos:ToScreen()

		      surface.SetDrawColor( Color(0, 160, 255, v.alpha ) )
		      surface.DrawLine(pos.x-2,pos.y-2,pos.x-5,pos.y-5)
		      surface.DrawLine(pos.x+2,pos.y+2,pos.x+5,pos.y+5)
		      surface.DrawLine(pos.x-2,pos.y+2,pos.x-5,pos.y+5)
		      surface.DrawLine(pos.x+2,pos.y-2,pos.x+5,pos.y-5)
		      v.alpha = v.alpha-FrameTime()*240;
		   end
		end
	end
	
end	

function meta:BaseDrawWeaponSelection(x, y, wide, tall, alpha)
	--if killicon.Get(self:GetClass()) then
		killicon.Draw(x + wide * 0.5, y + tall * 0.5, self:GetClass(), 255)
		draw.SimpleTextBlur(self:GetPrintName(), "ZSHUDFontSmaller", x + wide * 0.5, y + tall * 0.25, COLOR_RED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	--[[else
		draw.SimpleTextBlur(self:GetPrintName(), "ZSHUDFontSmaller", x + wide * 0.5, y + tall * 0.5, COLOR_RED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end]]
end

local function empty() end
local function NULLViewModelPosition(self, pos, ang)
	return pos + ang:Forward() * -256, ang
end

function meta:HideWorldModel()
	self:DrawShadow(false)
	self.DrawWorldModel = empty
	self.DrawWorldModelTranslucent = empty
end

function meta:HideViewModel()
	self.GetViewModelPosition = NULLViewModelPosition
end
