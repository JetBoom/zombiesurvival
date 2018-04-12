include("sh_zombieescape.lua")

if not GM.ZombieEscape then return end

hook.Add("HUDPaint", "zombieescape", function()
	if not MySelf:IsValid() then return end

	if GAMEMODE:GetWave() == 0 and not GAMEMODE:GetWaveActive() and (MySelf:Team() == TEAM_UNDEAD or CurTime() < GAMEMODE:GetWaveStart() - GAMEMODE.ZE_FreezeTime) then
		draw.SimpleTextBlur(translate.Format("ze_humans_are_frozen_until_x", GAMEMODE.ZE_FreezeTime), "ZSHUDFontSmall", ScrW() / 2, ScrH() / 2, COLOR_DARKRED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end)

/*---------------------------------------------------------
	Boss Health
---------------------------------------------------------*/
local BossEntities = {}
local LastBossUpdate = RealTime()
local BossGlowColor = Color(129, 180, 30, 180)

surface.CreateFont( "BossFont", { font = "Impact", size = 24, weight = 400, antialias = true } )

local gradientUp = surface.GetTextureID("VGUI/gradient_up")
local maxBarHealth = 100
local deltaVelocity = 0.08 -- [0-1]
local bw = 12 -- bar segment width
local padding = 2
local colGreen = Color( 129, 215, 30, 255 )
local colDarkGreen = Color( 50, 83, 35, 255 )
local colDarkRed = Color( 132, 43, 24, 255 )
local curPercent = nil

local function DrawBossHealth()
	for k, boss in pairs(BossEntities) do

		if !IsValid(boss.Ent) or boss.Health <= 1 then BossEntities[k] = nil return end
		if (LocalPlayer():GetPos() - boss.Ent:GetPos()):Length() > 4096 then return end

		halo.Add({boss.Ent}, HSVToColor( 120 * ( boss.Health / boss.MaxHealth ), 1, 1 ) )

		-- Let's do some calculations first
		maxBarHealth = (boss.MaxHealth > 999) and 1000 or 100
		local name = boss.Name and boss.Name or "BOSS"
		local totalHealthBars = math.ceil(boss.MaxHealth / maxBarHealth)
		local curHealthBar = math.floor(boss.Health / maxBarHealth)
		local percent = (boss.Health - curHealthBar*maxBarHealth) / maxBarHealth
		curPercent = !curPercent and 1 or math.Approach(curPercent, percent, math.abs(curPercent-percent)*0.08)

		local x, y = ScrW()/2, 80
		local w, h = ScrW()/3, 20

		-- Boss name
		surface.SetFont("BossFont")
		local tw, th = surface.GetTextSize(name)
		local x3, y3 = x-(w/2), y + h - padding*2
		local w3, h3 = tw + padding*4, th + padding
		draw.RoundedBox( 4, x3, y3, w3, h3, Color( 0, 0, 0, 255 ) )
		draw.SimpleText(name, "BossFont", x3 + padding*2, y3 + padding, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

		-- Boss health bar segments
		local rw, rh = (bw + padding)*totalHealthBars + padding, th + padding
		local x4, y4 = x+(w/2)-rw, y + h - padding*2
		draw.RoundedBox( 4, x4, y4, rw, rh, Color( 0, 0, 0, 255 ) )

		for i=0,totalHealthBars-1 do
			local col = (i<curHealthBar) and colGreen or colDarkGreen
			draw.RoundedBox( 4, x4 + (bw + padding)*i + padding, y4 + padding*3, bw, bw + padding*2, col )
		end

		-- Health bar background
		draw.RoundedBox( 4, x-(w/2), y, w, h, Color( 0, 0, 0, 255 ) )

		-- Boss health bar
		local x2, y2 = x-(w/2) + padding, y + padding
		local w2, h2 = w - padding*2, h - padding*2
		draw.RoundedBox( 4, x2, y2, w2, h2, colDarkGreen ) -- dark green background
		draw.RoundedBox( 0, x2, y2, w*curPercent - padding*2, h2, colGreen )

		surface.SetDrawColor(0,0,0,100)
		surface.SetTexture(gradientUp)
		surface.DrawTexturedRect( x2, y2, w2, h2 )

	end
end
hook.Add( "HUDPaint", "BossHealth", DrawBossHealth )

local function RecieveBossSpawn()

	local index = net.ReadFloat()
	local name = net.ReadString()

	local boss = BossEntities[index]
	if !boss then
		BossEntities[index] = {}
		boss = BossEntities[index]
		boss.Ent = Entity(index)
		boss.Name = string.upper(name)
		boss.bSpawned = true

		if CVars.BossDebug:GetInt() > 0 then
			Msg("BOSS SPAWN\n")
			Msg("\tName: " .. name .. "\n")
			Msg("\tEntity: " .. tostring(BossEntities[index].Ent) .. "\n")
		end
	end


end
net.Receive( "BossSpawn", RecieveBossSpawn )

local function RecieveBossUpdate()

	local index = net.ReadFloat()
	local health, maxhealth = net.ReadFloat(), net.ReadFloat()

	local boss = BossEntities[index]
	if !boss then
		if CVars.BossDebug:GetInt() > 0 then
			Msg("Received boss update for non-existant boss.\n")
		end
		BossEntities[index] = {}
		boss = BossEntities[index]
		boss.Ent = Entity(index)
	end

	boss.Health = health
	boss.MaxHealth = maxhealth
	if CVars.BossDebug:GetInt() > 0 then
		Msg("BOSS UPDATE\n")
		Msg("\tEntity: " .. tostring(BossEntities[index].Ent) .. "\n")
		Msg("\tHealth: " .. health .. "\n")
		Msg("\tMaxHealth: " .. boss.MaxHealth .. "\n")
	end

	LastBossUpdate = RealTime()

end
net.Receive( "BossTakeDamage", RecieveBossUpdate )

local function RecieveBossDefeated()

	local index = net.ReadFloat()

	if !BossEntities[index] then
		if CVars.BossDebug:GetInt() > 0 then
			Msg("Warning: Received boss death for non-existant boss!\n")
		end
	else
		if CVars.BossDebug:GetInt() > 0 then
			Msg("BOSS DEATH\n")
			Msg("\tEntity: " .. tostring(BossEntities[index].Ent) .. "\n")
		end
		BossEntities[index] = nil
	end

end
net.Receive( "BossDefeated", RecieveBossDefeated )
