GM.BeatSetHumanDefault = "defaulthuman"
GM.BeatSetZombieDefault = "defaultzombiev2"

GM.ItemCategoryIcons = {
	[ITEMCAT_GUNS] = "icon16/gun.png",
	[ITEMCAT_AMMO] = "icon16/box.png",
	[ITEMCAT_MELEE] = "icon16/cog.png",
	[ITEMCAT_TOOLS] = "icon16/wrench.png",
	[ITEMCAT_OTHER] = "icon16/world.png",
	[ITEMCAT_RETURNS] = "icon16/user_delete.png"
}

GM.LifeStatsLifeTime = 5

GM.RewardIcons = {}
GM.RewardIcons["weapon_zs_barricadekit"] = "models/props_debris/wood_board05a.mdl"

GM.CrosshairColor = Color(CreateClientConVar("zs_crosshair_colr", "255", true, false):GetInt(), CreateClientConVar("zs_crosshair_colg", "255", true, false):GetInt(), CreateClientConVar("zs_crosshair_colb", "255", true, false):GetInt(), 220)
GM.CrosshairColor2 = Color(CreateClientConVar("zs_crosshair_colr2", "220", true, false):GetInt(), CreateClientConVar("zs_crosshair_colg2", "0", true, false):GetInt(), CreateClientConVar("zs_crosshair_colb2", "0", true, false):GetInt(), 220)
cvars.AddChangeCallback("zs_crosshair_colr", function(cvar, oldvalue, newvalue) GAMEMODE.CrosshairColor.r = tonumber(newvalue) or 255 end)
cvars.AddChangeCallback("zs_crosshair_colg", function(cvar, oldvalue, newvalue) GAMEMODE.CrosshairColor.g = tonumber(newvalue) or 255 end)
cvars.AddChangeCallback("zs_crosshair_colb", function(cvar, oldvalue, newvalue) GAMEMODE.CrosshairColor.b = tonumber(newvalue) or 255 end)
cvars.AddChangeCallback("zs_crosshair_colr2", function(cvar, oldvalue, newvalue) GAMEMODE.CrosshairColor2.r = tonumber(newvalue) or 255 end)
cvars.AddChangeCallback("zs_crosshair_colg2", function(cvar, oldvalue, newvalue) GAMEMODE.CrosshairColor2.g = tonumber(newvalue) or 255 end)
cvars.AddChangeCallback("zs_crosshair_colb2", function(cvar, oldvalue, newvalue) GAMEMODE.CrosshairColor2.b = tonumber(newvalue) or 255 end)

GM.FilmMode = CreateClientConVar("zs_filmmode", "0", true, false):GetBool()
cvars.AddChangeCallback("zs_filmmode", function(cvar, oldvalue, newvalue)
	GAMEMODE.FilmMode = tonumber(newvalue) == 1

	GAMEMODE:EvaluateFilmMode()
end)

CreateClientConVar("zs_noredeem", "0", true, true)
CreateClientConVar("zs_alwaysvolunteer", "0", true, true)
CreateClientConVar("zs_nobosspick", "0", true, true)

GM.SuicideOnChangeClass = CreateClientConVar("zs_suicideonchange", "1", true, false):GetBool()
cvars.AddChangeCallback("zs_suicideonchange", function(cvar, oldvalue, newvalue)
	GAMEMODE.SuicideOnChangeClass = tonumber(newvalue) == 1
end)

GM.BeatsEnabled = CreateClientConVar("zs_beats", "1", true, false):GetBool()
cvars.AddChangeCallback("zs_beats", function(cvar, oldvalue, newvalue)
	GAMEMODE.BeatsEnabled = tonumber(newvalue) == 1
end)

GM.BeatsVolume = math.Clamp(CreateClientConVar("zs_beatsvolume", 80, true, false):GetInt(), 0, 100) / 100
cvars.AddChangeCallback("zs_beatsvolume", function(cvar, oldvalue, newvalue)
	GAMEMODE.BeatsVolume = math.Clamp(tonumber(newvalue) or 0, 0, 100) / 100
end)

GM.AlwaysShowNails = CreateClientConVar("zs_alwaysshownails", "0", true, false):GetBool()
cvars.AddChangeCallback("zs_alwaysshownails", function(cvar, oldvalue, newvalue)
	GAMEMODE.AlwaysShowNails = tonumber(newvalue) == 1
end)

GM.NoCrosshairRotate = CreateClientConVar("zs_nocrosshairrotate", "0", true, false):GetBool()
cvars.AddChangeCallback("zs_nocrosshairrotate", function(cvar, oldvalue, newvalue)
	GAMEMODE.NoCrosshairRotate = tonumber(newvalue) == 1
end)

GM.TransparencyRadius = math.Clamp(CreateClientConVar("zs_transparencyradius", 140, true, false):GetInt(), 0, 512)
cvars.AddChangeCallback("zs_transparencyradius", function(cvar, oldvalue, newvalue)
	GAMEMODE.TransparencyRadius = math.Clamp(tonumber(newvalue) or 0, 0, 512)
end)

GM.MovementViewRoll = CreateClientConVar("zs_movementviewroll", "1", true, false):GetBool()
cvars.AddChangeCallback("zs_movementviewroll", function(cvar, oldvalue, newvalue)
	GAMEMODE.MovementViewRoll = tonumber(newvalue) == 1
end)

GM.WeaponHUDMode = CreateClientConVar("zs_weaponhudmode", "0", true, false):GetInt()
cvars.AddChangeCallback("zs_weaponhudmode", function(cvar, oldvalue, newvalue)
	GAMEMODE.WeaponHUDMode = tonumber(newvalue) or 0
end)

GM.DrawPainFlash = CreateClientConVar("zs_drawpainflash", "1", true, false):GetBool()
cvars.AddChangeCallback("zs_drawpainflash", function(cvar, oldvalue, newvalue)
	GAMEMODE.DrawPainFlash = tonumber(newvalue) == 1
end)

CreateConVar( "cl_playercolor", "0.24 0.34 0.41", { FCVAR_ARCHIVE, FCVAR_USERINFO }, "The value is a Vector - so between 0-1 - not between 0-255" )
CreateConVar( "cl_weaponcolor", "0.30 1.80 2.10", { FCVAR_ARCHIVE, FCVAR_USERINFO }, "The value is a Vector - so between 0-1 - not between 0-255" )

GM.BeatSetHuman = CreateClientConVar("zs_beatset_human", "default", true, false):GetString()
cvars.AddChangeCallback("zs_beatset_human", function(cvar, oldvalue, newvalue)
	newvalue = tostring(newvalue)
	if newvalue == "default" then
		GAMEMODE.BeatSetHuman = GAMEMODE.BeatSetHumanDefault
	else
		GAMEMODE.BeatSetHuman = newvalue
	end
end)
if GM.BeatSetHuman == "default" then
	GM.BeatSetHuman = GM.BeatSetHumanDefault
end

GM.BeatSetZombie = CreateClientConVar("zs_beatset_zombie", "default", true, false):GetString()
cvars.AddChangeCallback("zs_beatset_zombie", function(cvar, oldvalue, newvalue)
	newvalue = tostring(newvalue)
	if newvalue == "default" then
		GAMEMODE.BeatSetZombie = GAMEMODE.BeatSetZombieDefault
	else
		GAMEMODE.BeatSetZombie = newvalue
	end
end)
if GM.BeatSetZombie == "default" then
	GM.BeatSetZombie = GM.BeatSetZombieDefault
end
