function GM:ConCommandErrorMessage(pl, message)
	pl:CenterNotify(COLOR_RED, message)
	pl:SendLua("surface.PlaySound(\"buttons/button10.wav\")")
end

concommand.Add("zs_pointsshopbuy", function(sender, command, arguments)
	if not (sender:IsValid() and sender:IsConnected() and sender:IsValidLivingHuman()) or #arguments == 0 then return end
	local usescrap = arguments[2]

	local midwave = GAMEMODE:GetWave() < GAMEMODE:GetNumberOfWaves() / 2 or GAMEMODE:GetWave() == GAMEMODE:GetNumberOfWaves() / 2 and GAMEMODE:GetWaveActive() and CurTime() < GAMEMODE:GetWaveEnd() - (GAMEMODE:GetWaveEnd() - GAMEMODE:GetWaveStart()) / 2
	if sender:IsSkillActive(SKILL_D_LATEBUYER) and not usescrap and midwave then
		GAMEMODE:ConCommandErrorMessage(sender, translate.ClientGet(sender, "late_buyer_warning"))
		return
	end

	if usescrap and not sender:NearRemantler() or not usescrap and not sender:NearArsenalCrate() then
		GAMEMODE:ConCommandErrorMessage(sender, translate.ClientGet(sender, usescrap and "need_to_be_near_remantler" or "need_to_be_near_arsenal_crate"))
		return
	end

	if not (usescrap or gamemode.Call("PlayerCanPurchase", sender)) then
		GAMEMODE:ConCommandErrorMessage(sender, translate.ClientGet(sender, "cant_purchase_right_now"))
		return
	end

	local id = arguments[1]
	id = tonumber(id) or id
	local itemtab = FindItem(id)

	if not itemtab or not itemtab.PointShop then return end
	local itemcat = itemtab.Category
	if usescrap and not (itemcat == ITEMCAT_TRINKETS or itemcat == ITEMCAT_AMMO) and not itemtab.CanMakeFromScrap then return end

	local points = usescrap and sender:GetAmmoCount("scrap") or sender:GetPoints()
	local cost = itemtab.Price

	if GAMEMODE:IsClassicMode() and itemtab.NoClassicMode then
		GAMEMODE:ConCommandErrorMessage(sender, translate.ClientFormat(sender, "cant_use_x_in_classic", itemtab.Name))
		return
	end

	if GAMEMODE.ZombieEscape and itemtab.NoZombieEscape then
		GAMEMODE:ConCommandErrorMessage(sender, translate.ClientFormat(sender, "cant_use_x_in_zombie_escape", itemtab.Name))
		return
	end

	if itemtab.SkillRequirement and not sender:IsSkillActive(itemtab.SkillRequirement) then
		GAMEMODE:ConCommandErrorMessage(sender, translate.ClientFormat(sender, "x_requires_a_skill_you_dont_have", itemtab.Name))
		return
	end

	if itemtab.Tier and GAMEMODE.LockItemTiers and not GAMEMODE.ObjectiveMap and not GAMEMODE.ZombieEscape and not GAMEMODE:IsClassicMode() and GAMEMODE:GetNumberOfWaves() == GAMEMODE.NumberOfWaves and GAMEMODE:GetWave() + (GAMEMODE:GetWaveActive() and 0 or 1) < itemtab.Tier then
		GAMEMODE:ConCommandErrorMessage(sender, translate.ClientFormat(sender, "tier_x_items_unlock_at_wave_y", itemtab.Tier, itemtab.Tier))
		return
	end

	if not GAMEMODE:HasItemStocks(id) then
		GAMEMODE:ConCommandErrorMessage(sender, translate.ClientGet(sender, "out_of_stock"))
		return
	end

	cost = usescrap and math.ceil(GAMEMODE:PointsToScrap(cost)) or math.floor(cost * (sender.ArsenalDiscount or 1))

	if points < cost then
		GAMEMODE:ConCommandErrorMessage(sender, translate.ClientGet(sender, usescrap and "need_to_have_enough_scrap" or "dont_have_enough_points"))
		return
	end

	if itemtab.Callback then
		itemtab.Callback(sender)
	elseif itemtab.SWEP then
		if string.sub(itemtab.SWEP, 1, 6) ~= "weapon" then
			if GAMEMODE:GetInventoryItemType(itemtab.SWEP) == INVCAT_TRINKETS and sender:HasInventoryItem(itemtab.SWEP) then
				local wep = ents.Create("prop_invitem")
				if wep:IsValid() then
					wep:SetPos(sender:GetShootPos())
					wep:SetAngles(sender:GetAngles())
					wep:SetInventoryItemType(itemtab.SWEP)
					wep:Spawn()
				end
			else
				sender:AddInventoryItem(itemtab.SWEP)
			end
		elseif sender:HasWeapon(itemtab.SWEP) then
			local stored = weapons.Get(itemtab.SWEP)
			if stored and stored.AmmoIfHas then
				sender:GiveAmmo(stored.Primary.DefaultClip, stored.Primary.Ammo)
			else
				local wep = ents.Create("prop_weapon")
				if wep:IsValid() then
					wep:SetPos(sender:GetShootPos())
					wep:SetAngles(sender:GetAngles())
					wep:SetWeaponType(itemtab.SWEP)
					wep:SetShouldRemoveAmmo(true)
					wep:Spawn()
				end
			end
		else
			local wep = sender:Give(itemtab.SWEP)
			if wep and wep:IsValid() and wep.EmptyWhenPurchased and wep:GetOwner():IsValid() then
				if wep.Primary then
					local primary = wep:ValidPrimaryAmmo()
					if primary then
						sender:RemoveAmmo(math.max(0, wep.Primary.DefaultClip - wep.Primary.ClipSize), primary)
					end
				end
				if wep.Secondary then
					local secondary = wep:ValidSecondaryAmmo()
					if secondary then
						sender:RemoveAmmo(math.max(0, wep.Secondary.DefaultClip - wep.Secondary.ClipSize), secondary)
					end
				end
			end
		end

		GAMEMODE.StatTracking:IncreaseElementKV(STATTRACK_TYPE_WEAPON, itemtab.SWEP, "Purchases", 1)
	else
		return
	end

	if usescrap then
		sender:RemoveAmmo(cost, "scrap")
		sender:SendLua("surface.PlaySound(\"buttons/lever"..math.random(5)..".wav\")")
	else
		sender:TakePoints(cost)
		sender:SendLua("surface.PlaySound(\"ambient/levels/labs/coinslot1.wav\")")
	end
	sender:PrintTranslatedMessage(HUD_PRINTTALK, usescrap and "created_x_for_y_scrap" or "purchased_x_for_y_points", itemtab.Name, cost)

	GAMEMODE:AddItemStocks(id, -1)

	if usescrap then
		local nearest = sender:NearestRemantler()
		if nearest then
			local owner = nearest.GetObjectOwner and nearest:GetObjectOwner() or nearest:GetOwner()
			if owner:IsValid() and owner ~= sender then
				local scrapcom = math.ceil(cost / 8)
				nearest:SetScraps(nearest:GetScraps() + scrapcom)
				nearest:GetObjectOwner():CenterNotify(COLOR_GREEN, translate.Format("remantle_used", scrapcom))
			end
		end
	else
		local nearest = sender:NearestArsenalCrateOwnedByOther()
		if nearest then
			local owner = nearest.GetObjectOwner and nearest:GetObjectOwner() or nearest:GetOwner()
			if owner:IsValid() then
				local commission = cost * GAMEMODE.ArsenalCrateCommission
				if commission > 0 then
					owner:AddPoints(commission, nil, nil, true)

					net.Start("zs_commission")
						net.WriteEntity(nearest)
						net.WriteEntity(sender)
						net.WriteFloat(commission)
					net.Send(owner)
				end
			end
		end
	end
end)

