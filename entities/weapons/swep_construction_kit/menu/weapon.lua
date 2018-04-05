
local function GetWeaponPrintText( wep )
	
	str = ""
	str = str.."SWEP.HoldType = \""..wep.HoldType.."\"\n"
	str = str.."SWEP.ViewModelFOV = "..wep.ViewModelFOV.."\n"
	str = str.."SWEP.ViewModelFlip = "..tostring(wep.ViewModelFlip).."\n"
	str = str.."SWEP.ViewModel = \""..wep.ViewModel.."\"\n"
	str = str.."SWEP.WorldModel = \""..wep.CurWorldModel.."\"\n"
	str = str.."SWEP.ShowViewModel = "..tostring(wep.ShowViewModel).."\n"
	str = str.."SWEP.ShowWorldModel = "..tostring(wep.ShowWorldModel).."\n"
	str = str.."SWEP.ViewModelBoneMods = {"
	local i = 0
	local num = table.Count( wep.v_bonemods )
	for k, v in pairs( wep.v_bonemods ) do
		if !(v.scale == Vector(1,1,1) and v.pos == Vector(0,0,0) and v.angle == Angle(0,0,0)) then
			if (i == 0) then str = str.."\n" end
			i = i + 1
			str = str.."\t[\""..k.."\"] = { scale = "..PrintVec( v.scale )..", pos = "..PrintVec( v.pos )..", angle = "..PrintAngle( v.angle ).." }"
			
			if (i < num) then str = str.."," end
			str = str.."\n"
		end
	end
	str = str.."}"
	
	str = string.Replace(str,",\n}","\n}") // remove the last comma
	
	return str
	
end

local function ClearViewModels()

	local wep = GetSCKSWEP( LocalPlayer() )

	wep.v_models = {}
	if (wep.v_modelListing) then wep.v_modelListing:Clear() end
	for k, v in pairs( wep.v_panelCache ) do
		if (v) then 
			v:Remove()
		end
	end
	wep.v_panelCache = {}
end

local function ClearWorldModels()
	
	local wep = GetSCKSWEP( LocalPlayer() )
	if (!IsValid(wep)) then return end

	wep.w_models = {}
	if (wep.w_modelListing) then wep.w_modelListing:Clear() end
	for k, v in pairs( wep.w_panelCache ) do
		if (v) then 
			v:Remove()
		end
	end
	wep.w_panelCache = {}
end

local function RefreshViewModelBoneMods()

	local wep = GetSCKSWEP( LocalPlayer() )
	if (!IsValid(wep)) then return end
	
	if (!IsValid(wep.v_modelbonebox)) then return end
	wep.v_bonemods = {}
	
	wep.v_modelbonebox:Clear()
	
	timer.Destroy("repop")
	
	timer.Create("repop", 1, 1, function()
		local option = PopulateBoneList( wep.v_modelbonebox, LocalPlayer():GetViewModel() )
		if (option) then
			wep.v_modelbonebox:ChooseOptionID(1)
		end
	end)

end

local wep = GetSCKSWEP( LocalPlayer() )
local pweapon = wep.pweapon
local next_v_model = ""

// Weapon model
local pweapon_vmodel = SimplePanel( pweapon )

	local vlabel = vgui.Create( "DLabel", pweapon_vmodel )
		vlabel:SetTall( 20 )
		vlabel:SetText( "View model:" )
	vlabel:Dock(LEFT)
	
	local vtext = vgui.Create( "DTextEntry", pweapon_vmodel)
		vtext:SetTall( 20 )
		vtext:SetMultiline(false)
		vtext.OnTextChanged = function()
			local newmod = string.gsub(vtext:GetValue(), ".mdl", "")
			RunConsoleCommand("swepck_viewmodel", newmod)
			
			// clear view model additions
			if (newmod != next_v_model and file.Exists(newmod..".mdl", "GAME")) then
				next_v_model = newmod
				ClearViewModels()
				RefreshViewModelBoneMods()
			end
			
		end
		vtext:SetText( wep.save_data.ViewModel )
		vtext:OnTextChanged()
	vtext:Dock(FILL)
	
	local vtbtn = vgui.Create( "DButton", pweapon_vmodel )
		vtbtn:SetSize( 25, 20 )
		vtbtn:SetText("...")
		vtbtn.DoClick = function()
			wep:OpenBrowser( wep.ViewModel, "model", function( val ) vtext:SetText(val) vtext:OnTextChanged() end )
		end
	vtbtn:Dock(RIGHT)

