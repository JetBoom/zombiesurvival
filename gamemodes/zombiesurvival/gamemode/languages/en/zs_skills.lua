-- Skill names and (where applicable) descriptions.
--
-- Rules for descriptions:
--   * Most skills get their description automatically from DescriptionAttributes
--     defined in registry.lua + attr_* keys in zs_attributes.lua. Do NOT add
--     skill_desc_<id> for those, or you'll shadow the dynamic values.
--   * The skills below have plain-string descriptions in registry.lua (mostly
--     "Unlock: ..." skills and passives). Those cannot use attr_* keys, so
--     their text is provided here as skill_desc_<id>.
--   * Colour prefix: ^2 = green, ^1 = red, no prefix = grey.

translate.AddLanguage("en", "English")

LANGUAGE.skill_name_1								= "Speed I"
LANGUAGE.skill_name_2								= "Speed II"
LANGUAGE.skill_name_3								= "Speed III"
LANGUAGE.skill_name_4								= "Speed IV"
LANGUAGE.skill_name_5								= "Speed V"

LANGUAGE.skill_name_6								= "Stoic I"
LANGUAGE.skill_name_7								= "Stoic II"
LANGUAGE.skill_name_8								= "Stoic III"
LANGUAGE.skill_name_9								= "Stoic IV"
LANGUAGE.skill_name_10								= "Stoic V"

LANGUAGE.skill_name_11								= "Surgeon I"
LANGUAGE.skill_name_12								= "Surgeon II"
LANGUAGE.skill_name_13								= "Surgeon III"

LANGUAGE.skill_name_14								= "Handy I"
LANGUAGE.skill_name_15								= "Handy II"
LANGUAGE.skill_name_16								= "Handy III"

LANGUAGE.skill_name_17								= "Motion I"

LANGUAGE.skill_name_18								= "Backpeddler"

LANGUAGE.skill_name_19								= "Phaser"

-- 20: Loaded Hull (uses DescriptionAttributes)
LANGUAGE.skill_name_20								= "Loaded Hull"

-- 21: Reinforced Hull (uses DescriptionAttributes)
LANGUAGE.skill_name_21								= "Reinforced Hull"

-- 22: Reinforced Blades (uses DescriptionAttributes)
LANGUAGE.skill_name_22								= "Reinforced Blades"

-- 23: Aviator (uses DescriptionAttributes)
LANGUAGE.skill_name_23								= "Aviator"

-- 24: Blast Turret (plain-string description in registry.lua)
LANGUAGE.skill_name_24								= "Unlock: Blast Turret"
LANGUAGE.skill_desc_24								= "^2Unlocks purchasing the Blast Turret.\n^2Fires buckshot instead of SMG ammo.\n^2Damage is higher close up.\n^1Cannot scan for targets far away."

-- 25: Turret Lock (uses DescriptionAttributes)
LANGUAGE.skill_name_25								= "Turret Lock"

-- 26: Twin Volley (uses DescriptionAttributes)
LANGUAGE.skill_name_26								= "Twin Volley"

-- 27: Turret Overload (uses DescriptionAttributes)
LANGUAGE.skill_name_27								= "Turret Overload"

-- 28: Pulse Drone (plain-string description in registry.lua)
LANGUAGE.skill_name_28								= "Unlock: Pulse Drone"
LANGUAGE.skill_desc_28								= "^2Unlocks the Pulse Drone Variant.\n^2Fires short range pulse projectiles instead of bullets."

-- 29: Nanite Cloud Bomb (plain-string description in registry.lua)
LANGUAGE.skill_name_29								= "Unlock: Nanite Cloud Bomb"
LANGUAGE.skill_desc_29								= "^2Unlocks purchasing the Nanite Cloud Bomb.\n^2Slowly repairs all props and deployables inside the cloud."

-- 30: Hammer Discipline (uses DescriptionAttributes)
LANGUAGE.skill_name_30								= "Hammer Discipline"

-- 31: Field Amplifier (uses DescriptionAttributes)
LANGUAGE.skill_name_31								= "Field Amplifier"

-- 32: Rollermine (plain-string description in registry.lua)
LANGUAGE.skill_name_32								= "Unlock: Rollermine"
LANGUAGE.skill_desc_32								= "^2Unlocks purchasing Rollermines.\n^2Rolls along the ground, shocking zombies and dealing damage."

