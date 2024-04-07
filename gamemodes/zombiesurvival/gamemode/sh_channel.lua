GM.MaxChannels = {}
GM.MaxChannels["turret"] = 7

GM.ChannelsToClass = {}
GM.ChannelsToClass["turret"] = {"prop_gunturret", "prop_gunturret_buckshot", "prop_gunturret_assault", "prop_gunturret_rocket"}

function GM:GetFreeChannel(class)
	local max = self.MaxChannels[class]
	if not max then return 1 end

	local taken_channels = {}

	for _, j in pairs(self.ChannelsToClass[class]) do
		for _, ent in pairs(ents.FindByClass(j)) do
			if ent:IsValid() and ent.GetChannel then
				taken_channels[ent:GetChannel()] = true
			end
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