concommand.Add("zs_dismantle", function(sender, command, arguments)
	if not (sender:IsValid() and sender:IsConnected() and sender:IsValidLivingHuman()) then return end

	local invitem, itypecat, potinv
	if #arguments > 0 then
		invitem = arguments[1]
	end

	if invitem and not sender:HasInventoryItem(invitem) then return end

	local active = sender:GetActiveWeapon()
	local contents, wtbl = active:GetClass()
	if not invitem then
		wtbl = weapons.Get(contents)
		if wtbl.NoDismantle or not (wtbl.AllowQualityWeapons or wtbl.PermitDismantle) then
			GAMEMODE:ConCommandErrorMessage(sender, translate.ClientGet(sender, "cannot_dismantle"))
			return
		end

		if wtbl.AmmoIfHas and sender:GetAmmoCount(wtbl.Primary.Ammo) == 0 and active:Clip1() == 0 then
			sender:SendLua("surface.PlaySound(\"buttons/button10.wav\")")
			return
		end

		potinv = GAMEMODE.Breakdowns[contents]
	else
		itypecat = GAMEMODE:GetInventoryItemType(invitem)
		if itypecat ~= INVCAT_TRINKETS or GAMEMODE.ZSInventoryItemData[invitem].PermitDismantle then
			GAMEMODE:ConCommandErrorMessage(sender, translate.ClientGet(sender, "cannot_dismantle"))
			return
		end

		potinv = GAMEMODE.Breakdowns[invitem]
	end

	local scrap = GAMEMODE:GetDismantleScrap(wtbl or GAMEMODE.ZSInventoryItemData[invitem], invitem)
	net.Start("zs_ammopickup")
		net.WriteUInt(scrap, 16)
		net.WriteString("scrap")
	net.Send(sender)
	sender:GiveAmmo(scrap, "scrap")

	if invitem then
		sender:TakeInventoryItem(invitem)
	else
		sender:GetActiveWeapon():EmptyAll(true)

		if wtbl and wtbl.AmmoIfHas then
			sender:RemoveAmmo(1, wtbl.Primary.Ammo)
		end

		sender:StripWeapon(contents)
		sender:UpdateAltSelectedWeapon()
	end

	GAMEMODE.StatTracking:IncreaseElementKV(STATTRACK_TYPE_WEAPON, invitem or contents, "Disassembles", 1)

	if potinv and potinv.Result then
		sender:AddInventoryItem(potinv.Result)

		net.Start("zs_invitem")
			net.WriteString(potinv.Result)
		net.Send(sender)
	end
end)

