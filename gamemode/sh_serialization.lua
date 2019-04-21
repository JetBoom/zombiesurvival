local sandbox_env = {Vector = Vector, Angle = Angle}

function Deserialize(sIn)
	local out = {}

	if #sIn == 0 or string.sub(sIn, -1) ~= "}" then return out end

	if string.sub(sIn, 1, 4) ~= "SRL=" then sIn = "SRL="..sIn end

	if string.sub(sIn, 5, 5) ~= "{" then return out end

	sIn = sIn.." return SRL"
	local func = CompileString(sIn, "deserialize", false)
	if type(func) == "string" then
		print("Deserialization error: "..func)
	else
		setfenv(func, sandbox_env)
		out = func() or out
	end

	return out
end

local allowedtypes = {}
allowedtypes["string"] = true
allowedtypes["number"] = true
allowedtypes["table"] = true
allowedtypes["Vector"] = true
allowedtypes["Angle"] = true
allowedtypes["boolean"] = true
local function MakeTable(tab, done)
	local str = ""
	local done = done or {}

	local sequential = table.IsSequential(tab)

	for key, value in pairs(tab) do
		local keytype = type(key)
		local valuetype = type(value)

		if allowedtypes[keytype] and allowedtypes[valuetype] then
			if sequential then
				key = ""
			else
				if keytype == "number" or keytype == "boolean" then 
					key ="["..tostring(key).."]="
				else
					key = "["..string.format("%q", tostring(key)).."]="
				end
			end

			if valuetype == "table" and not done[value] then
				done[value] = true
				if type(value._serialize) == "function" then
					str = str..key..value:_serialize()..","
				else
					str = str..key.."{"..MakeTable(value, done).."},"
				end
			else
				if valuetype == "string" then 
					value = string.format("%q", value)
				elseif valuetype == "Vector" then
					value = "Vector("..value.x..","..value.y..","..value.z..")"
				elseif valuetype == "Angle" then
					value = "Angle("..value.pitch..","..value.yaw..","..value.roll..")"
				else
					value = tostring(value)
				end

				str = str .. key .. value .. ","
			end
		end
	end

	if string.sub(str, -1) == "," then
		return string.sub(str, 1, #str - 1)
	else
		return str
	end
end

function Serialize(tIn, bRaw)
	if #tIn == 0 then
		local empty = true
		for k in pairs(tIn) do
			empty = false
			break
		end
		if empty then
			return ""
		end
	end

	if bRaw then
		return "{"..MakeTable(tIn).."}"
	end

	return "SRL={"..MakeTable(tIn).."}"
end