AddCSLuaFile()

SWEP.PrintName = "Drone Control"
SWEP.Description = "Controller for your Drone."
SWEP.Slot = 4
SWEP.SlotPos = 0

if CLIENT then
	SWEP.BobScale = 0.5
	SWEP.SwayScale = 0.5
end

SWEP.ViewModel = "models/weapons/c_slam.mdl"
SWEP.WorldModel = "models/weapons/w_slam.mdl"
SWEP.UseHands = true

SWEP.Primary.Delay = 0
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Delay = 0
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.WalkSpeed = SPEED_FAST

SWEP.NoMagazine = true
SWEP.Undroppable = true
SWEP.NoPickupNotification = true

SWEP.HoldType = "slam"

SWEP.NoDeploySpeedChange = true
SWEP.NoTransfer = true
SWEP.AutoSwitchFrom = false

-- Cooldown between drone switches (shared for R and LMB).
SWEP.CycleDelay = 0.25

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self:SetDeploySpeed(10)
end

-- Sorted list of the player's drones (by EntIndex, stable).
function SWEP:GetOwnedDrones()
	local drones = {}
	local owner = self:GetOwner()
	if not owner:IsValid() then return drones end

	for _, ent in pairs(ents.FindByClass("prop_drone*")) do
		if ent:IsValid() and ent:GetObjectOwner() == owner then
			drones[#drones + 1] = ent
		end
	end

	table.sort(drones, function(a, b)
		return a:EntIndex() < b:EntIndex()
	end)

	return drones
end

function SWEP:GetDrone()
	return self:GetDTEntity(0)
end

function SWEP:SetDrone(ent)
	self:SetDTEntity(0, ent)
end

function SWEP:CycleDrone(dir)
	local drones = self:GetOwnedDrones()
	if #drones == 0 then
		self:SetDrone(NULL)
		return
	end

	local current = self:GetDrone()
	local idx = 0
	for i, d in ipairs(drones) do
		if d == current then
			idx = i
			break
		end
	end

	if idx == 0 then
		idx = dir > 0 and 1 or #drones
	else
		idx = idx + dir
		if idx < 1 then idx = #drones end
		if idx > #drones then idx = 1 end
	end

	self:SetDrone(drones[idx])
end

-- Returns true only if the drone has actually changed.
function SWEP:TryCycle(dir)
	if self:GetDTBool(0) then return false end
	if CurTime() < (self.NextCycle or 0) then return false end

	local drones = self:GetOwnedDrones()
	if #drones < 2 then
		if #drones == 0 then self:SetDrone(NULL) end
		return false
	end

	self.NextCycle = CurTime() + self.CycleDelay
	self:CycleDrone(dir)
	return true
end

function SWEP:Think()
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end

	if not SERVER then return end

	local drones = self:GetOwnedDrones()

	-- There are no more drones — no weapons are needed.
	if #drones == 0 then
		self:GetOwner():StripWeapon(self:GetClass())
		return
	end

	-- The current one is lost (destroyed / taken away) — choose the first one.
	local current = self:GetDrone()
	local found = false
	for _, d in ipairs(drones) do
		if d == current then
			found = true
			break
		end
	end

	if not found then
		self:SetDrone(drones[1])
	end
end

function SWEP:GetResupplyAmmoType()
	local drone = self:GetDrone()
	if drone:IsValid() and drone.AmmoType then
		return drone.AmmoType
	end
	return "smg1"
end

function SWEP:PrimaryAttack()
	if not self:TryCycle(1) then return end

	if IsFirstTimePredicted() and CLIENT then
		MySelf:EmitSound("buttons/button15.wav", 60, 130)
	end
end

function SWEP:Reload()
	if not self:TryCycle(-1) then return end

	if IsFirstTimePredicted() and CLIENT then
		MySelf:EmitSound("buttons/button15.wav", 60, 110)
	end
end

function SWEP:SecondaryAttack()
	if not IsFirstTimePredicted() then return end

	-- If for some reason a drone hasn't been assigned yet (the first call
	-- after obtaining a weapon, a lost drone, etc.) — assign
	-- the first available one.
	local drone = self:GetDrone()
	if not drone:IsValid() then
		local drones = self:GetOwnedDrones()
		if #drones == 0 then return end
		drone = drones[1]
		self:SetDrone(drone)
	end

	self:SetDTBool(0, not self:GetDTBool(0))

	if CLIENT then
		MySelf:EmitSound(self:GetDTBool(0) and "buttons/button17.wav" or "buttons/button19.wav", 0)
	end
