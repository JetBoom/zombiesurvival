GM.Skills = {}
GM.SkillModifiers = {}
GM.SkillFunctions = {}
GM.SkillModifierFunctions = {}

function GM:AddSkill(id, name, description, x, y, connections, tree)
	local skill = {Connections = table.ToAssoc(connections or {})}

	if CLIENT then
		skill.x = x
		skill.y = y

 -- TODO: Dynamic skill descriptions based on modifiers on the skill.

		skill.Description = description
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

-- Use this after all skills have been added. It assigns dynamic IDs!
function GM:AddTrinket(name, swepaffix, pairedweapon, veles, weles, tier, description, status, stocks)
	local skill = {Connections = {}}

	skill.Name = name
	skill.Trinket = swepaffix
	skill.Status = status

	local datatab = {PrintName = name, DroppedEles = weles, Tier = tier, Description = description, Status = status, Stocks = stocks}

	if pairedweapon then
		skill.PairedWeapon = "weapon_zs_t_" .. swepaffix
	end

	self.ZSInventoryItemData["trinket_" .. swepaffix] = datatab
	self.Skills[#self.Skills + 1] = skill

	return #self.Skills, self.ZSInventoryItemData["trinket_" .. swepaffix]
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
TREE_TORMENTTREE = 7
TREE_REMORTTREE = 8

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
SKILL_MOTION1 = 17
SKILL_BACKPEDDLER = 18
SKILL_PHASER = 19
SKILL_LOADEDHULL = 20
SKILL_REINFORCEDHULL = 21
SKILL_REINFORCEDBLADES = 22
SKILL_AVIATOR = 23
SKILL_U_BLASTTURRET = 24
SKILL_TURRETLOCK = 25
SKILL_TWINVOLLEY = 26
SKILL_TURRETOVERLOAD = 27
SKILL_U_DRONE = 28
SKILL_U_NANITECLOUD = 29
SKILL_HAMMERDISCIPLINE1 = 30
SKILL_FIELDAMP = 31
SKILL_U_ROLLERMINE = 32
SKILL_HAULMODULE = 33
SKILL_LIGHTCONSTRUCT = 34
SKILL_TRIGGER_DISCIPLINE1 = 35
SKILL_TRIGGER_DISCIPLINE2 = 36
SKILL_TRIGGER_DISCIPLINE3 = 37
SKILL_D_PALSY = 38
SKILL_QUICKDRAW = 39
SKILL_FOCUS1 = 40
SKILL_QUICKRELOAD = 41
SKILL_WORTHINESS1 = 42
SKILL_WORTHINESS2 = 43
SKILL_EGOCENTRIC = 44
SKILL_VITALITY2 = 45
SKILL_WOOISM = 46
SKILL_D_HEMOPHILIA = 47
SKILL_BATTLER1 = 48
SKILL_BATTLER2 = 49
SKILL_BATTLER3 = 50
SKILL_BATTLER4 = 51
SKILL_BATTLER5 = 52
SKILL_HEAVYSTRIKES = 53
SKILL_LASTSTAND = 54
SKILL_D_NOODLEARMS = 55
SKILL_GLASSWEAPONS = 56
SKILL_CANNONBALL = 57
SKILL_D_CLUMSY = 58
SKILL_CHEAPKNUCKLE = 59
SKILL_CRITICALKNUCKLE = 60
SKILL_KNUCKLEMASTER = 61
SKILL_COMBOKNUCKLE = 62
SKILL_D_LATEBUYER = 63
SKILL_U_CRAFTINGPACK = 64
SKILL_VITALITY1 = 66
SKILL_JOUSTER1 = 65
SKILL_SCAVENGER = 67
SKILL_U_ZAPPER_ARC = 68
SKILL_TAUT = 69
SKILL_ULTRANIMBLE = 70
SKILL_D_FRAIL = 71
SKILL_U_MEDICCLOUD = 72
SKILL_SMARTTARGETING = 73
SKILL_INSIGHT = 74
SKILL_GLUTTON = 75
SKILL_GOURMET = 76
SKILL_BARRICADEEXPERT = 77
SKILL_WORTHINESS3 = 78
SKILL_BLOODARMOR = 79
SKILL_REGENERATOR = 80
SKILL_D_WEAKNESS = 81
SKILL_PREPAREDNESS = 82
SKILL_SAFEFALL = 83
SKILL_VITALITY3 = 84
SKILL_D_WIDELOAD = 85
SKILL_TANKER = 86
SKILL_U_CORRUPTEDFRAGMENT = 87
SKILL_WORTHINESS4 = 88
SKILL_FORAGER = 89
SKILL_LANKY1 = 90
SKILL_PITCHER = 91
SKILL_BLASTPROOF = 92
SKILL_MASTERCHEF = 93
SKILL_SUGARRUSH = 94
SKILL_U_STRENGTHSHOT = 95
SKILL_STABLEHULL = 96
SKILL_LIGHTWEIGHT = 97
SKILL_AGILE1 = 98
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
SKILL_AGILE2 = 111
SKILL_AGILE3 = 112
SKILL_BIOLOGY1 = 113
SKILL_BIOLOGY2 = 114
SKILL_BIOLOGY3 = 115
SKILL_FOCUS2 = 116
SKILL_FOCUS3 = 117
SKILL_EQUIPPED = 118
SKILL_SURESTEP = 119
SKILL_INTREPID = 120
SKILL_CARDIOTONIC = 121
SKILL_BLOODLUST = 122
SKILL_SCOURER = 123
SKILL_LANKY2 = 124
SKILL_U_ANTITODESHOT = 125
SKILL_DISPERSION = 126
SKILL_MOTION2 = 127
SKILL_MOTION3 = 128
SKILL_D_SLOW = 129
SKILL_BRASH = 130
SKILL_CONEFFECT = 131
SKILL_CIRCULATION = 132
SKILL_SANGUINE1 = 133
SKILL_ANTIGEN = 134
SKILL_INSTRUMENTS = 135
SKILL_HANDY4 = 136
SKILL_HANDY5 = 137
SKILL_TECHNICIAN = 138
SKILL_BIOLOGY4 = 139
SKILL_SURGEON4 = 140
SKILL_DELIBRATION = 141
SKILL_DRIFT = 142
SKILL_WARP = 143
SKILL_LEVELHEADED = 144
SKILL_ROBUST = 145
SKILL_STOWAGE = 146
SKILL_TRUEWOOISM = 147
SKILL_UNBOUND = 148

-- Custom skills
SKILL_SANGUINE2 = 149
SKILL_VITALITY4 = 150
SKILL_MOTION4 = 151
SKILL_BATTLER6 = 152
SKILL_HANDY6 = 153
SKILL_HAMMERDISCIPLINE2 = 154
SKILL_TORMENT1 = 155
SKILL_TORMENT2 = 156
SKILL_TORMENT3 = 157
SKILL_TORMENT4 = 158
SKILL_TORMENT5 = 159
SKILL_JUMPER = 160
SKILL_UNCORRUPTOR = 161
SKILL_TORMENT6 = 162
SKILL_TORMENT7 = 163
SKILL_TORMENT8 = 164
SKILL_TORMENT9 = 165
SKILL_TORMENT10 = 166
SKILL_LANKY3 = 167
SKILL_POINTFULNESS1 = 168
SKILL_POINTFULNESS2 = 169
SKILL_POINTFULNESS3 = 170
SKILL_POINTFULNESS4 = 171
SKILL_JOUSTER2 = 172
SKILL_SIGILDEFENDER1 = 173
SKILL_FISTER = 174
SKILL_CARRIER = 175
SKILL_U_DOOMSTICK = 176
SKILL_SIGILDEFENDER2 = 177
SKILL_SIGILDEFENDER3 = 178
SKILL_SIGILDEFENDER4 = 179
SKILL_GUNSLINGER = 180
SKILL_D_FRAGILITY = 181



SKILLMOD_HEALTH = 1
SKILLMOD_BLOODARMOR = 2
SKILLMOD_SPEED = 3
SKILLMOD_WORTH = 4
SKILLMOD_MELEE_DAMAGE_MUL = 5
SKILLMOD_MELEE_RANGE_MUL = 6
SKILLMOD_MELEE_RANGE_ADD = 7
SKILLMOD_MELEE_KNOCKBACK_MUL = 8
SKILLMOD_MELEE_SWING_DELAY_MUL = 9
SKILLMOD_MELEE_ATTACK_DELAY_MUL = 10
SKILLMOD_MELEE_DAMAGE_TO_BLOODARMOR_MUL = 11
SKILLMOD_MELEE_MOVEMENTSPEED_ON_KILL = 12
SKILLMOD_MELEE_POWERATTACK_MUL = 13
SKILLMOD_MELEE_LEG_DAMAGE_ADD = 14
SKILLMOD_MELEE_DAMAGE_TAKEN_MUL = 15
SKILLMOD_POISON_DAMAGE_TAKEN_MUL = 16
SKILLMOD_BLEED_DAMAGE_TAKEN_MUL = 17
SKILLMOD_EXP_DAMAGE_TAKEN_MUL = 18
SKILLMOD_FIRE_DAMAGE_TAKEN_MUL = 19
SKILLMOD_PHYSICS_DAMAGE_TAKEN_MUL = 20
SKILLMOD_PROJECTILE_DAMAGE_TAKEN_MUL = 21
SKILLMOD_MELEE_ATTACKER_DMG_REFLECT_PERCENT = 22
SKILLMOD_MELEE_ATTACKER_DMG_REFLECT = 23
SKILLMOD_BLOODARMOR_DMG_REDUCTION = 24
SKILLMOD_BLOODARMOR_MUL = 25
SKILLMOD_BLOODARMOR_GAIN_MUL = 26
SKILLMOD_JUMPPOWER_MUL = 27
SKILLMOD_BULLET_DAMAGE_MUL = 28
SKILLMOD_WEAPON_FIREDELAY_MUL = 29
SKILLMOD_RELOADSPEED_MUL = 30
SKILLMOD_DEPLOYSPEED_MUL = 31
SKILLMOD_AIMSPREAD_MUL = 32
SKILLMOD_SLOW_EFF_TAKEN_MUL = 33
SKILLMOD_WEAPON_WEIGHT_SLOW_MUL = 34
SKILLMOD_LOW_HEALTH_SLOW_MUL = 35
SKILLMOD_FALLDAMAGE_DAMAGE_MUL = 36
SKILLMOD_FALLDAMAGE_THRESHOLD_MUL = 37
SKILLMOD_FALLDAMAGE_RECOVERY_MUL = 38
SKILLMOD_FALLDAMAGE_SLOWDOWN_MUL = 39
SKILLMOD_FOODRECOVERY_MUL = 40
SKILLMOD_FOODEATTIME_MUL = 41
SKILLMOD_UNARMED_DAMAGE_MUL = 42
SKILLMOD_UNARMED_SWING_DELAY_MUL = 43
SKILLMOD_HAMMER_SWING_DELAY_MUL = 44
SKILLMOD_CONTROLLABLE_HEALTH_MUL = 45
SKILLMOD_CONTROLLABLE_SPEED_MUL = 46
SKILLMOD_CONTROLLABLE_HANDLING_MUL = 47
SKILLMOD_MANHACK_DAMAGE_MUL = 48
SKILLMOD_MANHACK_HEALTH_MUL = 49
SKILLMOD_BARRICADE_PHASE_SPEED_MUL = 50
SKILLMOD_MEDKIT_COOLDOWN_MUL = 51
SKILLMOD_MEDKIT_EFFECTIVENESS_MUL = 52
SKILLMOD_REPAIRRATE_MUL = 53
SKILLMOD_TURRET_HEALTH_MUL = 54
SKILLMOD_TURRET_SCANSPEED_MUL = 55
SKILLMOD_TURRET_SCANANGLE_MUL = 56
SKILLMOD_SELF_DAMAGE_MUL = 57
SKILLMOD_POINTS = 58
SKILLMOD_POINT_MULTIPLIER = 59
SKILLMOD_XP_MULTI = 60
SKILLMOD_DEPLOYABLE_HEALTH_MUL = 61
SKILLMOD_DEPLOYABLE_PACKTIME_MUL = 62
SKILLMOD_DRONE_SPEED_MUL = 63
SKILLMOD_DRONE_CARRYMASS_MUL = 64
SKILLMOD_DRONE_GUN_RANGE_MUL = 65
SKILLMOD_MEDGUN_FIRE_DELAY_MUL = 66
SKILLMOD_RESUPPLY_DELAY_MUL = 67
SKILLMOD_FIELD_RANGE_MUL = 68
SKILLMOD_FIELD_DELAY_MUL = 69
SKILLMOD_HEALING_RECEIVED = 70
SKILLMOD_PULSE_WEAPON_SLOW_MUL = 71
SKILLMOD_KNOCKDOWN_RECOVERY_MUL = 72
SKILLMOD_PROP_CARRY_CAPACITY_MASS_MUL = 73
SKILLMOD_PROP_CARRY_CAPACITY_VOLUME_MUL = 74
SKILLMOD_PROP_CARRY_SLOW_MUL = 75
SKILLMOD_PROP_THROW_STRENGTH_MUL = 76
SKILLMOD_VISION_ALTER_DURATION_MUL = 77
SKILLMOD_DIMVISION_EFF_MUL = 78
SKILLMOD_BLEED_SPEED_MUL = 79
SKILLMOD_POISON_SPEED_MUL = 80
SKILLMOD_SIGIL_TELEPORT_MUL = 81
SKILLMOD_EXP_DAMAGE_RADIUS = 82
SKILLMOD_MEDGUN_RELOAD_SPEED_MUL = 83
SKILLMOD_FRIGHT_DURATION_MUL = 84
SKILLMOD_IRONSIGHT_EFF_MUL = 85
SKILLMOD_PROJ_SPEED = 86
SKILLMOD_SCRAP_START = 87
SKILLMOD_ENDWAVE_POINTS = 88
SKILLMOD_ARSENAL_DISCOUNT = 89
SKILLMOD_CLOUD_RADIUS = 90
SKILLMOD_CLOUD_TIME = 91
SKILLMOD_PROJECTILE_DAMAGE_MUL = 92
SKILLMOD_EXP_DAMAGE_MUL = 93
SKILLMOD_TURRET_RANGE_MUL = 94
SKILLMOD_AIM_SHAKE_MUL = 95
SKILLMOD_MEDDART_EFFECTIVENESS_MUL = 96
SKILLMOD_RELOADSPEED_PISTOL_MUL = 97
SKILLMOD_RELOADSPEED_SMG_MUL = 98
SKILLMOD_RELOADSPEED_ASSAULT_MUL = 99
SKILLMOD_RELOADSPEED_SHELL_MUL = 100
SKILLMOD_RELOADSPEED_RIFLE_MUL = 101
SKILLMOD_RELOADSPEED_XBOW_MUL = 102
SKILLMOD_RELOADSPEED_PULSE_MUL = 103
SKILLMOD_RELOADSPEED_EXP_MUL = 104

-- These are only used to check in Character stats and Skills (beta)
GM.SkillModifiersNonMulOnly = {
	SKILLMOD_HEALTH, SKILLMOD_BLOODARMOR, SKILLMOD_SPEED, SKILLMOD_WORTH, SKILLMOD_POINTS, SKILLMOD_MELEE_ATTACKER_DMG_REFLECT, SKILLMOD_MELEE_MOVEMENTSPEED_ON_KILL,
	SKILLMOD_MELEE_LEG_DAMAGE_ADD, SKILLMOD_SCRAP_START, SKILLMOD_ENDWAVE_POINTS, SKILLMOD_MELEE_RANGE_ADD,
}

GM.SkillModifiersBadOnly = {
	SKILLMOD_FALLDAMAGE_DAMAGE_MUL, SKILLMOD_FALLDAMAGE_SLOWDOWN_MUL, SKILLMOD_FALLDAMAGE_RECOVERY_MUL, SKILLMOD_FOODEATTIME_MUL, SKILLMOD_UNARMED_SWING_DELAY_MUL, SKILLMOD_HAMMER_SWING_DELAY_MUL,
	SKILLMOD_MEDKIT_COOLDOWN_MUL, SKILLMOD_SELF_DAMAGE_MUL, SKILLMOD_AIMSPREAD_MUL, SKILLMOD_DEPLOYABLE_PACKTIME_MUL, SKILLMOD_MEDGUN_FIRE_DELAY_MUL,
	SKILLMOD_RESUPPLY_DELAY_MUL, SKILLMOD_FIELD_DELAY_MUL, SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, SKILLMOD_POISON_DAMAGE_TAKEN_MUL, SKILLMOD_BLEED_DAMAGE_TAKEN_MUL,
	SKILLMOD_MELEE_SWING_DELAY_MUL, SKILLMOD_MELEE_ATTACK_DELAY_MUL, SKILLMOD_KNOCKDOWN_RECOVERY_MUL, SKILLMOD_SLOW_EFF_TAKEN_MUL, SKILLMOD_EXP_DAMAGE_TAKEN_MUL, SKILLMOD_FIRE_DAMAGE_TAKEN_MUL,
	SKILLMOD_PHYSICS_DAMAGE_TAKEN_MUL, SKILLMOD_VISION_ALTER_DURATION_MUL, SKILLMOD_DIMVISION_EFF_MUL, SKILLMOD_PROP_CARRY_SLOW_MUL, SKILLMOD_BLEED_SPEED_MUL,
	SKILLMOD_SIGIL_TELEPORT_MUL, SKILLMOD_POISON_SPEED_MUL, SKILLMOD_PROJECTILE_DAMAGE_TAKEN_MUL, SKILLMOD_WEAPON_WEIGHT_SLOW_MUL, SKILLMOD_FRIGHT_DURATION_MUL,
	SKILLMOD_IRONSIGHT_EFF_MUL, SKILLMOD_LOW_HEALTH_SLOW_MUL, SKILLMOD_ARSENAL_DISCOUNT, SKILLMOD_AIM_SHAKE_MUL, SKILLMOD_WEAPON_FIREDELAY_MUL,
}


local VERYGOOD = "^"..COLORID_CYAN
local GOOD = "^"..COLORID_GREEN
local NEUTRAL = "^"..COLORID_YELLOW
local BAD = "^"..COLORID_RED
local VERYBAD = "^"..COLORID_RED


-- Health Tree
local s = GM:AddSkill(SKILL_STOIC1, "Stoic I", GOOD.."+1 maximum health\n"..BAD.."-0.75 movement speed",
-4, -6, {SKILL_NONE, SKILL_STOIC2}, TREE_HEALTHTREE)
s.CanUseInZE = true
s.CanUseInClassicMode = true
GM:AddSkillModifier(SKILL_STOIC1, SKILLMOD_HEALTH, 1)
GM:AddSkillModifier(SKILL_STOIC1, SKILLMOD_SPEED, -0.75)

s = GM:AddSkill(SKILL_STOIC2, "Stoic II", GOOD.."+2 maximum health\n"..BAD.."-1.5 movement speed",
-4, -4, {SKILL_STOIC3, SKILL_VITALITY1, SKILL_REGENERATOR}, TREE_HEALTHTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_STOIC2, SKILLMOD_HEALTH, 2)
GM:AddSkillModifier(SKILL_STOIC2, SKILLMOD_SPEED, -1.5)

s = GM:AddSkill(SKILL_STOIC3, "Stoic III", GOOD.."+4 maximum health\n"..BAD.."-3 movement speed",
-3, -2, {SKILL_STOIC4}, TREE_HEALTHTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_STOIC3, SKILLMOD_HEALTH, 4)
GM:AddSkillModifier(SKILL_STOIC3, SKILLMOD_SPEED, -3)

s = GM:AddSkill(SKILL_STOIC4, "Stoic IV", GOOD.."+6 maximum health\n"..BAD.."-4.5 movement speed",
-3, 0, {SKILL_STOIC5}, TREE_HEALTHTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_STOIC4, SKILLMOD_HEALTH, 6)
GM:AddSkillModifier(SKILL_STOIC4, SKILLMOD_SPEED, -4.5)

s = GM:AddSkill(SKILL_STOIC5, "Stoic V", GOOD.."+7 maximum health\n"..BAD.."-5.25 movement speed",
-3, 2, {SKILL_BLOODARMOR, SKILL_TANKER}, TREE_HEALTHTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_STOIC5, SKILLMOD_HEALTH, 7)
GM:AddSkillModifier(SKILL_STOIC5, SKILLMOD_SPEED, -5.25)

s = GM:AddSkill(SKILL_D_HEMOPHILIA, "Debuff: Hemophilia", GOOD.."+10 starting Worth\n"..GOOD.."+3 starting scrap\n"..BAD.."Bleed for 25% extra damage when hit\nOnly if damage taken is 4 or more",
4, 2, {}, TREE_HEALTHTREE)
GM:AddSkillModifier(SKILL_D_HEMOPHILIA, SKILLMOD_WORTH, 10)
GM:AddSkillModifier(SKILL_D_HEMOPHILIA, SKILLMOD_SCRAP_START, 3)
GM:AddSkillFunction(SKILL_D_HEMOPHILIA, function(pl, active)
	pl.HasHemophilia = active
end)

s = GM:AddSkill(SKILL_GLUTTON, "Glutton", GOOD.."Gain up to 30 blood armor when you eat food\n"..GOOD.."Blood armor gained can exceed the cap by 40\n"..BAD.."-5 maximum health\n"..BAD.."No longer receive health from eating food",
3, -2, {SKILL_GOURMET, SKILL_BLOODARMOR}, TREE_HEALTHTREE)
GM:AddSkillModifier(SKILL_GLUTTON, SKILLMOD_HEALTH, -5)

s = GM:AddSkill(SKILL_PREPAREDNESS, "Preparedness", GOOD.."Your starting item can be a random food item\n"..BAD.."Has 50% chance to not work when \"Preparedness\" skill is active",
4, -6, {SKILL_NONE}, TREE_HEALTHTREE)

s = GM:AddSkill(SKILL_GOURMET, "Gourmet", GOOD.."+100% recovery from food\n"..BAD.."+200% time to eat food",
4, -4, {SKILL_PREPAREDNESS, SKILL_VITALITY1}, TREE_HEALTHTREE)
GM:AddSkillModifier(SKILL_GOURMET, SKILLMOD_FOODEATTIME_MUL, 2.0)
GM:AddSkillModifier(SKILL_GOURMET, SKILLMOD_FOODRECOVERY_MUL, 1.0)

s = GM:AddSkill(SKILL_HAEMOSTASIS, "Haemostasis", GOOD.."Resist status effects while you have at least 2 blood armor\n"..BAD.."Lose 2 blood armor on resist\n"..BAD.."-20% blood armor damage absorption",
4, 6, {}, TREE_HEALTHTREE)
GM:AddSkillModifier(SKILL_HAEMOSTASIS, SKILLMOD_BLOODARMOR_DMG_REDUCTION, -0.2)

s = GM:AddSkill(SKILL_BLOODLETTER, "Bloodletter", GOOD.."+60% blood armor generated\n"..BAD.."Losing all blood armor inflicts 5 bleed damage",
0, 4, {SKILL_ANTIGEN}, TREE_HEALTHTREE)
GM:AddSkillModifier(SKILL_BLOODLETTER, SKILLMOD_BLOODARMOR_GAIN_MUL, 0.6)

s = GM:AddSkill(SKILL_REGENERATOR, "Regenerator", GOOD.."Regenerate 1 health every 6s when below 60% health\n"..BAD.."-6 maximum health",
-5, -2, {}, TREE_HEALTHTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_REGENERATOR, SKILLMOD_HEALTH, -6)

s = GM:AddSkill(SKILL_BLOODARMOR, "Blood Armor", GOOD.."Regenerate 1 blood armor every 8 seconds upto your blood armor max\nBase blood armor maximum is 20\nBase blood armor damage absorption is 50%\n"..BAD.."-13 maximum health",
2, 2, {SKILL_IRONBLOOD, SKILL_BLOODLETTER, SKILL_D_HEMOPHILIA}, TREE_HEALTHTREE)
GM:AddSkillModifier(SKILL_BLOODARMOR, SKILLMOD_HEALTH, -13)

s = GM:AddSkill(SKILL_IRONBLOOD, "Iron Blood", GOOD.."+25% damage reduction from blood armor\n"..GOOD.."Bonus doubled when health is 50% or less\n"..BAD.."-50% maximum blood armor",
2, 4, {SKILL_HAEMOSTASIS, SKILL_CIRCULATION}, TREE_HEALTHTREE)
GM:AddSkillModifier(SKILL_IRONBLOOD, SKILLMOD_BLOODARMOR_DMG_REDUCTION, 0.25)
GM:AddSkillModifier(SKILL_IRONBLOOD, SKILLMOD_BLOODARMOR_MUL, -0.5)

s = GM:AddSkill(SKILL_D_WEAKNESS, "Debuff: Weakness", GOOD.."+15 starting Worth\n"..GOOD.."+1 end of wave points\n"..BAD.."-45 maximum health",
1, -1, {}, TREE_HEALTHTREE)
GM:AddSkillModifier(SKILL_D_WEAKNESS, SKILLMOD_WORTH, 15)
GM:AddSkillModifier(SKILL_D_WEAKNESS, SKILLMOD_ENDWAVE_POINTS, 1)
GM:AddSkillModifier(SKILL_D_WEAKNESS, SKILLMOD_HEALTH, -45)

s = GM:AddSkill(SKILL_VITALITY1, "Vitality I", GOOD.."+1 maximum health",
0, -4, {SKILL_VITALITY2}, TREE_HEALTHTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_VITALITY1, SKILLMOD_HEALTH, 1)

s = GM:AddSkill(SKILL_VITALITY2, "Vitality II", GOOD.."+1 maximum health",
0, -2, {SKILL_VITALITY3}, TREE_HEALTHTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_VITALITY2, SKILLMOD_HEALTH, 1)

s = GM:AddSkill(SKILL_VITALITY3, "Vitality III", GOOD.."+1 maximum health",
0, 0, {SKILL_VITALITY4, SKILL_D_WEAKNESS}, TREE_HEALTHTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_VITALITY3, SKILLMOD_HEALTH, 1)

s = GM:AddSkill(SKILL_VITALITY4, "Vitality IV", GOOD.."+2 maximum health",
-1, 1, {}, TREE_HEALTHTREE)
s.CanUseInZE = true
s.RemortReq = 2
GM:AddSkillModifier(SKILL_VITALITY4, SKILLMOD_HEALTH, 2)

s = GM:AddSkill(SKILL_TANKER, "Tanker", GOOD.."+20 maximum health\n"..BAD.."-15 movement speed",
-5, 4, {}, TREE_HEALTHTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_TANKER, SKILLMOD_HEALTH, 20)
GM:AddSkillModifier(SKILL_TANKER, SKILLMOD_SPEED, -15)

s = GM:AddSkill(SKILL_FORAGER, "Forager", GOOD.."25% chance to collect food from resupply boxes\n"..BAD.."+20% resupply box delay",
5, -2, {SKILL_GOURMET}, TREE_HEALTHTREE)
GM:AddSkillModifier(SKILL_FORAGER, SKILLMOD_RESUPPLY_DELAY_MUL, 0.2)

s = GM:AddSkill(SKILL_SUGARRUSH, "Sugar Rush", GOOD.."+35 speed boost from food for 14 seconds\n"..BAD.."-35% recovery from food\n",
4, 0, {SKILL_GOURMET}, TREE_HEALTHTREE)
GM:AddSkillModifier(SKILL_SUGARRUSH, SKILLMOD_FOODRECOVERY_MUL, -0.35)

s = GM:AddSkill(SKILL_CIRCULATION, "Circulation", GOOD.."+1 maximum blood armor",
4, 4, {SKILL_SANGUINE1}, TREE_HEALTHTREE)
GM:AddSkillModifier(SKILL_CIRCULATION, SKILLMOD_BLOODARMOR, 1)

s = GM:AddSkill(SKILL_SANGUINE1, "Sanguine I", GOOD.."+11 maximum blood armor\n"..BAD.."-9 maximum health",
6, 2, {SKILL_SANGUINE2}, TREE_HEALTHTREE)
GM:AddSkillModifier(SKILL_SANGUINE1, SKILLMOD_BLOODARMOR, 11)
GM:AddSkillModifier(SKILL_SANGUINE1, SKILLMOD_HEALTH, -9)

s = GM:AddSkill(SKILL_SANGUINE2, "Sanguine II", GOOD.."+18 maximum blood armor\n"..BAD.."-15 maximum health",
6, 3.5, {}, TREE_HEALTHTREE)
GM:AddSkillModifier(SKILL_SANGUINE2, SKILLMOD_BLOODARMOR, 18)
GM:AddSkillModifier(SKILL_SANGUINE2, SKILLMOD_HEALTH, -15)

s = GM:AddSkill(SKILL_ANTIGEN, "Antigen", GOOD.."+5% blood armor damage absorption\n"..BAD.."-3 maximum health",
-2, 4, {}, TREE_HEALTHTREE)
GM:AddSkillModifier(SKILL_ANTIGEN, SKILLMOD_BLOODARMOR_DMG_REDUCTION, 0.05)
GM:AddSkillModifier(SKILL_ANTIGEN, SKILLMOD_HEALTH, -3)

-- Speed Tree

s = GM:AddSkill(SKILL_SPEED1, "Speed I", GOOD.."+0.75 movement speed\n"..BAD.."-1 maximum health",
-4, 6, {SKILL_NONE, SKILL_SPEED2}, TREE_SPEEDTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_SPEED1, SKILLMOD_SPEED, 0.75)
GM:AddSkillModifier(SKILL_SPEED1, SKILLMOD_HEALTH, -1)

s = GM:AddSkill(SKILL_SPEED2, "Speed II", GOOD.."+1.5 movement speed\n"..BAD.."-2 maximum health",
-4, 4, {SKILL_SPEED3, SKILL_PHASER, SKILL_SPEED2, SKILL_U_CORRUPTEDFRAGMENT}, TREE_SPEEDTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_SPEED2, SKILLMOD_SPEED, 1.5)
GM:AddSkillModifier(SKILL_SPEED2, SKILLMOD_HEALTH, -2)

s = GM:AddSkill(SKILL_SPEED3, "Speed III", GOOD.."+3 movement speed\n"..BAD.."-4 maximum health",
-4, 2, {SKILL_SPEED4}, TREE_SPEEDTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_SPEED3, SKILLMOD_SPEED, 3)
GM:AddSkillModifier(SKILL_SPEED3, SKILLMOD_HEALTH, -4)

s = GM:AddSkill(SKILL_SPEED4, "Speed IV", GOOD.."+4.5 movement speed\n"..BAD.."-6 maximum health",
-4, 0, {SKILL_SPEED5, SKILL_SAFEFALL}, TREE_SPEEDTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_SPEED4, SKILLMOD_SPEED, 4.5)
GM:AddSkillModifier(SKILL_SPEED4, SKILLMOD_HEALTH, -6)

s = GM:AddSkill(SKILL_SPEED5, "Speed V", GOOD.."+5.25 movement speed\n"..BAD.."-7 maximum health",
-4, -2, {SKILL_ULTRANIMBLE, SKILL_BACKPEDDLER, SKILL_MOTION1, SKILL_CARDIOTONIC, SKILL_UNBOUND}, TREE_SPEEDTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_SPEED5, SKILLMOD_SPEED, 5.25)
GM:AddSkillModifier(SKILL_SPEED5, SKILLMOD_HEALTH, -7)

s = GM:AddSkill(SKILL_AGILE1, "Agile I", GOOD.."+3% jumping power\n"..BAD.."-1.5 movement speed",
4, 6, {SKILL_NONE, SKILL_AGILE2}, TREE_SPEEDTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_AGILE1, SKILLMOD_JUMPPOWER_MUL, 0.03)
GM:AddSkillModifier(SKILL_AGILE1, SKILLMOD_SPEED, -1.5)

s = GM:AddSkill(SKILL_AGILE2, "Agile II", GOOD.."+4% jumping power\n"..BAD.."-2 movement speed",
4, 2, {SKILL_AGILE3, SKILL_WORTHINESS3}, TREE_SPEEDTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_AGILE2, SKILLMOD_JUMPPOWER_MUL, 0.04)
GM:AddSkillModifier(SKILL_AGILE2, SKILLMOD_SPEED, -2)

s = GM:AddSkill(SKILL_AGILE3, "Agile III", GOOD.."+5% jumping power\n"..BAD.."-2.5 movement speed",
4, -2, {SKILL_SAFEFALL, SKILL_ULTRANIMBLE, SKILL_SURESTEP, SKILL_INTREPID, SKILL_JUMPER}, TREE_SPEEDTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_AGILE3, SKILLMOD_JUMPPOWER_MUL, 0.05)
GM:AddSkillModifier(SKILL_AGILE3, SKILLMOD_SPEED, -2.5)

s = GM:AddSkill(SKILL_JUMPER, "Jumper", GOOD.."+1% jumping power",
4, -4, {}, TREE_SPEEDTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_JUMPER, SKILLMOD_JUMPPOWER_MUL, 0.01)

s = GM:AddSkill(SKILL_D_SLOW, "Debuff: Slow", GOOD.."+15 starting Worth\n"..GOOD.."+1 end of wave points\n"..BAD.."-33.75 movement speed",
0, -4, {}, TREE_SPEEDTREE)
GM:AddSkillModifier(SKILL_D_SLOW, SKILLMOD_WORTH, 15)
GM:AddSkillModifier(SKILL_D_SLOW, SKILLMOD_ENDWAVE_POINTS, 1)
GM:AddSkillModifier(SKILL_D_SLOW, SKILLMOD_SPEED, -33.75)

s = GM:AddSkill(SKILL_MOTION1, "Motion I", GOOD.."+0.75 movement speed",
-2, -2, {SKILL_MOTION2}, TREE_SPEEDTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_MOTION1, SKILLMOD_SPEED, 0.75)

s = GM:AddSkill(SKILL_MOTION2, "Motion II", GOOD.."+0.75 movement speed",
-1, -1, {SKILL_MOTION3}, TREE_SPEEDTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_MOTION2, SKILLMOD_SPEED, 0.75)

s = GM:AddSkill(SKILL_MOTION3, "Motion III", GOOD.."+0.75 movement speed",
0, -2, {SKILL_MOTION4, SKILL_D_SLOW}, TREE_SPEEDTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_MOTION3, SKILLMOD_SPEED, 0.75)

s = GM:AddSkill(SKILL_MOTION4, "Motion IV", GOOD.."+1.5 movement speed",
1, -3, {}, TREE_SPEEDTREE)
s.CanUseInZE = true
s.RemortReq = 2
GM:AddSkillModifier(SKILL_MOTION4, SKILLMOD_SPEED, 1.5)

s = GM:AddSkill(SKILL_BACKPEDDLER, "Backpeddler", GOOD.."Move the same speed in all directions\n"..BAD.."-6.75 movement speed\n"..BAD.."Receive leg damage on any melee hit",
-6, 0, {}, TREE_SPEEDTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_BACKPEDDLER, SKILLMOD_SPEED, -6.75)
GM:AddSkillFunction(SKILL_BACKPEDDLER, function(pl, active)
	pl.NoBWSpeedPenalty = active
end)

s = GM:AddSkill(SKILL_PHASER, "Phaser", GOOD.."+15% barricade phasing movement speed\n"..BAD.."+15% sigil teleportation time",
-1, 4, {SKILL_D_WIDELOAD, SKILL_DRIFT}, TREE_SPEEDTREE)
GM:AddSkillModifier(SKILL_PHASER, SKILLMOD_BARRICADE_PHASE_SPEED_MUL, 0.15)
GM:AddSkillModifier(SKILL_PHASER, SKILLMOD_SIGIL_TELEPORT_MUL, 0.15)

s = GM:AddSkill(SKILL_DRIFT, "Drift", GOOD.."+5% barricade phasing movement speed",
1, 3, {SKILL_WARP}, TREE_SPEEDTREE)
s.CanUseInClassicMode = true
GM:AddSkillModifier(SKILL_DRIFT, SKILLMOD_BARRICADE_PHASE_SPEED_MUL, 0.05)

s = GM:AddSkill(SKILL_WARP, "Warp", GOOD.."-5% sigil teleportation time",
2, 2, {}, TREE_SPEEDTREE)
GM:AddSkillModifier(SKILL_WARP, SKILLMOD_SIGIL_TELEPORT_MUL, -0.05)

s = GM:AddSkill(SKILL_SAFEFALL, "Safe Fall", GOOD.."-25% fall damage taken\n"..GOOD.."-30% fall damage knockdown duration\n"..BAD.."+45% slow down from landing or fall damage",
0, 0, {}, TREE_SPEEDTREE)
GM:AddSkillModifier(SKILL_SAFEFALL, SKILLMOD_FALLDAMAGE_DAMAGE_MUL, -0.25)
GM:AddSkillModifier(SKILL_SAFEFALL, SKILLMOD_FALLDAMAGE_RECOVERY_MUL, -0.3)
GM:AddSkillModifier(SKILL_SAFEFALL, SKILLMOD_FALLDAMAGE_SLOWDOWN_MUL, 0.45)

s = GM:AddSkill(SKILL_D_WIDELOAD, "Debuff: Wide Load", GOOD.."+20 starting Worth\n"..GOOD.."-5% resupply delay\n"..BAD.."Phasing speed limited to 1 for the first 6 seconds of phasing",
1, 1, {}, TREE_SPEEDTREE)
GM:AddSkillModifier(SKILL_D_WIDELOAD, SKILLMOD_WORTH, 20)
GM:AddSkillModifier(SKILL_D_WIDELOAD, SKILLMOD_RESUPPLY_DELAY_MUL, -0.05)
GM:AddSkillFunction(SKILL_D_WIDELOAD, function(pl, active)
	pl.NoGhosting = active
end)

s = GM:AddSkill(SKILL_U_CORRUPTEDFRAGMENT, "Unlock: Corrupted Fragment", GOOD.."Unlocks purchasing the Corrupted Fragment\nGoes to corrupted sigils instead",
-2, 2, {}, TREE_SPEEDTREE)
s.AlwaysActive = true

s = GM:AddSkill(SKILL_ULTRANIMBLE, "Ultra Nimble", GOOD.."+15 movement speed\n"..BAD.."-20 maximum health",
0, -6, {}, TREE_SPEEDTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_ULTRANIMBLE, SKILLMOD_HEALTH, -20)
GM:AddSkillModifier(SKILL_ULTRANIMBLE, SKILLMOD_SPEED, 15)

s = GM:AddSkill(SKILL_WORTHINESS3, "Worthiness III", GOOD.."+5 starting worth\n"..BAD.."-3 starting points",
6, 2, {SKILL_POINTFULNESS3}, TREE_SPEEDTREE)
GM:AddSkillModifier(SKILL_WORTHINESS3, SKILLMOD_WORTH, 5)
GM:AddSkillModifier(SKILL_WORTHINESS3, SKILLMOD_POINTS, -3)

s = GM:AddSkill(SKILL_POINTFULNESS3, "Pointfulness III", GOOD.."+3 starting points\n"..GOOD.."+1% point gain multiplier\n"..BAD.."-10 starting worth",
7, 3, {}, TREE_SPEEDTREE)
GM:AddSkillModifier(SKILL_POINTFULNESS3, SKILLMOD_WORTH, -10)
GM:AddSkillModifier(SKILL_POINTFULNESS3, SKILLMOD_POINTS, 3)
GM:AddSkillModifier(SKILL_POINTFULNESS3, SKILLMOD_POINT_MULTIPLIER, 0.01)

s = GM:AddSkill(SKILL_SURESTEP, "Sure Step", GOOD.."-30% effectiveness of slows\n"..BAD.."-4.5 movement speed",
6, 0, {}, TREE_SPEEDTREE)
GM:AddSkillModifier(SKILL_SURESTEP, SKILLMOD_SPEED, -4.5)
GM:AddSkillModifier(SKILL_SURESTEP, SKILLMOD_SLOW_EFF_TAKEN_MUL, -0.35)

s = GM:AddSkill(SKILL_INTREPID, "Intrepid", GOOD.."-35% low health slow intensity\n"..BAD.."-4.5 movement speed",
6, -4, {SKILL_ROBUST}, TREE_SPEEDTREE)
GM:AddSkillModifier(SKILL_INTREPID, SKILLMOD_SPEED, -4.5)
GM:AddSkillModifier(SKILL_INTREPID, SKILLMOD_LOW_HEALTH_SLOW_MUL, -0.35)

s = GM:AddSkill(SKILL_ROBUST, "Robust", GOOD.."-6% movement speed reduction with heavy weapons",
5, -5, {}, TREE_SPEEDTREE)
GM:AddSkillModifier(SKILL_ROBUST, SKILLMOD_WEAPON_WEIGHT_SLOW_MUL, -0.06)

s = GM:AddSkill(SKILL_CARDIOTONIC, "Cardiotonic", GOOD.."Hold shift to run whilst draining blood armor\n"..BAD.."-12 movement speed\n"..BAD.."-20% blood armor damage absorption\nSprinting grants +40 move speed",
-6, -4, {}, TREE_SPEEDTREE)
GM:AddSkillModifier(SKILL_CARDIOTONIC, SKILLMOD_SPEED, -12)
GM:AddSkillModifier(SKILL_CARDIOTONIC, SKILLMOD_BLOODARMOR_DMG_REDUCTION, -0.2)

s = GM:AddSkill(SKILL_UNBOUND, "Unbound", GOOD.."-60% reduced delay from switching weapons affecting movement speed\n"..BAD.."-4 movement speed",
-4, -4, {}, TREE_SPEEDTREE)
GM:AddSkillModifier(SKILL_UNBOUND, SKILLMOD_SPEED, -4.5)

-- Medic Tree

s = GM:AddSkill(SKILL_SURGEON1, "Surgeon I", GOOD.."-6% medical kit cooldown",
-4, 6, {SKILL_NONE, SKILL_SURGEON2}, TREE_SUPPORTTREE)
GM:AddSkillModifier(SKILL_SURGEON1, SKILLMOD_MEDKIT_COOLDOWN_MUL, -0.06)

s = GM:AddSkill(SKILL_SURGEON2, "Surgeon II", GOOD.."-7% medical kit cooldown",
-3, 3, {SKILL_WORTHINESS4, SKILL_SURGEON3}, TREE_SUPPORTTREE)
GM:AddSkillModifier(SKILL_SURGEON2, SKILLMOD_MEDKIT_COOLDOWN_MUL, -0.07)

s = GM:AddSkill(SKILL_SURGEON3, "Surgeon III", GOOD.."-8% medical kit cooldown",
-2, 0, {SKILL_U_MEDICCLOUD, SKILL_D_FRAIL, SKILL_SURGEON4}, TREE_SUPPORTTREE)
GM:AddSkillModifier(SKILL_SURGEON3, SKILLMOD_MEDKIT_COOLDOWN_MUL, -0.08)

s = GM:AddSkill(SKILL_SURGEON4, "Surgeon IV", GOOD.."-10% medical kit cooldown",
-2, -3, {}, TREE_SUPPORTTREE)
GM:AddSkillModifier(SKILL_SURGEON4, SKILLMOD_MEDKIT_COOLDOWN_MUL, -0.10)

s = GM:AddSkill(SKILL_BIOLOGY1, "Biology I", GOOD.."+6% medic tool effectiveness",
4, 6, {SKILL_NONE, SKILL_BIOLOGY2}, TREE_SUPPORTTREE)
GM:AddSkillModifier(SKILL_BIOLOGY1, SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, 0.06)

s = GM:AddSkill(SKILL_BIOLOGY2, "Biology II", GOOD.."+7% medic tool effectiveness",
3, 3, {SKILL_BIOLOGY3, SKILL_SMARTTARGETING}, TREE_SUPPORTTREE)
GM:AddSkillModifier(SKILL_BIOLOGY2, SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, 0.07)

s = GM:AddSkill(SKILL_BIOLOGY3, "Biology III", GOOD.."+8% medic tool effectiveness",
2, 0, {SKILL_U_MEDICCLOUD, SKILL_U_ANTITODESHOT, SKILL_BIOLOGY4}, TREE_SUPPORTTREE)
GM:AddSkillModifier(SKILL_BIOLOGY3, SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, 0.08)

s = GM:AddSkill(SKILL_BIOLOGY4, "Biology IV", GOOD.."+10% medic tool effectiveness",
2, -3, {}, TREE_SUPPORTTREE)
GM:AddSkillModifier(SKILL_BIOLOGY4, SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, 0.10)

s = GM:AddSkill(SKILL_D_FRAIL, "Debuff: Frail", GOOD.."+20 starting Worth\n"..GOOD.."+5 starting points\n"..BAD.."Cannot be healed above 25% health",
-4, -2, {}, TREE_SUPPORTTREE)
GM:AddSkillModifier(SKILL_D_FRAIL, SKILLMOD_WORTH, 20)
GM:AddSkillModifier(SKILL_D_FRAIL, SKILLMOD_POINTS, 5)
GM:AddSkillFunction(SKILL_D_FRAIL, function(pl, active)
	pl:SetDTBool(DT_PLAYER_BOOL_FRAIL, active)
end)

s = GM:AddSkill(SKILL_U_MEDICCLOUD, "Unlock: Medic Cloud Bomb", GOOD.."Unlocks purchasing the Medic Cloud Bomb\nSlowly heals all humans inside the cloud",
0, -2, {SKILL_DISPERSION}, TREE_SUPPORTTREE)
s.AlwaysActive = true

s = GM:AddSkill(SKILL_SMARTTARGETING, "Smart Targeting", GOOD.."Medical weapon darts lock onto targets with right click\n"..BAD.."+75% medic tool fire delay\n"..BAD.."-20% healing effectiveness on medical darts",
0, 2, {}, TREE_SUPPORTTREE)
GM:AddSkillModifier(SKILL_SMARTTARGETING, SKILLMOD_MEDGUN_FIRE_DELAY_MUL, 0.75)
GM:AddSkillModifier(SKILL_SMARTTARGETING, SKILLMOD_MEDDART_EFFECTIVENESS_MUL, -0.2)

s = GM:AddSkill(SKILL_RECLAIMSOL, "Recoverable Solution", GOOD.."60% of wasted medical dart ammo is returned to you\n"..BAD.."+150% medic tool fire delay\n"..BAD.."-40% medic tool reload speed\n"..BAD.."Cannot speed boost full health players",
0, 4, {SKILL_SMARTTARGETING}, TREE_SUPPORTTREE)
GM:AddSkillModifier(SKILL_RECLAIMSOL, SKILLMOD_MEDGUN_FIRE_DELAY_MUL, 1.5)
GM:AddSkillModifier(SKILL_RECLAIMSOL, SKILLMOD_MEDGUN_RELOAD_SPEED_MUL, -0.4)

s = GM:AddSkill(SKILL_U_STRENGTHSHOT, "Unlock: Strength Shot Gun", GOOD.."Unlocks purchasing the Strength Shot Gun\nTarget damage +25% for 10 seconds\nExtra damage is given to you as points\nTarget is not healed",
0, 0, {SKILL_SMARTTARGETING}, TREE_SUPPORTTREE)
s.AlwaysActive = true

s = GM:AddSkill(SKILL_WORTHINESS4, "Worthiness IV", GOOD.."+5 starting worth\n"..BAD.."-3 starting points",
-5, 2, {SKILL_POINTFULNESS4}, TREE_SUPPORTTREE)
GM:AddSkillModifier(SKILL_WORTHINESS4, SKILLMOD_WORTH, 5)
GM:AddSkillModifier(SKILL_WORTHINESS4, SKILLMOD_POINTS, -3)

s = GM:AddSkill(SKILL_POINTFULNESS4, "Pointfulness IV", GOOD.."+3 starting points\n"..GOOD.."+1% point gain multiplier\n"..BAD.."-10 starting worth",
-6, 1, {}, TREE_SUPPORTTREE)
GM:AddSkillModifier(SKILL_POINTFULNESS4, SKILLMOD_WORTH, -10)
GM:AddSkillModifier(SKILL_POINTFULNESS4, SKILLMOD_POINTS, 3)
GM:AddSkillModifier(SKILL_POINTFULNESS4, SKILLMOD_POINT_MULTIPLIER, 0.01)

s = GM:AddSkill(SKILL_U_ANTITODESHOT, "Unlock: Antidote Handgun", GOOD.."Unlocks purchasing the Antidote Handgun\nFires piercing blasts that heal poison greatly\nCleanses statuses from targets with a small point gain\nDoes not heal health",
4, -2, {}, TREE_SUPPORTTREE)
s.AlwaysActive = true

s = GM:AddSkill(SKILL_DISPERSION, "Dispersion", GOOD.."+15% cloud bomb radius\n"..BAD.."-10% cloud bomb time",
0, -4, {}, TREE_SUPPORTTREE)
GM:AddSkillModifier(SKILL_DISPERSION, SKILLMOD_CLOUD_RADIUS, 0.15)
GM:AddSkillModifier(SKILL_DISPERSION, SKILLMOD_CLOUD_TIME, -0.1)

-- Defence Tree

s = GM:AddSkill(SKILL_HANDY1, "Handy I", GOOD.."+3% repair rate",
-5, -6, {SKILL_NONE, SKILL_HANDY2}, TREE_BUILDINGTREE)
GM:AddSkillModifier(SKILL_HANDY1, SKILLMOD_REPAIRRATE_MUL, 0.03)

s = GM:AddSkill(SKILL_HANDY2, "Handy II", GOOD.."+4% repair rate",
-5, -4, {SKILL_HANDY3, SKILL_U_BLASTTURRET, SKILL_LOADEDHULL}, TREE_BUILDINGTREE)
GM:AddSkillModifier(SKILL_HANDY2, SKILLMOD_REPAIRRATE_MUL, 0.04)

s = GM:AddSkill(SKILL_HANDY3, "Handy III", GOOD.."+4% repair rate",
-5, -1, {SKILL_TAUT, SKILL_HAMMERDISCIPLINE1, SKILL_D_NOODLEARMS, SKILL_HANDY4}, TREE_BUILDINGTREE)
GM:AddSkillModifier(SKILL_HANDY3, SKILLMOD_REPAIRRATE_MUL, 0.04)

s = GM:AddSkill(SKILL_HANDY4, "Handy IV", GOOD.."+5% repair rate",
-3, 1, {SKILL_HANDY5}, TREE_BUILDINGTREE)
GM:AddSkillModifier(SKILL_HANDY4, SKILLMOD_REPAIRRATE_MUL, 0.05)

s = GM:AddSkill(SKILL_HANDY5, "Handy V", GOOD.."+6% repair rate",
-3, 3, {SKILL_HANDY6}, TREE_BUILDINGTREE)
GM:AddSkillModifier(SKILL_HANDY5, SKILLMOD_REPAIRRATE_MUL, 0.06)

s = GM:AddSkill(SKILL_HANDY6, "Handy VI", GOOD.."+7% repair rate",
-2.5, 4.5, {}, TREE_BUILDINGTREE)
GM:AddSkillModifier(SKILL_HANDY6, SKILLMOD_REPAIRRATE_MUL, 0.07)

s = GM:AddSkill(SKILL_HAMMERDISCIPLINE1, "Hammer Discipline I", GOOD.."-10% hammer swing delay\n"..BAD.."-8% repair rate",
0, 1, {SKILL_BARRICADEEXPERT, SKILL_HAMMERDISCIPLINE2}, TREE_BUILDINGTREE)
GM:AddSkillModifier(SKILL_HAMMERDISCIPLINE1, SKILLMOD_HAMMER_SWING_DELAY_MUL, -0.1)
GM:AddSkillModifier(SKILL_HAMMERDISCIPLINE1, SKILLMOD_REPAIRRATE_MUL, -0.08)

s = GM:AddSkill(SKILL_HAMMERDISCIPLINE2, "Hammer Discipline II", GOOD.."-15% hammer swing delay\n"..BAD.."-12% repair rate",
0, 0, {SKILL_BARRICADEEXPERT}, TREE_BUILDINGTREE)
GM:AddSkillModifier(SKILL_HAMMERDISCIPLINE2, SKILLMOD_HAMMER_SWING_DELAY_MUL, -0.15)
GM:AddSkillModifier(SKILL_HAMMERDISCIPLINE2, SKILLMOD_REPAIRRATE_MUL, -0.12)

s = GM:AddSkill(SKILL_BARRICADEEXPERT, "Reinforcer", GOOD.."Gives 8% damage protection for props that were hit with a hammer for 2.5 seconds\n"..GOOD.."Gain points from protected props\n"..BAD.."+30% hammer swing delay\nElectrohammer gives prop buff for 3 seconds",
0, 3, {}, TREE_BUILDINGTREE)
GM:AddSkillModifier(SKILL_BARRICADEEXPERT, SKILLMOD_HAMMER_SWING_DELAY_MUL, 0.3)

s = GM:AddSkill(SKILL_LOADEDHULL, "Loaded Hull", GOOD.."Controllables explode when destroyed, dealing explosive damage\n"..BAD.."-10% Controllable health",
-2, -4, {SKILL_REINFORCEDHULL, SKILL_REINFORCEDBLADES, SKILL_AVIATOR}, TREE_BUILDINGTREE)
GM:AddSkillModifier(SKILL_LOADEDHULL, SKILLMOD_CONTROLLABLE_HEALTH_MUL, -0.1)

s = GM:AddSkill(SKILL_REINFORCEDHULL, "Reinforced Hull", GOOD.."+25% Controllable health\n"..BAD.."-20% Controllable handling\n"..BAD.."-20% Controllable speed",
-2, -2, {SKILL_STABLEHULL}, TREE_BUILDINGTREE)
GM:AddSkillModifier(SKILL_REINFORCEDHULL, SKILLMOD_CONTROLLABLE_HEALTH_MUL, 0.25)
GM:AddSkillModifier(SKILL_REINFORCEDHULL, SKILLMOD_CONTROLLABLE_HANDLING_MUL, -0.2)
GM:AddSkillModifier(SKILL_REINFORCEDHULL, SKILLMOD_CONTROLLABLE_SPEED_MUL, -0.2)

s = GM:AddSkill(SKILL_STABLEHULL, "Stable Hull", GOOD.."Controllables are immune to high speed impacts\n"..BAD.."-20% Controllable speed",
0, -3, {SKILL_U_DRONE}, TREE_BUILDINGTREE)
GM:AddSkillModifier(SKILL_STABLEHULL, SKILLMOD_CONTROLLABLE_SPEED_MUL, -0.2)

s = GM:AddSkill(SKILL_REINFORCEDBLADES, "Reinforced Blades", GOOD.."+25% Manhack damage\n"..BAD.."-15% Manhack health",
0, -5, {}, TREE_BUILDINGTREE)
GM:AddSkillModifier(SKILL_REINFORCEDBLADES, SKILLMOD_MANHACK_DAMAGE_MUL, 0.25)
GM:AddSkillModifier(SKILL_REINFORCEDBLADES, SKILLMOD_MANHACK_HEALTH_MUL, -0.15)

s = GM:AddSkill(SKILL_AVIATOR, "Aviator", GOOD.."+30% Controllable speed and handling\n"..BAD.."-25% Controllable health",
-4, -2, {}, TREE_BUILDINGTREE)
GM:AddSkillModifier(SKILL_AVIATOR, SKILLMOD_CONTROLLABLE_SPEED_MUL, 0.3)
GM:AddSkillModifier(SKILL_AVIATOR, SKILLMOD_CONTROLLABLE_HANDLING_MUL, 0.3)
GM:AddSkillModifier(SKILL_AVIATOR, SKILLMOD_CONTROLLABLE_HEALTH_MUL, -0.25)

s = GM:AddSkill(SKILL_U_BLASTTURRET, "Unlock: Blast Turret", GOOD.."Unlocks purchasing the Blast Turret\nFires buckshot instead of SMG ammo\nDamage is higher close up\nCannot scan for targets far away",
-8, -4, {SKILL_TURRETLOCK, SKILL_TWINVOLLEY, SKILL_TURRETOVERLOAD}, TREE_BUILDINGTREE)
s.AlwaysActive = true

s = GM:AddSkill(SKILL_TURRETLOCK, "Turret Lock", "-90% turret scan angle\n"..BAD.."-90% turret target lock angle",
-6, -2, {}, TREE_BUILDINGTREE)
GM:AddSkillModifier(SKILL_TURRETLOCK, SKILLMOD_TURRET_SCANANGLE_MUL, -0.9)

s = GM:AddSkill(SKILL_TWINVOLLEY, "Twin Volley", GOOD.."Fire twice as many bullets in manual turret mode\n"..BAD.."+100% turret ammo usage in manual turret mode\n"..BAD.."+50% turret fire delay in manual turret mode",
-10, -5, {}, TREE_BUILDINGTREE)

s = GM:AddSkill(SKILL_TURRETOVERLOAD, "Turret Overload", GOOD.." +100% Turret scan speed\n"..BAD.."-30% Turret range",
-8, -2, {SKILL_INSTRUMENTS}, TREE_BUILDINGTREE)
GM:AddSkillModifier(SKILL_TURRETOVERLOAD, SKILLMOD_TURRET_RANGE_MUL, -0.3)
GM:AddSkillModifier(SKILL_TURRETOVERLOAD, SKILLMOD_TURRET_SCANSPEED_MUL, 1.0)

s = GM:AddSkill(SKILL_U_DRONE, "Unlock: Pulse Drone", GOOD.."Unlocks the Pulse Drone Variant\nFires short range pulse projectiles instead of bullets",
2, -3, {SKILL_HAULMODULE, SKILL_U_ROLLERMINE}, TREE_BUILDINGTREE)
s.AlwaysActive = true

s = GM:AddSkill(SKILL_U_NANITECLOUD, "Unlock: Nanite Cloud Bomb", GOOD.."Unlocks purchasing the Nanite Cloud Bomb\nSlowly repairs all props and deployables inside the cloud",
3, 1, {SKILL_HAMMERDISCIPLINE1}, TREE_BUILDINGTREE)
s.AlwaysActive = true

s = GM:AddSkill(SKILL_FIELDAMP, "Field Amplifier", GOOD.."-20% zapper and repair field delay\n"..BAD.."-40% zapper and repair field range",
6, 4, {}, TREE_BUILDINGTREE)
GM:AddSkillModifier(SKILL_FIELDAMP, SKILLMOD_FIELD_RANGE_MUL, -0.4)
GM:AddSkillModifier(SKILL_FIELDAMP, SKILLMOD_FIELD_DELAY_MUL, -0.2)

s = GM:AddSkill(SKILL_TECHNICIAN, "Field Technician", GOOD.." +3% zapper and repair field range\n"..GOOD.."-3% zapper and repair field delay",
4, 3, {}, TREE_BUILDINGTREE)
GM:AddSkillModifier(SKILL_TECHNICIAN, SKILLMOD_FIELD_RANGE_MUL, 0.03)
GM:AddSkillModifier(SKILL_TECHNICIAN, SKILLMOD_FIELD_DELAY_MUL, -0.03)

s = GM:AddSkill(SKILL_U_ROLLERMINE, "Unlock: Rollermine", GOOD.."Unlocks purchasing Rollermines\nRolls along the ground, shocking zombies and dealing damage",
3, -5, {}, TREE_BUILDINGTREE)
s.AlwaysActive = true

s = GM:AddSkill(SKILL_HAULMODULE, "Unlock: Hauling Drone", GOOD.."Unlocks the Hauling Drone\nRapidly transports props and items but cannot attack",
2, -1, {SKILL_U_NANITECLOUD}, TREE_BUILDINGTREE)
s.AlwaysActive = true

s = GM:AddSkill(SKILL_LIGHTCONSTRUCT, "Light Construction", GOOD.."-25% deployable pack time\n"..BAD.."-25% deployable health",
8, -1, {SKILL_CARRIER}, TREE_BUILDINGTREE)
GM:AddSkillModifier(SKILL_LIGHTCONSTRUCT, SKILLMOD_DEPLOYABLE_HEALTH_MUL, -0.25)
GM:AddSkillModifier(SKILL_LIGHTCONSTRUCT, SKILLMOD_DEPLOYABLE_PACKTIME_MUL, -0.25)

s = GM:AddSkill(SKILL_CARRIER, "Carrier", GOOD.."-5% prop carrying slow down",
9, -2, {}, TREE_BUILDINGTREE)
GM:AddSkillModifier(SKILL_CARRIER, SKILLMOD_PROP_CARRY_SLOW_MUL, -0.05)

s = GM:AddSkill(SKILL_STOCKPILE, "Stockpiling", GOOD.."Collect twice as much from resupplies\n"..BAD.."2.06x resupply box delay",
8, -3, {}, TREE_BUILDINGTREE)

s = GM:AddSkill(SKILL_ACUITY, "Supplier's Acuity", GOOD.."Locate nearby resupply boxes if behind walls\n"..GOOD.."Locate nearby unplaced resupply boxes on players through walls\n"..GOOD.."Locate nearby resupply packs through walls",
6, -3, {SKILL_INSIGHT, SKILL_STOCKPILE, SKILL_U_CRAFTINGPACK, SKILL_STOWAGE}, TREE_BUILDINGTREE)

s = GM:AddSkill(SKILL_VISION, "Refiner's Vision", GOOD.."Locate nearby remantlers if behind walls\n"..GOOD.."Locate nearby unplaced remantlers on players through walls",
6, -6, {SKILL_NONE, SKILL_ACUITY}, TREE_BUILDINGTREE)

s = GM:AddSkill(SKILL_U_ROCKETTURRET, "Unlock: Rocket Turret", GOOD.."Unlocks purchasing the Rocket Turret\nFires explosives instead of SMG ammo\nDeals damage in a radius\nHigh tier deployable",
-8, -0, {SKILL_TURRETOVERLOAD}, TREE_BUILDINGTREE)
s.AlwaysActive = true

s = GM:AddSkill(SKILL_INSIGHT, "Buyer's Insight", GOOD.."Locate nearby arsenal crates if behind walls\n"..GOOD.."Locate nearby unplaced arsenal crates on players through walls\n"..GOOD.."Locate nearby arsenal packs through walls",
6, -0, {SKILL_U_NANITECLOUD, SKILL_U_ZAPPER_ARC, SKILL_LIGHTCONSTRUCT, SKILL_D_LATEBUYER}, TREE_BUILDINGTREE)
s.AlwaysActive = true

s = GM:AddSkill(SKILL_U_ZAPPER_ARC, "Unlock: Arc Zapper", GOOD.."Unlocks purchasing the Arc Zapper\nZaps zombies that get nearby, and jumps in an arc\nMid tier deployable and long cooldown\nRequires a steady upkeep of pulse ammo",
6, 2, {SKILL_FIELDAMP, SKILL_TECHNICIAN}, TREE_BUILDINGTREE)
s.AlwaysActive = true

s = GM:AddSkill(SKILL_D_LATEBUYER, "Debuff: Late Buyer", GOOD.."+20 starting Worth\n"..GOOD.."-2% resupply delay\n"..GOOD.."-3% arsenal items cost\n"..BAD.."Unable to use points at arsenal crates until the second half of the round",
8, 1, {}, TREE_BUILDINGTREE)
GM:AddSkillModifier(SKILL_D_LATEBUYER, SKILLMOD_WORTH, 20)
GM:AddSkillModifier(SKILL_D_LATEBUYER, SKILLMOD_RESUPPLY_DELAY_MUL, -0.02)
GM:AddSkillModifier(SKILL_D_LATEBUYER, SKILLMOD_ARSENAL_DISCOUNT, -0.03)

s = GM:AddSkill(SKILL_U_CRAFTINGPACK, "Unlock: Crafting Pack", GOOD.."Unlocks purchasing the Sawblade component\n"..GOOD.."Unlocks purchasing the Electrobattery component\n"..GOOD.."Unlocks purchasing the CPU Parts component",
4, -1, {}, TREE_BUILDINGTREE)
s.AlwaysActive = true

s = GM:AddSkill(SKILL_TAUT, "Taut", GOOD.."Damage does not make you drop props\n"..BAD.."+45% prop carrying slow down",
-5, 3, {}, TREE_BUILDINGTREE)
GM:AddSkillModifier(SKILL_TAUT, SKILLMOD_PROP_CARRY_SLOW_MUL, 0.45)
GM:AddSkillFunction(SKILL_TAUT, function(pl, active)
	pl.BuffTaut = active
end)

s = GM:AddSkill(SKILL_D_NOODLEARMS, "Debuff: Noodle Arms", GOOD.."+5 starting Worth\n"..GOOD.."+1 starting scrap\n"..BAD.."-90% prop carrying weight limit\n"..BAD.."-75% prop carrying volume limit\n"..BAD.."-60% object throwing strength",
-7, 2, {}, TREE_BUILDINGTREE)
GM:AddSkillModifier(SKILL_D_NOODLEARMS, SKILLMOD_WORTH, 5)
GM:AddSkillModifier(SKILL_D_NOODLEARMS, SKILLMOD_SCRAP_START, 1)
GM:AddSkillModifier(SKILL_D_NOODLEARMS, SKILLMOD_PROP_CARRY_CAPACITY_MASS_MUL, -0.9)
GM:AddSkillModifier(SKILL_D_NOODLEARMS, SKILLMOD_PROP_CARRY_CAPACITY_VOLUME_MUL, -0.75)
GM:AddSkillModifier(SKILL_D_NOODLEARMS, SKILLMOD_PROP_THROW_STRENGTH_MUL, -0.6)
/*
GM:AddSkillFunction(SKILL_D_NOODLEARMS, function(pl, active)
	pl.NoObjectPickup = active
end)
*/

s = GM:AddSkill(SKILL_INSTRUMENTS, "Instruments", GOOD.."+5% turret range",
-10, -3, {}, TREE_BUILDINGTREE)
GM:AddSkillModifier(SKILL_INSTRUMENTS, SKILLMOD_TURRET_RANGE_MUL, 0.05)

s = GM:AddSkill(SKILL_STOWAGE, "Stowage", GOOD.."Resupply usages build up when you're not there\n"..BAD.."+10% resupply delay\n"..BAD.."+0.02x resupply delay per resupply usage remaining",
4, -3, {}, TREE_BUILDINGTREE)
GM:AddSkillModifier(SKILL_STOWAGE, SKILLMOD_RESUPPLY_DELAY_MUL, 0.1)
GM:AddSkillFunction(SKILL_STOWAGE, function(pl, active)
	pl.Stowage = active
end)

-- Gunnery Tree

s = GM:AddSkill(SKILL_TRIGGER_DISCIPLINE1, "Trigger Discipline I", GOOD.."+2% weapon reload speed\n"..GOOD.."+2% weapon draw speed",
-5, 6, {SKILL_TRIGGER_DISCIPLINE2, SKILL_NONE}, TREE_GUNTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_TRIGGER_DISCIPLINE1, SKILLMOD_RELOADSPEED_MUL, 0.02)
GM:AddSkillModifier(SKILL_TRIGGER_DISCIPLINE1, SKILLMOD_DEPLOYSPEED_MUL, 0.02)

s = GM:AddSkill(SKILL_TRIGGER_DISCIPLINE2, "Trigger Discipline II", GOOD.."+3% weapon reload speed\n"..GOOD.."+3% weapon draw speed",
-4, 3, {SKILL_TRIGGER_DISCIPLINE3, SKILL_D_PALSY, SKILL_EQUIPPED}, TREE_GUNTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_TRIGGER_DISCIPLINE2, SKILLMOD_RELOADSPEED_MUL, 0.03)
GM:AddSkillModifier(SKILL_TRIGGER_DISCIPLINE2, SKILLMOD_DEPLOYSPEED_MUL, 0.03)

s = GM:AddSkill(SKILL_TRIGGER_DISCIPLINE3, "Trigger Discipline III", GOOD.."+4% weapon reload speed\n"..GOOD.."+4% weapon draw speed",
-3, 0, {SKILL_QUICKRELOAD, SKILL_QUICKDRAW, SKILL_WORTHINESS1, SKILL_EGOCENTRIC}, TREE_GUNTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_TRIGGER_DISCIPLINE3, SKILLMOD_RELOADSPEED_MUL, 0.04)
GM:AddSkillModifier(SKILL_TRIGGER_DISCIPLINE3, SKILLMOD_DEPLOYSPEED_MUL, 0.04)

s = GM:AddSkill(SKILL_D_PALSY, "Debuff: Palsy", GOOD.."+10 starting Worth\n"..GOOD.."-3% resupply delay\n"..BAD.."Aiming ability reduced when health is low",
0, 4, {SKILL_LEVELHEADED}, TREE_GUNTREE)
GM:AddSkillModifier(SKILL_D_PALSY, SKILLMOD_WORTH, 10)
GM:AddSkillModifier(SKILL_D_PALSY, SKILLMOD_RESUPPLY_DELAY_MUL, -0.03)
GM:AddSkillFunction(SKILL_D_PALSY, function(pl, active)
	pl.HasPalsy = active
end)

s = GM:AddSkill(SKILL_LEVELHEADED, "Level Headed", GOOD.."-6% effect of aim shake effects",
-2, 2, {SKILL_UNCORRUPTOR, SKILL_GUNSLINGER}, TREE_GUNTREE)
GM:AddSkillModifier(SKILL_LEVELHEADED, SKILLMOD_AIM_SHAKE_MUL, -0.06)

s = GM:AddSkill(SKILL_GUNSLINGER, "Gunslinger", GOOD.."+3% bullet damage\n"..BAD.."-20% melee damage",
-0.5, 0.5, {}, TREE_GUNTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_GUNSLINGER, SKILLMOD_BULLET_DAMAGE_MUL, 0.03)
GM:AddSkillModifier(SKILL_GUNSLINGER, SKILLMOD_MELEE_DAMAGE_MUL, -0.20)

s = GM:AddSkill(SKILL_UNCORRUPTOR, "Uncorruptor", GOOD.."Can uncorrupt sigils with non-melee weapon\n"..BAD.."Uncorrupting sigils with non-melee weapon is 20% slower\n"..BAD.."-15% slower sigil uncorruption",
0, 2, {}, TREE_GUNTREE)
s.RemortReq = 1

s = GM:AddSkill(SKILL_QUICKDRAW, "Quick Draw", GOOD.."+55% weapon draw speed\n"..BAD.."-15% weapon reload speed",
-1.75, -1.25, {}, TREE_GUNTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_QUICKDRAW, SKILLMOD_DEPLOYSPEED_MUL, 0.55)
GM:AddSkillModifier(SKILL_QUICKDRAW, SKILLMOD_RELOADSPEED_MUL, -0.15)

s = GM:AddSkill(SKILL_FOCUS1, "Focus I", GOOD.."-3% weapon aim spread\n"..GOOD.."-0.75% effect of aim shake effects\n"..BAD.."-3% weapon reload speed",
5, 6, {SKILL_NONE, SKILL_FOCUS2}, TREE_GUNTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_FOCUS1, SKILLMOD_AIMSPREAD_MUL, -0.03)
GM:AddSkillModifier(SKILL_FOCUS1, SKILLMOD_AIM_SHAKE_MUL, -0.0075)
GM:AddSkillModifier(SKILL_FOCUS1, SKILLMOD_RELOADSPEED_MUL, -0.03)

s = GM:AddSkill(SKILL_FOCUS2, "Focus II", GOOD.."-4% weapon aim spread\n"..GOOD.."-1% effect of aim shake effects\n"..BAD.."-4% weapon reload speed",
4, 3, {SKILL_FOCUS3, SKILL_SCAVENGER, SKILL_D_PALSY, SKILL_PITCHER}, TREE_GUNTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_FOCUS2, SKILLMOD_AIMSPREAD_MUL, -0.04)
GM:AddSkillModifier(SKILL_FOCUS2, SKILLMOD_AIM_SHAKE_MUL, -0.01)
GM:AddSkillModifier(SKILL_FOCUS2, SKILLMOD_RELOADSPEED_MUL, -0.04)

s = GM:AddSkill(SKILL_FOCUS3, "Focus III", GOOD.."-5% weapon aim spread\n"..GOOD.."-1.25% effect of aim shake effects\n"..BAD.."-5% weapon reload speed",
3, 0, {SKILL_EGOCENTRIC, SKILL_WOOISM, SKILL_ORPHICFOCUS, SKILL_SCOURER}, TREE_GUNTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_FOCUS3, SKILLMOD_AIMSPREAD_MUL, -0.05)
GM:AddSkillModifier(SKILL_FOCUS3, SKILLMOD_AIM_SHAKE_MUL, -0.0125)
GM:AddSkillModifier(SKILL_FOCUS3, SKILLMOD_RELOADSPEED_MUL, -0.05)

s = GM:AddSkill(SKILL_QUICKRELOAD, "Quick Reload", GOOD.."+10% weapon reload speed\n"..BAD.."-25% weapon draw speed",
-5, 1, {SKILL_SLEIGHTOFHAND, SKILL_U_DOOMSTICK}, TREE_GUNTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_QUICKRELOAD, SKILLMOD_RELOADSPEED_MUL, 0.10)
GM:AddSkillModifier(SKILL_QUICKRELOAD, SKILLMOD_DEPLOYSPEED_MUL, -0.25)

s = GM:AddSkill(SKILL_U_DOOMSTICK, "Unlock: Doom Stick", GOOD.."Unlocks purchasing the Doom Stick\nThe only tier 6 weapon\nMore powerful than Boom Stick",
-6.5, 1.5, {}, TREE_GUNTREE)

s = GM:AddSkill(SKILL_SLEIGHTOFHAND, "Sleight of Hand", GOOD.."+10% weapon reload speed\n"..GOOD.."-2.5% weapon fire delay\n"..BAD.."+20% weapon aim spread",
-5, -1, {}, TREE_GUNTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_SLEIGHTOFHAND, SKILLMOD_RELOADSPEED_MUL, 0.10)
GM:AddSkillModifier(SKILL_SLEIGHTOFHAND, SKILLMOD_WEAPON_FIREDELAY_MUL, -0.025)
GM:AddSkillModifier(SKILL_SLEIGHTOFHAND, SKILLMOD_AIMSPREAD_MUL, 0.2)

s = GM:AddSkill(SKILL_U_CRYGASGREN, "Unlock: Cryo Gas Grenade", GOOD.."Unlocks purchasing the Cryo Gas Grenade\nVariant of the Corrosive Gas Grenade\nCryo gas deals a bit of damage over time\nZombies are slowed in the effect",
2, -2.5, {SKILL_EGOCENTRIC}, TREE_GUNTREE)
s.AlwaysActive = true

s = GM:AddSkill(SKILL_SOFTDET, "Soft Detonation", GOOD.."-30% explosive damage taken\n"..BAD.."-10% explosive damage radius",
0, -5, {}, TREE_GUNTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_SOFTDET, SKILLMOD_EXP_DAMAGE_RADIUS, -0.10)
GM:AddSkillModifier(SKILL_SOFTDET, SKILLMOD_EXP_DAMAGE_TAKEN_MUL, -0.3)

s = GM:AddSkill(SKILL_ORPHICFOCUS, "Orphic Focus", GOOD.."90% spread while ironsighting\n"..GOOD.."-2.5% weapon aim spread\n"..GOOD.."-1.25% weapon fire delay\n"..BAD.."110% spread at any other time\n"..BAD.."-8% reload speed",
5, -1, {SKILL_DELIBRATION}, TREE_GUNTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_ORPHICFOCUS, SKILLMOD_AIMSPREAD_MUL, -0.025)
GM:AddSkillModifier(SKILL_ORPHICFOCUS, SKILLMOD_WEAPON_FIREDELAY_MUL, -0.0125)
GM:AddSkillModifier(SKILL_ORPHICFOCUS, SKILLMOD_RELOADSPEED_MUL, -0.08)
GM:AddSkillFunction(SKILL_ORPHICFOCUS, function(pl, active)
	pl.Orphic = active
end)

s = GM:AddSkill(SKILL_DELIBRATION, "Delibration", GOOD.."-1% weapon aim spread",
6, -3, {}, TREE_GUNTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_DELIBRATION, SKILLMOD_AIMSPREAD_MUL, -0.01)

s = GM:AddSkill(SKILL_EGOCENTRIC, "Egocentric", GOOD.."-35% damage vs. yourself\n"..BAD.."-5 health",
0, -1, {SKILL_BLASTPROOF}, TREE_GUNTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_EGOCENTRIC, SKILLMOD_SELF_DAMAGE_MUL, -0.35)
GM:AddSkillModifier(SKILL_EGOCENTRIC, SKILLMOD_HEALTH, -5)

s = GM:AddSkill(SKILL_BLASTPROOF, "Blast Proof", GOOD.."-35% explosive damage taken\n"..BAD.."-7% reload speed\n"..BAD.."-12% weapon draw speed",
0, -3, {SKILL_SOFTDET, SKILL_CANNONBALL, SKILL_CONEFFECT}, TREE_GUNTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_BLASTPROOF, SKILLMOD_EXP_DAMAGE_TAKEN_MUL, -0.35)
GM:AddSkillModifier(SKILL_BLASTPROOF, SKILLMOD_RELOADSPEED_MUL, -0.07)
GM:AddSkillModifier(SKILL_BLASTPROOF, SKILLMOD_DEPLOYSPEED_MUL, -0.12)

s = GM:AddSkill(SKILL_WOOISM, "Zeal", GOOD.."-50% speed reduction from being ironsighted\n"..BAD.."-25% accuracy bonus from ironsighting",
5, 1, {SKILL_TRUEWOOISM}, TREE_GUNTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_WOOISM, SKILLMOD_IRONSIGHT_EFF_MUL, -0.25)
GM:AddSkillFunction(SKILL_WOOISM, function(pl, active)
	pl.Wooism = active
end)

s = GM:AddSkill(SKILL_SCAVENGER, "Scavenger's Eyes", GOOD.."See nearby weapons, ammo, and items through walls",
7, 4, {}, TREE_GUNTREE)

s = GM:AddSkill(SKILL_PITCHER, "Pitcher", GOOD.."+10% object throwing strength",
6, 2, {}, TREE_GUNTREE)
GM:AddSkillModifier(SKILL_PITCHER, SKILLMOD_PROP_THROW_STRENGTH_MUL, 0.1)

s = GM:AddSkill(SKILL_EQUIPPED, "Alacrity", GOOD.."Your starting item can be a random special trinket\n"..BAD.."Has 50% chance to not work when \"Preparedness\" skill is active",
-6, 2, {}, TREE_GUNTREE)

s = GM:AddSkill(SKILL_WORTHINESS1, "Worthiness I", GOOD.."+5 starting worth\n"..BAD.."-3 starting points",
-3.5, -2.5, {SKILL_POINTFULNESS1}, TREE_GUNTREE)
GM:AddSkillModifier(SKILL_WORTHINESS1, SKILLMOD_WORTH, 5)
GM:AddSkillModifier(SKILL_WORTHINESS1, SKILLMOD_POINTS, -3)

s = GM:AddSkill(SKILL_POINTFULNESS1, "Pointfulness I", GOOD.."+3 starting points\n"..GOOD.."+1% point gain multiplier\n"..BAD.."-10 starting worth",
-4, -4, {}, TREE_GUNTREE)
GM:AddSkillModifier(SKILL_POINTFULNESS1, SKILLMOD_WORTH, -10)
GM:AddSkillModifier(SKILL_POINTFULNESS1, SKILLMOD_POINTS, 3)
GM:AddSkillModifier(SKILL_POINTFULNESS1, SKILLMOD_POINT_MULTIPLIER, 0.01)

s = GM:AddSkill(SKILL_CANNONBALL, "Cannonball", "-25% projectile speed\n"..GOOD.."+3% projectile damage",
-2, -3, {}, TREE_GUNTREE)
GM:AddSkillModifier(SKILL_CANNONBALL, SKILLMOD_PROJ_SPEED, -0.25)
GM:AddSkillModifier(SKILL_CANNONBALL, SKILLMOD_PROJECTILE_DAMAGE_MUL, 0.03)

s = GM:AddSkill(SKILL_SCOURER, "Scourer", GOOD.."Earn end of wave points as scrap\n"..BAD.."Earn no end of wave points",
4, -3, {}, TREE_GUNTREE)
GM:AddSkillFunction(SKILL_SCOURER, function(pl, active)
	pl.Scourer = active
end)

s = GM:AddSkill(SKILL_CONEFFECT, "Concentrated Effect", GOOD.."+5% explosive damage\n"..BAD.."-20% explosive damage radius",
2, -5, {}, TREE_GUNTREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_CONEFFECT, SKILLMOD_EXP_DAMAGE_RADIUS, -0.2)
GM:AddSkillModifier(SKILL_CONEFFECT, SKILLMOD_EXP_DAMAGE_MUL, 0.05)

s = GM:AddSkill(SKILL_TRUEWOOISM, "Wooism", GOOD.."No accuracy penalty from moving or jumping\n"..BAD.."No accuracy bonus from crouching or ironsighting",
7, 0, {}, TREE_GUNTREE)
s.CanUseInZE = true
GM:AddSkillFunction(SKILL_TRUEWOOISM, function(pl, active)
	pl.TrueWooism = active
end)

-- Melee Tree

s = GM:AddSkill(SKILL_WORTHINESS2, "Worthiness II", GOOD.."+5 starting worth\n"..BAD.."-3 starting points",
4, 0, {SKILL_POINTFULNESS2}, TREE_MELEETREE)
GM:AddSkillModifier(SKILL_WORTHINESS2, SKILLMOD_WORTH, 5)
GM:AddSkillModifier(SKILL_WORTHINESS2, SKILLMOD_POINTS, -3)

s = GM:AddSkill(SKILL_POINTFULNESS2, "Pointfulness II", GOOD.."+3 starting points\n"..GOOD.."+1% point gain multiplier\n"..BAD.."-10 starting worth",
4, 2, {}, TREE_MELEETREE)
GM:AddSkillModifier(SKILL_POINTFULNESS2, SKILLMOD_WORTH, -10)
GM:AddSkillModifier(SKILL_POINTFULNESS2, SKILLMOD_POINTS, 3)
GM:AddSkillModifier(SKILL_POINTFULNESS2, SKILLMOD_POINT_MULTIPLIER, 0.01)

s = GM:AddSkill(SKILL_BATTLER1, "Battler I", GOOD.."+4% melee damage",
-6, -6, {SKILL_BATTLER2, SKILL_NONE}, TREE_MELEETREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_BATTLER1, SKILLMOD_MELEE_DAMAGE_MUL, 0.04)

s = GM:AddSkill(SKILL_BATTLER2, "Battler II", GOOD.."+4% melee damage",
-6, -4, {SKILL_BATTLER3, SKILL_LIGHTWEIGHT}, TREE_MELEETREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_BATTLER2, SKILLMOD_MELEE_DAMAGE_MUL, 0.05)

s = GM:AddSkill(SKILL_BATTLER3, "Battler III", GOOD.."+5% melee damage",
-4, -2, {SKILL_BATTLER4, SKILL_LANKY1}, TREE_MELEETREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_BATTLER3, SKILLMOD_MELEE_DAMAGE_MUL, 0.05)

s = GM:AddSkill(SKILL_BATTLER4, "Battler IV", GOOD.."+5% melee damage",
-2, 0, {SKILL_BATTLER5, SKILL_MASTERCHEF, SKILL_D_CLUMSY}, TREE_MELEETREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_BATTLER4, SKILLMOD_MELEE_DAMAGE_MUL, 0.06)

s = GM:AddSkill(SKILL_BATTLER5, "Battler V", GOOD.."+6% melee damage",
0, 2, {SKILL_BATTLER6, SKILL_GLASSWEAPONS, SKILL_BLOODLUST}, TREE_MELEETREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_BATTLER5, SKILLMOD_MELEE_DAMAGE_MUL, 0.07)

s = GM:AddSkill(SKILL_BATTLER6, "Battler VI", GOOD.."+7% melee damage",
0, -1, {}, TREE_MELEETREE)
s.RemortReq = 1
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_BATTLER6, SKILLMOD_MELEE_DAMAGE_MUL, 0.08)