concommand.Add("zs_upgrade", function(sender, command, arguments)
	if not (sender:IsValid() and sender:IsConnected() and sender:IsValidLivingHuman()) then return end

	if not sender:NearRemantler() then
		GAMEMODE:ConCommandErrorMessage(sender, translate.ClientGet(sender, "need_to_be_near_remantler"))
		return
	end

	local nearest = sender:NearestRemantler()
	local contents = sender:GetActiveWeapon():GetClass()
	local contentstbl = weapons.Get(contents)
	local contentsqua = contentstbl.QualityTier
	local desiredqua = contentsqua and contentsqua + 1 or 1

	local branch = contentstbl.Branch
	if not contentsqua and #arguments > 0 then
		branch = tonumber(arguments[1])
	end

	if not (nearest and nearest:IsValid() and contents) then return end

	local wtbl = weapons.Get(contents)
	local scrapcost = GAMEMODE:GetUpgradeScrap(wtbl, desiredqua)

	if wtbl.AmmoIfHas and sender:GetAmmoCount(wtbl.Primary.Ammo) == 0 then
		sender:SendLua("surface.PlaySound(\"buttons/button10.wav\")")
		return
	end

	if sender:GetAmmoCount("scrap") < scrapcost then
		GAMEMODE:ConCommandErrorMessage(sender, translate.ClientGet(sender, "need_to_have_enough_scrap"))
		return
	end

	local upgclass = GAMEMODE:GetWeaponClassOfQuality(not contentsqua and contents or contentstbl.BaseQuality, desiredqua, branch)
	local classtbl = weapons.Get(upgclass)
	if not classtbl then return end

	if sender:HasWeapon(upgclass) then
		GAMEMODE:ConCommandErrorMessage(sender, translate.ClientGet(sender, "remantle_cannot"))
		return
	end

	local upgname = classtbl.PrintName
	sender:CenterNotify(COLOR_CYAN, translate.ClientGet(sender, "remantle_success"), color_white, " "..upgname)
	sender:SendLua("surface.PlaySound(\"buttons/lever"..math.random(5)..".wav\")")
	sender:RemoveAmmo(scrapcost, "scrap")

	local wep = sender:GiveEmptyWeapon(upgclass)
	if wep and wep:IsValid() then
		sender:GetActiveWeapon():EmptyAll(true)
		sender:SelectWeapon(upgclass)
		sender:StripWeapon(contents)
		sender:UpdateAltSelectedWeapon()

		if wtbl.AmmoIfHas then
			sender:RemoveAmmo(1, wtbl.Primary.Ammo)
		end
		if wep.AmmoIfHas then
			sender:GiveAmmo(1, wep.Primary.Ammo)
		end

		net.Start("zs_remantleconf")
		net.Send(sender)

		GAMEMODE.StatTracking:IncreaseElementKV(STATTRACK_TYPE_WEAPON, upgclass, "Upgrades", 1)
	end

	local owner = nearest.GetObjectOwner and nearest:GetObjectOwner() or nearest:GetOwner()
	if owner:IsValid() and owner ~= sender then
		local scrapcom = math.ceil(scrapcost * 0.08)
		nearest:SetScraps(nearest:GetScraps() + scrapcom)
		nearest:GetObjectOwner():CenterNotify(COLOR_GREEN, translate.Format("remantle_used", scrapcom))
	end
end)