-- 33: Hauling Drone (plain-string description in registry.lua)
LANGUAGE.skill_name_33								= "Unlock: Hauling Drone"
LANGUAGE.skill_desc_33								= "^2Unlocks the Hauling Drone.\n^2Rapidly transports props and items but cannot attack."

-- 34: Light Construction (uses DescriptionAttributes)
LANGUAGE.skill_name_34								= "Light Construction"

-- 35-37: Trigger Discipline (uses DescriptionAttributes)
LANGUAGE.skill_name_35								= "Trigger Discipline I"
LANGUAGE.skill_name_36								= "Trigger Discipline II"
LANGUAGE.skill_name_37								= "Trigger Discipline III"

-- 38: Palsy (uses DescriptionAttributes)
LANGUAGE.skill_name_38								= "Debuff: Palsy"

-- 39: Quick Draw (uses DescriptionAttributes)
LANGUAGE.skill_name_39								= "Quick Draw"

-- 40: Focus I (uses DescriptionAttributes)
LANGUAGE.skill_name_40								= "Focus I"

-- 41: Quick Reload (uses DescriptionAttributes)
LANGUAGE.skill_name_41								= "Quick Reload"

-- 42: Worthiness I (uses DescriptionAttributes)
LANGUAGE.skill_name_42								= "Worthiness I"

-- 43: Worthiness II (uses DescriptionAttributes)
LANGUAGE.skill_name_43								= "Worthiness II"

-- 44: Egocentric (uses DescriptionAttributes)
LANGUAGE.skill_name_44								= "Egocentric"

-- 45: Vitality II (uses DescriptionAttributes)
LANGUAGE.skill_name_45								= "Vitality II"

-- 46: Zeal (uses DescriptionAttributes)
LANGUAGE.skill_name_46								= "Zeal"

-- 47: Hemophilia (uses DescriptionAttributes)
LANGUAGE.skill_name_47								= "Debuff: Hemophilia"

-- 48-52: Battler (uses DescriptionAttributes)
LANGUAGE.skill_name_48								= "Battler I"
LANGUAGE.skill_name_49								= "Battler II"
LANGUAGE.skill_name_50								= "Battler III"
LANGUAGE.skill_name_51								= "Battler IV"
LANGUAGE.skill_name_52								= "Battler V"

-- 53: Heavy Strikes (uses DescriptionAttributes)
LANGUAGE.skill_name_53								= "Heavy Strikes"

-- 54: Last Stand (plain-string description in registry.lua)
LANGUAGE.skill_name_54								= "Last Stand"
LANGUAGE.skill_desc_54								= "^2Double melee damage when below {{LastStandHealthThresholdPercent}}% health.\n^1{{LastStandDamagePenalty}}x melee weapon damage at any other time."

-- 55: Noodle Arms (uses DescriptionAttributes)
LANGUAGE.skill_name_55								= "Debuff: Noodle Arms"

-- 56: Glass Weapons (plain-string description in registry.lua)
LANGUAGE.skill_name_56								= "Glass Weapons"
LANGUAGE.skill_desc_56								= "^2{{GlassWeaponsDamageBonus}}x melee weapon damage vs. zombies.\n^1Your melee weapons have a {{GlassWeaponsBreakChance}}% chance to break when hitting a zombie."

-- 57: Cannonball (uses DescriptionAttributes)
LANGUAGE.skill_name_57								= "Cannonball"

LANGUAGE.skill_name_58								= "Debuff: Clumsy"

LANGUAGE.skill_name_59								= "Cheap Tactics"

LANGUAGE.skill_name_60								= "Critical Knuckle"

LANGUAGE.skill_name_61								= "Knuckle Master"

LANGUAGE.skill_name_62								= "Combo Knuckle"
LANGUAGE.skill_desc_62								= "^2Next unarmed strike is {{ComboKnuckleSlowMul}}x faster if hitting something.\n^1Next unarmed attack is {{ComboKnuckleSlowMul}}x slower if not hitting something."

LANGUAGE.skill_name_63								= "Debuff: Late Buyer"

