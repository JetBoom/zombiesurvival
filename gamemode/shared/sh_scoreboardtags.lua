function GM:IsSpecialPerson(pl, image)
	local img, tooltip

	if pl:SteamID() == "STEAM_0:1:3307510" then
		img = "VGUI/steam/games/icon_sourcesdk"
		tooltip = "JetBoom\nCreator of Zombie Survival!"
	elseif pl:SteamID() == "STEAM_0:1:49624713" then
		img = "VGUI/steam/games/icon_sourcesdk"
		tooltip = "MrCraigTunstall\nCoder of Zombie Survival Redemption!"
	elseif pl:IsAdmin() then
		img = "VGUI/servers/icon_robotron"
		tooltip = "Admin"
	elseif pl:IsNoxSupporter() then
		img = "noxiousnet/noxicon.png"
		tooltip = "Nox Supporter"
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