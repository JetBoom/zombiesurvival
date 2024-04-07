	
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

include( "shared.lua" )
SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
local RapeLength = SWEP.RapeLength
local SoundDelay = SWEP.SoundDelay
local ThrustVel = 750


local victimPos = {

	Vector( 4.1165161132813, 0.33807373046875, 24.5458984375 ),
	Vector( 10.886047363281, -6.7128601074219, 17.712890625 ),
	Vector( 14.32470703125, 6.6110534667969, 24.662109375 ),
	Vector( 10.561950683594, 11.863800048828, 14.9169921875 ),
	Vector( 14.15673828125, 11.935821533203, 4.0126953125 ),
	Vector( 8.0779418945313, -10.698425292969, 7.0859375 ),
	Vector( 17.083557128906, -6.5664367675781, 1.28515625 ),
	Vector( -6.3666381835938, -3.5222778320313, 22.1142578125 ),
	Vector( -5.1080932617188, -3.3052978515625, 4.3046875 ),
	Vector( 18.328247070313, -0.20745849609375, 18.6533203125 ),
	Vector( -7.3578491210938, 4.1403503417969, 22.0517578125 ),
	Vector( -6.7325439453125, 3.0444641113281, 4.2421875 ),
	Vector( -23.113708496094, 2.7197570800781, 6.40234375 ),
	Vector( -21.197875976563, -3.1515197753906, 6.390625 ),

}

local victimAng = {

	Angle( 13.763027191162, -7.126654624939, 297.44543457031 ),
	Angle( 65.35457611084, -125.17009735107, 116.02203369141 ),
	Angle( 56.451721191406, 125.61678314209, 68.999862670898 ),
	Angle( 71.750823974609, 1.1475394964218, 309.23059082031 ),
	Angle( 10.08162021637, 20.952842712402, 89.150527954102 ),
	Angle( 30.348388671875, 24.646505355835, 257.76071166992 ),
	Angle( -31.068134307861, 5.5770988464355, 100.95864105225 ),
	Angle( 85.568023681641, -10.062316894531, 259.72805786133 ),
	Angle( -11.049569129944, 179.28791809082, 92.02823638916 ),
	Angle( 36.883769989014, -10.713672637939, 95.383735656738 ),
	Angle( 87.360504150391, -50.038749694824, 219.5774230957 ),
	Angle( -7.4636454582214, -178.8634185791, 90.854110717773 ),
	Angle( 20.328042984009, 175.31163024902, 84.239585876465 ),
	Angle( 20.698318481445, -177.09216308594, 94.63240814209 ),

}



local attackerPos = {

	Vector( -0.65728759765625, 0.377197265625, 30.7626953125 ),
	Vector( 9.2244873046875, -3.9486083984375, 35.96484375 ),
	Vector( 6.1197509765625, 10.176849365234, 30.6552734375 ),
	Vector( 8.9208984375, 12.130462646484, 20.0087890625 ),
	Vector( 11.781127929688, 14.134094238281, 9.0712890625 ),
	Vector( 10.643859863281, -13.228057861328, 29.0009765625 ),
	Vector( 15.782470703125, -6.8009948730469, 20.9951171875 ),
	Vector( -9.7853393554688, -4.5965576171875, 24.3857421875 ),
	Vector( -11.373352050781, -7.4108276367188, 6.8203125 ),
	Vector( 13.504028320313, 4.9801635742188, 34.6708984375 ),
	Vector( -11.517456054688, 2.9996948242188, 25.9482421875 ),
	Vector( -14.434143066406, 11.57861328125, 10.537109375 ),
	Vector( -30.881225585938, 10.939605712891, 9.0634765625 ),
	Vector( -26.714416503906, -13.074645996094, 9.19921875 ),

}

local attackerAng = {

	Angle( -23.909204483032, 21.916522979736, 247.47807312012 ),
	Angle( 36.469985961914, -81.487747192383, 121.61176300049 ),
	Angle( 72.325134277344, 35.100917816162, 310.2248840332 ),
	Angle( 72.292373657227, 35.012317657471, 310.07629394531 ),
	Angle( 53.682888031006, 77.813186645508, 63.455425262451 ),
	Angle( 44.2184715271, 51.356468200684, 233.86199951172 ),
	Angle( 18.646379470825, 13.987821578979, 129.42607116699 ),
	Angle( 79.875244140625, -120.97535705566, 128.95693969727 ),
	Angle( -8.2740859985352, -159.73634338379, 95.78791809082 ),
	Angle( 4.1483745574951, 25.958532333374, 65.960624694824 ),
	Angle( 59.834487915039, 108.70742797852, 10.802012443542 ),
	Angle( 5.1143140792847, -177.7751159668, 61.338542938232 ),
	Angle( 46.266540527344, 113.92001342773, 15.213181495667 ),
	Angle( 49.310661315918, -157.73908996582, 96.905143737793 ),

}


