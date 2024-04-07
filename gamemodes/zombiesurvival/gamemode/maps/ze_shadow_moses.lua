AddCSLuaFile()

local weapon_meta = FindMetaTable([[Weapon]])
weapon_meta.EngineSendWeaponAnim = weapon_meta.EngineSendWeaponAnim or weapon_meta.SendWeaponAnim
function weapon_meta:SendWeaponAnim(anim)
	if self.IsSilenced then
		if     anim == ACT_VM_PRIMARYATTACK then anim =  ACT_VM_PRIMARYATTACK_SILENCED
		elseif anim == ACT_VM_RELOAD then anim = ACT_VM_RELOAD_SILENCED
		elseif anim == ACT_VM_DRYFIRE then anim = ACT_VM_DRYFIRE_SILENCED
		elseif anim == ACT_VM_IDLE then anim = ACT_VM_IDLE_SILENCED
		elseif anim == ACT_VM_DRAW then anim = ACT_VM_DRAW_SILENCED
		end
	end
	return self:EngineSendWeaponAnim(anim)
end

hook.Add("Initialize", "ZESM Init SH", function()
	GAMEMODE.ZombieEscapeWeapons = {"weapon_zs_zedeagle"}

	local deagle = weapons.GetStored("weapon_zs_zedeagle")
	if deagle then
		deagle.PrintName = "'SOCOM' Mark 23"
		deagle.IsSilenced = true
		deagle.ViewModel = "models/weapons/cstrike/c_pist_usp.mdl"
		deagle.WorldModel = "models/weapons/w_pist_usp_silencer.mdl"
		deagle.IronSightsPos = Vector(-5.9, 12, 2.3)
		deagle.HUD3DBone = "v_weapon.USP_Slide"
		deagle.Primary.Sound = Sound("Weapon_USP.SilencedShot")
		deagle.Primary.ClipSize = 12
		deagle.Primary.Damage = 195
		deagle.Primary.Delay = 0.18
		function deagle:Deploy() self:SendWeaponAnim(ACT_VM_DRAW) return self.BaseClass.Deploy(self) end
	end

	GAMEMODE.RandomPlayerModels = {
		"male11",
		"male16",
		"male18",
	}

	GAMEMODE.PlayerSpawnO = GAMEMODE.PlayerSpawnO or GAMEMODE.PlayerSpawn or function()end
	function GAMEMODE:PlayerSpawn(p)
		GAMEMODE:PlayerSpawnO(p)
		if p:Team() == TEAM_HUMAN then
			p:SelectRandomPlayerModel()
		else
			p:SetModel("models/player/arctic.mdl")
		end
	end

	GAMEMODE.WaveZeroLength = 0
end)

