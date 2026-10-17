local cvFastSwitch = GetConVar("hud_fastswitch")

local SLOT_COUNT = 6 -- slots 0..9 (keys 1..9, 0)

local BASE = {
	SMALL_BOX  = 72,
	LARGE_W    = 252,
	LARGE_H    = 180,
	STRIP_W    = 252,
	STRIP_H    = 43,
	GAP        = 13,
	TOP_MARGIN = 16,
	RADIUS     = 4,
}

local M = {}
for k, v in pairs(BASE) do M[k] = v end
M.scale = 1

local SELECTION_TIMEOUT = 1.6
local FADE_TIME = 0.6

local COL_BOX_FILLED   = Color(0, 0, 0, 70)
local COL_BOX_EMPTY    = Color(0, 0, 0, 25)
local COL_BOX_ACTIVE   = Color(0, 0, 0, 100)
local COL_SELECTED     = Color(0, 0, 0, 90)
local COL_STRIP        = Color(0, 0, 0, 70)

local COL_NAME_RED     = Color(225, 50,  50)
local COL_NAME_YELLOW  = Color(240, 215, 60)
local COL_NUM          = Color(240, 215, 60)
local COL_AMMO         = Color(240, 240, 240)


local state = {
	open = false,
	slot = -1,
	index = 1,
	openTime = 0,
	lastWeapon = nil,
}

-- ============================================================
-- Per-player weapon cache
-- ------------------------------------------------------------
-- The HUD redraws every frame while open. Building the bucket
-- layout once per frame is cheaper than re-iterating and
-- re-sorting GetWeapons() for every slot on every access, and
-- it sidesteps the client-side invalidation problem entirely:
-- the weapon list is immutable within a single frame.
-- ============================================================
local cache = {
	ply     = nil,       -- owner of the current cache
	bySlot  = {},        -- [slot] = {weapons...}  (sorted, stable)
	hasSlot = {},        -- [slot] = true if non-empty
}
local cacheFrame = -1

local function WepSlot(w)
	local s = w.GetSlot and w:GetSlot()
	return tonumber(s) or 0
end

local function WepPos(w)
	local s = w.GetSlotPos and w:GetSlotPos()
	return tonumber(s) or 0
end

local function SortWeapons(a, b)
	local sa, sb = WepSlot(a), WepSlot(b)
	if sa ~= sb then return sa < sb end
	local pa, pb = WepPos(a), WepPos(b)
	if pa ~= pb then return pa < pb end
	-- Tie-breaker: preserve weapon acquisition order.
	-- _ZS_AcquireIdx is set in BuildWeaponCache.
	return (a._ZS_AcquireIdx or 0) < (b._ZS_AcquireIdx or 0)
end