s = GM:AddSkill(SKILL_LASTSTAND, "Last Stand", GOOD.."1.85x melee damage when below 25% health\n"..GOOD.."-10% melee damage taken when below 25% health\n"..BAD.."0.8x melee weapon damage at any other time",
0, 6, {}, TREE_MELEETREE)

s = GM:AddSkill(SKILL_GLASSWEAPONS, "Glass Weapons", VERYGOOD.."3.23x melee weapon damage vs. zombies\n"..BAD.."Your melee weapons have a 35% chance to break when hitting a zombie\n"..NEUTRAL.."Some melee weapons are not affected by this skill", --\nFirst melee hit will never break a melee weapon,
2, 4.5, {}, TREE_MELEETREE)

s = GM:AddSkill(SKILL_D_CLUMSY, "Debuff: Clumsy", GOOD.."+20 starting Worth\n"..GOOD.."+5 starting points\n"..BAD.."Very easy to be knocked down",
-2, 2, {}, TREE_MELEETREE)
GM:AddSkillModifier(SKILL_D_CLUMSY, SKILLMOD_WORTH, 20)
GM:AddSkillModifier(SKILL_D_CLUMSY, SKILLMOD_POINTS, 5)
GM:AddSkillFunction(SKILL_D_CLUMSY, function(pl, active)
	pl.IsClumsy = active
end)

