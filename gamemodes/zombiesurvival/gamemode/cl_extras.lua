CreateConVar("spraymon_nooverspraying", 0, FCVAR_REPLICATED, "anti over spraying: 0 | 1")

local sprays = {}

net.Receive("SMAddSpray", function()
	local ply = net.ReadEntity()
	if ply.SteamID then
		local normal = Vector(net.ReadFloat(), net.ReadFloat(), net.ReadFloat())
		local ang = normal:Angle()
		local vec = ang:Forward() * .001 + (ang:Right() + ang:Up()) * 32
		local pos = Vector(net.ReadFloat(), net.ReadFloat(), net.ReadFloat()) + ang:Up() * 4
		sprays[ply:SteamID()] = {name = ply:Name(), pos1 = pos - vec, pos2 = pos + vec, normal = normal, clears = 0, pos11 = pos - vec * 1.75, pos22 = pos + vec * 1.75}
	end
end)

local function clear()
	for k, v in pairs(sprays) do
		v.clears = v.clears + 1
		if v.clears >= 2 then
			sprays[k] = nil
		end
	end
end
net.Receive("SMClearDecals", clear)

local old = RunConsoleCommand
RunConsoleCommand = function(cmd, ...)
	if cmd == "r_cleardecals" then
		clear()
	end
	return old(cmd, ...)
end

local function isin(num, num1, num2)
	return (num >= num1 and num <= num2) or (num <= num1 and num >= num2)
end

surface.CreateFont("SMSpray", {font = "Trebuchet MS", size = 24, weight = 900})

local first = true

hook.Add("HUDPaint", "SMPrintSprays", function()
	local todraw = {}
	local trace = LocalPlayer():GetEyeTrace()
	for k, v in pairs(sprays) do
		if v.normal == trace.HitNormal and isin(trace.HitPos.x, v.pos1.x, v.pos2.x) and isin(trace.HitPos.y, v.pos1.y, v.pos2.y) and isin(trace.HitPos.z, v.pos1.z, v.pos2.z) then
			table.insert(todraw, k)
		end
	end
	if #todraw > 0 then
		if first then
		first = false
		end
		local y = ScrH() / 2 - #todraw * 12
		draw.SimpleTextOutlined("Sprayed by:", "SMSpray", 10, y, Color(255, 136, 0), 0, 1, 1, Color(0, 0, 0))
		for k, v in pairs(todraw) do
			y = y + 24
			draw.SimpleTextOutlined(sprays[v].name .. (input.IsKeyDown(KEY_LALT) and (": " .. v) or ""), "SMSpray", 10, y, Color(255, 136, 0), 0, 1, 1, Color(0, 0, 0))
		end
		if input.IsKeyDown(KEY_LALT) then
			SetClipboardText(todraw[1])
		end
	end
end)

hook.Add("PlayerBindPress", "SMNoSprayDelay", function(_, cmd, down)
	if down and string.find(cmd, "impulse 201") then
		if GetConVarNumber("spraymon_nooverspraying") > 0 then
			local trace = LocalPlayer():GetEyeTrace()
			for k, v in pairs(sprays) do
				if k ~= LocalPlayer():SteamID() and v.normal == trace.HitNormal and isin(trace.HitPos.x, v.pos11.x, v.pos22.x) and isin(trace.HitPos.y, v.pos11.y, v.pos22.y) and isin(trace.HitPos.z, v.pos11.z, v.pos22.z) then
					chat.AddText(Color(255, 255, 255), "You can't place your spray here.")
					return true
				end
			end
		end
		net.Start("SMSpray")
		net.SendToServer()
	end
end)