INC_SERVER()
DEFINE_BASECLASS("weapon_zs_basemelee")

SWEP.TrinketStatus = ""

function SWEP:Initialize()
	BaseClass.Initialize(self)

	timer.Simple(0, function()
		if IsValid(self) then
			if self.TrinketStatus ~= "" then
				self:CreateTrinketStatus()
			end
		end
	end)
end

function SWEP:Deploy()
	BaseClass.Deploy(self)

	if self.TrinketStatus ~= "" then
		self:CreateTrinketStatus()
	end

	return true
end

function SWEP:CreateTrinketStatus()
	local owner = self:GetOwner()
	if not owner:IsValid() then return end

	local status = self.TrinketStatus
	for _, ent in pairs(ents.FindByClass(status)) do
		if ent:GetOwner() == owner then return end
	end

	local ent = ents.Create(status)
	if ent:IsValid() then
		ent:SetPos(owner:EyePos())
		ent:SetParent(owner)
		ent:SetOwner(owner)
		ent:Spawn()
	end
end
