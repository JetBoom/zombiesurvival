

SWEP.Category			= "Rape SWEP"
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.IconLetter				= "C"

SWEP.Primary.Sound			= Sound( "vo/novaprospekt/al_holdon.wav" )
SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= 0
SWEP.Primary.NumShots		= -1
SWEP.Primary.Delay			= 3
SWEP.Primary.Distance		= 75

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay		= 3

SWEP.ViewModel = Model("models/weapons/v_hands.mdl")
--SWEP.WorldModel = ""

local InProgress = false
SWEP.RapeLength = 20
SWEP.PRIMARYPW = "RAPEDEMBITCHEZ1"
SWEP.SECONDARYPW = "RAPEDEMBITCHEZ2"

SWEP.SoundDelay = 1.5


local sounds2 = {
	"bot/where_are_you_hiding.wav",
}



/*---------------------------------------------------------
---------------------------------------------------------*/
function SWEP:Initialize()
	--self:SetWeaponHoldType( self.HoldType )
end

function SWEP:DrawWorldModel()
end


/*---------------------------------------------------------
	Reload does nothing
---------------------------------------------------------*/
function SWEP:Reload()
end


/*---------------------------------------------------------
   Think
---------------------------------------------------------*/
function SWEP:Think()
end

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	local tr = self.Owner:GetEyeTrace().Entity
	if not tr:IsValid() then return end
	if tr:IsNPC() or tr:IsPlayer() or ( tr:GetClass() == 'prop_ragdoll' ) then else return end
	
	--if ( !self:CanPrimaryAttack() ) then return end this is stupid base shit
	if tr:GetPos():Distance( self.Owner:GetPos() ) > self.Primary.Distance then return end
		
	if SERVER then
		self.Owner:EmitSound( self.Primary.Sound )
	end
	
	RunConsoleCommand( self.PRIMARYPW )
	
end

SWEP.NextSecondaryAttack = 0
/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	if ( self.NextSecondaryAttack > CurTime() ) then return end
	
	self.NextSecondaryAttack = CurTime() + self.Secondary.Delay
	
	if SERVER then
		self.Owner:EmitSound( sounds2[math.random(#sounds2)] )
	end
	
end



/*---------------------------------------------------------
	Checks the objects before any action is taken
	This is to make sure that the entities haven't been removed
---------------------------------------------------------
function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	
	draw.SimpleText( self.IconLetter, "CSSelectIcons", x + wide/2, y + tall*0.2, Color( 255, 210, 0, 255 ), TEXT_ALIGN_CENTER )
	
	// try to fool them into thinking they're playing a Tony Hawks game
	draw.SimpleText( self.IconLetter, "CSSelectIcons", x + wide/2 + math.Rand(-4, 4), y + tall*0.2+ math.Rand(-14, 14), Color( 255, 210, 0, math.Rand(10, 120) ), TEXT_ALIGN_CENTER )
	draw.SimpleText( self.IconLetter, "CSSelectIcons", x + wide/2 + math.Rand(-4, 4), y + tall*0.2+ math.Rand(-9, 9), Color( 255, 210, 0, math.Rand(10, 120) ), TEXT_ALIGN_CENTER )
	
end*/


/*---------------------------------------------------------
	DrawHUD
	
	Just a rough mock up showing how to draw your own crosshair.
	
---------------------------------------------------------*/
function SWEP:DrawHUD()



end