s = GM:AddSkill(SKILL_CHEAPKNUCKLE, "Cheap Tactics", GOOD.."Slow targets when striking with a melee weapon from behind\n"..BAD.."-10% melee range multiplier",
4, -2, {SKILL_HEAVYSTRIKES, SKILL_WORTHINESS2}, TREE_MELEETREE)
GM:AddSkillModifier(SKILL_CHEAPKNUCKLE, SKILLMOD_MELEE_RANGE_MUL, -0.1)

s = GM:AddSkill(SKILL_CRITICALKNUCKLE, "Critical Knuckle", GOOD.."Knockback when using unarmed strikes\n"..BAD.."-5% unarmed strike damage\n"..BAD.."+25% time before next unarmed strike",
6, -2, {SKILL_BRASH, SKILL_FISTER}, TREE_MELEETREE)
GM:AddSkillModifier(SKILL_CRITICALKNUCKLE, SKILLMOD_UNARMED_DAMAGE_MUL, -0.05)
GM:AddSkillModifier(SKILL_CRITICALKNUCKLE, SKILLMOD_UNARMED_SWING_DELAY_MUL, 0.25)

s = GM:AddSkill(SKILL_FISTER, "Fister", GOOD.."-2% time before next unarmed strike",
8, -2, {}, TREE_MELEETREE)
GM:AddSkillModifier(SKILL_FISTER, SKILLMOD_UNARMED_SWING_DELAY_MUL, -0.02)

