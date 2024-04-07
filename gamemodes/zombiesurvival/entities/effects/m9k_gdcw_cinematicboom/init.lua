
					//Sound,Impact

					// 1        2       3      4      5
					//Dirt, Concrete, Metal, Glass, Flesh

					// 1     2     3      4      5      6      7      8         9
					//Dust, Dirt, Sand, Metal, Smoke, Wood,  Glass, Blood, YellowBlood
local mats={				
	[MAT_ALIENFLESH]		={5,9},
	[MAT_ANTLION]			={5,9},
	[MAT_BLOODYFLESH]		={5,8},
	[45]				={5,8},	// Metrocop heads are a source glitch, they have no enumeration
	[MAT_CLIP]			={3,5},
	[MAT_COMPUTER]			={4,5},
	[MAT_FLESH]			={5,8},
	[MAT_GRATE]			={3,4},
	[MAT_METAL]			={3,4},
	[MAT_PLASTIC]			={2,5},
	[MAT_SLOSH]			={5,5},
	[MAT_VENT]			={3,4},
	[MAT_FOLIAGE]			={1,5},
	[MAT_TILE]			={2,5},
	[MAT_CONCRETE]			={2,1},
	[MAT_DIRT]			={1,2},
	[MAT_SAND]			={1,3},
	[MAT_WOOD]			={2,6},
	[MAT_GLASS]			={4,7},
}

local sounds={
	[1]={"Bullet.Dirt",},
	[2]={"Bullet.Concrete",},
	[3]={"Bullet.Metal",},
	[4]={"Bullet.Glass",},
	[5]={"Bullet.Flesh",},
}

function EFFECT:Init(data)
self.Entity 		= data:GetEntity()		// Entity determines what is creating the dynamic light			//
self.Pos 		= data:GetOrigin()		// Origin determines the global position of the effect			//
self.Scale 		= data:GetScale()		// Scale determines how large the effect is				//
self.Radius 		= data:GetRadius() or 1		// Radius determines what type of effect to create, default is Concrete	//
self.DirVec 		= data:GetNormal()		// Normal determines the direction of impact for the effect		//
self.PenVec 		= data:GetStart()		// PenVec determines the direction of the round for penetrations	//
self.Particles 		= data:GetMagnitude()		// Particles determines how many puffs to make, primarily for "trails"	//
self.Angle 		= self.DirVec:Angle()		// Angle is the angle of impact from Normal				//
self.DebrizzlemyNizzle 	= 10+data:GetScale()		// Debrizzle my Nizzle is how many "trails" to make			//
self.Size 		= 5*self.Scale			// Size is exclusively for the explosion "trails" size			//
self.Emitter 		= ParticleEmitter( self.Pos )	// Emitter must be there so you don't get an error			//
	

			if self.Scale<1.2 then
			sound.Play( "ambient/explosions/explode_" .. math.random(1, 4) .. ".wav", self.Pos, 100, 100 )
			else
			sound.Play( "Explosion.Boom", self.Pos)
			sound.Play( "ambient/explosions/explode_" .. math.random(1, 4) .. ".wav", self.Pos, 100, 100 )
			end


	self.Mat=math.ceil(self.Radius)


 
	if     mats[self.Mat][2]==1 then	self:Dust()	
	elseif mats[self.Mat][2]==2 then	self:Dirt()
	elseif mats[self.Mat][2]==3 then	self:Sand()
	elseif mats[self.Mat][2]==4 then	self:Metal()
	elseif mats[self.Mat][2]==5 then	self:Smoke()
	elseif mats[self.Mat][2]==6 then	self:Wood()
	elseif mats[self.Mat][2]==7 then	self:Glass()
	elseif mats[self.Mat][2]==8 then	self:Blood()
	elseif mats[self.Mat][2]==9 then	self:YellowBlood()
	else 					self:Smoke()
	end