pweapon_vmodel:DockMargin(0,0,0,5)
pweapon_vmodel:Dock(TOP)

local pweapon_wmodel = SimplePanel( pweapon )

	local wlabel = vgui.Create( "DLabel", pweapon_wmodel )
		wlabel:SetTall( 20 )
		wlabel:SetText( "World model:" )
	wlabel:Dock(LEFT)
	
	local wtext = vgui.Create( "DTextEntry", pweapon_wmodel)
		wtext:SetTall( 20 )
		wtext:SetMultiline(false)
		wtext.OnTextChanged = function()
			local newmod = string.gsub(wtext:GetValue(), ".mdl", "")
			RunConsoleCommand("swepck_worldmodel", newmod)
			
			// clear world model additions
			if (newmod != wep.cur_wmodel) then
				ClearWorldModels()
			end
			
		end
		wtext:SetText( wep.save_data.CurWorldModel )
		wtext:OnTextChanged()
	wtext:Dock(FILL)
	
	local wtbtn = vgui.Create( "DButton", pweapon_wmodel )
		wtbtn:SetSize( 25, 20 )
		wtbtn:SetText("...")
		wtbtn.DoClick = function()
			wep:OpenBrowser( wep.CurWorldModel, "model", function( val ) wtext:SetText(val) wtext:OnTextChanged() end )
		end
	wtbtn:Dock(RIGHT)
	
pweapon_wmodel:DockMargin(0,0,0,5)
pweapon_wmodel:Dock(TOP)

local pweapon_holdtype = SimplePanel( pweapon )

	// Weapon hold type
	local hlabel = vgui.Create( "DLabel", pweapon_holdtype )
		hlabel:SetSize( 150, 20 )
		hlabel:SetText( "Hold type (3rd person):" )
	hlabel:Dock(LEFT)
	
	local hbox = vgui.Create( "DComboBox", pweapon_holdtype )
		hbox:SetTall( 20 )
		for k, v in pairs( wep:GetHoldTypes() ) do
			hbox:AddChoice( v )
		end
		hbox.OnSelect = function(panel,index,value)
			if (!value) then return end
			wep:SetWeaponHoldType( value )
			wep.HoldType = value
			RunConsoleCommand("swepck_setholdtype", value)
		end
		hbox:SetText( wep.save_data.HoldType )
		hbox.OnSelect( nil, nil, wep.save_data.HoldType )
	hbox:Dock(FILL)

pweapon_holdtype:DockMargin(0,0,0,5)
pweapon_holdtype:Dock(TOP)


// Show viewmodel
local vhbox = vgui.Create( "DCheckBoxLabel", pweapon )
	vhbox:SetTall( 20 )
	vhbox:SetText( "Show view model" )
	vhbox.OnChange = function()
		wep.ShowViewModel = vhbox:GetChecked()
		if (wep.ShowViewModel) then
			LocalPlayer():GetViewModel():SetColor(Color(255,255,255,255))
			LocalPlayer():GetViewModel():SetMaterial("")
		else
			LocalPlayer():GetViewModel():SetColor(Color(255,0,0,255))
			// This should prevent the model from drawing, without stopping ViewModelDrawn from being called
			// I tried Entity:SetRenderMode(1) with color alpha on 1 but the view model resets to render mode 0 every frame :/
			LocalPlayer():GetViewModel():SetMaterial("Debug/hsv") 
		end
	end
	if (wep.save_data.ShowViewModel) then vhbox:SetValue(1)
	else vhbox:SetValue(0) end
