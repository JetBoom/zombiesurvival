if ( CLIENT ) then
    SWEP.PrintName            = "Gluon Gun"                                                    
    SWEP.Slot            = 3
    SWEP.SlotPos            = 1
    SWEP.ViewModelFOV        = 65
    SWEP.DrawAmmo = false
	killicon.Add( "weapon_gluongun", "pack/killicon", color_white )
end

SWEP.UseHands			   = true
SWEP.ViewModel = "models/weapons/c_egon.mdl"
SWEP.WorldModel = "models/weapons/w_egon.mdl"
SWEP.Primary.ClipSize        = -1
SWEP.Primary.Ammo            = "none"

SWEP.Secondary.ClipSize        = -1
SWEP.Secondary.DefaultClip    = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo            = "none"

if(SERVER)then
function alphathink(self)

    if self.TimeOut > CurTime() then
        self:SetColor(255,255,255,((self.TimeOut-CurTime())/2)*255)
    else
        self:Remove()
    end
    self:NextThink( CurTime() + 0.01 )
end



function SWEP:Initialize()
    if (SERVER) then
        self:SetWeaponHoldType( "physgun" )
    end
    self.NextShoot = CurTime()
    
end

function SWEP:PrimaryAttack()
    if not self.NextShoot then self.NextShoot = CurTime() end
    if CurTime()>=self.NextShoot and self.Owner:KeyDown(IN_ATTACK) then
	   ChargeSnd = Sound("weapons/gluon/special1.wav")
       self.SndLoop = CreateSound(self.Owner, ChargeSnd )
   	   self.SndLoop:Play()
        if BEAM_ON == 0 then     
            self.Owner:ViewPunch(Angle( 0.3, 0, 0.3 ))				
		    self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
            BEAM_ON = 1
        end
    end
end

function SWEP:Think()
    
    if self.Owner:KeyReleased(IN_ATTACK) then
        BEAM_ON = 0
		if self.SndLoop then
            self.SndLoop:Stop()
        end
	    self.Owner:EmitSound("weapons/gluon/special2.wav")
		self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
    end
    if self.Owner:KeyDown(IN_ATTACK) and BEAM_ON then
        local tr = self.Owner:GetEyeTrace()
        if tr.Hit then
            util.ScreenShake( tr.HitPos, 5, 5, .1, 628 )
            util.BlastDamage(self.Weapon, self.Owner, tr.HitPos, 10, 10 )
        end
    end
    self:SetNWInt("fier", BEAM_ON)
    self:NextThink( CurTime() + 1/30 )
	    
end

function SWEP:Deploy()
    BEAM_ON = 0
    self:SetNWInt("fier", 0)
    return true
end


function SWEP:OnRemove()
    self:SetNWInt("fier", 0)
	BEAM_ON = 0
		if self.SndLoop then
            self.SndLoop:Stop()
        end
end

function SWEP:ShouldDropOnDie()
    return false
end
end


if (CLIENT)then

function SWEP:Initialize()
    if self.on == nil then self.on = 0 end
    self:SetWeaponHoldType( "physgun" )
    Beamz = CreateMaterial( "xeno/beamz2", "UnlitGeneric", {
        [ "$basetexture" ]    = "sprites/physbeam3",
        [ "$additive" ]        = "1",
        [ "$vertexcolor" ]    = "1",
        [ "$vertexalpha" ]    = "1",
    } )
    Beamtwo = CreateMaterial( "xeno/beam22", "UnlitGeneric", {
        [ "$basetexture" ]    = "sprites/laserbeam2",
        [ "$additive" ]        = "1",
        [ "$vertexcolor" ]    = "1",
        [ "$vertexalpha" ]    = "1",
    } )
end

function SWEP:DrawHUD()
end

function SWEP:Think()
    self.on = self:GetNWInt("fier")
end


function SWEP:ViewModelDrawn()
    self:Drawspiral()
end

function SWEP:DrawWorldModel()
    self:Drawspiral()
    self.Weapon:DrawModel()
end