end

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self:GetOwner(), self)

	self.IdleAnimation = CurTime() + self:SequenceDuration()

	return true
end

function SWEP:Holster()
	self:SetDTBool(0, false)
	return true
end

function SWEP:OnRemove()
	self:SetDTBool(0, false)
end

if not CLIENT then return end

function SWEP:DrawWeaponSelection(x, y, w, h, alpha)
	self:BaseDrawWeaponSelection(x, y, w, h, alpha)
end

-- ============================================================
-- HUD: panel with the list/status of the selected drone.
-- ============================================================
local colBG     = Color(16, 16, 16, 200)
local colBorder = Color(50, 255, 50, 220)
local colAccent = Color(255, 200, 60, 220)
local colRed    = Color(220, 60, 60, 220)
local colGray   = Color(180, 180, 180, 210)
local colBlack  = Color(0, 0, 0, 220)

local cachedDrones, cachedDronesAt, cachedDronesWep
local function GetCachedOwnedDrones(wep)
	local t = CurTime()
	if cachedDronesWep == wep and cachedDrones and t - cachedDronesAt < 0.25 then
		return cachedDrones
	end
	cachedDronesWep = wep
	cachedDrones = wep:GetOwnedDrones()
	cachedDronesAt = t
	return cachedDrones
end

-- Rendering a string with auto-scrolling if it doesn't fit within maxW.
-- Works like DLabelAutoScroll in "time" mode: pauses at the edges,
-- smooth back-and-forth movement. The cycle phase is taken from RealTime,
-- so when switching turrets, a long string doesn't "jump"
-- back to the beginning — it's already somewhere in the middle.
local function DrawScrollingText(text, font, x, y, maxW, col, xalign, yalign)
	if not text or text == "" then return end

	local tW, tH
	if ZS_MeasureMixedText then
		tW, tH = ZS_MeasureMixedText(text, font)
	else
		surface.SetFont(font)
		tW, tH = surface.GetTextSize(text)
	end

	if tW <= maxW then
		draw.SimpleText(text, font, x, y, col, xalign, yalign)
		return
	end

	local speed      = 40
	local pause      = 1.2
	local travel     = tW - maxW
	local scrollTime = travel / speed
	local cycle      = (scrollTime + pause) * 2
	local t          = RealTime() % cycle

	local frac
	if t < pause then
		frac = 0
	elseif t < pause + scrollTime then
		frac = (t - pause) / scrollTime
	elseif t < pause + scrollTime + pause then
		frac = 1
	else
		frac = 1 - (t - pause - scrollTime - pause) / scrollTime
	end

	-- The left/top edge of the rendering area — taking alignment into account.
	local boxL
	if xalign == TEXT_ALIGN_CENTER then
		boxL = x - maxW * 0.5
	elseif xalign == TEXT_ALIGN_RIGHT then
		boxL = x - maxW
	else
		boxL = x
	end

	local boxT = y
	if yalign == TEXT_ALIGN_CENTER then
		boxT = y - tH * 0.5
	elseif yalign == TEXT_ALIGN_BOTTOM then
		boxT = y - tH
	end

	local drawX = boxL - travel * frac

	render.SetScissorRect(boxL, boxT, boxL + maxW, boxT + tH, true)
		draw.SimpleText(text, font, drawX, y, col, TEXT_ALIGN_LEFT, yalign)
	render.SetScissorRect(0, 0, 0, 0, false)
end

-- Forward declaration: definition below.
local GetDronePrettyName

