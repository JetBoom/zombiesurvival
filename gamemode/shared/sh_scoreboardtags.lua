local specialPeople = {
	{
		id = "STEAM_0:1:3307510",
		img = "vgui/steam/games/icon_sourcesdk",
		tooltip = "JetBoom\nCreator of Zombie Survival!"
	},
	{
		id = "STEAM_0:1:49624713",
		img = "vgui/steam/games/icon_sourcesdk",
		tooltip = "MrCraigTunstall\nCoder of Zombie Survival Redemption!"
	},
	{
		id = "STEAM_0:0:47758537",
		img = "icons/cat.png",
		tooltip = "Flairieve\nThat Awesome Cat!"
	},
}

function GM:IsSpecialPerson(pl, image)
	local img, tooltip, size, color

	if pl:IsBot() then
		img = "icon16/bug.png"
		tooltip = "Beep Boop\nI'm a bot!"
	elseif pl:IsSuperAdmin() then
		img = "icon16/shield.png"
		tooltip = "Super Admin"
	elseif pl:IsAdmin() then
		img = "icons/shield_gray.png"
		tooltip = "Admin"
	elseif pl:IsNoxSupporter() then
		img = "noxiousnet/noxicon.png"
		tooltip = "Nox Supporter"
	end

	if not pl:IsBot() then
		for k,v in pairs(specialPeople) do
			if v.id == pl:SteamID() or v.id64 == pl:SteamID64() then
				img = v.img
				tooltip = v.tooltip
			end
		end
	end

	if img then
		if CLIENT then
			image:SetImage(img)
			image:SetTooltip(tooltip)
			if size ~= nil then
				image:SetSize(size, size)
			end
			if color ~= nil then
				image:SetImageColor(color)
			end
		end

		return true
	end

	return false
end