end
 
 function EFFECT:Dust()

		for i=1,5 do 
		local Flash = self.Emitter:Add( "effects/muzzleflash"..math.random(1,4), self.Pos )
		if (Flash) then
		Flash:SetVelocity( self.DirVec*100 )
		Flash:SetAirResistance( 200 )
		Flash:SetDieTime( 0.15 )
		Flash:SetStartAlpha( 255 )
		Flash:SetEndAlpha( 0 )
		Flash:SetStartSize( self.Scale*300 )
		Flash:SetEndSize( 0 )
		Flash:SetRoll( math.Rand(180,480) )
		Flash:SetRollDelta( math.Rand(-1,1) )
		Flash:SetColor(255,255,255)	
		end
		end

		for i=1, 20*self.Scale do
		local Dust = self.Emitter:Add( "particle/particle_composite", self.Pos )	
		if (Dust) then
		Dust:SetVelocity( self.DirVec * math.random( 100,400)*self.Scale + ((VectorRand():GetNormalized()*300)*self.Scale) )
		Dust:SetDieTime( math.Rand( 2 , 3 ) )
		Dust:SetStartAlpha( 230 )
		Dust:SetEndAlpha( 0 )
		Dust:SetStartSize( (50*self.Scale) )
		Dust:SetEndSize( (100*self.Scale) )
		Dust:SetRoll( math.Rand(150, 360) )
		Dust:SetRollDelta( math.Rand(-1, 1) )			
		Dust:SetAirResistance( 150 ) 			 
		Dust:SetGravity( Vector( 0, 0, math.Rand(-100, -400) ) ) 			
		Dust:SetColor( 80,80,80 )
		end
		end

		for i=1, 15*self.Scale do
		local Dust = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Pos )
		if (Dust) then
		Dust:SetVelocity( self.DirVec * math.random( 100,400)*self.Scale + ((VectorRand():GetNormalized()*400)*self.Scale) )
		Dust:SetDieTime( math.Rand( 1 , 5 )*self.Scale )
		Dust:SetStartAlpha( 50 )
		Dust:SetEndAlpha( 0 )
		Dust:SetStartSize( (80*self.Scale) )
		Dust:SetEndSize( (100*self.Scale) )
		Dust:SetRoll( math.Rand(150, 360) )
		Dust:SetRollDelta( math.Rand(-1, 1) )			
		Dust:SetAirResistance( 250 ) 			 
		Dust:SetGravity( Vector( math.Rand( -200 , 200 ), math.Rand( -200 , 200 ), math.Rand( 10 , 100 ) ) )		
		Dust:SetColor( 90,85,75 )
		end
		end

		for i=1, 25*self.Scale do
		local Debris = self.Emitter:Add( "effects/fleck_cement"..math.random(1,2), self.Pos )
		if (Debris) then
		Debris:SetVelocity ( self.DirVec * math.random(0,700)*self.Scale + VectorRand():GetNormalized() * math.random(0,700)*self.Scale )
		Debris:SetDieTime( math.random( 1, 2) * self.Scale )
		Debris:SetStartAlpha( 255 )
		Debris:SetEndAlpha( 0 )
		Debris:SetStartSize( math.random(5,10)*self.Scale)
		Debris:SetRoll( math.Rand(0, 360) )
		Debris:SetRollDelta( math.Rand(-5, 5) )			
		Debris:SetAirResistance( 40 ) 			 			
		Debris:SetColor( 60,60,60 )
		Debris:SetGravity( Vector( 0, 0, -600) ) 	
		end
		end

		local Angle = self.DirVec:Angle()
		for i = 1, self.DebrizzlemyNizzle do 					/// This part makes the trailers ///
		Angle:RotateAroundAxis(Angle:Forward(), (360/self.DebrizzlemyNizzle))
		local DustRing = Angle:Up()
		local RanVec = self.DirVec*math.Rand(1, 5) + (DustRing*math.Rand(2, 5))

			for k = 3, self.Particles do
			local Rcolor = math.random(-20,20)
			local particle1 = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Pos )				
			particle1:SetVelocity((VectorRand():GetNormalized()*math.Rand(1, 2) * self.Size) + (RanVec*self.Size*k*3.5))	
			particle1:SetDieTime( math.Rand( 0.5, 4 )*self.Scale )	
			particle1:SetStartAlpha( math.Rand( 90, 100 ) )			
			particle1:SetEndAlpha(0)	
			particle1:SetGravity((VectorRand():GetNormalized()*math.Rand(5, 10)* self.Size) + Vector(0,0,-50))
			particle1:SetAirResistance( 200+self.Scale*20 ) 		
			particle1:SetStartSize( (5*self.Size)-((k/self.Particles)*self.Size*3) )	
			particle1:SetEndSize( (20*self.Size)-((k/self.Particles)*self.Size) )
			particle1:SetRoll( math.random( -500, 500 )/100 )	
			particle1:SetRollDelta( math.random( -0.5, 0.5 ) )	
			particle1:SetColor( 90+Rcolor,87+Rcolor,80+Rcolor )
			end
		end
 end
 
