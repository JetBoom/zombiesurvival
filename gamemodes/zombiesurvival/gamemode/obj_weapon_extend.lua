local meta = FindMetaTable("Weapon")

meta.GetNextPrimaryAttack = meta.GetNextPrimaryFire
meta.GetNextSecondaryAttack = meta.GetNextSecondaryFire
meta.SetNextPrimaryAttack = meta.SetNextPrimaryFire
meta.SetNextSecondaryAttack = meta.SetNextSecondaryFire

function meta:ValidPrimaryAmmo()
	local ammotype = self:GetPrimaryAmmoTypeString()
	if ammotype and ammotype ~= "none" and ammotype ~= "dummy" then
		return ammotype
	end
end

function meta:ValidSecondaryAmmo()
	local ammotype = self:GetSecondaryAmmoTypeString()
	if ammotype and ammotype ~= "none" and ammotype ~= "dummy" then
		return ammotype
	end
end

function meta:SetNextReload(fTime)
	self:SetDTFloat(DT_WEAPON_BASE_FLOAT_NEXTRELOAD, fTime)
end

function meta:GetNextReload()
	return self:GetDTFloat(DT_WEAPON_BASE_FLOAT_NEXTRELOAD)
end

function meta:SetReloadStart(fTime)
	self:SetDTFloat(DT_WEAPON_BASE_FLOAT_RELOADSTART, fTime)
end

function meta:GetReloadStart()
	return self:GetDTFloat(DT_WEAPON_BASE_FLOAT_RELOADSTART)
end

function meta:SetReloadFinish(fTime)
	self:SetDTFloat(DT_WEAPON_BASE_FLOAT_RELOADEND, fTime)
end

function meta:GetReloadFinish()
	return self:GetDTFloat(DT_WEAPON_BASE_FLOAT_RELOADEND)
end

function meta:GetPrimaryAmmoCount()
	return self:GetOwner():GetAmmoCount(self.Primary.Ammo) + self:Clip1()
end

function meta:GetSecondaryAmmoCount()
	return self:GetOwner():GetAmmoCount(self.Secondary.Ammo) + self:Clip2()
end

function meta:HideViewAndWorldModel()
	self:HideViewModel()
	self:HideWorldModel()
end
meta.HideWorldAndViewModel = meta.HideViewAndWorldModel

function meta:GetCombinedPrimaryAmmo()
	return self:Clip1() + self:GetOwner():GetAmmoCount(self.Primary.Ammo)
end

function meta:GetCombinedSecondaryAmmo()
	return self:Clip2() + self:GetOwner():GetAmmoCount(self.Secondary.Ammo)
end

function meta:TakeCombinedPrimaryAmmo(amount)
	local ammotype = self.Primary.Ammo
	local owner = self:GetOwner()
	local clip = self:Clip1()
	local reserves = owner:GetAmmoCount(ammotype)

	amount = math.min(reserves + clip, amount)

	local fromreserves = math.min(reserves, amount)
	if fromreserves > 0 then
		amount = amount - fromreserves
		self:GetOwner():RemoveAmmo(fromreserves, ammotype)
	end

	local fromclip = math.min(clip, amount)
	if fromclip > 0 then
		self:SetClip1(clip - fromclip)
	end
end

function meta:TakeCombinedSecondaryAmmo(amount)
	local ammotype = self.Secondary.Ammo
	local owner = self:GetOwner()
	local clip = self:Clip2()
	local reserves = owner:GetAmmoCount(ammotype)

	amount = math.min(reserves + clip, amount)

	local fromreserves = math.min(reserves, amount)
	if fromreserves > 0 then
		amount = amount - fromreserves
		self:GetOwner():RemoveAmmo(fromreserves, ammotype)
	end

	local fromclip = math.min(clip, amount)
	if fromclip > 0 then
		self:SetClip2(clip - fromclip)
	end
end

local TranslatedAmmo = {}
TranslatedAmmo[-1] = "none"
TranslatedAmmo[0] = "none"
TranslatedAmmo[1] = "ar2"
TranslatedAmmo[2] = "alyxgun"
TranslatedAmmo[3] = "pistol"
TranslatedAmmo[4] = "smg1"
TranslatedAmmo[5] = "357"
TranslatedAmmo[6] = "xbowbolt"
TranslatedAmmo[7] = "buckshot"
TranslatedAmmo[8] = "rpg_round"
TranslatedAmmo[9] = "smg1_grenade"
TranslatedAmmo[10] = "sniperround"
TranslatedAmmo[11] = "sniperpenetratedround"
TranslatedAmmo[12] = "grenade"
TranslatedAmmo[13] = "thumper"
TranslatedAmmo[14] = "gravity"
TranslatedAmmo[14] = "battery"
TranslatedAmmo[15] = "gaussenergy"
TranslatedAmmo[16] = "combinecannon"
TranslatedAmmo[17] = "airboatgun"
TranslatedAmmo[18] = "striderminigun"
TranslatedAmmo[19] = "helicoptergun"
TranslatedAmmo[20] = "ar2altfire"
TranslatedAmmo[21] = "slam"

function meta:GetPrimaryAmmoTypeString()
	if self.Primary and self.Primary.Ammo then return string.lower(self.Primary.Ammo) end
	return TranslatedAmmo[self:GetPrimaryAmmoType()] or "none"
end

function meta:GetSecondaryAmmoTypeString()
	if self.Secondary and self.Secondary.Ammo then return string.lower(self.Secondary.Ammo) end
	return TranslatedAmmo[self:GetSecondaryAmmoType()] or "none"
end
