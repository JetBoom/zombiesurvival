if CLIENT then return end

local function DoCatBomb(pl)
	BroadcastLua([[surface.PlaySound("vo/Citadel/gman_exit02.wav")]])

	timer.Create("catbombmessage", 1, 5, function() for _, ply in pairs(player.GetAll()) do ply:PrintMessage(HUD_PRINTCENTER, "INCOMING CATBOMB!") end end)
	
	local tr = util.TraceLine({start=pl:GetShootPos(), endpos = pl:GetShootPos() + pl:GetAimVector() * 10000, ignore=pl})
	tr = util.TraceLine({start=tr.HitPos, endpos=tr.HitPos + Vector(0,0,5000), ignore=pl})
	local pos = tr.HitPos - Vector(0,0,100)
	local ent = ents.Create("prop_physics")
	if ent:IsValid() then
		ent:SetModel("models/props_junk/garbage_bag001a.mdl")
		ent:SetPos(pos)
		ent:Spawn()
		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:ApplyForceCenter(Vector(0,0,-1750))
			phys:EnableGravity(false)
			phys:SetMass(20000)
		end
		timer.Simple(8.5, function()
			CatBombExplode(ent)
		end)

		CATBOMB_ENTITY = ent
	end
end

local function KillEverything()
	for _, pl in pairs(player.GetAll()) do
		if pl:Alive() then
			pl:Kill()
			if pl.Gib then pl:Gib() end
		end
	end
	for _, ent in pairs(ents.GetAll()) do
		if ent:IsValid() then
			util.BlastDamage(ent, ent, ent:GetPos(), 128, 1000)
		end
	end
end

function BroadcastLua(lua)
	for _, pl in pairs(player.GetAll()) do
		pl:SendLua(lua)
	end
end

function CatBombExplode(prop)
	BroadcastLua([[surface.PlaySound("ambient/explosions/citadel_end_explosion1.wav")]])
	for i=1, 30 do
		timer.Simple(i*0.35, function()
			BroadcastLua([[surface.PlaySound("ambient/explosions/explode_"..math.random(1,8)..".wav")]])
		end)
	end
	timer.Create("CATBOMBFUCKEVERYTHING", 0.75, 15, KillEverything)
	for i=1, 65 do
		local ent = ents.Create("env_ar2explosion")
		if ent:IsValid() then
			ent:SetPos(prop:GetPos() + Vector(math.random(-1500, 1500), math.random(-1500, 1500), math.random(-600, 800)))
			ent:Spawn()
			ent:Fire("explode", "", i*0.1)
			ent:Fire("kill", "", (i*0.1)+0.05)
			local glow = ents.Create("env_lightglow")
			if glow:IsValid() then
				glow:SetKeyValue("rendercolor" , "255 255 200")
				glow:SetKeyValue("VerticalGlowSize", "120")
				glow:SetKeyValue("HorizontalGlowSize", "120")
				glow:SetKeyValue("MinDist", 15)
				glow:SetKeyValue("MaxDist", 4096)
				glow:SetKeyValue("OuterMaxDist", 250)
				glow:SetKeyValue("GlowProxySize", "15")
				glow:SetPos(prop:GetPos() + Vector(math.random(-2000, 2000), math.random(-2000, 2000), math.random(-600, 3500)))
				glow:Spawn()
				glow:Fire("kill", "", math.random(5, 15))
			end
		end
	end
	prop:Fire("kill", "15", 0)
end

concommand.Add("catbomb", function(sender, command, arguments)
	if not sender:IsSuperAdmin() then return end

	DoCatBomb(sender)	
end)
