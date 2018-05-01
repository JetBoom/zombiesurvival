INC_SERVER()

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModel("models/props_junk/TrashDumpster02b.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self:SetCustomCollisionCheck(true)
	self:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end
end

function ENT:OnTakeDamage(dmginfo)
	local inflictor = dmginfo:GetInflictor():IsValid() and dmginfo:GetInflictor() or dmginfo:GetAttacker()
	if dmginfo:GetDamage() <= 0 or not inflictor:IsProjectile() then return end

	local attacker = dmginfo:GetAttacker()
	if not (attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN) then
		local emitter = self:GetEmitter()
		if emitter and emitter:IsValid() and emitter.GetAmmo and emitter:GetAmmo() > 0 then
			self:SetLastDamaged(CurTime())
			self:EmitSound("ambient/energy/weld2.wav", 65, 255, 0.6)

			local ammousage = (dmginfo:GetDamage() / 10) + (emitter.CarryOver or 0)
			local floor = math.floor(ammousage)
			local owner = emitter:GetObjectOwner()

			emitter.CarryOver = ammousage - floor
			emitter:SetAmmo(math.max(emitter:GetAmmo() - floor, 0))

			if owner:IsValidLivingHuman() then
				owner:AddPoints(dmginfo:GetDamage() * 0.02)

				if emitter:GetAmmo() == 0 then
					owner:SendDeployableOutOfAmmoMessage(emitter)
				end
			end
		end
	end
end