local sounds = {
	"player/crit_death1.wav",
	"player/crit_death2.wav",
	"player/crit_death3.wav",
	"player/crit_death4.wav",
	"player/crit_death5.wav",
	"bot/come_to_papa.wav",
	"bot/im_pinned_down.wav",
	"bot/oh_man.wav",
	"bot/yesss.wav",
	"bot/pain4",
	"bot/pain5",
	"bot/pain8",
	"bot/pain9",
	"bot/pain10",
	"bot/stop_it.wav",
	"bot/help.wav",
	"bot/i_could_use_some_help.wav",
	"bot/i_could_use_some_help_over_here.wav",
	"bot/they_got_me_pinned_down_here.wav",
	"bot/this_is_my_house.wav",
	"bot/need_help.wav",
	"bot/i_am_dangerous.wav",
	"bot/yikes.wav",
	"noo.wav",
	"bot/whos_the_man.wav",
	"bot/hang_on_im_coming.wav",
	"hostage/hpain/hpain1.wav",
	"hostage/hpain/hpain2.wav",
	"hostage/hpain/hpain3.wav",
	"hostage/hpain/hpain4.wav",
	"hostage/hpain/hpain5.wav",
	"hostage/hpain/hpain6.wav",
	"vo/k_lab/al_youcoming.wav",
	"vo/k_lab/kl_ahhhh.wav",
}

local sounds3 = {
	"physics/body/body_medium_break2.wav",
	"physics/body/body_medium_break3.wav",
	"physics/body/body_medium_break4.wav",
	"physics/body/body_medium_impact_hard1.wav",
	"physics/body/body_medium_impact_hard2.wav",
	"physics/body/body_medium_impact_hard3.wav",
	"physics/body/body_medium_impact_hard4.wav",
	"physics/body/body_medium_impact_hard5.wav",
	"physics/body/body_medium_impact_hard6.wav",
}

local InProgress = false