s = GM:AddSkill(SKILL_KNUCKLEMASTER, "Knuckle Master", GOOD.."+65% unarmed strike damage\n"..GOOD.."Movement speed is no longer slower when using unarmed strikes\n"..BAD.."+35% time before next unarmed strike",
6, -6, {SKILL_NONE, SKILL_COMBOKNUCKLE}, TREE_MELEETREE)
GM:AddSkillModifier(SKILL_KNUCKLEMASTER, SKILLMOD_UNARMED_SWING_DELAY_MUL, 0.35)
GM:AddSkillModifier(SKILL_KNUCKLEMASTER, SKILLMOD_UNARMED_DAMAGE_MUL, 0.65)

s = GM:AddSkill(SKILL_COMBOKNUCKLE, "Combo Knuckle", GOOD.."Next unarmed strike is 2x faster if hitting something\n"..BAD.."Next unarmed attack is 2x slower if not hitting something",
6, -4, {SKILL_CHEAPKNUCKLE, SKILL_CRITICALKNUCKLE}, TREE_MELEETREE)

s = GM:AddSkill(SKILL_HEAVYSTRIKES, "Heavy Strikes", GOOD.."+75% melee knockback\n"..BAD.."6% of melee damage dealt is reflected back to you as damage if knockback is applied\n"..BAD.."25% reflected if using unarmed strikes",
2, 0, {SKILL_BATTLER5, SKILL_JOUSTER1}, TREE_MELEETREE)
GM:AddSkillModifier(SKILL_HEAVYSTRIKES, SKILLMOD_MELEE_KNOCKBACK_MUL, 0.75)

