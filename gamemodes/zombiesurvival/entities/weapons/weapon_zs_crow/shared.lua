SWEP.ZombieOnly = true
SWEP.IsMelee = true
SWEP.IsCrow = true

SWEP.ViewModel = "models/weapons/v_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 2
SWEP.Primary.MinDamage = 2
SWEP.Primary.MaxDamage = 8
SWEP.MeleeDelay = 1

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo	= "none"

SWEP.KEY_PHOENIX = "Phoenix"
SWEP.BOMB_DISTANCE = 700

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "PhoenixKey")
end

function SWEP:Initialize()
	self:HideViewAndWorldModel()
end

function SWEP:OnRemove()
	local owner = self.Owner
	if owner and owner:IsValid() then
		if owner.Flapping then
			owner:StopSound("NPC_Crow.Flap")
		end
		owner.Flapping = nil
	end
end
SWEP.Holster = SWEP.OnRemove

function SWEP:SetPeckEndTime(time)
	self:SetDTFloat(0, time)
end

function SWEP:GetPeckEndTime()
	return self:GetDTFloat(0)
end

function SWEP:IsPecking()
	return CurTime() < self:GetPeckEndTime()
end