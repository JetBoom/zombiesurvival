AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "리벳건"
	SWEP.Description = "못을 높은 속도로 발사한다. 멀리에서 바리케이드를 보강할 수 있다."
	SWEP.Slot = 1
	SWEP.SlotPos = 0
	
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60
	
	SWEP.HUD3DBone = "ValveBiped.square"
	SWEP.HUD3DPos = Vector(1.1, 0.25, -2)
	SWEP.HUD3DScale = 0.015
	SWEP.VElements = {
		["slidecover3"] = { type = "Model", model = "models/props_junk/metalbucket02a.mdl", bone = "ValveBiped.hammer", rel = "back", pos = Vector(0, -0.4, 7), angle = Angle(0, 0, -90), size = Vector(0.06, 0.3, 0.143), color = Color(255, 170, 0, 255), surpresslightning = false, material = "models/props_c17/canister_propane01a", skin = 0, bodygroup = {} },
		["back"] = { type = "Model", model = "models/props_c17/canister_propane01a.mdl", bone = "ValveBiped.hammer", rel = "element_name", pos = Vector(0, -8, -4.666), angle = Angle(0, 0, 90), size = Vector(0.083, 0.083, 0.052), color = Color(255, 170, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["element_name"] = { type = "Model", model = "models/props_pipes/pipe03_lcurve02_short.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.131, 1.399, 1.042), angle = Angle(0, 90, 0), size = Vector(0.045, 0.074, 0.083), color = Color(255, 170, 0, 255), surpresslightning = false, material = "models/props_c17/consolebox01a", skin = 0, bodygroup = {} }
	}
end
SWEP.WElements = {
	["slidecover3"] = { type = "Model", model = "models/props_junk/metalbucket02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.63, 2.119, -3.625), angle = Angle(0, 90, 5.002), size = Vector(0.093, 0.218, 0.123), color = Color(255, 170, 0, 255), surpresslightning = false, material = "models/props_c17/canister_propane01a", skin = 0, bodygroup = {} },
	["nozzle"] = { type = "Model", model = "models/props_junk/ibeam01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10.477, 2.201, -4.301), angle = Angle(-4.928, 0, 85.244), size = Vector(0.03, 0.075, 0.075), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/chairchrome01", skin = 0, bodygroup = {} },
	["element_name"] = { type = "Model", model = "models/props_pipes/pipe03_lcurve02_short.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.354, 1.514, 0.699), angle = Angle(-5.206, 90, 0), size = Vector(0.045, 0.074, 0.083), color = Color(255, 170, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["back"] = { type = "Model", model = "models/props_c17/canister_propane01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.106, 1.95, -2.876), angle = Angle(-95.669, 0, 0), size = Vector(0.104, 0.104, 0.064), color = Color(255, 170, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
sound.Add(
{
	name = "Weapon_Nailgun.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 100,
	pitch = {90,110},
	sound = "ambient/machines/catapult_throw.wav"
})
SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false
SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "GaussEnergy"
SWEP.Primary.Sound = Sound("Weapon_Nailgun.Single")
SWEP.ReloadSound = Sound("weapons/357/357_reload3.wav")
SWEP.Primary.Damage = 70
SWEP.Primary.Delay = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Recoil = 8
SWEP.Primary.KnockbackScale = 3
SWEP.ConeMax = 0.5
SWEP.ConeMin = 0.05

SWEP.IronSightsPos = Vector(-5.95, 3, 2.75)
SWEP.IronSightsAng = Vector(-0.15, -1, 2)
function SWEP.BulletCallback(attacker, tr, dmginfo)
	local hitent = tr.Entity
	local effectdata = EffectData()
	effectdata:SetOrigin(tr.HitPos)
	effectdata:SetNormal(tr.HitNormal)
	util.Effect("MetalSpark", effectdata)
	if hitent:IsValid() then
		if hitent:IsNailed() then
			local healstrength =  30 * (attacker.HumanRepairMultiplier or 1)
			if hitent:GetBarricadeRepairs()<hitent:GetMaxBarricadeRepairs() then
				hitent:SetBarricadeRepairs(math.min(hitent:GetBarricadeRepairs() + math.min(hitent:GetBarricadeRepairs(), healstrength), hitent:GetMaxBarricadeRepairs()))
				hitent:EmitSound("buttons/lever"..math.random(7, 8)..".wav", 70, math.random(100, 105))
				effectdata:SetMagnitude(1)
				util.Effect("nailrepaired", effectdata, true, true)
			end
		end
	end
	GenericBulletCallback(attacker, tr, dmginfo)
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextReload(CurTime() + 0.7)
	self:EmitFireSound()
	self:TakeAmmo()
	self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:SecondaryAttack()

end
function SWEP:Reload()
	self.ConeMul = 1
	if self.Owner:IsHolding() then return end
	if self:GetIronsights() then
		self:SetIronsights(false)
	end
	if self:GetNextReload() <= CurTime() and self:DefaultReload(ACT_VM_RELOAD) then
		self.IdleAnimation = CurTime() + self:SequenceDuration()
		self:SetNextReload(self.IdleAnimation)
		self:SetNextPrimaryAttack(self.IdleAnimation+0.2)
		self.Owner:DoReloadEvent()
		if self.ReloadSound then
			self:EmitSound(self.ReloadSound)
		end
	end
end