concommand.Add( SWEP.PRIMARYPW, function( ply, cmd, args )

	if !ply or !ply:IsValid() then return end

	if not ply:HasWeapon( "weapon_zs_rape" ) then return end
	InProgress = true

	local plyAttacker = ply
	local plyAttackerPos = plyAttacker:GetPos()
	
	local plyVictim = plyAttacker:GetEyeTrace().Entity
	if !plyVictim or plyVictim == nil or !plyVictim:IsValid() then return end
	local plyVictimHealth = plyVictim:Health()
	local plyVictimPos = plyVictim:GetPos()
	local VictimType = 1
	if plyVictim:IsNPC() then
		VictimType = 2
	elseif plyVictim:GetClass() == "prop_ragdoll" then
		VictimType = 3
	end
	
	plyAttacker.Raping = true
	
	plyAttacker:StripWeapons()
	plyAttacker:Spectate( OBS_MODE_CHASE )
	if VictimType == 1 and plyVictim and plyVictim:IsValid() then
		plyVictim:StripWeapons()
		plyVictim:Spectate( OBS_MODE_CHASE )
		plyVictim.Raping = true
	end
	
	local basepos = plyAttacker:GetPos() + Vector(0,0,20)
	local traceda = {}
	traceda.start = basepos
	traceda.endpos = basepos - Vector(0,0,1000)
	traceda.filter = {plyVictim, plyAttacker}
	local trace = util.TraceLine(traceda)
	basepos = trace.HitPos or basepos

	local ragVictim = NULL
	if VictimType == 3 then
		ragVictim = plyVictim
	else
		ragVictim = ents.Create("prop_ragdoll")
		ragVictim:SetModel( plyVictim:GetModel() )
		ragVictim:SetPos( plyVictimPos )
		ragVictim:Spawn()
		ragVictim:Activate()
	end

	for i = 1, 14 do
		local phys = ragVictim:GetPhysicsObjectNum(i)
		if phys and phys:IsValid() then
			phys:EnableCollisions( true )
			phys:EnableMotion( false )
			phys:SetPos( basepos + victimPos[i] )
			phys:SetAngles( victimAng[i] )
		end
	end
	
	local ragAttacker = ents.Create("prop_ragdoll")
	ragAttacker:SetModel( plyAttacker:GetModel() )
	ragAttacker:SetPos( plyVictimPos )
	ragAttacker:Spawn()
	ragAttacker:Activate()
	
	for i = 1, 14 do
		local phys = ragAttacker:GetPhysicsObjectNum(i)
		if phys and phys:IsValid() then
			phys:SetPos( basepos + attackerPos[i] )
			phys:SetAngles( attackerAng[i] )
			phys:EnableCollisions( false )
			phys:EnableMotion( true )
			if i==2 or i==5 or i==7 or i==10 or i==13 or i==14 then phys:EnableMotion(false) end
		end
	end

	plyAttacker:SpectateEntity( ragAttacker )
	if VictimType == 1 then
		plyVictim:SpectateEntity( ragVictim )
	elseif VictimType == 2 then
		plyVictim:SetPos( plyVictimPos + Vector(5000,5000,0) )
	elseif VictimType == 3 then
		
	end
	
	local thrustTimerString = "RapeThrust"..math.random(1337)
	local phys = ragAttacker:GetPhysicsObjectNum( 11 )
	if phys and phys:IsValid() then
		phys:SetVelocity( Vector( 0, 0, 100000 ) )
		timer.Create( thrustTimerString, 0.3, 0, function()
			phys:SetVelocity( Vector( 0, 0, ThrustVel ) )
			if math.random( 5 ) == 3 then
				ragVictim:EmitSound( sounds3[math.random(#sounds3)] )
			end
		end )
	end
	
	
	local soundTimerString = "EmitRapeSounds"..math.random(1337)
	timer.Create( soundTimerString, SoundDelay, 0, function()
		ragVictim:EmitSound( sounds[math.random(#sounds)] )
	end )
	
	timer.Simple( RapeLength, function()
	
		if plyAttacker and plyAttacker:IsValid() then
			plyAttacker:UnSpectate()
			plyAttacker:Spawn()
			plyAttacker:SetPos( plyAttackerPos )
			plyAttacker.Raping = false
			timer.Simple( 0.1, function() plyAttacker:Give( "weapon_zs_rape" ) end )
		end
		if plyVictim and plyVictim:IsValid() then
			if VictimType == 1 then
				plyVictim:UnSpectate()
				plyVictim:Spawn()
				plyVictim:SetPos( plyVictimPos )
				plyVictim:SetHealth( plyVictimHealth / 2 )
				plyVictim.Raping = false
			elseif VictimType == 2 then
				plyVictim:SetPos( plyVictimPos )
			elseif VictimType == 3 then
				for i = 1, 14 do
					local phys = ragVictim:GetPhysicsObjectNum(i)
					if phys and phys:IsValid() then
						phys:EnableMotion( true )
					end
				end
			end
		end
		
		SafeRemoveEntity( ragAttacker )
		if VictimType != 3 then SafeRemoveEntity( ragVictim ) end
		
		timer.Destroy( soundTimerString )
		timer.Destroy( thrustTimerString )
	
	end )

end )

hook.Add( "CanPlayerSuicide", "RAPESWEP.CanPlayerSuicide", function( ply )
	if ply.Raping then
		return false
	end
end )


/*--jesus code

--print( player.GetByID(1):GetEyeTrace().PhysicsBone )

local Ragdolls = ents.FindByClass( "prop_ragdoll" )

--for k,v in pairs(Ragdolls) do
local v = Ragdolls[1]

	print(v:GetModel())
	local basepos = Vector( -662, 432.5, -11135.5 )
		
	for i = 1, v:GetPhysicsObjectCount() do
		local phys = v:GetPhysicsObjectNum(i)
		if phys and phys:IsValid() then
			
			local pos = phys:GetPos()
			pos:Sub( basepos )
			local ang = phys:GetAngles()
			
			print("Vector( "..pos.x..", "..pos.y..", "..pos.z.." )," )
			timer.Simple(0.2, function() print("Angle( "..ang.p..", "..ang.y..", "..ang.r.." )," ) end )
		end
	end

--end
*/
