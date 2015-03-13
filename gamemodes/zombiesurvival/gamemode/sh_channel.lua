GM.MaxChannels = {}
GM.MaxChannels["prop_gunturret"] = 7

function GM:GetFreeChannel(class)
	local max = self.MaxChannels[class]
	if not max then return 1 end

	local taken_channels = {}

	for _, ent in pairs(ents.FindByClass(class)) do
		if ent:IsValid() and ent.GetChannel then
			taken_channels[ent:GetChannel()] = true
		end
	end

	for i=1, max do
		if not taken_channels[i] then
			return i
		end
	end

	return -1
end

function GM:HasFreeChannel(class)
	return self:GetFreeChannel(class) >= 1
end