function SWEP:Drawspiral()
    Beamz = CreateMaterial( "xeno/beamz2", "UnlitGeneric", {
        [ "$basetexture" ]    = "sprites/physbeam3",
        [ "$additive" ]        = "1",
        [ "$vertexcolor" ]    = "1",
        [ "$vertexalpha" ]    = "1",
    } )
    Beamtwo = CreateMaterial( "xeno/beam22", "UnlitGeneric", {
        [ "$basetexture" ]    = "sprites/laserbeam2",
        [ "$additive" ]        = "1",
        [ "$vertexcolor" ]    = "1",
        [ "$vertexalpha" ]    = "1",
    } )

    
    if self.on == 1 then
    local tr = self.Weapon.Owner:GetEyeTraceNoCursor()

    if tr.Hit then


    self.StartPos = self:GetMuzzlePos( self, 1 )
    self.EndPos = tr.HitPos


    if not self.StartPos then return end
    if not self.EndPos then return end

    self.Weapon:SetRenderBoundsWS( self.StartPos, self.EndPos )

    local sinq = 3
    render.SetMaterial( Beamz )
    Rotator = Rotator or 0
    Rotator = Rotator - 10
    local Times = 50 --12
    render.StartBeam( 2 + Times );
    // add start
    self.Dir = (self.EndPos - self.StartPos):GetNormal()
    self.Inc = (self.EndPos - self.StartPos):Length() / Times
    local RAng = self.Dir:Angle()
    RAng:RotateAroundAxis(RAng:Right(),90)
    RAng:RotateAroundAxis(RAng:Up(),Rotator)
    render.AddBeam(
        self.StartPos,                // Start position
        20,                    // Width
        CurTime(),                // Texture coordinate
        Color( 255, 255, 255, 200 )        // Color --Color( 64, 255, 64, 200 )
    )

    for i = 0, Times do
        // get point
        RAng:RotateAroundAxis(RAng:Up(),360/(Times/sinq))
        local point = ( self.StartPos + self.Dir * ( i * self.Inc ) ) + RAng:Forward() * (math.sin((i/Times)*math.pi))*11
        render.AddBeam(
            point,
            20,
            CurTime() + ( 1 / Times ) * i,
            Color( 255, 255, 255, 200 )
        )
    end
    render.AddBeam(
        self.EndPos,
        20,
        CurTime() + 1,
        Color( 255, 255, 255, 200 )
    )
    render.EndBeam()
    
    --2 beam
    
    
    render.StartBeam( 2 + Times );
    // add start
    self.Dir = (self.EndPos - self.StartPos):GetNormal()
    self.Inc = (self.EndPos - self.StartPos):Length() / Times
    local RAng = self.Dir:Angle()
    RAng:RotateAroundAxis(RAng:Right(),90)
    RAng:RotateAroundAxis(RAng:Up(),Rotator*-1)
    render.AddBeam(
        self.StartPos,                
        20,                    
        CurTime(),                
        Color( 255, 255, 255, 200 )        
    )

    for i = 0, Times do
        // get point
        RAng:RotateAroundAxis(RAng:Up(),360/(Times/sinq))
        local point = ( self.StartPos + self.Dir * ( i * self.Inc ) ) + RAng:Forward() * (math.sin((i/Times)*math.pi))*5
        render.AddBeam(
            point,
            20,
            CurTime() + ( 1 / Times ) * i,
            Color( 255, 255, 255, 200 )
        )
    end
    render.AddBeam(
        self.EndPos,
        20,
        CurTime() + 1,
        Color( 255, 255, 255, 200 )
    )
    render.EndBeam()
    
    -- 3 beam
    
    
    render.StartBeam( 2 + Times );
    // add start
    self.Dir = (self.EndPos - self.StartPos):GetNormal()
    self.Inc = (self.EndPos - self.StartPos):Length() / Times
    local RAng = self.Dir:Angle()
    RAng:RotateAroundAxis(RAng:Right(),90)
    render.AddBeam(
        self.StartPos,                
        20,                    
        CurTime(),                
        Color( 255, 255, 255, 200 )        
    )

    for i = 0, Times do
        // get point
        local point = ( self.StartPos + self.Dir * ( i * self.Inc ) ) --+ VectorRand()*math.random(1,10)
        render.AddBeam(
            point,
            20,
            CurTime() + ( 1 / Times ) * i,
            Color( 255, 255, 255, 200 )
        )
    end
    render.AddBeam(
        self.EndPos,
        20,
        CurTime() + 1,
        Color( 255, 255, 255, 200 )
    )
    render.EndBeam()
    end
    end


end
function SWEP:GetMuzzlePos( weapon, attachment )

    if(!IsValid(weapon)) then return end

    local origin = weapon:GetPos()
    local angle = weapon:GetAngles()
    if weapon:IsWeapon() and weapon:IsCarriedByLocalPlayer() then
        if( IsValid( weapon:GetOwner() ) && GetViewEntity() == weapon:GetOwner() ) then
            local viewmodel = weapon:GetOwner():GetViewModel()
            if( IsValid( viewmodel ) ) then
                weapon = viewmodel
            end
        end
    end
    local attachment = weapon:GetAttachment( attachment or 1 )
    if( !attachment ) then
        return origin, angle
    end
    return attachment.Pos, attachment.Ang

end

end

function SWEP:Deploy()
    self.Weapon:EmitSound("weapons/physcannon/physcannon_charge.wav")
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetNextPrimaryFire( CurTime() + 2 )
      return true
end
