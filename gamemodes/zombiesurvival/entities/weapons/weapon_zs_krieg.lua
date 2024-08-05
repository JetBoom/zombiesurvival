AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'크리그' 돌격 소총"
	SWEP.Description = "좀비의 머리 타격 시 전기 충격을 주어 어지럽게 한다."
	SWEP.Slot = 2
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.sg552_Parent"
	SWEP.HUD3DPos = Vector(-2.791, -5.597, -2.984)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.04
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = Model( "models/weapons/cstrike/c_rif_sg552.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_rif_sg552.mdl" )
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_SG552.Single")
SWEP.Primary.Damage = 25
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.12
SWEP.Primary.Recoil = 4.158
SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_AR2

SWEP.ConeMax = 0.3291
SWEP.ConeMin = 0.0787

SWEP.WalkSpeed = SPEED_SLOW
SWEP.IronSightsPos = Vector(-2.52, 3.819, 3.599)
SWEP.IronSightsAng = Vector(0, 0, 0)

function SWEP:SetIronsights(b)
	self:SetDTBool(0, b)
	if self.IronSightsHoldType then
		if b then
			self:SetWeaponHoldType(self.IronSightsHoldType)
		else
			self:SetWeaponHoldType(self.HoldType)
		end
	end

	gamemode.Call("WeaponDeployed", self.Owner, self)
end


function SWEP:Think()
	local owner = self.Owner
	if not self.Owner:KeyDown(IN_ATTACK2) then
		if self:GetIronsights() then
			self:SetIronsights(false)
		end
	end
end

local function BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	if (not tr.HitWorld) and IsValid(ent) then
                    
    end
	if ent:IsValid() then
		if ent:IsPlayer() then
			if ent:Team() == TEAM_UNDEAD and tempknockback then
				tempknockback[ent] = ent:GetVelocity()
			end
			
			if tr.HitGroup == HITGROUP_HEAD then
				local edata = EffectData()
				edata:SetEntity(ent)
				edata:SetMagnitude(5)
				edata:SetScale(1)
				util.Effect("TeslaHitBoxes", edata) 
				ent:EmitSound("ambient/energy/zap"..math.random(1,9)..".wav")
				if SERVER and ent:IsPlayer() then
                    local eyeang = ent:EyeAngles()

                    local j = 15
                    eyeang.pitch = math.Clamp(eyeang.pitch + math.Rand(-j, j), -90, 90)
                    eyeang.yaw = math.Clamp(eyeang.yaw + math.Rand(-j, j), -90, 90)
                    ent:SetEyeAngles(eyeang)
                end
			end
		else
			local phys = ent:GetPhysicsObject()
			if ent:GetMoveType() == MOVETYPE_VPHYSICS and phys:IsValid() and phys:IsMoveable() then
				ent:SetPhysicsAttacker(attacker)
			end
		end		
	end
	GenericBulletCallback(attacker, tr, dmginfo)
end

SWEP.BulletCallback = BulletCallback

if CLIENT then
SWEP.IronsightsMultiplier = 0.35
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
