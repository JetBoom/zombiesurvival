EFFECT.Duration			= 0.25;
EFFECT.Size				= 32;

local MaterialGlow		= Material( "effects/sw_laser_bit" );

function EFFECT:Init( data )

	self.Position = data:GetOrigin();
	self.Normal = data:GetNormal();
	self.LifeTime = self.Duration;

	-- particles
	local emitter = ParticleEmitter( self.Position );
	if( emitter ) then
		
		for i = 1, 32 do

			local particle = emitter:Add( "effects/sw_laser_bit", self.Position + self.Normal * 2 );
			particle:SetVelocity( ( self.Normal + VectorRand() * 0.75 ):GetNormal() * math.Rand( 75, 125 ) );
			particle:SetDieTime( math.Rand( 0.5, 1.25 ) );
			particle:SetStartAlpha( 255 );
			particle:SetEndAlpha( 0 );
			particle:SetStartSize( math.Rand( 4, 8 ) );
			particle:SetEndSize( 0 );
			particle:SetRoll( 0 );
			particle:SetGravity( Vector( 0, 0, -250 ) );
			particle:SetCollide( true );
			particle:SetBounce( 0.3 );
			particle:SetAirResistance( 5 );

		end
		emitter:Finish();
	end
	
	local emitter_s = ParticleEmitter( self.Position );
	if( emitter_s ) then
		for i = 1, 8 do
			local smokeTexture	= "effects/awoi_musket_smoke_01"
			
			local particle_s = emitter_s:Add(smokeTexture, self.Position+self.Normal*2);
			particle_s:SetVelocity((self.Normal+VectorRand()*0.10):GetNormal()*math.Rand(250, 2500));
			particle_s:SetDieTime(math.Rand(1, 3));
			particle_s:SetStartAlpha(150);
			particle_s:SetEndAlpha(0);
			particle_s:SetStartSize(math.Rand(10, 20));
			particle_s:SetEndSize(math.Rand(10, 20));
			particle_s:SetGravity(Vector(math.Rand(0, 500), math.Rand(250, 1000), math.Rand(-250, 250)));
			particle_s:SetRoll(math.Rand(0, 360));
			particle_s:SetRollDelta(math.Rand(-0.5, 0.5));
			local colour = math.Rand(50, 150);
			particle_s:SetColor(colour, colour, colour, 100);
			particle_s:SetCollide(false);
			particle_s:SetAirResistance(2000);
		end
		emitter_s:Finish();
	end
	
end


function EFFECT:Think()

	self.LifeTime = self.LifeTime - FrameTime();
	return self.LifeTime > 0;

end


function EFFECT:Render()

	local frac = math.max( 0, self.LifeTime / self.Duration );
	local rgb = 255 * frac;
	local color = Color( rgb, rgb, rgb, 255 );

	render.SetMaterial( MaterialGlow );
	render.DrawQuadEasy( self.Position + self.Normal, self.Normal, self.Size, self.Size, color );

end
