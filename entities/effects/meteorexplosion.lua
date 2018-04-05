function EFFECT:Init(data)
	local pos = data:GetOrigin() + Vector(0, 0, 16)

	local tr = util.TraceLine({start = pos, endpos = pos + Vector(0, 0, -90)})
	util.Decal("Scorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)

	sound.Play("ambient/explosions/explode_"..math.random(1,5)..".wav", pos, 90, math.random(85, 110))

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(32, 48)
	self.Emitter = emitter
	for i=1, 359, 7 do
		local particle = emitter:Add("sprites/flamelet"..math.random(1, 4), pos)
		local sini = math.sin(i)
		local cosi = math.cos(i)
		particle:SetVelocity(Vector(512 * sini, 512 * cosi, 0))
		particle:SetDieTime(math.Rand(1.5, 2))
		particle:SetStartAlpha(220)
		particle:SetEndAlpha(0)
		particle:SetStartSize(72)
		particle:SetEndSize(2)
		particle:SetRoll(math.Rand(0, 359))
		particle:SetRollDelta(math.Rand(-2, 2))
		particle:SetAirResistance(45)
		particle:SetCollide(true)
		particle:SetBounce(0.1)
		for x=0, 2 do
			local particle = emitter:Add("particles/smokey", pos)
			particle:SetVelocity(Vector(x * 160 * sini * math.Rand(0.9, 1.1), x * 160 * cosi * math.Rand(0.9, 1.1), 0))
			particle:SetDieTime(math.Rand(1.25, 1.5) + x * 0.33333)
			particle:SetStartAlpha(220)
			particle:SetEndAlpha(0)
			particle:SetStartSize(x * 2)
			particle:SetEndSize(x * math.Rand(20, 32))
			particle:SetRoll(math.Rand(0, 359))
			particle:SetRollDelta(math.Rand(-1 * x, x))
			particle:SetAirResistance(70)
			particle:SetCollide(true)
			particle:SetBounce(0.1)
			particle:SetColor(200 - x * 20, 150 - x * 20, 150 - x * 20)
		end
	end

	for i=1, 359, 12 do
		if 4 < math.random(1, 10) then
			local particle = emitter:Add("effects/fire_embers"..math.random(1, 3), pos)
			particle:SetVelocity(Vector(180 * math.sin(i) * math.Rand(0.9, 1.1), 180 * math.cos(i) * math.Rand(0.9, 1.1), math.Rand(500, 720)))
			particle:SetDieTime(math.Rand(2.25, 3.5))
			particle:SetStartAlpha(220)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.Rand(40, 68))
			particle:SetEndSize(1)
			particle:SetRoll(math.Rand(0, 359))
			particle:SetRollDelta(math.Rand(-3, 3))
			particle:SetAirResistance(50)
			particle:SetCollide(true)
			particle:SetBounce(0.3)
			particle:SetGravity(Vector(0,0,-600))
		else
			local particle = emitter:Add("particles/smokey", pos)
			particle:SetVelocity(Vector(32 * math.sin(i) * math.Rand(0.9, 1.1), 32 * math.cos(i) * math.Rand(0.9, 1.1), math.Rand(75, 300)))
			particle:SetDieTime(math.Rand(2.25, 3.5))
			particle:SetStartAlpha(220)
			particle:SetEndAlpha(0)
			particle:SetStartSize(2)
			particle:SetEndSize(math.Rand(45, 88))
			particle:SetRoll(math.Rand(0, 359))
			particle:SetRollDelta(math.Rand(-3, 3))
			particle:SetAirResistance(40)
			particle:SetCollide(true)
			particle:SetBounce(0.1)
			particle:SetColor(100, 75, 75)
		end
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
