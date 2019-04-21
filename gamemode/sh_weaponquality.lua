GM.WeaponQualityModifiers = {}
GM.WeaponQualities = {
	{"Sturdy", 1.09, "Tuned"},
	{"Honed", 1.19, "Modified"},
	{"Perfected", 1.35, "Reformed"}
}
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

GM:AddWeaponQualityModifier(WEAPON_MODIFIER_MIN_SPREAD, 				"Minimum Spread", 			false, 	{ConeMin = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_MAX_SPREAD,					"Maximum Spread", 			false, 	{ConeMax = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_FIRE_DELAY,					"Fire Delay", 				false, 	{Delay = true})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_RELOAD_SPEED,				"Reload Speed",		 		false, 	{ReloadSpeed = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_CLIP_SIZE,					"Clip Size", 				true, 	{ClipSize = true}).ReqClip = true
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_MELEE_RANGE,				"Melee Range", 				false, 	{MeleeRange = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_MELEE_SIZE,					"Melee Size", 				false, 	{MeleeSize = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_MELEE_IMPACT_DELAY,			"Melee Impact Delay", 		false, 	{SwingTime = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_PROJECTILE_VELOCITY,		"Projectile Velocity", 		false, 	{ProjVelocity = true})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_SHORT_TEAM_HEAT,			"Short Team Heat", 			false, 	{HeatBuildShort = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_SHOT_COUNT,					"Shot Count", 				true, 	{NumShots = true})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_BULLET_PIERCES,				"Bullet Pierces", 			true, 	{Pierces = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_MAXIMUM_MINES,				"Maximum Mines", 			true, 	{MaxMines = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_MAX_DISTANCE,				"Maximum Distance", 		false, 	{MaxDistance = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_AURA_RADIUS,				"Aura Detection Radius", 	false, 	{AuraRange = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_RECOIL,						"Recoil", 					false, 	{Recoil = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_DAMAGE,						"Damage", 					false, 	{Damage = true, MeleeDamage = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_HEALRANGE,					"Heal Range", 				false, 	{HealRange = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_HEALCOOLDOWN,				"Healing Cooldown", 		false, 	{Delay = true})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_BUFF_DURATION,				"Buff Duration", 			false, 	{BuffDuration = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_LEG_DAMAGE,					"Slow Strength", 			false, 	{LegDamage = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_REPAIR,						"Repair Strength", 			false, 	{Repair = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_TURRET_SPREAD,				"Turret Bullet Spread", 	false, 	{TurretSpread = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_HEALING,					"Healing Amount", 			false, 	{Heal = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_HEADSHOT_MULTI,				"Headshot Damage Bonus", 	false, 	{HeadshotMulti = false})
GM:AddWeaponQualityModifier(WEAPON_MODIFIER_MELEE_KNOCK,				"Knockback", 				false, 	{MeleeKnockBack = false})

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
				local ispos = datatab.Amount > 0 and "+" or ""
				local statincdesc = not modinfo.DisplayRaw and (((math.Round(newstat/basestat, 2)-1) * 100).. "% ")
					or ((datatab.Amount * qfactor / (modinfo.ReqClip and wept.RequiredClip or 1)).. " ")

				table.insert(remantledescs, ispos .. statincdesc .. modinfo.Name)
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

		table.insert(remantledescs, "+" .. ((quality[2]-1) * 100) .. "% " .. "Damage")
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

		scripted_ents.Register(afent, (prefix or "") .. newent)
		return newent
	end

	if wept.DeployClass then
		wept.DeployClass = regscriptent(wept.DeployClass, function(ent, newcl)
			if CLIENT then
				CreateQualityKillicon(wept.DeployClass, newcl, i)
			end

			if self.DeployableInfo[wept.DeployClass] then
				self:AddDeployableInfo(newcl, quality[1].." "..self.DeployableInfo[wept.DeployClass].Name, "")
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
