ENT.Type = "anim"
ENT.Base = "prop_baseoutlined"

ENT.NoNails = true

function ENT:HumanHoldable(pl)
	return pl:KeyDown(GAMEMODE.UtilityKey)
end
