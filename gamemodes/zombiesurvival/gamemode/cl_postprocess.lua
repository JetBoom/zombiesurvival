function GM:RenderScreenspaceEffects()
end

GM.PostProcessingEnabled = CreateClientConVar("zs_postprocessing", 1, true, false):GetBool()
cvars.AddChangeCallback("zs_postprocessing", function(cvar, oldvalue, newvalue)
	GAMEMODE.PostProcessingEnabled = tonumber(newvalue) == 1
end)

GM.FilmGrainEnabled = CreateClientConVar("zs_filmgrain", 1, true, false):GetBool()
cvars.AddChangeCallback("zs_filmgrain", function(cvar, oldvalue, newvalue)
	GAMEMODE.FilmGrainEnabled = tonumber(newvalue) == 1
end)

GM.FilmGrainOpacity = CreateClientConVar("zs_filmgrainopacity", 50, true, false):GetInt()
cvars.AddChangeCallback("zs_filmgrainopacity", function(cvar, oldvalue, newvalue)
	GAMEMODE.FilmGrainOpacity = math.Clamp(tonumber(newvalue) or 0, 0, 255)
end)

GM.ColorModEnabled = CreateClientConVar("zs_colormod", "1", true, false):GetBool()
cvars.AddChangeCallback("zs_colormod", function(cvar, oldvalue, newvalue)
	GAMEMODE.ColorModEnabled = tonumber(newvalue) == 1
end)

GM.Auras = CreateClientConVar("zs_auras", 1, true, false):GetBool()
cvars.AddChangeCallback("zs_auras", function(cvar, oldvalue, newvalue)
	GAMEMODE.Auras = tonumber(newvalue) == 1
end)

GM.AuraColorEmpty = Color(CreateClientConVar("zs_auracolor_empty_r", 255, true, false):GetInt(), CreateClientConVar("zs_auracolor_empty_g", 0, true, false):GetInt(), CreateClientConVar("zs_auracolor_empty_b", 0, true, false):GetInt(), 255)
GM.AuraColorFull = Color(CreateClientConVar("zs_auracolor_full_r", 20, true, false):GetInt(), CreateClientConVar("zs_auracolor_full_g", 255, true, false):GetInt(), CreateClientConVar("zs_auracolor_full_b", 20, true, false):GetInt(), 255)

cvars.AddChangeCallback("zs_auracolor_empty_r", function(cvar, oldvalue, newvalue)
	GAMEMODE.AuraColorEmpty.r = math.Clamp(math.ceil(tonumber(newvalue) or 0), 0, 255)
end)

cvars.AddChangeCallback("zs_auracolor_empty_g", function(cvar, oldvalue, newvalue)
	GAMEMODE.AuraColorEmpty.g = math.Clamp(math.ceil(tonumber(newvalue) or 0), 0, 255)
end)

cvars.AddChangeCallback("zs_auracolor_empty_b", function(cvar, oldvalue, newvalue)
	GAMEMODE.AuraColorEmpty.b = math.Clamp(math.ceil(tonumber(newvalue) or 0), 0, 255)
end)

cvars.AddChangeCallback("zs_auracolor_full_r", function(cvar, oldvalue, newvalue)
	GAMEMODE.AuraColorFull.r = math.Clamp(math.ceil(tonumber(newvalue) or 0), 0, 255)
end)

cvars.AddChangeCallback("zs_auracolor_full_g", function(cvar, oldvalue, newvalue)
	GAMEMODE.AuraColorFull.g = math.Clamp(math.ceil(tonumber(newvalue) or 0), 0, 255)
end)

cvars.AddChangeCallback("zs_auracolor_full_b", function(cvar, oldvalue, newvalue)
	GAMEMODE.AuraColorFull.b = math.Clamp(math.ceil(tonumber(newvalue) or 0), 0, 255)
end)


