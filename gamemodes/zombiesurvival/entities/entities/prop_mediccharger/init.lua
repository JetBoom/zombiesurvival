AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
local function RefreshChargerOwners(pl)
	for _, ent in pairs(ents.FindByClass("prop_mediccharger")) do
		if ent:IsValid() and ent:GetObjectOwner() == pl then
			ent:SetObjectOwner(NULL)
		end
	end
end
hook.Add("PlayerDisconnected", "MCharger.PlayerDisconnected", RefreshChargerOwners)
hook.Add("OnPlayerChangedTeam", "MCharger.OnPlayerChangedTeam", RefreshChargerOwners)

function ENT:Initialize()
	self:SetModel("models/props_combine/health_charger001.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetPlaybackRate(1)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end
	self:SetAmmoCount(self.DefaultAmmoCount)
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

		local pos = self:LocalToWorld(self:OBBCenter())

		local effectdata = EffectData()
			effectdata:SetOrigin(pos)
		util.Effect("Explosion", effectdata, true, true)
		self.Owner:CenterNotify(COLOR_RED, translate.ClientGet(owner,"charger_destroyed"))
		local amount = math.ceil(self:GetAmmoCount() * 0.33)
		while amount > 0 do
			local todrop = math.min(amount, 50)
			amount = amount - todrop
			local ent = ents.Create("prop_ammo")
			if ent:IsValid() then
				local heading = VectorRand():GetNormalized()
				ent:SetAmmoType("battery")
				ent:SetAmmo(todrop)
				ent:SetPos(pos + heading * 8)
				ent:SetAngles(VectorRand():Angle())
				ent:Spawn()

				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:ApplyForceOffset(heading * math.Rand(8000, 32000), pos)
				end
			end
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

function ENT:OnPackedUp(pl)
	pl:GiveEmptyWeapon("weapon_zs_mediccharger")
	pl:GiveAmmo(1, "charger")

	pl:PushPackedItem(self:GetClass(), self:GetObjectHealth())

	self:Remove()
end

function ENT:Think()
	if self.Destroyed then
		self:Remove()
	end
	local curammo = self:GetAmmoCount()
	local lastCharge = self.LastRecharge or -1
	if lastCharge + self.AmmoRechargeDelay <= CurTime() then
		self:SetAmmoCount(math.Min(curammo + self.AmmoRechargeAmount, self.MaxAmmo))
		self.LastRecharge = CurTime()
	end
end

local NextUse = {}
function ENT:Use(activator, caller)
	if activator:Team() ~= TEAM_HUMAN or not activator:Alive() or GAMEMODE:GetWave() <= 0 or activator:Health() == activator:GetMaxHealth() then return end

	if not self:GetObjectOwner():IsValid() then
		self:SetObjectOwner(activator)
	end

	local owner = self:GetObjectOwner()
	local owneruid = owner:IsValid() and owner:UniqueID() or "nobody"
	local myuid = activator:UniqueID()


	if activator:IsValid() and activator:IsPlayer() and activator:Team() == owner:Team() and activator:Alive() and gamemode.Call("PlayerCanBeHealed", activator)and self:GetAmmoCount() >= 0 then
		if CurTime() < (NextUse[myuid] or 0) then
			activator:CenterNotify(COLOR_RED, translate.ClientGet(activator, "no_ammo_here"))
		return
		end

		NextUse[myuid] = CurTime() + 10* (self.Owner.buffMedic and 0.75 or 1)

		net.Start("zs_nextchargeruse")
			net.WriteFloat(NextUse[myuid])
		net.Send(activator)
		local health, maxhealth = activator:Health(), activator:GetMaxHealth()
		local multiplier = owner.HumanHealMultiplier or 1
		local toheal = math.min(self:GetAmmoCount(), math.ceil(math.min(15 * multiplier, maxhealth - health)))
		activator:SetHealth(health + toheal)
		self:SetAmmoCount(self:GetAmmoCount() - toheal*2,0)
		self:EmitSound("items/medshot4.wav")
		if activator != owner then
			owner.ChargerUsedByOthers = owner.ChargerUsedByOthers + 1
			if owner.ChargerUsedByOthers % 2 == 0 then
				owner:AddPoints(1)
				net.Start("zs_commission")
				net.WriteEntity(self)
				net.WriteEntity(activator)
				net.WriteUInt(1, 16)
				net.Send(owner)
			end	
		end
	end
		self.Close = CurTime() + 3
end