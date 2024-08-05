AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function SWEP:Deploy()
	self.Owner.SkipCrow = true
	return true
end

function SWEP:Holster()
	local owner = self.Owner
	if owner:IsValid() then
		owner:StopSound("NPC_Crow.Flap")
		owner:SetAllowFullRotation(false)
	end
end
SWEP.OnRemove = SWEP.Holster

function SWEP:Think()
	local owner = self.Owner	
	
	if owner:KeyDown(IN_USE) then
		if !owner.NextPhoenix or owner.NextPhoenix <= GAMEMODE:GetWave() then
			self:Explode()
		end
		
		-- owner.NextPhoenix = 0
	end

	if owner:KeyDown(IN_WALK) then
		owner:TrySpawnAsGoreChild()
		return
	end

	local fullrot = not owner:OnGround()
	if owner:GetAllowFullRotation() ~= fullrot then
		owner:SetAllowFullRotation(fullrot)
	end

	if owner:IsOnGround() or not owner:KeyDown(IN_JUMP) or not owner:KeyDown(IN_FORWARD) then
		if self.PlayFlap then
			owner:StopSound("NPC_Crow.Flap")
			self.PlayFlap = nil
		end
	else
		if not self.PlayFlap then
			owner:EmitSound("NPC_Crow.Flap")
			self.PlayFlap = true
		end
	end

	local peckend = self:GetPeckEndTime()
	if peckend == 0 or CurTime() < peckend then return end
	self:SetPeckEndTime(0)

	local trace = owner:TraceLine(14, MASK_SOLID)
	local ent = NULL
	if trace.Entity then
		ent = trace.Entity
	end

	owner:ResetSpeed()

	if ent:IsValid() and ent:IsPlayer() and ent:Team() == TEAM_UNDEAD and ent:Alive() and ent:GetZombieClassTable().Name == "Crow" then
		ent:TakeSpecialDamage(2, DMG_SLASH, owner, self)
	end
	
end

function SWEP:PrimaryAttack()
	if CurTime() < self:GetNextPrimaryFire() or not self.Owner:IsOnGround() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	self.Owner:EmitSound("NPC_Crow.Squawk")
	self.Owner.EatAnim = CurTime() + 2

	self:SetPeckEndTime(CurTime() + 1)

	self.Owner:SetSpeed(1)
	
	local owner = self.Owner
	
	local start = owner:EyePos()
	local dir = owner:GetAimVector():GetNormal()
	
	timer.Create("CrowAttack" .. owner:UniqueID(), self.MeleeDelay, 1, function()
		local trace = util.TraceLine({
			start = start,
			endpos = start + dir * 12,
			filter = {self, owner},
			mask = MASK_SOLID
		})
		
		if IsValid(trace.Entity) then
			if trace.Entity:IsNailed() then
				trace.Entity:TakeDamage(math.random(self.Primary.MinDamage, self.Primary.MaxDamage), owner, self)
			end
		end
	end)
end

function SWEP:SecondaryAttack()
	if CurTime() < self:GetNextSecondaryFire() then return end
	self:SetNextSecondaryFire(CurTime() + 1.6)

	self.Owner:EmitSound("NPC_Crow.Alert")
end

function SWEP:Reload()
	self:SecondaryAttack()
	return false
end

function SWEP:Explode()
	local owner = self.Owner
	
	self:SetPhoenixKey(true)
	local players = {}
	local cpos = self:LocalToWorld(self:OBBCenter())
	for _, v in pairs(player.GetAll()) do
		local ppos = v:LocalToWorld(v:OBBCenter())
		if ppos:Distance(cpos) <= self.BOMB_DISTANCE and v:Team() != owner:Team() and v:Alive() then
			local trace = util.TraceHull({
				start = cpos,
				endpos = ppos,
				filter = {owner, self, ents.FindByName("prop_physics")},
				mins = Vector(-10, -10, -10),
				maxs = Vector(10, 10, 10),
				mask = MASK_SHOT_HULL
			})
			if trace.Hit and !trace.HitSky and !trace.HitWorld then
				table.insert(players, v)
			end
		end
	end
	
	for _, v in pairs(players) do
		v:TakeDamage(math.max(8 * (v:GetPos():Distance(self:GetPos())), 2) / self.BOMB_DISTANCE, owner or NULL, self or NULL)
	end
	
	owner:Kill()
	
	owner.NextPhoenix = GAMEMODE:GetWave() + 1
end