concommand.Add("worthrandom", function(sender, command, arguments)
	if sender:IsValid() and sender:IsConnected() and gamemode.Call("PlayerCanCheckout", sender) then
		gamemode.Call("GiveRandomEquipment", sender)
	end
end)

concommand.Add("worthcheckout", function(sender, command, arguments)
	if not (sender:IsValid() and sender:IsConnected()) or #arguments == 0 then return end

	if not gamemode.Call("PlayerCanCheckout", sender) then
		sender:CenterNotify(COLOR_RED, translate.ClientGet(sender, "cant_use_worth_anymore"))
		return
	end

	local cost = 0
	local hasalready = {}

	for _, id in pairs(arguments) do
		id = tonumber(id) or id

		local tab = FindStartingItem(id)
		if tab and not hasalready[id] and (not tab.SkillRequirement or sender:IsSkillActive(tab.SkillRequirement)) then
			cost = cost + tab.Price
			hasalready[id] = true
		end
	end

	if cost > GAMEMODE.StartingWorth + (sender.ExtraStartingWorth or 0) then return end

	hasalready = {}

	for _, id in pairs(arguments) do
		id = tonumber(id) or id

		local tab = FindStartingItem(id)
		if tab and not hasalready[id] then
			if tab.SkillRequirement and not sender:IsSkillActive(tab.SkillRequirement) then
				sender:PrintMessage(HUD_PRINTTALK, translate.ClientFormat(sender, "x_requires_a_skill_you_dont_have", tab.Name))
			elseif tab.NoClassicMode and GAMEMODE:IsClassicMode() then
				sender:PrintMessage(HUD_PRINTTALK, translate.ClientFormat(sender, "cant_use_x_in_classic_mode", tab.Name))
			elseif tab.Callback then
				tab.Callback(sender)
				hasalready[id] = true
			elseif tab.SWEP then
				GAMEMODE.StatTracking:IncreaseElementKV(STATTRACK_TYPE_WEAPON, tab.SWEP, "Checkouts", 1)

				sender:StripWeapon(tab.SWEP) -- "Fixes" players giving each other empty weapons to make it so they get no ammo from the Worth menu purchase.
				if GAMEMODE.ZSInventoryItemData[tab.SWEP] then
					sender:AddInventoryItem(tab.SWEP)
				else
					sender:Give(tab.SWEP)
				end
				hasalready[id] = true
			end
		end
	end

	if table.Count(hasalready) > 0 then
		GAMEMODE.CheckedOut[sender:UniqueID()] = true
	end

	gamemode.Call("RemoveDuplicateAmmo", sender)
end)

concommand.Add("zsdropweapon", function(sender, command, arguments)
	local currentwep = sender:GetActiveWeapon()
	if GAMEMODE.ZombieEscape then
		local hwep, zwep = sender:GetWeapon("weapon_elite"), sender:GetWeapon("weapon_knife")
		if hwep and hwep:IsValid() then
			sender:DropWeapon(hwep)
		elseif zwep and zwep:IsValid() then
			sender:DropWeapon(zwep)
		end

		return
	end

	if not (sender:IsValid() and sender:Alive() and sender:Team() == TEAM_HUMAN) or CurTime() < (sender.NextWeaponDrop or 0) or GAMEMODE.ZombieEscape then return end
	sender.NextWeaponDrop = CurTime() + 0.15

	local invitem
	if #arguments > 0 then
		invitem = arguments[1]
	end
	if invitem and not sender:HasInventoryItem(invitem) then return end

	if invitem or (currentwep and currentwep:IsValid()) then
		local ent = invitem and sender:DropInventoryItemByType(invitem) or sender:DropWeaponByType(currentwep:GetClass())
		if ent and ent:IsValid() then
			local shootpos = sender:GetShootPos()
			local aimvec = sender:GetAimVector()
			ent:SetPos(util.TraceHull({start = shootpos, endpos = shootpos + aimvec * 32, mask = MASK_SOLID, filter = sender, mins = Vector(-2, -2, -2), maxs = Vector(2, 2, 2)}).HitPos)
			ent:SetAngles(sender:GetAngles())
		end
	end
end)

