local specialPeople = {
	{
		id = "STEAM_0:1:3307510",
		img = "vgui/steam/games/icon_sourcesdk",
		tooltip = "JetBoom\nCreator of Zombie Survival!"
	},
	{
		id = "STEAM_0:1:49624713",
		img = "vgui/steam/games/icon_sourcesdk",
		tooltip = "MrCraigTunstall\nCoder of Zombie Survival Redemption."
	},
	{
		id = "STEAM_0:0:47758537",
		img = "icons/cat.png",
		tooltip = "Flairieve\nThat Awesome Cat!"
	},
	{
		id = "STEAM_0:0:18000855",
		img = "icon16/bomb.png",
		tooltip = "Mka0207\nConcepted and created Zombie Survival Redemption."
	},
	{
		id = "STEAM_0:0:22379160",
		img = "icon16/wrench_orange.png",
		tooltip = "D3\nAssistant coder of Zombie Survival Redemption."
	},
	{
		id = "STEAM_0:0:35752130",
		img = "icon16/rainbow.png",
		tooltip = "Gabi\nHollowcreek Owner."
	}
}

function GM:IsSpecialPerson(pl, image)
	local img, tooltip, size, color, flash
	
	if pl:IsBot() then
		img = "icon16/bug.png"
		tooltip = "Beep Boop!\nI'm a bot!"
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
				flash = true
			end
		end
	end
	
	if image == nil and flash then
		return true
	elseif image == nil then
		return false
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