local DrawColorModify = DrawColorModify
local DrawSharpen = DrawSharpen
local EyePos = EyePos
local TEAM_HUMAN = TEAM_HUMAN
local TEAM_UNDEAD = TEAM_UNDEAD
local render_SetMaterial = render.SetMaterial
local render_DrawSprite = render.DrawSprite
local render_SetLightingMode = render.SetLightingMode
local math_Approach = math.Approach
local FrameTime = FrameTime
local CurTime = CurTime
local math_sin = math.sin
local math_min = math.min
local math_max = math.max
local math_abs = math.abs
local team_GetPlayers = team.GetPlayers

local FullBright = false

local tColorModDead = {
	["$pp_colour_contrast"] = 1.25,
	["$pp_colour_colour"] = 0,
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = -0.02,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local tColorModHuman = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local tColorModZombie = {
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1.25,
	["$pp_colour_colour"] = 0.5,
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local tColorModZombieVision = {
	["$pp_colour_colour"] = 3,
	["$pp_colour_brightness"] = -0.1,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_mulr"]	= 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0,
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0.1,
	["$pp_colour_addb"] = 0
}

local tColorModNightVision = {
	["$pp_colour_colour"] = 0.99,
	["$pp_colour_brightness"] = -0.34,
	["$pp_colour_contrast"] = 1.46,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 1,
	["$pp_colour_mulb"] = 0,
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0.2,
	["$pp_colour_addb"] = 0
}

local redview = 0
local fear = 0
function GM:_RenderScreenspaceEffects()
	if MySelf.Confusion and MySelf.Confusion:IsValid() then
		MySelf.Confusion:RenderScreenSpaceEffects()
	end

	fear = math_Approach(fear, self:CachedFearPower(), FrameTime())

	if not self.PostProcessingEnabled then return end

	if self.DrawPainFlash and self.HurtEffect > 0 then
		DrawSharpen(1, math_min(6, self.HurtEffect * 3))
	end

	if self.ColorModEnabled then
		if not MySelf:Alive() and MySelf:GetObserverMode() ~= OBS_MODE_CHASE then
			if not MySelf:HasWon() then
				tColorModDead["$pp_colour_colour"] = (1 - math_min(1, CurTime() - self.LastTimeAlive)) * 0.5
				DrawColorModify(tColorModDead)
			end
		elseif MySelf:Team() == TEAM_UNDEAD then
			if self.m_ZombieVision then
				DrawColorModify(tColorModZombieVision)
			else
				tColorModZombie["$pp_colour_colour"] = math_min(1, 0.25 + math_min(1, (CurTime() - self.LastTimeDead) * 0.5) * 1.75 * fear)

				DrawColorModify(tColorModZombie)
			end
		else
			if self.m_NightVision then
				DrawColorModify(tColorModNightVision)
			else
				local curr = tColorModHuman["$pp_colour_addr"]
				local health = MySelf:Health()
				local maxhealth = MySelf:GetMaxHealth() / 3
				if health <= maxhealth then
					redview = math_Approach(redview, 1 - health / maxhealth, FrameTime() * 0.2)
				elseif 0 < curr then
					redview = math_Approach(redview, 0, FrameTime() * 0.2)
				end

				tColorModHuman["$pp_colour_addr"] = redview * (0.035 + math_abs(math_sin(CurTime() * 2)) * 0.14)
				tColorModHuman["$pp_colour_brightness"] = fear * -0.045
				tColorModHuman["$pp_colour_contrast"] = 1 + fear * 0.15
				tColorModHuman["$pp_colour_colour"] = 1 - fear * 0.725 --0.85

				DrawColorModify(tColorModHuman)
			end
		end
	end
end

function GM:_RenderScene()
	if (self.m_ZombieVision and MySelf:Team() == TEAM_UNDEAD) or (self.m_NightVision and MySelf:Team() == TEAM_HUMAN and not MySelf:GetStatus("dimvision")) then
		render_SetLightingMode(1)
		FullBright = true
	else
		FullBright = false
	end
end

function GM:FullBrightOn()
	if FullBright then
		render_SetLightingMode(1)
	end
end

function GM:FullBrightOff()
	if FullBright then
		render_SetLightingMode(0)
	end
end

hook.Add("PreDrawOpaqueRenderables", "ZFullBright", GM.FullBrightOff)
hook.Add("PreDrawTranslucentRenderables", "ZFullBright", GM.FullBrightOff)
hook.Add("PostDrawTranslucentRenderables", "ZFullBright", GM.FullBrightOn)
hook.Add("PreDrawViewModel", "ZFullBright", GM.FullBrightOff)
hook.Add("RenderScreenspaceEffects", "ZFullBright", GM.FullBrightOff)

local matGlow = Material("Sprites/light_glow02_add_noz")
local colHealthEmpty = GM.AuraColorEmpty
local colHealthFull = GM.AuraColorFull
local colHealth = Color(255, 255, 255)
function GM:DrawHumanIndicators()
	if MySelf:Team() ~= TEAM_UNDEAD or not self.Auras or self.m_ZombieVision then return end

	local eyepos = EyePos()
	local range, dist, healthfrac, pos, size
	for _, pl in pairs(team_GetPlayers(TEAM_HUMAN)) do
		range = pl:GetAuraRangeSqr()
		dist = pl:GetPos():DistToSqr(eyepos)
		if pl:Alive() and dist <= range and (not pl:GetDTBool(DT_PLAYER_BOOL_NECRO) or dist >= 27500) then
			healthfrac = math_max(pl:Health(), 0) / pl:GetMaxHealth()
			colHealth.r = math_Approach(colHealthEmpty.r, colHealthFull.r, math_abs(colHealthEmpty.r - colHealthFull.r) * healthfrac)
			colHealth.g = math_Approach(colHealthEmpty.g, colHealthFull.g, math_abs(colHealthEmpty.g - colHealthFull.g) * healthfrac)
			colHealth.b = math_Approach(colHealthEmpty.b, colHealthFull.b, math_abs(colHealthEmpty.b - colHealthFull.b) * healthfrac)

			pos = pl:WorldSpaceCenter()

			render_SetMaterial(matGlow)
			render_DrawSprite(pos, 13, 13, colHealth)
			size = math_sin(self.HeartBeatTime + pl:EntIndex()) * 50 - 21
			if size > 0 then
				render_DrawSprite(pos, size * 1.5, size, colHealth)
				render_DrawSprite(pos, size, size * 1.5, colHealth)
			end
		end
	end
end

function GM:ToggleZombieVision(onoff)
	if onoff == nil then
		onoff = not self.m_ZombieVision
	end

	if onoff then
		if not self.m_ZombieVision then
			self.m_ZombieVision = true
			MySelf:EmitSound("npc/stalker/breathing3.wav", 0, 230)
		end
	elseif self.m_ZombieVision then
		self.m_ZombieVision = nil
		MySelf:EmitSound("npc/zombie/zombie_pain6.wav", 0, 110)
	end
end

local CModWhiteOut = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}
local WhiteOutEnd
local WhiteOutFadeTime
local function RenderWhiteOut()
	local dt = math_max(WhiteOutEnd - CurTime(), 0) / WhiteOutFadeTime
	if dt <= 0 then
		WhiteOutEnd = nil
		WhiteOutFadeTime = nil
		hook.Remove("RenderScreenspaceEffects", "WhiteOut")
	else
		local size = 5 + dt * 10
		CModWhiteOut["$pp_colour_brightness"] = dt ^ 2
		DrawBloom(1 - dt, dt * 3, size, size, 1, 1, 1, 1, 1)
		DrawColorModify(CModWhiteOut)
	end
end

function util.WhiteOut(time, fadeouttime)
	time = time or 1

	WhiteOutEnd = math_max(CurTime() + time, WhiteOutEnd or 0)
	WhiteOutFadeTime = math_max(fadeouttime or time, WhiteOutFadeTime or 0)

	hook.Add("RenderScreenspaceEffects", "WhiteOut", RenderWhiteOut)
end
