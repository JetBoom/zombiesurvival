AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status_ghost_base"

ENT.GhostModel = Model("models/props_c17/light_domelight02_off.mdl")
ENT.GhostRotation = Angle(90, 0, 0)
ENT.GhostNoTraceRot = Angle(270, 0, 0)
ENT.GhostHitNormalOffset = 0
ENT.GhostEntity = "prop_camera"
ENT.GhostWeapon = "weapon_zs_camera"
ENT.GhostFlatGround = false
ENT.GhostDistance = 32
ENT.GhostArrow = true
ENT.GhostArrowUp = true