vhbox:DockMargin(0,0,0,5)
vhbox:Dock(TOP)

// Show worldmodel
local whbox = vgui.Create( "DCheckBoxLabel", pweapon )
	whbox:SetTall( 20 )
	whbox:SetText( "Show world model" )
	whbox.OnChange = function()
		wep.ShowWorldModel = whbox:GetChecked()
	end
	if (wep.save_data.ShowWorldModel) then whbox:SetValue(1)
	else whbox:SetValue(0) end
whbox:DockMargin(0,0,0,5)
whbox:Dock(TOP)

// Flip viewmodel
local fcbox = vgui.Create( "DCheckBoxLabel", pweapon )
	fcbox:SetTall( 20 )
	fcbox:SetText( "Flip viewmodel" )
	fcbox.OnChange = function()
		wep.ViewModelFlip = fcbox:GetChecked()
	end
	if (wep.save_data.ViewModelFlip) then fcbox:SetValue(1)
	else fcbox:SetValue(0) end
fcbox:DockMargin(0,0,0,5)
fcbox:Dock(TOP)

// View model FOV slider
local fovslider = vgui.Create( "DNumSlider", pweapon )
	fovslider:SetText( "View model FOV" )
	fovslider:SetMin( 20 )
	fovslider:SetMax( 140 )
	fovslider:SetDecimals( 0 )
	fovslider.OnValueChanged = function( panel, value )
		wep.ViewModelFOV = tonumber(value)
		RunConsoleCommand("swepck_viewmodelfov", value)
	end
	fovslider:SetValue( wep.save_data.ViewModelFOV )
fovslider:DockMargin(0,5,0,10)
fovslider:Dock(TOP)

local pweapon_bone = SimplePanel( pweapon )
	pweapon_bone:SetTall( 50 )

	local pbone_left = SimplePanel( pweapon_bone )
		pbone_left:SetWide( 200 )
		
		// View model bone scaling
		local vsbonelabel = vgui.Create( "DLabel", pbone_left )
			vsbonelabel:SetText( "Viewmodel bone mods:" )
			vsbonelabel:SizeToContentsX()
			vsbonelabel:SetTall( 20 )
		vsbonelabel:Dock(TOP)
		
		local vsbonebox = vgui.Create( "DComboBox", pbone_left )
			vsbonebox:SetTall( 20 )
		vsbonebox:Dock(BOTTOM)
		
	pbone_left:Dock(LEFT)
	
	local pbone_right = SimplePanel( pweapon_bone )
	
		local resbtn = vgui.Create( "DButton", pbone_right )
			resbtn:SetTall( 20 )
			resbtn:SetText("Reset all bone mods")
		resbtn:DockMargin(10,0,0,0)
		resbtn:Dock(TOP)
		
		local resselbtn = vgui.Create( "DButton", pbone_right )
			resselbtn:SetTall( 20 )
			resselbtn:SetText("Reset selected bone mod")
		resselbtn:DockMargin(10,0,0,0)
		resselbtn:Dock(BOTTOM)
		
	pbone_right:Dock(FILL)

pweapon_bone:Dock(TOP)

if (!wep.save_data.v_bonemods) then
	wep.save_data.v_bonemods = {}
end
		
// backwards compatability with old bone scales
if (wep.save_data.v_bonescales) then
	for k, v in pairs(wep.save_data.v_bonescales) do
		if (v == Vector(1,1,1)) then continue end
		wep.save_data.v_bonemods[k] = { scale = v, pos = Vector(0,0,0), angle = Angle(0,0,0) }
	end
end
wep.save_data.v_bonescales = nil

