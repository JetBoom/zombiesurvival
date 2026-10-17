GM.Skills = {}
GM.NextTrinketSkillID = GM.NextTrinketSkillID or 200
GM.SkillModifiers = {}
GM.SkillFunctions = {}
GM.SkillModifierFunctions = {}

function GM:AddSkill(id, name, description, x, y, connections, tree)
	local skill = {Connections = table.ToAssoc(connections or {})}

	if CLIENT then
		skill.x = x
		skill.y = y

		if type(description) == "table" then
			skill.DescriptionAttributes = description
		else
			skill.Description = description
		end
	end

	if #name == 0 then
		name = "Skill "..id
		skill.Disabled = true
	end

	skill.Name = name
	skill.Tree = tree

	self.Skills[id] = skill
	return skill
end

function GM:AddTrinket(name, swepaffix, pairedweapon, veles, weles, tier, description, status, stocks)
    local skill = {Connections = {}}
    skill.Name    = name
    skill.Trinket = swepaffix
    skill.Status  = status

    local datatab = {
        PrintName     = name,
        DroppedEles   = weles,
        Tier          = tier,
        Status        = status,
        Stocks        = stocks,
        TranslationID = swepaffix,
		TranslationPrefix = "trinket",
    }

    if type(description) == "table" then
        datatab.DescriptionAttributes = description
    elseif type(description) == "string" then
        datatab.Description = description
        local numbers = {}
        for n in string.gmatch(description, "%d+%.?%d*") do
            numbers[#numbers + 1] = n
        end
        datatab.DescriptionNumbers = numbers
    end

    if pairedweapon then
        skill.PairedWeapon = "weapon_zs_t_" .. swepaffix
    end

    self.ZSInventoryItemData["trinket_" .. swepaffix] = datatab

    local id = self.NextTrinketSkillID
    self.NextTrinketSkillID = id + 1
    self.Skills[id] = skill

    return id, datatab
end

-- I'll leave this here, but I don't think it's needed.
function GM:GetTrinketSkillID(trinketname)
	for skillid, skill in pairs(GM.Skills) do
		if skill.Trinket and skill.Trinket == trinketname then
			return skillid
		end
	end
end

function GM:AddSkillModifier(skillid, modifier, amount)
	self.SkillModifiers[skillid] = self.SkillModifiers[skillid] or {}
	self.SkillModifiers[skillid][modifier] = (self.SkillModifiers[skillid][modifier] or 0) + amount
end

function GM:AddSkillFunction(skillid, func)
	self.SkillFunctions[skillid] = self.SkillFunctions[skillid] or {}
	table.insert(self.SkillFunctions[skillid], func)
end

function GM:SetSkillModifierFunction(modid, func)
	self.SkillModifierFunctions[modid] = func
end

function GM:MkGenericMod(modifiername)
	return function(pl, amount) pl[modifiername] = math.Clamp(amount + 1.0, 0.0, 1000.0) end
end

-- These are used for position on the screen
TREE_HEALTHTREE = 1
TREE_SPEEDTREE = 2
TREE_SUPPORTTREE = 3
TREE_BUILDINGTREE = 4
TREE_MELEETREE = 5
TREE_GUNTREE = 6

-- Dummy skill used for "connecting" to their trees.
SKILL_NONE = 0

--[[
SKILL_U_AMMOCRATE = 0 -- Unlock alternate arsenal crate that only sells cheap ammo (remove from regular?)
SKILL_U_DECOY = 0 -- "Unlock: Decoy", "Unlocks purchasing the Decoy\nZombies believe it is a human\nCan be destroyed\nExplodes when destroyed"

SKILL_OVERCHARGEFLASHLIGHT = 0 -- Your flashlight now produces a blinding flash that stuns zombies\nYour flashlight now breaks after one use

Unlock: Explosive body armor - Allows you to purchase explosive body armor, which knocks back both you and nearby zombies when you fall below 25 hp.
Olympian - +50% throw power\nsomething bad
Unlock: Antidote Medic Gun - Unlocks purchasing the Antidote Medic Gun\nTarget poison damage resistance +100%\nTarget immediately cleansed of all debuffs\nTarget is no longer healed or hastened
]]

-- unimplemented

SKILL_SPEED1 = 1
SKILL_SPEED2 = 2
SKILL_SPEED3 = 3
SKILL_SPEED4 = 4
SKILL_SPEED5 = 5
SKILL_BACKPEDDLER = 18
SKILL_LOADEDHULL = 20
SKILL_REINFORCEDHULL = 21
SKILL_REINFORCEDBLADES = 22
SKILL_AVIATOR = 23
SKILL_U_BLASTTURRET = 24
SKILL_TWINVOLLEY = 26
SKILL_TURRETOVERLOAD = 27
SKILL_LIGHTCONSTRUCT = 34
SKILL_QUICKDRAW = 39
SKILL_QUICKRELOAD = 41
SKILL_VITALITY2 = 45
SKILL_BARRICADEEXPERT = 77
SKILL_BATTLER1 = 48
SKILL_BATTLER2 = 49
SKILL_BATTLER3 = 50
SKILL_BATTLER4 = 51
SKILL_BATTLER5 = 52
SKILL_HEAVYSTRIKES = 53
SKILL_COMBOKNUCKLE = 62
SKILL_U_CRAFTINGPACK = 64
SKILL_JOUSTER = 65
SKILL_SCAVENGER = 67
SKILL_U_ZAPPER_ARC = 68
SKILL_ULTRANIMBLE = 70
SKILL_D_FRAIL = 71
SKILL_U_MEDICCLOUD = 72
SKILL_SMARTTARGETING = 73
SKILL_GOURMET = 76
SKILL_BLOODARMOR = 79
SKILL_REGENERATOR = 80
SKILL_SAFEFALL = 83
SKILL_VITALITY3 = 84
SKILL_TANKER = 86
SKILL_U_CORRUPTEDFRAGMENT = 87
SKILL_WORTHINESS3 = 78
SKILL_WORTHINESS4 = 88
SKILL_FOCUS = 40
SKILL_WORTHINESS1 = 42
SKILL_WORTHINESS2 = 43
SKILL_WOOISM = 46
SKILL_U_DRONE = 28
SKILL_U_NANITECLOUD = 29
SKILL_STOIC1 = 6
SKILL_STOIC2 = 7
SKILL_STOIC3 = 8
SKILL_STOIC4 = 9
SKILL_STOIC5 = 10
SKILL_SURGEON1 = 11
SKILL_SURGEON2 = 12
SKILL_SURGEON3 = 13
SKILL_HANDY1 = 14
SKILL_HANDY2 = 15
SKILL_HANDY3 = 16
SKILL_MOTIONI = 17
SKILL_PHASER = 19
SKILL_TURRETLOCK = 25
SKILL_HAMMERDISCIPLINE = 30
SKILL_FIELDAMP = 31
SKILL_U_ROLLERMINE = 32
SKILL_HAULMODULE = 33
SKILL_TRIGGER_DISCIPLINE1 = 35
SKILL_TRIGGER_DISCIPLINE2 = 36
SKILL_TRIGGER_DISCIPLINE3 = 37
SKILL_D_PALSY = 38
SKILL_EGOCENTRIC = 44
SKILL_D_HEMOPHILIA = 47
SKILL_LASTSTAND = 54
SKILL_D_NOODLEARMS = 55
SKILL_GLASSWEAPONS = 56
SKILL_CANNONBALL = 57
SKILL_D_CLUMSY = 58
SKILL_CHEAPKNUCKLE = 59
SKILL_CRITICALKNUCKLE = 60
SKILL_KNUCKLEMASTER = 61
SKILL_D_LATEBUYER = 63
SKILL_VITALITY1 = 66
SKILL_TAUT = 69
SKILL_INSIGHT = 74
SKILL_GLUTTON = 75
SKILL_D_WEAKNESS = 81
SKILL_PREPAREDNESS = 82
SKILL_D_WIDELOAD = 85
SKILL_FORAGER = 89
SKILL_LANKY = 90
SKILL_PITCHER = 91
SKILL_BLASTPROOF = 92
SKILL_MASTERCHEF = 93
SKILL_SUGARRUSH = 94
SKILL_U_STRENGTHSHOT = 95
SKILL_STABLEHULL = 96
SKILL_LIGHTWEIGHT = 97
SKILL_AGILEI = 98
SKILL_U_CRYGASGREN = 99
SKILL_SOFTDET = 100
SKILL_STOCKPILE = 101
SKILL_ACUITY = 102
SKILL_VISION = 103
SKILL_U_ROCKETTURRET = 104
SKILL_RECLAIMSOL = 105
SKILL_ORPHICFOCUS = 106
SKILL_IRONBLOOD = 107
SKILL_BLOODLETTER = 108
SKILL_HAEMOSTASIS = 109
SKILL_SLEIGHTOFHAND = 110
SKILL_AGILEII = 111
SKILL_AGILEIII = 112
SKILL_BIOLOGYI = 113
SKILL_BIOLOGYII = 114
SKILL_BIOLOGYIII = 115
SKILL_FOCUSII = 116
SKILL_FOCUSIII = 117
SKILL_EQUIPPED = 118
SKILL_SURESTEP = 119
SKILL_INTREPID = 120
SKILL_CARDIOTONIC = 121
SKILL_BLOODLUST = 122
SKILL_SCOURER = 123
SKILL_LANKYII = 124
SKILL_U_ANTITODESHOT = 125
SKILL_DISPERSION = 126
SKILL_MOTIONII = 127
SKILL_MOTIONIII = 128
SKILL_D_SLOW = 129
SKILL_BRASH = 130
SKILL_CONEFFECT = 131
SKILL_CIRCULATION = 132
SKILL_SANGUINE = 133
SKILL_ANTIGEN = 134
SKILL_INSTRUMENTS = 135
SKILL_HANDY4 = 136
SKILL_HANDY5 = 137
SKILL_TECHNICIAN = 138
SKILL_BIOLOGYIV = 139
SKILL_SURGEONIV = 140
SKILL_DELIBRATION = 141
SKILL_DRIFT = 142
SKILL_WARP = 143
SKILL_LEVELHEADED = 144
SKILL_ROBUST = 145
SKILL_STOWAGE = 146
SKILL_TRUEWOOISM = 147
SKILL_UNBOUND = 148

SKILLMOD_HEALTH = 1
SKILLMOD_SPEED = 2
SKILLMOD_WORTH = 3
SKILLMOD_FALLDAMAGE_THRESHOLD_MUL = 4
SKILLMOD_FALLDAMAGE_RECOVERY_MUL = 5
SKILLMOD_FALLDAMAGE_SLOWDOWN_MUL = 6
SKILLMOD_FOODRECOVERY_MUL = 7
SKILLMOD_FOODEATTIME_MUL = 8
SKILLMOD_JUMPPOWER_MUL = 9
SKILLMOD_RELOADSPEED_MUL = 11
SKILLMOD_DEPLOYSPEED_MUL = 12
SKILLMOD_UNARMED_DAMAGE_MUL = 13
SKILLMOD_UNARMED_SWING_DELAY_MUL = 14
SKILLMOD_MELEE_DAMAGE_MUL = 15
SKILLMOD_HAMMER_SWING_DELAY_MUL = 16
SKILLMOD_CONTROLLABLE_SPEED_MUL = 17
SKILLMOD_CONTROLLABLE_HANDLING_MUL = 18
SKILLMOD_CONTROLLABLE_HEALTH_MUL = 19
SKILLMOD_MANHACK_DAMAGE_MUL = 20
SKILLMOD_BARRICADE_PHASE_SPEED_MUL = 21
SKILLMOD_MEDKIT_COOLDOWN_MUL = 22
SKILLMOD_MEDKIT_EFFECTIVENESS_MUL = 23
SKILLMOD_REPAIRRATE_MUL = 24
SKILLMOD_TURRET_HEALTH_MUL = 25
SKILLMOD_TURRET_SCANSPEED_MUL = 26
SKILLMOD_TURRET_SCANANGLE_MUL = 27
SKILLMOD_BLOODARMOR = 28
SKILLMOD_MELEE_KNOCKBACK_MUL = 29
SKILLMOD_SELF_DAMAGE_MUL = 30
SKILLMOD_AIMSPREAD_MUL = 31
SKILLMOD_POINTS = 32
SKILLMOD_POINT_MULTIPLIER = 33
SKILLMOD_FALLDAMAGE_DAMAGE_MUL = 34
SKILLMOD_MANHACK_HEALTH_MUL = 35
SKILLMOD_DEPLOYABLE_HEALTH_MUL = 36
SKILLMOD_DEPLOYABLE_PACKTIME_MUL = 37
SKILLMOD_DRONE_SPEED_MUL = 38
SKILLMOD_DRONE_CARRYMASS_MUL = 39
SKILLMOD_MEDGUN_FIRE_DELAY_MUL = 40
SKILLMOD_RESUPPLY_DELAY_MUL = 41
SKILLMOD_FIELD_RANGE_MUL = 42
SKILLMOD_FIELD_DELAY_MUL = 43
SKILLMOD_DRONE_GUN_RANGE_MUL = 44
SKILLMOD_HEALING_RECEIVED = 45
SKILLMOD_RELOADSPEED_PISTOL_MUL = 46
SKILLMOD_RELOADSPEED_SMG_MUL = 47
SKILLMOD_RELOADSPEED_ASSAULT_MUL = 48
SKILLMOD_RELOADSPEED_SHELL_MUL = 49
SKILLMOD_RELOADSPEED_RIFLE_MUL = 50
SKILLMOD_RELOADSPEED_XBOW_MUL = 51
SKILLMOD_RELOADSPEED_PULSE_MUL = 52
SKILLMOD_RELOADSPEED_EXP_MUL = 53
SKILLMOD_MELEE_ATTACKER_DMG_REFLECT = 54
SKILLMOD_PULSE_WEAPON_SLOW_MUL = 55
SKILLMOD_MELEE_DAMAGE_TAKEN_MUL = 56
SKILLMOD_POISON_DAMAGE_TAKEN_MUL = 57
SKILLMOD_BLEED_DAMAGE_TAKEN_MUL = 58
SKILLMOD_MELEE_SWING_DELAY_MUL = 59
SKILLMOD_MELEE_DAMAGE_TO_BLOODARMOR_MUL = 60
SKILLMOD_MELEE_MOVEMENTSPEED_ON_KILL = 61
SKILLMOD_MELEE_POWERATTACK_MUL = 62
SKILLMOD_KNOCKDOWN_RECOVERY_MUL = 63
SKILLMOD_MELEE_RANGE_MUL = 64
SKILLMOD_SLOW_EFF_TAKEN_MUL = 65
SKILLMOD_EXP_DAMAGE_TAKEN_MUL = 66
SKILLMOD_FIRE_DAMAGE_TAKEN_MUL = 67
SKILLMOD_PROP_CARRY_CAPACITY_MUL = 68
SKILLMOD_PROP_THROW_STRENGTH_MUL = 69
SKILLMOD_PHYSICS_DAMAGE_TAKEN_MUL = 70
SKILLMOD_VISION_ALTER_DURATION_MUL = 71
SKILLMOD_DIMVISION_EFF_MUL = 72
SKILLMOD_PROP_CARRY_SLOW_MUL = 73
SKILLMOD_BLEED_SPEED_MUL = 74
SKILLMOD_MELEE_LEG_DAMAGE_ADD = 75
SKILLMOD_SIGIL_TELEPORT_MUL = 76
SKILLMOD_MELEE_ATTACKER_DMG_REFLECT_PERCENT = 77
SKILLMOD_POISON_SPEED_MUL = 78
SKILLMOD_PROJECTILE_DAMAGE_TAKEN_MUL = 79
SKILLMOD_EXP_DAMAGE_RADIUS = 80
SKILLMOD_MEDGUN_RELOAD_SPEED_MUL = 81
SKILLMOD_WEAPON_WEIGHT_SLOW_MUL = 82
SKILLMOD_FRIGHT_DURATION_MUL = 83
SKILLMOD_IRONSIGHT_EFF_MUL = 84
SKILLMOD_BLOODARMOR_DMG_REDUCTION = 85
SKILLMOD_BLOODARMOR_MUL = 86
SKILLMOD_BLOODARMOR_GAIN_MUL = 87
SKILLMOD_LOW_HEALTH_SLOW_MUL = 88
SKILLMOD_PROJ_SPEED = 89
SKILLMOD_SCRAP_START = 90
SKILLMOD_ENDWAVE_POINTS = 91
SKILLMOD_ARSENAL_DISCOUNT = 92
SKILLMOD_CLOUD_RADIUS = 93
SKILLMOD_CLOUD_TIME = 94
SKILLMOD_PROJECTILE_DAMAGE_MUL = 95
SKILLMOD_EXP_DAMAGE_MUL = 96
SKILLMOD_TURRET_RANGE_MUL = 97
SKILLMOD_AIM_SHAKE_MUL = 98
SKILLMOD_MEDDART_EFFECTIVENESS_MUL = 99

local GOOD = "^"..COLORID_GREEN
local BAD = "^"..COLORID_RED

-- Health Tree-- Health Tree
GM:AddSkill(SKILL_STOIC1, "Stoic I", {
	{ "attr_health", 1, "good" },
	{ "attr_movement_speed", -0.75, "bad" },
}, -4, -6, {SKILL_NONE, SKILL_STOIC2}, TREE_HEALTHTREE)

GM:AddSkill(SKILL_STOIC2, "Stoic II", {
	{ "attr_health", 2, "good" },
	{ "attr_movement_speed", -1.5, "bad" },
}, -4, -4, {SKILL_STOIC3, SKILL_VITALITY1, SKILL_REGENERATOR}, TREE_HEALTHTREE)

GM:AddSkill(SKILL_STOIC3, "Stoic III", {
	{ "attr_health", 4, "good" },
	{ "attr_movement_speed", -3, "bad" },
}, -3, -2, {SKILL_STOIC4}, TREE_HEALTHTREE)

GM:AddSkill(SKILL_STOIC4, "Stoic IV", {
	{ "attr_health", 6, "good" },
	{ "attr_movement_speed", -4.5, "bad" },
}, -3, 0, {SKILL_STOIC5}, TREE_HEALTHTREE)

GM:AddSkill(SKILL_STOIC5, "Stoic V", {
	{ "attr_health", 7, "good" },
	{ "attr_movement_speed", -5.25, "bad" },
}, -3, 2, {SKILL_BLOODARMOR, SKILL_TANKER}, TREE_HEALTHTREE)

GM:AddSkill(SKILL_D_HEMOPHILIA, "Debuff: Hemophilia", {
	{ "attr_worth_starting", 10, "good" },
	{ "attr_scrap_starting", 3, "good" },
	{ "attr_hemophilia_note", 25, "bad" },
}, 4, 2, {}, TREE_HEALTHTREE)

GM:AddSkill(SKILL_GLUTTON, "Glutton", {
	{ "attr_glutton_armor", 30, "good" },
	{ "attr_glutton_overcap", 40, "good" },
	{ "attr_health", -5, "bad" },
	{ "attr_glutton_no_food_heal", 0, "bad" },
}, 3, -2, {SKILL_GOURMET, SKILL_BLOODARMOR}, TREE_HEALTHTREE)

GM:AddSkill(SKILL_PREPAREDNESS, "Preparedness", {
	{ "attr_preparedness_note", 0, "good" },
}, 4, -6, {SKILL_NONE}, TREE_HEALTHTREE)

GM:AddSkill(SKILL_GOURMET, "Gourmet", {
	{ "attr_food_recovery", 100, "good" },
	{ "attr_food_eat_time", 200, "bad" },
}, 4, -4, {SKILL_PREPAREDNESS, SKILL_VITALITY1}, TREE_HEALTHTREE)

GM:AddSkill(SKILL_HAEMOSTASIS, "Haemostasis", {
	{ "attr_haemostasis_resist", 2, "good" },
	{ "attr_haemostasis_cost", 2, "bad" },
	{ "attr_blood_armor_absorb", -25, "bad" },
}, 4, 6, {}, TREE_HEALTHTREE)

GM:AddSkill(SKILL_BLOODLETTER, "Bloodletter", {
	{ "attr_blood_armor_gain", 100, "good" },
	{ "attr_bloodletter_bleed", 5, "bad" },
}, 0, 4, {SKILL_ANTIGEN}, TREE_HEALTHTREE)

GM:AddSkill(SKILL_REGENERATOR, "Regenerator", {
	{ "attr_regen_note", 0, "good" },
	{ "attr_health", -6, "bad" },
}, -5, -2, {}, TREE_HEALTHTREE)

GM:AddSkill(SKILL_BLOODARMOR, "Blood Armor", {
	{ "attr_bloodarmor_note", 0, "good" },
	{ "attr_bloodarmor_base_max", 20, "good" },
	{ "attr_bloodarmor_base_absorb", 50, "good" },
	{ "attr_health", -13, "bad" },
}, 2, 2, {SKILL_IRONBLOOD, SKILL_BLOODLETTER, SKILL_D_HEMOPHILIA}, TREE_HEALTHTREE)

GM:AddSkill(SKILL_IRONBLOOD, "Iron Blood", {
	{ "attr_blood_armor_absorb", 25, "good" },
	{ "attr_ironblood_bonus", 0, "good" },
	{ "attr_blood_armor_max", -50, "bad" },
}, 2, 4, {SKILL_HAEMOSTASIS, SKILL_CIRCULATION}, TREE_HEALTHTREE)

GM:AddSkill(SKILL_D_WEAKNESS, "Debuff: Weakness", {
	{ "attr_worth_starting", 15, "good" },
	{ "attr_endwave_points", 1, "good" },
	{ "attr_health", -45, "bad" },
}, 1, -1, {}, TREE_HEALTHTREE)

GM:AddSkill(SKILL_VITALITY1, "Vitality I", { { "attr_health", 1, "good" } }, 0, -4, {SKILL_VITALITY2}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_VITALITY2, "Vitality II", { { "attr_health", 1, "good" } }, 0, -2, {SKILL_VITALITY3}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_VITALITY3, "Vitality III", { { "attr_health", 1, "good" } }, 0, 0, {SKILL_D_WEAKNESS}, TREE_HEALTHTREE)

GM:AddSkill(SKILL_TANKER, "Tanker", {
	{ "attr_health", 20, "good" },
	{ "attr_movement_speed", -15, "bad" },
}, -5, 4, {}, TREE_HEALTHTREE)

GM:AddSkill(SKILL_FORAGER, "Forager", {
	{ "attr_forager_chance", 25, "good" },
	{ "attr_resupply_delay", 20, "bad" },
}, 5, -2, {SKILL_GOURMET}, TREE_HEALTHTREE)

GM:AddSkill(SKILL_SUGARRUSH, "Sugar Rush", {
	{ "attr_sugarrush_bonus", 35, "good" },
	{ "attr_food_recovery", -35, "bad" },
}, 4, 0, {SKILL_GOURMET}, TREE_HEALTHTREE)

GM:AddSkill(SKILL_CIRCULATION, "Circulation", { { "attr_blood_armor_max", 1, "good" } }, 4, 4, {SKILL_SANGUINE}, TREE_HEALTHTREE)

GM:AddSkill(SKILL_SANGUINE, "Sanguine", {
	{ "attr_blood_armor_max", 11, "good" },
	{ "attr_health", -9, "bad" },
}, 6, 2, {}, TREE_HEALTHTREE)

GM:AddSkill(SKILL_ANTIGEN, "Antigen", {
	{ "attr_blood_armor_absorb", 5, "good" },
	{ "attr_health", -3, "bad" },
}, -2, 4, {}, TREE_HEALTHTREE)

-- Speed Tree
GM:AddSkill(SKILL_SPEED1, "Speed I", {
	{ "attr_movement_speed", 0.75, "good" },
	{ "attr_health", -1, "bad" },
}, -4, 6, {SKILL_NONE, SKILL_SPEED2}, TREE_SPEEDTREE)

GM:AddSkill(SKILL_SPEED2, "Speed II", {
	{ "attr_movement_speed", 1.5, "good" },
	{ "attr_health", -2, "bad" },
}, -4, 4, {SKILL_SPEED3, SKILL_PHASER, SKILL_U_CORRUPTEDFRAGMENT}, TREE_SPEEDTREE)

GM:AddSkill(SKILL_SPEED3, "Speed III", {
	{ "attr_movement_speed", 3, "good" },
	{ "attr_health", -4, "bad" },
}, -4, 2, {SKILL_SPEED4}, TREE_SPEEDTREE)

GM:AddSkill(SKILL_SPEED4, "Speed IV", {
	{ "attr_movement_speed", 4.5, "good" },
	{ "attr_health", -6, "bad" },
}, -4, 0, {SKILL_SPEED5, SKILL_SAFEFALL}, TREE_SPEEDTREE)

GM:AddSkill(SKILL_SPEED5, "Speed V", {
	{ "attr_movement_speed", 5.25, "good" },
	{ "attr_health", -7, "bad" },
}, -4, -2, {SKILL_ULTRANIMBLE, SKILL_BACKPEDDLER, SKILL_MOTIONI, SKILL_CARDIOTONIC, SKILL_UNBOUND}, TREE_SPEEDTREE)

GM:AddSkill(SKILL_AGILEI, "Agile I", {
	{ "attr_jump_power", 4, "good" },
	{ "attr_movement_speed", -2, "bad" },
}, 4, 6, {SKILL_NONE, SKILL_AGILEII}, TREE_SPEEDTREE)

GM:AddSkill(SKILL_AGILEII, "Agile II", {
	{ "attr_jump_power", 5, "good" },
	{ "attr_movement_speed", -3, "bad" },
}, 4, 2, {SKILL_AGILEIII, SKILL_WORTHINESS3}, TREE_SPEEDTREE)

GM:AddSkill(SKILL_AGILEIII, "Agile III", {
	{ "attr_jump_power", 6, "good" },
	{ "attr_movement_speed", -4, "bad" },
}, 4, -2, {SKILL_SAFEFALL, SKILL_ULTRANIMBLE, SKILL_SURESTEP, SKILL_INTREPID}, TREE_SPEEDTREE)

GM:AddSkill(SKILL_D_SLOW, "Debuff: Slow", {
	{ "attr_worth_starting", 15, "good" },
	{ "attr_endwave_points", 1, "good" },
	{ "attr_movement_speed", -33.75, "bad" },
}, 0, -4, {}, TREE_SPEEDTREE)

GM:AddSkill(SKILL_MOTIONI, "Motion I", { { "attr_movement_speed", 0.75, "good" } }, -2, -2, {SKILL_MOTIONII}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_MOTIONII, "Motion II", { { "attr_movement_speed", 0.75, "good" } }, -1, -1, {SKILL_MOTIONIII}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_MOTIONIII, "Motion III", { { "attr_movement_speed", 0.75, "good" } }, 0, -2, {SKILL_D_SLOW}, TREE_SPEEDTREE)

GM:AddSkill(SKILL_BACKPEDDLER, "Backpeddler", {
	{ "attr_backpeddler_move", 0, "good" },
	{ "attr_movement_speed", -7, "bad" },
	{ "attr_backpeddler_leg", 0, "bad" },
}, -6, 0, {}, TREE_SPEEDTREE)

GM:AddSkill(SKILL_PHASER, "Phaser", {
	{ "attr_barricade_phase_speed", 15, "good" },
	{ "attr_sigil_teleport_time", 15, "bad" },
}, -1, 4, {SKILL_D_WIDELOAD, SKILL_DRIFT}, TREE_SPEEDTREE)

GM:AddSkill(SKILL_DRIFT, "Drift", { { "attr_barricade_phase_speed", 5, "good" } }, 1, 3, {SKILL_WARP}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_WARP, "Warp", { { "attr_sigil_teleport_time", -5, "good" } }, 2, 2, {}, TREE_SPEEDTREE)

GM:AddSkill(SKILL_SAFEFALL, "Safe Fall", {
	{ "attr_fall_damage_taken", -40, "good" },
	{ "attr_fall_damage_recovery", 50, "good" },
	{ "attr_fall_damage_slowdown", 40, "bad" },
}, 0, 0, {}, TREE_SPEEDTREE)

GM:AddSkill(SKILL_D_WIDELOAD, "Debuff: Wide Load", {
	{ "attr_worth_starting", 20, "good" },
	{ "attr_resupply_delay", -5, "good" },
	{ "attr_wideload_note", 0, "bad" },
}, 1, 1, {}, TREE_SPEEDTREE)

GM:AddSkill(SKILL_U_CORRUPTEDFRAGMENT, "Unlock: Corrupted Fragment", "Unlocks purchasing the Corrupted Fragment.\nGoes to corrupted sigils instead.", -2, 2, {}, TREE_SPEEDTREE)

GM:AddSkill(SKILL_ULTRANIMBLE, "Ultra Nimble", {
	{ "attr_movement_speed", 15, "good" },
	{ "attr_health", -20, "bad" },
}, 0, -6, {}, TREE_SPEEDTREE)

GM:AddSkill(SKILL_WORTHINESS3, "Worthiness III", {
	{ "attr_worth_starting", 5, "good" },
	{ "attr_points_starting", -3, "bad" },
}, 6, 2, {}, TREE_SPEEDTREE)

GM:AddSkill(SKILL_SURESTEP, "Sure Step", {
	{ "attr_slow_effectiveness", -30, "good" },
	{ "attr_movement_speed", -4, "bad" },
}, 6, 0, {}, TREE_SPEEDTREE)

GM:AddSkill(SKILL_INTREPID, "Intrepid", {
	{ "attr_low_health_slow", -35, "good" },
	{ "attr_movement_speed", -4, "bad" },
}, 6, -4, {SKILL_ROBUST}, TREE_SPEEDTREE)

GM:AddSkill(SKILL_ROBUST, "Robust", { { "attr_weapon_weight_slow", -6, "good" } }, 5, -5, {}, TREE_SPEEDTREE)

GM:AddSkill(SKILL_CARDIOTONIC, "Cardiotonic", {
	{ "attr_cardio_run", 0, "good" },
	{ "attr_movement_speed", -12, "bad" },
	{ "attr_blood_armor_absorb", -20, "bad" },
	{ "attr_cardio_sprint", 40, "good" },
}, -6, -4, {}, TREE_SPEEDTREE)

GM:AddSkill(SKILL_UNBOUND, "Unbound", {
	{ "attr_unbound_note", 60, "good" },
	{ "attr_movement_speed", -4, "bad" },
}, -4, -4, {}, TREE_SPEEDTREE)

-- Medic / Support Tree
GM:AddSkill(SKILL_SURGEON1, "Surgeon I", { { "attr_medkit_cooldown", -8, "good" } }, -4, 6, {SKILL_NONE, SKILL_SURGEON2}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_SURGEON2, "Surgeon II", { { "attr_medkit_cooldown", -9, "good" } }, -3, 3, {SKILL_WORTHINESS4, SKILL_SURGEON3}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_SURGEON3, "Surgeon III", { { "attr_medkit_cooldown", -10, "good" } }, -2, 0, {SKILL_U_MEDICCLOUD, SKILL_D_FRAIL, SKILL_SURGEONIV}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_SURGEONIV, "Surgeon IV", { { "attr_medkit_cooldown", -11, "good" } }, -2, -3, {}, TREE_SUPPORTTREE)

GM:AddSkill(SKILL_BIOLOGYI, "Biology I", { { "attr_medgun_effectiveness", 8, "good" } }, 4, 6, {SKILL_NONE, SKILL_BIOLOGYII}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_BIOLOGYII, "Biology II", { { "attr_medgun_effectiveness", 9, "good" } }, 3, 3, {SKILL_BIOLOGYIII, SKILL_SMARTTARGETING}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_BIOLOGYIII, "Biology III", { { "attr_medgun_effectiveness", 10, "good" } }, 2, 0, {SKILL_U_MEDICCLOUD, SKILL_U_ANTITODESHOT, SKILL_BIOLOGYIV}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_BIOLOGYIV, "Biology IV", { { "attr_medgun_effectiveness", 11, "good" } }, 2, -3, {}, TREE_SUPPORTTREE)

GM:AddSkill(SKILL_D_FRAIL, "Debuff: Frail", {
	{ "attr_worth_starting", 20, "good" },
	{ "attr_points_starting", 5, "good" },
	{ "attr_frail_note", 0, "bad" },
}, -4, -2, {}, TREE_SUPPORTTREE)

GM:AddSkill(SKILL_U_MEDICCLOUD, "Unlock: Medic Cloud Bomb", "Unlocks purchasing the Medic Cloud Bomb.\nSlowly heals all humans inside the cloud.", 0, -2, {SKILL_DISPERSION}, TREE_SUPPORTTREE).AlwaysActive = true

GM:AddSkill(SKILL_SMARTTARGETING, "Smart Targeting", {
	{ "attr_smarttargeting_note", 0, "good" },
	{ "attr_medgun_fire_delay", 75, "bad" },
	{ "attr_meddart_effectiveness", -30, "bad" },
}, 0, 2, {}, TREE_SUPPORTTREE)

GM:AddSkill(SKILL_RECLAIMSOL, "Recoverable Solution", {
	{ "attr_reclaims_ammo", 60, "good" },
	{ "attr_medgun_fire_delay", 150, "bad" },
	{ "attr_medgun_reload_speed", -40, "bad" },
	{ "attr_reclaims_note", 0, "bad" },
}, 0, 4, {SKILL_SMARTTARGETING}, TREE_SUPPORTTREE)

GM:AddSkill(SKILL_U_STRENGTHSHOT, "Unlock: Strength Shot Gun", "Unlocks purchasing the Strength Shot Gun.\nTarget damage +25% for 10 seconds.\nExtra damage is given to you as points.\nTarget is not healed.", 0, 0, {SKILL_SMARTTARGETING}, TREE_SUPPORTTREE)

GM:AddSkill(SKILL_WORTHINESS4, "Worthiness IV", {
	{ "attr_worth_starting", 5, "good" },
	{ "attr_points_starting", -3, "bad" },
}, -5, 2, {}, TREE_SUPPORTTREE)

GM:AddSkill(SKILL_U_ANTITODESHOT, "Unlock: Antidote Handgun", "Unlocks purchasing the Antidote Handgun.\nFires piercing blasts that heal poison greatly.\nCleanses statuses from targets with a small point gain.\nDoes not heal health.", 4, -2, {}, TREE_SUPPORTTREE)

GM:AddSkill(SKILL_DISPERSION, "Dispersion", {
	{ "attr_cloud_radius", 15, "good" },
	{ "attr_cloud_time", -10, "bad" },
}, 0, -4, {}, TREE_SUPPORTTREE)

-- Defence / Building Tree
GM:AddSkill(SKILL_HANDY1, "Handy I", { { "attr_repair_rate", 4, "good" } }, -5, -6, {SKILL_NONE, SKILL_HANDY2}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_HANDY2, "Handy II", { { "attr_repair_rate", 5, "good" } }, -5, -4, {SKILL_HANDY3, SKILL_U_BLASTTURRET, SKILL_LOADEDHULL}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_HANDY3, "Handy III", { { "attr_repair_rate", 6, "good" } }, -5, -1, {SKILL_TAUT, SKILL_HAMMERDISCIPLINE, SKILL_D_NOODLEARMS, SKILL_HANDY4}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_HANDY4, "Handy IV", { { "attr_repair_rate", 7, "good" } }, -3, 1, {SKILL_HANDY5}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_HANDY5, "Handy V", { { "attr_repair_rate", 8, "good" } }, -3, 3, {}, TREE_BUILDINGTREE)

GM:AddSkill(SKILL_HAMMERDISCIPLINE, "Hammer Discipline", { { "attr_hammer_swing_delay", -20, "good" } }, 0, 1, {SKILL_BARRICADEEXPERT}, TREE_BUILDINGTREE)

GM:AddSkill(SKILL_BARRICADEEXPERT, "Reinforcer", {
	{ "attr_reinforcer_note", 8, "good" },
	{ "attr_reinforcer_points", 0, "good" },
	{ "attr_hammer_swing_delay", 30, "bad" },
}, 0, 3, {}, TREE_BUILDINGTREE)

GM:AddSkill(SKILL_LOADEDHULL, "Loaded Hull", {
	{ "attr_controllable_explode", 0, "good" },
	{ "attr_controllable_health", -10, "bad" },
}, -2, -4, {SKILL_REINFORCEDHULL, SKILL_REINFORCEDBLADES, SKILL_AVIATOR}, TREE_BUILDINGTREE)

GM:AddSkill(SKILL_REINFORCEDHULL, "Reinforced Hull", {
	{ "attr_controllable_health", 25, "good" },
	{ "attr_controllable_handling", -20, "bad" },
	{ "attr_controllable_speed", -20, "bad" },
}, -2, -2, {SKILL_STABLEHULL}, TREE_BUILDINGTREE)

GM:AddSkill(SKILL_STABLEHULL, "Stable Hull", {
	{ "attr_controllable_impact", 0, "good" },
	{ "attr_controllable_speed", -20, "bad" },
}, 0, -3, {SKILL_U_DRONE}, TREE_BUILDINGTREE)

GM:AddSkill(SKILL_REINFORCEDBLADES, "Reinforced Blades", {
	{ "attr_manhack_damage", 25, "good" },
	{ "attr_manhack_health", -15, "bad" },
}, 0, -5, {}, TREE_BUILDINGTREE)

GM:AddSkill(SKILL_AVIATOR, "Aviator", {
	{ "attr_controllable_speed", 40, "good" },
	{ "attr_controllable_handling", 40, "good" },
	{ "attr_controllable_health", -25, "bad" },
}, -4, -2, {}, TREE_BUILDINGTREE)

GM:AddSkill(SKILL_U_BLASTTURRET, "Unlock: Blast Turret", "Unlocks purchasing the Blast Turret.\nFires buckshot instead of SMG ammo.\nDamage is higher close up.\nCannot scan for targets far away.", -8, -4, {SKILL_TURRETLOCK, SKILL_TWINVOLLEY, SKILL_TURRETOVERLOAD}, TREE_BUILDINGTREE).AlwaysActive = true

GM:AddSkill(SKILL_TURRETLOCK, "Turret Lock", {
	{ "attr_turret_lock_note", 90, "bad" },
	{ "attr_turret_target_lock", 90, "bad" },
}, -6, -2, {}, TREE_BUILDINGTREE)

GM:AddSkill(SKILL_TWINVOLLEY, "Twin Volley", {
	{ "attr_twin_volley_note", 0, "good" },
	{ "attr_twin_volley_ammo", 100, "bad" },
	{ "attr_twin_volley_delay", 50, "bad" },
}, -10, -5, {}, TREE_BUILDINGTREE)

GM:AddSkill(SKILL_TURRETOVERLOAD, "Turret Overload", {
	{ "attr_turret_scan_speed", 100, "good" },
	{ "attr_turret_range", -30, "bad" },
}, -8, -2, {SKILL_INSTRUMENTS}, TREE_BUILDINGTREE)

GM:AddSkill(SKILL_U_DRONE, "Unlock: Pulse Drone", "Unlocks the Pulse Drone Variant.\nFires short range pulse projectiles instead of bullets.", 2, -3, {SKILL_HAULMODULE, SKILL_U_ROLLERMINE}, TREE_BUILDINGTREE).AlwaysActive = true

GM:AddSkill(SKILL_U_NANITECLOUD, "Unlock: Nanite Cloud Bomb", "Unlocks purchasing the Nanite Cloud Bomb.\nSlowly repairs all props and deployables inside the cloud.", 3, 1, {SKILL_HAMMERDISCIPLINE}, TREE_BUILDINGTREE).AlwaysActive = true

GM:AddSkill(SKILL_FIELDAMP, "Field Amplifier", {
	{ "attr_field_delay", -20, "good" },
	{ "attr_field_range", -40, "bad" },
}, 6, 4, {}, TREE_BUILDINGTREE)

GM:AddSkill(SKILL_TECHNICIAN, "Field Technician", {
	{ "attr_field_range", 3, "good" },
	{ "attr_field_delay", -3, "good" },
}, 4, 3, {}, TREE_BUILDINGTREE)

GM:AddSkill(SKILL_U_ROLLERMINE, "Unlock: Rollermine", "Unlocks purchasing Rollermines.\nRolls along the ground, shocking zombies and dealing damage.", 3, -5, {}, TREE_BUILDINGTREE)

GM:AddSkill(SKILL_HAULMODULE, "Unlock: Hauling Drone", "Unlocks the Hauling Drone.\nRapidly transports props and items but cannot attack.", 2, -1, {SKILL_U_NANITECLOUD}, TREE_BUILDINGTREE)

GM:AddSkill(SKILL_LIGHTCONSTRUCT, "Light Construction", {
	{ "attr_deployable_packtime", -25, "good" },
	{ "attr_deployable_health", -25, "bad" },
}, 8, -1, {}, TREE_BUILDINGTREE)

GM:AddSkill(SKILL_STOCKPILE, "Stockpiling", {
	{ "attr_stockpile_collect", 0, "good" },
	{ "attr_stockpile_delay", 2.12, "bad" },
}, 8, -3, {}, TREE_BUILDINGTREE)

GM:AddSkill(SKILL_ACUITY, "Supplier's Acuity", "Locate nearby resupply boxes if behind walls.\nLocate nearby unplaced resupply boxes on players through walls.\nLocate nearby resupply packs through walls.", 6, -3, {SKILL_INSIGHT, SKILL_STOCKPILE, SKILL_U_CRAFTINGPACK, SKILL_STOWAGE}, TREE_BUILDINGTREE)

GM:AddSkill(SKILL_VISION, "Refiner's Vision", "Locate nearby remantlers if behind walls.\nLocate nearby unplaced remantlers on players through walls.", 6, -6, {SKILL_NONE, SKILL_ACUITY}, TREE_BUILDINGTREE)

GM:AddSkill(SKILL_U_ROCKETTURRET, "Unlock: Rocket Turret", "Unlocks purchasing the Rocket Turret.\nFires explosives instead of SMG ammo.\nDeals damage in a radius.\nHigh tier deployable.", -8, 0, {SKILL_TURRETOVERLOAD}, TREE_BUILDINGTREE)

GM:AddSkill(SKILL_INSIGHT, "Buyer's Insight", "Locate nearby arsenal crates if behind walls.\nLocate nearby unplaced arsenal crates on players through walls.\nLocate nearby arsenal packs through walls.", 6, 0, {SKILL_U_NANITECLOUD, SKILL_U_ZAPPER_ARC, SKILL_LIGHTCONSTRUCT, SKILL_D_LATEBUYER}, TREE_BUILDINGTREE).AlwaysActive = true

GM:AddSkill(SKILL_U_ZAPPER_ARC, "Unlock: Arc Zapper", "Unlocks purchasing the Arc Zapper.\nZaps zombies that get nearby, and jumps in an arc.\nMid tier deployable and long cooldown.\nRequires a steady upkeep of pulse ammo.", 6, 2, {SKILL_FIELDAMP, SKILL_TECHNICIAN}, TREE_BUILDINGTREE).AlwaysActive = true

GM:AddSkill(SKILL_D_LATEBUYER, "Debuff: Late Buyer", {
	{ "attr_worth_starting", 20, "good" },
	{ "attr_arsenal_discount", 2, "good" },
	{ "attr_latebuyer_note", 0, "bad" },
}, 8, 1, {}, TREE_BUILDINGTREE)

GM:AddSkill(SKILL_U_CRAFTINGPACK, "Unlock: Crafting Pack", "Unlocks purchasing the Sawblade component.\nUnlocks purchasing the Electrobattery component.\nUnlocks purchasing the CPU Parts component.", 4, -1, {}, TREE_BUILDINGTREE).AlwaysActive = true

GM:AddSkill(SKILL_TAUT, "Taut", {
	{ "attr_taut_note", 0, "good" },
	{ "attr_prop_carry_slow", 40, "bad" },
}, -5, 3, {}, TREE_BUILDINGTREE)

GM:AddSkill(SKILL_D_NOODLEARMS, "Debuff: Noodle Arms", {
	{ "attr_worth_starting", 5, "good" },
	{ "attr_scrap_starting", 1, "good" },
	{ "attr_noodlearms_note", 0, "bad" },
}, -7, 2, {}, TREE_BUILDINGTREE)

GM:AddSkill(SKILL_INSTRUMENTS, "Instruments", { { "attr_turret_range", 5, "good" } }, -10, -3, {}, TREE_BUILDINGTREE)

GM:AddSkill(SKILL_STOWAGE, "Stowage", {
	{ "attr_stowage_note", 0, "good" },
	{ "attr_resupply_delay", 15, "bad" },
}, 4, -3, {}, TREE_BUILDINGTREE)

-- Gunnery Tree
GM:AddSkill(SKILL_TRIGGER_DISCIPLINE1, "Trigger Discipline I", {
	{ "attr_reload_speed", 2, "good" },
	{ "attr_weapon_switch_speed", 2, "good" },
}, -5, 6, {SKILL_TRIGGER_DISCIPLINE2, SKILL_NONE}, TREE_GUNTREE)

GM:AddSkill(SKILL_TRIGGER_DISCIPLINE2, "Trigger Discipline II", {
	{ "attr_reload_speed", 3, "good" },
	{ "attr_weapon_switch_speed", 3, "good" },
}, -4, 3, {SKILL_TRIGGER_DISCIPLINE3, SKILL_D_PALSY, SKILL_EQUIPPED}, TREE_GUNTREE)

GM:AddSkill(SKILL_TRIGGER_DISCIPLINE3, "Trigger Discipline III", {
	{ "attr_reload_speed", 4, "good" },
	{ "attr_weapon_switch_speed", 4, "good" },
}, -3, 0, {SKILL_QUICKRELOAD, SKILL_QUICKDRAW, SKILL_WORTHINESS1, SKILL_EGOCENTRIC}, TREE_GUNTREE)

GM:AddSkill(SKILL_D_PALSY, "Debuff: Palsy", {
	{ "attr_worth_starting", 10, "good" },
	{ "attr_resupply_delay", -3, "good" },
	{ "attr_palsy_note", 0, "bad" },
}, 0, 4, {SKILL_LEVELHEADED}, TREE_GUNTREE)

GM:AddSkill(SKILL_LEVELHEADED, "Level Headed", { { "attr_aim_shake", -5, "good" } }, -2, 2, {}, TREE_GUNTREE)

GM:AddSkill(SKILL_QUICKDRAW, "Quick Draw", {
	{ "attr_weapon_switch_speed", 65, "good" },
	{ "attr_reload_speed", -15, "bad" },
}, 0, 1, {}, TREE_GUNTREE)

GM:AddSkill(SKILL_FOCUS, "Focus I", {
	{ "attr_aim_tighter", 3, "good" },
	{ "attr_reload_speed", -3, "bad" },
}, 5, 6, {SKILL_NONE, SKILL_FOCUSII}, TREE_GUNTREE)

GM:AddSkill(SKILL_FOCUSII, "Focus II", {
	{ "attr_aim_tighter", 4, "good" },
	{ "attr_reload_speed", -4, "bad" },
}, 4, 3, {SKILL_FOCUSIII, SKILL_SCAVENGER, SKILL_D_PALSY, SKILL_PITCHER}, TREE_GUNTREE)

GM:AddSkill(SKILL_FOCUSIII, "Focus III", {
	{ "attr_aim_tighter", 5, "good" },
	{ "attr_reload_speed", -5, "bad" },
}, 3, 0, {SKILL_EGOCENTRIC, SKILL_WOOISM, SKILL_ORPHICFOCUS, SKILL_SCOURER}, TREE_GUNTREE)

GM:AddSkill(SKILL_QUICKRELOAD, "Quick Reload", {
	{ "attr_reload_speed", 10, "good" },
	{ "attr_weapon_switch_speed", -25, "bad" },
}, -5, 1, {SKILL_SLEIGHTOFHAND}, TREE_GUNTREE)

GM:AddSkill(SKILL_SLEIGHTOFHAND, "Sleight of Hand", {
	{ "attr_reload_speed", 10, "good" },
	{ "attr_aim_spread_penalty", -5, "bad" },
}, -5, -1, {}, TREE_GUNTREE)

GM:AddSkill(SKILL_U_CRYGASGREN, "Unlock: Cryo Gas Grenade", "Unlocks purchasing the Cryo Gas Grenade.\nVariant of the Corrosive Gas Grenade.\nCryo gas deals a bit of damage over time.\nZombies are slowed in the effect.", 2, -3, {SKILL_EGOCENTRIC}, TREE_GUNTREE)

GM:AddSkill(SKILL_SOFTDET, "Soft Detonation", {
	{ "attr_explosive_damage_taken", -40, "good" },
	{ "attr_explosive_radius", -10, "bad" },
}, 0, -5, {}, TREE_GUNTREE)

GM:AddSkill(SKILL_ORPHICFOCUS, "Orphic Focus", {
	{ "attr_orphic_ironsight", 90, "good" },
	{ "attr_aim_tighter", 2, "good" },
	{ "attr_orphic_othertime", 110, "bad" },
	{ "attr_reload_speed", -6, "bad" },
}, 5, -1, {SKILL_DELIBRATION}, TREE_GUNTREE)

GM:AddSkill(SKILL_DELIBRATION, "Delibration", { { "attr_aim_tighter", 1, "good" } }, 6, -3, {}, TREE_GUNTREE)

GM:AddSkill(SKILL_EGOCENTRIC, "Egocentric", {
	{ "attr_self_damage_taken", -35, "good" },
	{ "attr_health", -5, "bad" },
}, 0, -1, {SKILL_BLASTPROOF}, TREE_GUNTREE)

GM:AddSkill(SKILL_BLASTPROOF, "Blast Proof", {
	{ "attr_self_damage_taken", -45, "good" },
	{ "attr_reload_speed", -7, "bad" },
	{ "attr_weapon_switch_speed", -12, "bad" },
}, 0, -3, {SKILL_SOFTDET, SKILL_CANNONBALL, SKILL_CONEFFECT}, TREE_GUNTREE)

GM:AddSkill(SKILL_WOOISM, "Zeal", {
	{ "attr_ironsight_speed", -50, "good" },
	{ "attr_ironsight_bonus", -25, "bad" },
}, 5, 1, {SKILL_TRUEWOOISM}, TREE_GUNTREE)

GM:AddSkill(SKILL_SCAVENGER, "Scavenger's Eyes", "See nearby weapons, ammo, and items through walls.", 7, 4, {}, TREE_GUNTREE)

GM:AddSkill(SKILL_PITCHER, "Pitcher", { { "attr_prop_throw_strength", 10, "good" } }, 6, 2, {}, TREE_GUNTREE)

GM:AddSkill(SKILL_EQUIPPED, "Alacrity", "Your starting item can be a random special trinket.", -6, 2, {}, TREE_GUNTREE)

GM:AddSkill(SKILL_WORTHINESS1, "Worthiness I", {
	{ "attr_worth_starting", 5, "good" },
	{ "attr_points_starting", -3, "bad" },
}, -4, -3, {}, TREE_GUNTREE)

GM:AddSkill(SKILL_CANNONBALL, "Cannonball", {
	{ "attr_projectile_speed", -25, "bad" },
	{ "attr_projectile_damage", 3, "good" },
}, -2, -3, {}, TREE_GUNTREE)

GM:AddSkill(SKILL_SCOURER, "Scourer", "Earn end of wave points as scrap.\nEarn no end of wave points.", 4, -3, {}, TREE_GUNTREE)

GM:AddSkill(SKILL_CONEFFECT, "Concentrated Effect", {
	{ "attr_explosive_damage", 5, "good" },
	{ "attr_explosive_radius", -20, "bad" },
}, 2, -5, {}, TREE_GUNTREE)

GM:AddSkill(SKILL_TRUEWOOISM, "Wooism", "No accuracy penalty from moving or jumping.\nNo accuracy bonus from crouching or ironsighting.", 7, 0, {}, TREE_GUNTREE)

-- Melee Tree
GM:AddSkill(SKILL_WORTHINESS2, "Worthiness II", {
	{ "attr_worth_starting", 5, "good" },
	{ "attr_points_starting", -3, "bad" },
}, 4, 0, {}, TREE_MELEETREE)

GM:AddSkill(SKILL_BATTLER1, "Battler I", { { "attr_melee_damage", 4, "good" } }, -6, -6, {SKILL_BATTLER2, SKILL_NONE}, TREE_MELEETREE)
GM:AddSkill(SKILL_BATTLER2, "Battler II", { { "attr_melee_damage", 5, "good" } }, -6, -4, {SKILL_BATTLER3, SKILL_LIGHTWEIGHT}, TREE_MELEETREE)
GM:AddSkill(SKILL_BATTLER3, "Battler III", { { "attr_melee_damage", 5, "good" } }, -4, -2, {SKILL_BATTLER4, SKILL_LANKY}, TREE_MELEETREE)
GM:AddSkill(SKILL_BATTLER4, "Battler IV", { { "attr_melee_damage", 6, "good" } }, -2, 0, {SKILL_BATTLER5, SKILL_MASTERCHEF, SKILL_D_CLUMSY}, TREE_MELEETREE)
GM:AddSkill(SKILL_BATTLER5, "Battler V", { { "attr_melee_damage", 7, "good" } }, 0, 2, {SKILL_GLASSWEAPONS, SKILL_BLOODLUST}, TREE_MELEETREE)

GM:AddSkill(SKILL_LASTSTAND, "Last Stand", "Double melee damage when below 25% health.\n0.85x melee weapon damage at any other time.", 0, 6, {}, TREE_MELEETREE)

GM:AddSkill(SKILL_GLASSWEAPONS, "Glass Weapons", "3.5x melee weapon damage vs. zombies.\nYour melee weapons have a 50% chance to break when hitting a zombie.", 2, 4, {}, TREE_MELEETREE)

GM:AddSkill(SKILL_D_CLUMSY, "Debuff: Clumsy", {
	{ "attr_worth_starting", 20, "good" },
	{ "attr_points_starting", 5, "good" },
	{ "attr_clumsy_note", 0, "bad" },
}, -2, 2, {}, TREE_MELEETREE)

GM:AddSkill(SKILL_CHEAPKNUCKLE, "Cheap Tactics", {
	{ "attr_cheaptactics_note", 0, "good" },
	{ "attr_melee_range", -10, "bad" },
}, 4, -2, {SKILL_HEAVYSTRIKES, SKILL_WORTHINESS2}, TREE_MELEETREE)

GM:AddSkill(SKILL_CRITICALKNUCKLE, "Critical Knuckle", {
	{ "attr_criticalknuckle_note", 0, "good" },
	{ "attr_unarmed_damage", -25, "bad" },
	{ "attr_unarmed_swing_delay", 25, "bad" },
}, 6, -2, {SKILL_BRASH}, TREE_MELEETREE)

GM:AddSkill(SKILL_KNUCKLEMASTER, "Knuckle Master", {
	{ "attr_unarmed_damage", 75, "good" },
	{ "attr_knuckle_master_move", 0, "good" },
	{ "attr_unarmed_swing_delay", 35, "bad" },
}, 6, -6, {SKILL_NONE, SKILL_COMBOKNUCKLE}, TREE_MELEETREE)

GM:AddSkill(SKILL_COMBOKNUCKLE, "Combo Knuckle", "Next unarmed strike is 2x faster if hitting something.\nNext unarmed attack is 2x slower if not hitting something.", 6, -4, {SKILL_CHEAPKNUCKLE, SKILL_CRITICALKNUCKLE}, TREE_MELEETREE)

GM:AddSkill(SKILL_HEAVYSTRIKES, "Heavy Strikes", {
	{ "attr_melee_knockback", 100, "good" },
	{ "attr_heavystrikes_reflect", 8, "bad" },
	{ "attr_heavystrikes_unarmed", 100, "bad" },
}, 2, 0, {SKILL_BATTLER5, SKILL_JOUSTER}, TREE_MELEETREE)

GM:AddSkill(SKILL_JOUSTER, "Jouster", {
	{ "attr_melee_damage", 10, "good" },
	{ "attr_melee_knockback", -100, "bad" },
}, 2, 2, {}, TREE_MELEETREE)

GM:AddSkill(SKILL_LANKY, "Lanky I", {
	{ "attr_melee_range", 10, "good" },
	{ "attr_melee_damage", -15, "bad" },
}, -4, 0, {SKILL_LANKYII}, TREE_MELEETREE)

GM:AddSkill(SKILL_LANKYII, "Lanky II", {
	{ "attr_melee_range", 10, "good" },
	{ "attr_melee_damage", -15, "bad" },
}, -4, 2, {}, TREE_MELEETREE)

GM:AddSkill(SKILL_MASTERCHEF, "Master Chef", {
	{ "attr_masterchef_note", 0, "good" },
	{ "attr_melee_damage", -10, "bad" },
}, 0, -3, {SKILL_BATTLER4}, TREE_MELEETREE)

GM:AddSkill(SKILL_LIGHTWEIGHT, "Lightweight", {
	{ "attr_lightweight_move", 6, "good" },
	{ "attr_melee_damage", -20, "bad" },
}, -6, -2, {}, TREE_MELEETREE)

GM:AddSkill(SKILL_BLOODLUST, "Bloodlust", "Gain phantom health equal to half the damage taken from zombies.\nLose phantom health equal to any healing received.\nPhantom health decreases by 5 per second.\nHeal 25% of damage done with melee from remaining phantom health.\n-50% healing received.", -2, 4, {SKILL_LASTSTAND}, TREE_MELEETREE)

GM:AddSkill(SKILL_BRASH, "Brash", {
	{ "attr_melee_swing_delay", -16, "good" },
	{ "attr_melee_speed_on_kill", -15, "bad" },
}, 6, 0, {}, TREE_MELEETREE)

GM:SetSkillModifierFunction(SKILLMOD_SPEED, function(pl, amount)
	pl.SkillSpeedAdd = amount
end)

GM:SetSkillModifierFunction(SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, function(pl, amount)
	pl.MedicHealMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MEDKIT_COOLDOWN_MUL, function(pl, amount)
	pl.MedicCooldownMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_WORTH, function(pl, amount)
	pl.ExtraStartingWorth = amount
end)

GM:SetSkillModifierFunction(SKILLMOD_FALLDAMAGE_THRESHOLD_MUL, function(pl, amount)
	pl.FallDamageThresholdMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_FALLDAMAGE_SLOWDOWN_MUL, function(pl, amount)
	pl.FallDamageSlowDownMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_FOODEATTIME_MUL, function(pl, amount)
	pl.FoodEatTimeMul = math.Clamp(amount + 1.0, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_JUMPPOWER_MUL, function(pl, amount)
	pl.JumpPowerMul = math.Clamp(amount + 1.0, 0.0, 10.0)

	if SERVER then
		pl:ResetJumpPower()
	end
end)

GM:SetSkillModifierFunction(SKILLMOD_DEPLOYSPEED_MUL, function(pl, amount)
	pl.DeploySpeedMultiplier = math.Clamp(amount + 1.0, 0.05, 100.0)

	for _, wep in pairs(pl:GetWeapons()) do
		GAMEMODE:DoChangeDeploySpeed(wep)
	end
end)

GM:SetSkillModifierFunction(SKILLMOD_BLOODARMOR, function(pl, amount)
	local oldarmor = pl:GetBloodArmor()
	local oldcap = pl.MaxBloodArmor or 20
	local new = 20 + math.Clamp(amount, -20, 1000)

	pl.MaxBloodArmor = new

	if SERVER then
		if oldarmor > oldcap then
			local overcap = oldarmor - oldcap
			pl:SetBloodArmor(pl.MaxBloodArmor + overcap)
		else
			pl:SetBloodArmor(pl:GetBloodArmor() / oldcap * new)
		end
	end
end)

GM:SetSkillModifierFunction(SKILLMOD_RELOADSPEED_MUL, function(pl, amount)
	pl.ReloadSpeedMultiplier = math.Clamp(amount + 1.0, 0.05, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_DAMAGE_MUL, function(pl, amount)
	pl.MeleeDamageMultiplier = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_SELF_DAMAGE_MUL, function(pl, amount)
	pl.SelfDamageMul = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_KNOCKBACK_MUL, function(pl, amount)
	pl.MeleeKnockbackMultiplier = math.Clamp(amount + 1.0, 0.0, 10000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_UNARMED_DAMAGE_MUL, function(pl, amount)
	pl.UnarmedDamageMul = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_UNARMED_SWING_DELAY_MUL, function(pl, amount)
	pl.UnarmedDelayMul = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_BARRICADE_PHASE_SPEED_MUL, function(pl, amount)
	pl.BarricadePhaseSpeedMul = math.Clamp(amount + 1.0, 0.05, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_HAMMER_SWING_DELAY_MUL, function(pl, amount)
	pl.HammerSwingDelayMul = math.Clamp(amount + 1.0, 0.01, 1.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_REPAIRRATE_MUL, function(pl, amount)
	pl.RepairRateMul = math.Clamp(amount + 1.0, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_AIMSPREAD_MUL, function(pl, amount)
	pl.AimSpreadMul = math.Clamp(amount + 1.0, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MEDGUN_FIRE_DELAY_MUL, function(pl, amount)
	pl.MedgunFireDelayMul = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MEDGUN_RELOAD_SPEED_MUL, function(pl, amount)
	pl.MedgunReloadSpeedMul = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_DRONE_GUN_RANGE_MUL, function(pl, amount)
	pl.DroneGunRangeMul = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_HEALING_RECEIVED, function(pl, amount)
	pl.HealingReceived = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_RELOADSPEED_PISTOL_MUL, function(pl, amount)
	pl.ReloadSpeedMultiplierPISTOL = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_RELOADSPEED_SMG_MUL, function(pl, amount)
	pl.ReloadSpeedMultiplierSMG1 = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_RELOADSPEED_ASSAULT_MUL, function(pl, amount)
	pl.ReloadSpeedMultiplierAR2 = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_RELOADSPEED_SHELL_MUL, function(pl, amount)
	pl.ReloadSpeedMultiplierBUCKSHOT = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_RELOADSPEED_RIFLE_MUL, function(pl, amount)
	pl.ReloadSpeedMultiplier357 = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_RELOADSPEED_XBOW_MUL, function(pl, amount)
	pl.ReloadSpeedMultiplierXBOWBOLT = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_RELOADSPEED_PULSE_MUL, function(pl, amount)
	pl.ReloadSpeedMultiplierPULSE = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_RELOADSPEED_EXP_MUL, function(pl, amount)
	pl.ReloadSpeedMultiplierIMPACTMINE = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_ATTACKER_DMG_REFLECT, function(pl, amount)
	pl.BarbedArmor = math.Clamp(amount, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_PULSE_WEAPON_SLOW_MUL, function(pl, amount)
	pl.PulseWeaponSlowMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, function(pl, amount)
	pl.MeleeDamageTakenMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_POISON_DAMAGE_TAKEN_MUL, function(pl, amount)
	pl.PoisonDamageTakenMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_BLEED_DAMAGE_TAKEN_MUL, function(pl, amount)
	pl.BleedDamageTakenMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_SWING_DELAY_MUL, function(pl, amount)
	pl.MeleeSwingDelayMul = math.Clamp(amount + 1.0, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_DAMAGE_TO_BLOODARMOR_MUL, function(pl, amount)
	pl.MeleeDamageToBloodArmorMul = math.Clamp(amount, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_MOVEMENTSPEED_ON_KILL, function(pl, amount)
	pl.MeleeMovementSpeedOnKill = math.Clamp(amount, -15, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_POWERATTACK_MUL, function(pl, amount)
	pl.MeleePowerAttackMul = math.Clamp(amount + 1.0, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_KNOCKDOWN_RECOVERY_MUL, function(pl, amount)
	pl.KnockdownRecoveryMul = math.Clamp(amount + 1.0, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_RANGE_MUL, function(pl, amount)
	pl.MeleeRangeMul = math.Clamp(amount + 1.0, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_SLOW_EFF_TAKEN_MUL, function(pl, amount)
	pl.SlowEffTakenMul = math.Clamp(amount + 1.0, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_EXP_DAMAGE_TAKEN_MUL, function(pl, amount)
	pl.ExplosiveDamageTakenMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_FIRE_DAMAGE_TAKEN_MUL, function(pl, amount)
	pl.FireDamageTakenMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_PROP_CARRY_CAPACITY_MUL, function(pl, amount)
	pl.PropCarryCapacityMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_PROP_THROW_STRENGTH_MUL, function(pl, amount)
	pl.ObjectThrowStrengthMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_PHYSICS_DAMAGE_TAKEN_MUL, function(pl, amount)
	pl.PhysicsDamageTakenMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_VISION_ALTER_DURATION_MUL, function(pl, amount)
	pl.VisionAlterDurationMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_DIMVISION_EFF_MUL, function(pl, amount)
	pl.DimVisionEffMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_PROP_CARRY_SLOW_MUL, function(pl, amount)
	pl.PropCarrySlowMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_BLEED_SPEED_MUL, function(pl, amount)
	pl.BleedSpeedMul = math.Clamp(amount + 1.0, 0.1, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_LEG_DAMAGE_ADD, function(pl, amount)
	pl.MeleeLegDamageAdd = math.Clamp(amount, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_SIGIL_TELEPORT_MUL, function(pl, amount)
	pl.SigilTeleportTimeMul = math.Clamp(amount + 1.0, 0.1, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_ATTACKER_DMG_REFLECT_PERCENT, function(pl, amount)
	pl.BarbedArmorPercent = math.Clamp(amount, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_POISON_SPEED_MUL, function(pl, amount)
	pl.PoisonSpeedMul = math.Clamp(amount + 1.0, 0.1, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_PROJECTILE_DAMAGE_TAKEN_MUL, GM:MkGenericMod("ProjDamageTakenMul"))
GM:SetSkillModifierFunction(SKILLMOD_EXP_DAMAGE_RADIUS, GM:MkGenericMod("ExpDamageRadiusMul"))
GM:SetSkillModifierFunction(SKILLMOD_WEAPON_WEIGHT_SLOW_MUL, GM:MkGenericMod("WeaponWeightSlowMul"))
GM:SetSkillModifierFunction(SKILLMOD_FRIGHT_DURATION_MUL, GM:MkGenericMod("FrightDurationMul"))
GM:SetSkillModifierFunction(SKILLMOD_IRONSIGHT_EFF_MUL, GM:MkGenericMod("IronsightEffMul"))
GM:SetSkillModifierFunction(SKILLMOD_MEDDART_EFFECTIVENESS_MUL, GM:MkGenericMod("MedDartEffMul"))

GM:SetSkillModifierFunction(SKILLMOD_BLOODARMOR_DMG_REDUCTION, function(pl, amount)
	pl.BloodArmorDamageReductionAdd = amount
end)

GM:SetSkillModifierFunction(SKILLMOD_BLOODARMOR_MUL, function(pl, amount)
	local mul = math.Clamp(amount + 1.0, 0.0, 1000.0)

	pl.MaxBloodArmorMul = mul

	local oldarmor = pl:GetBloodArmor()
	local oldcap = pl.MaxBloodArmor or 20
	local new = pl.MaxBloodArmor * mul

	pl.MaxBloodArmor = new

	if SERVER then
		if oldarmor > oldcap then
			local overcap = oldarmor - oldcap
			pl:SetBloodArmor(pl.MaxBloodArmor + overcap)
		else
			pl:SetBloodArmor(pl:GetBloodArmor() / oldcap * new)
		end
	end
end)

GM:SetSkillModifierFunction(SKILLMOD_BLOODARMOR_GAIN_MUL, GM:MkGenericMod("BloodarmorGainMul"))
GM:SetSkillModifierFunction(SKILLMOD_LOW_HEALTH_SLOW_MUL, GM:MkGenericMod("LowHealthSlowMul"))
GM:SetSkillModifierFunction(SKILLMOD_PROJ_SPEED, GM:MkGenericMod("ProjectileSpeedMul"))

GM:SetSkillModifierFunction(SKILLMOD_ENDWAVE_POINTS, function(pl,amount)
	pl.EndWavePointsExtra = math.Clamp(amount, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_ARSENAL_DISCOUNT, GM:MkGenericMod("ArsenalDiscount"))
GM:SetSkillModifierFunction(SKILLMOD_CLOUD_RADIUS, GM:MkGenericMod("CloudRadius"))
GM:SetSkillModifierFunction(SKILLMOD_CLOUD_TIME, GM:MkGenericMod("CloudTime"))
GM:SetSkillModifierFunction(SKILLMOD_EXP_DAMAGE_MUL, GM:MkGenericMod("ExplosiveDamageMul"))
GM:SetSkillModifierFunction(SKILLMOD_PROJECTILE_DAMAGE_MUL, GM:MkGenericMod("ProjectileDamageMul"))
GM:SetSkillModifierFunction(SKILLMOD_TURRET_RANGE_MUL, GM:MkGenericMod("TurretRangeMul"))
GM:SetSkillModifierFunction(SKILLMOD_AIM_SHAKE_MUL, GM:MkGenericMod("AimShakeMul"))

GM:AddSkillModifier(SKILL_SPEED1, SKILLMOD_SPEED, 0.75)
GM:AddSkillModifier(SKILL_SPEED1, SKILLMOD_HEALTH, -1)

GM:AddSkillModifier(SKILL_SPEED2, SKILLMOD_SPEED, 1.5)
GM:AddSkillModifier(SKILL_SPEED2, SKILLMOD_HEALTH, -2)

GM:AddSkillModifier(SKILL_SPEED3, SKILLMOD_SPEED, 3)
GM:AddSkillModifier(SKILL_SPEED3, SKILLMOD_HEALTH, -4)

GM:AddSkillModifier(SKILL_SPEED4, SKILLMOD_SPEED, 4.5)
GM:AddSkillModifier(SKILL_SPEED4, SKILLMOD_HEALTH, -6)

GM:AddSkillModifier(SKILL_SPEED5, SKILLMOD_SPEED, 5.25)
GM:AddSkillModifier(SKILL_SPEED5, SKILLMOD_HEALTH, -7)

GM:AddSkillModifier(SKILL_STOIC1, SKILLMOD_HEALTH, 1)
GM:AddSkillModifier(SKILL_STOIC1, SKILLMOD_SPEED, -0.75)

GM:AddSkillModifier(SKILL_STOIC2, SKILLMOD_HEALTH, 2)
GM:AddSkillModifier(SKILL_STOIC2, SKILLMOD_SPEED, -1.5)

GM:AddSkillModifier(SKILL_STOIC3, SKILLMOD_HEALTH, 4)
GM:AddSkillModifier(SKILL_STOIC3, SKILLMOD_SPEED, -3)

GM:AddSkillModifier(SKILL_STOIC4, SKILLMOD_HEALTH, 6)
GM:AddSkillModifier(SKILL_STOIC4, SKILLMOD_SPEED, -4.5)

GM:AddSkillModifier(SKILL_STOIC5, SKILLMOD_HEALTH, 7)
GM:AddSkillModifier(SKILL_STOIC5, SKILLMOD_SPEED, -5.25)

GM:AddSkillModifier(SKILL_VITALITY1, SKILLMOD_HEALTH, 1)
GM:AddSkillModifier(SKILL_VITALITY2, SKILLMOD_HEALTH, 1)
GM:AddSkillModifier(SKILL_VITALITY3, SKILLMOD_HEALTH, 1)

GM:AddSkillModifier(SKILL_MOTIONI, SKILLMOD_SPEED, 0.75)
GM:AddSkillModifier(SKILL_MOTIONII, SKILLMOD_SPEED, 0.75)
GM:AddSkillModifier(SKILL_MOTIONIII, SKILLMOD_SPEED, 0.75)

GM:AddSkillModifier(SKILL_FOCUS, SKILLMOD_AIMSPREAD_MUL, -0.03)
GM:AddSkillModifier(SKILL_FOCUS, SKILLMOD_RELOADSPEED_MUL, -0.03)

GM:AddSkillModifier(SKILL_FOCUSII, SKILLMOD_AIMSPREAD_MUL, -0.04)
GM:AddSkillModifier(SKILL_FOCUSII, SKILLMOD_RELOADSPEED_MUL, -0.04)

GM:AddSkillModifier(SKILL_FOCUSIII, SKILLMOD_AIMSPREAD_MUL, -0.05)
GM:AddSkillModifier(SKILL_FOCUSIII, SKILLMOD_RELOADSPEED_MUL, -0.05)

GM:AddSkillModifier(SKILL_ORPHICFOCUS, SKILLMOD_RELOADSPEED_MUL, -0.06)
GM:AddSkillModifier(SKILL_ORPHICFOCUS, SKILLMOD_AIMSPREAD_MUL, -0.02)

GM:AddSkillModifier(SKILL_DELIBRATION, SKILLMOD_AIMSPREAD_MUL, -0.01)

GM:AddSkillModifier(SKILL_WOOISM, SKILLMOD_IRONSIGHT_EFF_MUL, -0.25)

GM:AddSkillModifier(SKILL_GLUTTON, SKILLMOD_HEALTH, -5)

GM:AddSkillModifier(SKILL_TANKER, SKILLMOD_HEALTH, 20)
GM:AddSkillModifier(SKILL_TANKER, SKILLMOD_SPEED, -15)

GM:AddSkillModifier(SKILL_ULTRANIMBLE, SKILLMOD_HEALTH, -20)
GM:AddSkillModifier(SKILL_ULTRANIMBLE, SKILLMOD_SPEED, 15)

GM:AddSkillModifier(SKILL_EGOCENTRIC, SKILLMOD_SELF_DAMAGE_MUL, -0.35)
GM:AddSkillModifier(SKILL_EGOCENTRIC, SKILLMOD_HEALTH, -5)

GM:AddSkillModifier(SKILL_BLASTPROOF, SKILLMOD_SELF_DAMAGE_MUL, -0.45)
GM:AddSkillModifier(SKILL_BLASTPROOF, SKILLMOD_RELOADSPEED_MUL, -0.07)
GM:AddSkillModifier(SKILL_BLASTPROOF, SKILLMOD_DEPLOYSPEED_MUL, -0.12)

GM:AddSkillModifier(SKILL_SURGEON1, SKILLMOD_MEDKIT_COOLDOWN_MUL, -0.08)
GM:AddSkillModifier(SKILL_SURGEON2, SKILLMOD_MEDKIT_COOLDOWN_MUL, -0.09)
GM:AddSkillModifier(SKILL_SURGEON3, SKILLMOD_MEDKIT_COOLDOWN_MUL, -0.10)
GM:AddSkillModifier(SKILL_SURGEONIV, SKILLMOD_MEDKIT_COOLDOWN_MUL, -0.11)

GM:AddSkillModifier(SKILL_BIOLOGYI, SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, 0.08)
GM:AddSkillModifier(SKILL_BIOLOGYII, SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, 0.09)
GM:AddSkillModifier(SKILL_BIOLOGYIII, SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, 0.1)
GM:AddSkillModifier(SKILL_BIOLOGYIV, SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, 0.11)

GM:AddSkillModifier(SKILL_HANDY1, SKILLMOD_REPAIRRATE_MUL, 0.04)
GM:AddSkillModifier(SKILL_HANDY2, SKILLMOD_REPAIRRATE_MUL, 0.05)
GM:AddSkillModifier(SKILL_HANDY3, SKILLMOD_REPAIRRATE_MUL, 0.06)
GM:AddSkillModifier(SKILL_HANDY4, SKILLMOD_REPAIRRATE_MUL, 0.07)
GM:AddSkillModifier(SKILL_HANDY5, SKILLMOD_REPAIRRATE_MUL, 0.08)

GM:AddSkillModifier(SKILL_D_SLOW, SKILLMOD_WORTH, 15)
GM:AddSkillModifier(SKILL_D_SLOW, SKILLMOD_ENDWAVE_POINTS, 1)
GM:AddSkillModifier(SKILL_D_SLOW, SKILLMOD_SPEED, -33.75)

GM:AddSkillModifier(SKILL_GOURMET, SKILLMOD_FOODEATTIME_MUL, 2.0)
GM:AddSkillModifier(SKILL_GOURMET, SKILLMOD_FOODRECOVERY_MUL, 1.0)

GM:AddSkillModifier(SKILL_SUGARRUSH, SKILLMOD_FOODRECOVERY_MUL, -0.35)

GM:AddSkillModifier(SKILL_BATTLER1, SKILLMOD_MELEE_DAMAGE_MUL, 0.04)
GM:AddSkillModifier(SKILL_BATTLER2, SKILLMOD_MELEE_DAMAGE_MUL, 0.05)
GM:AddSkillModifier(SKILL_BATTLER3, SKILLMOD_MELEE_DAMAGE_MUL, 0.05)
GM:AddSkillModifier(SKILL_BATTLER4, SKILLMOD_MELEE_DAMAGE_MUL, 0.06)
GM:AddSkillModifier(SKILL_BATTLER5, SKILLMOD_MELEE_DAMAGE_MUL, 0.07)

GM:AddSkillModifier(SKILL_JOUSTER, SKILLMOD_MELEE_DAMAGE_MUL, 0.1)
GM:AddSkillModifier(SKILL_JOUSTER, SKILLMOD_MELEE_KNOCKBACK_MUL, -1.0)

GM:AddSkillModifier(SKILL_QUICKDRAW, SKILLMOD_DEPLOYSPEED_MUL, 0.65)
GM:AddSkillModifier(SKILL_QUICKDRAW, SKILLMOD_RELOADSPEED_MUL, -0.15)

GM:AddSkillModifier(SKILL_QUICKRELOAD, SKILLMOD_RELOADSPEED_MUL, 0.10)
GM:AddSkillModifier(SKILL_QUICKRELOAD, SKILLMOD_DEPLOYSPEED_MUL, -0.25)

GM:AddSkillModifier(SKILL_SLEIGHTOFHAND, SKILLMOD_RELOADSPEED_MUL, 0.10)
GM:AddSkillModifier(SKILL_SLEIGHTOFHAND, SKILLMOD_AIMSPREAD_MUL, 0.05)

GM:AddSkillModifier(SKILL_TRIGGER_DISCIPLINE1, SKILLMOD_RELOADSPEED_MUL, 0.02)
GM:AddSkillModifier(SKILL_TRIGGER_DISCIPLINE1, SKILLMOD_DEPLOYSPEED_MUL, 0.02)

GM:AddSkillModifier(SKILL_TRIGGER_DISCIPLINE2, SKILLMOD_RELOADSPEED_MUL, 0.03)
GM:AddSkillModifier(SKILL_TRIGGER_DISCIPLINE2, SKILLMOD_DEPLOYSPEED_MUL, 0.03)

GM:AddSkillModifier(SKILL_TRIGGER_DISCIPLINE3, SKILLMOD_RELOADSPEED_MUL, 0.04)
GM:AddSkillModifier(SKILL_TRIGGER_DISCIPLINE3, SKILLMOD_DEPLOYSPEED_MUL, 0.04)

GM:AddSkillModifier(SKILL_PHASER, SKILLMOD_BARRICADE_PHASE_SPEED_MUL, 0.15)
GM:AddSkillModifier(SKILL_PHASER, SKILLMOD_SIGIL_TELEPORT_MUL, 0.15)

GM:AddSkillModifier(SKILL_DRIFT, SKILLMOD_BARRICADE_PHASE_SPEED_MUL, 0.05)

GM:AddSkillModifier(SKILL_WARP, SKILLMOD_SIGIL_TELEPORT_MUL, -0.05)

GM:AddSkillModifier(SKILL_HAMMERDISCIPLINE, SKILLMOD_HAMMER_SWING_DELAY_MUL, -0.2)
GM:AddSkillModifier(SKILL_BARRICADEEXPERT, SKILLMOD_HAMMER_SWING_DELAY_MUL, 0.3)

GM:AddSkillModifier(SKILL_SAFEFALL, SKILLMOD_FALLDAMAGE_DAMAGE_MUL, -0.4)
GM:AddSkillModifier(SKILL_SAFEFALL, SKILLMOD_FALLDAMAGE_RECOVERY_MUL, -0.5)
GM:AddSkillModifier(SKILL_SAFEFALL, SKILLMOD_FALLDAMAGE_SLOWDOWN_MUL, 0.4)

GM:AddSkillModifier(SKILL_BACKPEDDLER, SKILLMOD_SPEED, -7)
GM:AddSkillFunction(SKILL_BACKPEDDLER, function(pl, active)
	pl.NoBWSpeedPenalty = active
end)

GM:AddSkillModifier(SKILL_D_CLUMSY, SKILLMOD_WORTH, 20)
GM:AddSkillModifier(SKILL_D_CLUMSY, SKILLMOD_POINTS, 5)
GM:AddSkillFunction(SKILL_D_CLUMSY, function(pl, active)
	pl.IsClumsy = active
end)

GM:AddSkillModifier(SKILL_D_NOODLEARMS, SKILLMOD_WORTH, 5)
GM:AddSkillModifier(SKILL_D_NOODLEARMS, SKILLMOD_SCRAP_START, 1)
GM:AddSkillFunction(SKILL_D_NOODLEARMS, function(pl, active)
	pl.NoObjectPickup = active
end)

GM:AddSkillModifier(SKILL_D_PALSY, SKILLMOD_WORTH, 10)
GM:AddSkillModifier(SKILL_D_PALSY, SKILLMOD_RESUPPLY_DELAY_MUL, -0.03)
GM:AddSkillFunction(SKILL_D_PALSY, function(pl, active)
	pl.HasPalsy = active
end)

GM:AddSkillModifier(SKILL_D_HEMOPHILIA, SKILLMOD_WORTH, 10)
GM:AddSkillModifier(SKILL_D_HEMOPHILIA, SKILLMOD_SCRAP_START, 3)
GM:AddSkillFunction(SKILL_D_HEMOPHILIA, function(pl, active)
	pl.HasHemophilia = active
end)

GM:AddSkillModifier(SKILL_D_LATEBUYER, SKILLMOD_WORTH, 20)
GM:AddSkillModifier(SKILL_D_LATEBUYER, SKILLMOD_ARSENAL_DISCOUNT, -0.02)

GM:AddSkillFunction(SKILL_TAUT, function(pl, active)
	pl.BuffTaut = active
end)

GM:AddSkillModifier(SKILL_BLOODARMOR, SKILLMOD_HEALTH, -13)

GM:AddSkillModifier(SKILL_HAEMOSTASIS, SKILLMOD_BLOODARMOR_DMG_REDUCTION, -0.25)

GM:AddSkillModifier(SKILL_REGENERATOR, SKILLMOD_HEALTH, -6)

GM:AddSkillModifier(SKILL_D_WEAKNESS, SKILLMOD_WORTH, 15)
GM:AddSkillModifier(SKILL_D_WEAKNESS, SKILLMOD_ENDWAVE_POINTS, 1)
GM:AddSkillModifier(SKILL_D_WEAKNESS, SKILLMOD_HEALTH, -45)

GM:AddSkillModifier(SKILL_D_WIDELOAD, SKILLMOD_WORTH, 20)
GM:AddSkillModifier(SKILL_D_WIDELOAD, SKILLMOD_RESUPPLY_DELAY_MUL, -0.05)
GM:AddSkillFunction(SKILL_D_WIDELOAD, function(pl, active)
	pl.NoGhosting = active
end)

GM:AddSkillFunction(SKILL_WOOISM, function(pl, active)
	pl.Wooism = active
end)

GM:AddSkillFunction(SKILL_ORPHICFOCUS, function(pl, active)
	pl.Orphic = active
end)

GM:AddSkillModifier(SKILL_WORTHINESS1, SKILLMOD_WORTH, 5)
GM:AddSkillModifier(SKILL_WORTHINESS2, SKILLMOD_WORTH, 5)
GM:AddSkillModifier(SKILL_WORTHINESS3, SKILLMOD_WORTH, 5)
GM:AddSkillModifier(SKILL_WORTHINESS4, SKILLMOD_WORTH, 5)

GM:AddSkillModifier(SKILL_KNUCKLEMASTER, SKILLMOD_UNARMED_SWING_DELAY_MUL, 0.35)
GM:AddSkillModifier(SKILL_KNUCKLEMASTER, SKILLMOD_UNARMED_DAMAGE_MUL, 0.75)

GM:AddSkillModifier(SKILL_CRITICALKNUCKLE, SKILLMOD_UNARMED_DAMAGE_MUL, -0.25)
GM:AddSkillModifier(SKILL_CRITICALKNUCKLE, SKILLMOD_UNARMED_SWING_DELAY_MUL, 0.25)

GM:AddSkillModifier(SKILL_SMARTTARGETING, SKILLMOD_MEDGUN_FIRE_DELAY_MUL, 0.75)
GM:AddSkillModifier(SKILL_SMARTTARGETING, SKILLMOD_MEDDART_EFFECTIVENESS_MUL, -0.3)

GM:AddSkillModifier(SKILL_RECLAIMSOL, SKILLMOD_MEDGUN_FIRE_DELAY_MUL, 1.5)
GM:AddSkillModifier(SKILL_RECLAIMSOL, SKILLMOD_MEDGUN_RELOAD_SPEED_MUL, -0.4)

GM:AddSkillModifier(SKILL_LANKY, SKILLMOD_MELEE_DAMAGE_MUL, -0.15)
GM:AddSkillModifier(SKILL_LANKY, SKILLMOD_MELEE_RANGE_MUL, 0.1)

GM:AddSkillModifier(SKILL_LANKYII, SKILLMOD_MELEE_DAMAGE_MUL, -0.15)
GM:AddSkillModifier(SKILL_LANKYII, SKILLMOD_MELEE_RANGE_MUL, 0.1)

GM:AddSkillModifier(SKILL_D_FRAIL, SKILLMOD_WORTH, 20)
GM:AddSkillModifier(SKILL_D_FRAIL, SKILLMOD_POINTS, 5)
GM:AddSkillFunction(SKILL_D_FRAIL, function(pl, active)
	pl:SetDTBool(DT_PLAYER_BOOL_FRAIL, active)
end)

GM:AddSkillModifier(SKILL_MASTERCHEF, SKILLMOD_MELEE_DAMAGE_MUL, -0.10)

GM:AddSkillModifier(SKILL_LIGHTWEIGHT, SKILLMOD_MELEE_DAMAGE_MUL, -0.2)

GM:AddSkillModifier(SKILL_AGILEI, SKILLMOD_JUMPPOWER_MUL, 0.04)
GM:AddSkillModifier(SKILL_AGILEI, SKILLMOD_SPEED, -2)

GM:AddSkillModifier(SKILL_AGILEII, SKILLMOD_JUMPPOWER_MUL, 0.05)
GM:AddSkillModifier(SKILL_AGILEII, SKILLMOD_SPEED, -3)

GM:AddSkillModifier(SKILL_AGILEIII, SKILLMOD_JUMPPOWER_MUL, 0.06)
GM:AddSkillModifier(SKILL_AGILEIII, SKILLMOD_SPEED, -4)

GM:AddSkillModifier(SKILL_SOFTDET, SKILLMOD_EXP_DAMAGE_RADIUS, -0.10)
GM:AddSkillModifier(SKILL_SOFTDET, SKILLMOD_EXP_DAMAGE_TAKEN_MUL, -0.4)

GM:AddSkillModifier(SKILL_IRONBLOOD, SKILLMOD_BLOODARMOR_DMG_REDUCTION, 0.25)
GM:AddSkillModifier(SKILL_IRONBLOOD, SKILLMOD_BLOODARMOR_MUL, -0.5)

GM:AddSkillModifier(SKILL_BLOODLETTER, SKILLMOD_BLOODARMOR_GAIN_MUL, 1)

GM:AddSkillModifier(SKILL_SURESTEP, SKILLMOD_SPEED, -4)
GM:AddSkillModifier(SKILL_SURESTEP, SKILLMOD_SLOW_EFF_TAKEN_MUL, -0.35)

GM:AddSkillModifier(SKILL_INTREPID, SKILLMOD_SPEED, -4)
GM:AddSkillModifier(SKILL_INTREPID, SKILLMOD_LOW_HEALTH_SLOW_MUL, -0.35)

GM:AddSkillModifier(SKILL_UNBOUND, SKILLMOD_SPEED, -4)

GM:AddSkillModifier(SKILL_CHEAPKNUCKLE, SKILLMOD_MELEE_RANGE_MUL, -0.1)

GM:AddSkillModifier(SKILL_HEAVYSTRIKES, SKILLMOD_MELEE_KNOCKBACK_MUL, 1)

GM:AddSkillModifier(SKILL_CANNONBALL, SKILLMOD_PROJ_SPEED, -0.25)
GM:AddSkillModifier(SKILL_CANNONBALL, SKILLMOD_PROJECTILE_DAMAGE_MUL, 0.03)

GM:AddSkillModifier(SKILL_CONEFFECT, SKILLMOD_EXP_DAMAGE_RADIUS, -0.2)
GM:AddSkillModifier(SKILL_CONEFFECT, SKILLMOD_EXP_DAMAGE_MUL, 0.05)

GM:AddSkillModifier(SKILL_CARDIOTONIC, SKILLMOD_SPEED, -12)
GM:AddSkillModifier(SKILL_CARDIOTONIC, SKILLMOD_BLOODARMOR_DMG_REDUCTION, -0.2)

GM:AddSkillFunction(SKILL_SCOURER, function(pl, active)
	pl.Scourer = active
end)

GM:AddSkillModifier(SKILL_DISPERSION, SKILLMOD_CLOUD_RADIUS, 0.15)
GM:AddSkillModifier(SKILL_DISPERSION, SKILLMOD_CLOUD_TIME, -0.1)

GM:AddSkillModifier(SKILL_BRASH, SKILLMOD_MELEE_SWING_DELAY_MUL, -0.16)
GM:AddSkillModifier(SKILL_BRASH, SKILLMOD_MELEE_MOVEMENTSPEED_ON_KILL, -15)

GM:AddSkillModifier(SKILL_CIRCULATION, SKILLMOD_BLOODARMOR, 1)

GM:AddSkillModifier(SKILL_SANGUINE, SKILLMOD_BLOODARMOR, 11)
GM:AddSkillModifier(SKILL_SANGUINE, SKILLMOD_HEALTH, -9)

GM:AddSkillModifier(SKILL_ANTIGEN, SKILLMOD_BLOODARMOR_DMG_REDUCTION, 0.05)
GM:AddSkillModifier(SKILL_ANTIGEN, SKILLMOD_HEALTH, -3)

GM:AddSkillModifier(SKILL_INSTRUMENTS, SKILLMOD_TURRET_RANGE_MUL, 0.05)

GM:AddSkillModifier(SKILL_LEVELHEADED, SKILLMOD_AIM_SHAKE_MUL, -0.05)

GM:AddSkillModifier(SKILL_ROBUST, SKILLMOD_WEAPON_WEIGHT_SLOW_MUL, -0.06)

GM:AddSkillModifier(SKILL_TAUT, SKILLMOD_PROP_CARRY_SLOW_MUL, 0.4)

GM:AddSkillModifier(SKILL_TURRETOVERLOAD, SKILLMOD_TURRET_RANGE_MUL, -0.3)

GM:AddSkillModifier(SKILL_STOWAGE, SKILLMOD_RESUPPLY_DELAY_MUL, 0.15)
GM:AddSkillFunction(SKILL_STOWAGE, function(pl, active)
	pl.Stowage = active
end)

GM:AddSkillFunction(SKILL_TRUEWOOISM, function(pl, active)
	pl.TrueWooism = active
end)
