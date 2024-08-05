AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "실험용 가우스 레일건"
	SWEP.Description = "고전압을 이용해 중금속 탄환을 초고속으로 발사한다. 그 힘은 좀비 여럿을 관통하기에 충분하다."
	SWEP.Slot = 3
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.sg550_Parent"
	SWEP.HUD3DPos = Vector(-1.558, -5, -2.1)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.04
	
	SWEP.VElements = {
		["upper"] = { type = "Model", model = "models/props_trainstation/pole_448connection002a.mdl", bone = "v_weapon.sg550_Parent", rel = "", pos = Vector(0, -4.715, -24.338), angle = Angle(0, 0, 0), size = Vector(0.1, 0.05, 0.055), color = Color(255, 255, 255, 255), surpresslightning = false, material = "props/metalcrate009a", skin = 0, bodygroup = {} },
		["lower"] = { type = "Model", model = "models/props_trainstation/pole_448connection002a.mdl", bone = "v_weapon.sg550_Parent", rel = "", pos = Vector(0, -1.597, -24.338), angle = Angle(0, 0, 0), size = Vector(0.1, 0.05, 0.055), color = Color(255, 255, 255, 255), surpresslightning = false, material = "props/metalcrate009a", skin = 0, bodygroup = {} }
	}
end

sound.Add(
{
	name = "Weapon_Railgun.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 100,
	sound = "npc/strider/fire.wav"
})

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_snip_sg550.mdl"
SWEP.WorldModel = "models/weapons/w_snip_sg550.mdl"
SWEP.UseHands = true

SWEP.ReloadSound = Sound("Weapon_AWP.ClipOut")
SWEP.Primary.Sound = Sound("Weapon_Railgun.Single")
SWEP.Primary.Damage = 175
SWEP.Primary.NumShots = 2
SWEP.Primary.Delay = 5
SWEP.ReloadDelay = SWEP.Primary.Delay

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "combinecannon"
SWEP.Primary.DefaultClip = 1

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.ConeMax = 0
SWEP.ConeMin = 0

SWEP.IronSightsPos = Vector(5.559, -8.633, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)


SWEP.WalkSpeed = 130

SWEP.TracerName = "AirboatGunHeavyTracer"

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:EmitFireSound()
	self:TakeAmmo()
	owner = self.Owner
	tr = owner:GetEyeTrace()
	local hitw = EffectData()
	hitw:SetRadius(8)
	hitw:SetMagnitude(3)
	hitw:SetScale(1.25)
	if tr.HitWorld or tr.HitSky then 
		hitw:SetOrigin(tr.HitPos)
		hitw:SetNormal(tr.HitNormal)
		util.Effect("cball_bounce", hitw)
	return end
	local tracer = { 
		start = tr.HitPos + tr.Normal * 500,
		endpos = tr.HitPos,
		ignoreworld = true
	}
	outtr = util.TraceLine(tracer)
	firsthit = outtr.HitPos
	local Hitlist = {}
	while outtr.Entity ~= tr.Entity do
		if outtr.Entity:Team() == TEAM_ZOMBIE then
			table.insert(Hitlist,outtr.Entity) 
		else if 
		end
		local retrace = { 
			start = tr.HitPos + tr.Normal * 1000,
			endpos = tr.HitPos,
			ignoreworld = true,
			filter = Hitlist
		}
		outtr = util.TraceLine(retrace)
	end
	for k,v in pairs(Hitlist) do
		if SERVER then
			v:TakeDamage(self.Primary.Damage * 1.3,self.Owner,self)
		end
	end
	self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
	local worldloc = util.TraceLine({ 
		start = firsthit,
		endpos = firsthit + tr.Normal * 10000,
		mask = MASK_NPCWORLDSTATIC
	})
	util.ParticleTracer( self.Primary.TracerName, ,firsthit, worldloc.HitPos, false)
	util.decal("ExplosiveGunshot",firsthit,worldloc.HitPos)
	hitw:SetOrigin(worldloc.HitPos)
	hitw:SetNormal(tr.HitNormal)
	util.Effect("cball_bounce", hitw)
	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 85, 80)
end
	
function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
end

if CLIENT then
	SWEP.IronsightsMultiplier = 0.4

	function SWEP:GetViewModelPosition(pos, ang)
		if self:IsScoped() then
			return pos + ang:Up() * 256, ang
		end

		return self.BaseClass.GetViewModelPosition(self, pos, ang)
	end

	local matScope = Material("zombiesurvival/scope")
	function SWEP:DrawHUDBackground()
		if self:IsScoped() then
			local scrw, scrh = ScrW(), ScrH()
			local size = math.min(scrw, scrh)
			surface.SetMaterial(matScope)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRect((scrw - size) * 0.5, (scrh - size) * 0.5, size, size)
			surface.SetDrawColor(0, 0, 0, 255)
			if scrw > size then
				local extra = (scrw - size) * 0.5
				surface.DrawRect(0, 0, extra, scrh)
				surface.DrawRect(scrw - extra, 0, extra, scrh)
			end
			if scrh > size then
				local extra = (scrh - size) * 0.5
				surface.DrawRect(0, 0, scrw, extra)
				surface.DrawRect(0, scrh - extra, scrw, extra)
			end
		end
	end
end
