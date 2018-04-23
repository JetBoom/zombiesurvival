ENT.Type = "anim"

hook.Add("FindUseEntity", "Fix.Arsenal.Crate.Shit", function(pl)
    local target = pl:GetEyeTrace().Entity
	
    if IsValid(target) then
		local pos_from_target = pl:GetPos():Distance( target:GetPos() )
		
		if target:GetClass() == "player" then
			if target:Alive() and target:Team() == TEAM_HUMAN then
				if GAMEMODE:GetWave() > 0 then
					if pos_from_target <= 80 then
						local wep = "weapon_zs_arsenalcrate"
						local activewep = target:GetActiveWeapon()
						local has_wep = target:HasWeapon( wep )
						if IsValid( activewep ) and activewep:GetClass() ~= wep and has_wep or has_wep then
							pl:SendLua("GAMEMODE:OpenPointsShop()")
						end
					end
				end
			end
		end
    end
end)