LANGUAGE.skill_name_64								= "Unlock: Crafting Pack"
LANGUAGE.skill_desc_64								= "^2Unlocks purchasing the Sawblade component.\n^2Unlocks purchasing the Electrobattery component.\n^2Unlocks purchasing the CPU Parts component."

LANGUAGE.skill_name_65								= "Jouster"

LANGUAGE.skill_name_66								= "Vitality I"

LANGUAGE.skill_name_67								= "Scavenger's Eyes"
LANGUAGE.skill_desc_67								= "^2See nearby weapons, ammo, and items through walls."

LANGUAGE.skill_name_68								= "Unlock: Arc Zapper"
LANGUAGE.skill_desc_68								= "^2Unlocks purchasing the Arc Zapper.\n^2Zaps zombies that get nearby, and jumps in an arc.\n^2Mid tier deployable and long cooldown.\n^1Requires a steady upkeep of pulse ammo."

LANGUAGE.skill_name_69								= "Taut"

LANGUAGE.skill_name_70								= "Ultra Nimble"

LANGUAGE.skill_name_71								= "Debuff: Frail"

LANGUAGE.skill_name_72								= "Unlock: Medic Cloud Bomb"
LANGUAGE.skill_desc_72								= "^2Unlocks purchasing the Medic Cloud Bomb.\n^2Slowly heals all humans inside the cloud."

LANGUAGE.skill_name_73								= "Smart Targeting"

LANGUAGE.skill_name_74								= "Buyer's Insight"
LANGUAGE.skill_desc_74								= "^2Locate nearby arsenal crates if behind walls.\n^2Locate nearby unplaced arsenal crates on players through walls.\n^2Locate nearby arsenal packs through walls."

LANGUAGE.skill_name_75								= "Glutton"

LANGUAGE.skill_name_76								= "Gourmet"

LANGUAGE.skill_name_77								= "Reinforcer"

LANGUAGE.skill_name_78								= "Worthiness III"

-- 79: Blood Armor (uses DescriptionAttributes)
LANGUAGE.skill_name_79								= "Blood Armor"

-- 80: Regenerator (uses DescriptionAttributes)
LANGUAGE.skill_name_80								= "Regenerator"

-- 81: Weakness (uses DescriptionAttributes)
LANGUAGE.skill_name_81								= "Debuff: Weakness"

-- 82: Preparedness (uses DescriptionAttributes)
LANGUAGE.skill_name_82								= "Preparedness"

-- 83: Safe Fall (uses DescriptionAttributes)
LANGUAGE.skill_name_83								= "Safe Fall"

-- 84: Vitality III (uses DescriptionAttributes)
LANGUAGE.skill_name_84								= "Vitality III"

-- 85: Wide Load (uses DescriptionAttributes)
LANGUAGE.skill_name_85								= "Debuff: Wide Load"

-- 86: Tanker (uses DescriptionAttributes)
LANGUAGE.skill_name_86								= "Tanker"

-- 87: Corrupted Fragment (plain-string description in registry.lua)
LANGUAGE.skill_name_87								= "Unlock: Corrupted Fragment"
LANGUAGE.skill_desc_87								= "^2Unlocks purchasing the Corrupted Fragment.\n^2Goes to corrupted sigils instead."

-- 88: Worthiness IV (uses DescriptionAttributes)
LANGUAGE.skill_name_88								= "Worthiness IV"

-- 89: Forager (uses DescriptionAttributes)
LANGUAGE.skill_name_89								= "Forager"

-- 90: Lanky I (uses DescriptionAttributes)
LANGUAGE.skill_name_90								= "Lanky I"

-- 91: Pitcher (uses DescriptionAttributes)
LANGUAGE.skill_name_91								= "Pitcher"

-- 92: Blast Proof (uses DescriptionAttributes)
LANGUAGE.skill_name_92								= "Blast Proof"

-- 93: Master Chef (uses DescriptionAttributes)
LANGUAGE.skill_name_93								= "Master Chef"

-- 94: Sugar Rush (uses DescriptionAttributes)
LANGUAGE.skill_name_94								= "Sugar Rush"

