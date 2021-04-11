CLASS.Base = "ghoul"

CLASS.Wave = 2 / 6

CLASS.Name = "Elder Ghoul"
CLASS.TranslationName = "class_elderghoul"
CLASS.Description = "description_elderghoul"
CLASS.Help = "controls_elderghoul"

CLASS.BetterVersion = "Noxious Ghoul"

CLASS.Health = 190
CLASS.Speed = 165

CLASS.Points = CLASS.Health/GM.HumanoidZombiePointRatio

CLASS.SWEP = "weapon_zs_elderghoul"

local function CreateFlesh(pl, damage, damagepos, damagedir)
	damage = math.min(damage, 100)

	pl:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 74, 125 - damage * 0.50)

	if SERVER then
		damagepos = pl:LocalToWorld(damagepos)

		for i=1, math.max(1, math.floor(damage / 15)) do
			local ent = ents.Create("projectile_poisonflesh")
			if ent:IsValid() then
				local heading = (damagedir + VectorRand() * 0.3):GetNormalized()
				ent:SetPos(damagepos + heading)
				ent:SetOwner(pl)
				ent:Spawn()

				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:Wake()
					phys:SetVelocityInstantaneous(math.min(300, 50 + damage ^ math.Rand(1.15, 1.25)) * heading)
				end
			end
		end
	end
end

function CLASS:ProcessDamage(pl, dmginfo)
	local attacker, damage = dmginfo:GetAttacker(), math.min(dmginfo:GetDamage(), pl:Health())
	if attacker ~= pl and damage >= 5 and CurTime() >= (pl.m_NextPukeEmit or 0) then
		pl.m_NextPukeEmit = CurTime() + 0.3

		local pos = pl:WorldToLocal(dmginfo:GetDamagePosition())
		local norm = dmginfo:GetDamageForce():GetNormalized() * -1
		timer.Simple(0, function()
			if pl:IsValid() then
				CreateFlesh(pl, damage, pos, norm)
			end
		end)
	end
end

if not CLIENT then return end

CLASS.Icon = "zombiesurvival/killicons/ghoul"
CLASS.IconColor = Color(170, 220, 0)

local render_SetMaterial = render.SetMaterial
local render_DrawSprite = render.DrawSprite
local angle_zero = angle_zero
local LocalToWorld = LocalToWorld

local colGlow = Color(200, 160, 50)
local matSkin = Material("Models/humans/corpse/corpse1.vtf")
local matGlow = Material("sprites/glow04_noz")
local vecEyeLeft = Vector(4, -4.6, -1)
local vecEyeRight = Vector(4, -4.6, 1)

function CLASS:PrePlayerDraw(pl)
	render.ModelMaterialOverride(matSkin)
	render.SetColorModulation(0.66, 0.86, 0)
end

function CLASS:PostPlayerDraw(pl)
	render.ModelMaterialOverride()
	render.SetColorModulation(1, 1, 1)

	if pl == MySelf and not pl:ShouldDrawLocalPlayer() or pl.SpawnProtection then return end

	local pos, ang = pl:GetBonePositionMatrixed(6)
	if pos then
		render_SetMaterial(matGlow)
		render_DrawSprite(LocalToWorld(vecEyeLeft, angle_zero, pos, ang), 4, 4, colGlow)
		render_DrawSprite(LocalToWorld(vecEyeRight, angle_zero, pos, ang), 4, 4, colGlow)
	end
end
