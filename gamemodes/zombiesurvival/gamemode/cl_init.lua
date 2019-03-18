-- Sometimes persistent ones don't get created.
local dummy = CreateClientConVar("_zs_dummyconvar", 1, false, false)
local oldCreateClientConVar = CreateClientConVar
function CreateClientConVar(...)
	return oldCreateClientConVar(...) or dummy
end

include("sh_globals.lua")

include("obj_entity_extend_cl.lua")
include("obj_player_extend_cl.lua")
include("obj_weapon_extend_cl.lua")

include("loader.lua")

include("shared.lua")
include("cl_draw.lua")
include("cl_util.lua")
include("cl_options.lua")
include("cl_scoreboard.lua")
include("cl_targetid.lua")
include("cl_postprocess.lua")
include("cl_voicesets.lua")
include("cl_net.lua")
include("skillweb/cl_skillweb.lua")

include("vgui/dteamcounter.lua")
include("vgui/dmodelpanelex.lua")
include("vgui/dammocounter.lua")
include("vgui/dteamheading.lua")
include("vgui/dmodelkillicon.lua")

include("vgui/dexroundedpanel.lua")
include("vgui/dexroundedframe.lua")
include("vgui/dexrotatedimage.lua")
include("vgui/dexnotificationslist.lua")
include("vgui/dexchanginglabel.lua")

include("vgui/mainmenu.lua")
include("vgui/pmainmenu.lua")
include("vgui/poptions.lua")
include("vgui/phelp.lua")
include("vgui/pclassselect.lua")
include("vgui/pweapons.lua")
include("vgui/pendboard.lua")
include("vgui/pworth.lua")
include("vgui/parsenal.lua")
include("vgui/premantle.lua")
include("vgui/dpingmeter.lua")
include("vgui/dsidemenu.lua")
include("vgui/dspawnmenu.lua")
include("vgui/zsgamestate.lua")
include("vgui/zshealtharea.lua")
include("vgui/zsstatusarea.lua")

include("cl_dermaskin.lua")
include("cl_deathnotice.lua")
include("cl_floatingscore.lua")
include("cl_hint.lua")
include("cl_thirdperson.lua")

include("itemstocks/cl_stock.lua")

include("cl_zombieescape.lua")

w, h = ScrW(), ScrH()

MySelf = MySelf or NULL
hook.Add("InitPostEntity", "GetLocal", function()
	MySelf = LocalPlayer()

	GAMEMODE.HookGetLocal = GAMEMODE.HookGetLocal or function(g) end
	gamemode.Call("HookGetLocal", MySelf)
	RunConsoleCommand("initpostentity")

	MySelf:ApplySkills()
end)

-- Remove when model decal crash is fixed.
--[[function util.Decal()
end]]

-- Save on global lookup time.
local collectgarbage = collectgarbage
local render = render
local surface = surface
local draw = draw
local cam = cam
local player = player
local ents = ents
local util = util
local math = math
local string = string
local bit = bit
local gamemode = gamemode
local hook = hook
local Vector = Vector
local VectorRand = VectorRand
local Angle = Angle
local AngleRand = AngleRand
local Entity = Entity
local Color = Color
local FrameTime = FrameTime
local RealTime = RealTime
local CurTime = CurTime
local SysTime = SysTime
local EyePos = EyePos
local EyeAngles = EyeAngles
local pairs = pairs
local ipairs = ipairs
local tostring = tostring
local tonumber = tonumber
local type = type
local ScrW = ScrW
local ScrH = ScrH
local Lerp = Lerp
local EF_DIMLIGHT = EF_DIMLIGHT
local TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER
local TEXT_ALIGN_LEFT = TEXT_ALIGN_LEFT
local TEXT_ALIGN_RIGHT = TEXT_ALIGN_RIGHT
local TEXT_ALIGN_TOP = TEXT_ALIGN_TOP
local TEXT_ALIGN_BOTTOM = TEXT_ALIGN_BOTTOM
local TEXT_ALIGN_TOP_REAL = TEXT_ALIGN_TOP_REAL
local TEXT_ALIGN_BOTTOM_REAL = TEXT_ALIGN_BOTTOM_REAL

local TEAM_HUMAN = TEAM_HUMAN
local TEAM_UNDEAD = TEAM_UNDEAD
local translate = translate

local COLOR_PURPLE = COLOR_PURPLE
local COLOR_GRAY = COLOR_GRAY
local COLOR_RED = COLOR_RED
local COLOR_DARKRED = COLOR_DARKRED
local COLOR_DARKGREEN = COLOR_DARKGREEN
local COLOR_GREEN = COLOR_GREEN
local COLOR_WHITE = COLOR_WHITE

local vector_up = Vector(0, 0, 1)
local vector_down = Vector(0, 0, 1)

--local surface_SetFont = surface.SetFont
--local surface_SetTexture = surface.SetTexture
local surface_SetMaterial = surface.SetMaterial
local surface_SetDrawColor = surface.SetDrawColor
--local surface_DrawLine = surface.DrawLine
local surface_DrawRect = surface.DrawRect
local surface_DrawOutlinedRect = surface.DrawOutlinedRect
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_DrawTexturedRectRotated = surface.DrawTexturedRectRotated
local surface_DrawTexturedRectUV = surface.DrawTexturedRectUV
local surface_PlaySound = surface.PlaySound

local render_SetBlend = render.SetBlend
local render_ModelMaterialOverride = render.ModelMaterialOverride
local render_SetColorModulation = render.SetColorModulation
local render_SuppressEngineLighting = render.SuppressEngineLighting
local cam_IgnoreZ = cam.IgnoreZ
local render_SetMaterial = render.SetMaterial
local render_DrawQuadEasy = render.DrawQuadEasy
local cam_Start3D = cam.Start3D
local cam_End3D = cam.End3D
local cam_Start3D2D = cam.Start3D2D
local cam_End3D2D = cam.End3D2D
local render_FogMode = render.FogMode
local render_FogStart = render.FogStart
local render_FogEnd = render.FogEnd
local render_FogColor = render.FogColor
local render_FogMaxDensity = render.FogMaxDensity
local render_GetFogDistances = render.GetFogDistances
local render_GetFogColor = render.GetFogColor
local render_GetFogMode = render.GetFogMode

local draw_SimpleText = draw.SimpleText
local draw_SimpleTextBlurry = draw.SimpleTextBlurry
local draw_SimpleTextBlur = draw.SimpleTextBlur
local draw_GetFontHeight = draw.GetFontHeight

local MedicalAuraDistance = 800 ^ 2

local M_Player = FindMetaTable("Player")
local P_Team = M_Player.Team

GM.LifeStatsBrainsEaten = 0
GM.LifeStatsHumanDamage = 0
GM.LifeStatsBarricadeDamage = 0
GM.InputMouseX = 0
GM.InputMouseY = 0
GM.LastTimeDead = 0
GM.LastTimeAlive = 0
GM.HeartBeatTime = 0
GM.FOVLerp = 1
GM.HurtEffect = 0
GM.PrevHealth = 0
GM.SuppressArsenalTime = 0
GM.ZombieThirdPerson = false
GM.Beats = {}
GM.CurrentRound = 1

GM.DeathFog = 0
GM.FogStart = 0
GM.FogEnd = 8000
GM.FogRed = 30
GM.FogGreen = 30
GM.FogBlue = 30

function GM:ClickedPlayerButton(pl, button)
end

function GM:ClickedEndBoardPlayerButton(pl, button)
end

function GM:CenterNotify(...)
	if self.CenterNotificationHUD and self.CenterNotificationHUD:IsValid() then
		return self.CenterNotificationHUD:AddNotification(...)
	end
end

function GM:TopNotify(...)
	if self.TopNotificationHUD and self.TopNotificationHUD:IsValid() then
		return self.TopNotificationHUD:AddNotification(...)
	end
end

function GM:_InputMouseApply(cmd, x, y, ang)
	if MySelf:KeyDown(IN_WALK) and MySelf:IsHolding() then
		self.InputMouseX = math.NormalizeAngle(self.InputMouseX - x * 0.02 * GAMEMODE.PropRotationSensitivity)
		self.InputMouseY = math.NormalizeAngle(self.InputMouseY - y * 0.02 * GAMEMODE.PropRotationSensitivity)

		local snap = GAMEMODE.PropRotationSnap
		local snapanglex, snapangley = self.InputMouseX, self.InputMouseY
		if snap > 0 then
			snapanglex = Angle(self.InputMouseX, 0, 0):SnapTo("p", snap).p
			snapangley = Angle(self.InputMouseY, 0, 0):SnapTo("p", snap).p
		end

		RunConsoleCommand("_zs_rotateang", snapanglex, snapangley)
		return true
	end

	if self:UseOverTheShoulder() and P_Team(MySelf) == TEAM_HUMAN then
		self:InputMouseApplyOTS(cmd, x, y, ang)
	end
end

function GM:_GUIMousePressed(mc)
end

function GM:TryHumanPickup(pl, entity)
end

function GM:AddExtraOptions(list, window)
end

function GM:SpawnMenuEnabled()
	return false
end

function GM:SpawnMenuOpen()
	return false
end

function GM:ContextMenuOpen()
	return false
end

function GM:_HUDWeaponPickedUp(wep)
	if P_Team(MySelf) == TEAM_HUMAN and not wep.NoPickupNotification then
		self:Rewarded(wep:GetClass())
	end
end

function GM:HUDItemPickedUp(itemname)
end

function GM:HUDAmmoPickedUp(itemname, amount)
end

function GM:InitPostEntity()
	self:CreateLateVGUI()

	self:AssignItemProperties()
	self:FixWeaponBase()

	self:LocalPlayerFound()

	gamemode.Call("EvaluateFilmMode")

	timer.Simple(2, function() GAMEMODE:GetFogData() end)

	RunConsoleCommand("pp_bloom", "0")
end

local fogstart = 0
local fogend = 0
local fogr = 0
local fogg = 0
local fogb = 0

function GM:SetupFog()
	local power = self.DeathFog
	local rpower = 1 - self.DeathFog

	fogstart = self.FogStart * rpower
	fogend = self.FogEnd * rpower + 150 * power
	fogr = self.FogRed * rpower
	fogg = self.FogGreen * rpower + 40 * power
	fogb = self.FogBlue * rpower

	local dimvision = MySelf.DimVision
	if dimvision and dimvision:IsValid() then
		power = dimvision:GetDim()

		fogstart = Lerp(power, fogstart, 1)
		fogend = Lerp(power, fogend, math.min(148 / math.max(0.01, MySelf.DimVisionEffMul), fogend))
		fogr = Lerp(power, fogr, 0)
		fogg = Lerp(power, fogg, 0)
		fogb = Lerp(power, fogb, 0)
	end
end

function GM:_SetupWorldFog()
	if self.DeathFog == 0 and not MySelf.DimVision then return end

	self:SetupFog()

	render_FogMode(1)

	render_FogStart(fogstart)
	render_FogEnd(fogend)
	render_FogColor(fogr, fogg, fogb)
	render_FogMaxDensity(1)

	return true
end

function GM:_SetupSkyboxFog(skyboxscale)
	if self.DeathFog == 0 and not MySelf.DimVision then return end

	self:SetupFog()

	render_FogMode(1)

	render_FogStart(fogstart * skyboxscale)
	render_FogEnd(fogend * skyboxscale)
	render_FogColor(fogr, fogg, fogb)
	render_FogMaxDensity(1)

	return true
end

function GM:PreDrawSkyBox()
	self.DrawingInSky = true
end

