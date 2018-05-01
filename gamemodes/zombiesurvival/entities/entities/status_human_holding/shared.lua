ENT.Type = "anim"
ENT.Base = "status__base"

AccessorFuncDT(ENT, "ObjectMass", "Int", 0)

function ENT:Move(pl, mv)
	if pl ~= self:GetOwner() then return end

	local object = self:GetObject()
	if object:IsValid() then
		--local objectphys = object:GetPhysicsObject()
		--if objectphys:IsValid() then
			mv:SetMaxSpeed(math.max(
				mv:GetMaxSpeed() / 4,
				mv:GetMaxSpeed() - self:GetObjectMass() * CARRY_SPEEDLOSS_PERKG * pl.PropCarrySlowMul)
			)
			mv:SetMaxClientSpeed(mv:GetMaxSpeed())
		--end
	end
end

local defaultcolor = Vector( 62.0/255.0, 88.0/255.0, 106.0/255.0 )
function ENT:GetPlayerColor()
	local owner = self:GetOwner()
	if owner and owner:IsValid() and owner.GetPlayerColor then
		return owner:GetPlayerColor()
	end

	return defaultcolor
end

function ENT:GetObject()
	return self:GetDTEntity(0)
end

function ENT:SetObject(object)
	self:SetDTEntity(0, object)
end

function ENT:SetIsHeavy(heavy)
	self:SetDTBool(0, heavy)
end

function ENT:GetIsHeavy()
	return self:GetDTBool(0)
end

function ENT:GetPullPos()
	local owner = self:GetOwner()
	if owner:IsValid() then
		return owner:EyePos() + owner:GetAimVector() * 48
	end

	return self:GetObjectPos()
end

function ENT:GetObjectPos()
	local object = self:GetObject()
	if object:IsValid() then
		return object:GetPos()
	end

	return self:GetPos()
end

function ENT:SetHingePos(pos)
	local object = self:GetObject()
	if object:IsValid() then
		self:SetDTVector(0, object:WorldToLocal(pos))
	end
end

function ENT:GetHingePos()
	local object = self:GetObject()
	if object:IsValid() then
		return object:LocalToWorld(self:GetDTVector(0))
	end

	return self:GetObjectPos()
end