s = GM:AddSkill(SKILL_JOUSTER1, "Jouster I", GOOD.."+5% melee damage\n"..GOOD.."+1 melee range\n"..BAD.."-40% melee knockback",
2, 1.5, {SKILL_JOUSTER2}, TREE_MELEETREE)
GM:AddSkillModifier(SKILL_JOUSTER1, SKILLMOD_MELEE_DAMAGE_MUL, 0.05)
GM:AddSkillModifier(SKILL_JOUSTER1, SKILLMOD_MELEE_KNOCKBACK_MUL, -0.4)
GM:AddSkillModifier(SKILL_JOUSTER1, SKILLMOD_MELEE_RANGE_ADD, 1)

s = GM:AddSkill(SKILL_JOUSTER2, "Jouster II", GOOD.."+7.5% melee damage\n"..GOOD.."+1.5 melee range\n"..BAD.."-60% melee knockback",
2, 3, {}, TREE_MELEETREE)
GM:AddSkillModifier(SKILL_JOUSTER2, SKILLMOD_MELEE_DAMAGE_MUL, 0.075)
GM:AddSkillModifier(SKILL_JOUSTER2, SKILLMOD_MELEE_KNOCKBACK_MUL, -0.6)
GM:AddSkillModifier(SKILL_JOUSTER2, SKILLMOD_MELEE_RANGE_ADD, 1.5)