local matSky = CreateMaterial("SkyOverride", "UnlitGeneric", {["$basetexture"] = "color/white", ["$vertexcolor"] = 1, ["$vertexalpha"] = 1, ["$model"] = 1})
local colSky = Color(0, 30, 0)
function GM:PostDrawSkyBox()
	self.DrawingInSky = false

	local dimvision = MySelf.DimVision
	dimvision = dimvision and dimvision:IsValid() and dimvision:GetDim()
	if self.DeathFog > 0 or dimvision then
		colSky.a = math.max(self.DeathFog, dimvision or 0) * 230
		colSky.g = self.DeathFog * 30

		cam_Start3D(EyePos(), EyeAngles())
			render_SuppressEngineLighting(true)

			render_SetMaterial(matSky)

			render_DrawQuadEasy(Vector(0, 0, 10240), Vector(0, 0, -1), 20480, 20480, colSky, 0)
			render_DrawQuadEasy(Vector(0, 10240, 0), Vector(0, -1, 0), 20480, 20480, colSky, 0)
			render_DrawQuadEasy(Vector(0, -10240, 0), Vector(0, 1, 0), 20480, 20480, colSky, 0)
			render_DrawQuadEasy(Vector(10240, 0, 0), Vector(-1, 0, 0), 20480, 20480, colSky, 0)
			render_DrawQuadEasy(Vector(-10240, 0, 0), Vector(1, 0, 0), 20480, 20480, colSky, 0)

			render_SuppressEngineLighting(false)
		cam_End3D()
	end
end

function GM:GetFogData()
	local _fogstart, _fogend = render_GetFogDistances()
	local _fogr, _fogg, _fogb = render_GetFogColor()

	self.FogStart = _fogstart
	self.FogEnd = _fogend
	self.FogRed = _fogr
	self.FogGreen = _fogg
	self.FogBlue = _fogb
end

function GM:ShouldDraw3DWeaponHUD()
	return GAMEMODE.WeaponHUDMode ~= 1
end

function GM:ShouldDraw2DWeaponHUD()
	return GAMEMODE.WeaponHUDMode >= 1 or self:UseOverTheShoulder()
end

local matAura = Material("models/debug/debugwhite")
local skip = false
function GM.PostPlayerDrawMedical(pl)
	if not skip and P_Team(pl) == TEAM_HUMAN and pl ~= MySelf then
		local eyepos = EyePos()
		local dist = pl:NearestPoint(eyepos):DistToSqr(eyepos)
		if dist < MedicalAuraDistance then
			local green = pl:Health() / pl:GetMaxHealth()

			pl.SkipDrawHooks = true
			skip = true

			render_SuppressEngineLighting(true)
			render_ModelMaterialOverride(matAura)
			render_SetBlend((1 - dist / MedicalAuraDistance) * 0.1 * (1 + math.abs(math.sin((CurTime() + pl:EntIndex()) * 4)) * 0.05))
			render_SetColorModulation(1 - green, green, pl:GetDTBool(DT_PLAYER_BOOL_FRAIL) and 1 or 0)
				pl:DrawModel()
			render_SetColorModulation(1, 1, 1)
			render_SetBlend(1)
			render_ModelMaterialOverride()
			render_SuppressEngineLighting(false)

			skip = false
			pl.SkipDrawHooks = false
		end
	end
end

function GM:OnReloaded()
	self.BaseClass.OnReloaded(self)

	self:LocalPlayerFound()
end

-- The whole point of this is so we don't need to check if the local player is valid 1000 times a second.
-- Empty functions get filled when the local player is found.
function GM:Think() end
GM.HUDWeaponPickedUp = GM.Think
GM.Think = GM._Think
GM.HUDShouldDraw = GM.Think
GM.CachedFearPower = GM.Think
GM.CalcView = GM.Think
GM.ShouldDrawLocalPlayer = GM.Think
GM.PostDrawOpaqueRenderables = GM.Think
GM.PostDrawTranslucentRenderables = GM.Think
GM.HUDPaint = GM.Think
GM.HUDPaintBackground = GM.Think
GM.CreateMove = GM.Think
GM.PrePlayerDraw = GM.Think
GM.PostPlayerDraw = GM.Think
GM.InputMouseApply = GM.Think
GM.GUIMousePressed = GM.Think
GM.HUDWeaponPickedUp = GM.Think
function GM:LocalPlayerFound()
	self.Think = self._Think
	self.HUDShouldDraw = self._HUDShouldDraw
	self.CachedFearPower = self._CachedFearPower
	self.CalcView = self._CalcView
	self.ShouldDrawLocalPlayer = self._ShouldDrawLocalPlayer
	self.PostDrawTranslucentRenderables = self._PostDrawTranslucentRenderables
	self.HUDPaint = self._HUDPaint
	self.HUDPaintBackground = self._HUDPaintBackground
	self.CreateMove = self._CreateMove
	self.PrePlayerDraw = self._PrePlayerDraw
	self.PostPlayerDraw = self._PostPlayerDraw
	self.InputMouseApply = self._InputMouseApply
	self.GUIMousePressed = self._GUIMousePressed
	self.HUDWeaponPickedUp = self._HUDWeaponPickedUp
	self.RenderScene = self._RenderScene
	self.SetupSkyboxFog = self._SetupSkyboxFog
	self.SetupWorldFog = self._SetupWorldFog

	LocalPlayer().LegDamage = 0
	LocalPlayer().ArmDamage = 0

	if render.GetDXLevel() >= 80 then
		self.RenderScreenspaceEffects = self._RenderScreenspaceEffects
	end
end

local LastSigilCorrupted = -math.huge
local LastSigilUncorrupted = -math.huge
local function DrawEyeFlash(x, y, size, islast)
	local curtime = CurTime()
	local bsize = size * (1 + curtime * 2 % 1)
	surface_SetDrawColor(220, 0, 0, 240)
	surface_DrawTexturedRectRotated(x, y, bsize, bsize, 0)

	if islast then
		local dt = (curtime - LastSigilCorrupted) / 3
		if dt < 1 then
			local idt = 1 - dt
			surface_SetDrawColor(idt ^ 0.5 * 255, 0, 0, 255)
			surface_DrawTexturedRectRotated(x, y, size * dt * 150, size, dt * 10)
			surface_DrawTexturedRectRotated(x, y, size, size * dt * 150, dt * 10)
		else
			dt = (curtime - LastSigilUncorrupted) / 3
			if dt < 1 then
				local idt = 1 - dt
				surface_SetDrawColor(0, dt ^ 0.5 * 255, 0, 255)
				surface_DrawTexturedRectRotated(x, y, size * idt * 150, size, idt * 10)
				surface_DrawTexturedRectRotated(x, y, size, size * idt * 150, idt * 10)
			end
		end
	end
end

local currentpower = 0
local spawngreen = 0
local matFearMeter = Material("zombiesurvival/fearometer")
local matNeedle = Material("zombiesurvival/fearometerneedle")
local matEyeGlow = Material("Sprites/light_glow02_add_noz")
local matSigil = Material("zombiesurvival/sigil.png")
local matArsenal = Material("zombiesurvival/arsenalcrate.png")
local matResupply = Material("zombiesurvival/resupply.png")
local matRemantler = Material("zombiesurvival/remantler.png")
local matCrossout = Material("zombiesurvival/crossout.png")
local matNest = Material("zombiesurvival/nest.png")
--local matGradientRight = Material("vgui/gradient-r")
--local matGradientLeft = CreateMaterial("gradient-l", "UnlitGeneric", {["$basetexture"] = "vgui/gradient-l", ["$vertexalpha"] = "1", ["$vertexcolor"] = "1", ["$ignorez"] = "1", ["$nomip"] = "1"})
function GM:DrawFearMeter(power, screenscale)
	if currentpower < power then
		currentpower = math.min(power, currentpower + FrameTime() * (math.tan(currentpower) * 2 + 0.05))
	elseif power < currentpower then
		currentpower = math.max(power, currentpower - FrameTime() * (math.tan(currentpower) * 2 + 0.05))
	end

	local w, h = ScrW(), ScrH()
	local size = 192 * screenscale
	local half_size = size / 2
	local mx, my = w / 2 - half_size, h - size

	surface_SetMaterial(matFearMeter)
	surface_SetDrawColor(140, 140, 140, 240)
	surface_DrawTexturedRect(mx, my, size, size)
	if currentpower >= 0.75 then
		local pulse = CurTime() % 3 - 1
		if pulse > 0 then
			pulse = pulse ^ 2
			local pulsesize = pulse * screenscale * 28
			surface_SetDrawColor(140, 140, 140, 120 - pulse * 120)
			surface_DrawTexturedRect(mx - pulsesize, my - pulsesize, size + pulsesize * 2, size + pulsesize * 2)
		end
	end

	surface_SetMaterial(matNeedle)
	surface_SetDrawColor(160, 160, 160, 225)
	local rot = math.Clamp((0.5 - currentpower) + math.sin(RealTime() * 10) * 0.01, -0.5, 0.5) * 300
	surface_DrawTexturedRectRotated(w * 0.5 - math.max(0, rot * size * -0.0001), h - half_size - math.abs(rot) * size * 0.00015, size, size, rot)

	if P_Team(MySelf) == TEAM_UNDEAD then
		if self:GetDynamicSpawning() and self:ShouldUseAlternateDynamicSpawn() then
			local obs = MySelf:GetObserverTarget()
			spawngreen = math.Approach(spawngreen, self:DynamicSpawnIsValid(obs and obs:IsValid() and obs:IsPlayer() and obs:Team() == TEAM_UNDEAD and obs or MySelf) and 1 or 0, FrameTime() * 4)

			local sy = my + size * 0.6953
			local gsize = size * 0.085

			surface_SetMaterial(matEyeGlow)
			surface_SetDrawColor(220 * (1 - spawngreen), 220 * spawngreen, 0, 240)
			surface_DrawTexturedRectRotated(mx + size * 0.459, sy, gsize, gsize, 0)
			surface_DrawTexturedRectRotated(mx + size * 0.525, sy, gsize, gsize, 0)
		end

		if currentpower > 0 and not self.ZombieEscape then
			draw_SimpleTextBlurry(translate.Format("resist_x", math.ceil(self:GetDamageResistance(currentpower) * 100)), "ZSDamageResistance", w * 0.5, my + size * 0.75, Color(currentpower * 200, 200 - currentpower * 200, 0, 255), TEXT_ALIGN_CENTER)
		end
	end

	if self:GetUseSigils() and self.MaxSigils > 0 then
		local sigwid, sighei = screenscale * 18, screenscale * 36
		local extrude = size * 0.25 + sighei / 2
		local angle_current = -180
		local angle_step = 180 / (self.MaxSigils - 1)
		local rad, sigil, health, maxhealth, corrupt, damageflash, sigx, sigy, healthfrac

		local sigils = GAMEMODE.CachedSigils
		local corruptsigils = 0
		for i=1, self.MaxSigils do
			sigil = sigils[i]
			health = 0
			maxhealth = 0
			corrupt = false
			if sigil and sigil:IsValid() then
				health = sigil:GetSigilHealth()
				maxhealth = sigil:GetSigilMaxHealth()
				corrupt = sigil:GetSigilCorrupted()
				corruptsigils = corruptsigils + (corrupt and 1 or 0)
			end

			if health >= 0 then
				rad = math.rad(angle_current)
				sigx = mx + half_size + math.cos(rad) * extrude
				sigy = my + half_size + math.sin(rad) * extrude

				if sigil and sigil:IsValid() then
					damageflash = math.min((CurTime() - sigil:GetSigilLastDamaged()) * 2, 1) * 255
				else
					damageflash = 255
				end
				healthfrac = health / maxhealth
				if corrupt then
					surface_SetDrawColor((255 - damageflash) * healthfrac, damageflash * healthfrac, 0, 220)
				else
					surface_SetDrawColor((255 - damageflash) * healthfrac, damageflash * healthfrac, 220, 220)
				end

				surface_SetMaterial(matSigil)
				surface_DrawTexturedRectRotated(sigx, sigy, sigwid, sighei, angle_current + 90)

				if corrupt then
					surface_SetMaterial(matCrossout)
					surface_SetDrawColor(220, 0, 0, 220)
					surface_DrawTexturedRect(sigx - sigwid / 2, sigy - sighei / 2, sigwid, sighei)
				end

				angle_current = angle_current + angle_step
			end
		end

		local des = corruptsigils / self.MaxSigils --self:GetSigilsDestroyed() / self.MaxSigils
		if des >= 0.3333 then
			surface_SetMaterial(matEyeGlow)

			local eye_size = size * 0.125
			local sy = my + size * 0.6953

			if des >= 0.6666 then
				DrawEyeFlash(mx + size * 0.459, sy, eye_size)
				DrawEyeFlash(mx + size * 0.525, sy, eye_size, true)
			else
				DrawEyeFlash(mx + size * 0.459, sy, eye_size, true)
			end
		end
	end
