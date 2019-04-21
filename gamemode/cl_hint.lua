local Hints = {}

function GM:DrawPointWorldHints()
	for _, ent in pairs(ents.FindByClass("point_worldhint")) do if ent:IsValid() and ent.DrawHint then ent:DrawHint() end end
end

function GM:WorldHint(text, pos, ent, lifetime)
	lifetime = lifetime or 8

	if ent and ent:IsValid() then
		if pos then
			pos = ent:WorldToLocal(pos)
		else
			pos = ent:OBBCenter()
		end
	end

	local hint = {Hint = text, Pos = pos, Entity = ent, StartTime = CurTime(), EndTime = CurTime() + lifetime}
	table.insert(Hints, hint)

	return hint
end

net.Receive("zs_worldhint", function(length)
	GAMEMODE:WorldHint(net.ReadString(), net.ReadVector(), net.ReadEntity(), net.ReadFloat())
end)

local matRing = Material("effects/select_ring")
local colFG = Color(220, 220, 220, 255)
function DrawWorldHint(hint, pos, delta, scale)
	if not GAMEMODE.MessageBeaconShow then return end

	local eyepos = EyePos()

	delta = delta or 1

	colFG.a = math.min(220, delta * 220)

	local ang = (eyepos - pos):Angle()
	ang:RotateAroundAxis(ang:Right(), 270)
	ang:RotateAroundAxis(ang:Up(), 90)

	cam.IgnoreZ(true)
	cam.Start3D2D(pos, ang, (scale or 1) * math.max(250, eyepos:Distance(pos)) * delta * 0.0005)

	draw.SimpleText("!", "zshintfont", 0, 0, colFG, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText(hint, "ZS3D2DFont2Small", 0, 64, colFG, TEXT_ALIGN_CENTER)

	surface.SetMaterial(matRing)
	for i=1, 4 do
		colFG.a = colFG.a * (1 / i)
		surface.SetDrawColor(colFG)
		local pulse = math.max(0.25, math.abs(math.sin(RealTime() * 6))) * 30 * i
		surface.DrawTexturedRectRotated(0, 0, 128 + pulse, 128 + pulse, 0)
	end

	cam.End3D2D()
	cam.IgnoreZ(false)
end

function GM:DrawWorldHints()
	local drawhint = DrawWorldHint

	if #Hints > 0 then
		local curtime = CurTime()

		local done = true

		for _, hint in pairs(Hints) do
			local ent = hint.Entity
			if curtime < hint.EndTime and not (ent and not ent:IsValid()) then
				done = false

				drawhint(hint.Hint, ent and ent:LocalToWorld(hint.Pos) or hint.Pos, math.Clamp(hint.EndTime - curtime, 0, 1))
			end
		end

		if done then
			Hints = {}
		end
	end
end