function EFFECT:Dirt()

		for i=1,5 do 
		local Flash = self.Emitter:Add( "effects/muzzleflash"..math.random(1,4), self.Pos )
		if (Flash) then
		Flash:SetVelocity( self.DirVec*100 )
		Flash:SetAirResistance( 200 )
		Flash:SetDieTime( 0.15 )
		Flash:SetStartAlpha( 255 )
		Flash:SetEndAlpha( 0 )
		Flash:SetStartSize( self.Scale*300 )
		Flash:SetEndSize( 0 )
		Flash:SetRoll( math.Rand(180,480) )
		Flash:SetRollDelta( math.Rand(-1,1) )
		Flash:SetColor(255,255,255)	
		end
		end

		for i=1, 20*self.Scale do
		local Dust = self.Emitter:Add( "particle/particle_composite", self.Pos )	
		if (Dust) then
		Dust:SetVelocity( self.DirVec * math.random( 100,400)*self.Scale + ((VectorRand():GetNormalized()*300)*self.Scale) )
		Dust:SetDieTime( math.Rand( 2 , 3 ) )
		Dust:SetStartAlpha( 230 )
		Dust:SetEndAlpha( 0 )
		Dust:SetStartSize( (50*self.Scale) )
		Dust:SetEndSize( (100*self.Scale) )
		Dust:SetRoll( math.Rand(150, 360) )
		Dust:SetRollDelta( math.Rand(-1, 1) )			
		Dust:SetAirResistance( 150 ) 			 
		Dust:SetGravity( Vector( 0, 0, math.Rand(-100, -400) ) ) 			
		Dust:SetColor( 90,83,68 )
		end
		end

		for i=1, 15*self.Scale do
		local Dust = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Pos )
		if (Dust) then
		Dust:SetVelocity( self.DirVec * math.random( 100,400)*self.Scale + ((VectorRand():GetNormalized()*400)*self.Scale) )
		Dust:SetDieTime( math.Rand( 1 , 5 )*self.Scale )
		Dust:SetStartAlpha( 50 )
		Dust:SetEndAlpha( 0 )
		Dust:SetStartSize( (80*self.Scale) )
		Dust:SetEndSize( (100*self.Scale) )
		Dust:SetRoll( math.Rand(150, 360) )
		Dust:SetRollDelta( math.Rand(-1, 1) )			
		Dust:SetAirResistance( 250 ) 			 
		Dust:SetGravity( Vector( math.Rand( -200 , 200 ), math.Rand( -200 , 200 ), math.Rand( 10 , 100 ) ) )		
		Dust:SetColor( 90,83,68 )
		end
		end

		for i=1, 25*self.Scale do
		local Debris = self.Emitter:Add( "effects/fleck_cement"..math.random(1,2), self.Pos )
		if (Debris) then
		Debris:SetVelocity ( self.DirVec * math.random(0,700)*self.Scale + VectorRand():GetNormalized() * math.random(0,700)*self.Scale )
		Debris:SetDieTime( math.random( 1, 2) * self.Scale )
		Debris:SetStartAlpha( 255 )
		Debris:SetEndAlpha( 0 )
		Debris:SetStartSize( math.random(5,10)*self.Scale)
		Debris:SetRoll( math.Rand(0, 360) )
		Debris:SetRollDelta( math.Rand(-5, 5) )			
		Debris:SetAirResistance( 40 ) 			 			
		Debris:SetColor( 50,53,45 )
		Debris:SetGravity( Vector( 0, 0, -600) ) 	
		end
		end

		local Angle = self.DirVec:Angle()
		for i = 1, self.DebrizzlemyNizzle do 					/// This part makes the trailers ///
		Angle:RotateAroundAxis(Angle:Forward(), (360/self.DebrizzlemyNizzle))
		local DustRing = Angle:Up()
		local RanVec = self.DirVec*math.Rand(2, 6) + (DustRing*math.Rand(1, 4))	

			for k = 3, self.Particles do
			local Rcolor = math.random(-20,20)
			local particle1 = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Pos )				
			particle1:SetVelocity((VectorRand():GetNormalized()*math.Rand(1, 2) * self.Size) + (RanVec*self.Size*k*3.5))	
			particle1:SetDieTime( math.Rand( 0.5, 4 )*self.Scale )	
			particle1:SetStartAlpha( math.Rand( 90, 100 ) )			
			particle1:SetEndAlpha(0)	
			particle1:SetGravity((VectorRand():GetNormalized()*math.Rand(5, 10)* self.Size) + Vector(0,0,-50))
			particle1:SetAirResistance( 200+self.Scale*20 ) 		
			particle1:SetStartSize( (5*self.Size)-((k/self.Particles)*self.Size*3) )	
			particle1:SetEndSize( (20*self.Size)-((k/self.Particles)*self.Size) )
			particle1:SetRoll( math.random( -500, 500 )/100 )	
			particle1:SetRollDelta( math.random( -0.5, 0.5 ) )	
			particle1:SetColor( 90+Rcolor,83+Rcolor,68+Rcolor )
			end
		end
 end

 function EFFECT:Sand()

		for i=0, 45*self.Scale do		// This is the main plume
		local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Pos )
		if (Smoke) then
		Smoke:SetVelocity( self.DirVec * math.random( 50,1000*self.Scale) + VectorRand():GetNormalized()*300*self.Scale )
		Smoke:SetDieTime( math.Rand( 1 , 5 )*self.Scale )
		Smoke:SetStartAlpha( math.Rand( 100, 120 ) )
		Smoke:SetEndAlpha( 0 )
		Smoke:SetStartSize( 50*self.Scale )
		Smoke:SetEndSize( 120*self.Scale )
		Smoke:SetRoll( math.Rand(150, 360) )
		Smoke:SetRollDelta( math.Rand(-1, 1) )			
		Smoke:SetAirResistance( 200 ) 			 
		Smoke:SetGravity( Vector( 0, 0, math.Rand(-100, -400) ) ) 			
		Smoke:SetColor( 90,83,68 )
		end
		end

		for i=0, 20*self.Scale do		// This is the dirt kickup
		local Dust = self.Emitter:Add( "particle/particle_composite", self.Pos )
		if (Dust) then
		Dust:SetVelocity( self.DirVec * math.random( 100,700)*self.Scale + VectorRand():GetNormalized()*250*self.Scale )
		Dust:SetDieTime( math.Rand( 0.5 , 1,5 ) )
		Dust:SetStartAlpha( 200 )
		Dust:SetEndAlpha( 0 )
		Dust:SetStartSize( 60*self.Scale )
		Dust:SetEndSize( 90*self.Scale )
		Dust:SetRoll( math.Rand(150, 360) )
		Dust:SetRollDelta( math.Rand(-1, 1) )			
		Dust:SetAirResistance( 200 ) 			 
		Dust:SetGravity( Vector( 0, 0, math.Rand(-100, -400) ) ) 			
		Dust:SetColor( 90,83,68 )
		end
		end

		for i=0, 25*self.Scale do		// Chunkage
		local Debris = self.Emitter:Add( "effects/fleck_cement"..math.random(1,2), self.Pos )
		if (Debris) then
		Debris:SetVelocity ( self.DirVec * math.random(50,900)*self.Scale + VectorRand():GetNormalized() * math.random(0,700)*self.Scale )
		Debris:SetDieTime( math.random( 1, 2) * self.Scale )
		Debris:SetStartAlpha( 255 )
		Debris:SetEndAlpha( 0 )
		Debris:SetStartSize( math.random(5,8)*self.Scale )
		Debris:SetRoll( math.Rand(0, 360) )
		Debris:SetRollDelta( math.Rand(-5, 5) )			
		Debris:SetAirResistance( 40 ) 			 			
		Debris:SetColor( 53,50,45 )
		Debris:SetGravity( Vector( 0, 0, -600) ) 		
		end
		end

		for i=0, 25*self.Scale do		// Shrapnel
		local Shrapnel = self.Emitter:Add( "effects/fleck_cement"..math.random(1,2), self.Pos+self.DirVec )
		if (Shrapnel) then
		Shrapnel:SetVelocity ( (self.DirVec*700*self.Scale) + (VectorRand():GetNormalized() * 1000*self.Scale) )
		Shrapnel:SetDieTime( math.random( 0.3, 0.5) * self.Scale )
		Shrapnel:SetStartAlpha( 255 )
		Shrapnel:SetEndAlpha( 0 )
		Shrapnel:SetStartSize( math.random(4,7)*self.Scale )
		Shrapnel:SetRoll( math.Rand(0, 360) )
		Shrapnel:SetRollDelta( math.Rand(-5, 5) )			
		Shrapnel:SetAirResistance( 10 ) 			 			
		Shrapnel:SetColor( 53,50,45 )
		Shrapnel:SetGravity( Vector( 0, 0, -600) ) 
		Shrapnel:SetCollide( true )
		Shrapnel:SetBounce( 0.8 )			
		end
		end

		for i=1,5 do 				// Blast flash
		local Flash = self.Emitter:Add( "effects/muzzleflash"..math.random(1,4), self.Pos )
		if (Flash) then
		Flash:SetVelocity( self.DirVec*100 )
		Flash:SetAirResistance( 200 )
		Flash:SetDieTime( 0.10 )
		Flash:SetStartAlpha( 255 )
		Flash:SetEndAlpha( 0 )
		Flash:SetStartSize( self.Scale*200 )
		Flash:SetEndSize( 0 )
		Flash:SetRoll( math.Rand(180,480) )
		Flash:SetRollDelta( math.Rand(-1,1) )
		Flash:SetColor(255,255,255)	
		end
		end

		for i=0, 10*self.Scale do		
		local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Pos )
		if (Smoke) then
		Smoke:SetVelocity( self.DirVec * math.random( 30,120*self.Scale) + VectorRand():GetNormalized() * math.random( 50,100*self.Scale) )
		Smoke:SetDieTime( math.Rand( 0.5 , 1 )*self.Scale  )
		Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
		Smoke:SetEndAlpha( 0 )
		Smoke:SetStartSize( 10*self.Scale )
		Smoke:SetEndSize( 30*self.Scale )
		Smoke:SetRoll( math.Rand(150, 360) )
		Smoke:SetRollDelta( math.Rand(-2, 2) )			
		Smoke:SetAirResistance( 100 ) 			 
		Smoke:SetGravity( Vector( math.random(-20,20)*self.Scale, math.random(-20,20)*self.Scale, 250 ) ) 			
		Smoke:SetColor( 90,83,68 )
		end
		end
		
	
		for i=0, 5*self.Scale do
		local Whisp = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Pos )
		if (Whisp) then
		Whisp:SetVelocity(VectorRand():GetNormalized() * math.random( 300,600*self.Scale) )
		Whisp:SetDieTime( math.Rand( 4 , 10 )*self.Scale/2  )
		Whisp:SetStartAlpha( math.Rand( 30, 40 ) )
		Whisp:SetEndAlpha( 0 )
		Whisp:SetStartSize( 70*self.Scale )
		Whisp:SetEndSize( 100*self.Scale )
		Whisp:SetRoll( math.Rand(150, 360) )
		Whisp:SetRollDelta( math.Rand(-2, 2) )			
		Whisp:SetAirResistance( 300 ) 			 
		Whisp:SetGravity( Vector( math.random(-40,40)*self.Scale, math.random(-40,40)*self.Scale, 0 ) ) 			
		Whisp:SetColor( 150,150,150 )
		end
		end


				local Density = 40*self.Scale					/// This part is for the dust ring ///
				local Angle = self.DirVec:Angle()
				for i=0, Density do	
				Angle:RotateAroundAxis(Angle:Forward(), (360/Density))
				local ShootVector = Angle:Up()
				local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Pos )
				if (Smoke) then
				Smoke:SetVelocity( ShootVector * math.Rand(50,700*self.Scale) )
				Smoke:SetDieTime( math.Rand( 1 , 4 )*self.Scale  )
				Smoke:SetStartAlpha( math.Rand( 90, 120 ) )
				Smoke:SetEndAlpha( 0 )
				Smoke:SetStartSize( 40*self.Scale )
				Smoke:SetEndSize( 70*self.Scale )
				Smoke:SetRoll( math.Rand(0, 360) )
				Smoke:SetRollDelta( math.Rand(-1, 1) )			
				Smoke:SetAirResistance( 200 ) 			 
				Smoke:SetGravity( Vector( math.Rand( -200 , 200 ), math.Rand( -200 , 200 ), math.Rand( 10 , 100 ) ) )			
				Smoke:SetColor( 90,83,68 )
				end	
				end
 end

 function EFFECT:Metal()
			sound.Play( "Bullet.Impact", self.Pos)

		for i=1,5 do 				// Blast flash
		local Flash = self.Emitter:Add( "effects/muzzleflash"..math.random(1,4), self.Pos )
		if (Flash) then
		Flash:SetVelocity( self.DirVec*100 )
		Flash:SetAirResistance( 200 )
		Flash:SetDieTime( 0.15 )
		Flash:SetStartAlpha( 255 )
		Flash:SetEndAlpha( 0 )
		Flash:SetStartSize( self.Scale*200 )
		Flash:SetEndSize( 0 )
		Flash:SetRoll( math.Rand(180,480) )
		Flash:SetRollDelta( math.Rand(-1,1) )
		Flash:SetColor(255,255,255)	
		end
		end

		for i=0, 30*self.Scale do
		local Whisp = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Pos )
		if (Whisp) then
		Whisp:SetVelocity(VectorRand():GetNormalized() * math.random( 200,1000*self.Scale) )
		Whisp:SetDieTime( math.Rand( 4 , 10 )*self.Scale/2  )
		Whisp:SetStartAlpha( math.Rand( 50, 70 ) )
		Whisp:SetEndAlpha( 0 )
		Whisp:SetStartSize( 70*self.Scale )
		Whisp:SetEndSize( 100*self.Scale )
		Whisp:SetRoll( math.Rand(150, 360) )
		Whisp:SetRollDelta( math.Rand(-2, 2) )			
		Whisp:SetAirResistance( 300 ) 			 
		Whisp:SetGravity( Vector( math.random(-40,40)*self.Scale, math.random(-40,40)*self.Scale, 0 ) ) 			
		Whisp:SetColor( 120,120,120 )
		end
		end

 		for i=0, 30*self.Scale do 
 		local Sparks = self.Emitter:Add( "effects/spark", self.Pos ) 
 		if (Sparks) then 
 		Sparks:SetVelocity( ((self.DirVec*0.75)+VectorRand()) * math.Rand(200, 600)*self.Scale ) 
 		Sparks:SetDieTime( math.Rand(0.3, 1) ) 				 
 		Sparks:SetStartAlpha( 255 )  				 
 		Sparks:SetStartSize( math.Rand(7, 15)*self.Scale ) 
 		Sparks:SetEndSize( 0 ) 				 
 		Sparks:SetRoll( math.Rand(0, 360) ) 
 		Sparks:SetRollDelta( math.Rand(-5, 5) ) 				 
 		Sparks:SetAirResistance( 20 ) 
 		Sparks:SetGravity( Vector( 0, 0, -600 ) ) 
 		end 	
		end 

 		for i=0, 10*self.Scale do 
 		local Sparks = self.Emitter:Add( "effects/yellowflare", self.Pos ) 
 		if (Sparks) then 
 		Sparks:SetVelocity( VectorRand() * math.Rand(200, 600)*self.Scale ) 
 		Sparks:SetDieTime( math.Rand(1, 1.7) ) 				 
 		Sparks:SetStartAlpha( 200 )  				 
 		Sparks:SetStartSize( math.Rand(10, 13)*self.Scale ) 
 		Sparks:SetEndSize( 0 ) 				 
 		Sparks:SetRoll( math.Rand(0, 360) ) 
 		Sparks:SetRollDelta( math.Rand(-5, 5) ) 				 
 		Sparks:SetAirResistance( 100 ) 
 		Sparks:SetGravity( Vector( 0, 0, -60 ) ) 
 		end 	
		end 

