function EFFECT:Init(data)
    local pos = data:GetOrigin()
    pos = pos + Vector(0, 0, 48)
 
sound.Play("ambient/explosions/explode_"..math.random(1,5)..".wav", pos, 90, math.random(45, 50))
 
 
    local emitter = ParticleEmitter(pos)
    emitter:SetNearClip(40, 45)
        for i=1, math.random(12, 15) do
            local heading = VectorRand():GetNormalized()
            local particle = emitter:Add("particle/smokestack", pos + heading * 16)
            particle:SetVelocity(heading * 72)
            particle:SetDieTime(math.Rand(1.7, 2.0))
            particle:SetStartAlpha(220)
            particle:SetEndAlpha(0)
            particle:SetStartSize(204)
            particle:SetEndSize(4)
            particle:SetColor(0, 200, 255)
            particle:SetRoll(math.Rand(0, 360))
            particle:SetRollDelta(math.Rand(-1, 1))
			particle:SetLighting(false)
        end
        for i=1, math.random(5, 8) do
            local particle = emitter:Add("particle/smokestack", pos)
            particle:SetVelocity(VectorRand():GetNormalized() * math.Rand(48, 82))
            particle:SetDieTime(math.Rand(2.2, 3.6))
            particle:SetStartAlpha(120)
            particle:SetEndAlpha(0)
            particle:SetStartSize(106)
            particle:SetEndSize(800)
            particle:SetColor(100, 100, 120)
            particle:SetRoll(math.Rand(0, 360))
            particle:SetRollDelta(math.Rand(-1, 1))
            particle:SetAirResistance(10)
			particle:SetLighting(false)
        end
                    for i=1, math.random(5, 8) do
            local particle = emitter:Add("particle/smokestack", pos)
            particle:SetVelocity(VectorRand():GetNormalized() * math.Rand(48, 82))
            particle:SetDieTime(math.Rand(2.2, 3.6))
            particle:SetStartAlpha(220)
            particle:SetEndAlpha(0)
            particle:SetStartSize(106)
            particle:SetEndSize(100)
            particle:SetColor(0, 0, 250)
            particle:SetRoll(math.Rand(0, 360))
            particle:SetRollDelta(math.Rand(-1, 1))
            particle:SetAirResistance(10)
			particle:SetLighting(false)
        end
                for i=1, math.random(5, 8) do
            local particle = emitter:Add("particle/smokestack", pos)
            particle:SetVelocity(VectorRand():GetNormalized() * math.Rand(48, 82))
            particle:SetDieTime(math.Rand(2.2, 3.6))
            particle:SetStartAlpha(220)
            particle:SetEndAlpha(0)
            particle:SetStartSize(80)
            particle:SetEndSize(100)
            particle:SetColor(50, 30, 150)
            particle:SetRoll(math.Rand(0, 360))
            particle:SetRollDelta(math.Rand(-1, 1))
            particle:SetAirResistance(10)
			particle:SetLighting(false)
        end
        for i=1, math.random(17, 21) do
            local particle = emitter:Add("effects/fire_cloud1", pos + VectorRand() * 32)
            local dir = VectorRand():GetNormalized()
            particle:SetVelocity(dir * math.Rand(500, 600))
            particle:SetDieTime(math.Rand(1.0, 1.25))
            particle:SetStartAlpha(220)
            particle:SetEndAlpha(0)
            particle:SetStartSize(600)
            particle:SetEndSize(300)
			particle:SetColor(30, 30, 200)
            particle:SetRoll(math.Rand(0, 360))
            particle:SetRollDelta(math.Rand(-3, 3))
            particle:SetAirResistance(60)
            particle:SetGravity(dir * math.Rand(-600, -500))
			particle:SetLighting(false)
        end
                for i=1, math.random(17, 21) do
            local particle = emitter:Add("effects/fire_cloud1", pos + VectorRand() * 32)
            local dir = VectorRand():GetNormalized()
            particle:SetVelocity(dir * math.Rand(500, 600))
            particle:SetDieTime(math.Rand(1.0, 1.25))
            particle:SetStartAlpha(220)
            particle:SetEndAlpha(0)
            particle:SetStartSize(600)
            particle:SetEndSize(60)
            particle:SetColor(300, 200, 0)
            particle:SetRoll(math.Rand(0, 360))
            particle:SetRollDelta(math.Rand(-3, 3))
            particle:SetAirResistance(60)
            particle:SetGravity(dir * math.Rand(-600, -500))
			particle:SetLighting(false)
        end
                for i=1, math.random(17, 21) do
            local particle = emitter:Add("effects/fire_cloud1", pos + VectorRand() * 32)
            local dir = VectorRand():GetNormalized()
            particle:SetVelocity(dir * math.Rand(500, 600))
            particle:SetDieTime(math.Rand(1.0, 1.25))
            particle:SetStartAlpha(220)
            particle:SetEndAlpha(0)
            particle:SetStartSize(600)
            particle:SetEndSize(30)
            particle:SetColor(200, 100, 100)
            particle:SetRoll(math.Rand(0, 360))
            particle:SetRollDelta(math.Rand(-3, 3))
            particle:SetAirResistance(60)
            particle:SetGravity(dir * math.Rand(-600, -500))
			particle:SetLighting(false)
        end
        for i=1, 2 do
            local particle = emitter:Add("effects/fire_cloud1", pos)
            particle:SetDieTime(math.Rand(0.3, 0.35))
            particle:SetStartAlpha(255)
            particle:SetEndAlpha(0)
            particle:SetStartSize(32000)
            particle:SetEndSize(300)
            particle:SetColor(210, 30, 255)
            particle:SetRoll(math.Rand(0, 360))
            particle:SetRollDelta(math.Rand(-300, 300))
			particle:SetLighting(false)
        end
    emitter:Finish()
end
 
function EFFECT:Think()
    return false
end
 
function EFFECT:Render()
end