local PANEL = {}

local BASE = baseclass.Get("DModelPanel")

PANEL.SpinSpeed = 0.2

local HAND_BONE = "ValveBiped.Bip01_R_Hand"
local DEBUG = false
local MAX_REL_DEPTH = 16
local cvRig = CreateClientConVar("zs_wepelements_rig", "1", true, false)

local function RemoveEnt(ent)
	if IsValid(ent) then ent:Remove() end
end

local function ClearPreview(self)
	if self._Parts then
		for _, part in ipairs(self._Parts) do
			RemoveEnt(part.ent)
		end
	end
	self._Parts = nil
	self._ElemData = nil
	self._Preview = false
	self._ShowBaseModel = nil
	self._AutoCamCenter = nil
	self._BaseColor = nil
	self._BaseScale = nil
	self._GroundClip = nil
	if self._Rig then
		RemoveEnt(self._Rig.wep)
		RemoveEnt(self._Rig.body)
		self._Rig = nil
	end
end

local function SetEntityModel(self, strModelName)
	RemoveEnt(self.Entity)
	self.Entity = nil

	if not ClientsideModel then return end
	if not isstring(strModelName) or strModelName == "" then return end

	local ent = ClientsideModel(strModelName, RENDER_GROUP_OPAQUE_ENTITY)
	if not IsValid(ent) then return end

	ent:SetNoDraw(true)
	self.Entity = ent

	local iSeq = ent:LookupSequence("walk")
	if iSeq <= 0 then iSeq = ent:LookupSequence("Run1") end
	if iSeq <= 0 then iSeq = ent:LookupSequence("walk_all") end
	if iSeq <= 0 then iSeq = ent:LookupSequence("WalkUnarmed_all") end
	if iSeq <= 0 then iSeq = ent:LookupSequence("walk_all_moderate") end
	if iSeq > 0 then ent:ResetSequence(iSeq) end
end

function PANEL:SetModel(strModelName)
	ClearPreview(self)
	SetEntityModel(self, strModelName)
end

PANEL.FallbackFrameModels = {
	"models/weapons/w_crowbar.mdl",
	"models/weapons/w_pistol.mdl",
	"models/weapons/w_smg1.mdl",
}

local function ReadHandFrame(ent)
	ent:SetPos(Vector(0, 0, 0))
	ent:SetAngles(Angle(0, 0, 0))
	ent:SetupBones()

	local bone = ent:LookupBone(HAND_BONE)
	if bone then
		local m = ent:GetBoneMatrix(bone)
		if m then
			return m:GetTranslation(), m:GetAngles()
		end
	end
end

local FallbackFrame

local function GetFallbackFrame(self)
	if FallbackFrame then return FallbackFrame[1], FallbackFrame[2] end

	for _, mdl in ipairs(self.FallbackFrameModels) do
		if file.Exists(mdl, "GAME") then
			local tmp = ClientsideModel(mdl, RENDER_GROUP_OPAQUE_ENTITY)
			if IsValid(tmp) then
				tmp:SetNoDraw(true)
				local pos, ang = ReadHandFrame(tmp)
				tmp:Remove()
				if pos then
					FallbackFrame = { pos, ang }
					return pos, ang
				end
			end
		end
	end

	return Vector(0, 0, 0), Angle(0, 0, 0)
end

local function GetHandFrame(self, ent)
	if IsValid(ent) then
		local pos, ang = ReadHandFrame(ent)
		if pos then return pos, ang, "world model" end
	end
	local pos, ang = GetFallbackFrame(self)
	return pos, ang, "fallback"
end

PANEL.RigModels = {
	"models/player/kleiner.mdl",
	"models/player/group01/male_01.mdl",
	"models/player/alyx.mdl",
}