end


 function EFFECT:Smoke()
				sound.Play( "Bullet.Impact", self.Pos)

		for i=1,5 do 				// Blast flash
		local Flash = self.Emitter:Add( "effects/muzzleflash"..math.random(1,4), self.Pos )
		if (Flash) then
		Flash:SetVelocity( self.DirVec*100 )
		Flash:SetAirResistance( 200 )
		Flash:SetDieTime( 0.15 )
		Flash:SetStartAlpha( 255 )
		Flash:SetEndAlpha( 0 )
		Flash:SetStartSize( self.Scale*200 )
		Flash:SetEndSize( 0 )
		Flash:SetRoll( math.Rand(180,480) )
		Flash:SetRollDelta( math.Rand(-1,1) )
		Flash:SetColor(255,255,255)	
		end
		end

		for i=0, 30*self.Scale do
		local Whisp = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Pos )
		if (Whisp) then
		Whisp:SetVelocity(VectorRand():GetNormalized() * math.random( 200,1200*self.Scale) )
		Whisp:SetDieTime( math.Rand( 4 , 10 )*self.Scale/2  )
		Whisp:SetStartAlpha( math.Rand( 35, 50 ) )
		Whisp:SetEndAlpha( 0 )
		Whisp:SetStartSize( 70*self.Scale )
		Whisp:SetEndSize( 100*self.Scale )
		Whisp:SetRoll( math.Rand(150, 360) )
		Whisp:SetRollDelta( math.Rand(-2, 2) )			
		Whisp:SetAirResistance( 300 ) 			 
		Whisp:SetGravity( Vector( math.random(-40,40)*self.Scale, math.random(-40,40)*self.Scale, 0 ) ) 			
		Whisp:SetColor( 120,120,120 )
		end
		end


		for i=1, 25*self.Scale do
		local Debris = self.Emitter:Add( "effects/fleck_tile"..math.random(1,2), self.Pos )
		if (Debris) then
		Debris:SetVelocity ( self.DirVec * math.random(100,600)*self.Scale + VectorRand():GetNormalized() * math.random(100,1200)*self.Scale )
		Debris:SetDieTime( math.random( 1, 3) * self.Scale )
		Debris:SetStartAlpha( 255 )
		Debris:SetEndAlpha( 0 )
		Debris:SetStartSize( math.random(5,10)*self.Scale)
		Debris:SetRoll( math.Rand(0, 360) )
		Debris:SetRollDelta( math.Rand(-5, 5) )			
		Debris:SetAirResistance( 40 ) 			 			
		Debris:SetColor( 70,70,70 )
		Debris:SetGravity( Vector( 0, 0, -600) ) 	
		end
		end

		local Angle = self.DirVec:Angle()
		for i = 1, self.DebrizzlemyNizzle do 					/// This part makes the trailers ///
		Angle:RotateAroundAxis(Angle:Forward(), (360/self.DebrizzlemyNizzle))
		local DustRing = Angle:Up()
		local RanVec = self.DirVec*math.Rand(1, 4) + (DustRing*math.Rand(3, 4))

			for k = 3, self.Particles do
			local Rcolor = math.random(-20,20)
			local particle1 = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Pos )				
			particle1:SetVelocity((VectorRand():GetNormalized()*math.Rand(1, 2) * self.Size) + (RanVec*self.Size*k*3.5))	
			particle1:SetDieTime( math.Rand( 0, 3 )*self.Scale )	
			particle1:SetStartAlpha( math.Rand( 90, 100 ) )			
			particle1:SetEndAlpha(0)	
			particle1:SetGravity((VectorRand():GetNormalized()*math.Rand(5, 10)* self.Size) + Vector(0,0,-50))
			particle1:SetAirResistance( 200+self.Scale*20 ) 		
			particle1:SetStartSize( (5*self.Size)-((k/self.Particles)*self.Size*3) )	
			particle1:SetEndSize( (20*self.Size)-((k/self.Particles)*self.Size) )
			particle1:SetRoll( math.random( -500, 500 )/100 )	
			particle1:SetRollDelta( math.random( -0.5, 0.5 ) )	
			particle1:SetColor( 90+Rcolor,85+Rcolor,75+Rcolor )
			end
		end
