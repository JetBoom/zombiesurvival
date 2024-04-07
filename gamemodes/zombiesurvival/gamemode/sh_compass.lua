mCompass_Settings = {}

mCompass_Settings.Compass_Enabled = true
mCompass_Settings.Force_Server_Style = false -- Force the below compass settings on the client.
mCompass_Settings.Use_FastDL = true -- Auto download the nessesary content for clients.

mCompass_Settings.Style_Selected = "squad"
mCompass_Settings.Allow_Player_Spotting = false -- Allow / Disallow players from spotting. (Disabling just allows servers to implement their own method of spotting)
mCompass_Settings.Allow_Entity_Spotting = false -- Not yet working.
mCompass_Settings.Max_Spot_Distance = 15748.03 -- In GMOD units | Default( 15748.03 / 300m )
mCompass_Settings.Spot_Duration = 10 -- In seconds

mCompass_Settings.Style = {
	["fortnite"] = {
		heading = true,		-- Whether or not the precise bearing is displayed. (Default: true)
		compassX = 0.5,		-- This value is multiplied by users screen width. (Default: 0.5)
		compassY = 0.05,	-- This value is multiplied by users screen height. (Default: 0.05)
		width = 0.25,		-- This value is multiplied by users screen width. (Default: 0.25)
		height = 0.03,		-- This value is multiplied by users screen height. (Default: 0.03)
		multiplier = 2.5,	-- This value changes the spacing between lines. (Default: 2.5)
		ratio = 2,			-- The is the ratio of the size of the letters and numbers text. (Default: 2)
		offset = 180,		-- The number of degrees the compass will offset by. (Default: 180)
		color = Color( 255, 255, 255 ), -- The color of the compass.
		maxMarkerSize = 1,
		minMarkerSize = 0.5
	},
	["squad"] = {
		heading = true,		-- Whether or not the precise bearing is displayed. (Default: true)
		compassX = 0.5,		-- This value is multiplied by users screen width. (Default: 0.5)
		compassY = 0.9,		-- This value is multiplied by users screen height. (Default: 0.9)
		width = 0.25,		-- This value is multiplied by users screen width. (Default: 0.25)
		height = 0.03,		-- This value is multiplied by users screen height. (Default: 0.03)
		multiplier = 2.5,	-- This value changes the spacing between lines. (Default: 2.5)
		ratio = 1.8,		-- The is the ratio of the size of the letters and numbers text. (Default: 1.8)
		offset = 180,		-- The number of degrees the compass will offset by. (Default: 180)
		color = Color( 255, 255, 255 ), -- The color of the compass.
		maxMarkerSize = 1,
		minMarkerSize = 0.5
	},
	["pubg"] = {
		heading = true,		-- Whether or not the precise bearing is displayed. (Default: true)
		compassX = 0.5,		-- This value is multiplied by users screen width. (Default: 0.5)
		compassY = 0.05,	-- This value is multiplied by users screen height. (Default: 0.05)
		width = 0.25,		-- This value is multiplied by users screen width. (Default: 0.25)
		height = 0.03,		-- This value is multiplied by users screen height. (Default: 0.03)
		multiplier = 2.5,	-- This value changes the spacing between lines. (Default: 2.5)
		ratio = 1.8,			-- The is the ratio of the size of the letters and numbers text. (Default: 1.8)
		offset = 180,		-- The number of degrees the compass will offset by. (Default: 180)
		color = Color( 255, 255, 255 ), -- The color of the compass.
		maxMarkerSize = 1,
		minMarkerSize = 0.5
	}
}

--------------------------------------------------------------
-- Dont edit anything below this line.
--------------------------------------------------------------

