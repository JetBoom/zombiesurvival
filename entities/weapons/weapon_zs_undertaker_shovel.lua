AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Undertaker"

	SWEP.ViewModelFOV = 60

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_junk/shovel01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.363, 1.363, -7.728), angle = Angle(0, 0, 0), size = Vector(0.899, 0.899, 0.899), color = Color(120, 120, 120, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_junk/shovel01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(13, 1.5, -2.5), angle = Angle(-73, 180, 8), size = Vector(1, 1, 1), color = Color(120, 120, 120, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.HoldType = "melee2"

SWEP.DamageType = DMG_CLUB

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/props_junk/shovel01a.mdl"
SWEP.UseHands = true
SWEP.StunDamage = 20

SWEP.MeleeDamage = 40
SWEP.MeleeRange = 75
SWEP.MeleeSize = 1.5
SWEP.MeleeKnockBack = SWEP.MeleeDamage * 2

SWEP.Primary.Delay = 1.2

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.SwingRotation = Angle(0, -90, -60)
SWEP.SwingOffset = Vector(0, 30, -40)
SWEP.SwingTime = 0.3
SWEP.SwingHoldType = "melee"

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(65, 70))
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/shovel/shovel_hit-0"..math.random(4)..".ogg")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
end

function SWEP:CanSecondaryAttack()
	return true
end

local function DartThrow(pl, wep)
	if pl:IsValid() and pl:Alive() and wep:IsValid() then
		if SERVER then
			local startpos = pl:GetShootPos()
			local aimang = pl:EyeAngles()
			local aimvec = pl:GetAimVector()
			local ent = ents.Create("projectile_undertaker_dart")
				if ent:IsValid() then
					ent:SetAngles(aimvec:Angle())
					ent:SetPos(startpos)
					ent:SetOwner(pl)
					ent:Spawn()
					--ent:SetTeamID(TEAM_UNDEAD)
					local phys = ent:GetPhysicsObject()
					if phys:IsValid() then
					phys:SetVelocityInstantaneous(aimang:Forward() * 9000)
				end
			pl:EmitSound("npc/metropolice/pain"..math.random(2, 4)..".wav", 75, math.random(65, 70))
			end
		end
	end
end

function SWEP:SecondaryAttack()
local owner = self.Owner
	if CurTime() < self:GetNextPrimaryFire() or CurTime() < self:GetNextSecondaryFire() or IsValid(owner.FeignDeath) then return end
	if not self:CanSecondaryAttack() then return end
	self:SetNextSecondaryFire(CurTime() + 2)
	self.Owner:EmitSound("npc/combine_soldier/die"..math.random(2, 3)..".wav", 70, math.random(85, 90))
	local owner = self.Owner
	self:SendWeaponAnim(ACT_VM_THROW)
	self.Owner:DoCustomAnimEvent( PLAYERANIMEVENT_ATTACK_GRENADE , 1 )
	
	timer.Simple(0.7, function() DartThrow(owner, self) end)
end

hook.Add( "DoAnimationEvent" , "AnimEventTest" , function( ply , event , data )
	if event == PLAYERANIMEVENT_ATTACK_GRENADE then
		if data == 1 then
			ply:AnimRestartGesture( GESTURE_SLOT_GRENADE, ACT_GMOD_GESTURE_ITEM_THROW, true )
			return ACT_INVALID
		end
	end
end )

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if hitent:IsValid() and hitent:IsPlayer() then
		hitent:AddLegDamage(self.StunDamage)
	end
end