s = GM:AddSkill(SKILL_LANKY1, "Lanky I", GOOD.."+6.5% melee range multiplier\n"..BAD.."-10% melee damage",
-4, 0, {SKILL_LANKY2}, TREE_MELEETREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_LANKY1, SKILLMOD_MELEE_DAMAGE_MUL, -0.1)
GM:AddSkillModifier(SKILL_LANKY1, SKILLMOD_MELEE_RANGE_MUL, 0.065)

s = GM:AddSkill(SKILL_LANKY2, "Lanky II", GOOD.."+7.5% melee range multiplier\n"..BAD.."-11.5% melee damage",
-4, 1.5, {SKILL_LANKY3}, TREE_MELEETREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_LANKY2, SKILLMOD_MELEE_DAMAGE_MUL, -0.115)
GM:AddSkillModifier(SKILL_LANKY2, SKILLMOD_MELEE_RANGE_MUL, 0.075)

s = GM:AddSkill(SKILL_LANKY3, "Lanky III", GOOD.."+8.5% melee range multiplier\n"..BAD.."-13% melee damage",
-4, 3, {}, TREE_MELEETREE)
s.CanUseInZE = true
s.RemortReq = 1
GM:AddSkillModifier(SKILL_LANKY3, SKILLMOD_MELEE_DAMAGE_MUL, -0.13)
GM:AddSkillModifier(SKILL_LANKY3, SKILLMOD_MELEE_RANGE_MUL, 0.085)

