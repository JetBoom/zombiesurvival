AddCSLuaFile()

ENT.Type        = "anim"
ENT.RenderGroup = RENDERGROUP_OTHER

-- One global OnViewModelChanged hook instead of an entity hook for each
-- zs_hands instance. Previously, N players = N hooks, each called when
-- the viewmodel changed for ANY player. Now — one hook with O(1) lookup
-- of zs_hands via owner:GetHands().
if not ZS_Hands_ViewModelHook then
	ZS_Hands_ViewModelHook = true

	hook.Add("OnViewModelChanged", "ZS_Hands_ViewModelChanged", function(vm, old, new)
		if not IsValid(vm) then return end

		local owner = vm:GetOwner()
		if not IsValid(owner) then return end

		local hands = owner:GetHands()
		if IsValid(hands) and hands.AttachToViewmodel then
			hands:AttachToViewmodel(vm)
		end
	end)
end

function ENT:Initialize()
	self:SetNotSolid(true)
	self:DrawShadow(false)
	self:SetTransmitWithParent(true)
end

function ENT:DoSetup(ply)
	ply:SetHands(self)
	self:SetOwner(ply)

	local info = GAMEMODE:GetHandsModel(ply)
	if info then
		self:SetModel(info.model)
		self:SetSkin(info.skin)
		self:SetBodyGroups(info.body)
	end

	local vm = ply:GetViewModel(0)
	self:AttachToViewmodel(vm)

	vm:DeleteOnRemove(self)
	ply:DeleteOnRemove(self)
end

local defaultcolor = Vector(62.0 / 255.0, 88.0 / 255.0, 106.0 / 255.0)
function ENT:GetPlayerColor()
	local owner = self:GetOwner()
	if IsValid(owner) and owner.GetPlayerColor then
		return owner:GetPlayerColor()
	end
	return defaultcolor
end

function ENT:AttachToViewmodel(vm)
	if not IsValid(vm) then return end

	self:AddEffects(EF_BONEMERGE)
	self:SetParent(vm)
	self:SetMoveType(MOVETYPE_NONE)

	self:SetPos(Vector(0, 0, 0))
	self:SetAngles(Angle(0, 0, 0))
end

function ENT:Draw()
	if MySelf:CallZombieFunction1("DrawHands", self) then return end

	self:DrawModel()
end