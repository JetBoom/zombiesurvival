GM.WeaponQualityModifiers = {}
GM.WeaponQualities = {
	{"Sturdy", 1.09, "Tuned"},
	{"Honed", 1.19, "Modified"},
	{"Perfected", 1.35, "Reformed"}
}
-- Translation ids for the names above, same order. Used by translate.WeaponName to build a translated
-- "<quality> <weapon>" name for quality/branch weapon variants (see CreateWeaponOfQuality below).
GM.WeaponQualityNameIDs = {"sturdy", "honed", "perfected"}
GM.WeaponQualityAltNameIDs = {"tuned", "modified", "reformed"}
GM.WeaponQualityColors = {
	{Color(235, 235, 115), Color(172, 219, 105)},
	{Color(50, 90, 175), Color(35, 110, 145)},
	{Color(160, 95, 235), Color(252, 100, 100)}
}

WEAPON_MODIFIER_MIN_SPREAD = 1
WEAPON_MODIFIER_MAX_SPREAD = 2
WEAPON_MODIFIER_FIRE_DELAY = 3 -- Rounds up based on tick rate.
WEAPON_MODIFIER_RELOAD_SPEED = 4
WEAPON_MODIFIER_CLIP_SIZE = 5
WEAPON_MODIFIER_MELEE_RANGE = 6
WEAPON_MODIFIER_MELEE_SIZE = 7
WEAPON_MODIFIER_MELEE_IMPACT_DELAY = 8
WEAPON_MODIFIER_PROJECTILE_VELOCITY = 9
WEAPON_MODIFIER_SHORT_TEAM_HEAT = 10
WEAPON_MODIFIER_SHOT_COUNT = 11
WEAPON_MODIFIER_BULLET_PIERCES = 12
WEAPON_MODIFIER_MAXIMUM_MINES = 13
WEAPON_MODIFIER_MAX_DISTANCE = 14
WEAPON_MODIFIER_AURA_RADIUS = 15
WEAPON_MODIFIER_RECOIL = 16
WEAPON_MODIFIER_DAMAGE = 17
WEAPON_MODIFIER_HEALRANGE = 18
WEAPON_MODIFIER_HEALCOOLDOWN = 19
WEAPON_MODIFIER_BUFF_DURATION = 20
WEAPON_MODIFIER_LEG_DAMAGE = 21
WEAPON_MODIFIER_REPAIR = 22
WEAPON_MODIFIER_TURRET_SPREAD = 23
WEAPON_MODIFIER_HEALING = 24
WEAPON_MODIFIER_HEADSHOT_MULTI = 25
WEAPON_MODIFIER_MELEE_KNOCK = 26

local index = 1
function GM:AddWeaponQualityModifier(id, name, displayraw, vartable)
	local datatab = {Name = name, DisplayRaw = displayraw, VarTable = vartable}
	self.WeaponQualityModifiers[id] = datatab

	index = index + 1

	return datatab
end

function GM:SetPrimaryWeaponModifier(swep, modifier, amount)
	swep.PrimaryRemantleModifier = {Modifier = modifier, Amount = amount}
end

function GM:AttachWeaponModifier(swep, modifier, amount, qualitystart)
	if not swep.AltRemantleModifiers then swep.AltRemantleModifiers = {} end

	local datatab = {Amount = amount, QualityStart = qualitystart or 2}
	swep.AltRemantleModifiers[modifier] = datatab
end

function GM:AddNewRemantleBranch(swep, no, printname, desc, branchfunc)
	if not swep.Branches then swep.Branches = {} end

	local datatab = {PrintName = printname, Desc = desc, BranchFunc = branchfunc}
	swep.Branches[no] = datatab

	return datatab
end

