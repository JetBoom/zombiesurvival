AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local function RefreshCrateOwners(pl)
	for _, ent in pairs(ents.FindByClass("prop_resupplybox")) do
		if ent:IsValid() and ent:GetObjectOwner() == pl then
			ent:SetObjectOwner(NULL)
		end
	end
end
hook.Add("PlayerDisconnected", "ResupplyBox.PlayerDisconnected", RefreshCrateOwners)
hook.Add("OnPlayerChangedTeam", "ResupplyBox.OnPlayerChangedTeam", RefreshCrateOwners)

function ENT:Initialize()
	self:SetModel("models/Items/ammocrate_ar2.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetPlaybackRate(1)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end

	self:SetMaxObjectHealth(200)
	self:SetObjectHealth(self:GetMaxObjectHealth())
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "maxcratehealth" then
		value = tonumber(value)
		if not value then return end

		self:SetMaxObjectHealth(value)
	elseif key == "cratehealth" then
		value = tonumber(value)
		if not value then return end

		self:SetObjectHealth(value)
	end
end

function ENT:AcceptInput(name, activator, caller, args)
	if name == "setcratehealth" then
		self:KeyValue("cratehealth", args)
		return true
	elseif name == "setmaxcratehealth" then
		self:KeyValue("maxcratehealth", args)
		return true
	end
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)
	if health <= 0 and not self.Destroyed then
		self.Destroyed = true

		local ent = ents.Create("prop_physics")
		if ent:IsValid() then
			ent:SetModel(self:GetModel())
			ent:SetMaterial(self:GetMaterial())
			ent:SetAngles(self:GetAngles())
			ent:SetPos(self:GetPos())
			ent:SetSkin(self:GetSkin() or 0)
			ent:SetColor(self:GetColor())
			ent:Spawn()
			ent:Fire("break", "", 0)
			ent:Fire("kill", "", 0.1)
		end
	end
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)

	local attacker = dmginfo:GetAttacker()
	if not (attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN) then
		self:SetObjectHealth(self:GetObjectHealth() - dmginfo:GetDamage())
		self:ResetLastBarricadeAttacker(attacker, dmginfo)
	end
end

function ENT:AltUse(activator, tr)
	self:PackUp(activator)
end

function ENT:OnPackedUp(pl)
	pl:GiveEmptyWeapon("weapon_zs_resupplybox")
	pl:GiveAmmo(1, "helicoptergun")

	pl:PushPackedItem(self:GetClass(), self:GetObjectHealth())

	self:Remove()
end

function ENT:Think()
	if self.Destroyed then
		self:Remove()
	elseif self.Close and CurTime() >= self.Close then
		self.Close = nil
		self:ResetSequence("open")
		self:EmitSound("items/ammocrate_close.wav")
	end
end

local NextUse = {}
function ENT:Use(activator, caller)
	if activator:Team() ~= TEAM_HUMAN or not activator:Alive() or GAMEMODE:GetWave() <= 0 then return end

	if not self:GetObjectOwner():IsValid() then
		self:SetObjectOwner(activator)
	end

	local owner = self:GetObjectOwner()
	local owneruid = owner:IsValid() and owner:UniqueID() or "nobody"
	local myuid = activator:UniqueID()

	if CurTime() < (NextUse[myuid] or 0) then
		activator:CenterNotify(COLOR_RED, translate.ClientGet(activator, "no_ammo_here"))
		return
	end

	local ammotype
	local wep = activator:GetActiveWeapon()
	if not wep:IsValid() then
		ammotype = "smg1"
	end

	if not ammotype then
		ammotype = wep:GetPrimaryAmmoTypeString()
		if not GAMEMODE.AmmoResupply[ammotype] then
			ammotype = "smg1"
		end
	end

	NextUse[myuid] = CurTime() + 120

	net.Start("zs_nextresupplyuse")
		net.WriteFloat(NextUse[myuid])
	net.Send(activator)

	activator:GiveAmmo(GAMEMODE.AmmoResupply[ammotype], ammotype)
	if activator ~= owner and owner:IsValid() and owner:IsPlayer() and owner:Team() == TEAM_HUMAN then
		owner.ResupplyBoxUsedByOthers = owner.ResupplyBoxUsedByOthers + 1

		if owner.ResupplyBoxUsedByOthers % 2 == 0 then
			owner:AddPoints(1)
		end

		net.Start("zs_commission")
			net.WriteEntity(self)
			net.WriteEntity(activator)
			net.WriteUInt(1, 16)
		net.Send(owner)
	end

	if not self.Close then
		self:ResetSequence("close")
		self:EmitSound("items/ammocrate_open.wav")
	end
	self.Close = CurTime() + 3
end