local curbone = table.GetFirstKey(wep.save_data.v_bonemods)
if (curbone) then
	wep.v_bonemods = table.Copy(wep.save_data.v_bonemods)
else
	curbone = ""
	wep.v_bonemods = {}
end
	
local bonepanel = vgui.Create( "DPanel", pweapon )
	bonepanel:SetVisible( true )
	bonepanel:SetPaintBackground( true )
	bonepanel.Paint = function() surface.SetDrawColor( 80, 80, 80, 255 ) surface.DrawRect( 0, 0, bonepanel:GetWide(), bonepanel:GetTall() ) end
bonepanel:DockMargin( 0, 5, 0, 5 )
bonepanel:DockPadding( 5, 5, 5, 5 )
bonepanel:Dock(FILL)
	
local function CreateBoneMod( selbone, preset_data )
	
	local data = wep.v_bonemods[selbone]
	if (!preset_data) then preset_data = {} end
	
	data.scale = preset_data.scale or Vector(1,1,1)
	data.pos = preset_data.pos or Vector(0,0,0)
	data.angle = preset_data.angle or Angle(0,0,0)
	
	local sliderw = 110
	
	local pscale = SimplePanel( bonepanel )
	pscale:SetTall(32*3)
	
		local vslabel = vgui.Create( "DLabel", pscale )
			vslabel:SetText( "Scale" )
			vslabel:SizeToContents()
			vslabel:SetWide(45)
		vslabel:Dock(LEFT)
		
		local vsxwang = vgui.Create( "DNumSlider", pscale )
			vsxwang:SetText("x / y / z")
			vsxwang:SetWide(sliderw)
			vsxwang:SetMinMax( 0.01, 3 ) 
			vsxwang:SetDecimals( 3 )
		
		local vsywang = vgui.Create( "DNumSlider", pscale )
			vsywang:SetText("y")
			vsywang:SetWide(sliderw)
			vsywang:SetMinMax( 0.01, 3 )
			vsywang:SetDecimals( 3 )
			vsywang.Wang.ConVarChanged = function( p, value ) 
				if (selbone != "") then wep.v_bonemods[selbone].scale.y = tonumber(value) end
			end
			vsywang:DockMargin(10,0,0,0)
			
		local vszwang = vgui.Create( "DNumSlider", pscale )
			vszwang:SetText("z")
			vszwang:SetWide(sliderw)
			vszwang:SetMinMax( 0.01, 3 )
			vszwang:SetDecimals( 3 )
			vszwang.Wang.ConVarChanged = function( p, value ) 
				if (selbone != "") then wep.v_bonemods[selbone].scale.z = tonumber(value) end 
			end
			vszwang:DockMargin(10,0,0,0)
			
			// make the x numberwang set the total size
			vsxwang.Wang.ConVarChanged = function( p, value )
				if (selbone == "") then return end
				vszwang:SetValue( value )
				vsywang:SetValue( value )
				wep.v_bonemods[selbone].scale.x = tonumber(value)
			end
			vsxwang:DockMargin(10,0,0,0)
		
		pscale.PerformLayout = function() // scales the sliders with the panel
			vszwang:SetWide(pscale:GetWide()*4/15)
			vsywang:SetWide(pscale:GetWide()*4/15)
			vsxwang:SetWide(pscale:GetWide()*4/15)
		end
		
		vsxwang:Dock(TOP)
		vsywang:Dock(TOP)
		vszwang:Dock(TOP)
		
	pscale:DockMargin(0,0,0, 5)
	pscale:Dock(TOP)
		
	local ppos = SimplePanel( bonepanel )
	ppos:SetTall(32*3)
	
		local vposlabel = vgui.Create( "DLabel", ppos )
			vposlabel:SetText( "Pos" )
			vposlabel:SizeToContents()
			vposlabel:SetWide(45)
		vposlabel:Dock(LEFT)
		
		local vposxwang = vgui.Create( "DNumSlider", ppos )
			vposxwang:SetText("x")
			vposxwang:SetWide(sliderw)
			vposxwang:SetMinMax( -30, 30 )
			vposxwang:SetDecimals( 3 )
			vposxwang.Wang.ConVarChanged = function( p, value )
				if (selbone != "") then wep.v_bonemods[selbone].pos.x = tonumber(value) end
			end
		vposxwang:DockMargin(10,0,0,0)
		
		local vposywang = vgui.Create( "DNumSlider", ppos )
			vposywang:SetText("y")
			vposywang:SetWide(sliderw)
			vposywang:SetMinMax( -30, 30 )
			vposywang:SetDecimals( 3 )
			vposywang.Wang.ConVarChanged = function( p, value ) 
				if (selbone != "") then wep.v_bonemods[selbone].pos.y = tonumber(value) end
			end
		vposywang:DockMargin(10,0,0,0)
		
		local vposzwang = vgui.Create( "DNumSlider", ppos )
			vposzwang:SetText("z")
			vposzwang:SetWide(sliderw)
			vposzwang:SetMinMax( -30, 30 )
			vposzwang:SetDecimals( 3 )
			vposzwang.Wang.ConVarChanged = function( p, value ) 
				if (selbone != "") then wep.v_bonemods[selbone].pos.z = tonumber(value) end 
			end
		vposzwang:DockMargin(10,0,0,0)
		
		ppos.PerformLayout = function()
			vposzwang:SetWide(ppos:GetWide()*4/15)
			vposywang:SetWide(ppos:GetWide()*4/15)
			vposxwang:SetWide(ppos:GetWide()*4/15)
		end
		
		vposxwang:Dock(TOP)
		vposywang:Dock(TOP)
		vposzwang:Dock(TOP)
		
	ppos:DockMargin(0,0,0, 5)
	ppos:Dock(TOP)
	
	local pang = SimplePanel( bonepanel )
	pang:SetTall(32*3)
	
		local vanglabel = vgui.Create( "DLabel", pang )
			vanglabel:SetText( "Angle" )
			vanglabel:SizeToContents()
			vanglabel:SetWide(45)
		vanglabel:Dock(LEFT)
		
		local vangxwang = vgui.Create( "DNumSlider", pang )
			vangxwang:SetText("pitch")
			vangxwang:SetWide(sliderw)
			vangxwang:SetMinMax( -180, 180 )
			vangxwang:SetDecimals( 3 )
			vangxwang.Wang.ConVarChanged = function( p, value )
				if (selbone != "") then wep.v_bonemods[selbone].angle.p = tonumber(value) end
			end
		vangxwang:DockMargin(10,0,0,0)
		
		local vangywang = vgui.Create( "DNumSlider", pang )
			vangywang:SetText("yaw")
			vangywang:SetWide(sliderw)
			vangywang:SetMinMax( -180, 180 )
			vangywang:SetDecimals( 3 )
			vangywang.Wang.ConVarChanged = function( p, value ) 
				if (selbone != "") then wep.v_bonemods[selbone].angle.y = tonumber(value) end
			end
		vangywang:DockMargin(10,0,0,0)
		
		local vangzwang = vgui.Create( "DNumSlider", pang )
			vangzwang:SetText("roll")
			vangzwang:SetWide(sliderw)
			vangzwang:SetMinMax( -180, 180 )
			vangzwang:SetDecimals( 3 )
			vangzwang.Wang.ConVarChanged = function( p, value ) 
				if (selbone != "") then wep.v_bonemods[selbone].angle.r = tonumber(value) end 
			end
		vangzwang:DockMargin(10,0,0,0)
		
		pang.PerformLayout = function()
			vangzwang:SetWide(pang:GetWide()*4/15)
			vangywang:SetWide(pang:GetWide()*4/15)
			vangxwang:SetWide(pang:GetWide()*4/15)
		end
		
		vangxwang:Dock(TOP)
		vangywang:Dock(TOP)
		vangzwang:Dock(TOP)
		
	pang:DockMargin(0,0,0, 5)
	pang:Dock(TOP)
		
	vsxwang:SetValue( data.scale.x )
	vsywang:SetValue( data.scale.y )
	vszwang:SetValue( data.scale.z )
	
	vposxwang:SetValue( data.pos.x )
	vposywang:SetValue( data.pos.y )
	vposzwang:SetValue( data.pos.z )
	
	vangxwang:SetValue( data.angle.p )
	vangywang:SetValue( data.angle.y )
	vangzwang:SetValue( data.angle.r )
	
