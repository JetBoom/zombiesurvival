concommand.Add("initpostentity", function(sender, command, arguments)
	if not sender.DidInitPostEntity then
		sender.DidInitPostEntity = true

		gamemode.Call("PlayerReady", sender)
	end
end)

concommand.Add("zs_pointsshopbuy", function(sender, command, arguments)
	if not (sender:IsValid() and sender:IsConnected()) or #arguments == 0 then return end

	if sender:GetUnlucky() then
		sender:CenterNotify(COLOR_RED, translate.ClientGet(sender, "banned_for_life_warning"))
		sender:SendLua("surface.PlaySound(\"buttons/button10.wav\")")
		return
	end

	if not sender:NearArsenalCrate() then
		sender:CenterNotify(COLOR_RED, translate.ClientGet(sender, "need_to_be_near_arsenal_crate"))
		sender:SendLua("surface.PlaySound(\"buttons/button10.wav\")")
		return
	end

	if not gamemode.Call("PlayerCanPurchase", sender) then
		sender:CenterNotify(COLOR_RED, translate.ClientGet(sender, "cant_purchase_right_now"))
		sender:SendLua("surface.PlaySound(\"buttons/button10.wav\")")
		return
	end

	local itemtab
	local id = arguments[1]
	local num = tonumber(id)
	if num then
		itemtab = GAMEMODE.Items[num]
	else
		for i, tab in pairs(GAMEMODE.Items) do
			if tab.Signature == id then
				itemtab = tab
				break
			end
		end
	end

	if not itemtab or not itemtab.PointShop then return end

	local points = sender:GetPoints()
	local cost = itemtab.Worth
	if not GAMEMODE:GetWaveActive() then
		cost = cost * GAMEMODE.ArsenalCrateMultiplier
	end

	if GAMEMODE:IsClassicMode() and itemtab.NoClassicMode then
		sender:CenterNotify(COLOR_RED, translate.ClientFormat(sender, "cant_use_x_in_classic", itemtab.Name))
		sender:SendLua("surface.PlaySound(\"buttons/button10.wav\")")
		return
	end

	if GAMEMODE.ZombieEscape and itemtab.NoZombieEscape then
		sender:CenterNotify(COLOR_RED, translate.ClientFormat(sender, "cant_use_x_in_zombie_escape", itemtab.Name))
		sender:SendLua("surface.PlaySound(\"buttons/button10.wav\")")
		return
	end

	cost = math.ceil(cost)

	if points < cost then
		sender:CenterNotify(COLOR_RED, translate.ClientGet(sender, "dont_have_enough_points"))
		sender:SendLua("surface.PlaySound(\"buttons/button10.wav\")")
		return
	end

	if itemtab.Callback then
		itemtab.Callback(sender)
	elseif itemtab.SWEP then
		if sender:HasWeapon(itemtab.SWEP) then
			local stored = weapons.GetStored(itemtab.SWEP)
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
	else
		return
	end

	sender:TakePoints(cost)
	sender:PrintTranslatedMessage(HUD_PRINTTALK, "purchased_x_for_y_points", itemtab.Name, cost)
	sender:SendLua("surface.PlaySound(\"ambient/levels/labs/coinslot1.wav\")")

	local nearest = sender:NearestArsenalCrateOwnedByOther()
	if nearest then
		local owner = nearest:GetObjectOwner()
		if owner:IsValid() then
			local nonfloorcommission = cost * 0.07
			local commission = math.floor(nonfloorcommission)
			if commission > 0 then
				owner.PointsCommission = owner.PointsCommission + cost

				owner:AddPoints(commission)

				net.Start("zs_commission")
					net.WriteEntity(nearest)
					net.WriteEntity(sender)
					net.WriteUInt(commission, 16)
				net.Send(owner)
			end

			local leftover = nonfloorcommission - commission
			if leftover > 0 then
				owner.CarryOverCommision = owner.CarryOverCommision + leftover
				if owner.CarryOverCommision >= 1 then
					local carried = math.floor(owner.CarryOverCommision)
					owner.CarryOverCommision = owner.CarryOverCommision - carried
					owner:AddPoints(carried)

					net.Start("zs_commission")
						net.WriteEntity(nearest)
						net.WriteEntity(sender)
						net.WriteUInt(carried, 16)
					net.Send(owner)
				end
			end
		end
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
		local tab = FindStartingItem(id)
		if tab and not hasalready[id] then
			cost = cost + tab.Worth
			hasalready[id] = true
		end
	end

	if cost > GAMEMODE.StartingWorth then return end

	local hasalready = {}

	for _, id in pairs(arguments) do
		local tab = FindStartingItem(id)
		if tab and not hasalready[id] then
			if tab.NoClassicMode and GAMEMODE:IsClassicMode() then
				sender:PrintMessage(HUD_PRINTTALK, translate.ClientFormat(sender, "cant_use_x_in_classic_mode", tab.Name))
			elseif tab.Callback then
				tab.Callback(sender)
				hasalready[id] = true
			elseif tab.SWEP then
				sender:StripWeapon(tab.SWEP) -- "Fixes" players giving each other empty weapons to make it so they get no ammo from the Worth menu purchase.
				sender:Give(tab.SWEP)
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
	if GAMEMODE.ZombieEscape then return end

	if not (sender:IsValid() and sender:Alive() and sender:Team() ~= TEAM_UNDEAD) or CurTime() < (sender.NextWeaponDrop or 0) or GAMEMODE.ZombieEscape then return end
	sender.NextWeaponDrop = CurTime() + 0.15

	local currentwep = sender:GetActiveWeapon()
	if currentwep and currentwep:IsValid() then
		if string.StartWith(currentwep:GetClass(), "weapon_zs") then
			local ent = sender:DropWeaponByType(currentwep:GetClass())
			if ent and ent:IsValid() then
				local shootpos = sender:GetShootPos()
				local aimvec = sender:GetAimVector()
				ent:SetPos(util.TraceHull({start = shootpos, endpos = shootpos + aimvec * 32, mask = MASK_SOLID, filter = sender, mins = Vector(-2, -2, -2), maxs = Vector(2, 2, 2)}).HitPos)
				ent:SetAngles(sender:GetAngles())
			end
		end
	end
end)