local function ComputeRigFrame(self, holdtype)
	if not cvRig:GetBool() or not ClientsideModel then return end

	local base = self.Entity
	if not IsValid(base) then return end

	local bodymodel
	for _, m in ipairs(self.RigModels) do
		if file.Exists(m, "GAME") then bodymodel = m break end
	end
	if not bodymodel then return end

	local body = ClientsideModel(bodymodel, RENDER_GROUP_OPAQUE_ENTITY)
	if not IsValid(body) then return end
	body:SetNoDraw(true)
	body:SetPos(Vector(0, 0, 0))
	body:SetAngles(Angle(0, 0, 0))

	for _, name in ipairs({ "idle_" .. tostring(holdtype or "melee"), "idle_all_01", "idle_all" }) do
		local seq = body:LookupSequence(name)
		if seq and seq > 0 then
			body:ResetSequence(seq)
			body:SetCycle(0)
			break
		end
	end
	body:SetupBones()

	local handbone = body:LookupBone(HAND_BONE)
	local H = handbone and body:GetBoneMatrix(handbone)
	if not H then
		body:Remove()
		return
	end

	base:SetPos(Vector(0, 0, 0))
	base:SetAngles(Angle(0, 0, 0))
	base:SetupBones()

	local bestW, bestR, bestName
	for i = 0, (base:GetBoneCount() or 0) - 1 do
		local name = base:GetBoneName(i)
		if name and name ~= "__INVALIDBONE__" then
			local bi = body:LookupBone(name)
			if bi then
				local W = body:GetBoneMatrix(bi)
				local R = base:GetBoneMatrix(i)
				if W and R and (not bestW or name == HAND_BONE) then
					bestW, bestR, bestName = W, R, name
				end
			end
		end
	end
	body:Remove()

	if not bestW then return end
	local inv = bestW:GetInverse()
	if not inv then return end

	local F = bestR * inv * H
	return F:GetTranslation(), F:GetAngles(), bestName
end

local Placed
Placed = function(self, name, cache, depth)
	local c = cache[name]
	if c then return c[1], c[2] end

	local data = self._ElemData[name]
	if not istable(data) then return nil end

	local ppos, pang
	local rel = data.rel
	if isstring(rel) and rel ~= "" and rel ~= name and depth < MAX_REL_DEPTH and self._ElemData[rel] then
		ppos, pang = Placed(self, rel, cache, depth + 1)
	end
	if not ppos then
		ppos, pang = self._FramePos, self._FrameAng
	end

	local dp = data.pos
	local px, py, pz = dp and dp.x or 0, dp and dp.y or 0, dp and dp.z or 0

	local pos = ppos + pang:Forward() * px + pang:Right() * py + pang:Up() * pz
	local ang = Angle(pang.p, pang.y, pang.r)

	local da = data.angle
	if da then
		ang:RotateAroundAxis(ang:Up(),      da.y)
		ang:RotateAroundAxis(ang:Right(),   da.p)
		ang:RotateAroundAxis(ang:Forward(), da.r)
	end

	cache[name] = { pos, ang }
	return pos, ang
end

local function SizeToVector(size)
	if isvector(size) then return size end
	if isnumber(size) then return Vector(size, size, size) end
	return Vector(1, 1, 1)
end

local function PartMatrix(pos, ang, size)
	local m = Matrix()
	m:SetTranslation(pos)
	m:SetAngles(ang)
	m:Scale(SizeToVector(size))
	return m
end

