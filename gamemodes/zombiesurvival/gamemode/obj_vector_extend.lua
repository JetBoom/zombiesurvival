local meta = FindMetaTable("Vector")

function meta:DistanceZSkew(vec, skew)
	return math.sqrt((self.x - vec.x) ^ 2 + (self.y - vec.y) ^ 2 + ((self.z - vec.z) * skew) ^ 2)
end

-- ^ operator: by reference normalize and optional multiply
function meta:__pow(len)
	self:Normalize()
	if len == 1 then
		return self
	end

	self.x = self.x * len
	self.y = self.y * len
	self.z = self.z * len

	return self
end

-- % operator: by reference raise Z
function meta:__mod(z)
	self.z = self.z + z

	return self
end

-- # operator: length
function meta:__len()
	return self:Length()
end

-- Normalize self and return self (GetNormalized makes a copy)
function meta:NormalizeRef()
	self:Normalize()
	return self
end