end

 function EFFECT:Wood()

		for i=1,5 do 				
		local Flash = self.Emitter:Add( "effects/muzzleflash"..math.random(1,4), self.Pos )
		if (Flash) then
		Flash:SetVelocity( self.DirVec*100 )
		Flash:SetAirResistance( 200 )
		Flash:SetDieTime( 0.15 )
		Flash:SetStartAlpha( 255 )
		Flash:SetEndAlpha( 0 )
		Flash:SetStartSize( self.Scale*200 )
		Flash:SetEndSize( 0 )
		Flash:SetRoll( math.Rand(180,480) )
		Flash:SetRollDelta( math.Rand(-1,1) )
		Flash:SetColor(255,255,255)	
		end
		end

		for i=0, 30*self.Scale do
		local Whisp = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Pos )
		if (Whisp) then
		Whisp:SetVelocity(VectorRand():GetNormalized() * math.random( 200,1000)*self.Scale )
		Whisp:SetDieTime( math.Rand( 4 , 10 )*self.Scale/2  )
		Whisp:SetStartAlpha( math.Rand( 70, 90 ) )
		Whisp:SetEndAlpha( 0 )
		Whisp:SetStartSize( 70*self.Scale )
		Whisp:SetEndSize( 100*self.Scale )
		Whisp:SetRoll( math.Rand(150, 360) )
		Whisp:SetRollDelta( math.Rand(-2, 2) )			
		Whisp:SetAirResistance( 300 ) 			 
		Whisp:SetGravity( Vector( math.random(-40,40)*self.Scale, math.random(-40,40)*self.Scale, 0 ) ) 			
		Whisp:SetColor( 90,85,75 )
		end
		end

		for i=0, 20*self.Scale do
		local Debris = self.Emitter:Add( "effects/fleck_wood"..math.random(1,2), self.Pos+self.DirVec )
		if (Debris) then
		Debris:SetVelocity( self.DirVec * math.random(50,500)*self.Scale + VectorRand():GetNormalized() * math.random(200,900)*self.Scale )
		Debris:SetDieTime( math.random( 0.75, 2) )
		Debris:SetStartAlpha( 255 )
		Debris:SetEndAlpha( 0 )
		Debris:SetStartSize( math.random(10,15)*self.Scale )
		Debris:SetRoll( math.Rand(0, 360) )
		Debris:SetRollDelta( math.Rand(-5, 5) )			
		Debris:SetAirResistance( 70 ) 			 			
		Debris:SetColor( 90,85,75 )
		Debris:SetGravity( Vector( 0, 0, -600) ) 		
		end
		end
