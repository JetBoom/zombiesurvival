INC_CLIENT()

ENT.NextEmit = 0

local materialp = {}
materialp["$refractamount"] = 0.02
materialp["$colortint"] = "[1.0 1.3 1.6]"
materialp["$SilhouetteColor"] = "[2.1 3.5 5.0]"
materialp["$BlurAmount"] = 0.04
materialp["$SilhouetteThickness"] = 0.05
materialp["$normalmap"] = "effects/combineshield/comshieldwall"
function ENT:OnInitialize()
	hook.Add("Move", self, self.Move)
	hook.Add("CreateMove", self, self.CreateMove)
	hook.Add("ShouldDrawLocalPlayer", self, self.ShouldDrawLocalPlayer)

	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 80))

	local owner = self:GetOwner()
	if owner:IsValid() then
		owner.ShadeShield = self
	end

	self:EmitSound("physics/glass/glass_impact_bullet4.wav", 70, 75)

	self.AmbientSound = CreateSound(self, "vehicles/fast_windloop1.wav")
	self.ShieldMaterial = CreateMaterial("shadeshield" .. self:EntIndex(), "Aftershock_dx9", materialp)
end

function ENT:Think()
	local curtime = CurTime()

	if self:GetStateEndTime() <= curtime and self:GetState() == 0 then
		self.AmbientSound:PlayEx(0.8, 100)

		if curtime >= self.NextEmit then
			self.NextEmit = curtime + 0.05

			local pos = self:WorldSpaceCenter()
			pos.z = pos.z + 8
			local owner = self:GetOwner()
			local emitter = ParticleEmitter(pos)
			local handpos = owner:GetAttachment(owner:LookupAttachment("anim_attachment_RH")).Pos
			emitter:SetNearClip(16, 24)

			local particle = emitter:Add("sprites/glow04_noz", handpos)
			local dir = (pos - handpos + (VectorRand() * 2)):GetNormalized()
			particle:SetVelocity(dir * math.Rand(120, 125))
			particle:SetDieTime(math.Rand(0.25, 0.27))
			particle:SetStartAlpha(math.Rand(230, 250))
			particle:SetEndAlpha(0)
			particle:SetStartSize(1)
			particle:SetEndSize(math.Rand(12, 14))
			particle:SetColor(0, 140, 255)

			emitter:Finish() emitter = nil collectgarbage("step", 64)
		end
	elseif self:GetState() == 1 then
		self.AmbientSound:Stop()
	end
end

local matWhite = Material("models/debug/debugwhite")
function ENT:DrawTranslucent()
	local curtime = CurTime()
	local diff = self:GetStateEndTime() - curtime
	local scalar = self:GetState() == 1 and diff or 0.5 - diff
	local scale = math.Clamp((scalar ^ 2)/0.25, 0, 1)

	local red = 1 - self:GetObjectHealth()/self:GetMaxObjectHealth()
	render.SetColorModulation(red, 0.7 * (1 - red), 1 - red)
	local blend = 0.3 + math.abs(math.cos(CurTime())) ^ 2 * 0.1
	render.SetBlend(blend * scale)
	render.SuppressEngineLighting(true)
	render.ModelMaterialOverride(matWhite)

	self:DrawModel()

	render.SetColorModulation(1, 1, 1)
	render.SuppressEngineLighting(false)
	render.ModelMaterialOverride()
	render.SetBlend(1)

	if render.SupportsPixelShaders_2_0() then
		self.ShieldMaterial:SetFloat("$refractamount", 0.01 * scale)
		self.ShieldMaterial:SetFloat("$BlurAmount", 0.01 * scale)
		render.UpdateRefractTexture()

		render.ModelMaterialOverride(self.ShieldMaterial)
		nodraw = true
		self:DrawModel()
		nodraw = false
		render.ModelMaterialOverride(0)
	end
end
