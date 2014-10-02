SWEP.ZombieOnly = true
SWEP.IsMelee = true

SWEP.ViewModel = "models/weapons/v_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"

function SWEP:Initialize()
	self:HideViewAndWorldModel()
end

function SWEP:Think()
	if self:GetAttackDown() and not self.Owner:KeyDown(IN_ATTACK) then
		self:SetAttackDown(false)
	end
end

function SWEP:PrimaryAttack()
	if not self:GetAttackDown() then
		self:SetAttackDown(true)
		self:EmitSound("npc/scanner/scanner_nearmiss"..math.random(2)..".wav")
	end
end

function SWEP:SecondaryAttack()
	if CurTime() >= self:GetNextPrimaryAttack() then
		self:SetNextPrimaryAttack(CurTime() + 8)
		self:EmitSound("npc/scanner/scanner_talk1.wav")
	end
end

function SWEP:Reload()
	if CurTime() >= self:GetNextPrimaryAttack() then
		self:SetNextPrimaryAttack(CurTime() + 5)
		self:EmitSound("npc/scanner/scanner_talk2.wav")
	end
end

function SWEP:SetAttackDown(attackdown)
	self:SetDTBool(0, attackdown)
end

function SWEP:GetAttackDown()
	return self:GetDTBool(0)
end

util.PrecacheSound("npc/scanner/scanner_nearmiss1.wav")
util.PrecacheSound("npc/scanner/scanner_nearmiss2.wav")
util.PrecacheSound("npc/scanner/scanner_talk1.wav")
util.PrecacheSound("npc/scanner/scanner_talk2.wav")
