
local drag_modes = {
	["x / z"] = { "x", "z" },
	["y"] = { "y" },
	["pitch / yaw"] = { "pitch", "yaw" },
	["roll"] = { "roll" }	
}

local function GetIronSightPrintText( vec, ang )
	return "SWEP.IronSightsPos = "..PrintVec( vec ).."\nSWEP.IronSightsAng = "..PrintVec( ang )
end

local wep = GetSCKSWEP( LocalPlayer() )
local pironsight = wep.pironsight
local pironsight_enable = SimplePanel( pironsight )

	local icbox = vgui.Create( "DCheckBoxLabel", pironsight_enable )
		icbox:SetSize( 150, 20 )
		icbox:SetText( "Enable ironsights" )
		icbox.OnChange = function()
			if (wep:GetIronSights() != icbox:GetChecked()) then
				RunConsoleCommand("swepck_toggleironsights")
			end
		end
		if (wep.save_data.IronSightsEnabled) then icbox:SetValue(1)
		else icbox:SetValue(0) end
	icbox:Dock(LEFT)
	
	local ribtn = vgui.Create( "DButton", pironsight_enable )
		ribtn:SetTall( 20 )
		ribtn:SetText( "Reset ironsights" )
		ribtn.DoClick = function()
			wep:ResetIronSights()
		end
	ribtn:Dock(FILL)

pironsight_enable:DockMargin(0,0,0,5)
pironsight_enable:Dock(TOP)

local pironsight_drag = SimplePanel( pironsight )

	local modlabel = vgui.Create( "DLabel", pironsight_drag )
		modlabel:SetSize( 150, 20 )
		modlabel:SetText( "Drag mode:" )
	modlabel:Dock(LEFT)
	
	local drbox = vgui.Create( "DComboBox", pironsight_drag )
		drbox:SetTall( 20 )
		drbox:SetText( wep.cur_drag_mode )
		for k, v in pairs( drag_modes ) do
			drbox:AddChoice( k )
		end
		drbox.OnSelect = function(panel,index,value)
			local modes = drag_modes[value]
			wep.cur_drag_mode = value
			for k, v in pairs( wep.ir_drag ) do
				v[1] = table.HasValue( modes, k ) // set the drag modus
			end
		end
	drbox:Dock(FILL)
	
pironsight_drag:DockMargin(0,0,0,10)	
pironsight_drag:Dock(TOP)

local ixslider = vgui.Create( "DNumSlider", pironsight )
	ixslider:SetText( "Translate x" )
	ixslider:SetMinMax( -20, 20 )
	ixslider:SetDecimals( 3 )
	ixslider:SetConVar( "_sp_ironsight_x" )
	ixslider:SetValue( wep.save_data.IronSightsPos.x )
	ixslider.ConVarChanged = function( p, value )
		RunConsoleCommand("_sp_ironsight_x",value)
	end
ixslider:DockMargin(0,0,0,10)
ixslider:Dock(TOP)

local iyslider = vgui.Create( "DNumSlider", pironsight )
	iyslider:SetText( "Translate y" )
	iyslider:SetMinMax( -20, 20 )
	iyslider:SetDecimals( 3 )
	iyslider:SetConVar( "_sp_ironsight_y" )
	iyslider:SetValue( wep.save_data.IronSightsPos.y )
	iyslider.ConVarChanged = function( p, value )
		RunConsoleCommand("_sp_ironsight_y",value)
	end
iyslider:DockMargin(0,0,0,10)
iyslider:Dock(TOP)

local izslider = vgui.Create( "DNumSlider", pironsight )
	izslider:SetText( "Translate z" )
	izslider:SetMinMax( -20, 20 )
	izslider:SetDecimals( 3 )
	izslider:SetConVar( "_sp_ironsight_z" )
	izslider:SetValue( wep.save_data.IronSightsPos.z )
	izslider.ConVarChanged = function( p, value )
		RunConsoleCommand("_sp_ironsight_z",value)
	end
izslider:DockMargin(0,0,0,10)
izslider:Dock(TOP)

local ipslider = vgui.Create( "DNumSlider", pironsight )
	ipslider:SetText( "Rotate pitch" )
	ipslider:SetMinMax( -70, 70 )
	ipslider:SetDecimals( 3 )
	ipslider:SetConVar( "_sp_ironsight_pitch" )
	ipslider:SetValue( wep.save_data.IronSightsAng.x )
	ipslider.ConVarChanged = function( p, value )
		RunConsoleCommand("_sp_ironsight_pitch",value)
	end
ipslider:DockMargin(0,0,0,10)
ipslider:Dock(TOP)

local iyaslider = vgui.Create( "DNumSlider", pironsight )
	iyaslider:SetText( "Rotate yaw" )
	iyaslider:SetMinMax( -70, 70 )
	iyaslider:SetDecimals( 3 )
	iyaslider:SetConVar( "_sp_ironsight_yaw" )
	iyaslider:SetValue( wep.save_data.IronSightsAng.y )
	iyaslider.ConVarChanged = function( p, value )
		RunConsoleCommand("_sp_ironsight_yaw",value)
	end
iyaslider:DockMargin(0,0,0,10)
iyaslider:Dock(TOP)

local irslider = vgui.Create( "DNumSlider", pironsight )
	irslider:SetText( "Rotate roll" )
	irslider:SetMinMax( -70, 70 )
	irslider:SetDecimals( 3 )
	irslider:SetConVar( "_sp_ironsight_roll" )
	irslider:SetValue( wep.save_data.IronSightsAng.z )
	irslider.ConVarChanged = function( p, value )
		RunConsoleCommand("_sp_ironsight_roll",value)
	end
irslider:DockMargin(0,0,0,10)
irslider:Dock(TOP)

local pcbtn = vgui.Create( "DButton", pironsight )
	pcbtn:SetTall( 30 )
	pcbtn:SetText( "Copy ironsights code to clipboard" )
	pcbtn.DoClick = function()
		local vec, ang = wep:GetIronSightCoordination()
		SetClipboardText(GetIronSightPrintText( vec, ang ))
		LocalPlayer():ChatPrint("Code copied to clipboard!")
	end
pcbtn:DockMargin(0,5,0,0)
pcbtn:Dock(BOTTOM)

local prbtn = vgui.Create( "DButton", pironsight )
	prbtn:SetTall( 30 )
	prbtn:SetText( "Print ironsights code to console" )
	prbtn.DoClick = function()
		local vec, ang = wep:GetIronSightCoordination()
		MsgN("*********************************************")
		MsgN(GetIronSightPrintText( vec, ang ))
		MsgN("*********************************************")
		LocalPlayer():ChatPrint("Code printed to console!")
	end
prbtn:DockMargin(0,5,0,0)
prbtn:Dock(BOTTOM)
