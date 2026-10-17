local TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER
local EyePos = EyePos
local EyeVector = EyeVector
local CurTime = CurTime
local string_format = string.format
local string_match = string.match
local math_max = math.max
local math_ceil = math.ceil
local draw = draw
local util = util

local trace = {mask = MASK_SHOT, mins = Vector(-2, -2, -2), maxs = Vector(2, 2, 2)}
local entitylist = {}

local colTemp = Color(255, 255, 255)
function GM:DrawTargetID(ent, fade)
	fade = fade or 1
	local pos = ent:GetPos()
	pos.z = pos.z + 16
	local ts = pos:ToScreen()
	local x, y = ts.x, math.Clamp(ts.y, 0, ScrH() * 0.95)

	colTemp.a = fade * 255
	util.ColorCopy(COLOR_FRIENDLY, colTemp)

	local name = ent:DisplayName()
	draw.SimpleTextBlur(name, "ZSHUDFontSmaller", x, y, colTemp, TEXT_ALIGN_CENTER)
	y = y + draw.GetFontHeight("ZSHUDFontSmaller") + 3

	local healthfraction = math_max(ent:Health() / (ent:Team() == TEAM_UNDEAD and ent:GetMaxZombieHealth() or ent:GetMaxHealth()), 0)
	if healthfraction ~= 1 then
		util.ColorCopy(0.75 <= healthfraction and COLOR_HEALTHY or 0.5 <= healthfraction and COLOR_SCRATCHED or 0.25 <= healthfraction and COLOR_HURT or COLOR_CRITICAL, colTemp)

		local hptxt
		if self.HealthTargetDisplay == 1 then
			hptxt = translate.Format("targetid_health_hp", math_ceil(ent:Health()))
		else
			hptxt = translate.Format("targetid_health_percent", math_ceil(healthfraction * 100))
		end

		draw.SimpleTextBlur(hptxt, "ZSHUDFont", x, y, colTemp, TEXT_ALIGN_CENTER)
		y = y + draw.GetFontHeight("ZSHUDFont") + 3

		if self.MedicalAura then
			if ent:GetDTBool(DT_PLAYER_BOOL_FRAIL) then
				util.ColorCopy(COLOR_LBLUE, colTemp)
				draw.SimpleTextBlur(translate.Get("targetid_frail"), "ZSHUDFontSmaller", x, y, colTemp, TEXT_ALIGN_CENTER)
				y = y + draw.GetFontHeight("ZSHUDFontSmaller") + 2
			end

			local poison = ent:GetPoisonDamage()
			local bleed = ent:GetBleedDamage()
			local phant = ent:GetPhantomHealth()
			if poison >= 1 then
				util.ColorCopy(COLOR_LIMEGREEN, colTemp)
				draw.SimpleTextBlur(translate.Format("targetid_poison", math.floor(poison)), "ZSHUDFontSmaller", x, y, colTemp, TEXT_ALIGN_CENTER)
				y = y + draw.GetFontHeight("ZSHUDFontSmaller") + 2
			end
			if bleed >= 1 then
				util.ColorCopy(COLOR_SOFTRED, colTemp)
				draw.SimpleTextBlur(translate.Format("targetid_bleed", math.floor(bleed)), "ZSHUDFontSmaller", x, y, colTemp, TEXT_ALIGN_CENTER)
				y = y + draw.GetFontHeight("ZSHUDFontSmaller") + 2
			end
			if phant >= 1 then
				util.ColorCopy(COLOR_MIDGRAY, colTemp)
				draw.SimpleTextBlur(translate.Get("targetid_bloodlust"), "ZSHUDFontSmaller", x, y, colTemp, TEXT_ALIGN_CENTER)
				y = y + draw.GetFontHeight("ZSHUDFontSmaller") + 2
			end
		end
	end

	util.ColorCopy(color_white, colTemp)

	if ent:Team() == TEAM_UNDEAD then
		local classtab = ent:GetZombieClassTable()
		local classname = classtab.TranslationName and translate.Get(classtab.TranslationName) or classtab.Name
		if classname then
			draw.SimpleTextBlur(classname, ZS_TinyFontWithOutline(), x, y, colTemp, TEXT_ALIGN_CENTER)
		end
	else
		local holding = ent:GetHolding()
		if holding:IsValid() then
			draw.SimpleTextBlur(translate.Format("targetid_carrying", string_match(holding:GetModel(), ".*/(.+)%.mdl") or "object"), ZS_TinyFontWithOutline(), x, y, colTemp, TEXT_ALIGN_CENTER)
		else
		local wep = ent:GetActiveWeapon()
			if wep:IsValid() then
				local weptbl = weapons.Get(wep:GetClass())
				local wname = weptbl and translate.WeaponName(weptbl) or wep:GetPrintName()
				draw.SimpleTextBlur(wname, ZS_TinyFontWithOutline(), x, y, colTemp, TEXT_ALIGN_CENTER)
			end
		end

		local level = ent:GetZSLevel()
		local remortlevel = ent:GetZSRemortLevel()
		y = y + draw.GetFontHeight(ZS_TinyFontWithOutline()) + 4
		if remortlevel >= 1 then
			draw.SimpleTextBlur(translate.Format("targetid_level_remort", level, remortlevel), ZS_TinyFontWithOutline(), x, y, colTemp, TEXT_ALIGN_CENTER)
		else
			draw.SimpleTextBlur(translate.Format("targetid_level", level), ZS_TinyFontWithOutline(), x, y, colTemp, TEXT_ALIGN_CENTER)
		end
	end