end

function GM:GetDynamicSpawning()
	return not GetGlobalBool("DynamicSpawningDisabled", false)
end

function GM:TrackLastDeath()
	if MySelf:Alive() then
		self.LastTimeAlive = CurTime()
	else
		self.LastTimeDead = CurTime()
	end
end

function GM:IsClassicMode()
	return GetGlobalBool("classicmode", false)
end

function GM:IsBabyMode()
	return GetGlobalBool("babymode", false)
end

function GM:PostRender()
end

local lastwarntim = -1
--local NextGas = 0
function GM:_Think()
	local time = CurTime()

	if self:GetEscapeStage() == ESCAPESTAGE_DEATH then
		self.DeathFog = math.min(self.DeathFog + FrameTime() / 5, 1)

		--[[if time >= NextGas then
			NextGas = time + 0.01

			local randdir, emitpos, particle
			local eyepos = EyePos()

			local emitter = ParticleEmitter(eyepos)

			for i=1, 3 do
				randdir = VectorRand()
				randdir.z = math.abs(randdir.z)
				randdir:Normalize()
				emitpos = eyepos + randdir * math.Rand(0, 1200)

				particle = emitter:Add("particles/smokey", emitpos)
				particle:SetVelocity(randdir * math.Rand(8, 256))
				particle:SetAirResistance(16)
				particle:SetDieTime(math.Rand(2.2, 3.5))
				particle:SetStartAlpha(math.Rand(70, 90))
				particle:SetEndAlpha(0)
				particle:SetStartSize(1)
				particle:SetEndSize(math.Rand(150, 325))
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-1, 1))
				particle:SetColor(0, math.Rand(20, 45), 0)
			end

			emitter:Finish() emitter = nil collectgarbage("step", 64)
		end]]
	elseif self.DeathFog > 0 then
		self.DeathFog = math.max(self.DeathFog - FrameTime() / 5, 0)
	end

	local health = MySelf:Health()
	if self.PrevHealth and health < self.PrevHealth then
		self.HurtEffect = math.min(self.HurtEffect + (self.PrevHealth - health) * 0.02, 1.5)
	elseif self.HurtEffect > 0 then
		self.HurtEffect = math.max(0, self.HurtEffect - FrameTime() * 0.65)
	end
	self.PrevHealth = health

	self:TrackLastDeath()

	local endtime = self:GetWaveActive() and self:GetWaveEnd() or self:GetWaveStart()
	if endtime ~= -1 then
		local timleft = math.max(0, endtime - time)
		if timleft <= 10 and lastwarntim ~= math.ceil(timleft) then
			lastwarntim = math.ceil(timleft)
			if 0 < lastwarntim then
				LocalPlayer():EmitSound("buttons/lightswitch2.wav", 100, 110 - lastwarntim * 2)
			end
		end
	end

	local myteam = P_Team(MySelf)

	self:PlayBeats(myteam, self:CachedFearPower())

	local thirdperson
	if myteam == TEAM_HUMAN then
		local wep = MySelf:GetActiveWeapon()
		if wep:IsValid() and wep.GetIronsights and wep:GetIronsights() then
			self.FOVLerp = math.Approach(self.FOVLerp, wep.IsScoped and not self.DisableScopes and wep.IronsightsMultiplier or not wep.IsScoped and wep.IronsightsMultiplier or 0.6, FrameTime() * 4)
		elseif self.FOVLerp ~= 1 then
			self.FOVLerp = math.Approach(self.FOVLerp, 1, FrameTime() * 5)
		end

		if MySelf:GetBarricadeGhosting() then
			MySelf:BarricadeGhostingThink()
		end
		thirdperson = self.OverTheShoulder
	else
		self.HeartBeatTime = self.HeartBeatTime + (6 + self:CachedFearPower() * 5) * FrameTime()
		thirdperson = self.ZombieThirdPerson

		--[[if not MySelf:Alive() then
			self:ToggleZombieVision(false)
		end]]
	end
	self.TransparencyRadius = thirdperson and self.TransparencyRadius3p or self.TransparencyRadius1p

	local tab

	for _, pl in pairs(player.GetAll()) do
		if P_Team(pl) == TEAM_UNDEAD then
			tab = pl:GetZombieClassTable()
			if tab.BuildBonePositions then
				if not pl.WasBuildingBonePositions then
					pl.BuildingBones = pl:GetBoneCount() - 1
					pl.WasBuildingBonePositions = true
				end
				pl:ResetBones()
				tab.BuildBonePositions(tab, pl)
			elseif pl.WasBuildingBonePositions then
				pl.WasBuildingBonePositions = nil
				pl:ResetBones()
			end
		elseif pl.WasBuildingBonePositions then
			pl.WasBuildingBonePositions = nil
			pl:ResetBones()
		end
	end
end

function GM:ShouldPlayBeats(teamid, fear)
	return not self.RoundEnded and not self.ZombieEscape and not GetGlobalBool("beatsdisabled", false)
end

local cv_ShouldPlayMusic = CreateClientConVar("zs_playmusic", 1, true, false)
local NextBeat = 0
local LastBeatLevel = 0
function GM:PlayBeats(teamid, fear)
	if RealTime() <= NextBeat or not gamemode.Call("ShouldPlayBeats", teamid, fear) then return end

	--if (LASTHUMAN or self:GetAllSigilsDestroyed()) and cv_ShouldPlayMusic:GetBool() then
	if LASTHUMAN and cv_ShouldPlayMusic:GetBool() then
		MySelf:EmitSound(self.LastHumanSound, 0, 100, self.BeatsVolume)
		NextBeat = RealTime() + SoundDuration(self.LastHumanSound) - 0.025
		return
	end

	if fear <= 0 or not self.BeatsEnabled then return end

	local beats = self.Beats[teamid == TEAM_HUMAN and self.BeatSetHuman or self.BeatSetZombie]
	if not beats then return end

	LastBeatLevel = math.Approach(LastBeatLevel, math.ceil(fear * 10), 3)

	local snd = beats[LastBeatLevel]
	if snd then
		MySelf:EmitSound(snd, 0, 100, self.BeatsVolume)
		NextBeat = RealTime() + (self.SoundDuration[snd] or SoundDuration(snd)) - 0.025
	end
end

local colPackUp = Color(20, 255, 20, 220)
local colPackUpNotOwner = Color(255, 240, 10, 220)
function GM:DrawPackUpBar(x, y, fraction, notowner, screenscale)
	local col = notowner and colPackUpNotOwner or colPackUp

	local maxbarwidth = 270 * screenscale
	local barheight = 11 * screenscale
	local barwidth = maxbarwidth * math.Clamp(fraction, 0, 1)
	local startx = x - maxbarwidth * 0.5

	surface_SetDrawColor(0, 0, 0, 220)
	surface_DrawRect(startx, y, maxbarwidth, barheight)
	surface_SetDrawColor(col)
	surface_DrawRect(startx + 3, y + 3, barwidth - 6, barheight - 6)
	surface_DrawOutlinedRect(startx, y, maxbarwidth, barheight)

	draw_SimpleText(notowner and CurTime() % 2 < 1 and translate.Format("requires_x_people", 4) or notowner and translate.Get("packing_others_object") or translate.Get("packing"), "ZSHUDFontSmall", x, y - draw_GetFontHeight("ZSHUDFontSmall") - 2, col, TEXT_ALIGN_CENTER)
end

local colSigilTeleport = Color(125, 215, 255, 220)
function GM:DrawSigilTeleportBar(x, y, fraction, target, screenscale)
	local maxbarwidth = 270 * screenscale
	local barheight = 11 * screenscale
	local barwidth = maxbarwidth * math.Clamp(fraction, 0, 1)
	local startx = x - maxbarwidth * 0.5

	local letter = "?"
	for i, sigil in pairs(ents.FindByClass("prop_obj_sigil")) do
		if target == sigil then
			letter = string.char(64 + i)
			break
		end
	end

	surface_SetDrawColor(0, 0, 0, 220)
	surface_DrawRect(startx, y, maxbarwidth, barheight)
	surface_SetDrawColor(colSigilTeleport)
	surface_DrawRect(startx + 3, y + 3, barwidth - 6, barheight - 6)
	surface_DrawOutlinedRect(startx, y, maxbarwidth, barheight)

	draw_SimpleText(translate.Format("teleporting_to_sigil", letter), "ZSHUDFontSmall", x, y - draw_GetFontHeight("ZSHUDFontSmall") - 2, colSigilTeleport, TEXT_ALIGN_CENTER)
	draw_SimpleText(translate.Get("press_shift_to_cancel"), "ZSHUDFontSmaller", x, y + draw_GetFontHeight("ZSHUDFontSmaller") - 16, colSigilTeleport, TEXT_ALIGN_CENTER)
	draw_SimpleText(translate.Get("point_at_a_sigil_to_choose_destination"), "ZSHUDFontSmaller", x, y + draw_GetFontHeight("ZSHUDFontSmaller") * 2 - 16, colSigilTeleport, TEXT_ALIGN_CENTER)
end

