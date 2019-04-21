INC_SERVER()

function SWEP:SetupPlayerVisibility(pl)
	local owner = self:GetOwner()
	if owner ~= pl then return end

	local camera = self:GetCamera()
	if camera:IsValid() then
		AddOriginToPVS(camera:WorldSpaceCenter())
	end
end

function SWEP:CycleCamera(reverse)
	local cameras = {}

	for _, camera in pairs(ents.FindByClass("prop_camera")) do
		if camera:IsValid() then
			table.insert(cameras, camera)
		end
	end

	if #cameras == 0 then return end

	local index
	for i, camera in pairs(cameras) do
		if self:GetCamera() == camera then
			index = i
			break
		end
	end

	if not index or #cameras == 1 then
		self:SetCamera(cameras[1])
		return
	end

	if reverse then
		self:SetCamera(cameras[index - 1] or cameras[#cameras])
	else
		self:SetCamera(cameras[index + 1] or cameras[1])
	end
end
