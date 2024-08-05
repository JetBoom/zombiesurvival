AddCSLuaFile()
ENT.Type = "anim"
first = true
function ENT:BeginFire(attacker, tr, dmginfo, dir, damageowner)
	self:FireBullets({Num = 1, Src = self:GetPos(), Dir = dir, Spread = Vector(0, 0, 0), Tracer = 1, TracerName = "AirboatGunHeavyTracer", Force = dmginfo:GetDamage() * 0.1, Damage = dmginfo:GetDamage() + 50, Callback = 
	function (attacker, tr, dmginfo)
		self.BulletCallback(attacker, tr, dmginfo)
	end})
	self:Remove()
end

function GenericBulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	if ent:IsValid() then
		if ent:IsPlayer() then
		else
			local phys = ent:GetPhysicsObject()
			if ent:GetMoveType() == MOVETYPE_VPHYSICS and phys:IsValid() and phys:IsMoveable() then
				ent:SetPhysicsAttacker(attacker)
			end
		end
	end
end

function ENT.BulletCallback(attacker, tr, dmginfo)
	GenericBulletCallback(attacker, tr, dmginfo)
	local e = EffectData()
		e:SetOrigin(tr.HitPos)
		e:SetNormal(tr.HitNormal)
		e:SetRadius(8)
		e:SetMagnitude(3)
		e:SetScale(1)
	util.Effect("cball_bounce", e)
	outtr = util.TraceLine({ 
	start = tr.HitPos + tr.Normal * 50,
	endpos = tr.HitPos,
	ignoreworld = true,
	})
	dmginfo:SetAttacker(attacker:GetOwner())
	if (SERVER) and not tr.HitWorld then
		local firer = ents.Create( "point_firemanager" )
		firer:Spawn()
		firer:SetPos(outtr.HitPos + tr.Normal * 3)
		firer:SetOwner(dmginfo:GetAttacker())
		firer:BeginFire(attacker, tr, dmginfo,tr.Normal,dmginfo:GetAttacker())
	end
end