-- Rebuilds the entire cache for `ply`. Filters out NULL entries
-- so a stale weapon ref can never reach the draw code.
local function BuildWeaponCache(ply)
	cache.ply = ply

	for k in pairs(cache.bySlot)  do cache.bySlot[k]  = nil end
	for k in pairs(cache.hasSlot) do cache.hasSlot[k] = nil end

	local weapons = ply:GetWeapons()
	for i = 1, #weapons do
		local w = weapons[i]
		if IsValid(w) then
			-- ply:GetWeapons() returns weapons in inventory insertion order.
			-- Remember that index so that table.sort (which is not stable)
			-- doesn't shuffle positions.
			w._ZS_AcquireIdx = i

			local s = WepSlot(w)
			local bucket = cache.bySlot[s]
			if bucket then
				bucket[#bucket + 1] = w
			else
				cache.bySlot[s]  = { w }
				cache.hasSlot[s] = true
			end
		end
	end

	for _, bucket in pairs(cache.bySlot) do
		table.sort(bucket, SortWeapons)
	end
end

local function EnsureWeaponCache(ply)
	local frame = FrameNumber()
	if cache.ply == ply and cacheFrame == frame then return end
	cacheFrame = frame
	BuildWeaponCache(ply)
end

-- Returns the cached, already-sorted table for `slot` (may be empty).
local function GetWeaponsInSlot(ply, slot)
	EnsureWeaponCache(ply)
	return cache.bySlot[tonumber(slot) or 0] or {}
end

local function SlotHasWeapons(ply, slot)
	EnsureWeaponCache(ply)
	return cache.hasSlot[tonumber(slot) or 0] or false
end

-- ============================================================
-- (rest of the file unchanged from here)
-- ============================================================

local function IsFastSwitch()
	return cvFastSwitch and cvFastSwitch:GetInt() ~= 0
end

local MIN_SOUND_INTERVAL = 0.05
local lastSoundTime = {}
local function PlayUISound(path)
	local now = CurTime()
	if lastSoundTime[path] and now - lastSoundTime[path] < MIN_SOUND_INTERVAL then return end
	lastSoundTime[path] = now

	surface.PlaySound(path)
end

local function GetAllWeaponsSorted(ply)
	EnsureWeaponCache(ply)

	local t = {}
	for slot = 0, SLOT_COUNT - 1 do
		local bucket = cache.bySlot[slot]
		if bucket then
			for i = 1, #bucket do
				t[#t + 1] = bucket[i]
			end
		end
	end
	return t
end

local function GetWeaponName(w)
	if not IsValid(w) then return "" end
	return (translate and translate.WeaponName(w)) or w:GetPrintName()
end

local function ApplyWeapon(wep)
	if not IsValid(wep) then return end
	RunConsoleCommand("use", wep:GetClass())
end

local function CloseSelection(playSound)
	if state.open and playSound then
		PlayUISound("Player.WeaponSelectionClose")
	end
	state.open = false
	state.slot = -1
	state.index = 1
end

local function GetSelectedWeapon()
	local ply = LocalPlayer()
	if not IsValid(ply) or state.slot < 0 then return end
	local weps = GetWeaponsInSlot(ply, state.slot)
	if #weps == 0 then return end
	if state.index < 1 then state.index = 1 end
	if state.index > #weps then state.index = #weps end
	return weps[state.index]
end

local function TouchSelection()
	state.openTime = CurTime()
	state.open = true
end

local function OpenOnSlot(ply, slot)
	slot = tonumber(slot) or 0
	local weps = GetWeaponsInSlot(ply, slot)
	if #weps == 0 then return false end

	local active = ply:GetActiveWeapon()
	local idx = 1
	for i, w in ipairs(weps) do
		if w == active then idx = i break end
	end

	state.slot = slot
	state.index = idx
	TouchSelection()
	return true
end

local function CycleInSlot(ply, dir)
	local weps = GetWeaponsInSlot(ply, state.slot)
	if #weps == 0 then return end
	local idx = state.index + dir
	if idx < 1 then idx = #weps end
	if idx > #weps then idx = 1 end
	state.index = idx
	TouchSelection()
end

local function HandleSlot(ply, slot, pressed)
	if not pressed then return true end
	slot = tonumber(slot) or 0

	local weps = GetWeaponsInSlot(ply, slot)
	if #weps == 0 then return true end

	if IsFastSwitch() then
		local active = ply:GetActiveWeapon()
		local idx = 0
		for i, w in ipairs(weps) do
			if w == active then idx = i break end
		end
		idx = idx % #weps + 1
		ApplyWeapon(weps[idx])
		return true
	end

	if state.open and state.slot == slot then
		CycleInSlot(ply, 1)
	else
		OpenOnSlot(ply, slot)
	end
	PlayUISound("Player.WeaponSelectionMoveSlot")
	return true
end

local function HandleCycle(ply, dir)
	local weps = GetAllWeaponsSorted(ply)
	if #weps == 0 then return end

	if IsFastSwitch() then
		local active = ply:GetActiveWeapon()
		local idx = 1
		for i, w in ipairs(weps) do
			if w == active then idx = i break end
		end
		idx = idx + dir
		if idx < 1 then idx = #weps end
		if idx > #weps then idx = 1 end
		ApplyWeapon(weps[idx])
		return
	end

	local curWep
	if state.open then curWep = GetSelectedWeapon() end
	if not IsValid(curWep) then curWep = ply:GetActiveWeapon() end

	local idx = 1
	for i, w in ipairs(weps) do
		if w == curWep then idx = i break end
	end
	idx = idx + dir
	if idx < 1 then idx = #weps end
	if idx > #weps then idx = 1 end

	local nextWep = weps[idx]
	if not IsValid(nextWep) then return end

	local slot = WepSlot(nextWep)
	local slotWeps = GetWeaponsInSlot(ply, slot)
	local newIdx = 1
	for i, w in ipairs(slotWeps) do
		if w == nextWep then newIdx = i break end
	end

	state.slot = slot
	state.index = newIdx
	TouchSelection()
	PlayUISound("Player.WeaponSelectionMoveSlot")
end

hook.Add("PlayerBindPress", "ZS_CustomWeaponSelection", function(ply, bind, pressed)
	if ply ~= LocalPlayer() then return end

	if string.sub(bind, 1, 4) == "slot" then
		local n = tonumber(string.sub(bind, 5))
		if not n then return end
		if n == 0 then n = 10 end
		if n >= 1 and n <= SLOT_COUNT then
			HandleSlot(ply, n - 1, pressed)
		end
		return true
	end

	if bind == "lastinv" then
		if IsValid(state.lastWeapon) and state.lastWeapon ~= ply:GetActiveWeapon() then
			if IsFastSwitch() then
				ApplyWeapon(state.lastWeapon)
			else
				local slot = WepSlot(state.lastWeapon)
				state.slot = slot
				local slotWeps = GetWeaponsInSlot(ply, slot)
				for i, w in ipairs(slotWeps) do
					if w == state.lastWeapon then state.index = i break end
				end
				TouchSelection()
				PlayUISound("Player.WeaponSelectionMoveSlot")
			end
		end
		return true
	end

	if bind == "invnext" then
		if pressed then HandleCycle(ply, 1) end
		return true
	end

	if bind == "invprev" then
		if pressed then HandleCycle(ply, -1) end
		return true
	end

	if bind == "+attack" and state.open then
		if pressed then
			local sel = GetSelectedWeapon()
			if IsValid(sel) then
				ApplyWeapon(sel)
				PlayUISound("Player.WeaponSelected")
			end
			CloseSelection(false)
		end
		return true
	end

	if bind == "+attack2" and state.open then
		if pressed then CloseSelection(true) end
		return true
	end
end)

hook.Add("PlayerSwitchWeapon", "ZS_TrackLastWeapon", function(ply, old, new)
	if ply == LocalPlayer() and IsValid(old) then
		state.lastWeapon = old
	end
end)

hook.Add("PlayerDeath", "ZS_CloseWeaponSelection", function(ply)
	if ply == LocalPlayer() then
		CloseSelection(false)
	end
end)

local function GetAlpha()
	local remaining = SELECTION_TIMEOUT - (CurTime() - state.openTime)
	if remaining >= FADE_TIME then return 1 end
	return math.Clamp(remaining / FADE_TIME, 0, 1)
end

local function UpdateLayoutScale()
	local s = (BetterScreenScale and BetterScreenScale()) or (ScrH() / 1080)
	s = math.Clamp(s, 0.55, 1.4)

	local baseTotal = 0
	for i = 0, SLOT_COUNT - 1 do
		baseTotal = baseTotal + (i == 0 and BASE.LARGE_W or BASE.SMALL_BOX) + BASE.GAP
	end
	baseTotal = baseTotal - BASE.GAP

	local maxW = ScrW() * 0.92
	if baseTotal * s > maxW then
		s = maxW / baseTotal
	end

	M.scale = s

	for k, v in pairs(BASE) do
		M[k] = math.max(1, math.floor(v * s + 0.5))
	end

	local r = math.max(4, math.floor(BASE.RADIUS * s + 0.5))
	if r % 2 == 1 then r = r + 1 end
	M.RADIUS = r

	local totalW = 0
	for i = 0, SLOT_COUNT - 1 do
		totalW = totalW + (i == 0 and M.LARGE_W or M.SMALL_BOX) + M.GAP
	end
	totalW = totalW - M.GAP

	if totalW > maxW then
		local extra = maxW / totalW
		for k, v in pairs(M) do
			if k ~= "scale" and k ~= "RADIUS" then
				M[k] = math.max(1, math.floor(v * extra + 0.5))
			end
		end
	end
end

local function FillRounded(x, y, w, h, col, alphaMul)
	local ix = math.floor(x + 0.5)
	local iy = math.floor(y + 0.5)
	local iw = math.floor(w + 0.5)
	local ih = math.floor(h + 0.5)
	local ia = math.floor(col.a * alphaMul + 0.5)

	if iw <= 0 or ih <= 0 or ia <= 0 then return end

	local r = M.RADIUS

	if r < 4 or iw < r * 3 or ih < r * 3 or ia < 12 then
		surface.SetDrawColor(col.r, col.g, col.b, ia)
		surface.DrawRect(ix, iy, iw, ih)
		return
	end

	draw.RoundedBox(r, ix, iy, iw, ih, Color(col.r, col.g, col.b, ia))
end

local function DrawKillIcon(cls, cx, cy, maxW, maxH, alpha)
	local ki = killicon.Get(cls)
	if not ki then return end

	local cols = ki[#ki] or color_white
	local r, g, b = cols.r or 255, cols.g or 255, cols.b or 255

	if #ki == 3 then
		local font = ki[1] .. "ws"
		surface.SetFont(font)
		draw.SimpleText(ki[2], font, cx, cy, Color(r, g, b, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	else
		local mat = Material(ki[1])
		local iw, ih = mat:Width(), mat:Height()
		if iw <= 0 or ih <= 0 then return end

		local scale = math.min(maxW / iw, maxH / ih, 1)
		local dw, dh = iw * scale, ih * scale

		surface.SetMaterial(mat)
		surface.SetDrawColor(r, g, b, alpha)
		surface.DrawTexturedRect(cx - dw * 0.5, cy - dh * 0.5, dw, dh)
	end
end

local function DrawStrip(wep, x, y, w, h, alpha)
	FillRounded(x, y, w, h, COL_STRIP, alpha)
	draw.SimpleText(GetWeaponName(wep), "ZSHUDFontSmallest", x + w * 0.5, y + h * 0.5, Color(COL_NAME_YELLOW.r, COL_NAME_YELLOW.g, COL_NAME_YELLOW.b, 255 * alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

local function DrawSmallSlot(x, y, size, number, hasWeapon, alpha)
	FillRounded(x, y, size, size, hasWeapon and COL_BOX_FILLED or COL_BOX_EMPTY, alpha)

	if hasWeapon then
		local s = M.scale
		draw.SimpleText(tostring(number), "ZSHUDFontSmaller", x + 10 * s, y + 8 * s, Color(COL_NUM.r, COL_NUM.g, COL_NUM.b, 255 * alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end
end

local function DrawSelectedContent(wep, x, y, w, h, alpha)
	FillRounded(x, y, w, h, COL_SELECTED, alpha)
	local s = M.scale

	draw.SimpleTextBlur(GetWeaponName(wep), "ZSHUDFontSmallest", x + w * 0.5, y + 6 * s, Color(COL_NAME_RED.r, COL_NAME_RED.g, COL_NAME_RED.b, 255 * alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

	DrawKillIcon(wep:GetClass(), x + w * 0.5, y + h * 0.5, w * 0.6, h * 0.5, 255 * alpha)

	local function DrawAmmoCount(total, inclip, clipSize, tx, align, noReserve)
		if clipSize < 0 then
			local text = translate.Format("wep_select_ammo_single", total)
			local col = total <= 0
				and Color(COLOR_RED.r, COLOR_RED.g, COLOR_RED.b, 255 * alpha)
				or Color(COL_AMMO.r, COL_AMMO.g, COL_AMMO.b, 255 * alpha)
			draw.SimpleTextBlur(text, "ZSHUDFontSmallest", tx, y + h - 6 * s, col, align, TEXT_ALIGN_BOTTOM_REAL)
			return
		end

		if inclip < 0 then return end

		-- Initially treat a weapon as a tool if it has 1 round in the clip or less.
		local isTool = clipSize > 0 and clipSize <= 1

		-- NEW: if the weapon explicitly sets the ShowReserveAmmo flag, force showing reserve.
		if wep and wep.ShowReserveAmmo then
			isTool = false
		end

		local text
		if noReserve then
			text = translate.Format("wep_select_ammo_single", inclip)
		elseif isTool then
			text = translate.Format("wep_select_ammo_single", total)
		else
			text = translate.Format("wep_select_ammo_clip", inclip, math.max(0, total - inclip))
		end

		local col
		if noReserve then
			col = Color(COL_AMMO.r, COL_AMMO.g, COL_AMMO.b, 255 * alpha)
		elseif total <= 0 then
			col = Color(COLOR_RED.r, COLOR_RED.g, COLOR_RED.b, 255 * alpha)
		elseif isTool or inclip > 0 then
			col = Color(COL_AMMO.r, COL_AMMO.g, COL_AMMO.b, 255 * alpha)
		else
			col = Color(COLOR_YELLOW.r, COLOR_YELLOW.g, COLOR_YELLOW.b, 255 * alpha)
		end

		draw.SimpleTextBlur(text, "ZSHUDFontSmallest", tx, y + h - 6 * s, col, align, TEXT_ALIGN_BOTTOM_REAL)
	end

	local owner = wep:GetOwner()

		local function DrawAmmoFor(ammoType, clip, clipSize, tx, align)
		if not ammoType then return end

		if clip < 0 or clipSize < 0 then
			-- No magazine tracking (shotgun-like / infinite reserve):
			-- only show the pool.
			local total = IsValid(owner) and owner:GetAmmoCount(ammoType) or 0
			DrawAmmoCount(total, 0, -1, tx, align)
			return
		end

		local reserve = IsValid(owner) and owner:GetAmmoCount(ammoType) or 0

		-- SWEPs like the Peashooter use half ammo per shot and expose
		-- GetDisplayAmmo(clip, spare, maxclip) that doubles the shown
		-- numbers. Without applying it here, the weapon-selection HUD
		-- displays half of what the weapon's own HUD shows.
		if wep.GetDisplayAmmo then
			local dclip, dspare, dmaxclip = wep:GetDisplayAmmo(clip, reserve, clipSize)
			if dclip then
				clip     = dclip
				reserve  = dspare  or reserve
				clipSize = dmaxclip or clipSize
			end
		end

		local total = clip + reserve

		-- NoMagazine weapons (medical kit, gluon gun, …) treat the
		-- entire pool as a single number: their own DrawHUD calls
		-- GetPrimaryAmmoCount() (= clip + reserve) and shows one figure.
		-- The selection HUD must match by showing "[total]" instead
		-- of "[clip / reserve]". Passing `total` for both positions
		-- reuses DrawAmmoCount's noReserve path unchanged.
		if wep.NoMagazine then
			DrawAmmoCount(total, total, clipSize, tx, align, true)
			return
		end

		DrawAmmoCount(total, clip, clipSize, tx, align)
	end
	
	-- Walks up the Base chain and returns the first non-empty value of the
	-- field (Ammo/ClipSize/DefaultClip) from Primary/Secondary. Needed for
	-- weapons that override SWEP.Primary.* and lose the inherited
	-- Ammo/ClipSize (e.g., weapon_zs_cinderrod ← weapon_zs_blareduct).
	local function InheritField(wep, slot, field)
		local t = wep
		local guard = 0

		while t and guard < 16 do
			guard = guard + 1
			local p = t[slot]
			local v = p and p[field]
			if v ~= nil and v ~= "" then
				return v
			end

			local base = t.Base
			if type(base) == "string" then
				t = weapons.GetStored(base)
			else
				t = base
			end
		end
	end

	local function ResolvePrimaryAmmoType(w)
		local ammo = InheritField(w, "Primary", "Ammo")
		if type(ammo) == "string" and ammo ~= "" and ammo ~= "none" and ammo ~= "dummy" then
			return string.lower(ammo)
		end

		-- For engine weapons (HL2/CSS/GMod) Primary.Ammo is not set —
		-- ask the engine.
		if not w:IsScripted() then
			local id = w:GetPrimaryAmmoType()
			if id and id > 0 then
				return game.GetAmmoName(id)
			end
		end
	end

	local function ResolveSecondaryAmmoType(w)
		local ammo = InheritField(w, "Secondary", "Ammo")
		if type(ammo) == "string" and ammo ~= "" and ammo ~= "none" and ammo ~= "dummy" then
			return string.lower(ammo)
		end

		if not w:IsScripted() then
			local id = w:GetSecondaryAmmoType()
			if id and id > 0 then
				return game.GetAmmoName(id)
			end
		end
	end

	local stored    = weapons.GetStored(wep:GetClass())
	local primary   = wep.Primary   or (stored and stored.Primary)
	local secondary = wep.Secondary or (stored and stored.Secondary)

	local primAmmoType    = ResolvePrimaryAmmoType(wep)
	local defaultClipPrim = (primary and primary.DefaultClip) or InheritField(wep, "Primary", "DefaultClip") or 0
	local infiniteReserve = (defaultClipPrim == 99999)

	if infiniteReserve then
		local clip     = wep:Clip1()
		local clipSize = (primary and primary.ClipSize) or 0
		local text     = clipSize > 0 and translate.Format("wep_select_ammo_infinite", clip) or translate.Format("wep_select_ammo_single", clip)
		local col      = clip <= 0 and Color(COLOR_RED.r, COLOR_RED.g, COLOR_RED.b, 255 * alpha) or Color(COL_AMMO.r, COL_AMMO.g, COL_AMMO.b, 255 * alpha)
		draw.SimpleTextBlur(text, "ZSHUDFontSmallest",
			x + 10 * s, y + h - 6 * s, col,
			TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM_REAL)
	elseif primAmmoType then
		local clip     = wep:Clip1()
		local clipSize = (primary and primary.ClipSize) or InheritField(wep, "Primary", "ClipSize") or 0
		DrawAmmoFor(primAmmoType, clip, clipSize, x + 10 * s, TEXT_ALIGN_LEFT)
	elseif wep.NoMagazine then
		-- Soft fallback: no valid ammoType, but the weapon still consumes
		-- ammo. Show what's actually in the pool.
		local total = wep:GetPrimaryAmmoCount()
		DrawAmmoCount(total, total, 0, x + 10 * s, TEXT_ALIGN_LEFT, true)
	end

	local secAmmoType = ResolveSecondaryAmmoType(wep)
	if secAmmoType then
		local clip     = wep:Clip2()
		local clipSize = (secondary and secondary.ClipSize) or InheritField(wep, "Secondary", "ClipSize") or 0
		DrawAmmoFor(secAmmoType, clip, clipSize, x + w - 10 * s, TEXT_ALIGN_RIGHT)
	end
end

hook.Add("HUDPaint", "ZS_DrawWeaponSelection", function()
	if not state.open then return end
	local ply = LocalPlayer()
	if not IsValid(ply) or not ply:Alive() then CloseSelection(false) return end

	if CurTime() - state.openTime > SELECTION_TIMEOUT then
		CloseSelection(false)
		return
	end

	UpdateLayoutScale()

	local alpha = GetAlpha()

	local totalW = 0
	for s = 0, SLOT_COUNT - 1 do
		totalW = totalW + (s == state.slot and M.LARGE_W or M.SMALL_BOX) + M.GAP
	end
	totalW = totalW - M.GAP

	local startX = math.floor((ScrW() - totalW) * 0.5 + 0.5)
	local baseY  = M.TOP_MARGIN

	local x = startX
	for s = 0, SLOT_COUNT - 1 do
		local has      = SlotHasWeapons(ply, s)
		local isActive = (s == state.slot)
		local keynum   = s + 1

		if isActive then
			local weps = GetWeaponsInSlot(ply, s)
			if #weps == 0 then
				DrawSmallSlot(x, baseY, M.SMALL_BOX, keynum, false, alpha)
				x = x + M.SMALL_BOX + M.GAP
			else
				if state.index < 1 then state.index = 1 end
				if state.index > #weps then state.index = #weps end

				local totalH = 0
				for i in ipairs(weps) do
					totalH = totalH + (i == state.index and M.LARGE_H or M.STRIP_H) + M.GAP
				end
				totalH = math.max(0, totalH - M.GAP)
				FillRounded(x, baseY, M.LARGE_W, totalH, COL_BOX_ACTIVE, alpha)

				draw.SimpleText(tostring(keynum), "ZSHUDFontSmaller", x + 10 * M.scale, baseY + 6 * M.scale, Color(COL_NUM.r, COL_NUM.g, COL_NUM.b, 255 * alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

				local y = baseY
				for i, w in ipairs(weps) do
					if i == state.index then
						DrawSelectedContent(w, x, y, M.LARGE_W, M.LARGE_H, alpha)
						y = y + M.LARGE_H + M.GAP
					else
						DrawStrip(w, x, y, M.STRIP_W, M.STRIP_H, alpha)
						y = y + M.STRIP_H + M.GAP
					end
				end

				x = x + M.LARGE_W + M.GAP
			end
		else
			DrawSmallSlot(x, baseY, M.SMALL_BOX, keynum, has, alpha)
			x = x + M.SMALL_BOX + M.GAP
		end
	end
end)

function GM:IsWeaponSelectOpen()
	return state.open
end