end

 function EFFECT:Glass()

		for i=1,5 do 				// Blast flash
		local Flash = self.Emitter:Add( "effects/muzzleflash"..math.random(1,4), self.Pos )
		if (Flash) then
		Flash:SetVelocity( self.DirVec*100 )
		Flash:SetAirResistance( 200 )
		Flash:SetDieTime( 0.15 )
		Flash:SetStartAlpha( 255 )
		Flash:SetEndAlpha( 0 )
		Flash:SetStartSize( self.Scale*200 )
		Flash:SetEndSize( 0 )
		Flash:SetRoll( math.Rand(180,480) )
		Flash:SetRollDelta( math.Rand(-1,1) )
		Flash:SetColor(255,255,255)	
		end
		end

		for i=0, 30*self.Scale do
		local Debris = self.Emitter:Add( "effects/fleck_glass"..math.random(1,3), self.Pos )
		if (Debris) then
		Debris:SetVelocity ( VectorRand():GetNormalized() * math.random(100,600)*self.Scale )
		Debris:SetDieTime( math.random( 1, 2.5) )
		Debris:SetStartAlpha( 255 )
		Debris:SetEndAlpha( 0 )
		Debris:SetStartSize( math.random(3,7)*self.Scale )
		Debris:SetRoll( math.Rand(0, 360) )
		Debris:SetRollDelta( math.Rand(-15, 15) )			
		Debris:SetAirResistance( 50 ) 			 			
		Debris:SetColor( 200,200,200 )
		Debris:SetGravity( Vector( 0, 0, -600) ) 
		Debris:SetCollide( true )
		Debris:SetBounce( 0.5 )				
		end
		end


		for i=0, 30*self.Scale do
		local Whisp = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Pos )
		if (Whisp) then
		Whisp:SetVelocity(VectorRand():GetNormalized() * math.random( 200,800*self.Scale) )
		Whisp:SetDieTime( math.Rand( 4 , 10 )*self.Scale/2  )
		Whisp:SetStartAlpha( math.Rand( 35, 50 ) )
		Whisp:SetEndAlpha( 0 )
		Whisp:SetStartSize( 70*self.Scale )
		Whisp:SetEndSize( 100*self.Scale )
		Whisp:SetRoll( math.Rand(150, 360) )
		Whisp:SetRollDelta( math.Rand(-2, 2) )			
		Whisp:SetAirResistance( 300 ) 			 
		Whisp:SetGravity( Vector( math.random(-40,40)*self.Scale, math.random(-40,40)*self.Scale, 0 ) ) 			
		Whisp:SetColor( 150,150,150 )
		end
		end
		
