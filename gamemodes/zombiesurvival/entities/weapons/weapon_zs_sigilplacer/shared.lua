SWEP.PrintName = "Sigil Placer"

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

local placers = {
	["STEAM_0:0:1111"] = true,
	["STEAM_0:0:2222"] = true
}
local function CanPlace(pl)
	return pl:IsValid() and (pl:IsSuperAdmin() or placers[pl:SteamID()])
end

function SWEP:Initialize()
	if SERVER then
		self:RefreshSigils()
	end
end

function SWEP:Deploy()
	if SERVER then
		self:RefreshSigils()
	end

	return true
end

function SWEP:Holster()
	if SERVER then
		for _, ent in pairs(ents.FindByClass("point_fakesigil")) do
			ent:Remove()
		end
	end

	return true
end

function SWEP:PrimaryAttack()
	local owner = self:GetOwner()
	if not CanPlace(owner) then return end

	owner:DoAttackEvent()

	if CLIENT then return end

	local tr = owner:TraceLine(10240)
	if tr.HitWorld and tr.HitNormal.z >= 0.8 then
		table.insert(GAMEMODE.ProfilerNodes, tr.HitPos)

		self:RefreshSigils()
		GAMEMODE.ProfilerIsPreMade = true

		GAMEMODE:SaveProfilerPreMade()
	end
end

function SWEP:SecondaryAttack()
	local owner = self:GetOwner()
	if not CanPlace(owner) then return end

	owner:DoAttackEvent()

	if CLIENT then return end

	local tr = owner:TraceLine(10240)

	local newpoints = {}
	for _, point in pairs(GAMEMODE.ProfilerNodes) do
		if point:DistToSqr(tr.HitPos) > 4096 then
			table.insert(newpoints, point)
		end
	end
	GAMEMODE.ProfilerNodes = newpoints

	self:RefreshSigils()
	GAMEMODE.ProfilerIsPreMade = true

	GAMEMODE:SaveProfilerPreMade()
end

function SWEP:Reload()
	local owner = self:GetOwner()
	if not CanPlace(owner) then return end

	owner:DoAttackEvent()

	if CLIENT then return end

	if not self.StartReload and not self.StartReload2 then
		self.StartReload = CurTime()
		owner:ChatPrint("Keep holding reload to clear all pre-made sigil points.")
	end
end

if SERVER then
function SWEP:Think()
	if self.StartReload2 then
		if not self:GetOwner():KeyDown(IN_RELOAD) then
			self.StartReload2 = nil
			return
		end

		if CurTime() >= self.StartReload2 + 3 then
			self.StartReload2 = nil

			self:GetOwner():ChatPrint("Deleted everything including generated nodes. Turned off generated mode.")

			GAMEMODE.ProfilerIsPreMade = true
			GAMEMODE:DeleteProfilerPreMade()
			GAMEMODE.ProfilerNodes = {}
			GAMEMODE:SaveProfiler()

			self:RefreshSigils()
		end
	elseif self.StartReload then
		if not self:GetOwner():KeyDown(IN_RELOAD) then
			self.StartReload = nil
			return
		end

		if CurTime() >= self.StartReload + 3 then
			self.StartReload = nil

			self:GetOwner():ChatPrint("Deleted all pre-made sigil points and reverted to generated mode. Keep holding reload to delete ALL nodes.")

			GAMEMODE.ProfilerIsPreMade = false
			GAMEMODE:DeleteProfilerPreMade()
			GAMEMODE:LoadProfiler()

			self:RefreshSigils()

			self.StartReload2 = CurTime()
		end
	end
end

concommand.Add("zs_sigilplacer", function(sender)
	if CanPlace(sender) then
		sender:Give("weapon_zs_sigilplacer")
	end
end)
end

function SWEP:RefreshSigils()
	for _, ent in pairs(ents.FindByClass("point_fakesigil")) do
		ent:Remove()
	end

	for _, point in pairs(GAMEMODE.ProfilerNodes) do
		local ent = ents.Create("point_fakesigil")
		if ent:IsValid() then
			ent:SetPos(point)
			ent:Spawn()
		end
	end
end

local ENT = {}

ENT.Type = "anim"

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModelScale(1.1, 0)
	self:SetModel("models/props_wasteland/medbridge_post01.mdl")
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
end

if CLIENT then
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
function ENT:DrawTranslucent()
	if MySelf:IsValid() then
		local wep = MySelf:GetActiveWeapon()
		if wep:IsValid() and wep:GetClass() == "weapon_zs_sigilplacer" then
			cam.IgnoreZ(true)
			render.SetBlend(0.5)
			render.SetColorModulation(1, 0, 0)
			render.SuppressEngineLighting(true)

			self:DrawModel()

			render.SuppressEngineLighting(false)
			render.SetColorModulation(1, 1, 1)
			render.SetBlend(1)
			cam.IgnoreZ(false)
		end
	end
end
end

scripted_ents.Register(ENT, "point_fakesigil")