end

vsbonebox.OnSelect = function( p, index, value )
	local selbone = value
	if (!selbone or selbone == "") then return end
	
	if (!wep.v_bonemods[selbone]) then
		wep.v_bonemods[selbone] = { scale = Vector(1,1,1), pos = Vector(0,0,0), angle = Angle(0,0,0) }
	end
	
	for k, v in pairs( bonepanel:GetChildren() ) do
		v:Remove()
	end
	
	CreateBoneMod( selbone, wep.v_bonemods[selbone])
	curbone = selbone
end
vsbonebox:SetText( curbone )
vsbonebox.OnSelect( vsbonebox, 1, curbone ) 
	
timer.Simple(1, function()
	local option = PopulateBoneList( vsbonebox, LocalPlayer():GetViewModel() )
	if (option and curbone == "") then 
		vsbonebox:ChooseOptionID(1)
	end
end)
	
resbtn.DoClick = function()
	wep.v_bonemods = {}
	if (curbone == "") then return end
	
	wep.v_bonemods[curbone] = { scale = Vector(1,1,1), pos = Vector(0,0,0), angle = Angle(0,0,0) }
	
	for k, v in pairs( bonepanel:GetChildren() ) do
		v:Remove()
	end
	
	CreateBoneMod( curbone, wep.v_bonemods[curbone])
