// NOTE by Clavus: glon was removed from GMod 13, replaced by the util.TableToJSON etc functions
// In order to maintain compatability and not rewrite all that shit, I'm including it with the SCK.

-- GLON: Garry's Mod Lua Object Notation
-- A extension of LON: Lua Object Notation
-- Made entirely by Deco Da Man
-- Types:
	-- 2: table
	-- 3: array
	-- 4: fasle boolean
	-- 5: true boolean
	-- 6: number (NOT COMPRESSED, it isn't worth it)
	-- 7: string
	---- non-LON types start here!
	-- 8: Vector (NOT COMPRESSED, it isn't worth it)
	-- 9: Angle (NOT COMPRESSED, it isn't worth it)
	-- 10: Entity (Can do players, vehicles, npcs, weapons and any other type of entity (-1 for null entity))
	-- 11: Player (By UserID)
	-- 12: CEffectData
	-- 13: ConVar (Not ClientConVar)
	-- 15: Color
	-- 254: The number equal to -math.huge (tostring(math.huge) == "-1.#INF")
	-- 254: The number equal to math.huge (tostring(math.huge) == "1.#INF")
	-- 255: reference (Sends the ID of the table to use (for "local t = {} t.a=t"))
/*local pairs = pairs
local type = type
local string = string
local math = math
local tostring = tostring
local ValidEntity = ValidEntity
local error = error
local print = print
local setmetatable = setmetatable
local Vector = Vector
local Angle = Angle
local Entity = Entity
local EffectData = EffectData
local GetConVar = GetConVar
local tonumber = tonumber
local player = player
local IsValid = IsValid
module("glon")*/
glon = {}
local encode_types
local decode_types
local Write
local Read

local function InDataEscape(s)
	s = string.gsub(s, "([\1\2])", "\2%1")
	s = string.gsub(s, "%z", "\2\3")
	s = string.gsub(s, "\"", "\4") // escape the " character to simplify client commands
	return s
end

encode_types = {
	["nil"] = {nil, function()
		return "", nil
	end},
	table = {2, function(o, rtabs)
		for k,v in pairs(rtabs) do
			if v == o then
				return tostring(k).."\1", 255
			end
		end
		rtabs[#rtabs+1] = o
		local is_array = true
		local i = 0
		for k,v in pairs(o) do
			i = i + 1
			if k ~= i or type(k) ~= "number" or math.floor(k) ~= k then
				is_array = false
			break end
		end
		local s = ""
		for k,v in pairs(o) do
		
			if ( !encode_types[type(v)] ) then continue end
		
			if not is_array then
				s = s..Write(k, rtabs)
			end
			s = s..Write(v, rtabs)
		end
		return s.."\1", is_array and 3
	end},
	boolean = {4, function(o)
		return "", o and 5
	end},
	number = {6, function(o)
		o = o == 0 and "" or o
		return o == ((o == math.huge or o == -math.huge) and "") or tostring(o).."\1", (o == math.huge and 254) or (o == -math.huge and 253)
	end},
	string = {7, function(o)
		return InDataEscape(o).."\1"
	end},
	-- non-LON types start here!
	Vector = {8, function(o)
		return o.x.."\1"..o.y.."\1"..o.z.."\1"
	end},
	Angle = {9, function(o)
		return o.p.."\1"..o.y.."\1"..o.r.."\1"
	end},
	Entity = {10, function(o)
		return (ValidEntity(o) and o:EntIndex() or -1).."\1"
	end},
	NPC = {10, function(o)
		return (ValidEntity(o) and o:EntIndex() or -1).."\1"
	end},
	Weapon = {10, function(o)
		return (ValidEntity(o) and o:EntIndex() or -1).."\1"
	end},
	Player = {11, function(o)
		return o:EntIndex().."\1"
	end},
	CEffectData = {12, function(o, rtabs)
		local t = {}
		if o:GetAngle() ~= Angle(0,0,0) then
			t.a = o:GetAngle()
		end
		if o:GetAttachment() ~= 0 then
			t.h = o:GetAttachment()
		end
		if o:GetEntity():IsValid() then
			t.e = o:GetEntity()
		end
		if o:GetMagnitude() ~= 0 then
			t.m = o:GetMagnitude()
		end
		if o:GetNormal() ~= Vector(0,0,0) then
			t.n = o:GetNormal()
		end
		if o:GetOrigin() ~= Vector(0,0,0) then
			t.o = o:GetOrigin()
		end
		if o:GetRadius() ~= 0 then
			t.r = o:GetRadius()
		end
		if o:GetScale() ~= 0 then
			t.c = o:GetScale()
		end
		if o:GetStart() ~= 0 then
			t.s = o:GetStart()
		end
		if o:GetSurfaceProp() ~= 0 then
			t.p = o:GetSurfaceProp()
		end
		return encode_types.table[2](t, rtabs)
	end},
	ConVar = {13, function(o)
		return InDataEscape(o:GetName()).."\1"
	end},
	PhysObj = {14, function(o)
		local parent, obj, id = o:GetEntity()
		for i = 1, parent:GetPhysicsObjectCount() do
			obj = parent:GetPhysicsObjectNum()
			if obj == o then
				id = i
			break end
		end
		return parent:EntIndex().."\1"..id.."\1"
	end},
	Color = {15, function(o)
		return o.r.."\1"..o.g.."\1"..o.b.."\1"..o.a.."\1"
	end},
}

Write = function(data, rtabs)
	local t = encode_types[type(data)]
	if t then
		local data, id_override = t[2](data, rtabs)
		local char = id_override or t[1] or ""
		if char ~= "" then char = string.char(char) end
		return char..(data or "")
	else
		error(string.format("Tried to write unwriteable type: %s",
			type(data)))
	end
end

local CEffectDataTranslation = {
	a = "Angle",
	h = "Attachment",
	e = "Entity",
	m = "Magnitude",
	n = "Normal",
	o = "Origin",
	r = "Radius",
	c = "Scale",
	s = "Start",
	p = "SurfaceProp",
}
decode_types = {
	-- \2\6omg\1\6omgavalue\1\1
	[2	] = function(reader, rtabs) -- table
		local t, c, pos = {}, reader:Next()
		rtabs[#rtabs+1] = t
		local stage = false
		local key
		while true do
			c, pos = reader:Peek()
			if c == "\1" then
				if stage then
					error(string.format("Expected value to match key at %s! (Got EO Table)",
						pos))
				else
					reader:Next()
					return t
				end
			else
				if stage then
					t[key] = Read(reader, rtabs)
				else
					key = Read(reader, rtabs)
				end
				stage = not stage
			end
		end
	end,
	[3	] = function(reader, rtabs) -- array
		local t, i, c, pos = {}, 1, reader:Next()
		rtabs[#rtabs+1] = t
		while true do
			c, pos = reader:Peek()
			if c == "\1" then
				reader:Next()
				return t
			else
				t[i] = Read(reader, rtabs)
				i = i+1
			end
		end
	end,
	[4	] = function(reader) -- false boolean
		reader:Next()
		return false
	end,
	[5	] = function(reader) -- true boolean
		reader:Next()
		return true
	end,
	[6	] = function(reader) -- number
		local s, c, pos, e = "", reader:Next()
		while true do
			c = reader:Next()
			if not c then
				error(string.format("Expected \1 to end number at %s! (Got EOF!)",
					pos))
			elseif c == "\1" then
				break
			else
				s = s..c
			end
		end
		if s == "" then s = "0" end
		local n = tonumber(s)
		if not n then
			error(string.format("Invalid number at %s! (%q)",
				pos, s))
		end
		return n
	end,
	[7	] = function(reader) -- string
		local s, c, pos, e = "", reader:Next()
		while true do
			c = reader:Next()
			if not c then
				error(string.format("Expected unescaped \1 to end string at position %s! (Got EOF)",
					pos))
			elseif e then
				if c == "\3" then
					s = s.."\0"
				else
					s = s..c
				end
				e = false
			elseif c == "\2" then
				e = true
			elseif c == "\1" then
				s = string.gsub(s, "\4", "\"") // unescape quotes
				return s
			else
				s = s..c
			end
		end
	end,
	[8	] = function(reader) -- Vector
		local x = decode_types[6](reader)
		reader:StepBack()
		local y = decode_types[6](reader)
		reader:StepBack()
		local z = decode_types[6](reader)
		return Vector(x, y, z)
	end,
	[9	] = function(reader) -- Angle
		local p = decode_types[6](reader)
		reader:StepBack()
		local y = decode_types[6](reader)
		reader:StepBack()
		local r = decode_types[6](reader)
		return Angle(p, y, r)
	end,
	[10	] = function(reader) -- Entity
		return Entity(decode_types[6](reader))
	end,
	[11	] = function(reader) -- Player
		local num = decode_types[6](reader)
		return player.GetByID(num)
	end,
	[12 ] = function(reader, rtabs) -- CEffectData
		local t = decode_types[2](reader, rtabs)
		local d = EffectData()
		for k,v in pairs(t) do
			d["Set"..CEffectDataTranslation[k]](d, v)
		end
		return d
	end,
	[13	] = function(reader) -- ConVar
		return GetConVar(decode_types[7](reader))
	end,
	[14	] = function(reader) -- PhysicsObject
	
		local ent = Entity(decode_types[6](reader))
		local bone = decode_types[6](reader)
		
		if ( !IsValid( ent ) ) then return nil end;	
		return ent:GetPhysicsObjectNum( bone )
	end,
	[15 ] = function(reader) -- Color
		local r = decode_types[6](reader)
		reader:StepBack()
		local g = decode_types[6](reader)
		reader:StepBack()
		local b = decode_types[6](reader)
		reader:StepBack()
		local a = decode_types[6](reader)
		return Color(r, g, b, a)
	end,
	[253] = function(reader) -- -math.huge
		reader:Next()
		return -math.huge
	end,
	[254] = function(reader) -- math.huge
		reader:Next()
		return math.huge
	end,
	[255] = function(reader, rtabs) -- Reference
		return rtabs[decode_types[6](reader) - 1]
	end,
}

Read = function(reader, rtabs)
	local t, pos = reader:Peek()
	if not t then
		error(string.format("Expected type ID at %s! (Got EOF)",
			pos))
	else
		local dt = decode_types[string.byte(t)]
		if not dt then
			error(string.format("Unknown type ID, %s!",
				string.byte(t)))
		else
			return dt(reader, rtabs or {0})
		end
	end
end

local reader_meta = {}
reader_meta.__index = reader_meta
reader_meta.Next = function(self)
	self.i = self.i+1
	self.c = string.sub(self.s, self.i, self.i)
	if self.c == "" then self.c = nil end
	self.p = string.sub(self.s, self.i+1, self.i+1)
	if self.p == "" then self.p = nil end
	return self.c, self.i
end

reader_meta.StepBack = function(self)
	self.i = self.i-1
	self.c = string.sub(self.s, self.i, self.i)
	if self.c == "" then self.c = nil end
	self.p = string.sub(self.s, self.i+1, self.i+1)
	if self.p == "" then self.p = nil end
	return self.c, self.i
end

reader_meta.Peek = function(self)
	return self.p, self.i+1
end

function glon.decode(data)
	if type(data) == "nil" then
		return nil
	elseif type(data) ~= "string" then
		error(string.format("Expected string to decode! (Got type %s)",
			type(data)
		))
	elseif data:len() == 0 then
		return nil
	end
	
	
	return Read(setmetatable({
		s = data,
		i = 0,
		c = string.sub(data, 0, 0),
		p = string.sub(data, 1, 1),
	}, reader_meta), {})
end

function glon.encode(data)
	return Write(data, {0}) -- to use the first key, to prevent it from interfereing with \1s. You can have up to 254 unique tables (including arrays)
end