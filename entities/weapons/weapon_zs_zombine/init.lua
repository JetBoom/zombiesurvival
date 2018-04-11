AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.MoanDelay = 1
SWEP.SpawnUseDelay = 5

function SWEP:Equip()

	self:SetSpawnedTime( CurTime() + self.SpawnUseDelay )

end

function SWEP:Reload()
	if CurTime() < self:GetNextSecondaryFire() then return end
	self:SetNextSecondaryFire(CurTime() + self.MoanDelay)

	if self:IsMoaning() then
		self:StopMoaning()
	else
		self:StartMoaning()
	end

end

function SWEP:SecondaryAttack()
	if CLIENT then return end
	if not self.Owner:OnGround() || self:GetGrenading() then return end
	if CurTime() < self:GetSpawnedTime() then return end

	self:DoAlert()
	
	self:SetGrenading(true)
	
	if SERVER and self.Owner:IsValid() then
		self.Owner:GiveStatus( "zombine_grenade" )
	end	
	
	self:SendWeaponAnim(ACT_VM_THROW)
	self:StopMoaning()
	
	self:TakeAmmo()
	
	self:SetGrenadeTime( CurTime() + 0.5 ) // the +2 is for how long the third person grenade pull animation is.
	
	
end