s = GM:AddSkill(SKILL_MASTERCHEF, "Master Chef", GOOD.."Zombies hit by culinary weapons in the past second have a chance to drop food items on death\n"..BAD.."-10% melee damage",
0, -3, {SKILL_BATTLER4}, TREE_MELEETREE)
GM:AddSkillModifier(SKILL_MASTERCHEF, SKILLMOD_MELEE_DAMAGE_MUL, -0.10)

s = GM:AddSkill(SKILL_LIGHTWEIGHT, "Lightweight", GOOD.."+6.75 movement speed with a melee weapon equipped\n"..BAD.."-20% melee damage",
-6, -2, {}, TREE_MELEETREE)
s.CanUseInZE = true
GM:AddSkillModifier(SKILL_LIGHTWEIGHT, SKILLMOD_MELEE_DAMAGE_MUL, -0.2)

s = GM:AddSkill(SKILL_BLOODLUST, "Bloodlust", "Gain phantom health equal to half the damage taken from zombies\nLose phantom health equal to any healing received\nPhantom health decreases by 4 per second\n"..GOOD.."Heal 25% of damage done with melee from remaining phantom health\n"..BAD.."-40% healing received",
-2, 4, {SKILL_LASTSTAND}, TREE_MELEETREE)
GM:AddSkillModifier(SKILL_BLOODLUST, SKILLMOD_HEALING_RECEIVED, -0.4)

s = GM:AddSkill(SKILL_BRASH, "Brash", GOOD.."-16% melee swing impact delay\n"..GOOD.."-2% melee attack delay\n"..BAD.."-15 speed on melee kill for 10 seconds",
6, 0, {}, TREE_MELEETREE)
GM:AddSkillModifier(SKILL_BRASH, SKILLMOD_MELEE_SWING_DELAY_MUL, -0.16)
GM:AddSkillModifier(SKILL_BRASH, SKILLMOD_MELEE_ATTACK_DELAY_MUL, -0.02)
GM:AddSkillModifier(SKILL_BRASH, SKILLMOD_MELEE_MOVEMENTSPEED_ON_KILL, -15)

-- Torment Skill Tree
s = GM:AddSkill(SKILL_TORMENT1, "Torment I", GOOD.."+2% XP multiplier\n"..BAD.."-7.5 movement speed",
-3, 0, {SKILL_NONE, SKILL_TORMENT2}, TREE_TORMENTTREE)
GM:AddSkillModifier(SKILL_TORMENT1, SKILLMOD_XP_MULTI, 0.02)
GM:AddSkillModifier(SKILL_TORMENT1, SKILLMOD_SPEED, -7.5)

s = GM:AddSkill(SKILL_TORMENT2, "Torment II", GOOD.."+3% XP multiplier\n"..BAD.."-15 maximum health",
-1.5, 0, {SKILL_TORMENT3}, TREE_TORMENTTREE)
s.RemortReq = 1
GM:AddSkillModifier(SKILL_TORMENT2, SKILLMOD_XP_MULTI, 0.03)
GM:AddSkillModifier(SKILL_TORMENT2, SKILLMOD_HEALTH, -15)

s = GM:AddSkill(SKILL_TORMENT3, "Torment III", GOOD.."+4% XP multiplier\n"..BAD.."+50% medical kit cooldown\n"..BAD.."-20% repair rate",
0, 0, {SKILL_TORMENT4}, TREE_TORMENTTREE)
s.RemortReq = 1
GM:AddSkillModifier(SKILL_TORMENT3, SKILLMOD_XP_MULTI, 0.04)
GM:AddSkillModifier(SKILL_TORMENT3, SKILLMOD_MEDKIT_COOLDOWN_MUL, 0.5)
GM:AddSkillModifier(SKILL_TORMENT3, SKILLMOD_REPAIRRATE_MUL, -0.2)

s = GM:AddSkill(SKILL_TORMENT4, "Torment IV", GOOD.."+5% XP multiplier\n"..BAD.."+10% melee damage taken\n"..BAD.."+5% arsenal items cost",
1, -0.5, {SKILL_TORMENT5}, TREE_TORMENTTREE)
s.RemortReq = 2
GM:AddSkillModifier(SKILL_TORMENT4, SKILLMOD_XP_MULTI, 0.05)
GM:AddSkillModifier(SKILL_TORMENT4, SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, 0.1)
GM:AddSkillModifier(SKILL_TORMENT4, SKILLMOD_ARSENAL_DISCOUNT, 0.05)

s = GM:AddSkill(SKILL_TORMENT5, "Torment V", GOOD.."+6% XP multiplier\n"..BAD.."-15 maximum blood armor\n"..BAD.."-10% jumping power\n"..BAD.."+40% effect of aim shake effects",
2, -1, {}, TREE_TORMENTTREE)
s.RemortReq = 2
GM:AddSkillModifier(SKILL_TORMENT5, SKILLMOD_XP_MULTI, 0.06)
GM:AddSkillModifier(SKILL_TORMENT5, SKILLMOD_JUMPPOWER_MUL, -0.1)
GM:AddSkillModifier(SKILL_TORMENT5, SKILLMOD_AIM_SHAKE_MUL, 0.4)
GM:AddSkillModifier(SKILL_TORMENT5, SKILLMOD_BLOODARMOR, -15)

s = GM:AddSkill(SKILL_TORMENT6, "Torment VI", GOOD.."+7% XP multiplier\n"..BAD.."-25 maximum health\n"..BAD.."+20% resupply delay\nWORK IN PROGRESS",
3, -1.5, {SKILL_TORMENT7}, TREE_TORMENTTREE)
s.RemortReq = 3
GM:AddSkillModifier(SKILL_TORMENT6, SKILLMOD_XP_MULTI, 0.07)
GM:AddSkillModifier(SKILL_TORMENT6, SKILLMOD_HEALTH, -25)
GM:AddSkillModifier(SKILL_TORMENT6, SKILLMOD_RESUPPLY_DELAY_MUL, 0.2)

