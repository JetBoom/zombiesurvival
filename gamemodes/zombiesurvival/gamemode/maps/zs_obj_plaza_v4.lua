hook.Add("InitPostEntityMap", "Adding", function()
	
	local classes_purchased = {}
	
	for _, v in pairs(ents.GetAll()) do
		if string.find(v:GetName(),"Currency_Brains_") then
			local name = string.Replace(string.lower(v:GetName()), "currency_brains_", "")
			
			if name == "redeem" then
				v.AcceptInput = function(self, name, activator, caller, args)
					if activator:Frags() >= 4 then
						activator:TakeBrains(activator:GetPoints())
						activator:Redeem()
					else
						net.Start("zs_centernotify")
							net.WriteTable({COLOR_RED, "뇌가 부족하다!"})
						net.Send(activator)
					end
				end
			end
			
			if name == "classes" then
				v.AcceptInput = function(self, name, activator, caller, args)
					if activator:Frags() >= 1 then
						if !classes_purchased[activator] then
							classes_purchased[activator] = 1
							activator:SetZombieClass(GAMEMODE.ZombieClasses["Fast Headcrab"].Index)
							activator:UnSpectateAndSpawn()
							activator:TakeBrains(1)
						elseif classes_purchased[activator] == 1 then
							classes_purchased[activator] = 2
							activator:SetZombieClass(GAMEMODE.ZombieClasses["Wraith"].Index)
							activator:UnSpectateAndSpawn()
							activator:TakeBrains(1)
						elseif classes_purchased[activator] == 2 then
							classes_purchased[activator] = 3
							activator:SetZombieClass(GAMEMODE.ZombieClasses["Poison Headcrab"].Index)
							activator:UnSpectateAndSpawn()
							activator:TakeBrains(1)
						elseif classes_purchased[activator] == 3 then
							classes_purchased[activator] = 4
							activator:SetZombieClass(GAMEMODE.ZombieClasses["Poison Zombie"].Index)
							activator:UnSpectateAndSpawn()
							activator:TakeBrains(1)
						elseif classes_purchased[activator] >= 4 then
							net.Start("zs_centernotify")
								net.WriteTable({COLOR_RED, "이미 모두 언락되었다."})
							net.Send(activator)
						end
					else
						net.Start("zs_centernotify")
							net.WriteTable({COLOR_RED, "뇌가 부족하다!"})
						net.Send(activator)
					end
				end
			end
			
			if name == "bonemesh" then
				v.AcceptInput = function(self, name, activator, caller, args)
					if activator:Frags() >= 2 then
						activator:SetZombieClass(GAMEMODE.ZombieClasses["Bonemesh"].Index)
						activator:UnSpectateAndSpawn()
						activator:TakeBrains(2)
					else
						net.Start("zs_centernotify")
							net.WriteTable({COLOR_RED, "뇌가 부족하다!"})
						net.Send(activator)
					end
				end
			end
			
			if name == "nightmare" then
				v.AcceptInput = function(self, name, activator, caller, args)
					if activator:Frags() >= 4 then
						activator:SetZombieClass(GAMEMODE.ZombieClasses["Nightmare"].Index)
						activator:UnSpectateAndSpawn()
						activator:TakeBrains(4)
					else
						net.Start("zs_centernotify")
							net.WriteTable({COLOR_RED, "뇌가 부족하다!"})
						net.Send(activator)
					end
				end
			end
			
			if name == "ticklemonster" then
				v.AcceptInput = function(self, name, activator, caller, args)
					if activator:Frags() >= 3 then
						activator:SetZombieClass(GAMEMODE.ZombieClasses["The Tickle Monster"].Index)
						activator:UnSpectateAndSpawn()
						activator:TakeBrains(3)
					else
						net.Start("zs_centernotify")
							net.WriteTable({COLOR_RED, "뇌가 부족하다!"})
						net.Send(activator)
					end
				end
			end
			
			if name == "pukepuss" then
				v.AcceptInput = function(self, name, activator, caller, args)
					if activator:Frags() >= 2 then
						activator:SetZombieClass(GAMEMODE.ZombieClasses["Puke Pus"].Index)
						activator:UnSpectateAndSpawn()
						activator:TakeBrains(2)
					else
						net.Start("zs_centernotify")
							net.WriteTable({COLOR_RED, "뇌가 부족하다!"})
						net.Send(activator)
					end
				end
			end
			
			if name == "freshdead" then
				v.AcceptInput = function(self, name, activator, caller, args)
					if activator:Frags() >= 2 then
						activator:SetZombieClass(GAMEMODE.ZombieClasses["Fresh Dead"].Index)
						activator:UnSpectateAndSpawn()
						activator:TakeBrains(2)
					else
						net.Start("zs_centernotify")
							net.WriteTable({COLOR_RED, "뇌가 부족하다!"})
						net.Send(activator)
					end
				end
			end
			
			if name == "freshdead" then
				v.AcceptInput = function(self, name, activator, caller, args)
					if activator:Frags() >= 2 then
						activator:SetZombieClass(GAMEMODE.ZombieClasses["Fresh Dead"].Index)
						activator:UnSpectateAndSpawn()
						activator:TakeBrains(2)
					else
						net.Start("zs_centernotify")
							net.WriteTable({COLOR_RED, "뇌가 부족하다!"})
						net.Send(activator)
					end
				end
			end
			
			if name == "legs" then
				v.AcceptInput = function(self, name, activator, caller, args)
					if activator:Frags() >= 2 then
						activator:SetZombieClass(GAMEMODE.ZombieClasses["Zombie Legs"].Index)
						activator:UnSpectateAndSpawn()
						activator:TakeBrains(2)
					else
						net.Start("zs_centernotify")
							net.WriteTable({COLOR_RED, "뇌가 부족하다!"})
						net.Send(activator)
					end
				end
			end
			
			if name == "chem" then
				v.AcceptInput = function(self, name, activator, caller, args)
					if activator:Frags() >= 6 then
						activator:SetZombieClass(GAMEMODE.ZombieClasses["Chem Zombie"].Index)
						activator:UnSpectateAndSpawn()
						activator:TakeBrains(6)
					else
						net.Start("zs_centernotify")
							net.WriteTable({COLOR_RED, "뇌가 부족하다!"})
						net.Send(activator)
					end
				end
			end
		end
	end
end)