local function BuildParts(self, weles)
	local models, sprites = {}, {}

	for name, data in pairs(weles) do
		if istable(data) and not data.hide then
			if data.type == "Model" and isstring(data.model) and data.model ~= ""
				and file.Exists(data.model, "GAME") then

				util.PrecacheModel(data.model)
				local ent = ClientsideModel(data.model, RENDER_GROUP_OPAQUE_ENTITY)
				if IsValid(ent) then
					ent:SetNoDraw(true)

					if istable(data.bodygroup) then
						for k, v in pairs(data.bodygroup) do
							k, v = tonumber(k), tonumber(v)
							if k and v then ent:SetBodygroup(k, v) end
						end
					end
					local skin = tonumber(data.skin)
					if skin then ent:SetSkin(skin) end

					local sm = Matrix()
					sm:Scale(SizeToVector(data.size))
					ent:EnableMatrix("RenderMultiply", sm)

					models[#models + 1] = { name = name, data = data, ent = ent }
				end

			elseif data.type == "Sprite" and isstring(data.sprite) and data.sprite ~= ""
				and file.Exists("materials/" .. data.sprite .. ".vmt", "GAME") then

				local matName = "sweppreview_" .. data.sprite .. "-"
				local params = { ["$basetexture"] = data.sprite }
				for _, flag in ipairs({ "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }) do
					if data[flag] then
						params["$" .. flag] = 1
						matName = matName .. "1"
					else
						matName = matName .. "0"
					end
				end

				sprites[#sprites + 1] = {
					name = name, data = data,
					mat = CreateMaterial(matName, "UnlitGeneric", params)
				}
			end
		end
	end

	for _, sp in ipairs(sprites) do models[#models + 1] = sp end
	return models
end

local TURRET = {
	model = "models/Combine_turrets/Floor_turret.mdl",
	useEntScale = true,
	anchorAttachment = "eyes", anchorPos = Vector(0, 0, 55),
	gunPitch = 15,
	pose = { aim_pitch = 15, aim_yaw = 0 },
	groundClip = true,
}

local function Derive(base, extra)
	local t = table.Copy(base)
	for k, v in pairs(extra) do t[k] = v end
	return t
end

local ZAPPER = {
	model = "models/props_c17/utilityconnecter006c.mdl",
	modelScale = 0.75,
	baseScale = Vector(0.6, 0.6, 1.2),
	baseMaterial = "models/shiny", baseColor = Color(128, 128, 128),
	parts = {
		{ model = "models/props_trainstation/trainstation_ornament002.mdl", pos = Vector(0, 0, -25.6), angle = Angle(0, 0, 0), size = Vector(2, 2, 0.25), color = Color(190, 255, 255) },},}

local ZAPPER_ARC = {
	model = "models/props_c17/utilityconnecter006c.mdl",
	modelScale = 0.75,
	baseScale = Vector(0.85, 0.85, 1.2),
	baseMaterial = "models/shiny", baseColor = Color(102, 102, 102), -- 0.4*255
	parts = {
		{ model = "models/props_trainstation/trainstation_ornament002.mdl", pos = Vector(0, 0, -25.6), angle = Angle(0, 0, 0), size = Vector(2, 2, 0.25), color = Color(195, 195, 145) },

		{ model = "models/props_c17/utilityconnecter005.mdl", pos = Vector(0, -2, 25.6), angle = Angle(0, 0, -70), size = Vector(2, 1.25, 0.25), color = Color(150, 150, 150), material = "models/shiny" },

		{ model = "models/props_c17/utilityconnecter005.mdl", pos = Vector(0, 2, 25.6), angle = Angle(0, 0, 70), size = Vector(2, 1.25, 0.25), color = Color(150, 150, 150), material = "models/shiny" },
	},
}

PANEL.DeployablePreviews = {
	prop_drone = {
		model = "models/combine_scanner.mdl",
		sequence = 2, -- init.lua: SetSequence(2)
		anchorPos = Vector(3, 0, 13.75), -- ENT:GetRedLightPos
	},

	prop_drone_hauler = {
		model = "models/shield_scanner.mdl",
		sequence = 5, -- init.lua: ResetSequence(5)
	},

	prop_drone_pulse = {
		model = "models/combine_scanner.mdl",
		sequence = 2,
		anchorPos = Vector(3, 0, 13.75),
		gunPitch = 15,
		parts = {
			{ model = "models/weapons/w_IRifle.mdl", anchored = true,
			  pos = Vector(12, 1, -5), angle = Angle(0, 180, 0),
			  size = Vector(0.9, 0.65, 0.65), color = Color(150, 150, 150),
			  material = "phoenix_storms/torpedo" },
		},
	},

	prop_gunturret = Derive(TURRET, {}),

	prop_gunturret_rocket = Derive(TURRET, { parts = {
		{ model = "models/weapons/w_rocket_launcher.mdl", anchored = true,
		  pos = Vector(8, 1, -5), angle = Angle(0, 180, 0),
		  size = Vector(0.9, 2, 2), color = Color(150, 150, 150),
		  material = "phoenix_storms/torpedo" },
		{ model = "models/props_trainstation/trainstation_ornament002.mdl",
		  pos = Vector(0, 0, 0), angle = Angle(0, 180, 0),
		  size = Vector(0.65, 0.65, 1.5), color = Color(100, 100, 100),
		  material = "phoenix_storms/torpedo" },
		{ model = "models/props_wasteland/buoy01.mdl",
		  pos = Vector(0, 0, 0), angle = Angle(0, 0, 0),
		  size = Vector(0.25, 0.15, 0.7), color = Color(100, 100, 100),
		  material = "phoenix_storms/torpedo" },
	} }),

	prop_gunturret_assault = Derive(TURRET, { parts = {
		-- ShootPos + Forward*4 + Right*4  (Right = -Y)  =>  y = -4
		{ model = "models/weapons/w_rif_aug.mdl", anchored = true,
		  pos = Vector(4, -4, 0), angle = Angle(0, 0, 45),
		  size = Vector(1.1, 0.9, 0.9), color = Color(70, 70, 70),
		  material = "phoenix_storms/torpedo" },
		{ model = "models/weapons/w_rif_aug.mdl", anchored = true,
		  pos = Vector(4, -4, 0), angle = Angle(0, 0, -45),
		  size = Vector(1.1, 0.9, 0.9), color = Color(70, 70, 70),
		  material = "phoenix_storms/torpedo" },
		{ model = "models/props_trainstation/trainstation_ornament002.mdl",
		  pos = Vector(0, 0, 0), angle = Angle(0, 180, 0),
		  size = Vector(0.65, 0.65, 1.5), color = Color(100, 100, 100),
		  material = "phoenix_storms/torpedo" },
		{ model = "models/props_wasteland/buoy01.mdl",
		  pos = Vector(0, 0, 0), angle = Angle(0, 0, 0),
		  size = Vector(0.25, 0.15, 0.7), color = Color(100, 100, 100),
		  material = "phoenix_storms/torpedo" },
	} }),

	prop_gunturret_buckshot = Derive(TURRET, { parts = {
		{ model = "models/weapons/w_shotgun.mdl", anchored = true,
		  pos = Vector(8, 0, 0), angle = Angle(0, 180, 0) },
	} }),

	prop_zapper = ZAPPER,
	prop_zapper_arc = ZAPPER_ARC,

	-- server init: SetBodygroup(1,1), SetBodygroup(2,1), SetSequence(1)
	prop_manhack = {
		model = "models/manhack.mdl",
		bodygroup = { [1] = 1, [2] = 1 },
		sequence = 1,
	},

	prop_manhack_saw = {
		model = "models/manhack.mdl",
		bodygroup = { [1] = 1, [2] = 1 },
		sequence = 1,
		parts = {
			{ model = "models/props_junk/sawblade001a.mdl",
			  pos = Vector(0, 0, -1.5), angle = Angle(0, 0, 0),
			  size = Vector(0.8, 0.8, 0.8), spin = 360 },
		},
	},
}

local function ResolveDef(self, entclass)
	local name, guard = entclass, 0
	while isstring(name) and guard < 8 do
		local d = self.DeployablePreviews[name]
		if d then return d end
		local st = scripted_ents.GetStored(name)
		name = istable(st) and istable(st.t) and st.t.Base or nil
		guard = guard + 1
	end
end

local SWEPToEnt
local function FindEntClassForSWEP(swepclass)
	if not isstring(swepclass) then return end

	if not SWEPToEnt then
		SWEPToEnt = {}

		local info = GAMEMODE and GAMEMODE.DeployableInfo
		if istable(info) then
			for _, tab in ipairs(info) do
				if isstring(tab.WepClass) and isstring(tab.Class) then
					SWEPToEnt[tab.WepClass] = tab.Class
				end
			end
		end

		for name, v in pairs(scripted_ents.GetList()) do
			local t = istable(v) and v.t
			if istable(t) then
				if isstring(t.SWEP) and not SWEPToEnt[t.SWEP] then SWEPToEnt[t.SWEP] = name end
				if isstring(t.WeaponClass) and not SWEPToEnt[t.WeaponClass] then SWEPToEnt[t.WeaponClass] = name end
			end
		end
	end

	local found = SWEPToEnt[swepclass]
	if found then return found end

	local guess = "prop_" .. string.gsub(swepclass, "^weapon_zs_", "")
	if swepclass ~= guess and scripted_ents.GetStored(guess) then return guess end
end

local function BuildEntityPreview(self, entclass, useElements)
	local def = ResolveDef(self, entclass) or {}
	local et = scripted_ents.Get(entclass)

	local model = def.model
	if not model then
		for _, e in ipairs(ents.FindByClass(entclass)) do
			if IsValid(e) then
				local m = e:GetModel()
				if isstring(m) and m ~= "" then model = m break end
			end
		end
	end
	if not model and istable(et) and isstring(et.Model) and et.Model ~= "" then
		model = et.Model
	end
	if not isstring(model) or model == "" then return false end

	SetEntityModel(self, model)
	local ent = self.Entity
	if not IsValid(ent) then return false end

	local ms = def.modelScale
	if not ms and def.useEntScale and istable(et) then ms = tonumber(et.ModelScale) end
	if ms and ms ~= 1 then ent:SetModelScale(ms, 0) end

	if isvector(def.baseScale) then
		local m = Matrix()
		m:Scale(def.baseScale)
		ent:EnableMatrix("RenderMultiply", m)
	end
	if def.baseMaterial then ent:SetMaterial(def.baseMaterial) end
	if istable(def.bodygroup) then
		for k, v in pairs(def.bodygroup) do ent:SetBodygroup(k, v) end
	end
	if def.sequence then ent:ResetSequence(def.sequence) end
	if istable(def.pose) then
		for k, v in pairs(def.pose) do ent:SetPoseParameter(k, v) end
	end

	self._BaseColor = def.baseColor
	self._GroundClip = def.groundClip
	self._BaseScale = SizeToVector(def.baseScale) * (ms or 1)

	local anchorLocal
	if def.anchorAttachment then
		ent:SetPos(Vector(0, 0, 0))
		ent:SetAngles(Angle(0, 0, 0))
		ent:SetupBones()
		local id = ent:LookupAttachment(def.anchorAttachment)
		if id and id > 0 then
			local at = ent:GetAttachment(id)
			if at then anchorLocal = at.Pos end
		end
	end
	anchorLocal = anchorLocal or def.anchorPos or Vector(0, 0, 0)

	self._Preview = true
	self._ShowBaseModel = true
	self._AutoCamAngle = math.rad(45)
	self._FramePos, self._FrameAng = Vector(0, 0, 0), Angle(0, 0, 0)

	local weles = {}

	weles["anchor"] = {
		type = "Anchor", rel = "",
		pos = Vector(anchorLocal.x, -anchorLocal.y, anchorLocal.z),
		angle = Angle(-(def.gunPitch or 0), 0, 0),
	}

	if useElements ~= false then
		for i, p in ipairs(def.parts or {}) do
			weles["part" .. i] = {
				type = "Model", model = p.model, rel = p.anchored and "anchor" or "",
				pos = Vector(p.pos.x, -p.pos.y, p.pos.z),
				angle = p.angle or Angle(0, 0, 0),
				size = p.size or Vector(1, 1, 1),
				color = p.color, material = p.material or "",
				skin = 0, bodygroup = {}, spin = p.spin,
			}
		end
	end

	self._ElemData = weles
	self._Parts = BuildParts(self, weles)
	ent:SetPos(Vector(0, 0, 0))
	ent:SetAngles(Angle(0, 0, 0))
	self:AutoCam()
	return true
end

function PANEL:SetSWEPPreview(sweptable, useElements)
	ClearPreview(self)

	if not sweptable then
		SetEntityModel(self, "")
		self:AutoCam()
		return
	end

	local entclass = FindEntClassForSWEP(sweptable.ClassName)
	if entclass then
		local ok = BuildEntityPreview(self, entclass, useElements)
		if DEBUG then
			MsgN(string.format("[DModelPanelEx] %s -> entity %s: preview %s",
				tostring(sweptable.ClassName), entclass, ok and "built" or "FAILED (no model), using SWEP model"))
		end
		if ok then return end
	elseif DEBUG then
		MsgN("[DModelPanelEx] " .. tostring(sweptable.ClassName) .. ": no deployable entity found, treating as a normal weapon")
	end
	ClearPreview(self)

	SetEntityModel(self, sweptable.WorldModel)

	local weles = sweptable.WElements
	local hasElems = useElements ~= false and istable(weles) and next(weles) ~= nil

	self._Preview = true
	self._AutoCamAngle = math.rad(45)

	if not hasElems then
		if IsValid(self.Entity) then
			self.Entity:SetPos(Vector(0, 0, 0))
			self.Entity:SetAngles(Angle(0, 0, 0))
		end
		self._ShowBaseModel = true
		self:AutoCam()
		return
	end

	self._ShowBaseModel = sweptable.ShowWorldModel ~= false
	self._ElemData = weles
	local source
	local fp, fa, bname = ComputeRigFrame(self, sweptable.HoldType)
	if fp then
		self._FramePos, self._FrameAng, source = fp, fa, "player rig, shared bone " .. tostring(bname)
	else
		self._FramePos, self._FrameAng, source = GetHandFrame(self, self.Entity)
	end
	self._Parts = BuildParts(self, weles)

	if DEBUG then
		MsgN(string.format("[DModelPanelEx] %s: WorldModel=%s showbase=%s hand frame from %s, pos=%s ang=%s, parts=%d",
			tostring(sweptable.ClassName), tostring(sweptable.WorldModel), tostring(self._ShowBaseModel),
			source, tostring(self._FramePos), tostring(self._FrameAng), #self._Parts))
	end

	self:AutoCam()
end

function PANEL:AutoCam()
	if self._Preview then
		return self:PreviewAutoCam()
	end

	if IsValid(self.Entity) then
		local mins, maxs = self.Entity:GetRenderBounds()
		self:SetCamPos(mins:Distance(maxs) * Vector(0.75, 0.75, 0.5))
		self:SetLookAt((mins + maxs) / 2)
	end
end

function PANEL:PreviewAutoCam()
	local mins = Vector(math.huge, math.huge, math.huge)
	local maxs = Vector(-math.huge, -math.huge, -math.huge)

	local function AddPoint(v)
		mins.x = math.min(mins.x, v.x)
		mins.y = math.min(mins.y, v.y)
		mins.z = math.min(mins.z, v.z)
		maxs.x = math.max(maxs.x, v.x)
		maxs.y = math.max(maxs.y, v.y)
		maxs.z = math.max(maxs.z, v.z)
	end

	if self._Rig and IsValid(self.Entity) then
		local bmins, bmaxs = self.Entity:GetRenderBounds()
		local r = bmins:Distance(bmaxs) * 0.6
		AddPoint(self._Rig.pos - Vector(r, r, r))
		AddPoint(self._Rig.pos + Vector(r, r, r))
	elseif self._ShowBaseModel and IsValid(self.Entity) then
		local bmins, bmaxs = self.Entity:GetRenderBounds()
		local bs = self._BaseScale
		if bs then
			bmins = Vector(bmins.x * bs.x, bmins.y * bs.y, bmins.z * bs.z)
			bmaxs = Vector(bmaxs.x * bs.x, bmaxs.y * bs.y, bmaxs.z * bs.z)
		end
		AddPoint(bmins)
		AddPoint(bmaxs)
	end

	if self._Parts and self._ElemData then
		local cache = {}
		for _, part in ipairs(self._Parts) do
			local pos, ang = Placed(self, part.name, cache, 0)
			if pos then
				if IsValid(part.ent) then
					local emins, emaxs = part.ent:GetRenderBounds()
					local m = PartMatrix(pos, ang, part.data.size)
					for ix = 0, 1 do
						for iy = 0, 1 do
							for iz = 0, 1 do
								AddPoint(m * Vector(
									ix == 0 and emins.x or emaxs.x,
									iy == 0 and emins.y or emaxs.y,
									iz == 0 and emins.z or emaxs.z
								))
							end
						end
					end
				elseif part.mat then
					local sz = part.data.size
					local s = (sz and sz.x or 1) * 0.5
					AddPoint(pos - Vector(s, s, s))
					AddPoint(pos + Vector(s, s, s))
				end
			end
		end
	end

	if mins.x > maxs.x then
		mins, maxs = Vector(-16, -16, -16), Vector(16, 16, 16)
	end

	if self._GroundClip then
		mins.z = math.max(mins.z, 0)
		if maxs.z < mins.z + 1 then maxs.z = mins.z + 1 end
	end

	self._AutoCamCenter = (mins + maxs) * 0.5
	self._AutoCamRadius = math.max((maxs - mins):Length(), 32)
	self._AutoCamAngle = self._AutoCamAngle or math.rad(45)
	self:UpdateCam()
end

function PANEL:UpdateCam()
	if not self._AutoCamCenter then return end
	local c = self._AutoCamCenter
	local d = self._AutoCamRadius
	local a = self._AutoCamAngle
	local hR = d * 1.06066
	local zR = d * 0.5
	self:SetCamPos(c + Vector(math.cos(a) * hR, math.sin(a) * hR, zR))
	self:SetLookAt(c)
end

function PANEL:Think()
	if BASE and BASE.Think then BASE.Think(self) end

	if self._Preview and self._AutoCamCenter then
		self._AutoCamAngle = (self._AutoCamAngle or math.rad(45)) + FrameTime() * self.SpinSpeed
		self:UpdateCam()
	end
end

function PANEL:ApplyPanelLighting()
	local amb = self.colAmbient or Color(50, 50, 50)
	render.ResetModelLighting(amb.r / 255, amb.g / 255, amb.b / 255)
	local lights = self.DirectionalLight
	if lights then
		for i = 0, 6 do
			local col = lights[i]
			if col then
				render.SetModelLighting(i, col.r / 255, col.g / 255, col.b / 255)
			end
		end
	end
end

function PANEL:DrawPreviewInner(panelBlend)
	local rig = self._Rig
	if rig and IsValid(rig.body) and IsValid(rig.wep) then
		rig.body:SetupBones()
		rig.wep:DrawModel()
	elseif self._ShowBaseModel and IsValid(self.Entity) then
		self.Entity:SetPos(Vector(0, 0, 0))
		self.Entity:SetAngles(Angle(0, 0, 0))

		local bc = self._BaseColor
		if bc then
			render.SetColorModulation(bc.r / 255, bc.g / 255, bc.b / 255)
		end
		self.Entity:DrawModel()
		render.SetColorModulation(1, 1, 1)
	end

	if not self._Parts then return end

	local cache = {}
	for _, part in ipairs(self._Parts) do
		local data = part.data
		local pos, ang = Placed(self, part.name, cache, 0)

		if pos then
			local ent = part.ent

			if data.spin then
				ang = Angle(ang.p, ang.y, ang.r)
				ang:RotateAroundAxis(ang:Up(), (RealTime() * data.spin) % 360)
			end

			if IsValid(ent) then
				ent:SetPos(pos)
				ent:SetAngles(ang)

				local mat = data.material or ""
				if mat == "" then
					if ent:GetMaterial() ~= "" then ent:SetMaterial("") end
				elseif ent:GetMaterial() ~= mat then
					ent:SetMaterial(mat)
				end

				if data.surpresslightning then
					render.ResetModelLighting(1, 1, 1)
				end

				local col = data.color
				if col then
					render.SetColorModulation(col.r / 255, col.g / 255, col.b / 255)
					render.SetBlend(panelBlend * (col.a / 255))
				end

				ent:DrawModel()

				render.SetColorModulation(1, 1, 1)
				render.SetBlend(panelBlend)
				if data.surpresslightning then
					self:ApplyPanelLighting()
				end

			elseif part.mat then
				local sz = data.size
				render.SetMaterial(part.mat)
				render.DrawSprite(pos, sz and sz.x or 1, sz and sz.y or 1, data.color or color_white)
			end
		end
	end
end

function PANEL:DrawPreview(panelBlend)
	if not self._GroundClip then
		return self:DrawPreviewInner(panelBlend)
	end

	local oldclip = render.EnableClipping(true)
	render.PushCustomClipPlane(Vector(0, 0, 1), 0)
	self:DrawPreviewInner(panelBlend)
	render.PopCustomClipPlane()
	render.EnableClipping(oldclip)
end

function PANEL:Paint(w, h)
	if not self._Preview then
		return BASE.Paint(self, w, h)
	end

	local x, y = self:LocalToScreen(0, 0)
	local campos, lookat = self.vCamPos, self.vLookatPos
	if not campos or not lookat then return end
	local ang = self.aLookAngle or (lookat - campos):Angle()

	local panelBlend = self:GetAlpha() / 255

	cam.Start3D(campos, ang, self.fFOV, x, y, w, h, 5, self.FarZ)
		render.ClearDepth()
		render.SuppressEngineLighting(true)
		render.SetLightingOrigin(Vector(0, 0, 0))
		self:ApplyPanelLighting()
		render.SetColorModulation(1, 1, 1)
		render.SetBlend(panelBlend)

		self:DrawPreview(panelBlend)

		render.SetColorModulation(1, 1, 1)
		render.SetBlend(1)
		render.SuppressEngineLighting(false)
	cam.End3D()

	self.LastPaint = RealTime()
end

function PANEL:OnRemove()
	ClearPreview(self)
	RemoveEnt(self.Entity)
	self.Entity = nil
end

vgui.Register("DModelPanelEx", PANEL, "DModelPanel")
