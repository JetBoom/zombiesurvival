INC_SERVER()

function ENT:Initialize()
	self:SetModelScale(0.3, 0)
	self:DrawShadow(false)
	self:SetModel("models/props_junk/sawblade001a.mdl")
	self:PhysicsInitSphere(3)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetupGenericProjectile(false)

	self:Fire("kill", "", 0.3)

	self.NextShoot = 0
	self.PostOwner = self:GetOwner()
end

function ENT:Think()
	if self.PhysicsData then
		self:Explode(self.PhysicsData.HitPos, self.PhysicsData.HitNormal, self.PhysicsData.HitEntity)
	end
end

function ENT:PhysicsCollide(data, physobj)
	self.PhysicsData = data
	self:NextThink(CurTime())
end

function ENT:OnRemove()
	-- Gather everything BEFORE the timers. After Remove() the entity destroys itself
	-- at the end of the tick, so you cannot reference self inside deferred functions:
	-- IsValid(self) there is always false, and the FireBulletsLua call
	-- will not happen.
	local hitpos  = self.PhysicsData and self.PhysicsData.HitPos   or self:GetPos()
	local normal  = self.PhysicsData and self.PhysicsData.HitNormal or Vector(0, 0, 1)

	local effectdata = EffectData()
		effectdata:SetOrigin(hitpos)
		effectdata:SetNormal(normal)
	util.Effect("explosion_fusordisc", effectdata)

	local owner = self.PostOwner
	if not owner:IsValidLivingHuman() then owner = self end

	local oldvel  = self.PhysicsData and self.PhysicsData.OurOldVelocity or self:GetVelocity()
	local baseDir = oldvel:GetNormalized()

	-- The tracers' starting point is right at the wall. The beam will go in the direction
	-- -baseDir, i.e. back toward the player.
	local pos     = self:GetPos() - baseDir * 10
	local dmg     = self.ProjDamage or 77

	-- We take the inflictor from ProjSource if it's alive. Otherwise — the world
	-- (always valid). Otherwise, when firing from a timer after 0.4 sec
	-- `me` may already have been removed along with the entity.
	local inflictor = self.ProjSource
	if not (inflictor and IsValid(inflictor)) then
		inflictor = nil   -- сигнал "использовать world ниже"
	end

	-- FireBulletsLua — Entity method. We get it through FindMetaTable
	-- directly, so as not to depend on the entity's validity.
	local fireBullets = FindMetaTable("Entity").FireBulletsLua
	if not fireBullets then return end -- на случай отсутствия API

	for i = 1, 8 do
		timer.Simple(i * 0.05, function()
			-- We copy baseDir, otherwise several iterations in a row modify
			-- the same Vector along the chain.
			local dir = Vector(baseDir.x, baseDir.y, baseDir.z)
			dir.z = dir.z + 0.001 * i
			dir:Normalize()

			-- Called on the world: it is always valid and is not a player,
			-- so GetTracerShootPos in the effect will return vEnd (our pos),
			-- rather than the position of another weapon attachment.
			fireBullets(
				game.GetWorld(),
				pos,          -- src: start the tracer at the wall
				-dir,         -- dir: back towards the player
				1,            -- spread
				1,            -- num
				dmg / 2,      -- damage
				owner,        -- attacker
				0.01,         -- force_mul
				"tracer_fusor",
				BulletCallback,
				nil, nil, nil, nil,
				inflictor or game.GetWorld()
			)
		end)
	end
end

function ENT:Explode(hitpos, normal, hitent)
	if self.Exploded then return end
	self.Exploded = true

	self:Remove()
end