if SERVER then

	util.AddNetworkString( "Adv_Compass_AddMarker" )
	util.AddNetworkString( "Adv_Compass_RemoveMarker" )

	local mCompass_MarkerTable = mCompass_MarkerTable || {}

	function Adv_Compass_AddMarker( isEntity, pos, time, color, playersWhoCanSeeMarker )
		local id = #mCompass_MarkerTable + 1
		if playersWhoCanSeeMarker then
			for k, v in pairs( playersWhoCanSeeMarker ) do
				net.Start( "Adv_Compass_AddMarker" )
					net.WriteBool( isEntity ) -- IsEntity
					if isEntity then
						net.WriteEntity( pos )
					else
						net.WriteVector( pos )
					end
					net.WriteFloat( time )
					net.WriteColor( color && color || Color( 214, 48, 49 ) )
					net.WriteInt( id, 4 )
				net.Send( v )
			end
		elseif !playersWhoCanSeeMarker then
			net.Start( "Adv_Compass_AddMarker" )
				net.WriteBool( isEntity ) -- IsEntity
				if isEntity then
					net.WriteEntity( pos )
				else
					net.WriteVector( pos )
				end
				net.WriteFloat( time )
				net.WriteColor( color && color || Color( 250, 177, 160 ) )
				net.WriteInt( id, 4 )
			net.Broadcast()
		end
		table.insert( mCompass_MarkerTable, { pos, time, color || Color( 214, 48, 49 ), id } )
		return id
	end

	function Adv_Compass_RemoveMarker( markerID )
		for k, v in pairs( mCompass_MarkerTable ) do
			if markerID == v[5] then
				net.Start( "Adv_Compass_RemoveMarker" )
					net.WriteInt( markerID, 4 )
				net.Broadcast()
				table.remove( mCompass_MarkerTable, k )
			end
		end
	end

	if mCompass_Settings.Use_FastDL then
		resource.AddFile( "materials/compass/compass_marker_01.vmt" )
		resource.AddFile( "materials/compass/compass_marker_02.vmt" )
		resource.AddFile( "resource/fonts/exo/Exo-Regular.ttf" )
	end

	local function v( arg )
		local arg = tonumber( arg )
		return math.Clamp( arg && arg || 255, 0, 255 )
	end

	concommand.Add( "mcompass_spot", function( ply, cmd, args )

		if mCompass_Settings.Allow_Player_Spotting then

			local color = string.ToColor( v( args[1] ).." "..v( args[2] ).." "..v( args[3] ).." "..v( args[4] ) )
			local tr = util.TraceLine( {
				start = ply:EyePos(),
				endpos = ply:EyePos() + ply:EyeAngles():Forward() * mCompass_Settings.Max_Spot_Distance,
				filter = ply
			} )

			local id
			if tr.Entity && !tr.HitWorld then
				id = Adv_Compass_AddMarker( true, tr.Entity, CurTime() + mCompass_Settings.Spot_Duration, color )
			else
				id = Adv_Compass_AddMarker( false, tr.HitPos, CurTime() + mCompass_Settings.Spot_Duration, color )
			end

		end

	end )

end

