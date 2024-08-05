AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "레일건"
	SWEP.Description = "고전압을 이용해 열화 우라늄 탄환을 발사한다. 매우 강력한 한발을 쏜다."
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
SWEP.Primary.Damage = 270
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1
SWEP.ReloadDelay = SWEP.Primary.Delay

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "combinecannon"
SWEP.Primary.DefaultClip = 1

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.ConeMax = 0.01
SWEP.ConeMin = 0

SWEP.IronSightsPos = Vector(5.559, -8.633, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)


SWEP.WalkSpeed = 140

SWEP.TracerName = "AirboatGunHeavyTracer"

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	local e = EffectData()
		e:SetOrigin(tr.HitPos)
		e:SetNormal(tr.HitNormal)
		e:SetRadius(8)
		e:SetMagnitude(1)
		e:SetScale(1)
	util.Effect("cball_bounce", e)
	if ent:IsPlayer() and ent:Team() == TEAM_UNDEAD and tr.HitGroup == HITGROUP_HEAD then
		local edata = EffectData()
		edata:SetOrigin(tr.HitPos)
		edata:SetNormal(tr.HitNormal)
		edata:SetMagnitude(5)
		edata:SetScale(1)
		util.Effect("hit_hunter", edata) 
	end
	GenericBulletCallback(attacker, tr, dmginfo)
end

if CLIENT then
	SWEP.IronsightsMultiplier = 0.1

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
		local hw,hh = scrw * 0.5, scrh * 0.5
		local screenscale = BetterScreenScale()
		local gradsize = math.ceil(size * 0.14)
		local line = 38 * screenscale
		
		surface.SetDrawColor(0,145,255,16)
		surface.DrawRect(0,0,scrw,scrh)
		for i=0,6 do
			local rectsize = math.floor(screenscale * 44) + i * math.floor(130 * screenscale)
			local hrectsize = rectsize * 0.5
			surface.SetDrawColor(0,145,255,math.max(35,25 + i * 30))
			surface.DrawOutlinedRect(hw-hrectsize,hh-hrectsize,rectsize,rectsize)
		end
		if scrw > size then
			local extra = (scrw - size) * 0.5
			for i=0,12 do
				surface.SetDrawColor(0,145,255, math.max(10,255 - i * 21.25))
				surface.DrawLine(hw,i*line,hw,i*line+line)
				surface.DrawLine(hw,scrh-i*line,hw,scrh-i*line-line)
				surface.DrawLine(i*line+extra,hh,i*line+line+extra,hh)
				surface.DrawLine(scrw-i*line-extra,hh,scrw-i*line-line-extra,hh)
			end
			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawRect(0, 0, extra, scrh)
			surface.DrawRect(scrw - extra, 0, extra, scrh)
		end
		if scrh > size then
			local extra = (scrh - size) * 0.5
			for i=0,12 do
				surface.SetDrawColor(0,145,255, math.max(10,255 - i * 21.25))
				surface.DrawLine(hw,i*line+extra,hw,i*line+line+extra)
				surface.DrawLine(hw,scrh-i*line-extra,hw,scrh-i*line-line-extra)
				surface.DrawLine(i*line,hh,i*line+line,hh)
				surface.DrawLine(scrw-i*line,hh,scrw-i*line-line,hh)
			end
			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawRect(0, 0, scrw, extra)
			surface.DrawRect(0, scrh - extra, scrw, extra)
		end
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
