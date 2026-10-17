-- Shared numeric constants used both by gameplay code and by skill descriptions
-- (via {{Key}} interpolation in translate.SkillDescription).
-- Changing a value here updates the corresponding skill text automatically.

GAMEMODE = GAMEMODE or GM
GAMEMODE.SkillConstants = GAMEMODE.SkillConstants or {}

-- Threshold is a percent of max health. Code divides by 100.
GAMEMODE.SkillConstants.LastStandHealthThresholdPercent = 25
GAMEMODE.SkillConstants.LastStandDamageBonus   = 2      -- x2 melee damage below threshold
GAMEMODE.SkillConstants.LastStandDamagePenalty = 0.85   -- x0.85 melee damage otherwise

GAMEMODE.SkillConstants.GlassWeaponsDamageBonus  = 3.5
GAMEMODE.SkillConstants.GlassWeaponsBreakChance  = 50   -- shown in desc; code toggles every other hit

GAMEMODE.SkillConstants.ComboKnuckleFastMul = 0.5       -- hitdelay / 2
GAMEMODE.SkillConstants.ComboKnuckleSlowMul = 2         -- hitdelay * 2

GAMEMODE.SkillConstants.BloodlustPhantomGainMul     = 0.5   -- phantom gained per damage taken
GAMEMODE.SkillConstants.BloodlustDecayPerSecond     = 5     -- phantom lost per second
GAMEMODE.SkillConstants.BloodlustHealFromPhantomMul = 0.25  -- heal from remaining phantom on melee hit
GAMEMODE.SkillConstants.BloodlustHealingReceivedMul = -50   -- % healing received modifier

GAMEMODE.SkillConstants.StrengthShotgunBonusPercent = 25
GAMEMODE.SkillConstants.StrengthShotgunBaseDuration = 10

-- =========================================================================
-- Description-only constants
-- =========================================================================

GAMEMODE.SkillConstants.MeleeSpeedOnKillDuration          = 10   -- seconds
GAMEMODE.SkillConstants.MeleeSpeedOnKillFastDuration      = 10   -- code: status_zs "adrenalineamp"

GAMEMODE.SkillConstants.RegeneratorHealAmount             = 1    -- health per tick
GAMEMODE.SkillConstants.RegeneratorInterval               = 6    -- seconds
GAMEMODE.SkillConstants.RegeneratorHealthThresholdPercent = 60   -- % of max health

GAMEMODE.SkillConstants.BloodArmorRegenAmount             = 1    -- blood armor per tick
GAMEMODE.SkillConstants.BloodArmorRegenInterval           = 8    -- seconds

GAMEMODE.SkillConstants.IronBloodHealthThresholdPercent   = 50   -- % of max health

GAMEMODE.SkillConstants.SugarRushSpeedBonus               = 35   -- code: weapon_zs_basefood
GAMEMODE.SkillConstants.SugarRushDuration                 = 14   -- code: status "adrenalineamp"

GAMEMODE.SkillConstants.ReinforcerDuration                = 2    -- seconds, code: ReinforceEnd
GAMEMODE.SkillConstants.ReinforcerDamageReductionPercent  = 8    -- 1 - 0.92

GAMEMODE.SkillConstants.TwinVolleyBulletMultiplier        = 2
GAMEMODE.SkillConstants.TwinVolleyAmmoUsagePercent        = 100  -- +100%
GAMEMODE.SkillConstants.TwinVolleyFireDelayPercent        = 50   -- +50%

GAMEMODE.SkillConstants.BiocleanserBlocksCount            = 1
GAMEMODE.SkillConstants.BiocleanserCooldown               = 20   -- code: TrinketRecharges.biocleanser

GAMEMODE.SkillConstants.BloodpackArmorAmount              = 20   -- code: GM:PlayerHurt
GAMEMODE.SkillConstants.BloodpackHealthThresholdPercent   = 50   -- % of max health

GAMEMODE.SkillConstants.MeleeLegDamageHitsRequired        = 5

GAMEMODE.SkillConstants.ExtMagMinClipSize                 = 8
GAMEMODE.SkillConstants.ExtMagBonusPercent                = 25

GAMEMODE.SkillConstants.RefinedMaxTier                    = 3

GAMEMODE.SkillConstants.FrailHealthCapPercent             = 25   -- % of max health

GAMEMODE.SkillConstants.WideLoadPhaseSpeedLimit           = 1
GAMEMODE.SkillConstants.WideLoadPhaseGraceSeconds         = 6

GAMEMODE.SkillConstants.MasterChefMarkDuration            = 1    -- seconds

GAMEMODE.SkillConstants.StockpileCollectMultiplier        = 2