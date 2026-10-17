function player.GetAllActive()
	local t = {}

	for _, pl in pairs(player.GetAll()) do
		if not pl:IsSpectator() then
			t[#t + 1] = pl
		end
	end

	return t
end

function player.GetAllSpectators()
	local t = {}

	for _, pl in pairs(player.GetAll()) do
		if pl:IsSpectator() then
			t[#t + 1] = pl
		end
	end

	return t
end

function FindStartingItem(id)
	local item = FindItem(id)
	if item and item.WorthShop then return item end
end

function FindItem(id)
	return GAMEMODE.Items[id]
end

-- DEPRECATED behavior. CachedInvisibleEntities and filter tables is nonsense. Move to using functions.
local TrueVisibleTrace = {mask = MASK_SHOT}
function TrueVisible(posa, posb, filter)
	local filt = ents.FindByClass("projectile_*")
	filt = table.Add(filt, SERVER and GAMEMODE.CachedInvisibleEntities or player.GetAll())
	if filter then
		filt[#filt + 1] = filter
	end

	TrueVisibleTrace.start = posa
	TrueVisibleTrace.endpos = posb
	TrueVisibleTrace.filter = filt
	TrueVisibleTrace.mask = MASK_SHOT

	return not util.TraceLine(TrueVisibleTrace).Hit
end

-- DEPRECATED behavior. CachedInvisibleEntities and filter tables is nonsense. Move to using functions.
function TrueVisibleFilters(posa, posb, ...)
	local filt = ents.FindByClass("projectile_*")
	filt = table.Add(filt, SERVER and GAMEMODE.CachedInvisibleEntities or player.GetAll())
	if ... ~= nil then
		filt = table.Add(filt, {...})
	end

	TrueVisibleTrace.start = posa
	TrueVisibleTrace.endpos = posb
	TrueVisibleTrace.filter = filt
	TrueVisibleTrace.mask = MASK_SHOT

	return not util.TraceLine(TrueVisibleTrace).Hit
end

-- Useful macros for the 3 file system
function INC_SERVER()
	AddCSLuaFile("shared.lua")
	AddCSLuaFile("cl_init.lua")
	include("shared.lua")
end

function INC_CLIENT()
	include("shared.lua")
end
INC_CLIENT_NO_SHARED = INC_CLIENT

function INC_SERVER_NO_SHARED()
	AddCSLuaFile("cl_init.lua")
end

function INC_SERVER_NO_CLIENT()
	AddCSLuaFile("shared.lua")
end

-- Just in case you add this by mistake because it does nothing
function INC_SHARED()
end

MASK_SHOT_OPAQUE = bit.bor(MASK_SHOT, CONTENTS_OPAQUE)
-- Literally if photon particles can reach point b from point a.
local LightVisibleTrace = {mask = MASK_SHOT_OPAQUE}
function LightVisible(posa, posb, ...)
	local filter
	if ... ~= nil then
		filter = {...}
	end

	LightVisibleTrace.start = posa
	LightVisibleTrace.endpos = posb
	LightVisibleTrace.filter = filter

	return not util.TraceLine(LightVisibleTrace).Hit
end

local WorldVisibleTrace = {mask = MASK_SOLID_BRUSHONLY}
function WorldVisible(posa, posb)
	WorldVisibleTrace.start = posa
	WorldVisibleTrace.endpos = posb
	return not util.TraceLine(WorldVisibleTrace).Hit
end

function CosineInterpolation(y1, y2, mu)
	local mu2 = (1 - math.cos(mu * math.pi)) / 2
	return y1 * (1 - mu2) + y2 * mu2
end

function CubicInterpolate(y0, y1, y2, y3, mu)
	local mu2 = mu * mu
	local a0 = y3 - y2 - y0 + y1
	local a1 = y0 - y1 - a0
	local a2 = y2 - y0

	return a0 * mu * mu2 + a1 * mu2 + a2 * mu + y1
end

--[[function CatmullInterpolate(y0, y1, y2, y3, mu)
	local mu2 = mu * mu
	local a0 = -0.5 * y0 + 1.5 * y1 - 1.5 * y2 + 0.5 * y3
	local a1 = y0 - 2.5 * y1 + 2 * y2 - 0.5 * y3
	local a2 = -0.5 * y0 + 0.5 * y2

	return a0 * mu * mu2 + a1 * mu2 + a2 * mu + y1
end]]

function CatmullInterpolate(previous, start, last, nextp, elapsedTime, duration)
		local percentComplete = elapsedTime / duration
		local percentCompleteSquared = percentComplete * percentComplete
		local percentCompleteCubed = percentCompleteSquared * percentComplete

		return previous * (-0.5 * percentCompleteCubed +
								   percentCompleteSquared -
							0.5 * percentComplete) +
				start * (1.5 * percentCompleteCubed +
						   -2.5 * percentCompleteSquared + 1.0) +
				last * (-1.5 * percentCompleteCubed +
							2.0 * percentCompleteSquared +
							0.5 * percentComplete) +
				nextp * (0.5 * percentCompleteCubed -
							0.5 * percentCompleteSquared)
end

function string.AndSeparate(list, listSeparator, andSeparator, finalSeparator, transform)
	local length = #list
	if length <= 0 then return "" end
	if length == 1 then return list[1] end

	listSeparator  = listSeparator  or ", "
	andSeparator   = andSeparator   or " and "
	finalSeparator = finalSeparator or ", and "

	if transform then
		local t = {list[1]}
		for i = 2, length do
			t[i] = transform(list[i], i) or list[i]
		end
		list = t
	end

	if length == 2 then
		return list[1]..andSeparator..list[2]
	end

	return table.concat(list, listSeparator, 1, length - 1)..finalSeparator..list[length]
end

function string.utf8lower(s)
	if not s or s == "" then return s end

	-- Fast-path for ASCII: 90% of strings on the server — English text.
	if not s:find("[\128-\255]") then
		return s:lower()
	end

	local ok, result = pcall(function()
		local out = {}
		for _, code in utf8.codes(s) do
			local lower = code

			if code >= 65 and code <= 90 then
				lower = code + 32
			elseif code >= 1040 and code <= 1071 then
				lower = code + 32
			elseif code == 1025 then lower = 1105
			elseif code == 1030 then lower = 1110
			elseif code == 1031 then lower = 1111
			elseif code == 1028 then lower = 1108
			elseif code == 1168 then lower = 1169
			end

			out[#out + 1] = utf8.char(lower)
		end
		return table.concat(out)
	end)

	if not ok then return s end
	return result
end

function util.SkewedDistance(a, b, skew)
	if a.z > b.z then
		return math.sqrt((b.x - a.x) ^ 2 + (b.y - a.y) ^ 2 + ((a.z - b.z) * skew) ^ 2)
	end

	return a:Distance(b)
end

function util.IsServerOrClient()
	return SERVER and "SERVER" or "CLIENT"
end

function util.Blood(pos, amount, dir, force, noprediction)
	local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		effectdata:SetMagnitude(amount)
		effectdata:SetNormal(dir)
		effectdata:SetScale(math.max(128, force))
	util.Effect("bloodstream", effectdata, nil, noprediction)
end

function util.BlastDamagePlayer(inf, att, center, radius, damage, damagetype, taperfactor)
	if not att:IsValidPlayer() then ErrorNoHalt("[BlastDamagePlayer] Tried to use a nonplayer") end

	util.BlastDamageEx(inf, att, center, radius * (att.ExpDamageRadiusMul or 1), damage * (att.ExplosiveDamageMul or 1), damagetype, taperfactor)
end

-- I had to make this since the default function checks visibility vs. the entitiy's center and not the nearest position.
function util.BlastDamageEx(inflictor, attacker, epicenter, radius, damage, damagetype, taperfactor)
	local basedmg = damage

	for _, ent in pairs(ents.FindInSphere(epicenter, radius)) do
		if ent:IsValid() then
			local nearest = ent:NearestPoint(epicenter)
			if TrueVisibleFilters(epicenter, nearest, inflictor, attacker, ent)
				or TrueVisibleFilters(epicenter, ent:EyePos(), inflictor, attacker, ent)
				or TrueVisibleFilters(epicenter, ent:WorldSpaceCenter(), inflictor, attacker, ent) then

				ent:TakeSpecialDamage(((radius - nearest:Distance(epicenter)) / radius) * basedmg, damagetype, attacker, inflictor, nearest)

				if taperfactor and ent:IsPlayer() then
					basedmg = basedmg * taperfactor
				end
			end
		end
	end
end

function util.BlastDamageExAlloc(inflictor, attacker, epicenter, radius, damage, damagetype)
	local dmg
	local t = {}

	for _, ent in pairs(ents.FindInSphere(epicenter, radius)) do
		if ent:IsValid() then
			local nearest = ent:NearestPoint(epicenter)
			if TrueVisibleFilters(epicenter, nearest, inflictor, attacker, ent)
				or TrueVisibleFilters(epicenter, ent:EyePos(), inflictor, attacker, ent)
				or TrueVisibleFilters(epicenter, ent:WorldSpaceCenter(), inflictor, attacker, ent) then

				dmg = ((radius - nearest:Distance(epicenter)) / radius) * damage
				ent:TakeSpecialDamage(dmg, damagetype, attacker, inflictor, nearest)

				t[ent] = dmg
			end
		end
	end

	return t
end

function util.BlastAlloc(inflictor, attacker, epicenter, radius)
	local t = {}

	for _, ent in pairs(ents.FindInSphere(epicenter, radius)) do
		if ent:IsValid() then
			local nearest = ent:NearestPoint(epicenter)
			if TrueVisibleFilters(epicenter, nearest, inflictor, attacker, ent)
				or TrueVisibleFilters(epicenter, ent:EyePos(), inflictor, attacker, ent)
				or TrueVisibleFilters(epicenter, ent:WorldSpaceCenter(), inflictor, attacker, ent) then
				t[#t + 1] = ent
			end
		end
	end

	return t
end

function util.FindValidInSphere(pos, radius)
	local ret = {}

	for _, ent in pairs(util.FindInSphere(pos, radius)) do
		if ent:IsValid() then
			ret[#ret + 1] = ent
		end
	end

	return ret
end

function util.PoisonBlastDamage(inflictor, attacker, epicenter, radius, damage, noreduce, instant)
	for _, ent in pairs(ents.FindInSphere(epicenter, radius)) do
		if ent:IsValid() then
			local nearest = ent:NearestPoint(epicenter)
			if TrueVisibleFilters(epicenter, nearest, inflictor, attacker, ent)
				or TrueVisibleFilters(epicenter, ent:EyePos(), inflictor, attacker, ent)
				or TrueVisibleFilters(epicenter, ent:WorldSpaceCenter(), inflictor, attacker, ent) then
				ent:PoisonDamage(((radius - nearest:Distance(epicenter)) / radius) * damage, attacker, inflictor, nil, noreduce, instant)
			end
		end
	end
end

function util.ToMinutesSeconds(seconds)
	local minutes = math.floor(seconds / 60)
	seconds = seconds - minutes * 60

	return string.format("%02d:%02d", minutes, math.floor(seconds))
end

-- More appropriate for count downs. Timer will display 00:01 if less than a second remains and never display 00:00.
function util.ToMinutesSecondsCD(seconds)
	seconds = math.ceil(seconds)
	local minutes = math.floor(seconds / 60)
	seconds = seconds - minutes * 60

	return string.format("%02d:%02d", minutes, seconds)
end

function util.ToMinutesSecondsMilliseconds(seconds)
	local minutes = math.floor(seconds / 60)
	seconds = seconds - minutes * 60

	local milliseconds = math.floor(seconds % 1 * 100)

	return string.format("%02d:%02d.%02d", minutes, math.floor(seconds), milliseconds)
end

function util.RemoveAll(class)
	for _, ent in pairs(ents.FindByClass(class)) do
		ent:Remove()
	end
end

-- Takes a table of false/trues with numbers as the keys, compresses to array of chars (8 bits), in other words a string, for storage in files.
-- The net library already uses the smallest number of bits needed so this is only for storing data.
function util.CompressBitTable(t)
	local buf = ""
	local maxvalue = 0

	t = table.ToAssoc(t)

	for k in pairs(t) do
		if k > maxvalue then maxvalue = k end
	end
	local num_bytes = math.ceil(maxvalue / 8)

	for on_byte = 1, num_bytes do
		local byte = 0

		for bit_slot = 1, 8 do
			if t[bit_slot + 8 * (on_byte - 1)] then
				byte = bit.bor(byte, 2 ^ (bit_slot - 1))
			end
		end

		buf = buf..string.char(byte)
	end

	return buf
end

function util.DecompressBitTable(str, associative)
	local t = {}

	for on_byte = 1, #str do
		local byte = str:sub(on_byte, on_byte):byte()
		for bit_slot = 1, 8 do
			if bit.band(byte, 1) == 1 then
				local v = bit_slot + 8 * (on_byte - 1)
				if associative then
					t[v] = true
				else
					t[#t + 1] = v
				end
			end
			byte = bit.arshift(byte, 1)
		end
	end

	return t
end

function table.IsAssoc(t)
	for _, v in pairs(t) do
		if v == true then
			return true
		end
	end

	return false
end

function table.ToAssoc(t)
	if not table.IsAssoc(t) then
		local t2 = {}

		for k, v in pairs(t) do
			t2[v] = true
		end

		return t2
	end

	return t
end

function table.ToKeyValues(t)
	if table.IsAssoc(t) then
		local t2 = {}

		for k, v in pairs(t) do
			if v then
				t2[#t2 + 1] = k
			end
		end

		return t2
	end

	return t
end

local function TooNear(spawn, tab, dist)
	dist = dist * dist

	local spawnpos = spawn:GetPos()
	for _, ent in pairs(tab) do
		if ent:GetPos():DistToSqr(spawnpos) <= dist then
			return true
		end
	end

	return false
end
function team.GetSpawnPointGrouped(teamid, dist)
	dist = dist or 200

	local tab = {}
	local spawns = team.GetSpawnPoint(teamid)

	for _, spawn in pairs(spawns) do
		if not TooNear(spawn, tab, dist) then
			table.insert(tab, spawn)
		end
	end

	return tab
end

function AccessorFuncDT(tab, membername, type, id)
	local emeta = FindMetaTable("Entity")
	local setter = emeta["SetDT"..type]
	local getter = emeta["GetDT"..type]

	tab["Set"..membername] = function(me, val)
		setter(me, id, val)
	end

	tab["Get"..membername] = function(me)
		return getter(me, id)
	end
end

function team.GetValidSpawnPoint(teamid)
	local t = {}

	local spawns = team.GetSpawnPoint(teamid)
	if spawns then
		for _, ent in pairs(spawns) do
			if ent:IsValid() and not ent.Disabled then
				t[#t + 1] = ent
			end
		end
	end

	return t
end

function ents.CreateLimited(class, limit)
	if #ents.FindByClass(class) >= (limit or 32) then return NULL end

	return ents.Create(class)
end

function string.CommaSeparate(num)
	local k
	for ___=1, 10000 do
		num, k = string.gsub(num, "^(-?%d+)(%d%d%d)", "%1,%2")
		if k == 0 then break end
	end
	return num
end

function tonumbersafe(a)
	local n = tonumber(a)

	if n then
		if n == 0 or n < 0 or n > 0 then
			return n
		end

		-- NaN!
		return 0
	end

	return nil
end

-- y from the top left can be retrieved with quad_h - y
function util.IntersectRayWithQuad(start, dir, quad_bottom_left, quad_angles, quad_w, quad_h, double_sided)
	local quad_normal = quad_angles:Forward()

	if not double_sided and dir:Dot(quad_normal) > 0 then return end

	local hitpos = util.IntersectRayWithPlane(start, dir, quad_bottom_left, quad_normal)
	if hitpos then
		local lpos, _ = WorldToLocal(hitpos, quad_angles, quad_bottom_left, quad_angles)
		local x = lpos.y
		local y = lpos.z
		if x >= 0 and x <= quad_w and y >= 0 and y <= quad_h then
			return hitpos, x, y
		end
	end
end

local pulseeffect = EffectData()
pulseeffect:SetRadius(8)
pulseeffect:SetMagnitude(1)
pulseeffect:SetScale(1)
function util.CreatePulseImpactEffect(hitpos, hitnormal)
	pulseeffect:SetOrigin(hitpos)
	pulseeffect:SetNormal(hitnormal)
	util.Effect("cball_bounce", pulseeffect)
end

-- Truncates a UTF-8 string so its rendered width in `font` doesn't exceed `maxw` pixels.
-- Appends `suffix` (default "..") if truncation happened.
-- Uses binary search on UTF-8 character boundaries — safe for CJK, Cyrillic, Latin, etc.
function string.TruncateUTF8ToWidth(s, font, maxw, suffix)
    if not s or s == "" then return s end
    suffix = suffix or ".."

    local function measure(t)
        if ZS_MeasureMixedText then
            return ZS_MeasureMixedText(t, font)
        end
        surface.SetFont(font)
        return surface.GetTextSize(t)
    end

    if measure(s) <= maxw then return s end

    local suffixW = measure(suffix)
    if suffixW >= maxw then return suffix end

    local target = maxw - suffixW
    local len = utf8.len(s)
    if not len then return s end

    local lo, hi = 0, len
    while lo < hi do
        local mid = math.floor((lo + hi + 1) / 2)
        local ok, byteidx = pcall(utf8.offset, s, mid + 1)
        if not ok or not byteidx then break end
        if measure(s:sub(1, byteidx - 1)) <= target then
            lo = mid
        else
            hi = mid - 1
        end
    end

    if lo < 1 then return suffix end
    local ok, byteidx = pcall(utf8.offset, s, lo + 1)
    if not ok or not byteidx then return suffix end
    return s:sub(1, byteidx - 1) .. suffix
end

-- Splits a string into lines so that each fits within maxw pixels.
-- Works both by spaces (Latin/Cyrillic) and character-by-character (CJK).
-- maxlines — maximum number of lines. If the text does not fit, the last line
-- is appended with the tail and truncated with "..".
-- Requires string.TruncateUTF8ToWidth (declared above).
function string.WrapTextLines(text, font, maxw, maxlines)
    if not text or text == "" then return { "" } end
    maxlines = maxlines or 2

    -- Use the mixed-font measurer when it exists. The client installs it
    -- in cl_fontfallback.lua; on the server it's absent and we fall back
    -- to the plain surface.GetTextSize. Without this the base decorative
    -- font (which has no Cyrillic glyphs) reports near-zero width for
    -- Russian text, and wrapping never kicks in.
    local function measure(s)
        if ZS_MeasureMixedText then
            return ZS_MeasureMixedText(s, font)
        end
        surface.SetFont(font)
        return surface.GetTextSize(s)
    end

    if measure(text) <= maxw then
        return { text }
    end

    local lines = {}
    local current = ""
    local i = 1
    local n = #text

    while i <= n do
        local b = string.byte(text, i)
        local charLen = 1
        if b >= 0xF0 then charLen = 4
        elseif b >= 0xE0 then charLen = 3
        elseif b >= 0xC0 then charLen = 2
        end
        if i + charLen - 1 > n then charLen = n - i + 1 end

        local char = string.sub(text, i, i + charLen - 1)
        i = i + charLen

        local test = current .. char
        if measure(test) > maxw and current ~= "" then
            local breakAt = current:match("^.*()%s")
            if breakAt and breakAt > 1 then
                lines[#lines + 1] = string.sub(current, 1, breakAt - 1)
                current = string.sub(current, breakAt + 1) .. char
            else
                lines[#lines + 1] = current
                current = char
            end
        else
            current = test
        end
    end
    if current ~= "" then lines[#lines + 1] = current end

    -- If there are more lines than maxlines — compress the tail into the last one.
    if #lines > maxlines then
        local kept = {}
        for k = 1, maxlines - 1 do kept[k] = lines[k] end

        local tail = lines[maxlines]
        for k = maxlines + 1, #lines do tail = tail .. " " .. lines[k] end
        kept[maxlines] = string.TruncateUTF8ToWidth(tail, font, maxw)

        return kept
    end

    return lines
end

-- Truncates the string by the number of UTF-8 characters, not bytes.
-- Needed for Chinese/Japanese/Korean, where 1 character = 3 bytes.
function string.TruncateUTF8(s, maxchars, suffix)
	if not s then return s end
	suffix = suffix or ".."
	local len = utf8.len(s)
	if not len or len <= maxchars then return s end

	local tail = maxchars - #suffix + 1
	if tail < 1 then return suffix end

	local ok, byteidx = pcall(utf8.offset, s, tail + 1)
	if not ok or not byteidx then return suffix end
	return s:sub(1, byteidx - 1)..suffix
end

-- Checks whether the string contains at least one character from the specified scripts.
-- scripts — an array of names from SCRIPT_RANGES, or {"any"} (always true).
local SCRIPT_RANGES = {
	latin    = {{0x0041, 0x005A}, {0x00C0, 0x00DE}, {0x0100, 0x017F}, {0x0180, 0x024F}},
	greek    = {{0x0391, 0x03A9}, {0x03B1, 0x03C9}},
	cyrillic = {{0x0400, 0x04FF}, {0x0500, 0x052F}},
	armenian = {{0x0531, 0x0556}},
	georgian = {{0x10A0, 0x10FF}, {0x2D00, 0x2D2D}},
}

local function CodeInRanges(code, ranges)
	for _, r in ipairs(ranges) do
		if code >= r[1] and code <= r[2] then return true end
	end
	return false
end

function string.HasScript(s, scripts)
	if not s or s == "" then return false end
	if not scripts or scripts[1] == "any" then return true end

	local ok, res = pcall(function()
		for _, code in utf8.codes(s) do
			for _, name in ipairs(scripts) do
				local ranges = SCRIPT_RANGES[name]
				if ranges and CodeInRanges(code, ranges) then
					return true
				end
			end
		end
		return false
	end)
	return ok and res
end
