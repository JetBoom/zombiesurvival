AddCSLuaFile()

SWEP.Base = "weapon_zs_crow"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 0.15
SWEP.IsCrow = true
SWEP.DrawCrosshair = true
SWEP.Attacking = false
SWEP.PlayAttackSound = false
function SWEP:Initialize()
	self:HideViewAndWorldModel()
end

function SWEP:Holster()
	local owner = self.Owner
	if owner:IsValid() then
		owner:StopSound("Loop_Lanius")	
	end
end

sound.Add( {
	name = "Loop_Lanius",
	channel = CHAN_VOICE,
	volume = 1,
	level = 80,
	pitch = {35,40},
	sound = "npc/antlion_guard/growl_high.wav"
} )
sound.Add( {
	name = "Loop_Lanius_Flight",
	channel = CHAN_VOICE,
	volume = 1,
	level = 90,
	pitch = 80,
	sound = "npc/stalker/breathing3.wav"
} )
function SWEP:DoGas()
if CLIENT then return end
	local ent = ents.Create("projectile_poisonegg") 
	if ent:IsValid() then
		ent:SetPos(self.Owner:GetPos())
		ent:SetOwner(self.Owner)
		ent:Spawn()
		ent:SetVelocity(self.Owner:EyeAngles():Forward()* 50)
		ent:SetAngles(self.Owner:GetAimVector():Angle())
		ent:Spawn()
		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:SetVelocityInstantaneous(self.Owner:GetAimVector() * 1000)
			self.Owner:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.random(70, 80))
		end
	end  
end
function SWEP:SecondaryAttack()
	if CurTime() < self:GetNextSecondaryFire() then return end
	self:SetNextSecondaryFire(CurTime() + 5)
	if self.Owner:Team() ~= TEAM_UNDEAD then self.Owner:Kill() return end
	self.Owner:EmitSound("npc/combine_gunship/gunship_pain.wav",75,120)
	timer.Simple(0.7, 
	function() if self.Owner:IsValid() and self.Owner:Alive() then self:DoGas() end end)
end

function SWEP:PrimaryAttack()
	if self.Attacking == false then
		self.Attacking = true
	end
	if CurTime() < self:GetNextPrimaryFire() or not self.Owner:IsOnGround() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if self.Owner:Team() ~= TEAM_UNDEAD then self.Owner:Kill() return end
	self.Owner.EatAnim = CurTime() + 0.15
	self:SetPeckEndTime(CurTime() + 0.15)
	self.Owner:SetSpeed(30)
end

function SWEP:Think()
	local owner = self.Owner
	local fullrot = not owner:OnGround()
	if owner:GetAllowFullRotation() ~= fullrot then
		owner:SetAllowFullRotation(fullrot)
	end
	if not owner:KeyDown(IN_ATTACK) or not owner:IsOnGround() then
		self.Attacking = false
	end
	if owner:IsOnGround() or not owner:KeyDown(IN_JUMP) or not owner:KeyDown(IN_FORWARD) then
		if self.PlayFlap then
			owner:StopSound("Loop_Lanius_Flight")
			self.PlayFlap = nil
		end
	else
		if not self.PlayFlap then
			owner:EmitSound("Loop_Lanius_Flight")
			self.PlayFlap = true
		end
	end
	
	if self.Attacking == false then
		if self.PlayAttackSound then
			owner:StopSound("Loop_Lanius")
			self.PlayAttackSound = nil
		end
	else
		if not self.PlayAttackSound then
			owner:EmitSound("Loop_Lanius")
			self.PlayAttackSound = true
		end
	end
	
	local peckend = self:GetPeckEndTime()
	if peckend == 0 or CurTime() < peckend then return end
	self:SetPeckEndTime(0)

	local trace = owner:TraceLine(64, MASK_SOLID)
	local ent = NULL
	if trace.Entity then
		ent = trace.Entity
	end

	owner:ResetSpeed()

	if ent:IsValid() then
		if not ent:IsPlayer() then
			if ent.CanPackUp == true then 
				ent:TakeSpecialDamage(5, DMG_SLASH, owner, self)
			else
				local phys = ent:GetPhysicsObject()
				ent:TakeSpecialDamage(math.random(4,8), DMG_SLASH, owner, self)
			end
		else if ent:Team() == TEAM_HUMAN then
			ent:TakeSpecialDamage(2, DMG_SLASH, owner, self)
		end
		end
		self:EmitSound("physics/flesh/flesh_impact_bullet"..math.random(5)..".wav",75,80)
	end
end