concommand.Add("zsemptyclip", function(sender, command, arguments)
	if GAMEMODE.ZombieEscape then return end

	if not (sender:IsValid() and sender:Alive() and sender:Team() ~= TEAM_UNDEAD) then return end

	sender.NextEmptyClip = sender.NextEmptyClip or 0
	if sender.NextEmptyClip <= CurTime() then
		sender.NextEmptyClip = CurTime() + 0.1

		local wep = sender:GetActiveWeapon()
		if wep:IsValid() and not wep.NoMagazine then
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

concommand.Add("zsgiveammo", function(sender, command, arguments)
	if GAMEMODE.ZombieEscape then return end

	if not sender:IsValid() or not sender:Alive() or sender:Team() == TEAM_UNDEAD then return end

	local ammotype = arguments[1]
	if not ammotype or #ammotype == 0 or not GAMEMODE.AmmoCache[ammotype] then return end

	local count = sender:GetAmmoCount(ammotype)
	if count <= 0 then
		sender:SendLua("surface.PlaySound(\"buttons/button10.wav\")")
		sender:PrintTranslatedMessage(HUD_PRINTCENTER, "no_spare_ammo_to_give")
		return
	end

	local ent
	local dent = Entity(tonumbersafe(arguments[2] or 0) or 0)
	if GAMEMODE:ValidMenuLockOnTarget(sender, dent) then
		ent = dent
	end

	if not ent then
		ent = sender:MeleeTrace(48, 2).Entity
	end

	if ent and ent:IsValid() and ent:IsPlayer() and ent:Team() ~= TEAM_UNDEAD and ent:Alive() then
		local desiredgive = math.min(count, GAMEMODE.AmmoCache[ammotype])
		if desiredgive >= 1 then
			sender:RemoveAmmo(desiredgive, ammotype)
			ent:GiveAmmo(desiredgive, ammotype)

			if CurTime() >= (sender.NextGiveAmmoSound or 0) then
				sender.NextGiveAmmoSound = CurTime() + 1
				sender:PlayGiveAmmoSound()
			end

			sender:RestartGesture(ACT_GMOD_GESTURE_ITEM_GIVE)

			return
		end
	else
		sender:SendLua("surface.PlaySound(\"buttons/button10.wav\")")
		sender:PrintTranslatedMessage(HUD_PRINTCENTER, "no_person_in_range")
	end
end)

concommand.Add("zsgiveweapon", function(sender, command, arguments)
	if GAMEMODE.ZombieEscape then return end

	if not (sender:IsValid() and sender:Alive() and sender:Team() ~= TEAM_UNDEAD) or GAMEMODE.ZombieEscape then return end

	local currentwep = sender:GetActiveWeapon()
	if currentwep and currentwep:IsValid() then
		local ent
		local dent = Entity(tonumbersafe(arguments[2] or 0) or 0)
		if GAMEMODE:ValidMenuLockOnTarget(sender, dent) then
			ent = dent
		end

		if not ent then
			ent = sender:MeleeTrace(48, 2).Entity
		end

		if ent and ent:IsValid() and ent:IsPlayer() and ent:Team() ~= TEAM_UNDEAD and ent:Alive() then
			if not ent:HasWeapon(currentwep:GetClass()) then
				sender:GiveWeaponByType(currentwep, ent, false)
			else
				sender:SendLua("surface.PlaySound(\"buttons/button10.wav\")")
				sender:PrintTranslatedMessage(HUD_PRINTCENTER, "person_has_weapon")
			end
		else
			sender:SendLua("surface.PlaySound(\"buttons/button10.wav\")")
			sender:PrintTranslatedMessage(HUD_PRINTCENTER, "no_person_in_range")
		end
	end
end)

concommand.Add("zsgiveweaponclip", function(sender, command, arguments)
	if GAMEMODE.ZombieEscape then return end

	if not (sender:IsValid() and sender:Alive() and sender:Team() ~= TEAM_UNDEAD) then return end

	local currentwep = sender:GetActiveWeapon()
	if currentwep and currentwep:IsValid() then
		local ent
		local dent = Entity(tonumbersafe(arguments[2] or 0) or 0)
		if GAMEMODE:ValidMenuLockOnTarget(sender, dent) then
			ent = dent
		end

		if not ent then
			ent = sender:MeleeTrace(48, 2).Entity
		end

		if ent and ent:IsValid() and ent:IsPlayer() and ent:Team() ~= TEAM_UNDEAD and ent:Alive() then
			if not ent:HasWeapon(currentwep:GetClass()) then
				sender:GiveWeaponByType(currentwep, ent, true)
			else
				sender:SendLua("surface.PlaySound(\"buttons/button10.wav\")")
				sender:PrintTranslatedMessage(HUD_PRINTCENTER, "person_has_weapon")
			end
		else
			sender:SendLua("surface.PlaySound(\"buttons/button10.wav\")")
			sender:PrintTranslatedMessage(HUD_PRINTCENTER, "no_person_in_range")
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

concommand.Add("zs_class", function(sender, command, arguments)
	if sender:Team() ~= TEAM_UNDEAD or sender.Revive or GAMEMODE.PantsMode or GAMEMODE:IsClassicMode() or GAMEMODE:IsBabyMode() or GAMEMODE.ZombieEscape then return end

	local classname = arguments[1]
	local suicide = arguments[2] == "1"
	local classtab = GAMEMODE.ZombieClasses[classname]
	if not classtab or classtab.Hidden and not (classtab.CanUse and classtab:CanUse(sender)) then return end

	if not gamemode.Call("IsClassUnlocked", classname) then
		sender:CenterNotify(COLOR_RED, translate.ClientFormat(sender, "class_not_unlocked_will_be_unlocked_x", classtab.Wave))
	elseif sender:GetZombieClassTable().Name == classname and not sender.DeathClass then
		sender:CenterNotify(COLOR_RED, translate.ClientFormat(sender, "you_are_already_a_x", translate.ClientGet(sender, classtab.TranslationName)))
	else
		sender.DeathClass = classtab.Index
		sender:CenterNotify(translate.ClientFormat(sender, "you_will_spawn_as_a_x", translate.ClientGet(sender, classtab.TranslationName)))

		if suicide and sender:Alive() and not sender:GetZombieClassTable().Boss and gamemode.Call("CanPlayerSuicide", sender) then
			sender:Kill()
		end
	end
end)

concommand.Add("zs_sigilplacer", function(sender)
		if sender:IsValid() and sender:IsSuperAdmin() then
			sender:Give("weapon_zs_sigilplacer")
		end
end)