function GM:HumanHUD(screenscale)
	local curtime = CurTime()
	local w, h = ScrW(), ScrH()

	local packup = MySelf.PackUp
	local sigiltp = MySelf.SigilTeleport
	if packup and packup:IsValid() then
		self:DrawPackUpBar(w * 0.5, h * 0.55, 1 - packup:GetTimeRemaining() / packup:GetMaxTime(), packup:GetNotOwner(), screenscale)
	elseif sigiltp and sigiltp:IsValid() then
		self:DrawSigilTeleportBar(w * 0.5, h * 0.55, 1 - sigiltp:GetTimeRemaining() / sigiltp:GetMaxTime(), sigiltp:GetTargetSigil(), screenscale)
	end

	if not self.RoundEnded then
		if self:GetWave() == 0 and not self:GetWaveActive() then
			local txth = draw_GetFontHeight("ZSHUDFontSmall")
			local desiredzombies = self:GetDesiredStartingZombies()

			draw_SimpleTextBlurry(translate.Get("waiting_for_players").." "..util.ToMinutesSecondsCD(math.max(0, self:GetWaveStart() - curtime)), "ZSHUDFontSmall", w * 0.5, h * 0.25, COLOR_GRAY, TEXT_ALIGN_CENTER)

			if desiredzombies > 0 then
				draw_SimpleTextBlurry(translate.Get(self:HasSigils() and "humans_furthest_from_sigils_are_zombies" or "humans_closest_to_spawns_are_zombies"), "ZSHUDFontSmall", w * 0.5, h * 0.25 + txth, COLOR_GRAY, TEXT_ALIGN_CENTER)
				draw_SimpleTextBlurry(translate.Format("number_of_initial_zombies_this_game", self.WaveOneZombies * 100, desiredzombies), "ZSHUDFontSmall", w * 0.5, h * 0.7, COLOR_GRAY, TEXT_ALIGN_CENTER)

				for i, pl in ipairs(self.ZombieVolunteers) do
					if pl:IsValid() then
						draw_SimpleTextBlurry(translate.Get("zombie_volunteers"), "ZSHUDFontSmall", w * 0.5, h * 0.7 + txth, COLOR_GRAY, TEXT_ALIGN_CENTER)
						break
					end
				end

				local y = h * 0.7 + txth * 1.9
				txth = draw_GetFontHeight("ZSHUDFontTiny")
				for i, pl in ipairs(self.ZombieVolunteers) do
					if pl:IsValid() then
						draw_SimpleTextBlurry(pl:Name(), "ZSHUDFontTiny", w * 0.5, y, pl == MySelf and COLOR_SOFTRED or COLOR_GRAY, TEXT_ALIGN_CENTER)
						y = y + txth * 0.8
					end
				end
			end
		end

		local drown = MySelf.status_drown
		if drown and drown:IsValid() then
			surface_SetDrawColor(0, 0, 0, 60)
			surface_DrawRect(w * 0.4, h * 0.35, w * 0.2, 12)
			surface_SetDrawColor(30, 30, 230, 180)
			surface_DrawOutlinedRect(w * 0.4, h * 0.35, w * 0.2, 12)
			surface_DrawRect(w * 0.4, h * 0.35, w * 0.2 * (1 - drown:GetDrown()), 12)
			draw_SimpleTextBlurry(translate.Get("breath").." ", "ZSHUDFontSmall", w * 0.4, h * 0.35 + 6, COLOR_LBLUE, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end
	end

	local lockon = self.HumanMenuLockOn
	if lockon and self:ValidMenuLockOnTarget(MySelf, lockon) then
		local txth = draw_GetFontHeight("ZSHUDFontSmall")
		draw_SimpleTextBlurry(translate.Format("giving_items_to", lockon:Name()), "ZSHUDFontSmall", w * 0.5, h * 0.55 + txth, COLOR_GRAY, TEXT_ALIGN_CENTER)
	end

	if gamemode.Call("PlayerCanPurchase", MySelf) then
		draw_SimpleTextBlurry(translate.Get("press_f2_for_the_points_shop"), "ZSHUDFontSmall", w * 0.5, screenscale * 135, COLOR_GRAY, TEXT_ALIGN_CENTER)
	end
end

function GM:_HUDPaint()
	if self.FilmMode then return end

	local screenscale = BetterScreenScale()
	local myteam = P_Team(MySelf)

	self:HUDDrawTargetID(myteam, screenscale)

	if self:GetWave() > 0 then
		self:DrawFearMeter(self:CachedFearPower(), screenscale)
	end

	if myteam == TEAM_UNDEAD then
		self:ZombieHUD()
	elseif myteam == TEAM_HUMAN then
		self:HumanHUD(screenscale)
	end

	if GetGlobalBool("classicmode") then
		draw_SimpleTextBlurry(translate.Get("classic_mode"), "ZSHUDFontSmaller", 4, ScrH() - 4, COLOR_GRAY, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM_REAL)
	end
end

function GM:ZombieObserverHUD(obsmode)
	local w, h = ScrW(), ScrH()
	local texh = draw_GetFontHeight("ZSHUDFontSmall")

	if obsmode == OBS_MODE_CHASE then
		local target = MySelf:GetObserverTarget()
		if target and target:IsValid() then
			if target:IsPlayer() and P_Team(target) == TEAM_UNDEAD then
				draw_SimpleTextBlur(translate.Format("observing_x", target:Name(), math.max(0, target:Health())), "ZSHUDFontSmall", w * 0.5, h * 0.75 - texh - 32, COLOR_DARKRED, TEXT_ALIGN_CENTER)
			end

			if target.IsCreeperNest or target.MinionSpawn then
				local txt = target.IsCreeperNest and "Nest" or "Gore Child"

				draw_SimpleTextBlur(translate.Format("observing_x_simple", txt), "ZSHUDFontSmall", w * 0.5, h * 0.75 - texh - 32, COLOR_DARKRED, TEXT_ALIGN_CENTER)
			end

			dyn = self:GetDynamicSpawning() and self:DynamicSpawnIsValid(target)
		end
	end

	local space = texh + 2
	local x, y = w / 2, h * 0.68

	if self:GetWaveActive() then
		draw_SimpleTextBlurry(translate.Get("press_lmb_to_spawn"), "ZSHUDFontSmall", x, y, COLOR_GRAY, TEXT_ALIGN_CENTER)
		draw_SimpleTextBlurry(translate.Get("press_rmb_to_spawn_close"), "ZSHUDFontSmall", x, y + space, COLOR_GRAY, TEXT_ALIGN_CENTER)
		draw_SimpleTextBlurry(translate.Get("press_reload_to_spawn_far"), "ZSHUDFontSmall", x, y + space * 2, COLOR_GRAY, TEXT_ALIGN_CENTER)
		draw_SimpleTextBlurry(translate.Get("press_alt_nest_menu"), "ZSHUDFontSmaller", x, y + space * 4, COLOR_GRAY, TEXT_ALIGN_CENTER)
	end

	draw_SimpleTextBlurry(translate.Get("press_jump_to_free_roam"), "ZSHUDFontSmall", x, y + space * 3, COLOR_GRAY, TEXT_ALIGN_CENTER)
end

local colLifeStats = Color(255, 50, 50, 255)
function GM:ZombieHUD()
	if self.LifeStatsEndTime and CurTime() < self.LifeStatsEndTime and (self.LifeStatsBarricadeDamage > 0 or self.LifeStatsHumanDamage > 0 or self.LifeStatsBrainsEaten > 0) then
		colLifeStats.a = math.Clamp((self.LifeStatsEndTime - CurTime()) / (self.LifeStatsLifeTime * 0.33), 0, 1) * 255

		local th = draw_GetFontHeight("ZSHUDFontSmall")
		local x = ScrW() * 0.75
		local y = ScrH() * 0.75

		draw_SimpleTextBlur(translate.Get("that_life"), "ZSHUDFontSmall", x, y, colLifeStats, TEXT_ALIGN_LEFT)
		y = y + th

		if self.LifeStatsBarricadeDamage > 0 then
			draw_SimpleTextBlur(translate.Format("x_damage_to_barricades", self.LifeStatsBarricadeDamage), "ZSHUDFontSmall", x, y, colLifeStats, TEXT_ALIGN_LEFT)
			y = y + th
		end
		if self.LifeStatsHumanDamage > 0 then
			draw_SimpleTextBlur(translate.Format("x_damage_to_humans", self.LifeStatsHumanDamage), "ZSHUDFontSmall", x, y, colLifeStats, TEXT_ALIGN_LEFT)
			y = y + th
		end
		if self.LifeStatsBrainsEaten > 0 then
			draw_SimpleTextBlur(translate.Format("x_brains_eaten", self.LifeStatsBrainsEaten), "ZSHUDFontSmall", x, y, colLifeStats, TEXT_ALIGN_LEFT)
			y = y + th
		end
	end

	local obsmode = MySelf:GetObserverMode()
	if obsmode ~= OBS_MODE_NONE then
		self:ZombieObserverHUD(obsmode)
	elseif not MySelf:Alive() then
		local x = ScrW() * 0.5
		local y = ScrH() * 0.3

		if not self:GetWaveActive() then
			draw_SimpleTextBlur(translate.Get("waiting_for_next_wave"), "ZSHUDFont", x, y, COLOR_DARKRED, TEXT_ALIGN_CENTER)
		end
	end

	if not self:GetWaveActive() and self:GetWave() ~= 0 then
		local pl = GAMEMODE.NextBossZombie
		if pl and pl:IsValid() then
			local x, y = ScrW() / 2, ScrH() * 0.3 + draw_GetFontHeight("ZSHUDFont")
			if pl == MySelf then
				draw_SimpleTextBlur(translate.Format("you_will_be_x_soon", GAMEMODE.NextBossZombieClass), "ZSHUDFont", x, y, Color(255, 50, 50), TEXT_ALIGN_CENTER)
			else
				draw_SimpleTextBlur(translate.Format("x_will_be_y_soon", pl:Name(), GAMEMODE.NextBossZombieClass), "ZSHUDFont", x, y, COLOR_GRAY, TEXT_ALIGN_CENTER)
			end
		end
	end
end

function GM:RequestedDefaultCart()
	local defaultcart = GetConVar("zs_defaultcart"):GetString()
	if #defaultcart > 0 then
		defaultcart = string.lower(defaultcart)

		for i, carttab in ipairs(self.SavedCarts) do
			if carttab[1] and string.lower(carttab[1]) == defaultcart then
				gamemode.Call("SuppressArsenalUpgrades", 1)
				RunConsoleCommand("worthcheckout", unpack(carttab[2]))

				return
			end
		end

		RunConsoleCommand("worthrandom")
	end
end

function GM:_PostDrawTranslucentRenderables()
	if not self.DrawingInSky then
		self:DrawPointWorldHints()
		self:DrawWorldHints()
		self:DrawSigilIndicators()
		self:DrawCrateIndicators()
		self:DrawResupplyIndicators()
		self:DrawRemantlerIndicators()
		self:DrawHumanIndicators()
		self:DrawNestIndicators()
	end
end

function GM:DrawCrateIndicators()
	if P_Team(MySelf) ~= TEAM_HUMAN or not MySelf:IsSkillActive(SKILL_INSIGHT) then return end

	local pos, distance, ang, deployable, alpha
	local eyepos = EyePos()

	surface_SetMaterial(matArsenal)

	for i, arsenal in pairs(GAMEMODE.CachedArsenalEntities) do
		if not arsenal:IsValid() then continue end
		deployable = arsenal.GetObjectOwner

		pos = arsenal:GetPos()
		pos.z = pos.z + (arsenal:IsPlayer() and 32 or (deployable and 12 or -8))
		distance = eyepos:DistToSqr(pos)

		if (distance >= 6400 and distance <= 1048576) and (not deployable or not WorldVisible(eyepos, pos)) then -- Limited to Scavenger's Eyes distance.
			ang = (eyepos - pos):Angle()
			ang:RotateAroundAxis(ang:Right(), 270)
			ang:RotateAroundAxis(ang:Up(), 90)
			alpha = math.min(220, math.sqrt(distance / 4))

			cam_IgnoreZ(true)
			cam_Start3D2D(pos, ang, math.max(250, math.sqrt(distance)) / 5000)

			surface_SetDrawColor(255, 255, 255, alpha)
			surface_DrawTexturedRect(-123, -113, 248, 228)

			draw_SimpleTextBlurry("Arsenal Crate", "ZS3D2DFont2Big", 0, 128, COLOR_GRAY, TEXT_ALIGN_CENTER)

			cam_End3D2D()
			cam_IgnoreZ(false)
		end
	end
end

function GM:DrawResupplyIndicators()
	if P_Team(MySelf) ~= TEAM_HUMAN or not MySelf:IsSkillActive(SKILL_ACUITY) then return end

	local pos, distance, ang, deployable, alpha
	local eyepos = EyePos()

	surface_SetMaterial(matResupply)

	for i, resupply in pairs(GAMEMODE.CachedResupplyEntities) do
		if not resupply:IsValid() then continue end
		deployable = resupply.GetObjectOwner

		pos = resupply:GetPos()
		pos.z = pos.z + (resupply:IsPlayer() and 32 or (deployable and 12 or -8))
		distance = eyepos:DistToSqr(pos)

		if (distance >= 6400 and distance <= 1048576) and (not deployable or not WorldVisible(eyepos, pos)) then -- Limited to Scavenger's Eyes distance.
			ang = (eyepos - pos):Angle()
			ang:RotateAroundAxis(ang:Right(), 270)
			ang:RotateAroundAxis(ang:Up(), 90)
			alpha = math.min(220, math.sqrt(distance / 4))

			cam_IgnoreZ(true)
			cam_Start3D2D(pos, ang, math.max(250, math.sqrt(distance)) / 5000)

			surface_SetDrawColor(255, 255, 255, alpha)
			surface_DrawTexturedRect(-128, -128, 256, 256)

			local timeremain = math.ceil(math.max(0, (MySelf.NextUse or 0) - CurTime()))
			local txt = not MySelf.NextUse and translate.Get("ready") or timeremain > 0 and timeremain or translate.Get("ready")
			draw_SimpleTextBlurry(txt, "ZS3D2DFont2Big", 0, 128, COLOR_GRAY, TEXT_ALIGN_CENTER)

			cam_End3D2D()
			cam_IgnoreZ(false)
		end
	end
end

function GM:DrawRemantlerIndicators()
	if P_Team(MySelf) ~= TEAM_HUMAN or not MySelf:IsSkillActive(SKILL_VISION) then return end

	local pos, distance, ang, deployable, alpha
	local eyepos = EyePos()

	surface_SetMaterial(matRemantler)

	for i, remantler in pairs(GAMEMODE.CachedRemantlerEntities) do
		if not remantler:IsValid() then continue end
		deployable = remantler.GetObjectOwner

		pos = remantler:GetPos()
		pos.z = pos.z + (remantler:IsPlayer() and 32 or (deployable and 12 or -8))
		distance = eyepos:DistToSqr(pos)

		if (distance >= 6400 and distance <= 1048576) and (not deployable or not WorldVisible(eyepos, pos)) then -- Limited to Scavenger's Eyes distance.
			ang = (eyepos - pos):Angle()
			ang:RotateAroundAxis(ang:Right(), 270)
			ang:RotateAroundAxis(ang:Up(), 90)
			alpha = math.min(220, math.sqrt(distance / 4))

			cam_IgnoreZ(true)
			cam_Start3D2D(pos, ang, math.max(250, math.sqrt(distance)) / 5000)

			surface_SetDrawColor(255, 255, 255, alpha)
			surface_DrawTexturedRect(-128, -128, 256, 256)

			draw_SimpleTextBlurry("Weapon Remantler", "ZS3D2DFont2Big", 0, 128, COLOR_GRAY, TEXT_ALIGN_CENTER)

			cam_End3D2D()
			cam_IgnoreZ(false)
		end
	end
end

function GM:DrawNestIndicators()
	if P_Team(MySelf) ~= TEAM_ZOMBIE then return end

	local pos, distance, ang, alpha
	local eyepos = EyePos()

	surface_SetMaterial(matNest)

	for i, nest in pairs(GAMEMODE.CachedNests) do
		if not nest:IsValid() then continue end

		pos = nest:GetPos()
		pos.z = pos.z + 32
		distance = eyepos:DistToSqr(pos)

		ang = (eyepos - pos):Angle()
		ang:RotateAroundAxis(ang:Right(), 270)
		ang:RotateAroundAxis(ang:Up(), 90)
		alpha = math.min(220, math.sqrt(distance / 4))

		cam_IgnoreZ(true)
		cam_Start3D2D(pos, ang, math.max(250, math.sqrt(distance)) / 5000)

		surface_SetDrawColor(255, 255, 255, alpha)
		surface_DrawTexturedRect(-128, -128, 256, 256)

		draw_SimpleTextBlurry("Nest", "ZS3D2DFont2Big", 0, 128, COLOR_GRAY, TEXT_ALIGN_CENTER)

		if distance < 80000 then
			local nown = nest:GetNestOwner()
			local ownname = nown:IsValidZombie() and nown:ClippedName() or ""

			draw_SimpleTextBlurry(ownname, "ZS3D2DFont2", 0, 256, COLOR_GRAY, TEXT_ALIGN_CENTER)
		end

		cam_End3D2D()
		cam_IgnoreZ(false)
	end
end

function GM:DrawSigilIndicators()
	if not self:GetUseSigils() then return end

	local health, pos, distance, maxhealth, corrupted, damageflash, missinghealthfrac, ang, alpha
	local eyepos = EyePos()

	surface_SetMaterial(matSigil)

	for i, sigil in pairs(GAMEMODE.CachedSigils) do
		if not sigil:IsValid() then continue end

		health = sigil:GetSigilHealth()
		if health > 0 then
			pos = sigil:GetPos()
			pos.z = pos.z + 48
			distance = eyepos:DistToSqr(pos)

			maxhealth = sigil:GetSigilMaxHealth()
			corrupted = sigil:GetSigilCorrupted()
			damageflash = math.min((CurTime() - sigil:GetSigilLastDamaged()) * 2, 1) * 255
			missinghealthfrac = 1 - health / maxhealth
			alpha = math.min(220, math.sqrt(distance / 4))

			ang = (eyepos - pos):Angle()
			ang:RotateAroundAxis(ang:Right(), 270)
			ang:RotateAroundAxis(ang:Up(), 90)

			cam_IgnoreZ(true)
			cam_Start3D2D(pos, ang, math.max(250, math.sqrt(distance)) / 5000)
			local oldfogmode = render_GetFogMode()
			render_FogMode(0)

			if corrupted then
				surface_SetDrawColor(255 - damageflash, damageflash, 0, alpha)
			else
				surface_SetDrawColor(damageflash, 255, damageflash, alpha)
			end
			surface_DrawTexturedRect(-64, -128, 128, 256)
			if missinghealthfrac > 0 then
				surface_SetDrawColor(40, 40, 40, 255)
				surface_DrawTexturedRectUV(-64, -128, 128, 256 * missinghealthfrac, 0, 0, 1, missinghealthfrac)
			end

			draw_SimpleTextBlurry(string.char(64 + i), "ZS3D2DFont2Big", 0, 128, COLOR_GRAY, TEXT_ALIGN_CENTER)

			render_FogMode(oldfogmode)
			cam_End3D2D()
			cam_IgnoreZ(false)
		end
	end
end

function GM:RestartRound()
	self.TheLastHuman = nil
	self.RoundEnded = nil
	LASTHUMAN = nil

	if pEndBoard and pEndBoard:IsValid() then
		pEndBoard:Remove()
		pEndBoard = nil
	end

	self:ClearItemStocks()

	self:InitPostEntity()

	self:RevertZombieClasses()
end

function GM:_HUDShouldDraw(name)
	if self.FilmMode and name ~= "CHudWeaponSelection" then return false end

	return name ~= "CHudHealth" and name ~= "CHudBattery"
	and name ~= "CHudAmmo" and name ~= "CHudSecondaryAmmo"
	and name ~= "CHudDamageIndicator"
end

local Current = 0
local NextCalculate = 0
function GM:_CachedFearPower()
	if CurTime() >= NextCalculate then
		NextCalculate = CurTime() + 0.15
		Current = self:GetFearMeterPower(EyePos(), TEAM_UNDEAD, MySelf)
	end

	return Current
end

function surface.CreateLegacyFont(font, size, weight, antialias, additive, name, shadow, outline, blursize)
	surface.CreateFont(name, {font = font, size = size, weight = weight, antialias = antialias, additive = additive, shadow = shadow, outline = outline, blursize = blursize})
end

local fontfamily = "Ghoulish Fright AOE"
local fontfamilysm = "Remington Noiseless"
local fontfamily3d = "hidden"
local fontsizeadd = 8
local fontweight = 0

function GM:Create3DFonts()
	local fontsizeadd3D = 0
	local fontweight3D = 0

	surface.CreateLegacyFont(fontfamily3d, 28 + fontsizeadd3D, fontweight3D, false, false,  "ZS3D2DFontSmaller", false, true)
	surface.CreateLegacyFont(fontfamily3d, 48 + fontsizeadd3D, fontweight3D, false, false,  "ZS3D2DFontSmall", false, true)
	surface.CreateLegacyFont(fontfamily3d, 72 + fontsizeadd3D, fontweight3D, false, false, "ZS3D2DFont", false, true)
	surface.CreateLegacyFont(fontfamily3d, 128 + fontsizeadd3D, fontweight3D, false, false, "ZS3D2DFontBig", false, true)
	surface.CreateLegacyFont(fontfamily3d, 28 + fontsizeadd3D, fontweight3D, false, false,  "ZS3D2DFontSmallerBlur", false, false, 16)
	surface.CreateLegacyFont(fontfamily3d, 48 + fontsizeadd3D, fontweight3D, false, false,  "ZS3D2DFontSmallBlur", false, false, 16)
	surface.CreateLegacyFont(fontfamily3d, 72 + fontsizeadd3D, fontweight3D, false, false, "ZS3D2DFontBlur", false, false, 16)
	surface.CreateLegacyFont(fontfamily3d, 128 + fontsizeadd3D, fontweight3D, false, false, "ZS3D2DFontBigBlur", false, false, 16)
	surface.CreateLegacyFont(fontfamily, 40 + fontsizeadd3D, fontweight3D, false, false,  "ZS3D2DFont2Smaller", false, true)
	surface.CreateLegacyFont(fontfamily, 48 + fontsizeadd3D, fontweight3D, false, false,  "ZS3D2DFont2Small", false, true)
	surface.CreateLegacyFont(fontfamily, 72 + fontsizeadd3D, fontweight3D, false, false, "ZS3D2DFont2", false, true)
	surface.CreateLegacyFont(fontfamily, 128 + fontsizeadd3D, fontweight3D, false, false, "ZS3D2DFont2Big", false, true)
	surface.CreateLegacyFont(fontfamily, 40 + fontsizeadd3D, fontweight3D, false, false,  "ZS3D2DFont2SmallerBlur", false, false, 16)
	surface.CreateLegacyFont(fontfamily, 48 + fontsizeadd3D, fontweight3D, false, false,  "ZS3D2DFont2SmallBlur", false, false, 16)
	surface.CreateLegacyFont(fontfamily, 72 + fontsizeadd3D, fontweight3D, false, false, "ZS3D2DFont2Blur", false, false, 16)
	surface.CreateLegacyFont(fontfamily, 128 + fontsizeadd3D, fontweight3D, false, false, "ZS3D2DFont2BigBlur", false, false, 16)

	surface.CreateLegacyFont(fontfamilysm, 14 + fontsizeadd3D, fontweight3D, false, false,  "ZS3D2DUnstyleTiny", false, true)
	surface.CreateLegacyFont(fontfamilysm, 24 + fontsizeadd3D, fontweight3D, false, false,  "ZS3D2DUnstyleSmallest", false, true)
	surface.CreateLegacyFont(fontfamilysm, 36 + fontsizeadd3D, fontweight3D, false, false,  "ZS3D2DUnstyleSmaller", false, true)
end

function GM:CreateNonScaleFonts()
	surface.CreateLegacyFont("tahoma", 96, 1000, true, false, "zshintfont", false, true)

	-- Default, DefaultBold, DefaultSmall, etc. were changed when gmod13 hit. These are renamed fonts that have the old values.
	surface.CreateFont("DefaultFontVerySmall", {font = "tahoma", size = 10, weight = 0, antialias = false})
	surface.CreateFont("DefaultFontSmall", {font = "tahoma", size = 11, weight = 0, antialias = false})
	surface.CreateFont("DefaultFontSmallDropShadow", {font = "tahoma", size = 11, weight = 0, shadow = true, antialias = false})
	surface.CreateFont("DefaultFont", {font = "tahoma", size = 13, weight = 500, antialias = false})
	surface.CreateFont("DefaultFontAA", {font = "tahoma", size = 13, weight = 500, antialias = true})
	surface.CreateFont("DefaultFontBold", {font = "tahoma", size = 13, weight = 1000, antialias = false})
	surface.CreateFont("DefaultFontLarge", {font = "tahoma", size = 16, weight = 0, antialias = false})
	surface.CreateFont("DefaultFontLargeAA", {font = "tahoma", size = 16, weight = 0, antialias = true})
	surface.CreateFont("DefaultFontLargest", {font = "tahoma", size = 22, weight = 0, antialias = false})
	surface.CreateFont("DefaultFontLargestAA", {font = "tahoma", size = 22, weight = 0, antialias = true})
end

function GM:CreateScalingFonts()
	local fontaa = true
	local fontshadow = false
	local fontoutline = true

	local screenscale = BetterScreenScale()

	surface.CreateLegacyFont("csd", screenscale * 42, 100, true, false, "zsdeathnoticecs", false, false)
	surface.CreateLegacyFont("HL2MP", screenscale * 42, 100, true, false, "zsdeathnotice", false, false)

	surface.CreateLegacyFont("csd", screenscale * 96, 100, true, false, "zsdeathnoticecsws", false, false)
	surface.CreateLegacyFont("HL2MP", screenscale * 96, 100, true, false, "zsdeathnoticews", false, false)

	surface.CreateLegacyFont("csd", screenscale * 72, 100, true, false, "zsdeathnoticecspa", false, false)
	surface.CreateLegacyFont("HL2MP", screenscale * 72, 100, true, false, "zsdeathnoticepa", false, false)

	surface.CreateLegacyFont(fontfamily, screenscale * (16 + fontsizeadd), fontweight, fontaa, false, "ZSHUDFontTiny", fontshadow, fontoutline)
	surface.CreateLegacyFont(fontfamily, screenscale * (20 + fontsizeadd), fontweight, fontaa, false, "ZSHUDFontSmallest", fontshadow, fontoutline)
	surface.CreateLegacyFont(fontfamily, screenscale * (22 + fontsizeadd), fontweight, fontaa, false, "ZSHUDFontSmaller", fontshadow, fontoutline)
	surface.CreateLegacyFont(fontfamily, screenscale * (28 + fontsizeadd), fontweight, fontaa, false, "ZSHUDFontSmall", fontshadow, fontoutline)
	surface.CreateLegacyFont(fontfamily, screenscale * (42 + fontsizeadd), fontweight, fontaa, false, "ZSHUDFont", fontshadow, fontoutline)
	surface.CreateLegacyFont(fontfamily, screenscale * (72 + fontsizeadd), fontweight, fontaa, false, "ZSHUDFontBig", fontshadow, fontoutline)
	surface.CreateLegacyFont(fontfamily, screenscale * (16 + fontsizeadd), fontweight, fontaa, false, "ZSHUDFontTinyBlur", false, false, 8)
	surface.CreateLegacyFont(fontfamily, screenscale * (22 + fontsizeadd), fontweight, fontaa, false, "ZSHUDFontSmallerBlur", false, false, 8)
	surface.CreateLegacyFont(fontfamily, screenscale * (28 + fontsizeadd), fontweight, fontaa, false, "ZSHUDFontSmallBlur", false, false, 8)
	surface.CreateLegacyFont(fontfamily, screenscale * (42 + fontsizeadd), fontweight, fontaa, false, "ZSHUDFontBlur", false, false, 8)
	surface.CreateLegacyFont(fontfamily, screenscale * (72 + fontsizeadd), fontweight, fontaa, false, "ZSHUDFontBigBlur", false, false, 8)

	surface.CreateLegacyFont(fontfamily, screenscale * (20 + fontsizeadd/2), 0, fontaa, false, "ZSAmmoName", false, false)

	local liscreenscale = math.max(0.95, BetterScreenScale())

	surface.CreateLegacyFont(fontfamily, liscreenscale * (32 + fontsizeadd), fontweight, true, false, "ZSScoreBoardTitle", false, true)
	surface.CreateLegacyFont(fontfamily, liscreenscale * (22 + fontsizeadd), fontweight, true, false, "ZSScoreBoardSubTitle", false, true)
	surface.CreateLegacyFont(fontfamily, liscreenscale * (16 + fontsizeadd), fontweight, true, false, "ZSScoreBoardPlayer", false, true)
	surface.CreateLegacyFont(fontfamily, liscreenscale * (24 + fontsizeadd), fontweight, true, false, "ZSScoreBoardHeading", false, false)
	surface.CreateLegacyFont("arial", 18 * liscreenscale, 0, true, false, "ZSScoreBoardPlayerSmall", false, true)
	surface.CreateLegacyFont("arial", 15 * liscreenscale, 0, true, false, "ZSScoreBoardPlayerSmaller", false, true)
	surface.CreateLegacyFont("tahoma", 11 * liscreenscale, 0, true, false, "ZSScoreBoardPing")

	surface.CreateLegacyFont(fontfamily, screenscale * (16 + fontsizeadd), fontweight, fontaa, false, "ZSHUDFontTinyNS", false, false)
	surface.CreateLegacyFont(fontfamily, screenscale * (20 + fontsizeadd), fontweight, fontaa, false, "ZSHUDFontSmallestNS", false, false)
	surface.CreateLegacyFont(fontfamily, screenscale * (22 + fontsizeadd), fontweight, fontaa, false, "ZSHUDFontSmallerNS", false, false)
	surface.CreateLegacyFont(fontfamily, screenscale * (28 + fontsizeadd), fontweight, fontaa, false, "ZSHUDFontSmallNS", false, false)
	surface.CreateLegacyFont(fontfamily, screenscale * (42 + fontsizeadd), fontweight, fontaa, false, "ZSHUDFontNS", false, false)
	surface.CreateLegacyFont(fontfamily, screenscale * (72 + fontsizeadd), fontweight, fontaa, false, "ZSHUDFontBigNS", false, false)

	surface.CreateLegacyFont(fontfamilysm, screenscale * 13, fontweight, fontaa, false, "ZSBodyTextFontSmall", fontshadow)

	surface.CreateLegacyFont(fontfamilysm, screenscale * 15, fontweight, fontaa, false, "ZSBodyTextFont", fontshadow, fontoutline)
	surface.CreateLegacyFont(fontfamilysm, screenscale * 20, fontweight, fontaa, false, "ZSBodyTextFontBig", fontshadow, fontoutline)

	surface.CreateLegacyFont(fontfamily, screenscale * (20 + fontsizeadd), 0, true, false, "ZSDamageResistance", false, true)
	surface.CreateLegacyFont(fontfamily, screenscale * (20 + fontsizeadd), 0, true, false, "ZSDamageResistanceBlur", false, true)

	surface.CreateFont("ZSXPBar", {font = "tahoma", size = screenscale * 14, weight = 500, antialias = false, shadow = true})
end

function GM:CreateFonts()
	self:Create3DFonts()
	self:CreateNonScaleFonts()
	self:CreateScalingFonts()
end

function GM:EvaluateFilmMode()
	local visible = not self.FilmMode

	if self.GameStatePanel and self.GameStatePanel:IsValid() then
		self.GameStatePanel:SetVisible(visible)
	end

	if self.TopNotificationHUD and self.TopNotificationHUD:IsValid() then
		self.TopNotificationHUD:SetVisible(visible)
	end

	if self.CenterNotificationHUD and self.CenterNotificationHUD:IsValid() then
		self.CenterNotificationHUD:SetVisible(visible)
	end

	if self.XPHUD and self.XPHUD:IsValid() then
		self.XPHUD:SetVisible(visible and self.DisplayXPHUD)
	end

	if self.HealthHUD and self.HealthHUD:IsValid() then
		self.HealthHUD:SetVisible(visible)
	end

	if self.StatusHUD and self.StatusHUD:IsValid() then
		self.StatusHUD:SetVisible(visible)
	end
end

function GM:CreateVGUI()
	local screenscale = BetterScreenScale()
	self.GameStatePanel = vgui.Create("ZSGameState")
	self.GameStatePanel:SetTextFont("ZSHUDFontSmaller")
	self.GameStatePanel:SetAlpha(220)
	self.GameStatePanel:SetSize(screenscale * 420, screenscale * 80)
	self.GameStatePanel:ParentToHUD()

	self.TopNotificationHUD = vgui.Create("DEXNotificationsList")
	self.TopNotificationHUD:SetAlign(RIGHT)
	self.TopNotificationHUD.PerformLayout = function(pan)
		pan:SetSize(ScrW() * 0.4, ScrH() * 0.6)
		pan:AlignTop(16 * BetterScreenScale())
		pan:AlignRight()
	end
	self.TopNotificationHUD:InvalidateLayout()
	self.TopNotificationHUD:ParentToHUD()

	self.CenterNotificationHUD = vgui.Create("DEXNotificationsList")
	self.CenterNotificationHUD:SetAlign(CENTER)
	self.CenterNotificationHUD:SetMessageHeight(36)
	self.CenterNotificationHUD.PerformLayout = function(pan)
		pan:SetSize(ScrW() / 2, ScrH() * 0.35)
		pan:CenterHorizontal()
		pan:AlignBottom(16 * BetterScreenScale())
	end
	self.CenterNotificationHUD:InvalidateLayout()
	self.CenterNotificationHUD:ParentToHUD()
end

function GM:CreateLateVGUI()
	if not self.HealthHUD then
		self.HealthHUD = vgui.Create("ZSHealthArea")
	end

	if not self.StatusHUD then
		self.StatusHUD = vgui.Create("ZSStatusArea")
	end

	if not self.XPHUD then
		self.XPHUD = vgui.Create("ZSExperienceHUD")
		self.XPHUD:ParentToHUD()
		self.XPHUD:InvalidateLayout()
	end
end

function GM:Initialize()
	self:FixSkillConnections()
	self:CreateFonts()
	self:PrecacheResources()
	self:CreateVGUI()
	self:InitializeBeats()
	self:AddCustomAmmo()
	self:RegisterFood()
	self:CreateWeaponQualities()
	self:CreateSpriteMaterials()

	-- Not sure if this still crashes, but whatever.
	RunConsoleCommand("r_drawmodeldecals", "0")
	-- Flashlight dynamic lights of other players.
	RunConsoleCommand("r_dynamic", "0")

	self:RefreshMapIsObjective()
end

-- These can be accessed without pointing to the IMaterial by using ! before the material string.
function GM:CreateSpriteMaterials()
	local params = {["$translucent"] = "1", ["$vertexcolor"] = "1", ["$vertexalpha"] = "1"}
	for i=1, 8 do
		params["$basetexture"] = "Decals/blood"..i
		CreateMaterial("sprite_bloodspray"..i, "UnlitGeneric", params)
	end
end

function GM:ShutDown()
	RunConsoleCommand("r_drawmodeldecals", "1")
	RunConsoleCommand("r_dynamic", "1")
end

local function FirstOfGoodType(a)
	local ext

	for _, v in pairs(a) do
		ext = string.sub(v, -4)
		if ext == ".ogg" or ext == ".wav" or ext == ".mp3" then
			return v
		end
	end
end

function GM:InitializeBeats()
	local _, dirs = file.Find("sound/zombiesurvival/beats/*", "GAME")
	for _, dirname in pairs(dirs) do
		if dirname == "none" or dirname == "default" then continue end

		self.Beats[dirname] = {}
		local highestexist
		for i=1, 10 do
			local a, __ = file.Find("sound/zombiesurvival/beats/"..dirname.."/"..i..".*", "GAME")
			local a1 = FirstOfGoodType(a)
			if a1 then
				local filename = "zombiesurvival/beats/"..dirname.."/"..a1
				if file.Exists("sound/"..filename, "GAME") then
					self.Beats[dirname][i] = Sound(filename)
					highestexist = filename

					continue
				end
			end

			if highestexist then
				self.Beats[dirname][i] = highestexist
			end
		end
	end
end

function GM:PlayerDeath(pl, attacker)
end

function GM:ScalePlayerDamage(pl, hitgroup, dmginfo)
end

function GM:LastHuman(pl)
	if not IsValid(pl) then pl = nil end

	self.TheLastHuman = pl

	if not LASTHUMAN then
		LASTHUMAN = true
		timer.Simple(0.5, function() GAMEMODE:LastHumanMessage() end)
	end
end

function GM:LastHumanMessage()
	if self.RoundEnded or not MySelf:IsValid() then return end

	local icon = self.PantsMode and "weapon_zs_legs" or "default"
	if P_Team(MySelf) == TEAM_UNDEAD or not MySelf:Alive() then
		self:CenterNotify({killicon = icon}, {font = "ZSHUDFont"}, " ", COLOR_RED, translate.Get(self.PantsMode and "kick_the_last_human" or "kill_the_last_human"), {killicon = icon})
	else
		self:CenterNotify({font = "ZSHUDFont"}, " ", COLOR_RED, translate.Get("you_are_the_last_human"))
		self:CenterNotify({killicon = icon}, " ", COLOR_RED, translate.Format(self.PantsMode and "x_pants_out_to_get_you" or "x_zombies_out_to_get_you", team.NumPlayers(TEAM_UNDEAD)), {killicon = icon})
	end
end

function GM:PlayerShouldTakeDamage(pl, attacker)
	return pl == attacker or not attacker:IsPlayer() or P_Team(pl) ~= P_Team(attacker) or pl.AllowTeamDamage or attacker.AllowTeamDamage
end

function GM:SetWave(wave)
	SetGlobalInt("wave", wave)
end

local matRing = Material("effects/select_ring")
function GM:DrawCircle(x, y, radius, color)
	surface.SetMaterial(matRing)
	surface.SetDrawColor(color)
	surface.DrawTexturedRect(x - radius, y - radius, radius * 2, radius * 2)
end

local matFilmGrain = Material("zombiesurvival/filmgrain/filmgrain")
function GM:_HUDPaintBackground()
	if self.FilmGrainEnabled and P_Team(MySelf) ~= TEAM_UNDEAD then
		surface_SetMaterial(matFilmGrain)
		surface_SetDrawColor(0, 0, 0, (0.25 + 0.75 * self:CachedFearPower()) * self.FilmGrainOpacity)
		surface_DrawTexturedRectUV(0, 0, ScrW(), ScrH(), 2, 2, 0, 0)
	end

	local wep = MySelf:GetActiveWeapon()
	if wep:IsValid() and wep.DrawHUDBackground then
		wep:DrawHUDBackground()
	end
end

local function GiveWeapon()
	if GAMEMODE.HumanMenuLockOn then
		RunConsoleCommand("zsgiveweapon", GAMEMODE.HumanMenuLockOn:EntIndex(), GAMEMODE.InventoryMenu.SelInv)
	end
end
local function GiveWeaponClip()
	if GAMEMODE.HumanMenuLockOn then
		RunConsoleCommand("zsgiveweaponclip", GAMEMODE.HumanMenuLockOn:EntIndex(), GAMEMODE.InventoryMenu.SelInv)
	end
end
local function DropWeapon()
	RunConsoleCommand("zsdropweapon", GAMEMODE.InventoryMenu.SelInv)
end
local function EmptyClip()
	RunConsoleCommand("zsemptyclip")
end
local function DismantleWeapon()
	RunConsoleCommand("zs_dismantle", GAMEMODE.InventoryMenu.SelInv)
end

local function AltSelItemUpd()
	local activeweapon = MySelf:GetActiveWeapon()
	if not activeweapon or not activeweapon:IsValid() then return end

	local actwclass = activeweapon:GetClass()
	GAMEMODE.HumanMenuPanel.SelectedItemLabel:SetText(weapons.Get(actwclass).PrintName)
end

function GM:DoAltSelectedItemUpdate()
	if self.InventoryMenu.SelInv then
		self.HumanMenuPanel.SelectedItemLabel:SetText(self.ZSInventoryItemData[self.InventoryMenu.SelInv].PrintName)
	else
		timer.Simple(0.25, AltSelItemUpd)
	end
end

function GM:HumanMenu()
	if self.ZombieEscape then return end

	local ent = MySelf:MeleeTrace(48, 2, nil, nil, true).Entity
	if self:ValidMenuLockOnTarget(MySelf, ent) then
		self.HumanMenuLockOn = ent
	else
		self.HumanMenuLockOn = nil
	end

	self:OpenInventory()
	if self.HumanMenuPanel and self.HumanMenuPanel:IsValid() then
		self.HumanMenuPanel:SetVisible(true)
		self.HumanMenuPanel:OpenMenu()

		self:DoAltSelectedItemUpdate()
		return
	end

	local panel = vgui.Create("DSideMenu")
	self.HumanMenuPanel = panel

	local screenscale = BetterScreenScale()
	for k, v in pairs(self.AmmoNames) do
		local b = vgui.Create("DAmmoCounter", panel)
		b:SetAmmoType(k)
		b:SetTall(math.max(32, screenscale * 36))
		panel:AddItem(b)
	end

	local hei = draw_GetFontHeight("ZSHUDFontSmall")

	local selecteditemtitle = EasyLabel(panel, "Selected Item", "ZSHUDFontSmall", color_white)
	selecteditemtitle:SetContentAlignment(5)
	panel:AddItem(selecteditemtitle)

	local selecteditemlabel = EasyLabel(panel, "Fists", "ZSHUDFontSmaller", color_white)
	selecteditemlabel:SetContentAlignment(5)
	panel:AddItem(selecteditemlabel)
	panel.SelectedItemLabel = selecteditemlabel

	local gwbtn = vgui.Create("DButton")
	gwbtn:SetFont("ZSHUDFontSmaller")
	gwbtn:SetText("Give Item")
	gwbtn:SetSize(panel:GetWide() - 8 * screenscale, hei - 4 * screenscale)
	gwbtn:CenterHorizontal()
	gwbtn.DoClick = GiveWeapon
	panel:AddItem(gwbtn)

	gwbtn = vgui.Create("DButton")
	gwbtn:SetFont("ZSHUDFontSmaller")
	gwbtn:SetText("Give Item and 5 clips")
	gwbtn:SetSize(panel:GetWide() - 8 * screenscale, hei - 4 * screenscale)
	gwbtn:CenterHorizontal()
	gwbtn.DoClick = GiveWeaponClip
	panel:AddItem(gwbtn)

	gwbtn = vgui.Create("DButton")
	gwbtn:SetFont("ZSHUDFontSmaller")
	gwbtn:SetText("Drop Item")
	gwbtn:SetSize(panel:GetWide() - 8 * screenscale, hei - 4 * screenscale)
	gwbtn:CenterHorizontal()
	gwbtn.DoClick = DropWeapon
	panel:AddItem(gwbtn)

	gwbtn = vgui.Create("DButton")
	gwbtn:SetFont("ZSHUDFontSmaller")
	gwbtn:SetText("Empty Weapon Clip")
	gwbtn:SetSize(panel:GetWide() - 8 * screenscale, hei - 4 * screenscale)
	gwbtn:CenterHorizontal()
	gwbtn.DoClick = EmptyClip
	panel:AddItem(gwbtn)

	gwbtn = vgui.Create("DButton")
	gwbtn:SetFont("ZSHUDFontSmaller")
	gwbtn:SetText("Dismantle Item")
	gwbtn:SetSize(panel:GetWide() - 8 * screenscale, hei - 4 * screenscale)
	gwbtn:CenterHorizontal()
	gwbtn.DoClick = DismantleWeapon
	panel:AddItem(gwbtn)

	panel:AddItem(EasyLabel(panel, "Resupply Ammo Selection", "DefaultFont", color_white))
	local dropdown = vgui.Create("DComboBox", panel)
	dropdown:SetMouseInputEnabled(true)
	dropdown:AddChoice("Resupply Held Weapon")
	for k,v in pairs(self.AmmoResupply) do
		dropdown:AddChoice(self.AmmoNames[k])
	end
	dropdown.OnSelect = function(me, index, value, data)
		if value == "Resupply Held Weapon" then
			MySelf.ResupplyChoice = nil
			RunConsoleCommand("zs_resupplyammotype", "default")
			return
		end

		for k,v in pairs(self.AmmoNames) do
			if value == v then
				MySelf.ResupplyChoice = k
				RunConsoleCommand("zs_resupplyammotype", k)
				break
			end
		end
	end
	dropdown:SetText("Resupply Held Weapon")
	dropdown:SetTextColor(color_black)
	panel:AddItem(dropdown)

	self.HumanMenuSupplyChoice = dropdown

	panel:OpenMenu()
end

function GM:ZombieSpawnMenu()
	if self.ZombieEscape then return end

	if self.ZSpawnMenu and self.ZSpawnMenu:IsValid() then
		self.ZSpawnMenu:SetVisible(true)
		self.ZSpawnMenu:OpenMenu()
		self.ZSpawnMenu:RefreshContents()

		return
	end

	local panel = vgui.Create("DZombieSpawnMenu")
	self.ZSpawnMenu = panel

	panel:OpenMenu()
end

function GM:PlayerBindPress(pl, bind, wasin)
	if bind == "gmod_undo" or bind == "undo" then
		RunConsoleCommand("+zoom")
		timer.Create("ReleaseZoom", 1, 1, function() RunConsoleCommand("-zoom") end)
	elseif bind == "+menu_context" then
		if P_Team(pl) == TEAM_UNDEAD then
			self.ZombieThirdPerson = not self.ZombieThirdPerson
		elseif P_Team(pl) == TEAM_HUMAN then
			self:ToggleOTSCamera()
		end
	elseif bind == "impulse 100" then
		if P_Team(pl) == TEAM_UNDEAD and pl:Alive() then
			self:ToggleZombieVision()
		end
	end
end

function GM:_ShouldDrawLocalPlayer(pl)
	return FROM_CAMERA or P_Team(pl) == TEAM_UNDEAD and (self.ZombieThirdPerson or pl:CallZombieFunction0("ShouldDrawLocalPlayer"))
	or P_Team(pl) == TEAM_HUMAN and self:UseOverTheShoulder()
	or pl:IsPlayingTaunt()
	or pl.Revive and pl.Revive:IsValid()
	or pl.KnockedDown and pl.KnockedDown:IsValid()
end

local roll = 0
function GM:_CalcView(pl, origin, angles, fov, znear, zfar)
	if pl.Confusion and pl.Confusion:IsValid() then
		pl.Confusion:CalcView(pl, origin, angles, fov, znear, zfar)
	end

	if pl.Revive and pl.Revive:IsValid() and pl.Revive.GetRagdollEyes then
		if self.ThirdPersonKnockdown or self.ZombieThirdPerson then
			origin = pl:GetThirdPersonCameraPos(origin, angles)
		else
			local rpos, rang = pl.Revive:GetRagdollEyes(pl)
			if rpos then
				origin = rpos
				angles = rang
			end
		end
	elseif pl.KnockedDown and pl.KnockedDown:IsValid() then
		if self.ThirdPersonKnockdown or self:UseOverTheShoulder() then
			origin = pl:GetThirdPersonCameraPos(origin, angles)
		else
			local rpos, rang = self:GetRagdollEyes(pl)
			if rpos then
				origin = rpos
				angles = rang
			end
		end
	elseif pl:ShouldDrawLocalPlayer() and pl:OldAlive() and not pl:HasWon() then
		if P_Team(pl) == TEAM_UNDEAD then
			origin = pl:GetThirdPersonCameraPos(origin, angles)
		elseif self:UseOverTheShoulder() then
			self:CalcViewOTS(pl, origin, angles, fov, znear, zfar)
		end
	end

	local targetroll = 0
	if self.MovementViewRoll then
		local dir = pl:GetVelocity()
		local speed = dir:Length()
		dir:Normalize()

		targetroll = targetroll + dir:Dot(angles:Right()) * math.min(30, speed / 100)
	end

	if pl:WaterLevel() >= 3 then
		targetroll = targetroll + math.sin(CurTime()) * 7
	end

	roll = math.Approach(roll, targetroll, math.max(0.25, math.sqrt(math.abs(roll))) * 30 * FrameTime())
	angles.roll = angles.roll + roll

	if pl:IsPlayingTaunt() then
		self:CalcViewTaunt(pl, origin, angles, fov, znear, zfar)
	end

	local target = pl:GetObserverTarget()
	if target and target:IsValid() then
		local lasttarget = self.LastObserverTarget
		if lasttarget and lasttarget:IsValid() and target ~= lasttarget then
			if self.LastObserverTargetLerp then
				if CurTime() >= self.LastObserverTargetLerp then
					self.LastObserverTarget = nil
					self.LastObserverTargetLerp = nil
				else
					local delta = math.Clamp((self.LastObserverTargetLerp - CurTime()) / 0.3333, 0, 1) ^ 0.5
					origin:Set(self.LastObserverTargetPos * delta + origin * (1 - delta))
				end
			else
				self.LastObserverTargetLerp = CurTime() + 0.3333
			end
		else
			self.LastObserverTarget = target
			self.LastObserverTargetPos = origin
		end
	end

	if pl:GetObserverMode() ~= OBS_MODE_NONE then
		angles.roll = 0 --Fixes babies tilting the screen
	end

	pl:CallZombieFunction2("CalcView", origin, angles)

	return self.BaseClass.CalcView(self, pl, origin, angles, fov, znear, zfar)
end

function GM:CalcViewTaunt(pl, origin, angles, fov, znear, zfar)
	local tr = util.TraceHull({start = origin, endpos = origin - angles:Forward() * 72, mins = Vector(-2, -2, -2), maxs = Vector(2, 2, 2), mask = MASK_OPAQUE, filter = pl})
	origin:Set(tr.HitPos + tr.HitNormal * 2)
end

function GM:CreateMoveTaunt(cmd)
	cmd:ClearButtons(0)
	cmd:ClearMovement()
end

function GM:PostProcessPermitted(str)
	return false
end

function GM:HUDPaintEndRound()
end

function GM:PreDrawViewModel(vm, pl, wep)
	if pl and pl:IsValid() and (pl:IsHolding() or GAMEMODE.HideViewModels) then return true end

	if wep and wep:IsValid() and wep.PreDrawViewModel then
		return wep:PreDrawViewModel(vm)
	end
end

function GM:PostDrawViewModel(vm, pl, wep)
	if wep and wep:IsValid() then
		if wep.UseHands or not wep:IsScripted() then
			local hands = pl:GetHands()
			if hands and hands:IsValid() then
				hands:DrawModel()
			end
		end

		if wep.PostDrawViewModel then
			wep:PostDrawViewModel(vm)
		end
	end
end

local undo = false
local matWhite = Material("models/debug/debugwhite")
local lowhealthcolor = GM.AuraColorEmpty
local fullhealthcolor = GM.AuraColorFull
function GM:_PrePlayerDraw(pl)
	local shadowman = false

	if pl ~= MySelf and pl:IsEffectActive(EF_DIMLIGHT) then
		pl:RemoveEffects(EF_DIMLIGHT)
	end

	local myteam = P_Team(MySelf)
	local theirteam = P_Team(pl)

	local radius = self.TransparencyRadius
	if radius > 0 and myteam == theirteam and pl ~= MySelf and not (GAMEMODE.AlwaysDrawFriend and pl:IsFriend()) and not self.MedicalAura then
		local dist = pl:GetPos():DistToSqr(EyePos())
		if dist < radius then
			local blend = (dist / radius) ^ 1.4
			if blend <= 0.1 then
				pl.ShadowMan = true return true
			end
			render_SetBlend(blend)
			if myteam == TEAM_HUMAN and blend < 0.5 then
				render_ModelMaterialOverride(matWhite)
				render_SetColorModulation(0.2, 0.2, 0.2)
				shadowman = true
			end
			undo = true
		end
	end

	pl.ShadowMan = shadowman

	if pl:CallZombieFunction0("PrePlayerDraw") then return true end

	if pl.SpawnProtection and (not (pl.status_overridemodel and pl.status_overridemodel:IsValid()) or pl:GetZombieClassTable().NoHideMainModel) then
		undo = true
		render_ModelMaterialOverride(matWhite)
		render_SetBlend(0.02 + (CurTime() + pl:EntIndex() * 0.2) % 0.05)
		render_SetColorModulation(0, 0.3, 0)
		render_SuppressEngineLighting(true)
	end

	if self.m_ZombieVision and myteam == TEAM_UNDEAD and theirteam == TEAM_HUMAN then
		local dist = pl:GetPos():DistToSqr(EyePos())
		if dist <= pl:GetAuraRangeSqr() and (not pl:GetDTBool(DT_PLAYER_BOOL_NECRO) or dist >= 27500) then
			undo = true
			local healthfrac = pl:Health() / pl:GetMaxHealth()

			render_SetBlend(1)
			render_ModelMaterialOverride(matWhite)
			render_SetColorModulation(
				Lerp(healthfrac, lowhealthcolor.r, fullhealthcolor.r) / 255,
				Lerp(healthfrac, lowhealthcolor.g, fullhealthcolor.g) / 255,
				Lerp(healthfrac, lowhealthcolor.b, fullhealthcolor.b) / 255
			)
			render_SuppressEngineLighting(true)
			cam_IgnoreZ(true)
		end
	end
end

local colFriend = Color(10, 255, 10, 60)
local matFriendRing = Material("SGM/playercircle")
local matTargetTri = Material("gui/point.png")
function GM:_PostPlayerDraw(pl)
	pl:CallZombieFunction0("PostPlayerDraw")

	if undo then
		render_SetBlend(1)
		render_ModelMaterialOverride()
		render_SetColorModulation(1, 1, 1)
		render_SuppressEngineLighting(false)
		cam_IgnoreZ(false)

		undo = false
	end

	local eyepos, ang, tpos, distance, hpf
	if MySelf.TargetLocus and self.TraceTargetTeam == pl and pl:IsValidLivingZombie() and not pl:GetZombieClassTable().IgnoreTargetAssist then
		tpos = pl:GetPos()
		tpos.z = tpos.z + 80

		eyepos = MySelf:EyePos()
		distance = eyepos:DistToSqr(tpos)

		ang = (eyepos - tpos):Angle()
		ang:RotateAroundAxis(ang:Right(), 270)
		ang:RotateAroundAxis(ang:Up(), 90)

		cam_IgnoreZ(true)
		cam_Start3D2D(tpos, ang, math.max(750, math.sqrt(distance)) / 6500)
			surface_SetMaterial(matTargetTri)

			hpf = pl:Health() / pl:GetMaxZombieHealth()

			surface_SetDrawColor(255 - (255 * hpf), 255 * hpf, 0, 230)
			surface_DrawTexturedRect(-96, -96, 96, 96)
		cam_End3D2D()
		cam_IgnoreZ(false)
	end

	if pl ~= MySelf and P_Team(MySelf) == P_Team(pl) and pl:IsFriend() then
		local pos = pl:GetPos()
		pos.z = pos.z + 2
		render_SetMaterial(matFriendRing)
		render_DrawQuadEasy(pos, vector_up, 32, 32, colFriend)
		render_DrawQuadEasy(pos, vector_down, 32, 32, colFriend)
	end
end

function GM:HUDPaintBackgroundEndRound()
	local x, y = ScrW() / 2, ScrH() * 0.8
	local timleft = math.max(0, self.EndTime + self.EndGameTime - CurTime())

	if timleft <= 0 then
		draw_SimpleTextBlur(translate.Get("loading"), "ZSHUDFont", x, y, COLOR_WHITE, TEXT_ALIGN_CENTER)
	else
		draw_SimpleTextBlur(translate.Format("next_round_in_x", util.ToMinutesSecondsCD(timleft)), "ZSHUDFontSmall", x, y, COLOR_WHITE, TEXT_ALIGN_CENTER)
	end
end

local function EndRoundCalcView(pl, origin, angles, fov, znear, zfar)
	if GAMEMODE.EndTime and CurTime() < GAMEMODE.EndTime + 5 then
		local endposition = GAMEMODE.LastHumanPosition
		local override = GetGlobalVector("endcamerapos", vector_origin)
		if override ~= vector_origin then
			endposition = override
		end
		if endposition then
			local delta = math.Clamp((CurTime() - GAMEMODE.EndTime) * 2, 0, 1)

			local start = endposition * delta + origin * (1 - delta)
			local tr = util.TraceHull({start = start, endpos = start + delta * 64 * Angle(0, CurTime() * 30, 0):Forward(), mins = Vector(-2, -2, -2), maxs = Vector(2, 2, 2), filter = player.GetAll(), mask = MASK_SOLID})
			return {origin = tr.HitPos + tr.HitNormal, angles = (start - tr.HitPos):Angle()}
		end

		return
	end

	hook.Remove("CalcView", "EndRoundCalcView")
end

local function EndRoundShouldDrawLocalPlayer(pl)
	if GAMEMODE.EndTime and CurTime() < GAMEMODE.EndTime + 5 then
		return true
	end

	hook.Remove("ShouldDrawLocalPlayer", "EndRoundShouldDrawLocalPlayer")
end

function GM:EndRound(winner, nextmap)
	if self.RoundEnded then return end
	self.RoundEnded = true

	ROUNDWINNER = winner

	self.EndTime = CurTime()

	RunConsoleCommand("stopsound")

	self.HUDPaint = self.HUDPaintEndRound
	self.HUDPaintBackground = self.HUDPaintBackgroundEndRound

	if winner == TEAM_UNDEAD and GetGlobalBool("endcamera", true) then
		hook.Add("CalcView", "EndRoundCalcView", EndRoundCalcView)
		hook.Add("ShouldDrawLocalPlayer", "EndRoundShouldDrawLocalPlayer", EndRoundShouldDrawLocalPlayer)
	end

	local dvar = winner == TEAM_UNDEAD and self.AllLoseSound or self.HumanWinSound
	local snd = GetGlobalString(winner == TEAM_UNDEAD and "losemusic" or "winmusic", dvar)
	if snd == "default" then
		snd = dvar
	elseif snd == "none" then
		snd = nil
	end
	if snd then
		timer.Simple(0.5, function() surface_PlaySound(snd) end)
	end

	timer.Simple(5, function()
		if not (pEndBoard and pEndBoard:IsValid()) then
			MakepEndBoard(winner)
		end
	end)
end

function GM:WeaponDeployed(pl, wep)
	self:DoChangeDeploySpeed(wep)
end

function GM:LocalPlayerDied(attackername)
	LASTDEATH = RealTime()

	surface_PlaySound(self.DeathSound)
	if attackername then
		self:CenterNotify(COLOR_RED, {font = "ZSHUDFont"}, translate.Get("you_have_died"))
		self:CenterNotify(COLOR_RED, translate.Format(self.PantsMode and "you_were_kicked_by_x" or "you_were_killed_by_x", tostring(attackername)))
	else
		self:CenterNotify(COLOR_RED, {font = "ZSHUDFont"}, translate.Get("you_have_died"))
	end
end

function GM:KeyPress(pl, key)
	if key == self.MenuKey then
		local team = P_Team(pl)
		if team == TEAM_HUMAN and pl:Alive() and not pl:IsHolding() then
			gamemode.Call("HumanMenu")
		elseif team == TEAM_ZOMBIE and not pl:Alive() then
			gamemode.Call("ZombieSpawnMenu")
		end
	elseif key == IN_SPEED then
		if pl:Alive() then
			if P_Team(pl) == TEAM_HUMAN then
				pl:DispatchAltUse()
			elseif P_Team(pl) == TEAM_UNDEAD then
				pl:CallZombieFunction0("AltUse")
			end
		end
	end
end

function GM:KeyRelease(pl, key)
	if key == self.MenuKey then
		if self.HumanMenuPanel and self.HumanMenuPanel:IsValid() then
			if self.InventoryMenu and self.InventoryMenu:IsValid() then
				self.InventoryMenu:SetVisible(false)

				if self.m_InvViewer and self.m_InvViewer:IsValid() then
					self.m_InvViewer:SetVisible(false)
				end
			end

			if self.HumanMenuSupplyChoice then
				self.HumanMenuSupplyChoice:CloseMenu()
			end

			if self.InventoryMenu.SelInv then
				self.InventoryMenu.SelInv = nil
				self:DoAltSelectedItemUpdate()

				local grid = self.InventoryMenu.Grid
				for k, v in pairs(grid:GetChildren()) do
					v.On = false
				end
			end
		end
	end
end

function GM:PlayerStepSoundTime(pl, iType, bWalking)
	local time = pl:CallZombieFunction2("PlayerStepSoundTime", iType, bWalking)
	if time then
		return time
	end

	if iType == STEPSOUNDTIME_NORMAL or iType == STEPSOUNDTIME_WATER_FOOT then
		return 520 - pl:GetVelocity():Length()
	end

	if iType == STEPSOUNDTIME_ON_LADDER then
		return 500
	end

	if iType == STEPSOUNDTIME_WATER_KNEE then
		return 650
	end

	return 350
end

function GM:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume)
	return pl:CallZombieFunction4("PlayerFootstep", vFootPos, iFoot, strSoundName, fVolume)
