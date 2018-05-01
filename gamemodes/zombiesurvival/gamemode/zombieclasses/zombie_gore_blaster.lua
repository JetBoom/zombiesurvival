CLASS.Base = "zombie"

CLASS.Name = "Gore Blaster Zombie"
CLASS.TranslationName = "class_zombie_gore_blaster"
CLASS.Description = "description_zombie_gore_blaster"
CLASS.Help = "controls_zombie_gore_blaster"

CLASS.BetterVersion = "Chem Burster"

CLASS.Wave = 0
CLASS.Unlocked = true

CLASS.Health = 220
CLASS.Speed = 180
CLASS.Revives = false

CLASS.Points = CLASS.Health/GM.HumanoidZombiePointRatio

CLASS.SWEP = "weapon_zs_zombie_gore_blaster"

function CLASS:PlayPainSound(pl)
	pl:EmitSound("npc/zombie/zombie_pain"..math.random(6)..".wav", 75, math.random(87, 92))

	pl.NextPainSound = CurTime() + .5

	return true
end

function CLASS:PlayDeathSound(pl)
	pl:EmitSound("npc/zombie/zombie_die"..math.random(3)..".wav", 70, math.random(87, 92))

	return true
end

if SERVER then

function CLASS:ReviveCallback(pl, attacker, dmginfo)
	return false
end

function CLASS:ProcessDamage(pl, dmginfo)
	return false
end

function CLASS:OnKilled(pl, attacker, inflictor, suicide, headshot, dmginfo, assister)
	if suicide then return end

	local pos = pl:WorldSpaceCenter()

	local effectdata = EffectData()
		effectdata:SetOrigin(pos)
	util.Effect("gore_blast", effectdata, true)
		effectdata:SetEntity(pl)
	util.Effect("gib_player", effectdata, true, true)

	pl:GodEnable()
	util.BlastDamageEx(pl:GetActiveWeapon() or pl, pl, pos, 105, 3, DMG_GENERIC, 0.7)
	pl:GodDisable()

	return true
end

end

if not CLIENT then return end

CLASS.Icon = "zombiesurvival/killicons/zombie"
CLASS.IconColor = Color(255, 0, 0)

local matSkin = Material("models/Zombie_Classic/Zombie_Classic_sheet.vtf")

function CLASS:PrePlayerDraw(pl)
	render.ModelMaterialOverride(matSkin)
	render.SetColorModulation(1, 0, 0)
end

function CLASS:PostPlayerDraw(pl)
	render.ModelMaterialOverride()
	render.SetColorModulation(1, 1, 1)
end