function SWEP:DrawHUD()
	local ss = BetterScreenScale()
	local drones = GetCachedOwnedDrones(self)
	local inControl = self:GetDTBool(0)

	local labelFont = "ZSHUDFontSmaller"
	local labelH    = draw.GetFontHeight(labelFont)
	local pad       = 10 * ss
	local barH      = 12 * ss
	local headerH   = math.max(labelH, 16 * ss)
	local wid       = 340 * ss
	local borderW   = math.max(1, math.Round(2 * ss))

	-- Hauler without GetAmmo — has no ammo.
	local current = self:GetDrone()
	local hasAmmo = current:IsValid() and current.GetAmmo ~= nil and current.MaxAmmo ~= nil

	local hei = 6 * ss + headerH + 6 * ss
	          + labelH + 6 * ss  -- drone name
	          + labelH + 3 * ss + barH + 8 * ss  -- HP
	          + (hasAmmo and (labelH + 3 * ss + barH + 8 * ss) or 0)
	          + labelH + 8 * ss  -- hint
	          + 6 * ss           -- bottom margin (see comment in
	                             -- weapon_zs_gunturretcontrol.lua)

	local x = 20 * ss
	local y = math.max(ScrH() * 0.22, 150 * ss)

	draw.RoundedBox(0, x, y, wid, hei, colBG)

	local bc = inControl and colAccent or colBorder
	surface.SetDrawColor(bc)
	surface.DrawOutlinedRect(x, y, wid, hei, borderW)

	if #drones == 0 then
		draw.SimpleText(translate.Get("dronecontrol_no_drones"), "ZSHUDFontSmall",
			x + wid * 0.5, y + hei * 0.5, colRed,
			TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		return
	end

	local idx = 0
	for i, d in ipairs(drones) do
		if d == current then
			idx = i
			break
		end
	end

	draw.SimpleText(
		translate.Format("dronecontrol_selection", idx, #drones),
		labelFont, x + pad, y + 6 * ss, colBorder, TEXT_ALIGN_LEFT)

	local statusTxt = inControl and translate.Get("gunturret_control_active")
		or translate.Get("gunturret_control_standby")
	local statusCol = inControl and colAccent or colGray
	draw.SimpleText(statusTxt, labelFont,
		x + wid - pad, y + 6 * ss, statusCol, TEXT_ALIGN_RIGHT)

	surface.SetDrawColor(colBorder.r, colBorder.g, colBorder.b, 60)
	surface.DrawRect(x + pad, y + 6 * ss + headerH + 2 * ss, wid - pad * 2, 1)

	if not current:IsValid() then
		draw.SimpleText(translate.Get("dronecontrol_none_selected"),
			"ZSHUDFontSmall", x + wid * 0.5, y + hei * 0.5, colRed,
			TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		return
	end

	local health    = current:GetObjectHealth()
	local maxhealth = current:GetMaxObjectHealth()

	local hpf = math.Clamp(health / math.max(maxhealth, 1), 0, 1)
	local colHp = hpf > 0.5 and colBorder or (hpf > 0.25 and colAccent or colRed)

	local barX = x + pad
	local barW = wid - pad * 2

	local rowY = y + 6 * ss + headerH + 8 * ss

	-- ===== Name of the selected drone =====
	-- Duplicate the world indicator in the HUD (see the block of the same name
	-- in weapon_zs_gunturretcontrol.lua).
	DrawScrollingText(
		GetDronePrettyName(current),
		"ZSHUDFontSmall",
		barX, rowY, barW, COLOR_WHITE, TEXT_ALIGN_LEFT)

	rowY = rowY + labelH + 6 * ss

	-- ===== HP =====
	draw.SimpleText(translate.Format("gunturret_health_fmt",
		math.ceil(health), math.ceil(maxhealth)),
		labelFont, barX, rowY, colHp, TEXT_ALIGN_LEFT)

	rowY = rowY + labelH + 3 * ss
	surface.SetDrawColor(colBlack)
	surface.DrawRect(barX, rowY, barW, barH)
	surface.SetDrawColor(colHp.r, colHp.g, colHp.b, 200)
	surface.DrawRect(barX, rowY, barW * hpf, barH)
	surface.SetDrawColor(colHp)
	surface.DrawOutlinedRect(barX, rowY, barW, barH)

	rowY = rowY + barH + 8 * ss

	-- ===== Ammo (if the drone has it) =====
	if hasAmmo then
		local ammo    = current:GetAmmo() or 0
		local maxammo = current.MaxAmmo or 1
		local apf     = math.Clamp(ammo / math.max(maxammo, 1), 0, 1)

		local ammoRowY = rowY
		local ammoRowH = labelH + 3 * ss + barH

		if ammo > 0 then
			draw.SimpleText(translate.Format("gunturret_ammo_fmt", ammo, maxammo),
				labelFont, barX, rowY, colAccent, TEXT_ALIGN_LEFT)

			local barY = rowY + labelH + 3 * ss
			surface.SetDrawColor(colBlack)
			surface.DrawRect(barX, barY, barW, barH)
			surface.SetDrawColor(colAccent.r, colAccent.g, colAccent.b, 200)
			surface.DrawRect(barX, barY, barW * apf, barH)
			surface.SetDrawColor(colAccent)
			surface.DrawOutlinedRect(barX, barY, barW, barH)
		else
			if math.sin(CurTime() * 15) > 0 then
				draw.SimpleTextBlur(translate.Get("empty"), labelFont,
					barX, ammoRowY + ammoRowH * 0.5, colRed,
					TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
		end

		rowY = rowY + labelH + 3 * ss + barH + 8 * ss
	end

	-- ===== Hint =====
	-- In standby — reuse the turret string: controls
	-- are the same (LMB/R — switch drones, RMB — take
	-- control). In control mode, the hint depends on whether
	-- the selected drone can shoot. The hauler has no ammo block
	-- (hasAmmo == false), so LMB attaches a rope to an object,
	-- rather than shooting. The action itself is already implemented in
	-- prop_drone_hauler/init.lua (owner:KeyDown(IN_ATTACK) → RopeAttach).
	local hint
	if inControl then
		if hasAmmo then
			hint = translate.Get("gunturret_hint_fire")
			if type(hint) ~= "string" or hint:sub(1, 1) == "@" then
				hint = "LMB: fire  RMB: release"
			end
		else
			hint = translate.Get("dronecontrol_hint_grapple")
			if type(hint) ~= "string" or hint:sub(1, 1) == "@" then
				hint = "LMB: grapple  RMB: release"
			end
		end
	else
		hint = translate.Get("gunturret_hint_control")
		if type(hint) ~= "string" or hint:sub(1, 1) == "@" then
			hint = "LMB/R: switch  RMB: control"
		end
	end
	DrawScrollingText(hint, labelFont,
		barX + barW, rowY, barW, colGray, TEXT_ALIGN_RIGHT)
end

-- ============================================================
-- World indicator for selected drone.
-- ============================================================
local matGlow = Material("sprites/glow04_noz")

-- Localized drone name. Drones have no quality system
-- (AllowQualityWeapons is not set), so unlike
-- turrets, we show only the name — but the format is already ready to accept
-- quality if it ever appears.
--
--   prop_drone         → "DRONE"
--   prop_drone_pulse   → "PULSE DRONE"
--   prop_drone_hauler  → "HAULER DRONE"
GetDronePrettyName = function(ent)
	local klass   = ent:GetClass()
	local variant = klass:gsub("^prop_drone", ""):gsub("^_", "")

	local nkey = variant ~= "" and ("deployable_drone_" .. variant) or "deployable_drone"
	local nname
	local n = translate.Get(nkey)
	if type(n) == "string" and n ~= nkey and n:sub(1, 1) ~= "@" then
		nname = n
	elseif variant ~= "" then
		nname = variant
	else
		nname = "Drone"
	end

	-- The same registration flag as the turret — so that the world
	-- indicator looks consistent everywhere.
	if translate.Get("qlt_weapon_lowercase") ~= "0" then
		nname = string.upper(nname)
	end

	return nname
end

hook.Add("PostDrawTranslucentRenderables", "ZS_DroneControl_Indicator", function(bDepth, bSkybox)
	if bDepth or bSkybox then return end

	local ply = LocalPlayer()
	if not IsValid(ply) then return end

	local wep = ply:GetActiveWeapon()
	if not IsValid(wep) or wep:GetClass() ~= "weapon_zs_dronecontrol" then return end

	local current = wep:GetDrone()
	if not current:IsValid() then return end

	local pos = current:GetPos()

	local eyepos = EyePos()
	local dist = eyepos:Distance(pos)
	if dist < 32 or dist > 4096 then return end

	local ang = (eyepos - pos):Angle()
	ang:RotateAroundAxis(ang:Right(), 270)
	ang:RotateAroundAxis(ang:Up(), 90)

	local inControl = wep:GetDTBool(0)
	local pulse = 0.5 + 0.5 * math.abs(math.sin(RealTime() * 3))
	local col = inControl and colAccent or colBorder

	-- Light glow — visible through walls.
	render.SetMaterial(matGlow)
	render.DrawSprite(pos, 24 + pulse * 8, 24 + pulse * 8, col)
	render.DrawSprite(pos, 8, 8, COLOR_WHITE)

	-- IgnoreZ: the cross and label are drawn on top of the geometry.
	cam.IgnoreZ(true)
	cam.Start3D2D(pos, ang, math.max(0.05, math.min(0.25, dist / 4000)))
		surface.SetDrawColor(col.r, col.g, col.b, 220)

		-- Target: a cross with a pulsating size.
		local size = 40 + pulse * 20
		surface.DrawRect(-2, -size * 0.5, 4, size)
		surface.DrawRect(-size * 0.5, -2, size, 4)

		-- Drone name. No format string is needed: drones have neither a channel
		-- nor quality, so there's nothing to translate — the name itself is already
		-- localized (deployable_drone*).
		draw.SimpleText(GetDronePrettyName(current), "ZS3D2DFont2",
			0, size * 0.6, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	cam.End3D2D()
	cam.IgnoreZ(false)
end)