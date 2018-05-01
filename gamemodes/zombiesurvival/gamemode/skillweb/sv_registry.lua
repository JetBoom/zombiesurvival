GM:SetSkillModifierFunction(SKILLMOD_HEALTH, function(pl, amount)
	local current = pl:GetMaxHealth()
	local new = 100 + math.Clamp(amount, -99, 1000)
	pl:SetMaxHealth(new)
	pl:SetHealth(math.max(1, pl:Health() / current * new))
end)

GM:SetSkillModifierFunction(SKILLMOD_POINTS, function(pl, amount)
	if not pl.AdjustedStartPointsSkill then
		pl:SetPoints(pl:GetPoints() + amount)
		pl.AdjustedStartPointsSkill = true
	end
end)

GM:SetSkillModifierFunction(SKILLMOD_SCRAP_START, function(pl, amount)
	if not pl.AdjustedStartScrapSkill then
		pl:GiveAmmo(amount, "scrap")
		pl.AdjustedStartScrapSkill = true
	end
end)

GM:SetSkillModifierFunction(SKILLMOD_FOODRECOVERY_MUL, function(pl, amount)
	pl.FoodRecoveryMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_FALLDAMAGE_DAMAGE_MUL, function(pl, amount)
	pl.FallDamageDamageMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_FALLDAMAGE_RECOVERY_MUL, function(pl, amount)
	pl.FallDamageRecoveryMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_POINT_MULTIPLIER, function(pl, amount)
	pl.PointIncomeMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
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

GM:SetSkillModifierFunction(SKILLMOD_MANHACK_HEALTH_MUL, function(pl, amount)
	pl.ManhackHealthMul = math.Clamp(amount + 1.0, 0.01, 10.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MANHACK_DAMAGE_MUL, function(pl, amount)
	pl.ManhackDamageMul = math.Clamp(amount + 1.0, 0.0, 10.0)
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

GM:AddSkillModifier(SKILL_TURRETOVERLOAD, SKILLMOD_TURRET_SCANSPEED_MUL, 1.0)

GM:AddSkillModifier(SKILL_TURRETLOCK, SKILLMOD_TURRET_SCANANGLE_MUL, -0.9)

GM:AddSkillModifier(SKILL_WORTHINESS1, SKILLMOD_POINTS, -3)
GM:AddSkillModifier(SKILL_WORTHINESS2, SKILLMOD_POINTS, -3)
GM:AddSkillModifier(SKILL_WORTHINESS3, SKILLMOD_POINTS, -3)
GM:AddSkillModifier(SKILL_WORTHINESS4, SKILLMOD_POINTS, -3)

GM:AddSkillModifier(SKILL_LOADEDHULL, SKILLMOD_CONTROLLABLE_HEALTH_MUL, -0.1)

GM:AddSkillModifier(SKILL_REINFORCEDHULL, SKILLMOD_CONTROLLABLE_HEALTH_MUL, 0.25)
GM:AddSkillModifier(SKILL_REINFORCEDHULL, SKILLMOD_CONTROLLABLE_HANDLING_MUL, -0.2)
GM:AddSkillModifier(SKILL_REINFORCEDHULL, SKILLMOD_CONTROLLABLE_SPEED_MUL, -0.2)

GM:AddSkillModifier(SKILL_REINFORCEDBLADES, SKILLMOD_MANHACK_DAMAGE_MUL, 0.25)
GM:AddSkillModifier(SKILL_REINFORCEDBLADES, SKILLMOD_MANHACK_HEALTH_MUL, -0.15)

GM:AddSkillModifier(SKILL_STABLEHULL, SKILLMOD_CONTROLLABLE_SPEED_MUL, -0.2)

GM:AddSkillModifier(SKILL_AVIATOR, SKILLMOD_CONTROLLABLE_SPEED_MUL, 0.4)
GM:AddSkillModifier(SKILL_AVIATOR, SKILLMOD_CONTROLLABLE_HANDLING_MUL, 0.4)
GM:AddSkillModifier(SKILL_AVIATOR, SKILLMOD_CONTROLLABLE_HEALTH_MUL, -0.25)

GM:AddSkillModifier(SKILL_LIGHTCONSTRUCT, SKILLMOD_DEPLOYABLE_HEALTH_MUL, -0.25)
GM:AddSkillModifier(SKILL_LIGHTCONSTRUCT, SKILLMOD_DEPLOYABLE_PACKTIME_MUL, -0.25)

GM:AddSkillModifier(SKILL_FORAGER, SKILLMOD_RESUPPLY_DELAY_MUL, 0.2)

GM:AddSkillModifier(SKILL_FIELDAMP, SKILLMOD_FIELD_RANGE_MUL, -0.4)
GM:AddSkillModifier(SKILL_FIELDAMP, SKILLMOD_FIELD_DELAY_MUL, -0.2)

GM:AddSkillModifier(SKILL_TECHNICIAN, SKILLMOD_FIELD_RANGE_MUL, 0.03)
GM:AddSkillModifier(SKILL_TECHNICIAN, SKILLMOD_FIELD_DELAY_MUL, -0.03)

GM:AddSkillModifier(SKILL_PITCHER, SKILLMOD_PROP_THROW_STRENGTH_MUL, 0.1)