end

function GM:PlayerCanCheckout(pl)
	return pl:IsValid() and P_Team(pl) == TEAM_HUMAN and pl:Alive() and self:GetWave() <= 0
end

function GM:OpenWorth()
	if gamemode.Call("PlayerCanCheckout", MySelf) then
		MakepWorth()
	end
end

function GM:CloseWorth()
	if pWorth and pWorth:IsValid() then
		pWorth:Remove()
		pWorth = nil
	end
end

function GM:SuppressArsenalUpgrades(suppresstime)
	self.SuppressArsenalTime = math.max(CurTime() + suppresstime, self.SuppressArsenalTime)
end

function GM:Rewarded(class, amount)
	if CurTime() < self.SuppressArsenalTime then return end

	class = class or "0"

	local toptext = translate.Get("arsenal_upgraded")

	local wep = weapons.Get(class)
	if wep and wep.PrintName and #wep.PrintName > 0 then
		if killicon.Get(class) == killicon.Get("default") then
			self:CenterNotify(COLOR_PURPLE, toptext..": ", color_white, wep.PrintName)
		else
			self:CenterNotify({killicon = class}, " ", COLOR_PURPLE, toptext..": ", color_white, wep.PrintName)
		end
	elseif amount then
		self:CenterNotify(COLOR_PURPLE, toptext..": ", color_white, amount.." "..class)
	else
		self:CenterNotify(COLOR_PURPLE, toptext)
	end
end

function PlayMenuOpenSound()
	MySelf:EmitSound("buttons/lightswitch2.wav", 100, 30)
end

function PlayMenuCloseSound()
	MySelf:EmitSound("buttons/lightswitch2.wav", 100, 20)
end
