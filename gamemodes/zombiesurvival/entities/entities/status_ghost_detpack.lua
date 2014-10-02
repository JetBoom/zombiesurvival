AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status_ghost_base"

ENT.GhostModel = Model("models/weapons/w_c4_planted.mdl")
ENT.GhostRotation = Angle(270, 0, 0)
ENT.GhostEntity = "prop_detpack"
ENT.GhostWeapon = "weapon_zs_detpack"
ENT.GhostFlatGround = false
ENT.GhostDistance = 8

function ENT:CustomValidate(tr)
	local hitent = tr.Entity
	if hitent and hitent:IsValid() and hitent:GetClass() ~= "func_tracktrain" and hitent:GetClass() ~= "func_movelinear" then
		return false
	end

	return true
end