-- 95: Strength Shot Gun (plain-string description in registry.lua)
LANGUAGE.skill_name_95								= "Unlock: Strength Shot Gun"
LANGUAGE.skill_desc_95								= "^2Unlocks purchasing the Strength Shot Gun.\n^2Target damage +{{StrengthShotgunBonusPercent}}% for {{StrengthShotgunBaseDuration}} seconds.\n^2Extra damage is given to you as points.\n^1Target is not healed."

-- 96: Stable Hull (uses DescriptionAttributes)
LANGUAGE.skill_name_96								= "Stable Hull"

-- 97: Lightweight (uses DescriptionAttributes)
LANGUAGE.skill_name_97								= "Lightweight"

-- 98: Agile I (uses DescriptionAttributes)
LANGUAGE.skill_name_98								= "Agile I"

-- 99: Cryo Gas Grenade (plain-string description in registry.lua)
LANGUAGE.skill_name_99								= "Unlock: Cryo Gas Grenade"
LANGUAGE.skill_desc_99								= "^2Unlocks purchasing the Cryo Gas Grenade.\n^2Variant of the Corrosive Gas Grenade.\n^2Cryo gas deals a bit of damage over time.\n^2Zombies are slowed in the effect."

-- 100: Soft Detonation (uses DescriptionAttributes)
LANGUAGE.skill_name_100								= "Soft Detonation"

-- 101: Stockpiling (uses DescriptionAttributes)
LANGUAGE.skill_name_101								= "Stockpiling"

-- 102: Supplier's Acuity (plain-string description in registry.lua)
LANGUAGE.skill_name_102								= "Supplier's Acuity"
LANGUAGE.skill_desc_102								= "^2Locate nearby resupply boxes if behind walls.\n^2Locate nearby unplaced resupply boxes on players through walls.\n^2Locate nearby resupply packs through walls."

-- 103: Refiner's Vision (plain-string description in registry.lua)
LANGUAGE.skill_name_103								= "Refiner's Vision"
LANGUAGE.skill_desc_103								= "^2Locate nearby remantlers if behind walls.\n^2Locate nearby unplaced remantlers on players through walls."

-- 104: Rocket Turret (plain-string description in registry.lua)
LANGUAGE.skill_name_104								= "Unlock: Rocket Turret"
LANGUAGE.skill_desc_104								= "^2Unlocks purchasing the Rocket Turret.\n^2Fires explosives instead of SMG ammo.\n^2Deals damage in a radius.\n^2High tier deployable."

-- 105: Recoverable Solution (uses DescriptionAttributes)
LANGUAGE.skill_name_105								= "Recoverable Solution"

-- 106: Orphic Focus (uses DescriptionAttributes)
LANGUAGE.skill_name_106								= "Orphic Focus"

-- 107: Iron Blood (uses DescriptionAttributes)
LANGUAGE.skill_name_107								= "Iron Blood"

-- 108: Bloodletter (uses DescriptionAttributes)
LANGUAGE.skill_name_108								= "Bloodletter"

-- 109: Haemostasis (uses DescriptionAttributes)
LANGUAGE.skill_name_109								= "Haemostasis"

-- 110: Sleight of Hand (uses DescriptionAttributes)
LANGUAGE.skill_name_110								= "Sleight of Hand"

-- 111: Agile II (uses DescriptionAttributes)
LANGUAGE.skill_name_111								= "Agile II"

-- 112: Agile III (uses DescriptionAttributes)
LANGUAGE.skill_name_112								= "Agile III"

-- 113-115: Biology (uses DescriptionAttributes)
LANGUAGE.skill_name_113								= "Biology I"
LANGUAGE.skill_name_114								= "Biology II"
LANGUAGE.skill_name_115								= "Biology III"

-- 116-117: Focus (uses DescriptionAttributes)
LANGUAGE.skill_name_116								= "Focus II"
LANGUAGE.skill_name_117								= "Focus III"

-- 118: Alacrity (plain-string description in registry.lua)
LANGUAGE.skill_name_118								= "Alacrity"
LANGUAGE.skill_desc_118								= "^2Your starting item can be a random special trinket."

-- 119: Sure Step (uses DescriptionAttributes)
LANGUAGE.skill_name_119								= "Sure Step"

-- 120: Intrepid (uses DescriptionAttributes)
LANGUAGE.skill_name_120								= "Intrepid"