end

function GM:DrawSigilTargetHint(ent, fade)
	fade = fade or 1
	local pos = ent:GetPos()
	pos.z = pos.z + 16
	local ts = pos:ToScreen()
	local x, y = ts.x, math.Clamp(ts.y, 0, ScrH() * 0.95)

	colTemp.a = fade * 128
	util.ColorCopy(color_white, colTemp)

	draw.SimpleTextBlur(translate.Get("targetid_sigil"), "ZSHUDFontSmaller", x, y, colTemp, TEXT_ALIGN_CENTER)

	if GAMEMODE:NumSigils() > 1 then
		y = y + draw.GetFontHeight("ZSHUDFontSmaller") + 0
		draw.SimpleTextBlur(translate.Format("targetid_sigil_teleport", translate.GetBindKeyName("+use")), ZS_TinyFontWithOutline(), x, y, colTemp, TEXT_ALIGN_CENTER)
	end
end

GM.TraceTarget = NULL

-- Service entities (trinket backpacks, markers) attached to the player.
-- MASK_SHOT hits them like regular geometry, and without an explicit flag
-- targetid/medicgun don't see the player behind them.
local function IsIgnoredByTargetID(ent)
	-- Sigils must be visible in targetid even if they have
	-- IgnoreTraces/IgnoreBullets/IgnoreMelee — they are
	-- marked with the .Sigil flag and handled by a separate branch.
	if ent.Sigil then return false end

	return ent.IgnoreTraces or ent.IgnoreBullets or ent.IgnoreMelee
end

local function TargetIDFilter(ent)
	if ent == MySelf
	or ent == MySelf:GetObserverTarget()
	or (MySelf.TargetIDFilter and ent == MySelf.TargetIDFilter)
	or IsIgnoredByTargetID(ent) then
		return false
	end
	return true
end

local function FuncFilterPlayers(ent)
	if IsIgnoredByTargetID(ent) then return false end
	return not ent:IsPlayer()
end

local function FuncFilterTeam(ent)
	if IsIgnoredByTargetID(ent) then return false end
	return not (ent:IsPlayer() and ent:Team() == MySelf:Team())
end

function GM:HUDDrawTargetID(teamid)
	local start = EyePos()
	trace.start = start
	trace.endpos = start + EyeVector() * 2048
	trace.filter = TargetIDFilter

	local isspectator = MySelf:IsSpectator()

	local entity = util.TraceHull(trace).Entity
	self.TraceTarget = entity
	trace.filter = FuncFilterPlayers
	self.TraceTargetNoPlayers = util.TraceLine(trace).Entity

	if MySelf.TargetLocus then
		trace.filter = FuncFilterTeam
		self.TraceTargetTeam = util.TraceLine(trace).Entity
	end

	if entity:IsValid() and (entity:IsPlayer() and (entity:Team() == teamid or isspectator) or entity.Sigil) then
		entitylist[entity] = CurTime()
	end

	for ent, time in pairs(entitylist) do
		if ent:IsValidPlayer() and (ent:Team() == teamid or isspectator) and CurTime() < time + 1.5 then
			self:DrawTargetID(ent, 1 - math.Clamp((CurTime() - time) / 1.5, 0, 1))
		elseif teamid == TEAM_HUMAN and ent.Sigil and CurTime() < time + 0.5 then
			self:DrawSigilTargetHint(ent, 1 - math.Clamp((CurTime() - time) / 0.5, 0, 1))
		else
			entitylist[ent] = nil
		end
	end
end