end

 function EFFECT:Blood()
		for i=0, 30*self.Scale do		// If you recieve over 50,000 joules of energy, you become red mist.
		local Smoke = self.Emitter:Add( "particle/particle_composite", self.Pos )
		if (Smoke) then
		Smoke:SetVelocity( VectorRand():GetNormalized()*math.random(100,600)*self.Scale )
		Smoke:SetDieTime( math.Rand( 1 , 2 ) )
		Smoke:SetStartAlpha( 80 )
		Smoke:SetEndAlpha( 0 )
		Smoke:SetStartSize( 30*self.Scale )
		Smoke:SetEndSize( 100*self.Scale )
		Smoke:SetRoll( math.Rand(150, 360) )
		Smoke:SetRollDelta( math.Rand(-2, 2) )			
		Smoke:SetAirResistance( 400 ) 			 
		Smoke:SetGravity( Vector( math.Rand(-50, 50) * self.Scale, math.Rand(-50, 50) * self.Scale, math.Rand(0, -200) ) ) 			
		Smoke:SetColor( 70,35,35 )
		end
		end

		for i=0, 20*self.Scale do		// Add some finer details....
		local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Pos )
		if (Smoke) then
		Smoke:SetVelocity( VectorRand():GetNormalized()*math.random(200,600)*self.Scale )
		Smoke:SetDieTime( math.Rand( 1 , 4 ) )
		Smoke:SetStartAlpha( 120 )
		Smoke:SetEndAlpha( 0 )
		Smoke:SetStartSize( 30*self.Scale )
		Smoke:SetEndSize( 100*self.Scale )
		Smoke:SetRoll( math.Rand(150, 360) )
		Smoke:SetRollDelta( math.Rand(-2, 2) )			
		Smoke:SetAirResistance( 400 ) 			 
		Smoke:SetGravity( Vector( math.Rand(-50, 50) * self.Scale, math.Rand(-50, 50) * self.Scale, math.Rand(-50, -300) ) ) 			
		Smoke:SetColor( 70,35,35 )
		end
		end

		for i=1,5 do 				// Into the flash!
		local Flash = self.Emitter:Add( "effects/muzzleflash"..math.random(1,4), self.Pos )
		if (Flash) then
		Flash:SetVelocity( self.DirVec*100 )
		Flash:SetAirResistance( 200 )
		Flash:SetDieTime( 0.15 )
		Flash:SetStartAlpha( 255 )
		Flash:SetEndAlpha( 0 )
		Flash:SetStartSize( self.Scale*300 )
		Flash:SetEndSize( 0 )
		Flash:SetRoll( math.Rand(180,480) )
		Flash:SetRollDelta( math.Rand(-1,1) )
		Flash:SetColor(255,255,255)	
		end
		end

		for i=1, 20*self.Scale do		// Chunkage NOT contained
		local Debris = self.Emitter:Add( "effects/fleck_cement"..math.random(1,2), self.Pos-(self.DirVec*5) )
		if (Debris) then
		Debris:SetVelocity ( VectorRand():GetNormalized() * 400*self.Scale )
		Debris:SetDieTime( math.random( 0.3, 0.6) )
		Debris:SetStartAlpha( 255 )
		Debris:SetEndAlpha( 0 )
		Debris:SetStartSize( 8 )
		Debris:SetEndSize( 9 )
		Debris:SetRoll( math.Rand(0, 360) )
		Debris:SetRollDelta( math.Rand(-5, 5) )			
		Debris:SetAirResistance( 30 ) 			 			
		Debris:SetColor( 70,35,35 )
		Debris:SetGravity( Vector( 0, 0, -600) ) 
		Debris:SetCollide( true )
		Debris:SetBounce( 0.2 )			
		end
		end

