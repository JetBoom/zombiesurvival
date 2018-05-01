EFFECT.LifeTime = 3

local TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER
local TEXT_ALIGN_BOTTOM = TEXT_ALIGN_BOTTOM
local draw = draw
local cam = cam

local Particles = {}

local col = Color(220, 0, 0)
local colprop = Color(220, 220, 0)
hook.Add("PostDrawTranslucentRenderables", "DrawDamage", function()
	if #Particles == 0 then return end

	local done = true
	local curtime = CurTime()

	local ang = EyeAngles()
	ang:RotateAroundAxis(ang:Up(), -90)
	ang:RotateAroundAxis(ang:Forward(), 90)

	if GAMEMODE.DamageNumberThroughWalls then
		cam.IgnoreZ(true)
	end

	for _, particle in pairs(Particles) do
		if particle and curtime < particle.DieTime then
			local c = particle.Type == 1 and colprop or col

			done = false

			c.a = math.Clamp(particle.DieTime - curtime, 0, 1) * 220

			cam.Start3D2D(particle:GetPos(), ang, 0.1 * GAMEMODE.DamageNumberScale)
				draw.SimpleText(particle.Amount, "ZS3D2DFont2", 0, 0, c, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			cam.End3D2D()
		end
	end

	if GAMEMODE.DamageNumberThroughWalls then
		cam.IgnoreZ(false)
	end

	if done then
		Particles = {}
	end
end)

local gravity = Vector(0, 0, -500)
function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local amount = data:GetMagnitude()
	local Type = data:GetScale()
	local velscal = GAMEMODE.DamageNumberSpeed

	local vel = VectorRand()
	vel.z = math.Rand(0.7, 0.98)
	vel:Normalize()

	local emitter = ParticleEmitter(pos)
	local particle = emitter:Add("sprites/glow04_noz", pos)
	particle:SetDieTime(2)
	particle:SetStartAlpha(0)
	particle:SetEndAlpha(0)
	particle:SetStartSize(0)
	particle:SetEndSize(0)
	particle:SetCollide(true)
	particle:SetBounce(0.7)
	particle:SetAirResistance(32)
	particle:SetGravity(gravity * (velscal ^ 2))
	particle:SetVelocity(math.Clamp(amount, 5, 50) * 4 * vel * velscal)

	particle.Amount = amount
	particle.DieTime = CurTime() + 2 * GAMEMODE.DamageNumberLifetime
	particle.Type = Type

	table.insert(Particles, particle)

	emitter:Finish() emitter = nil collectgarbage("step", 64)
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
