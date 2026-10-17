-- ============================================================
-- TFA Base / TFA-CSO compatibility with ZS.
-- Shared tables needed by both client and server.
-- ============================================================

TFACompat = TFACompat or {}

-- All known TFA bases that break ghosting, etc.
TFACompat.BaseNames = {
	["tfa_gun_base"]      = true,
	["tfa_cso_base"]      = true,
	["tfa_cso2_base"]     = true,
	["tfa_ins2_base"]     = true,
}

-- Returns true if the weapon (entity/class/table) is a TFA weapon.
-- Argument may be a SWEP table or a weapon entity.
function TFACompat.IsTFA(wep)
	if not wep then return false end

	-- Either an entity or a SWEP table
	local base = wep.Base
	if base and TFACompat.BaseNames[base] then return true end

	if wep.IsTFA or wep.TFAWeapon then return true end

	return false
end

-- Helper check by weapon class registered in weapons.
function TFACompat.IsTFAByClass(class)
	if not class then return false end
	local stored = weapons.GetStored(class)
	return stored and TFACompat.IsTFA(stored) or false
end