-- 121: Cardiotonic (uses DescriptionAttributes)
LANGUAGE.skill_name_121								= "Cardiotonic"

-- 122: Bloodlust (plain-string description in registry.lua)
LANGUAGE.skill_name_122								= "Bloodlust"
LANGUAGE.skill_desc_122								= "^2Gain phantom health equal to half the damage taken from zombies.\n^2Lose phantom health equal to any healing received.\n^2Phantom health decreases by {{BloodlustDecayPerSecond}} per second.\n^2Heal {{BloodlustHealFromPhantomMul}}x of damage done with melee from remaining phantom health.\n^1{{BloodlustHealingReceivedMul}}% healing received."

-- 123: Scourer (plain-string description in registry.lua)
LANGUAGE.skill_name_123								= "Scourer"
LANGUAGE.skill_desc_123								= "^2Earn end of wave points as scrap.\n^1Earn no end of wave points."

-- 124: Lanky II (uses DescriptionAttributes)
LANGUAGE.skill_name_124								= "Lanky II"

-- 125: Antidote Handgun (plain-string description in registry.lua)
LANGUAGE.skill_name_125								= "Unlock: Antidote Handgun"
LANGUAGE.skill_desc_125								= "^2Unlocks purchasing the Antidote Handgun.\n^2Fires piercing blasts that heal poison greatly.\n^2Cleanses statuses from targets with a small point gain.\n^1Does not heal health."

-- 126: Dispersion (uses DescriptionAttributes)
LANGUAGE.skill_name_126								= "Dispersion"

-- 127-128: Motion (uses DescriptionAttributes)
LANGUAGE.skill_name_127								= "Motion II"
LANGUAGE.skill_name_128								= "Motion III"

-- 129: Slow (uses DescriptionAttributes)
LANGUAGE.skill_name_129								= "Debuff: Slow"

-- 130: Brash (uses DescriptionAttributes)
LANGUAGE.skill_name_130								= "Brash"

-- 131: Concentrated Effect (uses DescriptionAttributes)
LANGUAGE.skill_name_131								= "Concentrated Effect"

-- 132: Circulation (uses DescriptionAttributes)
LANGUAGE.skill_name_132								= "Circulation"

-- 133: Sanguine (uses DescriptionAttributes)
LANGUAGE.skill_name_133								= "Sanguine"

-- 134: Antigen (uses DescriptionAttributes)
LANGUAGE.skill_name_134								= "Antigen"

-- 135: Instruments (uses DescriptionAttributes)
LANGUAGE.skill_name_135								= "Instruments"

-- 136-137: Handy (uses DescriptionAttributes)
LANGUAGE.skill_name_136								= "Handy IV"
LANGUAGE.skill_name_137								= "Handy V"

-- 138: Field Technician (uses DescriptionAttributes)
LANGUAGE.skill_name_138								= "Field Technician"

-- 139: Biology IV (uses DescriptionAttributes)
LANGUAGE.skill_name_139								= "Biology IV"

-- 140: Surgeon IV (uses DescriptionAttributes)
LANGUAGE.skill_name_140								= "Surgeon IV"

-- 141: Delibration (uses DescriptionAttributes)
LANGUAGE.skill_name_141								= "Delibration"

-- 142: Drift (uses DescriptionAttributes)
LANGUAGE.skill_name_142								= "Drift"

-- 143: Warp (uses DescriptionAttributes)
LANGUAGE.skill_name_143								= "Warp"

-- 144: Level Headed (uses DescriptionAttributes)
LANGUAGE.skill_name_144								= "Level Headed"

-- 145: Robust (uses DescriptionAttributes)
LANGUAGE.skill_name_145								= "Robust"

-- 146: Stowage (uses DescriptionAttributes)
LANGUAGE.skill_name_146								= "Stowage"

-- 147: Wooism (plain-string description in registry.lua)
LANGUAGE.skill_name_147								= "Wooism"
LANGUAGE.skill_desc_147								= "^2No accuracy penalty from moving or jumping.\n^2No accuracy bonus from crouching or ironsighting."

-- 148: Unbound (uses DescriptionAttributes)
LANGUAGE.skill_name_148								= "Unbound"