if SERVER then

	local function boundcheck(a1, a2, b1, b2)
		if a1 > a2 then local swap = a1 a1 = a2 a2 = swap end
		if b1 > b2 then local swap = b1 b1 = b2 b2 = swap end
		if a2 < b1 then return false end
		if b2 < a1 then return false end
		return true
	end

	local function intersect_boxes(amin, amax, bmin, bmax)
		return
			boundcheck(amin.x, amax.x, bmin.x, bmax.x) and
			boundcheck(amin.y, amax.y, bmin.y, bmax.y) and
			boundcheck(amin.z, amax.z, bmin.z, bmax.z)
	end

	local psyfirstpos, psylastpos, spawnfirstpos, spawnlastpos
	local hurt_spawntop = {Vector(-1652, -12925, 2019), Vector(-1636, -13288, 2093)}
	local hurt_spawnmid = {Vector(-2148, -12924, 671), Vector(-1600, -13500, 726)}
	local hurt_spawnbotfloor = {Vector(-2243, -12739, -360), Vector(-1594, -13397, -239)}
	local hurt_spawnbotedge = {Vector(-2171, -13349, -56), Vector(-1631, -13374, 307)}
	local hurt_psyuptop = {Vector(-470, 752, 2484), Vector(-687, 528, 2507)}
	local hurt_psyupdoor = {Vector(-448, 538, 2420), Vector(-683, 585, 2328)}
	local hurt_psydownfloor = {Vector(-686, 510, 1838), Vector(-459, 759, 1817)}
	local hurt_psydowndoor = {Vector(-450, 527, 1870), Vector(-702, 558, 1957)}
	local function dynhurts()
		local t = {}

		local spawnelev = ents.GetMapCreatedEntity(1328)
		if IsValid(spawnelev) then
			local spawnpos = spawnelev:GetPos()
			if not spawnfirstpos then spawnfirstpos = spawnpos end
			if spawnpos == spawnlastpos and spawnfirstpos ~= spawnpos then
				if spawnpos.z > 800 then
					t[#t+1] = hurt_spawntop
				elseif spawnpos.z > 650 then
					t[#t+1] = hurt_spawnmid
				else
					if spawnpos.z < 0 then
						t[#t+1] = hurt_spawnbotfloor
					end
					t[#t+1] = hurt_spawnbotedge
				end
			end
			spawnlastpos = spawnpos
		end

		local psyelev = ents.GetMapCreatedEntity(1263)
		if IsValid(psyelev) then
			local psypos = psyelev:GetPos()
			if not psyfirstpos then psyfirstpos = psypos end
			if psypos == psylastpos and psyfirstpos ~= psypos then
				if psypos.z > 2200 then
					t[#t+1] = hurt_psyuptop
					t[#t+1] = hurt_psyupdoor
				else
					t[#t+1] = hurt_psydownfloor
					t[#t+1] = hurt_psydowndoor
				end
			end
			psylastpos = psypos
		end

		return t
	end

	timer.Create("ZESM Killer", 0.75, 0, function()
		local allhurts = dynhurts()

		for k,v in pairs(player.GetAll()) do
			if v:Alive() then
				if v:GetPos().z < -5400 then
					v:Kill()
				end

				for _, t in pairs(allhurts) do
					local a, b = v:WorldSpaceAABB()
					if intersect_boxes(a, b, t[1], t[2]) then
						v:TakeSpecialDamage(math.ceil(v:GetMaxHealth()/5), DMG_CRUSH)
					end
				end
			end
		end
	end)

	local zonedefault = {Vector(), Vector(), Vector(-2236, -14527, -49), "Space"}
	local zones = {
		-- min, max, spawn, name
		zonedefault,
		{Vector(-6173, -4094, -4177), Vector(-1627, 4918, 60), Vector(-3832, 3769, -3703), "METAL GEAR"},
		{Vector(-6074, 4325, -3822), Vector(-2375, 10834, 1473), Vector(-2761, 10230, 608), "Killevators"},
		{Vector(-4850, 10248, 351), Vector(-544, 13098, 1615), Vector(-1266, 12319, 1095), "Spacewalk"},
		{Vector(-2430, 11897, 1560), Vector(4212, 16203, 2778), Vector(3370, 12979, 1719), "Warehouses"},
		{Vector(654, 10363, 1660), Vector(2219, 12232, 9120), Vector(1414, 11466, 8256), "Tower 2"},
		{Vector(480, 8465, 1564), Vector(2650, 10419, 9116), Vector(1597, 8558, 1904), "Tower 1"},
		{Vector(-1525, 2717, 1640), Vector(2706, 8769, 2723), Vector(1477, 3124, 1712), "Maze"},
		{Vector(-1531, 1714, 1714), Vector(-36, 3218, 2165), Vector(-893, 1865, 1774), "Psycho"},
		{Vector(-1653, -1033, 1683), Vector(814, 1864, 2070), Vector(-86, 821, 1774), "Prison"},
		{Vector(-1538, -1962, 2069), Vector(862, 1469, 2880), Vector(-121, -1015, 2231), "Elevator Room"},
		{Vector(-977, -5671, 2040), Vector(1450, -1609, 3102), Vector(-150, -4825, 2100), "Snow"},
		{Vector(-2310, -7805, 1920), Vector(1986, -5327, 3066), Vector(-1545, -6457, 2356), "Storage Room"},
		{Vector(-3460, -13467, 1960), Vector(2737, -7519, 3743), Vector(-2792, -10632, 2103), "Hind"},
		{Vector(-2988, -15962, -729), Vector(-905, -12809, 2795), Vector(-2236, -14527, -49), "Spawn"},
		zonedefault
	}
	for k, t in ipairs(zones) do
		t.min = t[1]
		t.max = t[2]
		t.spawnpos = t[3]
		t.name = t[4]
		t.id = k
		t.data = {}
		t.prev = zones[k+1] or zonedefault
	end
	local function plyzone(p)
		for k, z in ipairs(zones) do
			if p:GetPos():WithinAABox(z.min, z.max) then
				return z
			end
		end
		return zonedefault
	end
	timer.Create("ZESM Zoning", 0.2, 0, function()
		for _, p in pairs(player.GetAll()) do
			local oldzone = p.ZESM_Zone
			local zone = plyzone(p)
			if oldzone ~= zone then
				p.ZESM_Zone = zone
				if not oldzone or zone.id < oldzone.id then
					p.ZESM_LatestZone = zone
					if not GAMEMODE.ZESM_LatestZone or zone.id < GAMEMODE.ZESM_LatestZone.id then
						GAMEMODE.ZESM_LatestZone = zone
					end
				end
			end
		end
		local lzonep = GAMEMODE.ZESM_LatestZone and GAMEMODE.ZESM_LatestZone.prev or zonedefault
		for _, p in pairs(player.GetAll()) do
			if lzonep ~= zonedefault and lzonep.id < p.ZESM_Zone.id then
				p:SetPos(lzonep.spawnpos)
			end
		end
	end)

end
