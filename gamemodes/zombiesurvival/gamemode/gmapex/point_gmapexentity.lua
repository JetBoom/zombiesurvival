AddCSLuaFile()

ENT.Type = "anim"

AccessorFuncDT(ENT, "EntityClass", "String", 0)

function ENT:Initialize()
	self:DrawShadow(false)

	if SERVER then
		self:SetModel("models/editor/axis_helper.mdl")
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_NONE)
	end
end

local function SearchForModelIn(filename)
	if file.Exists(filename, "LUA") then
		local contents = file.Read(filename, "LUA")
		return string.match(contents, "self%:SetModel%([\"'](.+)[\"']%)")
	end
end

local function ExtractModel(classname, isweapon, isentity)
	local basedir = isweapon and "weapons/" or "entities/"
	basedir = basedir..classname

	return SearchForModelIn(basedir..".lua")
		or SearchForModelIn(basedir.."/init.lua")
		or SearchForModelIn(basedir.."/shared.lua")
		or SearchForModelIn(basedir.."/cl_init.lua")
end

function ENT:EntityClassChanged()
	local mdl, tex
	local isweapon = false
	local isentity = false
	local classname = self:GetEntityClass()
	local stored = weapons.Get(classname)
	if stored then
		isweapon = true
	else
		stored = scripted_ents.Get(classname)
		if stored then
			isentity = true
		end
	end

	if isentity or isweapon then
		mdl = stored.Model or ExtractModel(classname, isweapon, isentity) -- Try to see if a model can be extracted from the files themselves?
	end

	self:SetModelAndSprite(mdl, tex)
end

function ENT:SetModelAndSprite(mdl, tex)
	mdl = mdl or "models/editor/axis_helper.mdl"

	if SERVER then
		self:SetModel(mdl)
	end

	if CLIENT then
		if tex then
			self.SpriteMaterial = Material(tex)
		else
			self.SpriteMaterial = nil
		end
	end
end

function ENT:Think()
	local entityclass = self:GetEntityClass()
	if self._PrevEntityClass ~= entityclass then
		self._PrevEntityClass = entityclass
		self:EntityClassChanged()
	end
end

if not CLIENT then return end

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:DrawTranslucent()
	if self.SpriteMaterial then
		render.SetMaterial(self.SpriteMaterial)
		render.DrawSprite(self:GetPos(), 24, 24)
	else
		self:DrawModel()
	end
end
