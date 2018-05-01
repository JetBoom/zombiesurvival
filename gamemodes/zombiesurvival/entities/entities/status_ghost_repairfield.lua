AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status_ghost_base"

ENT.GhostModel = Model("models/props/de_nuke/smokestack01.mdl")
ENT.GhostRotation = Angle(270, 0, 0)
ENT.GhostEntity = "prop_repairfield"
ENT.GhostWeapon = "weapon_zs_repairfield"
ENT.GhostDistance = 120
ENT.GhostHitNormalOffset = 12
ENT.GhostScale = 0.55
ENT.GhostNotBarricadeProp = true
ENT.GhostEntityWildCard = "prop_repairfield"