concommand.Add("zsemptyclip", function(sender, command, arguments)
	if GAMEMODE.ZombieEscape then return end

	if not (sender:IsValid() and sender:Alive() and sender:Team() == TEAM_HUMAN) then return end

	sender.NextEmptyClip = sender.NextEmptyClip or 0
	if sender.NextEmptyClip <= CurTime() then
		sender.NextEmptyClip = CurTime() + 0.1

		local wep = sender:GetActiveWeapon()
		if wep:IsValid() and (not wep.NoMagazine and not wep.AmmoIfHas or wep.AllowEmpty) then
			local primary = wep:ValidPrimaryAmmo()
			if primary and 0 < wep:Clip1() then
				sender:GiveAmmo(wep:Clip1(), primary, true)
				wep:SetClip1(0)
			end
			local secondary = wep:ValidSecondaryAmmo()
			if secondary and 0 < wep:Clip2() then
				sender:GiveAmmo(wep:Clip2(), secondary, true)
				wep:SetClip2(0)
			end
		end
	end
end)

function GM:TryGetLockOnTrace(sender, arguments)
	local ent
	local dent = Entity(tonumbersafe(arguments[2] or 0) or 0)
	if GAMEMODE:ValidMenuLockOnTarget(sender, dent) then
		ent = dent
	end

	if not ent then
		ent = sender:MeleeTrace(48, 2, nil, nil, true).Entity
	end

	return ent
end

concommand.Add("zsgiveammo", function(sender, command, arguments)
	if GAMEMODE.ZombieEscape then return end

	if not sender:IsValid() or not sender:Alive() or sender:Team() ~= TEAM_HUMAN then return end

	local ammotype = arguments[1]
	if not ammotype or #ammotype == 0 or not GAMEMODE.AmmoCache[ammotype] then return end

	local count = sender:GetAmmoCount(ammotype)
	if count <= 0 then
		GAMEMODE:ConCommandErrorMessage(sender, translate.ClientGet(sender, "no_spare_ammo_to_give"))
		return
	end

	local ent = GAMEMODE:TryGetLockOnTrace(sender, arguments)
	if ent and ent:IsValidLivingHuman() then
		local desiredgive = math.min(count, GAMEMODE.AmmoCache[ammotype])
		if desiredgive >= 1 then
			sender:RemoveAmmo(desiredgive, ammotype)
			ent:GiveAmmo(desiredgive, ammotype)

			if CurTime() >= (sender.NextGiveAmmoSound or 0) then
				sender.NextGiveAmmoSound = CurTime() + 1
				sender:PlayGiveAmmoSound()
			end

			sender:RestartGesture(ACT_GMOD_GESTURE_ITEM_GIVE)

			net.Start("zs_ammogive")
				net.WriteUInt(desiredgive, 16)
				net.WriteString(ammotype)
				net.WriteEntity(ent)
			net.Send(sender)

			net.Start("zs_ammogiven")
				net.WriteUInt(desiredgive, 16)
				net.WriteString(ammotype)
				net.WriteEntity(sender)
			net.Send(ent)

			return
		end
	else
		GAMEMODE:ConCommandErrorMessage(sender, translate.ClientGet(sender, "no_person_in_range"))
	end
end)

concommand.Add("zsgiveweapon", function(sender, command, arguments)
	if GAMEMODE.ZombieEscape then return end

	if not (sender:IsValid() and sender:Alive() and sender:Team() == TEAM_HUMAN) then return end

	local invitem
	if #arguments > 0 then
		invitem = arguments[2]
	end
	if invitem and not sender:HasInventoryItem(invitem) then return end

	local currentwep = sender:GetActiveWeapon()
	if not invitem and not IsValid(currentwep) then return end

	local ent = GAMEMODE:TryGetLockOnTrace(sender, arguments)
	if ent and ent:IsValidLivingHuman() then
		if not invitem then
			if ent:HasWeapon(currentwep:GetClass()) then
				GAMEMODE:ConCommandErrorMessage(sender, translate.ClientGet(sender, "person_has_weapon"))
			else
				sender:GiveWeaponByType(currentwep, ent, false)
			end
		else
			sender:GiveInventoryItemByType(invitem, ent)
		end
	else
		GAMEMODE:ConCommandErrorMessage(sender, translate.ClientGet(sender, "no_person_in_range"))
	end
end)

