local specialPeople = {
	{
		id = "STEAM_0:1:3307510",
		img = "VGUI/steam/games/icon_sourcesdk",
		tooltip = "JetBoom\nCreator of Zombie Survival!"
	},
	{
		id = "STEAM_0:1:49624713",
		img = "VGUI/steam/games/icon_sourcesdk",
		tooltip = "MrCraigTunstall\nCoder of Zombie Survival Redemption!"
	},
	{
		id = "STEAM_0:0:47758537",
		img = "VGUI/steam/games/icon_sourcesdk",
		tooltip = "Flairieve\nThe Awesome Cat!"
	},
}

function GM:IsSpecialPerson(pl, image)
	local img, tooltip

	if pl:IsAdmin() then
		img = "VGUI/servers/icon_robotron"
		tooltip = "Admin"
	elseif pl:IsNoxSupporter() then
		img = "noxiousnet/noxicon.png"
		tooltip = "Nox Supporter"
	end

	for k,v in pairs(specialPeople) do
		if v.id == pl:SteamID() or v.id64 == pl:SteamID64() then
			img = v.img
			tooltip = v.tooltip
		end
	end

	if img then
		if CLIENT then
			image:SetImage(img)
			image:SetTooltip(tooltip)
		end

		return true
	end

	return false
end