if CLIENT then

	concommand.Add( "mcompass_reset", function( ply, cmd, args )
		RunConsoleCommand( "mcompass_enabled", "1" )
		RunConsoleCommand( "mcompass_style", "1" )
		RunConsoleCommand( "mcompass_heading", "1" )
		RunConsoleCommand( "mcompass_xposition", "0.5" )
		RunConsoleCommand( "mcompass_yposition", "0.05" )
		RunConsoleCommand( "mcompass_width", "0.25" )
		RunConsoleCommand( "mcompass_height", "0.03" )
		RunConsoleCommand( "mcompass_multiplier", "2.5" )
		RunConsoleCommand( "mcompass_ratio", "1.8" )
		RunConsoleCommand( "mcompass_color", "255", "255", "255", "255" )
	end )

	-- cvars
	local cl_cvar_mcompass_enabled, cl_cvar_mcompass_style, cl_cvar_mcompass_heading, cl_cvar_mcompass_xposition, cl_cvar_mcompass_yposition
	local cl_cvar_mcompass_width, cl_cvar_mcompass_height, cl_cvar_mcompass_multiplier, cl_cvar_mcompass_ratio, cl_cvar_mcompass_color
	local clientStyleSelection, compassStyle

	local function updateCompassSettings()
		clientStyleSelection = ( cl_cvar_mcompass_style == 1 && "fortnite" || cl_cvar_mcompass_style == 2 && "squad" || cl_cvar_mcompass_style == 3 && "pubg" )
		compassStyle = mCompass_Settings.Force_Server_Style && mCompass_Settings.Style_Selected || clientStyleSelection
		compassTBLSelected = mCompass_Settings.Style[mCompass_Settings.Style_Selected]
	end

	local function loadFonts()
		local returnVal = hook.Call( "mCompass_loadFonts" )
	end

	CreateClientConVar( "mcompass_enabled", "1", true, false )
	cvars.AddChangeCallback( "mcompass_enabled", function( convar, oldValue, newValue )
		if newValue == "1" || newValue == "0" then
			cl_cvar_mcompass_enabled = tobool( newValue )
		end
	end, "mcompass_enabled_cvar_callback" )
	cl_cvar_mcompass_enabled = tobool( GetConVar( "mcompass_enabled" ):GetInt() )

	CreateClientConVar( "mcompass_style", "1", true, false )
	cvars.AddChangeCallback( "mcompass_style", function( convar, oldValue, newValue )
		if newValue == "1" || newValue == "2" || newValue == "3" then
			cl_cvar_mcompass_style = tonumber( newValue )
		end
		updateCompassSettings()
	end, "mcompass_style_cvar_callback" )
	cl_cvar_mcompass_style = GetConVar( "mcompass_style" ):GetInt()

	CreateClientConVar( "mcompass_heading", "1", true, false )
	cvars.AddChangeCallback( "mcompass_heading", function( convar, oldValue, newValue )
		if newValue == "1" || newValue == "0" then
			cl_cvar_mcompass_heading = tobool( newValue )
		end
	end, "mcompass_heading_cvar_callback" )
	cl_cvar_mcompass_heading = tobool( GetConVar( "mcompass_heading" ):GetInt() )

	CreateClientConVar( "mcompass_xposition", "0.5", true, false )
	cvars.AddChangeCallback( "mcompass_xposition", function( convar, oldValue, newValue )
		local foo = tonumber( newValue )
		if foo >= 0 && foo <= 1 then
			cl_cvar_mcompass_xposition = newValue
		end
	end, "mcompass_xposition_cvar_callback" )
	cl_cvar_mcompass_xposition = GetConVar( "mcompass_xposition" ):GetFloat()

	CreateClientConVar( "mcompass_yposition", "0.05", true, false )
	cvars.AddChangeCallback( "mcompass_yposition", function( convar, oldValue, newValue )
		local foo = tonumber( newValue )
		if foo >= 0 && foo <= 1 then
			cl_cvar_mcompass_yposition = newValue
		end
	end, "mcompass_yposition_cvar_callback" )
	cl_cvar_mcompass_yposition = GetConVar( "mcompass_yposition" ):GetFloat()

	CreateClientConVar( "mcompass_width", "0.25", true, false )
	cvars.AddChangeCallback( "mcompass_width", function( convar, oldValue, newValue )
		local foo = tonumber( newValue )
		if foo >= 0 && foo <= 1 then
			cl_cvar_mcompass_width = tonumber( newValue )
		end
	end, "mcompass_width_cvar_callback" )
	cl_cvar_mcompass_width = GetConVar( "mcompass_width" ):GetFloat()

	CreateClientConVar( "mcompass_height", "0.03", true, false )
	cvars.AddChangeCallback( "mcompass_height", function( convar, oldValue, newValue )
		local foo = tonumber( newValue )
		if foo >= 0 && foo <= 1 then
			cl_cvar_mcompass_height = tonumber( newValue )
		end
	end, "mcompass_height_cvar_callback" )
	cl_cvar_mcompass_height = GetConVar( "mcompass_height" ):GetFloat()

	CreateClientConVar( "mcompass_multiplier", "2.5", true, false )
	cvars.AddChangeCallback( "mcompass_multiplier", function( convar, oldValue, newValue )
		local foo = tonumber( newValue )
		if foo > 1 && foo < 10 then
			cl_cvar_mcompass_multiplier = foo
		end
	end, "mcompass_multiplier_cvar_callback" )
	cl_cvar_mcompass_multiplier = GetConVar( "mcompass_multiplier" ):GetFloat()

	CreateClientConVar( "mcompass_ratio", "1.8", true, false )
	cvars.AddChangeCallback( "mcompass_ratio", function( convar, oldValue, newValue )
		local foo = tonumber( newValue )
		if foo > 0 && foo < 10 then
			cl_cvar_mcompass_ratio = foo
		end
		loadFonts()
	end, "mcompass_ratio_cvar_callback" )
	cl_cvar_mcompass_ratio = GetConVar( "mcompass_ratio" ):GetFloat()

	local function v( arg )
		local arg = tonumber( arg )
		return math.Clamp( arg && arg || 255, 0, 255 )
	end

	CreateClientConVar( "mcompass_color", "255 255 255 255", true, false )
	cvars.AddChangeCallback( "mcompass_color", function( convar, oldValue, newValue )
		local args = string.Explode( " ", newValue )
		cl_cvar_mcompass_color = string.ToColor( v( args[1] ).." "..v( args[2] ).." "..v( args[3] ).." "..v( args[4] ) )
	end, "mcompass_color_cvar_callback" )
	local foo = string.Explode( " ", GetConVar( "mcompass_color" ):GetString() )
	cl_cvar_mcompass_color = string.ToColor( v( foo[1] ).." "..v( foo[2] ).." "..v( foo[3] ).." "..v( foo[4] ) )

	updateCompassSettings()

	----====----====----====----====----====----====----====----====----====----====----====----====----====----====----====----====----====----

	local compassEnabled, displayHeading, compassWidth, compassHeight, compassMultiplier, compassXPos, oldMarkerSizeScale, oldFontRatio

	-- This table is just going to hold all of the generated fonts for later use.
	displayDistanceFontTable = displayDistanceFontTable || {}
	fontRatioChangeTable = fontRatioChangeTable || {}

	-- Function that handles fonts for the spot marker.
	local function markerScaleFunc( markerSizeScale )

		local returnVal
		local n = math.Round( markerSizeScale )

		if !oldMarkerSizeScale || oldMarkerSizeScale != n then

			if displayDistanceFontTable[n] then
				returnVal = displayDistanceFontTable[n].name
			else

				local newFontName = tostring( "exo_compass_DDN_"..n )

				displayDistanceFontTable[n] = {
					name = newFontName,
					size = n
				}

				surface.CreateFont( newFontName, {
					font = "Exo",
					size = n,
					antialias = true
				} )

				returnVal = displayDistanceFontTable[n].name

			end

			oldMarkerSizeScale = n

		else

			return displayDistanceFontTable[oldMarkerSizeScale].name

		end

		return returnVal

	end

	-- Doing this just so we could remake fonts and see ratio effects live. Kinda messy, I'll clean it up later. :P
	hook.Add( "mCompass_loadFonts", "mCompass_loadFonts_addon", function()

		local h, r, ms

		if mCompass_Settings.Force_Server_Style then
			h = mCompass_Settings.Style[mCompass_Settings.Style_Selected].height
			r = mCompass_Settings.Style[mCompass_Settings.Style_Selected].ratio
			ms = ScrH() * ( mCompass_Settings.Style[mCompass_Settings.Style_Selected].maxMarkerSize / 45 )
		else
			h = cl_cvar_mcompass_height
			r = cl_cvar_mcompass_ratio
			ms = ScrH() * ( mCompass_Settings.Style[clientStyleSelection].maxMarkerSize / 45 )
		end

		if r != oldFontRatio then

			for k, v in pairs( fontRatioChangeTable ) do
				if "exo_compass_Numbers_"..r == v.numberName then
					oldFontRatio = r
					return v
				end
			end

			local maxMarkerSize = mCompass_Settings.Force_Server_Style && mCompass_Settings.Style[mCompass_Settings.Style_Selected].maxMarkerSize || mCompass_Settings.Style[clientStyleSelection].maxMarkerSize

			surface.CreateFont( "exo_compass_Numbers_"..r, {
				font = "Exo",
				size = ScrH() * ( h/r ),
				antialias = true
			} )

			surface.CreateFont( "exo_compass_Distance-Display-Numbers_"..r, {
				font = "Exo",
				size = ( ScrH() * ( h/r ) ) * maxMarkerSize,
				antialias = true
			} )

			surface.CreateFont( "exo_compass_Letters", {
				font = "Exo",
				size = ScrH() * h,
				antialias = true
			} )

			local t = {
				ratio = r,
				numberName = "exo_compass_Numbers_"..r
			}
			table.insert( fontRatioChangeTable, t )

			-- print( "Font created | Name = " .. "exo_compass_Numbers_"..r .. "\nNew table length: "..#fontRatioChangeTable )

			oldFontRatio = r

		end

	end )
	loadFonts()

	compassEnabled = ( mCompass_Settings.Compass_Enabled && cl_cvar_mcompass_enabled )
	displayHeading = mCompass_Settings.Style[compassStyle].heading

	----------------------------------------------------------------------------------------------------------------

	local cl_mCompass_MarkerTable = cl_mCompass_MarkerTable || {}

	net.Receive( "Adv_Compass_AddMarker", function( len )

		local isEntity = net.ReadBool()
		local pos = ( isEntity && net.ReadEntity() || net.ReadVector() )
		local time, color, id = net.ReadFloat(), net.ReadColor(), net.ReadInt( 4 )

		table.insert( cl_mCompass_MarkerTable, { isEntity, pos, time, color, id } )

	end )

	net.Receive( "Adv_Compass_RemoveMarker", function( len )

		local id = net.ReadInt( 4 )

		for k, v in pairs( cl_mCompass_MarkerTable ) do
			if id == v[5] then
				table.remove( cl_mCompass_MarkerTable, k )
			end
		end

	end )

	local function custom_compass_GetMetricValue( units )
		local meters = math.Round( units * 0.01905 )
		local kilometers = math.Round( meters / 1000, 2 )
		return ( kilometers > 1 ) && kilometers.."km" || meters.."m"
	end

	local function custom_compass_GetTextSize( font, text )
		surface.SetFont( font )
		local w, h = surface.GetTextSize( text )
		return w, h
	end

	local function custom_compass_DrawLineFunc( mask1, mask2, line, color )

		render.ClearStencil() -- This is being ran alot
		render.SetStencilEnable( true )

			render.SetStencilFailOperation( STENCILOPERATION_KEEP )
			render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
			render.SetStencilPassOperation( STENCILOPERATION_REPLACE)
			render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )

			render.SetStencilWriteMask( 1 )
			render.SetStencilReferenceValue( 1 )

			surface.SetDrawColor( Color( 0, 0, 0, 1 ) )
			surface.DrawRect( mask1[1], mask1[2], mask1[3], mask1[4] ) -- left
			surface.DrawRect( mask2[1], mask2[2], mask2[3], mask2[4] ) -- right

			render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
			render.SetStencilTestMask( 1 )

			surface.SetDrawColor( color )
			surface.DrawLine( line[1], line[2], line[3], line[4] )

		render.SetStencilEnable( false )

	end

	local adv_compass_tbl = {
		[0] = "N",
		[45] = "NE",
		[90] = "E",
		[135] = "SE",
		[180] = "S",
		[225] = "SW",
		[270] = "W",
		[315] = "NW",
		[360] = "N"
	}

	local mat = Material( "compass/compass_marker_01" )
	local mat2 = Material( "compass/compass_marker_02" )

	hook.Add( "HUDPaint", "HUDPaint_Compass", function()

        local ply = LocalPlayer()

		if compassEnabled && cl_cvar_mcompass_enabled && FindMetaTable("Player").Team(ply) == TEAM_HUMAN && ply:GetObserverMode() == OBS_MODE_NONE then

			local ang = ply:GetAngles()
			local compassX, compassY, width, height, multiplier, offset, spacing, numOfLines, fadeDistMultiplier, ratio
			local displayHeading, fadeDistance, color, compassBearingW, compassBearing, maxMarkerSize, minMarkerSize

			if mCompass_Settings.Force_Server_Style then
				compassX, compassY = ScrW()*compassTBLSelected.compassX, ScrH()*compassTBLSelected.compassY
				width, height = ScrW()*compassTBLSelected.width, ScrH()*compassTBLSelected.height
				multiplier = compassTBLSelected.multiplier
				ratio = compassTBLSelected.ratio
				color = compassTBLSelected.color
				minMarkerSize, maxMarkerSize = ScrH() * ( compassTBLSelected.minMarkerSize / 45 ), ScrH() * ( compassTBLSelected.maxMarkerSize / 45 )
				displayHeading = compassTBLSelected.heading
			else
				compassX, compassY = ScrW()*cl_cvar_mcompass_xposition, ScrH()*cl_cvar_mcompass_yposition
				width, height = ScrW()*cl_cvar_mcompass_width, ScrH()*cl_cvar_mcompass_height
				multiplier = cl_cvar_mcompass_multiplier
				ratio = cl_cvar_mcompass_ratio
				color = cl_cvar_mcompass_color
				minMarkerSize, maxMarkerSize = ScrH() * ( compassTBLSelected.minMarkerSize / 45 ), ScrH() * ( compassTBLSelected.maxMarkerSize / 45 )
				displayHeading = cl_cvar_mcompass_heading
			end
			offset = compassTBLSelected.offset


			spacing = ( width * multiplier ) / 360
			numOfLines = width / spacing
			fadeDistMultiplier = 1
			fadeDistance = (width/2) / fadeDistMultiplier

			surface.SetFont( "exo_compass_Numbers_"..ratio )

			if compassStyle == "squad" then
				local text = math.Round( 360 - ( ang.y % 360 ) )
				local font = "exo_compass_Numbers_"..ratio
				compassBearingW, compassBearingH = custom_compass_GetTextSize( font, text )
				surface.SetFont( font )
				surface.SetTextColor( Color( 255, 255, 255 ) )
				surface.SetTextPos( compassX - compassBearingW/2, compassY )
				surface.DrawText( text )
			end

			for i = ( math.Round( ang.y ) - numOfLines/2 ) % 360, ( ( math.Round( ang.y ) - numOfLines/2 ) % 360 ) + numOfLines do

				local x = ( compassX + ( width/2 * multiplier ) ) - ( ( ( i - ang.y - offset ) % 360 ) * spacing )
				local value = math.abs( x - compassX )
				local calc = 1 - ( ( value + ( value - fadeDistance ) ) / ( width/2 ) )
				local calculation = 255 * math.Clamp( calc, 0, calc )

				if i % 15 == 0 && i > 0 then

					local text = adv_compass_tbl[360 - (i % 360)] && adv_compass_tbl[360 - (i % 360)] || 360 - (i % 360)
					local font = type( text ) == "string" && "exo_compass_Letters" || "exo_compass_Numbers_"..ratio
					local w, h = custom_compass_GetTextSize( font, text )

					surface.SetDrawColor( Color( color.r, color.g, color.b, calculation ) )
					surface.SetTextColor( Color( color.r, color.g, color.b, calculation ) )
					surface.SetFont( font )

					if compassStyle == "pubg" then
						surface.DrawLine( x, compassY, x, compassY + height * 0.5 )
						surface.SetTextPos( x - w/2, compassY + height * 0.6 )
						surface.DrawText( text )
					elseif compassStyle == "fortnite" then
						if font == "exo_compass_Numbers_"..ratio then
							surface.DrawLine( x, compassY, x, compassY + height * 0.3 )
							surface.SetTextPos( x - w/2, compassY + height * 0.5 )
							surface.DrawText( text )
						elseif font == "exo_compass_Letters" then
							surface.SetTextPos( x - w/2, compassY )
							surface.DrawText( text )
						end
					elseif compassStyle == "squad" then
						local mask1 = { compassX - width/2 - fadeDistance, compassY, width/2 + fadeDistance - compassBearingW, height * 2 }
						local mask2 = { compassX + compassBearingW, compassY, width/2 + fadeDistance - compassBearingW, height * 2 }
						local col = Color( color.r, color.g, color.b, calculation )
						local line = { x, compassY, x, compassY + height * 0.5 }
						custom_compass_DrawLineFunc( mask1, mask2, line, col )
						surface.SetTextPos( x - w/2, compassY + height * 0.55 )
						surface.DrawText( text )
					end

					if compassStyle == "squad" then

						local mask1 = { compassX - width/2 - fadeDistance, compassY, width/2 + fadeDistance - compassBearingW, height * 2 }
						local mask2 = { compassX + compassBearingW, compassY, width/2 + fadeDistance - compassBearingW, height * 2 }
						local col = Color( color.r, color.g, color.b, calculation )

						local line = { x, compassY, x, compassY + height * 0.5 }
						custom_compass_DrawLineFunc( mask1, mask2, line, col )

					end

				end

				if compassStyle == "squad" then
					if i % 5 == 0 && i % 15 != 0 then

						local mask1 = { compassX - width/2 - fadeDistance, compassY, width/2 + fadeDistance - compassBearingW, height }
						local mask2 = { compassX + compassBearingW, compassY, width/2 + fadeDistance - compassBearingW, height }
						local col = Color( color.r, color.g, color.b, calculation )

						local line = { x, compassY, x, compassY + height * 0.35 }
						custom_compass_DrawLineFunc( mask1, mask2, line, col )

					end
				end

			end

			for k, v in pairs( cl_mCompass_MarkerTable ) do

				if CurTime() > v[3] || ( v[1] && !IsValid( v[2] ) )  then
					table.remove( cl_mCompass_MarkerTable, k )
					continue
				end

				local spotPos = ( v[1] && v[2]:GetPos() || v[2] )
				local d = ply:GetPos():Distance( spotPos )
				local currentVar = 1 - ( d / ( 300 / 0.01905 ) ) -- Converting 300m to gmod units
				local markerScale = Lerp( currentVar, minMarkerSize, maxMarkerSize  )
				local font = markerScaleFunc( markerScale )

				local yAng = ang.y - ( spotPos - ply:GetPos() ):GetNormalized():Angle().y
				local markerSpot = math.Clamp( ( ( compassX + ( width/2 * multiplier ) ) - ( ( ( -yAng - offset ) % 360 ) * spacing ) ), compassX - width/2, compassX + width/2 )

				surface.SetMaterial( mat )
				surface.SetDrawColor( v[4] )
				surface.DrawTexturedRect( markerSpot - markerScale/2, compassY - markerScale - markerScale/2, markerScale, markerScale )

				-- Drawing text above markers
				local text = custom_compass_GetMetricValue( d )
				local w, h = custom_compass_GetTextSize( font, text )

				surface.SetFont( font )
				surface.SetTextColor( Color( 255, 255, 255 ) )
				surface.SetTextPos( markerSpot - w/2, compassY - markerScale - markerScale/2 - h )
				surface.DrawText( text )

			end

			if compassTBLSelected.heading && compassStyle != "squad" then

				-- Middle Triangle
				local triangleSize = 8
				local triangleHeight = compassY

				local triangle = {
					{ x = compassX - triangleSize/2, y = triangleHeight - ( triangleSize * 2 ) },
					{ x = compassX + triangleSize/2, y = triangleHeight - ( triangleSize * 2 ) },
					{ x = compassX, y = triangleHeight - triangleSize },
				}
				surface.SetDrawColor( 255, 255, 255 )
				draw.NoTexture()
				surface.DrawPoly( triangle )

				if displayHeading then
					local text = math.Round( 360 - ( ang.y % 360 ) )
					local font = "exo_compass_Numbers_"..ratio
					local w, h = custom_compass_GetTextSize( font, text )
					surface.SetFont( font )
					surface.SetTextColor( Color( 255, 255, 255 ) )
					surface.SetTextPos( compassX - w/2, compassY - h - ( triangleSize * 2 ) )
					surface.DrawText( text )
				end

			end

		end

	end )

	hook.Add( "PopulateToolMenu", "mCompass_PopulateToolMenu", function()

		spawnmenu.AddToolMenuOption( "Options", "mCompass", "Settings", "Settings", "", "", function( panel )

			panel:ClearControls()

			local Label1 = vgui.Create( "DLabel", panel )
			Label1:Dock( TOP )
			Label1:SetTextColor( Color( 50, 50, 50 ) )
			Label1:SetText( "Client Settings" )
			Label1:SizeToContents()
			panel:AddItem( Label1 )

			----====----====----====----====----====----====----====----

			local box = vgui.Create( "DCheckBoxLabel", panel )
			box:SetText( "Enabled"  )
			box:SetTextColor( Color( 50, 50, 50 ) )
			box:SetConVar( "mcompass_enabled" )
			box:SetValue( GetConVar( "mcompass_enabled" ):GetInt() )
			box:SizeToContents()
			panel:AddItem( box )

			local box2 = vgui.Create( "DCheckBoxLabel", panel )
			box2:SetText( "Show Heading"  )
			box2:SetTextColor( Color( 50, 50, 50 ) )
			box2:SetConVar( "mcompass_heading" )
			box2:SetValue( GetConVar( "mcompass_heading" ):GetInt() )
			box2:SizeToContents()
			panel:AddItem( box2 )

			panel:NumSlider( "Style", "mcompass_style", 1, 3, 0 )

			panel:NumSlider( "X Position", "mcompass_xposition", 0, 1 )
			panel:NumSlider( "Y Position", "mcompass_yposition", 0, 1 )
			panel:NumSlider( "Width", "mcompass_width", 0, 1 )
			panel:NumSlider( "Height", "mcompass_height", 0, 1 )

			panel:NumSlider( "Multiplier", "mcompass_multiplier", 1, 10, 0 )
			panel:NumSlider( "Ratio (font size)", "mcompass_ratio", 0, 10 )

			local mixercolor = string.ToColor( GetConVar( "mcompass_color" ):GetString() )

			local mixer = vgui.Create( "DColorMixer", panel )
			mixer:SizeToContents()
			mixer:SetColor( mixercolor )
			panel:AddItem( mixer )

			local but1 = vgui.Create( "DButton", panel )
			but1:SetText( "Set Color" )
			but1.DoClick = function( self )
				local t = mixer:GetColor()
				RunConsoleCommand( "mcompass_color", tostring(t.r).." "..tostring(t.g).." "..tostring(t.b).." "..tostring(t.a) )
			end
			panel:AddItem( but1 )

			local but2 = vgui.Create( "DButton", panel )
			but2:SetText( "Reset Settings" )
			but2.DoClick = function( self )
				RunConsoleCommand( "mcompass_reset" )
			end
			panel:AddItem( but2 )

		end )

	end )

end