concommand.Add("zsgiveweaponclip", function(sender, command, arguments)
	if GAMEMODE.ZombieEscape then return end

	if not (sender:IsValid() and sender:Alive() and sender:Team() == TEAM_HUMAN) then return end

	local currentwep = sender:GetActiveWeapon()
	if currentwep and currentwep:IsValid() then
		local ent = GAMEMODE:TryGetLockOnTrace(sender, arguments)
		if ent and ent:IsValidLivingHuman() then
			if not ent:HasWeapon(currentwep:GetClass()) then
				sender:GiveWeaponByType(currentwep, ent, true)
			else
				GAMEMODE:ConCommandErrorMessage(sender, translate.ClientGet(sender, "person_has_weapon"))
			end
		else
			GAMEMODE:ConCommandErrorMessage(sender, translate.ClientGet(sender, "no_person_in_range"))
		end
	end
end)

concommand.Add("zsdropammo", function(sender, command, arguments)
	if GAMEMODE.ZombieEscape then return end

	if not sender:IsValid() or not sender:Alive() or sender:Team() ~= TEAM_HUMAN or CurTime() < (sender.NextDropClip or 0) then return end

	sender.NextDropClip = CurTime() + 0.2

	local wep = sender:GetActiveWeapon()
	if not wep:IsValid() then return end

	local ammotype = arguments[1] or wep:GetPrimaryAmmoTypeString()
	if GAMEMODE.AmmoNames[ammotype] and GAMEMODE.AmmoCache[ammotype] then
		local ent = sender:DropAmmoByType(ammotype, GAMEMODE.AmmoCache[ammotype] * 2)
		if ent and ent:IsValid() then
			ent:SetPos(sender:EyePos() + sender:GetAimVector() * 8)
			ent:SetAngles(sender:GetAngles())
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:Wake()
				phys:SetVelocityInstantaneous(sender:GetVelocity() * 0.85)
			end
		end
	end
end)

concommand.Add("zs_resupplyammotype", function(sender, command, arguments)
	if GAMEMODE.ZombieEscape then return end

	if not (sender:IsValid() and sender:Alive() and sender:Team() == TEAM_HUMAN) then return end

	local ammotype = arguments[1]
	if not ammotype or #ammotype == 0 or not (ammotype == "default" or GAMEMODE.AmmoResupply[ammotype]) then return end

	sender.ResupplyChoice = ammotype ~= "default" and ammotype or nil
end)

concommand.Add("zs_shitmap_check", function(sender, command, arguments)
	if not sender:IsAdmin() then return end

	local teleporters = ents.FindByClass("trigger_teleport")
	local buttons = ents.FindByClass("func_button")
	local doors = ents.FindByClass("func_door_rotating")
	table.Add(doors, ents.FindByClass("func_movelinear"))

	sender:PrintMessage(HUD_PRINTCONSOLE, "Teleports: "..#teleporters.." Buttons: "..#buttons.." Doors: "..#doors)
end)

concommand.Add("zs_shitmap_toteleport", function(sender, command, arguments)
	if not sender:IsSuperAdmin() then return end

	local ent = ents.FindByClass("trigger_teleport")[tonumber(arguments[1])]
	if ent then
		sender:SetPos(ent:WorldSpaceCenter())
	end
end)

concommand.Add("zs_shitmap_teleport_on", function(sender, command, arguments)
	if not sender:IsSuperAdmin() then return end

	for _, ent in pairs(ents.FindByClass("trigger_teleport")) do
		ent:Fire("enable", "", 0)
	end
end)

concommand.Add("zs_shitmap_teleport_off", function(sender, command, arguments)
	if not sender:IsSuperAdmin() then return end

	for _, ent in pairs(ents.FindByClass("trigger_teleport")) do
		ent:Fire("enable", "", 0)
	end
end)

concommand.Add("zs_shitmap_tobutton", function(sender, command, arguments)
	if not sender:IsSuperAdmin() then return end

	local ent = ents.FindByClass("func_button")[tonumber(arguments[1])]
	if ent then
		sender:SetPos(ent:WorldSpaceCenter())
	end
end)

concommand.Add("zs_shitmap_tomover", function(sender, command, arguments)
	if not sender:IsSuperAdmin() then return end

	local entities = ents.FindByClass("func_door_rotating")
	table.Add(entities, ents.FindByClass("func_movelinear"))
	local ent = entities[tonumber(arguments[1])]
	if ent then
		sender:SetPos(ent:WorldSpaceCenter())
	end
end)