end

 function EFFECT:YellowBlood()
		for i=0, 30*self.Scale do		// If you recieve over 50,000 joules of energy, you become red mist.
		local Smoke = self.Emitter:Add( "particle/particle_composite", self.Pos )
		if (Smoke) then
		Smoke:SetVelocity( VectorRand():GetNormalized()*math.random(100,600)*self.Scale )
		Smoke:SetDieTime( math.Rand( 1 , 2 ) )
		Smoke:SetStartAlpha( 80 )
		Smoke:SetEndAlpha( 0 )
		Smoke:SetStartSize( 30*self.Scale )
		Smoke:SetEndSize( 100*self.Scale )
		Smoke:SetRoll( math.Rand(150, 360) )
		Smoke:SetRollDelta( math.Rand(-2, 2) )			
		Smoke:SetAirResistance( 400 ) 			 
		Smoke:SetGravity( Vector( math.Rand(-50, 50) * self.Scale, math.Rand(-50, 50) * self.Scale, math.Rand(0, -200) ) ) 			
		Smoke:SetColor( 120,120,0 )
		end
		end

		for i=0, 20*self.Scale do		// Add some finer details....
		local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Pos )
		if (Smoke) then
		Smoke:SetVelocity( VectorRand():GetNormalized()*math.random(200,600)*self.Scale )
		Smoke:SetDieTime( math.Rand( 1 , 4 ) )
		Smoke:SetStartAlpha( 120 )
		Smoke:SetEndAlpha( 0 )
		Smoke:SetStartSize( 30*self.Scale )
		Smoke:SetEndSize( 100*self.Scale )
		Smoke:SetRoll( math.Rand(150, 360) )
		Smoke:SetRollDelta( math.Rand(-2, 2) )			
		Smoke:SetAirResistance( 400 ) 			 
		Smoke:SetGravity( Vector( math.Rand(-50, 50) * self.Scale, math.Rand(-50, 50) * self.Scale, math.Rand(-50, -300) ) ) 			
		Smoke:SetColor( 120,120,0 )
		end
		end

		for i=1,5 do 				// Into the flash!
		local Flash = self.Emitter:Add( "effects/muzzleflash"..math.random(1,4), self.Pos )
		if (Flash) then
		Flash:SetVelocity( self.DirVec*100 )
		Flash:SetAirResistance( 200 )
		Flash:SetDieTime( 0.15 )
		Flash:SetStartAlpha( 255 )
		Flash:SetEndAlpha( 0 )
		Flash:SetStartSize( self.Scale*300 )
		Flash:SetEndSize( 0 )
		Flash:SetRoll( math.Rand(180,480) )
		Flash:SetRollDelta( math.Rand(-1,1) )
		Flash:SetColor(255,255,255)	
		end
		end

		for i=1, 20*self.Scale do		// Chunkage NOT contained
		local Debris = self.Emitter:Add( "effects/fleck_cement"..math.random(1,2), self.Pos-(self.DirVec*5) )
		if (Debris) then
		Debris:SetVelocity ( VectorRand():GetNormalized() * 400*self.Scale )
		Debris:SetDieTime( math.random( 0.3, 0.6) )
		Debris:SetStartAlpha( 255 )
		Debris:SetEndAlpha( 0 )
		Debris:SetStartSize( 8 )
		Debris:SetEndSize( 9 )
		Debris:SetRoll( math.Rand(0, 360) )
		Debris:SetRollDelta( math.Rand(-5, 5) )			
		Debris:SetAirResistance( 30 ) 			 			
		Debris:SetColor( 120,120,0 )
		Debris:SetGravity( Vector( 0, 0, -600) ) 
		Debris:SetCollide( true )
		Debris:SetBounce( 0.2 )			
		end
		end
end
 

function EFFECT:Think( )
return false
end

function EFFECT:Render()
end