GM:AddWeaponQualityModifier(WEAPON_MODIFIER_MIN_SPREAD,               "wpn_stat_min_spread",           false, {ConeMin = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_MAX_SPREAD,               "wpn_stat_max_spread",           false, {ConeMax = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_FIRE_DELAY,               "wpn_stat_fire_delay",           false, {Delay = true})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_RELOAD_SPEED,             "wpn_stat_reload_speed",         false, {ReloadSpeed = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_CLIP_SIZE,                "wpn_stat_clip_size",            true,  {ClipSize = true}).ReqClip = true
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_MELEE_RANGE,              "wpn_stat_melee_range",          false, {MeleeRange = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_MELEE_SIZE,               "wpn_stat_melee_size",           false, {MeleeSize = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_MELEE_IMPACT_DELAY,       "wpn_stat_melee_impact_delay",   false, {SwingTime = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_PROJECTILE_VELOCITY,      "wpn_stat_projectile_velocity",  false, {ProjVelocity = true})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_SHORT_TEAM_HEAT,          "wpn_stat_short_team_heat",      false, {HeatBuildShort = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_SHOT_COUNT,               "wpn_stat_shot_count",           true,  {NumShots = true})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_BULLET_PIERCES,           "wpn_stat_bullet_pierces",       true,  {Pierces = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_MAXIMUM_MINES,            "wpn_stat_maximum_mines",        true,  {MaxMines = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_MAX_DISTANCE,             "wpn_stat_maximum_distance",     false, {MaxDistance = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_AURA_RADIUS,              "wpn_stat_aura_radius",          false, {AuraRange = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_RECOIL,                   "wpn_stat_recoil",               false, {Recoil = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_DAMAGE,                   "wpn_stat_damage",               false, {Damage = true, MeleeDamage = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_HEALRANGE,                "wpn_stat_heal_range",           false, {HealRange = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_HEALCOOLDOWN,             "wpn_stat_healing_cooldown",     false, {Delay = true})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_BUFF_DURATION,            "wpn_stat_buff_duration",        false, {BuffDuration = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_LEG_DAMAGE,               "wpn_stat_slow_strength",        false, {LegDamage = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_REPAIR,                   "wpn_stat_repair_strength",      false, {Repair = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_TURRET_SPREAD,            "wpn_stat_turret_spread",        false, {TurretSpread = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_HEALING,                  "wpn_stat_healing_amount",       false, {Heal = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_HEADSHOT_MULTI,           "wpn_stat_headshot_bonus",       false, {HeadshotMulti = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_MELEE_KNOCK,              "wpn_stat_knockback",            false, {MeleeKnockBack = false})

local function ApplyWeaponModifier(modinfo, wept, datatab, remantledescs, i)
	local displayed = false
	local mtbl, basestat, newstat, qfactor

	for var, isprimary in pairs(modinfo.VarTable) do
		mtbl = isprimary and wept.Primary or wept
		if mtbl[var] then
			qfactor = i - (datatab.QualityStart - 1)
			basestat = mtbl[var]
			newstat = basestat + datatab.Amount * qfactor

			mtbl[var] = newstat

			if not displayed and qfactor > 0 then
				local statname = translate.Get(modinfo.Name)
				local ispos = datatab.Amount > 0
				local val, key

				if modinfo.DisplayRaw then
					val = datatab.Amount * qfactor / (modinfo.ReqClip and wept.RequiredClip or 1)
					key = ispos and "wpn_stat_format_raw_pos" or "wpn_stat_format_raw_neg"
				else
					val = (math.Round(newstat / basestat, 2) - 1) * 100
					key = ispos and "wpn_stat_format_pct_pos" or "wpn_stat_format_pct_neg"
				end

				table.insert(remantledescs, translate.Format(key, val, statname))
				displayed = true
			end
		end
	end
end

local function CreateQualityKillicon(oldc, newc, i, b, cols)
	local kitbl = killicon.Get(oldc)
	if kitbl then
		local kifunc = #kitbl == 2 and killicon.Add or killicon.AddFont
		local nkitbl = table.Copy(kitbl)
		nkitbl[#kitbl] = cols and cols[i] or GAMEMODE.WeaponQualityColors[i][b and b+1 or 1]
		kifunc(newc, unpack(nkitbl))
	end
end

function GM:CreateWeaponOfQuality(i, orig, quality, classname, branch)
	orig.RemantleDescs[branch and branch.No or 0][i] = {}
	-- Doing it with a full copy prevents crash issues on scoped weapons.
	-- TODO: Refactor me to not use the full weapon class once all self.BaseClass calls have been removed

	local wept = weapons.Get(classname)
	local remantledescs = orig.RemantleDescs[branch and branch.No or 0][i]

	wept.BaseQuality = classname
	wept.QualityTier = i
	wept.Branch = branch and branch.No

	if wept.PrintName then
		wept.PrintName = (branch and branch.NewNames and branch.NewNames[i] or branch and quality[3] or quality[1]).." "..(branch and branch.PrintName or wept.PrintName)
	end

	-- Translation metadata for translate.WeaponName. Additive only: wept.PrintName above
	-- stays the English fallback, this just lets translate.WeaponName rebuild the same
	-- name in another language.
	--
	-- Base translation ID for this variant:
	--   * branch variant → branch.TranslationID (e.g. "cosmos"),
	--   * otherwise      → the base weapon's ID: explicit SWEP.TranslationID, or the
	--     classname with "weapon_zs_" stripped (what GetWeaponTranslationID does for
	--     the original weapon at runtime).
	--
	-- Without this, translate.WeaponName would derive an ID from the variant's
	-- generated classname ("weapon_zs_tempest_q21") and fall through to the base
	-- weapon's PrintName.
	local baseid = wept.TranslationID
	if not baseid and wept.ClassName then
		baseid = string.gsub(wept.ClassName, "^weapon_zs_", "")
	end

	if branch and branch.TranslationID then
		wept.TranslationID = branch.TranslationID
	elseif baseid then
		wept.TranslationID = baseid
	end

	wept.QualityNameID = (branch and branch.NewNameIDs and branch.NewNameIDs[i])
		or (branch and self.WeaponQualityAltNameIDs[i])
		or self.WeaponQualityNameIDs[i]

	if wept.PrimaryRemantleModifier then
		local primod = wept.PrimaryRemantleModifier

		ApplyWeaponModifier(self.WeaponQualityModifiers[primod.Modifier], wept, {Amount = primod.Amount, QualityStart = 1}, remantledescs, i)
	else
		if wept.Primary and wept.Primary.Damage then
			wept.Primary.Damage = wept.Primary.Damage * quality[2]
		end
		if wept.MeleeDamage then
			wept.MeleeDamage = wept.MeleeDamage * quality[2]
		end

		table.insert(remantledescs, translate.Format("wpn_stat_format_pct_pos", (quality[2] - 1) * 100, translate.Get("wpn_stat_damage")))
	end
	if wept.AltRemantleModifiers then
		for modifier, datatab in pairs(wept.AltRemantleModifiers) do
			if modifier == "BaseClass" then continue end -- ???

			ApplyWeaponModifier(self.WeaponQualityModifiers[modifier], wept, datatab, remantledescs, i)
		end
	end

	if branch and branch.BranchFunc then
		table.insert(remantledescs, 1, branch.Desc)
		branch.BranchFunc(wept)
	end

	local newclass = self:GetWeaponClassOfQuality(classname, i, branch and branch.No)
	if CLIENT then
		CreateQualityKillicon(branch and branch.Killicon or classname, newclass, i, branch and branch.No, branch and branch.Colors)
	end

	local regscriptent = function(class, cbk, prefix)
		local newent = self:GetWeaponClassOfQuality(class, i)
		local afent = scripted_ents.Get((prefix or "") .. class)
		if cbk then cbk(afent, newent) end

		afent.ClassName = nil
		scripted_ents.Register(afent, (prefix or "") .. newent)
		return newent
	end

	if wept.DeployClass then
		wept.DeployClass = regscriptent(wept.DeployClass, function(ent, newcl)
			if CLIENT then
				CreateQualityKillicon(wept.DeployClass, newcl, i)
			end

			local baseinfo = self.DeployableInfo[wept.DeployClass]
			if baseinfo then
				local newinfo = self:AddDeployableInfo(newcl, quality[1].." "..baseinfo.Name, "")
				-- Metadata for localizing notifications (deployable_lost /
				-- deployable_claimed / ran_out_of_ammo).
				--
				-- Previously Name was a ready-made English concatenation
				-- "Sturdy deployable_gunturret". translate.Get couldn't find
				-- such a key and returned "@Sturdy deployable_gunturret@",
				-- which is what ended up in the notification. Now we store
				-- parts separately and assemble the string only when sending
				-- to the client.
				newinfo.QualityTier   = i
				newinfo.QualityNameID = wept.QualityNameID
				newinfo.BaseNameKey   = baseinfo.Name
			end
		end)

		if wept.AmmoIfHas then
			local newammo = self:GetWeaponClassOfQuality(wept.Primary.Ammo, i)

			game.AddAmmoType({name = newammo})
			wept.Primary.Ammo = newammo
		end

		if wept.Channel then
			table.insert(self.ChannelsToClass[wept.Channel], wept.DeployClass)
		end
	end

	if wept.GhostStatus then wept.GhostStatus = regscriptent(wept.GhostStatus, function(ent)
		if ent.GhostEntityWildCard then
			ent.GhostEntityWildCard = ent.GhostEntity
		end

		local ghostent = self:GetWeaponClassOfQuality(ent.GhostEntity, i)
		ent.GhostEntity = ghostent
		ent.GhostWeapon = newclass
	end, "status_") end

	wept.ClassName = nil
	weapons.Register(wept, newclass)
end

function GM:CreateWeaponQualities()
	local allweapons = weapons.GetList()
	local classname

	for _, t in ipairs(allweapons) do
		classname = t.ClassName

		if string.sub(classname, 1, 14) == "weapon_zs_base" then
			continue
		end

		local wept = weapons.Get(classname)
		if wept and wept.AllowQualityWeapons then
			local orig = weapons.GetStored(classname)
			orig.RemantleDescs = {}
			orig.RemantleDescs[0] = {}

			if orig.Branches then
				for no, _ in pairs(orig.Branches) do
					orig.RemantleDescs[no] = {}
				end
			end

			for i, quality in ipairs(self.WeaponQualities) do
				self:CreateWeaponOfQuality(i, orig, quality, classname)

				if orig.Branches then
					for no, tbl in pairs(orig.Branches) do
						local ntbl = table.Copy(tbl)
						ntbl.No = no

						self:CreateWeaponOfQuality(i, orig, quality, classname, ntbl)
					end
				end
			end
		end
	end
end

function GM:GetWeaponClassOfQuality(classname, quality, branch)
	return classname.."_"..string.char(113 + (branch or 0))..quality
end

function GM:GetDismantleScrap(wtbl, invitem)
	local itier = wtbl.Tier
	local quatier = wtbl.QualityTier

	local dismantlediv = invitem and 2 or 1
	local baseval = invitem and GAMEMODE.ScrapValsTrinkets[itier or 1] or GAMEMODE.ScrapVals[itier or 1]

	local qu = (quatier or 0) + 1
	local basicvalue = baseval * GAMEMODE.DismantleMultipliers[qu] - ((quatier or itier) and 0 or 1)

	return math.floor((basicvalue * (wtbl.IsMelee and 0.75 or 1)) / (wtbl.DismantleDiv or dismantlediv))
end

function GM:GetUpgradeScrap(wtbl, qualitychoice)
	local itier = wtbl.Tier

	return math.ceil(self.ScrapVals[itier or 1] * qualitychoice * (wtbl.IsMelee and 0.85 or 1))
end

function GM:PointsToScrap(points)
	return points / (70 / 32)
end