end

resselbtn.DoClick = function()
	
	if (curbone == "") then return end
	wep.v_bonemods[curbone] = { scale = Vector(1,1,1), pos = Vector(0,0,0), angle = Angle(0,0,0) }
	
	for k, v in pairs( bonepanel:GetChildren() ) do
		v:Remove()
	end
	
	CreateBoneMod( curbone, wep.v_bonemods[curbone])
end

wep.v_modelbonebox = vsbonebox

local wpdbtn = vgui.Create( "DButton", pweapon )
	wpdbtn:SetTall( 30 )
	wpdbtn:SetText( "Drop weapon (hold reload key to pick back up)" )
	wpdbtn.DoClick = function()
		RunConsoleCommand("swepck_dropwep")
	end
wpdbtn:DockMargin(0,5,0,0)
wpdbtn:Dock(BOTTOM)

local wpcbtn = vgui.Create( "DButton", pweapon )
	wpcbtn:SetTall( 30 )
	wpcbtn:SetText( "Copy weapon code to clipboard" )
	wpcbtn.DoClick = function()
		SetClipboardText(GetWeaponPrintText(wep))
		LocalPlayer():ChatPrint("Code copied to clipboard!")
	end
wpcbtn:DockMargin(0,5,0,0)
wpcbtn:Dock(BOTTOM)

local wpbtn = vgui.Create( "DButton", pweapon )
	wpbtn:SetTall( 30 )
	wpbtn:SetText( "Print weapon code to console" )
	wpbtn.DoClick = function()
		MsgN("*********************************************")
		for k, v in pairs(string.Explode("\n",GetWeaponPrintText(wep))) do
			MsgN(v)
		end
		MsgN("*********************************************")
		LocalPlayer():ChatPrint("Code printed to console!")
	end
wpbtn:DockMargin(0,5,0,0)
wpbtn:Dock(BOTTOM)
