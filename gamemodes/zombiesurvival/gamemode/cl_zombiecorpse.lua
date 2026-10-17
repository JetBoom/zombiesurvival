local P_Team = FindMetaTable("Player").Team

local SNAPSHOT_INTERVAL = 0.1
local SETUP_MAX_TRIES = 120

local vec_one = Vector(1, 1, 1)

local DEBUG = false
local function Debug(fmt, ...)
	if DEBUG then
		MsgN("[ZS corpse] " .. string.format(fmt, ...))
	end
end

local function NormModel(path)
	if not isstring(path) then return "" end
	local s = string.gsub(path, "\\", "/")
	return string.lower(s)
end

local function SnapshotBones(pl)
	local bones

	for i = 0, pl:GetBoneCount() - 1 do
		local name = pl:GetBoneName(i)
		if name and name ~= "__INVALIDBONE__" then
			local s = pl:GetManipulateBoneScale(i)
			local p = pl:GetManipulateBonePosition(i)
			local a = pl:GetManipulateBoneAngles(i)

			if s ~= vec_one or p ~= vector_origin or a ~= angle_zero then
				bones = bones or {}
				bones[#bones + 1] = { name = name, scale = s, pos = p, ang = a }
			end
		end
	end

	return bones
end

local function HasCorpseVisuals(tab)
	return tab and (tab.PrePlayerDraw or tab.PrePlayerDrawOverrideModel or tab.OverrideModel)
end

local CLASS_STABLE_DELAY = 0.35

local function SnapshotLiving(pl)
	if P_Team(pl) ~= TEAM_UNDEAD then
		pl.m_ZSCorpseSnap = nil
		return
	end

	if pl:Health() <= 0 then
		return
	end

	local tab = pl:GetZombieClassTable()
	if not tab then return end

	local snap = pl.m_ZSCorpseSnap
	if not snap then
		snap = { class = tab, lastClass = tab, lastClassTime = CurTime() }
		pl.m_ZSCorpseSnap = snap
	end

	if snap.lastClass ~= tab then
		snap.lastClass = tab
		snap.lastClassTime = CurTime()
		return
	end

	if CurTime() - snap.lastClassTime < CLASS_STABLE_DELAY then
		return
	end

	if HasCorpseVisuals(snap.class) and not HasCorpseVisuals(tab) then
		return
	end

	snap.class = tab
	snap.bones = tab.BuildBonePositions and SnapshotBones(pl) or nil
end

local function ApplyBones(rag)
	local list = rag.m_ZSCorpseBoneList

	if not list then
		local snapbones = rag.m_ZSCorpseBones
		if not snapbones or rag:GetBoneCount() <= 0 then return end

		list = {}
		for _, b in ipairs(snapbones) do
			local bi = rag:LookupBone(b.name)
			if bi and bi >= 0 then
				list[#list + 1] = { bi, b.scale, b.pos, b.ang }
			end
		end
		rag.m_ZSCorpseBoneList = list
	end

	for i = 1, #list do
		local e = list[i]
		rag:ManipulateBoneScale(e[1], e[2])
		rag:ManipulateBonePosition(e[1], e[3])
		rag:ManipulateBoneAngles(e[1], e[4])
	end
end

local function ApplyModelScale(ent, tab)
	local ms = tab.ModelScale
	if ms and ms ~= 1 and ent:GetModelScale() ~= ms then
		ent:SetModelScale(ms, 0)
	end
	if tab.ClientsideModelScale then
		local m = Matrix()
		m:Scale(Vector(1, 1, 1) * tab.ClientsideModelScale)
		ent:EnableMatrix("RenderMultiply", m)
	end
end

local function ResetRenderState()
	render.ModelMaterialOverride()
	render.SetColorModulation(1, 1, 1)
	render.SetBlend(1)
	render.SuppressEngineLighting(false)
	cam.IgnoreZ(false)
	render.EnableClipping(false)
end

local function CallClassHook(rag, name, pl, arg)
	local tab = rag.m_ZSCorpseClass
	local fn = tab and tab[name]
	if not fn then return nil end

	local brokenkey = "m_ZSBroken_" .. name
	if rag[brokenkey] then return nil end

	local ok, ret = pcall(fn, tab, pl, arg)
	if not ok then
		rag[brokenkey] = true
		ErrorNoHalt("[ZS corpse] " .. name .. " of class '" .. tostring(tab.Name) .. "' failed: " .. tostring(ret) .. "\n")
		return nil
	end

	return ret
end

local function DrawMain(rag, flags)
	local prev = rag.m_ZSCorpsePrevRender
	if prev then
		prev(rag, flags)
	else
		rag:DrawModel(flags)
	end
end

local function CorpseRender(self, flags)
	ResetRenderState()

	local tab = self.m_ZSCorpseClass
	local pl = self.m_ZSCorpseOwner
	if not IsValid(pl) then pl = nil end

	local mode = self.m_ZSCorpseMode

	if mode == "layered" then
		self:SetupBones()

		local ov = self.m_ZSCorpseOv
		local drawMain = (tab.NoHideMainModel or tab.CorpseUseBaseModel) and not tab.CorpseHideMainModel
		if not drawMain and not IsValid(ov) then drawMain = true end

		if drawMain then
			if pl then CallClassHook(self, "PrePlayerDraw", pl, self) end
			DrawMain(self, flags)
			ResetRenderState()
		end

		return
	end

	-- plain / override
	if self.m_ZSCorpseBones then
		self:SetupBones()
		ApplyBones(self)
	end

	if pl and not tab.CorpsePlainOverrideModel then
		local name = (mode == "override" and tab.PrePlayerDrawOverrideModel) and "PrePlayerDrawOverrideModel" or "PrePlayerDraw"
		CallClassHook(self, name, pl, self)
	end

	DrawMain(self, flags)
	ResetRenderState()
end

local Tracked = {}

local function CleanupTracked()
	for i = #Tracked, 1, -1 do
		local t = Tracked[i]
		if not IsValid(t.rag) then
			if IsValid(t.ov) then t.ov:Remove() end
			table.remove(Tracked, i)
		end
	end
end

local function SetupCorpse(pl, rag)
	local snap = pl.m_ZSCorpseSnap
	if not snap or not snap.class then
		if rag:GetNoDraw() then rag:SetNoDraw(false) end
		return true
	end

	local tab = snap.class

	local model = NormModel(rag:GetModel())
	if model == "" or rag:GetBoneCount() <= 0 then
		rag.m_ZSCorpseTries = (rag.m_ZSCorpseTries or 0) + 1

		if rag.m_ZSCorpseTries > SETUP_MAX_TRIES then
			if rag:GetNoDraw() then rag:SetNoDraw(false) end
			return true
		end

		return false
	end

	local mainmodel = NormModel(tab.Model)
	local ovmodel = NormModel(tab.OverrideModel)

	local mode = "plain"
	if ovmodel ~= "" then
		if model == ovmodel and model ~= mainmodel then
			mode = "override"
		elseif model == mainmodel then
			mode = "layered"
		end
	end

	local ov
	if mode == "layered" then
				ov = ClientsideModel(tab.OverrideModel, RENDER_GROUP_OPAQUE_ENTITY)
		if IsValid(ov) then
			ov:SetParent(rag)
			ov:AddEffects(bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL, EF_PARENT_ANIMATES))
			ov:SetRenderMode(RENDERMODE_TRANSALPHA)
			ov:SetColor(Color(255, 255, 255, 255))

			if tab.ManipulateOverrideModel then
				local ok, err = pcall(tab.ManipulateOverrideModel, tab, pl, ov)
				if not ok then
					ErrorNoHalt("[ZS corpse] ManipulateOverrideModel of '" .. tostring(tab.Name) .. "' failed: " .. tostring(err) .. "\n")
				end
			end

			ov.m_ZSCorpseClass = tab
			ov.m_ZSCorpseOwner = pl
			ov.RenderOverride = function(ent, oflags)
				local classtab = ent.m_ZSCorpseClass
				local owner = ent.m_ZSCorpseOwner
				if not classtab then
					ent:DrawModel(oflags)
					return
				end
				if not IsValid(owner) then owner = nil end

				if owner and not classtab.CorpsePlainOverrideModel then
					local fn = classtab.PrePlayerDrawOverrideModel
					if fn then
						local ok, err = pcall(fn, classtab, owner, ent)
						if not ok then
							ErrorNoHalt("[ZS corpse ov] PrePlayerDrawOverrideModel of '" .. tostring(classtab.Name) .. "' failed: " .. tostring(err) .. "\n")
						end
					end
				end

				ent:DrawModel(oflags)
				ResetRenderState()
			end

			rag.m_ZSCorpseOv = ov
		else
			ov = nil
			mode = "plain"
		end
	end

	rag.m_ZSCorpseClass = tab
	rag.m_ZSCorpseOwner = pl
	rag.m_ZSCorpseMode = mode
	rag.m_ZSCorpseBones = snap.bones

	ApplyModelScale(rag, tab)
	if ov then ApplyModelScale(ov, tab) end

	rag:SetNoDraw(false)

	if tab.CorpseTranslucent then
		rag:SetRenderMode(RENDERMODE_TRANSALPHA)
		if ov then ov:SetRenderMode(RENDERMODE_TRANSALPHA) end
	else
		rag:SetRenderMode(RENDERMODE_NORMAL)
		rag:SetColor(Color(255, 255, 255, 255))
		if ov then ov:SetRenderMode(RENDERMODE_NORMAL) end
	end

	timer.Simple(0, function()
		if not IsValid(rag) then return end
		if rag:GetRenderMode() == RENDERMODE_NONE then
			rag:SetRenderMode(RENDERMODE_NORMAL)
		end
		rag:SetNoDraw(false)
	end)

	rag.m_ZSCorpsePrevRender = rag.RenderOverride
	rag.RenderOverride = CorpseRender

	if ov or snap.bones then
		Tracked[#Tracked + 1] = { rag = rag, ov = ov }
	end

	Debug("%s: class '%s', ragdoll model %s, mode %s, bones %d",
		tostring(pl), tostring(tab.Name), model, mode, snap.bones and #snap.bones or 0)

	return true
end

local NextSnapshot = 0
hook.Add("Think", "ZS_ZombieCorpse", function()
	local curtime = CurTime()
	local dosnapshot = curtime >= NextSnapshot
	if dosnapshot then
		NextSnapshot = curtime + SNAPSHOT_INTERVAL
	end

	for _, pl in player.Iterator() do
		if pl:Alive() then
			if dosnapshot then
				SnapshotLiving(pl)
			end
		else
			local rag = pl:GetRagdollEntity()
			if IsValid(rag) and not rag.m_ZSCorpseDone then
				if SetupCorpse(pl, rag) then
					rag.m_ZSCorpseDone = true
				end
			end
		end
	end

	if #Tracked > 0 then
		CleanupTracked()
	end
end)

local function HidePendingCorpses()
	for _, pl in player.Iterator() do
		if pl:Alive() then continue end

		local snap = pl.m_ZSCorpseSnap
		if not snap or not snap.class then continue end

		if not (snap.class.OverrideModel or snap.class.PrePlayerDrawOverrideModel) then
			continue
		end

		local rag = pl:GetRagdollEntity()
		if not IsValid(rag) then continue end

		if rag.m_ZSCorpseDone or rag.m_ZSCorpseClass then continue end

		if not rag:GetNoDraw() then
			rag:SetNoDraw(true)
		end
	end
end

hook.Add("PreDrawOpaqueRenderables",      "ZS_ZombieCorpse_HidePending", HidePendingCorpses)
hook.Add("PreDrawTranslucentRenderables", "ZS_ZombieCorpse_HidePending", HidePendingCorpses)
