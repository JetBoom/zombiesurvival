AddCSLuaFile()

SWEP.PrintName = "Gun Turret Controller"
SWEP.Description = "Allows the user to manually take control of any turrets they own."
SWEP.Slot = 4
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFOV = 50

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

-- Cooldown between turret switches (shared for R and LMB).
SWEP.CycleDelay = 0.25

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self:SetDeploySpeed(10)
end

-- Returns a sorted list of the player's turrets.
-- Order: first by channel, then by EntIndex. Stable across frames.
function SWEP:GetOwnedTurrets()
	local turrets = {}
	local owner = self:GetOwner()
	if not owner:IsValid() then return turrets end

	for _, ent in pairs(ents.FindByClass("prop_gunturret*")) do
		if ent:GetObjectOwner() == owner then
			turrets[#turrets + 1] = ent
		end
	end

	table.sort(turrets, function(a, b)
		local ca, cb = a:GetChannel(), b:GetChannel()
		if ca ~= cb then return ca < cb end
		return a:EntIndex() < b:EntIndex()
	end)

	return turrets
end

function SWEP:CycleTurret(dir)
	local turrets = self:GetOwnedTurrets()
	if #turrets == 0 then
		self:SetTurret(NULL)
		return
	end

	local current = self:GetTurret()
	local idx = 0
	for i, t in ipairs(turrets) do
		if t == current then
			idx = i
			break
		end
	end

	if idx == 0 then
		-- The current one is lost — we start from edge
		idx = dir > 0 and 1 or #turrets
	else
		idx = idx + dir
		if idx < 1 then idx = #turrets end
		if idx > #turrets then idx = 1 end
	end

	self:SetTurret(turrets[idx])
end

-- General cooldown + check for "not in control mode".
-- Returns true only if the turret has actually changed
-- (>= 2 turrets and the cooldown has elapsed). Otherwise PrimaryAttack/Reload do not
-- play the switching sound.
function SWEP:TryCycle(dir)
	if self:GetDTBool(0) then return false end
	if CurTime() < (self.NextCycle or 0) then return false end

	local turrets = self:GetOwnedTurrets()

	-- Nothing to switch: 0 or 1 turret available.
	if #turrets < 2 then
		if #turrets == 0 then self:SetTurret(NULL) end
		return false
	end

	self.NextCycle = CurTime() + self.CycleDelay
	self:CycleTurret(dir)
	return true
end

function SWEP:Think()
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end

	if not SERVER then return end

	local turrets = self:GetOwnedTurrets()

	-- There are no more turrets — no weapons are needed.
	if #turrets == 0 then
		self:GetOwner():StripWeapon(self:GetClass())
		return
	end

	-- Current turret lost (destroyed) — select the first one.
	local current = self:GetTurret()
	local found = false
	for _, t in ipairs(turrets) do
		if t == current then
			found = true
			break
		end
	end

	if not found then
		self:SetTurret(turrets[1])
	end
end

-- The base weapon_zs_base doesn't call PrimaryAttack for weapons with ClipSize=-1,
-- because CanPrimaryAttack returns false. Force true.
function SWEP:CanPrimaryAttack()
	return true
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

	local turret = self:GetTurret()
	if not turret:IsValid() then return end

	self:SetDTBool(0, not self:GetDTBool(0))

	if CLIENT then
		MySelf:EmitSound(self:GetDTBool(0) and "buttons/button17.wav" or "buttons/button19.wav", 0)
	end
end

function SWEP:GetTurret()
	return self:GetDTEntity(0)
end

function SWEP:SetTurret(ent)
	self:SetDTEntity(0, ent)
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

function SWEP:GetResupplyAmmoType()
	local turret = self:GetTurret()
	if turret:IsValid() then
		return turret.AmmoType
	end

	return "smg1"
end

if not CLIENT then return end

function SWEP:DrawWeaponSelection(x, y, w, h, alpha)
	self:BaseDrawWeaponSelection(x, y, w, h, alpha)
end

-- ============================================================
-- HUD: panel with the list/status of the selected turret.
-- ============================================================
local colBG     = Color(16, 16, 16, 200)
local colBorder = Color(50, 255, 50, 220)
local colAccent = Color(255, 200, 60, 220)
local colRed    = Color(220, 60, 60, 220)
local colGray   = Color(180, 180, 180, 210)
local colBlack  = Color(0, 0, 0, 220)

-- Turret list cache to avoid sorting every frame.
local cachedTurrets, cachedTurretsAt, cachedTurretsWep
local function GetCachedOwnedTurrets(wep)
	local t = CurTime()
	if cachedTurretsWep == wep and cachedTurrets and t - cachedTurretsAt < 0.25 then
		return cachedTurrets
	end
	cachedTurretsWep = wep
	cachedTurrets = wep:GetOwnedTurrets()
	cachedTurretsAt = t
	return cachedTurrets
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

-- Forward declaration: the function itself is defined below, after DrawHUD,
-- but now we also need it in DrawHUD (the name of the selected turret in the panel).
-- local function creates a local variable at the point of definition,
-- so without this line DrawHUD would see nil.
local GetTurretPrettyName

function SWEP:DrawHUD()
	local ss = BetterScreenScale()
	local turrets = GetCachedOwnedTurrets(self)
	local inControl = self:GetDTBool(0)

	local labelFont = "ZSHUDFontSmaller"
	local labelH    = draw.GetFontHeight(labelFont)
	local pad       = 10 * ss
	local barH      = 12 * ss
	local headerH   = math.max(labelH, 16 * ss)
	local wid       = 340 * ss
	local radius    = 0
	local borderW   = math.max(1, math.Round(2 * ss))

	-- Dynamic height: title + HP (label+bar) + Ammo (label+bar)
	-- + channel line + hint line.
	local hei = 6 * ss + headerH + 6 * ss
	          + labelH + 6 * ss  -- turret name
	          + labelH + 3 * ss + barH + 8 * ss  -- HP
	          + labelH + 3 * ss + barH + 8 * ss  -- Ammo
	          + labelH + 2 * ss  -- channel
	          + labelH + 8 * ss  -- hint
	          + 6 * ss           -- bottom margin: actual glyph
	                             -- of the font is taller than GetFontHeight, plus
	                             -- the fallback Tahoma for Cyrillic has
	                             -- a larger descender than the base GFA

	local x = 20 * ss

	-- Vertical position. Previously there was a fixed ScrH() * 0.16 —
	-- at low resolutions (1280x720, 1024x768) this overlapped
	-- the player's upper HUD (level/XP/score bar). We take the maximum of
	-- the relative position and a hard offset so that on low
	-- screens the panel always starts below the upper HUD.
	local y = math.max(ScrH() * 0.22, 150 * ss)

	draw.RoundedBox(radius, x, y, wid, hei, colBG)

	local bc = inControl and colAccent or colBorder
	surface.SetDrawColor(bc)
	surface.DrawOutlinedRect(x, y, wid, hei, borderW)

	if #turrets == 0 then
		draw.SimpleText(translate.Get("gunturret_no_turrets"), "ZSHUDFontSmall",
			x + wid * 0.5, y + hei * 0.5, colRed,
			TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		return
	end

	local current = self:GetTurret()
	local idx = 0
	for i, t in ipairs(turrets) do
		if t == current then
			idx = i
			break
		end
	end

	-- Title: "Turret 2 / 5" on the left, status on the right.
	draw.SimpleText(
		translate.Format("gunturret_selection", idx, #turrets),
		labelFont, x + pad, y + 6 * ss, colBorder, TEXT_ALIGN_LEFT)

	local statusTxt = inControl and translate.Get("gunturret_control_active")
		or translate.Get("gunturret_control_standby")
	local statusCol = inControl and colAccent or colGray
	draw.SimpleText(statusTxt, labelFont,
		x + wid - pad, y + 6 * ss, statusCol, TEXT_ALIGN_RIGHT)

	-- Separator.
	surface.SetDrawColor(colBorder.r, colBorder.g, colBorder.b, 60)
	surface.DrawRect(x + pad, y + 6 * ss + headerH + 2 * ss, wid - pad * 2, 1)

	if not current:IsValid() then
		draw.SimpleText(translate.Get("gunturret_none_selected"),
			"ZSHUDFontSmall", x + wid * 0.5, y + hei * 0.5, colRed,
			TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		return
	end

	local health    = current:GetObjectHealth()
	local maxhealth = current:GetMaxObjectHealth()
	local ammo      = current:GetAmmo()
	local maxammo   = current.MaxAmmo
	local channel   = current:GetChannel()

	local hpf = math.Clamp(health / math.max(maxhealth, 1), 0, 1)
	local apf = math.Clamp(ammo   / math.max(maxammo,   1), 0, 1)

	local colHp = hpf > 0.5 and colBorder or (hpf > 0.25 and colAccent or colRed)

	local barX = x + pad
	local barW = wid - pad * 2

	local rowY = y + 6 * ss + headerH + 8 * ss

	-- ===== Name of the selected turret =====
	-- Duplicate the world indicator in the HUD: the world label is visible only
	-- when the turret is in the field of view, while the name is useful to read at all times.
	-- Color — from WeaponQualityColors: Sturdy is yellow, Honed is blue,
	-- Perfected is purple. For the base turret — colBorder
	local tname, tcolor = GetTurretPrettyName(current)
	DrawScrollingText(
		tname,
		"ZSHUDFontSmall",
		barX, rowY, barW, tcolor or COLOR_WHITE, TEXT_ALIGN_LEFT)

	rowY = rowY + labelH + 6 * ss

	-- ===== HP: label/value above the bar =====
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

	-- ===== Ammo =====
	local ammoRowY = rowY
	local ammoRowH = labelH + 3 * ss + barH

	if ammo > 0 then
		draw.SimpleText(translate.Format("gunturret_ammo_fmt", ammo, maxammo),
			labelFont, barX, rowY, colAccent, TEXT_ALIGN_LEFT)

		-- The strip is drawn using barY, we don't touch rowY —
		-- advance is performed ONCE below, after if/else.
		-- Previously, there was rowY = rowY + labelH + 3*ss here,
		-- and then the common advance repeated this offset →
		-- the channel and tooltip moved beyond the bottom edge of the panel.
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

	-- ===== Channel line (left) =====
	draw.SimpleText(
		translate.Format("channel_x_of_y", channel, GAMEMODE.MaxChannels["turret"]),
		labelFont, barX, rowY, colGray, TEXT_ALIGN_LEFT)

	rowY = rowY + labelH + 2 * ss

	-- ===== Hint — on a separate line. =====
	local hint
	if inControl then
		hint = translate.Get("gunturret_hint_fire")
		if type(hint) ~= "string" or hint:sub(1, 1) == "@" then
			hint = "LMB: fire  RMB: release"
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
-- World indicator for selected turret.
-- ============================================================
local matGlow = Material("sprites/glow04_noz")

-- Localized turret name for the world label.
-- The format follows the weapon convention ("Sturdy Gun Turret", see qlt_weapon_format_targetid):
--   prop_gunturret             → "GUN TURRET"
--   prop_gunturret_q1          → "STURDY GUN TURRET"
--   prop_gunturret_assault     → "ASSAULT TURRET"
--   prop_gunturret_buckshot_q2 → "HONED BLAST TURRET"
GetTurretPrettyName = function(ent)
	local klass    = ent:GetClass()
	local quality  = tonumber(klass:match("_q([123])$"))
	local base     = quality and klass:gsub("_q[123]$", "") or klass
	local variant  = base:gsub("^prop_gunturret", ""):gsub("^_", "")

	-- ─── Quality name ───
	-- Same keys as the weapon remantler: qlt_name_<id> (sturdy/honed/perfected).
	local qname
	if quality then
		local id = GAMEMODE.WeaponQualityNameIDs and GAMEMODE.WeaponQualityNameIDs[quality]
		if id then
			local qkey = "qlt_name_" .. id
			local v = translate.Get(qkey)
			if type(v) == "string" and v ~= qkey and v:sub(1, 1) ~= "@" then
				qname = v
			end
		end
		if not qname and GAMEMODE.WeaponQualities and GAMEMODE.WeaponQualities[quality] then
			qname = GAMEMODE.WeaponQualities[quality][1]
		end
		if not qname then qname = "Q" .. quality end
	end

	-- ─── Deployment name ───
	-- Reuse deployable_gunturret[_variant]. For the base turret, the key has no suffix.
	local nkey = variant ~= "" and ("deployable_gunturret_" .. variant) or "deployable_gunturret"
	local nname
	local n = translate.Get(nkey)
	if type(n) == "string" and n ~= nkey and n:sub(1, 1) ~= "@" then
		nname = n
	elseif variant ~= "" then
		nname = variant
	else
		nname = "Gun Turret"
	end

	local composed
	if qname then
		-- Reuse the weapon dismantler's format. If its language hasn't been set,
		-- fall back to the default "%quality% %name%".
		local fmt = translate.Get("qlt_weapon_format_targetid")
		if type(fmt) ~= "string" or fmt == "@qlt_weapon_format_targetid@" then
			fmt = "%quality% %name%"
		end
		composed = fmt:gsub("%%quality%%", function() return qname end)
		composed = composed:gsub("%%name%%",    function() return nname end)
	else
		composed = nname
	end

	-- ─── Uppercase (optional) ───
	if translate.Get("qlt_weapon_lowercase") ~= "0" then
		composed = string.upper(composed)
	end

	-- ─── Color by quality ───
	-- GM.WeaponQualityColors[i] — {base, for branch}. Turrets
	-- have no branches, so we always use [1]. For a base turret
	-- (quality == nil), return nil — the caller will substitute
	-- its own colBorder.
	local col
	if quality and GAMEMODE.WeaponQualityColors and GAMEMODE.WeaponQualityColors[quality] then
		col = GAMEMODE.WeaponQualityColors[quality][1]
	end

	return composed, col
end

hook.Add("PostDrawTranslucentRenderables", "ZS_GunTurretControl_Indicator", function(bDepth, bSkybox)
	if bDepth or bSkybox then return end

	local ply = LocalPlayer()
	if not IsValid(ply) then return end

	local wep = ply:GetActiveWeapon()
	if not IsValid(wep) or wep:GetClass() ~= "weapon_zs_gunturretcontrol" then return end

	local current = wep:GetTurret()
	if not current:IsValid() then return end

	local pos = current:GetPos()
	pos.z = pos.z + current:BoundingRadius() * 0.5 + 26

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

		-- The gunturret_world_label format contains %s (name) and %d (channel)
		-- in arbitrary order. We split the string into tokens and
		-- draw each in its own color: the name — based on quality, the channel
		-- and literals ("·", spaces) — in gray. Simply swapping
		-- %s and %d doesn't break the colors.
		local tname, tcolor = GetTurretPrettyName(current)

		local nameFont = "ZS3D2DFont2"

		local fmt = translate.Get("gunturret_world_label")
		if type(fmt) ~= "string" or fmt:sub(1, 1) == "@" then
			fmt = "%s · CH. %d"
		end

		-- Split the format into tokens. Both simple
		-- (%s, %d) and positional (%1$s, %2$d) placeholders are supported.
		local tokens = {}
		local i = 1
		while i <= #fmt do
			local s, e = fmt:find("%%%d*%$?[sd]", i)
			if not s then
				tokens[#tokens + 1] = { kind = "literal", text = fmt:sub(i) }
				break
			end
			if s > i then
				tokens[#tokens + 1] = { kind = "literal", text = fmt:sub(i, s - 1) }
			end
			tokens[#tokens + 1] = {
				kind = fmt:sub(e, e) == "s" and "name" or "channel",
			}
			i = e + 1
		end

		-- Substituting the values.
		for _, t in ipairs(tokens) do
			if t.kind == "name" then
				t.text = tname
			elseif t.kind == "channel" then
				t.text = tostring(current:GetChannel())
			end
		end

		-- Measure widths using the same function that
		-- font-fallback uses — otherwise, the channel numbers will shift for Cyrillic.
		local function measure(s)
			if ZS_MeasureMixedText then
				return ZS_MeasureMixedText(s, nameFont)
			end
			surface.SetFont(nameFont)
			return surface.GetTextSize(s)
		end

		local widths = {}
		local totalW = 0
		for idx, t in ipairs(tokens) do
			widths[idx] = measure(t.text)
			totalW = totalW + widths[idx]
		end

		-- Draw from left to right from the center.
		local labelY = size * 0.6
		local cx     = -totalW * 0.5

		for idx, t in ipairs(tokens) do
			local col = t.kind == "name"
				and (tcolor or COLOR_WHITE)
				or  COLOR_WHITE

			draw.SimpleText(t.text, nameFont, cx, labelY, col,
				TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

			cx = cx + widths[idx]
		end
	cam.End3D2D()
	cam.IgnoreZ(false)
end)