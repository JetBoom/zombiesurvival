AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status_ghost_base"

ENT.GhostModel = Model("models/props_lab/lab_flourescentlight002b.mdl")
ENT.GhostRotation = Angle(0, 0, 0)
ENT.GhostNoTraceRot = Angle(90, 0, 0)
ENT.GhostEntity = "prop_ffemitter"
ENT.GhostWeapon = "weapon_zs_ffemitter"
ENT.GhostDistance = 70
ENT.GhostHitNormalOffset = 2.9
ENT.GhostRotateFunction = "Forward"
ENT.GhostNotBarricadeProp = true
ENT.GhostArrow = true
ENT.GhostArrowUp = true