s = GM:AddSkill(SKILL_TORMENT7, "Torment VII", GOOD.."+8% XP multiplier\n"..BAD.."+15% melee damage taken\n"..BAD.."-15 starting points\n"..VERYBAD.."-5% point gain multiplier\nWORK IN PROGRESS",
4, -2, {SKILL_TORMENT8}, TREE_TORMENTTREE)
s.RemortReq = 3
GM:AddSkillModifier(SKILL_TORMENT7, SKILLMOD_XP_MULTI, 0.08)
GM:AddSkillModifier(SKILL_TORMENT7, SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, 0.15)
GM:AddSkillModifier(SKILL_TORMENT7, SKILLMOD_POINTS, -15)
GM:AddSkillModifier(SKILL_TORMENT7, SKILLMOD_POINT_MULTIPLIER, -0.05)

s = GM:AddSkill(SKILL_TORMENT8, "Torment VIII", GOOD.."+9% XP multiplier\n"..BAD.."-22.5 movement speed\n"..BAD.."+20% sigil teleportation time\n"..BAD.."+150% time to eat food\nWORK IN PROGRESS",
5, -3, {SKILL_TORMENT9}, TREE_TORMENTTREE)
s.RemortReq = 4
GM:AddSkillModifier(SKILL_TORMENT8, SKILLMOD_XP_MULTI, 0.09)
GM:AddSkillModifier(SKILL_TORMENT8, SKILLMOD_SPEED, -22.5)
GM:AddSkillModifier(SKILL_TORMENT8, SKILLMOD_SIGIL_TELEPORT_MUL, 0.2)
GM:AddSkillModifier(SKILL_TORMENT8, SKILLMOD_FOODEATTIME_MUL, 1.5)

s = GM:AddSkill(SKILL_TORMENT9, "Torment IX", GOOD.."+10% XP multiplier\n"..BAD.."-20% barricade phasing movement speed\nWORK IN PROGRESS",
5.5, -4, {SKILL_TORMENT10}, TREE_TORMENTTREE)
s.RemortReq = 4
GM:AddSkillModifier(SKILL_TORMENT9, SKILLMOD_XP_MULTI, 0.1)
GM:AddSkillModifier(SKILL_TORMENT9, SKILLMOD_BARRICADE_PHASE_SPEED_MUL, -0.2)

s = GM:AddSkill(SKILL_TORMENT10, "Torment X", GOOD.."+11% XP multiplier\n"..VERYGOOD.."If all torment skills active you gain +50% XP on winning round\nWORK IN PROGRESS",
6, -5.5, {}, TREE_TORMENTTREE)
s.RemortReq = 5
GM:AddSkillModifier(SKILL_TORMENT10, SKILLMOD_XP_MULTI, 0.11)

-- Defender Skill Tree

s = GM:AddSkill(SKILL_SIGILDEFENDER1, "Sigil Defender I", GOOD.."-1% melee damage taken\n"..BAD.."-2.5 movement speed\nMinimal melee damage taken is 2.5%",
0, -2, {SKILL_NONE, SKILL_SIGILDEFENDER2}, TREE_REMORTTREE)
GM:AddSkillModifier(SKILL_SIGILDEFENDER1, SKILLMOD_SPEED, -2.5)
GM:AddSkillModifier(SKILL_SIGILDEFENDER1, SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, -0.01)

s = GM:AddSkill(SKILL_SIGILDEFENDER2, "Sigil Defender II", GOOD.."-2% melee damage taken\n"..BAD.."-5 movement speed",
2, -1, {SKILL_SIGILDEFENDER3}, TREE_REMORTTREE)
GM:AddSkillModifier(SKILL_SIGILDEFENDER2, SKILLMOD_SPEED, -5)
GM:AddSkillModifier(SKILL_SIGILDEFENDER2, SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, -0.02)

s = GM:AddSkill(SKILL_SIGILDEFENDER3, "Sigil Defender III", GOOD.."-4% melee damage taken\n"..BAD.."-10 movement speed",
2, 1, {SKILL_SIGILDEFENDER4}, TREE_REMORTTREE)
GM:AddSkillModifier(SKILL_SIGILDEFENDER3, SKILLMOD_SPEED, -10)
GM:AddSkillModifier(SKILL_SIGILDEFENDER3, SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, -0.04)

s = GM:AddSkill(SKILL_SIGILDEFENDER4, "Sigil Defender IV", GOOD.."-6% melee damage taken\n"..BAD.."-15 movement speed",
0, 2, {SKILL_D_FRAGILITY}, TREE_REMORTTREE)
GM:AddSkillModifier(SKILL_SIGILDEFENDER4, SKILLMOD_SPEED, -15)
GM:AddSkillModifier(SKILL_SIGILDEFENDER4, SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, -0.06)

s = GM:AddSkill(SKILL_D_FRAGILITY, "Debuff: Fragility", GOOD.."+15 starting worth\n"..GOOD.."+1% point gain multiplier\n"..BAD.."+4% melee damage taken for every wave",
0, 4, {}, TREE_REMORTTREE)
GM:AddSkillModifier(SKILL_D_FRAGILITY, SKILLMOD_WORTH, 15)
GM:AddSkillModifier(SKILL_D_FRAGILITY, SKILLMOD_POINT_MULTIPLIER, 0.01)
GM:AddSkillFunction(SKILL_D_FRAGILITY, function(pl, active)
	pl.IsFragility = active
end)



GM:SetSkillModifierFunction(SKILLMOD_HEALTH, function(pl, amount)
	local current = pl:GetMaxHealth()
	local new = math.Clamp(100 + amount, 1, 100000)
	if SERVER then
		pl:SetMaxHealth(new)
		pl:SetHealth(math.max(1, pl:Health() / current * new))
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

GM:SetSkillModifierFunction(SKILLMOD_SPEED, function(pl, amount)
	pl.SkillSpeedAdd = amount
end)

GM:SetSkillModifierFunction(SKILLMOD_WORTH, function(pl, amount)
	pl.ExtraStartingWorth = amount
end)

GM:SetSkillModifierFunction(SKILLMOD_FALLDAMAGE_DAMAGE_MUL, function(pl, amount)
	pl.FallDamageDamageMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_FALLDAMAGE_THRESHOLD_MUL, function(pl, amount)
	pl.FallDamageThresholdMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_FALLDAMAGE_RECOVERY_MUL, function(pl, amount)
	pl.FallDamageRecoveryMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_FALLDAMAGE_SLOWDOWN_MUL, function(pl, amount)
	pl.FallDamageSlowDownMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_FOODRECOVERY_MUL, function(pl, amount)
	pl.FoodRecoveryMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
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

GM:SetSkillModifierFunction(SKILLMOD_RELOADSPEED_MUL, function(pl, amount)
	pl.ReloadSpeedMultiplier = math.Clamp(amount + 1.0, 0.05, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_DEPLOYSPEED_MUL, function(pl, amount)
	pl.DeploySpeedMultiplier = math.Clamp(amount + 1.0, 0.05, 100.0)

	for _, wep in pairs(pl:GetWeapons()) do
		GAMEMODE:DoChangeDeploySpeed(wep)
	end
end)

GM:SetSkillModifierFunction(SKILLMOD_UNARMED_DAMAGE_MUL, function(pl, amount)
	pl.UnarmedDamageMul = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_UNARMED_SWING_DELAY_MUL, function(pl, amount)
	pl.UnarmedDelayMul = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_DAMAGE_MUL, function(pl, amount)
	pl.MeleeDamageMultiplier = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_KNOCKBACK_MUL, function(pl, amount)
	pl.MeleeKnockbackMultiplier = math.Clamp(amount + 1.0, 0.0, 10000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_RANGE_MUL, function(pl, amount)
	pl.MeleeRangeMul = math.Clamp(amount + 1.0, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_HAMMER_SWING_DELAY_MUL, function(pl, amount)
	pl.HammerSwingDelayMul = math.Clamp(amount + 1.0, 0.01, 10.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_CONTROLLABLE_SPEED_MUL, function(pl, amount)
	pl.ControllableSpeedMul = math.Clamp(amount + 1.0, 0.01, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_CONTROLLABLE_HANDLING_MUL, function(pl, amount)
	pl.ControllableHandlingMul = math.Clamp(amount + 1.0, 0.01, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_CONTROLLABLE_HEALTH_MUL, function(pl, amount)
	pl.ControllableHealthMul = math.Clamp(amount + 1.0, 0.01, 10.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MANHACK_DAMAGE_MUL, function(pl, amount)
	pl.ManhackDamageMul = math.Clamp(amount + 1.0, 0.0, 10.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MANHACK_HEALTH_MUL, function(pl, amount)
	pl.ManhackHealthMul = math.Clamp(amount + 1.0, 0.01, 10.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_BARRICADE_PHASE_SPEED_MUL, function(pl, amount)
	pl.BarricadePhaseSpeedMul = math.Clamp(amount + 1.0, 0.05, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MEDKIT_COOLDOWN_MUL, function(pl, amount)
	pl.MedicCooldownMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, function(pl, amount)
	pl.MedicHealMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)


GM:SetSkillModifierFunction(SKILLMOD_SELF_DAMAGE_MUL, function(pl, amount)
	pl.SelfDamageMul = math.Clamp(amount + 1.0, 0.0, 100.0)
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
	pl.MeleeDamageTakenMul = math.Clamp(amount + 1.0, -1000.0, 1000.0)
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

GM:SetSkillModifierFunction(SKILLMOD_MELEE_ATTACK_DELAY_MUL, function(pl, amount)
	pl.MeleeAttackDelayMul = math.Clamp(amount + 1.0, 0, 1000.0)
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


GM:SetSkillModifierFunction(SKILLMOD_MELEE_RANGE_ADD, function(pl, amount)
	pl.MeleeRangeAdd = math.Clamp(amount, 0.0, 1000.0)
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

GM:SetSkillModifierFunction(SKILLMOD_PROP_CARRY_CAPACITY_MASS_MUL, function(pl, amount)
	pl.PropCarryCapacityMassMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_PROP_CARRY_CAPACITY_VOLUME_MUL, function(pl, amount)
	pl.PropCarryCapacityVolumeMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
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
	pl.BloodArmorDamageReductionAdd = math.Clamp(amount, -0.5, 0.5)
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

GM:SetSkillModifierFunction(SKILLMOD_ARSENAL_DISCOUNT, function(pl, amount)
	pl.ArsenalDiscount = math.Clamp(1 + amount, 0.0, 1000.0)
end)
GM:SetSkillModifierFunction(SKILLMOD_CLOUD_RADIUS, GM:MkGenericMod("CloudRadius"))
GM:SetSkillModifierFunction(SKILLMOD_CLOUD_TIME, GM:MkGenericMod("CloudTime"))
GM:SetSkillModifierFunction(SKILLMOD_EXP_DAMAGE_MUL, GM:MkGenericMod("ExplosiveDamageMul"))
GM:SetSkillModifierFunction(SKILLMOD_PROJECTILE_DAMAGE_MUL, GM:MkGenericMod("ProjectileDamageMul"))
GM:SetSkillModifierFunction(SKILLMOD_TURRET_RANGE_MUL, GM:MkGenericMod("TurretRangeMul"))
GM:SetSkillModifierFunction(SKILLMOD_AIM_SHAKE_MUL, GM:MkGenericMod("AimShakeMul"))
GM:SetSkillModifierFunction(SKILLMOD_XP_MULTI, GM:MkGenericMod("XPGainMul"))
GM:SetSkillModifierFunction(SKILLMOD_POINT_MULTIPLIER, GM:MkGenericMod("PointsGainMul"))

GM:SetSkillModifierFunction(SKILLMOD_BULLET_DAMAGE_MUL, function(pl, amount)
	pl.WeaponBulletDamageMul = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_WEAPON_FIREDELAY_MUL, function(pl, amount)
	pl.WeaponFireDelayMul = math.Clamp(amount + 1.0, 0.0, 100.0)
end)



GM:SetSkillModifierFunction(SKILLMOD_POINTS, function(pl, amount)
	if SERVER and not pl.AdjustedStartPointsSkill then
 pl:SetPoints(pl:GetPoints() + amount)
 pl.AdjustedStartPointsSkill = true
	end
end)

GM:SetSkillModifierFunction(SKILLMOD_SCRAP_START, function(pl, amount)
	if SERVER and not pl.AdjustedStartScrapSkill then
 pl:GiveAmmo(amount, "scrap")
 pl.AdjustedStartScrapSkill = true
	end
end)

GM:SetSkillModifierFunction(SKILLMOD_DRONE_SPEED_MUL, function(pl, amount)
	pl.DroneSpeedMul = math.Clamp(amount + 1.0, 0.01, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_DRONE_CARRYMASS_MUL, function(pl, amount)
	pl.DroneCarryMassMul = math.Clamp(amount + 1.0, 0.01, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_TURRET_HEALTH_MUL, function(pl, amount)
	pl.TurretHealthMul = math.Clamp(amount + 1.0, 0.01, 10.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_TURRET_SCANSPEED_MUL, function(pl, amount)
	pl.TurretScanSpeedMul = math.Clamp(amount + 1.0, 0, 10.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_TURRET_SCANANGLE_MUL, function(pl, amount)
	pl.TurretScanAngleMul = math.Clamp(amount + 1.0, 0, 2.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_DEPLOYABLE_HEALTH_MUL, function(pl, amount)
	pl.DeployableHealthMul = math.Clamp(amount + 1.0, 0.01, 10.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_DEPLOYABLE_PACKTIME_MUL, function(pl, amount)
	pl.DeployablePackTimeMul = math.Clamp(amount + 1.0, 0.01, 10.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_RESUPPLY_DELAY_MUL, function(pl, amount)
	pl.ResupplyDelayMul = math.Clamp(amount + 1.0, 0.01, 10.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_FIELD_RANGE_MUL, function(pl, amount)
	pl.FieldRangeMul = math.Clamp(amount + 1.0, 0.01, 10.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_FIELD_DELAY_MUL, function(pl, amount)
	pl.FieldDelayMul = math.Clamp(amount + 1.0, 0.01, 10.0)
end)
