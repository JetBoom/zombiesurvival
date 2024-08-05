AddCSLuaFile()

ENT.Base = "projectile_poisonflesh"
ENT.Type = "anim"

ENT.TraceHumanRadius = 350
ENT.TraceManhackRadius = 450

ENT.Target = nil

ENT.MaxHumanVel = 1550
ENT.MinHumanVel = 550

ENT.MaxManhackVel = 900
ENT.MinManhackVel = 450

ENT.SlowDown = Vector(0.92, 0.92, 1)

ENT.Damage = 4

function ENT:Think()
	self.BaseClass.Think(self)
	self:TraceTarget()
end

function ENT:TraceTarget()
	self:TraceHuman()
	self:TraceManhack()
end

function ENT:TraceHuman()
	-- local pos = self:GetPos()
	-- if !self.Target then
		-- for _, v in pairs(ents.FindInSphere(pos, self.TraceHumanRadius)) do
			-- if IsValid(v) and v:IsPlayer() and v:Team() == TEAM_HUMAN and v:Alive() then
				-- self.Target = v
				-- break
			-- end
		-- end
	-- else
		-- local target = self.Target
		-- local phys = self:GetPhysicsObject()
		
		-- if IsValid(phys) and IsValid(target) then
			-- local tpos = target:LocalToWorld(target:OBBCenter())
			-- local dist = tpos:Distance(pos)
			-- local dir = (tpos - pos):GetNormal()
			-- local tvel = target:GetVelocity():Length()
			
			-- if dist <= self.TraceHumanRadius then
				-- local td = {
					-- start = pos,
					-- endpos = tpos,
					-- mask = MASK_SHOT,
					-- filter = {self}
				-- }
				
				-- local tr = util.TraceLine(td)
				
				-- if tr.Hit and tr.Entity == target and tvel >= 280 then
					-- phys:EnableGravity(false)
					-- phys:SetVelocityInstantaneous(dir * math.max(self.MaxHumanVel * (1 - (dist / self.TraceHumanRadius)), self.MinHumanVel))
				-- end
				
				-- target.pukeLockOff = CurTime() + 0.2
				-- self.Target = target
			-- elseif (self.Target.pukeLockOn and self.Target.pukeLockOff <= CurTime()) or (!IsValid(phys) or !IsValid(self.Target)) then
				-- self.Target = nil
				-- local phys = self:GetPhysicsObject()
				-- if IsValid(phys) then
					-- phys:EnableGravity(true)
				-- end
			-- end
		-- end
	-- end
end

function ENT:TraceManhack()
	local pos = self:GetPos()
	if !self.Target then
		for _, v in pairs(ents.FindInSphere(pos, self.TraceManhackRadius)) do
			if IsValid(v) and string.find(v:GetClass(), "prop_*manhack*") or string.find(v:GetClass(), "prop_*drone*") then
				self.Target = v
				-- PrintMessage(3, tostring(v))
				break
			end
		end
	else
		local target = self.Target
		local phys = self:GetPhysicsObject()
		
		if IsValid(phys) and IsValid(target) then
			if string.find(target:GetClass(), "manhack") or string.find(target:GetClass(), "prop_*drone*") then
				local tpos = target:LocalToWorld(target:OBBCenter())
				local dist = tpos:Distance(pos)
				local dir = (tpos - pos):GetNormal()
				
				if dist <= self.TraceHumanRadius then
					local td = {
						start = pos,
						endpos = tpos,
						mask = MASK_SHOT,
						filter = {self}
					}
					
					local tr = util.TraceLine(td)
					
					if tr.Hit and IsValid(tr.Entity) and tr.Entity == target and IsValid(phys) then
						phys:EnableGravity(false)
						phys:SetVelocityInstantaneous(dir * math.max(self.MaxManhackVel * (1 - (dist / self.TraceManhackRadius)), self.MinManhackVel))
					end
				else
					self.Target = nil
					local phys = self:GetPhysicsObject()
					if IsValid(phys) then
						phys:EnableGravity(true)
					end
				end
			end
		end
	end
end

function ENT:Explode(pos, normal, ent)
	self.BaseClass.Explode(self, pos, normal, ent)
	if IsValid(ent) and ent:IsPlayer() and ent:Team() == TEAM_HUMAN then
		local vel = ent:GetVelocity()
		local dir = vel:GetNormal()
		ent:SetLocalVelocity(vel * self.SlowDown)
	end
end