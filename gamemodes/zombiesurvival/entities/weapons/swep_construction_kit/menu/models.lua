
local function GetVModelsText()

	local wep = GetSCKSWEP( LocalPlayer() )
	if (!IsValid(wep)) then return "" end
	
	local str = ("SWEP.VElements = {\n")
	local i = 0
	local num = table.Count(wep.v_models)
	for k, v in pairs( wep.v_models ) do
	
		if (v.type == "Model") then
			str = str.."\t[\""..k.."\"] = { type = \"Model\", model = \""..v.model.."\", bone = \""..v.bone.."\", rel = \""..v.rel.."\", pos = "..PrintVec(v.pos)
			str = str..", angle = "..PrintAngle( v.angle )..", size = "..PrintVec(v.size)..", color = "..PrintColor( v.color )
			str = str..", surpresslightning = "..tostring(v.surpresslightning)..", material = \""..v.material.."\", skin = "..v.skin
			str = str..", bodygroup = {"
			local i = 0
			for k, v in pairs( v.bodygroup ) do
				if (v <= 0) then continue end
				if ( i != 0 ) then str = str..", " end
				i = 1
				str = str.."["..k.."] = "..v
			end
			str = str.."} }"
		elseif (v.type == "Sprite") then
			str = str.."\t[\""..k.."\"] = { type = \"Sprite\", sprite = \""..v.sprite.."\", bone = \""..v.bone.."\", rel = \""..v.rel.."\", pos = "..PrintVec(v.pos)
			str = str..", size = { x = "..v.size.x..", y = "..v.size.y.." }, color = "..PrintColor( v.color )..", nocull = "..tostring(v.nocull)
			str = str..", additive = "..tostring(v.additive)..", vertexalpha = "..tostring(v.vertexalpha)..", vertexcolor = "..tostring(v.vertexcolor)
			str = str..", ignorez = "..tostring(v.ignorez).."}"
		elseif (v.type == "Quad") then
			str = str.."\t[\""..k.."\"] = { type = \"Quad\", bone = \""..v.bone.."\", rel = \""..v.rel.."\", pos = "..PrintVec(v.pos)..", angle = "..PrintAngle( v.angle )
			str = str..", size = "..v.size..", draw_func = nil}"
		end
		
		if (v.type) then
			i = i + 1
			if (i < num) then str = str.."," end
			str = str.."\n"
		end
	end
	str = str.."}"

	return str
end

local function GetWModelsText()

	local wep = GetSCKSWEP( LocalPlayer() )
	if (!IsValid(wep)) then return "" end

	local str = ("SWEP.WElements = {\n")
	local i = 0
	local num = table.Count(wep.w_models)
	for k, v in pairs( wep.w_models ) do
	
		if (v.type == "Model") then
			str = str.."\t[\""..k.."\"] = { type = \"Model\", model = \""..v.model.."\", bone = \""..v.bone.."\", rel = \""..v.rel.."\", pos = "..PrintVec(v.pos)
			str = str..", angle = "..PrintAngle( v.angle )..", size = "..PrintVec(v.size)..", color = "..PrintColor( v.color )
			str = str..", surpresslightning = "..tostring(v.surpresslightning)..", material = \""..v.material.."\", skin = "..v.skin
			str = str..", bodygroup = {"
			local i = 0
			for k, v in pairs( v.bodygroup ) do
				if (v <= 0) then continue end
				if ( i != 0 ) then str = str..", " end
				i = 1
				str = str.."["..k.."] = "..v
			end
			str = str.."} }"
		elseif (v.type == "Sprite") then
			str = str.."\t[\""..k.."\"] = { type = \"Sprite\", sprite = \""..v.sprite.."\", bone = \""..v.bone.."\", rel = \""..v.rel.."\", pos = "..PrintVec(v.pos)
			str = str..", size = { x = "..v.size.x..", y = "..v.size.y.." }, color = "..PrintColor( v.color )..", nocull = "..tostring(v.nocull)
			str = str..", additive = "..tostring(v.additive)..", vertexalpha = "..tostring(v.vertexalpha)..", vertexcolor = "..tostring(v.vertexcolor)
			str = str..", ignorez = "..tostring(v.ignorez).."}"
		elseif (v.type == "Quad") then
			str = str.."\t[\""..k.."\"] = { type = \"Quad\", bone = \""..v.bone.."\", rel = \""..v.rel.."\", pos = "..PrintVec(v.pos)..", angle = "..PrintAngle( v.angle )
			str = str..", size = "..v.size..", draw_func = nil}"
		end
		
		if (v.type) then
			i = i + 1
			if (i < num) then str = str.."," end
			str = str.."\n"
		end
	end
	str = str.."}"

	str = str.."\n\n"

	local i = 0
	for k, v in pairs( wep.w_models ) do
		if (v.type == "Model") then
			i = i + 1
			str = str.."c:AddModel(\""..v.model.."\", "..PrintVec(v.pos)..", "..PrintAngle(v.angle)..", ".. ((not v.rel or #v.rel == 0) and "\""..v.bone.."\"" or "nil") ..", "..(v.size.x == 1 and v.size.y == 1 and v.size.z == 1 and "nil" or v.size.x == v.size.y and v.size.x == v.size.z and math.Round(v.size.x, 4) or PrintVec(v.size))..", ".. (v.material and #v.material > 0 and "\""..v.material.."\"" or "nil") ..", "..(v.color.r == 255 and v.color.g == 255 and v.color.b == 255 and v.color.a == 255 and "nil" or PrintColor( v.color ))
			if v.rel and #v.rel > 0 then
				str = str..", 1"
			end
			str = str..")\n"
		end
	end

	return str
end

local function PopulateRelative( sourcetab, box, startchoice, ignore )
	
	box:Clear()
	local choose = box:AddChoice("")
	for k, v in pairs( sourcetab ) do
		if (v == ignore) then continue end
		local id = box:AddChoice(v)
		if (v == startchoice) then
			choose = id
		end
	end
	box:ChooseOptionID( choose )
	
end

// Some hacky shit to keep the relative DComboBoxes updated
local v_relelements = {}
local w_relelements = {}
local boxes_to_update = {}
local function RegisterRelBox( elementname, box, w_or_v, preset_choice )
	table.insert(boxes_to_update, { box, w_or_v, elementname, preset_choice })	
end

local function RemoveRelBox( w_or_v, elementname )
	for k, v in pairs( boxes_to_update ) do
		if (v[2] == w_or_v and v[3] == elementname) then
			table.remove(boxes_to_update, k)
			break
		end
	end
end

local function UpdateRelBoxes( w_or_v )
	local source = v_relelements
	if (w_or_v == "w") then
		source = w_relelements
	end
	
	for k, v in pairs( boxes_to_update ) do
		if (IsValid(v[1]) and v[2] == w_or_v) then 
			local choose = v[1]:GetValue()
			if (v[4]) then // preset choice
				choose = v[4]
				v[4] = nil
			end
			PopulateRelative( source, v[1], choose, v[3] )
		end
	end
end

local wep = GetSCKSWEP( LocalPlayer() )
local pmodels = wep.pmodels
local pwmodels = wep.pwmodels
local lastVisible = ""

local mlabel = vgui.Create( "DLabel", pmodels )
	mlabel:SetTall( 20 )
	mlabel:SetText( "New viewmodel element:" )
mlabel:Dock(TOP)

local function CreateNote( text )
	local templabel = vgui.Create( "DLabel" )
		templabel:SetText( text )
		templabel:SizeToContents()

	local x, y = mlabel:GetPos()
	local notif = vgui.Create( "DNotify" , pmodels )
		notif:SetPos( x + 160, y )
		notif:SetSize( templabel:GetWide(), 20 )
		notif:SetLife( 5 )
		notif:AddItem(templabel)
end

local pnewelement = SimplePanel( pmodels )
pnewelement:SetTall(20)

	local mntext = vgui.Create("DTextEntry", pnewelement )
		mntext:SetTall( 20 )
		mntext:SetMultiline(false)
		mntext:SetText( "element_name" )
	mntext:Dock(FILL)
	
	local mnbtn = vgui.Create( "DButton", pnewelement )
		mnbtn:SetSize( 50, 20 )
		mnbtn:SetText( "Add" )
	mnbtn:DockMargin(5,0,0,0)
	mnbtn:Dock(RIGHT)
	
	local tpbox = vgui.Create( "DComboBox", pnewelement )
		tpbox:SetSize( 100, 20 )
		tpbox:SetText( "Model" )
		tpbox:AddChoice( "Model" )
		tpbox:AddChoice( "Sprite" )
		tpbox:AddChoice( "Quad" )
		local boxselected = "Model"
		tpbox.OnSelect = function( p, index, value )
			boxselected = value
		end
	tpbox:DockMargin(5,0,0,0)
	tpbox:Dock(RIGHT)

pnewelement:DockMargin(0,5,0,5)
pnewelement:Dock(TOP)

local mlist = vgui.Create( "DListView", pmodels)
	wep.v_modelListing = mlist
	
	mlist:SetTall( 160 )
	mlist:SetMultiSelect(false)
	mlist:SetDrawBackground(true)
	mlist:AddColumn("Name")
	mlist:AddColumn("Type")
	// cache the created panels
	mlist.OnRowSelected = function( panel, line )
		local name = mlist:GetLine(line):GetValue(1)
		
		if (wep.v_panelCache[lastVisible]) then
			wep.v_panelCache[lastVisible]:SetVisible(false)
		end
		wep.v_panelCache[name]:SetVisible(true)
		
		lastVisible = name
	end

mlist:Dock(TOP)

local pbuttons = SimplePanel( pmodels )

	local rmbtn = vgui.Create( "DButton", pbuttons )
		rmbtn:SetSize( 160, 25 )
		rmbtn:SetText( "Remove selected" )
	rmbtn:Dock(LEFT)
	
	local copybtn = vgui.Create( "DButton", pbuttons )
		copybtn:SetSize( 160, 25 )
		copybtn:SetText( "Copy selected" )
	copybtn:Dock(RIGHT)

pbuttons:DockMargin(0,5,0,5)
pbuttons:Dock(TOP)

// Print buttons
local pctbtn = vgui.Create( "DButton", pmodels)
	pctbtn:SetTall( 30 )
	pctbtn:SetText("Copy view model table to clipboard")
	pctbtn.DoClick = function()
		SetClipboardText(GetVModelsText())
		LocalPlayer():ChatPrint("Code copied to clipboard!")
	end
pctbtn:DockMargin(0,5,0,0)
pctbtn:Dock(BOTTOM)

local prtbtn = vgui.Create( "DButton", pmodels)
	prtbtn:SetTall( 30 )
	prtbtn:SetText("Print view model table to console")
	prtbtn.DoClick = function()
		MsgN("*********************************************")
		for k, v in pairs(string.Explode("\n",GetVModelsText())) do
			MsgN(v)
		end
		MsgN("*********************************************")
		LocalPlayer():ChatPrint("Code printed to console!")
	end
prtbtn:Dock(BOTTOM)

local pCol = 0
local function PanelBackgroundReset()
	pCol = 0
end

local function PanelApplyBackground(panel)
	
	if (pCol == 1) then
		panel:SetPaintBackground(true)
		panel.Paint = function() surface.SetDrawColor( 85, 85, 85, 255 ) surface.DrawRect( 0, 0, panel:GetWide(), panel:GetTall() ) end
	end
	
	pCol = (pCol + 1) % 2
end

local function CreatePositionModifiers( data, panel )
	
	panel:SetTall(32*3)
	PanelApplyBackground(panel)
	
	local trlabel = vgui.Create( "DLabel", panel )
		trlabel:SetText( "Position:" )
		trlabel:SizeToContents()
		trlabel:SetWide(45)
	trlabel:Dock(LEFT)
	
	local mxwang = vgui.Create( "DNumSlider", panel )
		mxwang:SetText("x")
		mxwang:SetMinMax( -80, 80 )
		mxwang:SetDecimals( 3 )
		mxwang.Wang.ConVarChanged = function( p, value ) data.pos.x = tonumber(value) end
		mxwang:SetValue( data.pos.x )
	mxwang:DockMargin(10,0,0,0)
	
	local mywang = vgui.Create( "DNumSlider", panel )
		mywang:SetText("y") 
		mywang:SetMinMax( -80, 80 )
		mywang:SetDecimals( 3 )
		mywang.Wang.ConVarChanged = function( p, value ) data.pos.y = tonumber(value) end
		mywang:SetValue( data.pos.y )
	mywang:DockMargin(10,0,0,0)
	
	local mzwang = vgui.Create( "DNumSlider", panel )
		mzwang:SetText("z")
		mzwang:SetMinMax( -80, 80 )
		mzwang:SetDecimals( 3 )
		mzwang.Wang.ConVarChanged = function( p, value ) data.pos.z = tonumber(value) end
		mzwang:SetValue( data.pos.z )
	mzwang:DockMargin(10,0,0,0)
	
	panel.PerformLayout = function() 
		mxwang:SetWide(panel:GetWide()*4/15)
		mywang:SetWide(panel:GetWide()*4/15) 
		mzwang:SetWide(panel:GetWide()*4/15)
	end
	
	mxwang:Dock(TOP)
	mywang:Dock(TOP)
	mzwang:Dock(TOP)
	
	return panel
end

local function CreateAngleModifiers( data, panel )
	
	panel:SetTall(32*3)
	PanelApplyBackground(panel)
	
	local anlabel = vgui.Create( "DLabel", panel )
		anlabel:SetText( "Angle:" )
		anlabel:SizeToContents()
		anlabel:SetWide(45)
	anlabel:Dock(LEFT)
	
	local mpitchwang = vgui.Create( "DNumSlider", panel )
		mpitchwang:SetText("pitch")
		mpitchwang:SetMinMax( -180, 180 )
		mpitchwang:SetDecimals( 3 )
		mpitchwang.Wang.ConVarChanged = function( p, value ) data.angle.p = tonumber(value) end
		mpitchwang:SetValue( data.angle.p )
	mpitchwang:DockMargin(10,0,0,0)
	
	local myawwang = vgui.Create( "DNumSlider", panel )
		myawwang:SetText("yaw")
		myawwang:SetMinMax( -180, 180 )
		myawwang:SetDecimals( 3 )
		myawwang.Wang.ConVarChanged = function( p, value ) data.angle.y = tonumber(value) end
		myawwang:SetValue( data.angle.y )
	myawwang:DockMargin(10,0,0,0)
	
	local mrollwang = vgui.Create( "DNumSlider", panel )
		mrollwang:SetText("roll")
		mrollwang:SetMinMax( -180, 180 )
		mrollwang:SetDecimals( 3 )
		mrollwang.Wang.ConVarChanged = function( p, value ) data.angle.r = tonumber(value) end
		mrollwang:SetValue( data.angle.r )
	mrollwang:DockMargin(10,0,0,0)
	
	panel.PerformLayout = function() 
		mrollwang:SetWide(panel:GetWide()*4/15)
		myawwang:SetWide(panel:GetWide()*4/15) 
		mpitchwang:SetWide(panel:GetWide()*4/15)
	end
	
	mpitchwang:Dock(TOP)
	myawwang:Dock(TOP)
	mrollwang:Dock(TOP)
	
	return panel
end

local function CreateSizeModifiers( data, panel, dimensions )

	panel:SetTall(32*dimensions)
	PanelApplyBackground(panel)
	
	local sizelabel = vgui.Create( "DLabel", panel )
		sizelabel:SetText( "Size:" )
		sizelabel:SizeToContents()
		sizelabel:SetWide(45)
	sizelabel:Dock(LEFT)
	
	local msywang, mszwang
	
	local msxwang = vgui.Create( "DNumSlider", panel )
		msxwang:SetMinMax( 0.01, 10 )
		msxwang:SetDecimals( 3 )
		
	if (dimensions > 1 ) then
		
		msywang = vgui.Create( "DNumSlider", panel )
			msywang:SetText("y")
			msywang:SetMinMax( 0.01, 10 )
			msywang:SetDecimals( 3 )
			msywang.Wang.ConVarChanged = function( p, value ) data.size.y = tonumber(value) end
		msywang:DockMargin(10,0,0,0)
		msywang:Dock(TOP)
		
		if (dimensions > 2) then
			mszwang = vgui.Create( "DNumSlider", panel )
				mszwang:SetText("z")
				mszwang:SetMinMax( 0.01, 10 )
				mszwang:SetDecimals( 3 )
				mszwang.Wang.ConVarChanged = function( p, value ) data.size.z = tonumber(value) end
			mszwang:DockMargin(10,0,0,0)
			mszwang:Dock(TOP)
		end
		
	end
	
	// make the x numberwang set the total size
	msxwang.Wang.ConVarChanged = function( p, value )
		if (mszwang) then
			mszwang:SetValue( value )
		end
		if (msywang) then
			msywang:SetValue( value )
		end
		
		if (dimensions > 1) then
			data.size.x = tonumber(value)
		else
			data.size = tonumber(value)
		end
	end
	
	msxwang:DockMargin(10,0,0,0)
	msxwang:Dock(TOP)
	
	/*panel.PerformLayout = function() 
		msxwang:SetWide(panel:GetWide()*4/5/dimensions)
		if (dimensions > 1) then
			msywang:SetWide(panel:GetWide()*4/5/dimensions)
			if (dimensions > 2) then
				mszwang:SetWide(panel:GetWide()*4/15)
			end
		end
	end*/
	
	if (dimensions == 1) then
		
		msxwang:SetText("factor")
		msxwang:SetValue( data.size )
		
	else
	
		local new_y = data.size.y
		local new_z = data.size.z
		
		msxwang:SetText("x / y")
		msxwang:SetValue( data.size.x )
		msywang:SetValue( new_y )
		
		if (mszwang) then
			msxwang:SetText("x / y / z")
			mszwang:SetValue( new_z )
		end
		
	end
	
	return panel
end

local function CreateColorModifiers( data, panel )
	
	panel:SetTall(32*4)
	PanelApplyBackground(panel)
	
	local collabel = vgui.Create( "DLabel", panel )
		collabel:SetText( "Color:" )
		collabel:SizeToContents()
		collabel:SetWide(45)
	collabel:Dock(LEFT)
	
	local colrwang = vgui.Create( "DNumSlider", panel )
		colrwang:SetText("red")
		colrwang:SetMinMax( 0, 255 )
		colrwang:SetDecimals( 0 )
		colrwang.Wang.ConVarChanged = function( p, value ) data.color.r = tonumber(value) end
		colrwang:SetValue(data.color.r)
	colrwang:DockMargin(10,0,0,0)
	
	local colgwang = vgui.Create( "DNumSlider", panel )
		colgwang:SetText("green")
		colgwang:SetMinMax( 0, 255 )
		colgwang:SetDecimals( 0 )
		colgwang.Wang.ConVarChanged = function( p, value ) data.color.g = tonumber(value) end
		colgwang:SetValue(data.color.g)
	colgwang:DockMargin(10,0,0,0)
	
	local colbwang = vgui.Create( "DNumSlider", panel )
		colbwang:SetText("blue")
		colbwang:SetMinMax( 0, 255 )
		colbwang:SetDecimals( 0 )
		colbwang.Wang.ConVarChanged = function( p, value ) data.color.b = tonumber(value) end
		colbwang:SetValue(data.color.b)
	colbwang:DockMargin(10,0,0,0)
	
	local colawang = vgui.Create( "DNumSlider", panel )
		colawang:SetText("alpha")
		colawang:SetMinMax( 0, 255 )
		colawang:SetDecimals( 0 )
		colawang.Wang.ConVarChanged = function( p, value ) data.color.a = tonumber(value) end
		colawang:SetValue(data.color.a)
	colawang:DockMargin(10,0,0,0)
	
	panel.PerformLayout = function() 
		colawang:SetWide(panel:GetWide()/5)
		colbwang:SetWide(panel:GetWide()/5)
		colgwang:SetWide(panel:GetWide()/5)
		colrwang:SetWide(panel:GetWide()/5)
	end
	
	colrwang:Dock(TOP)
	colgwang:Dock(TOP)
	colbwang:Dock(TOP)
	colawang:Dock(TOP)
	
	return panel
end

local function CreateModelModifier( data, panel )
	
	panel:SetTall(20)
	
	local pmolabel = vgui.Create( "DLabel", panel )
		pmolabel:SetText( "Model:" )
		pmolabel:SetWide(60)
		pmolabel:SizeToContentsY()
	pmolabel:Dock(LEFT)
	
	local wtbtn = vgui.Create( "DButton", panel )
		wtbtn:SetSize( 25, 20 )
		wtbtn:SetText("...")
	wtbtn:Dock(RIGHT)
	
	local pmmtext = vgui.Create( "DTextEntry", panel )
		pmmtext:SetMultiline(false)
		pmmtext:SetToolTip("Path to the model file")
		pmmtext.OnTextChanged = function()
			local newmod = pmmtext:GetValue()
			if file.Exists(newmod, "GAME") then
				util.PrecacheModel(newmod)
				data.model = newmod
			end
		end
		pmmtext:SetText( data.model )
		pmmtext.OnTextChanged()
	pmmtext:DockMargin(10,0,0,0)
	pmmtext:Dock(FILL)
	
	wtbtn.DoClick = function()
		wep:OpenBrowser( data.model, "model", function( val ) pmmtext:SetText(val) pmmtext:OnTextChanged() end )
	end
	
	return panel
end

local function CreateSpriteModifier( data, panel )
	
	panel:SetTall(20)
	
	local pmolabel = vgui.Create( "DLabel", panel )
		pmolabel:SetText( "Sprite:" )
		pmolabel:SetWide(60)
		pmolabel:SizeToContentsY()
	pmolabel:Dock(LEFT)
	
	local wtbtn = vgui.Create( "DButton", panel )
		wtbtn:SetSize( 25, 20 )
		wtbtn:SetText("...")
	wtbtn:Dock(RIGHT)
	
	local pmmtext = vgui.Create( "DTextEntry", panel )
		pmmtext:SetMultiline(false)
		pmmtext:SetToolTip("Path to the sprite material")
		pmmtext.OnTextChanged = function()
			local newsprite = pmmtext:GetValue()
			if file.Exists("materials/"..newsprite..".vmt", "GAME") then
				data.sprite = newsprite
			end
		end
		pmmtext:SetText( data.sprite )
		pmmtext.OnTextChanged()
	pmmtext:DockMargin(10,0,0,0)
	pmmtext:Dock(FILL)
	
	wtbtn.DoClick = function()
		wep:OpenBrowser( data.sprite, "material", function( val ) pmmtext:SetText(val) pmmtext:OnTextChanged() end )
	end
		
	return panel
end

local function CreateNameLabel( name, panel )
	
	panel:SetTall(20)
	
	local pnmlabel = vgui.Create( "DLabel", panel )
		pnmlabel:SetText( "Name: "..name )
		pnmlabel:SizeToContents()
	pnmlabel:Dock(LEFT)
	
	/*local pnmtext = vgui.Create( "DTextEntry", panel )
		pnmtext:SetMultiline(false)
		pnmtext:SetText( name )
		pnmtext:SetEditable( false )
	pnmtext:Dock(FILL)*/
	
	return panel
end

local function CreateParamModifiers( data, panel )
	
	panel:SetTall(45)
	
	local strip1 = SimplePanel( panel )
	strip1:SetTall(20)
	
		local ncchbox = vgui.Create( "DCheckBoxLabel", strip1 )
			ncchbox:SetText("$nocull")
			ncchbox:SizeToContents()
			ncchbox:SetValue( 0 )
			ncchbox.OnChange = function()
				data.nocull = ncchbox:GetChecked()
				data.spriteMaterial = nil // dump old material
			end
			if (data.nocull) then ncchbox:SetValue( 1 ) end
		ncchbox:DockMargin(0,0,10,0)
		ncchbox:Dock(LEFT)
		
		local adchbox = vgui.Create( "DCheckBoxLabel", strip1 )
			adchbox:SetText("$additive")
			adchbox:SizeToContents()
			adchbox:SetValue( 0 )
			adchbox.OnChange = function()
				data.additive = adchbox:GetChecked()
				data.spriteMaterial = nil // dump old material
			end
			if (data.additive) then adchbox:SetValue( 1 ) end
		adchbox:DockMargin(0,0,10,0)
		adchbox:Dock(LEFT)
		
		local vtachbox = vgui.Create( "DCheckBoxLabel", strip1 )
			vtachbox:SetText("$vertexalpha")
			vtachbox:SizeToContents()
			vtachbox:SetValue( 0 )
			vtachbox.OnChange = function()
				data.vertexalpha = vtachbox:GetChecked()
				data.spriteMaterial = nil // dump old material
			end
			if (data.vertexalpha) then vtachbox:SetValue( 1 ) end
		vtachbox:DockMargin(0,0,10,0)
		vtachbox:Dock(LEFT)
		
	strip1:DockMargin(0,0,0,5)
	strip1:Dock(TOP)
	
	local strip2 = SimplePanel( panel )
	strip2:SetTall(20)
	
		local vtcchbox = vgui.Create( "DCheckBoxLabel", strip2 )
			vtcchbox:SetText("$vertexcolor")
			vtcchbox:SizeToContents()
			vtcchbox:SetValue( 0 )
			vtcchbox.OnChange = function()
				data.vertexcolor = vtcchbox:GetChecked()
				data.spriteMaterial = nil // dump old material
			end
			if (data.vertexcolor) then vtcchbox:SetValue( 1 ) end
		vtcchbox:DockMargin(0,0,10,0)
		vtcchbox:Dock(LEFT)
		
		local izchbox = vgui.Create( "DCheckBoxLabel", strip2 )
			izchbox:SetText("$ignorez")
			izchbox:SizeToContents()
			izchbox:SetValue( 0 )
			izchbox.OnChange = function()
				data.ignorez = izchbox:GetChecked()
				data.spriteMaterial = nil // dump old material
			end
			if (data.ignorez) then izchbox:SetValue( 1 ) end
		izchbox:DockMargin(0,0,10,0)
		izchbox:Dock(LEFT)
		
	strip2:Dock(TOP)
	
	return panel
end

local function CreateMaterialModifier( data, panel )
	
	panel:SetTall(20)
	
	local matlabel = vgui.Create( "DLabel", panel )
		matlabel:SetText( "Material:" )
		matlabel:SetWide(60)
		matlabel:SizeToContentsY()
	matlabel:Dock(LEFT)	
	
	local wtbtn = vgui.Create( "DButton", panel )
		wtbtn:SetSize( 25, 20 )
		wtbtn:SetText("...")
	wtbtn:Dock(RIGHT)
	
	local mattext = vgui.Create("DTextEntry", panel )
		mattext:SetMultiline(false)
		mattext:SetToolTip("Path to the material file")
		mattext.OnTextChanged = function()
			local newmat = mattext:GetValue()
			if file.Exists("materials/"..newmat..".vmt", "GAME") then
				data.material = newmat
			else
				data.material = ""
			end
		end
		mattext:SetText( data.material )
	mattext:DockMargin(10,0,0,0)
	mattext:Dock(FILL)
	
	wtbtn.DoClick = function()
		wep:OpenBrowser( data.material, "material", function( val ) mattext:SetText(val) mattext:OnTextChanged() end )
	end
	
	return panel
end

local function CreateSLightningModifier( data, panel )

	local lschbox = vgui.Create( "DCheckBoxLabel", panel )
		lschbox:SetText("Surpress engine lightning")
		lschbox:SizeToContents()
		lschbox.OnChange = function()
			data.surpresslightning = lschbox:GetChecked()
		end
		if (data.surpresslightning) then
			lschbox:SetValue( 1 )
		else
			lschbox:SetValue( 0 )
		end
	lschbox:Dock(LEFT)
	
	return panel
end

local function CreateBoneModifier( data, panel, ent )
	
	local pbonelabel = vgui.Create( "DLabel", panel )
		pbonelabel:SetText( "Bone:" )
		pbonelabel:SetWide(60)
		pbonelabel:SizeToContentsY()
	pbonelabel:Dock(LEFT)
	
	local bonebox = vgui.Create( "DComboBox", panel )
		bonebox:SetToolTip("Bone to parent the selected element to. Is ignored if the 'Relative' field is not empty")
		bonebox.OnSelect = function( p, index, value )
			data.bone = value
		end
		bonebox:SetText( data.bone )
	bonebox:DockMargin(10,0,0,0)
	bonebox:Dock(FILL)
	
	local delay = 0
	// we have to call it later when loading settings because the viewmodel needs to be changed first
	if (data.bone != "") then delay = 2 end
	
	timer.Simple(delay, function()
		local option = PopulateBoneList( bonebox, ent )
		if (option and data.bone == "") then 
			bonebox:ChooseOptionID(1)
		end
	end)
	
	return panel
end

local function CreateVRelativeModifier( name, data, panel )
	
	local prellabel = vgui.Create( "DLabel", panel )
		prellabel:SetText( "Relative:" )
		prellabel:SetWide(60)
		prellabel:SizeToContentsY()
	prellabel:Dock(LEFT)
	
	local relbox = vgui.Create( "DComboBox", panel )
		relbox:SetToolTip("Element you want to parent this element to (position and angle become relative). Overrides parenting to a bone if not blank.")
		relbox.OnSelect = function( p, index, value )
			data.rel = value
		end
	relbox:DockMargin(10,0,0,0)
	relbox:Dock(FILL)
	
	RegisterRelBox(name, relbox, "v", data.rel)
	
	return panel
end

local function CreateWRelativeModifier( name, data, panel )
	
	local prellabel = vgui.Create( "DLabel", panel )
		prellabel:SetText( "Relative:" )
		prellabel:SetWide(60)
		prellabel:SizeToContentsY()
	prellabel:Dock(LEFT)
	
	local relbox = vgui.Create( "DComboBox", panel )
		relbox:SetToolTip("Element you want to parent this element to (position and angle become relative). Overrides parenting to a bone if not blank.")
		relbox.OnSelect = function( p, index, value )
			data.rel = value
		end
	relbox:DockMargin(10,0,0,0)
	relbox:Dock(FILL)
	
	RegisterRelBox(name, relbox, "w", data.rel)
	
	return panel
end

local function CreateBodygroupSkinModifier( data, panel )

	local bdlabel = vgui.Create( "DLabel", panel )
		bdlabel:SetText( "Bodygroup:" )
		bdlabel:SizeToContents()
	bdlabel:Dock(LEFT)
	
	local bdwang = vgui.Create( "DNumberWang", panel )
		bdwang:SetSize( 30, 20 )
		bdwang:SetMinMax( 1, 9 )
		bdwang:SetDecimals( 0 )
		bdwang:SetToolTip("Bodygroup number")
	bdwang:DockMargin(10,0,0,0)
	bdwang:Dock(LEFT)
	
	local islabel = vgui.Create( "DLabel", panel )
		islabel:SetSize( 10, 20 )
		islabel:SetText( "=" )
	islabel:DockMargin(1,0,1,0)
	islabel:Dock(LEFT)
	
	local bdvwang = vgui.Create( "DNumberWang", panel )
		bdvwang:SetSize( 30, 20 )
		bdvwang:SetMinMax( 0, 9 )
		bdvwang:SetDecimals( 0 )
		bdvwang:SetToolTip("State number")
	bdvwang:Dock(LEFT)
	
	bdvwang.ConVarChanged = function( p, value ) 
		local group = tonumber(bdwang:GetValue())
		local val = tonumber(value)
		data.bodygroup[group] = val
	end
	bdvwang:SetValue(0)

	bdwang.ConVarChanged = function( p, value )
		local group = tonumber(value)
		if (group < 1) then return end
		local setval = data.bodygroup[group] or 0
		bdvwang:SetValue(setval)
	end
	bdwang:SetValue(1)

	local sklabel = vgui.Create( "DLabel", panel )
		sklabel:SetText( "Skin:" )
		sklabel:SizeToContents()
	sklabel:DockMargin(50,0,0,0)
	sklabel:Dock(LEFT)
	
	local skwang = vgui.Create( "DNumberWang", panel )
		skwang:SetSize( 30, 20 )
		skwang:SetMin( 0 )
		skwang:SetMax( 9 )
		skwang:SetDecimals( 0 )
		skwang.ConVarChanged = function( p, value ) data.skin = tonumber(value) end
		skwang:SetValue(data.skin)
	skwang:DockMargin(10,0,0,0)
	skwang:Dock(LEFT)
	
	return panel
end

/*** Model panel for adjusting models ***
Name:
Model:
Bone name:
Translation x / y / z
Rotation pitch / yaw / role
Model size x / y / z
Material
Color modulation
*/
local function CreateModelPanel( name, preset_data )
	
	local data = wep.v_models[name]
	if (!preset_data) then preset_data = {} end
	
	// default data
	data.type = preset_data.type or "Model"
	data.model = preset_data.model or ""
	data.bone = preset_data.bone or ""
	data.rel = preset_data.rel or ""
	data.pos = preset_data.pos or Vector(0,0,0)
	data.angle = preset_data.angle or Angle(0,0,0)
	data.size = preset_data.size or Vector(0.5,0.5,0.5)
	data.color = preset_data.color or Color(255,255,255,255)
	data.surpresslightning = preset_data.surpresslightning or false
	data.material = preset_data.material or ""
	data.bodygroup = preset_data.bodygroup or {}
	data.skin = preset_data.skin or 0
	
	wep.vRenderOrder = nil // force viewmodel render order to recache
	
	local panellist = vgui.Create("DPanelList", pmodels )
	panellist:SetPaintBackground( true )
		panellist.Paint = function() surface.SetDrawColor( 90, 90, 90, 255 ) surface.DrawRect( 0, 0, panellist:GetWide(), panellist:GetTall() ) end
		panellist:EnableVerticalScrollbar( true )
		panellist:SetSpacing(5)
		panellist:SetPadding(5)
	panellist:DockMargin(0,0,0,5)
	panellist:Dock(FILL)
	
	PanelBackgroundReset()
	
	panellist:AddItem(CreateNameLabel( name, SimplePanel(panellist) ))
	panellist:AddItem(CreateModelModifier( data, SimplePanel(panellist) ))
	panellist:AddItem(CreateBoneModifier( data, SimplePanel(panellist), LocalPlayer():GetViewModel() ))
	panellist:AddItem(CreateVRelativeModifier( name, data, SimplePanel(panellist) ))
	panellist:AddItem(CreatePositionModifiers( data, SimplePanel(panellist) ))
	panellist:AddItem(CreateAngleModifiers( data, SimplePanel(panellist) ))
	panellist:AddItem(CreateSizeModifiers( data, SimplePanel(panellist), 3 ))
	panellist:AddItem(CreateColorModifiers( data, SimplePanel(panellist) ))
	panellist:AddItem(CreateSLightningModifier( data, SimplePanel(panellist) ))
	panellist:AddItem(CreateMaterialModifier( data, SimplePanel(panellist) ))
	panellist:AddItem(CreateBodygroupSkinModifier( data, SimplePanel(panellist) ))
	
	return panellist
	
end

/*** Sprite panel for adjusting sprites ***
Name:
Sprite:
Bone name:
Translation x / y / z
Sprite x / y size
Color
*/
local function CreateSpritePanel( name, preset_data )
	
	local data = wep.v_models[name]
	if (!preset_data) then preset_data = {} end
	
	// default data
	data.type = preset_data.type or "Sprite"
	data.sprite = preset_data.sprite or ""
	data.bone = preset_data.bone or ""
	data.rel = preset_data.rel or ""
	data.pos = preset_data.pos or Vector(0,0,0)
	data.size = preset_data.size or { x = 1, y = 1 }
	data.color = preset_data.color or Color(255,255,255,255)
	data.nocull = preset_data.nocull or true
	data.additive = preset_data.additive or true
	data.vertexalpha = preset_data.vertexalpha or true
	data.vertexcolor = preset_data.vertexcolor or true
	data.ignorez = preset_data.ignorez or false
	
	wep.vRenderOrder = nil
	
	local panellist = vgui.Create("DPanelList", pmodels )
	panellist:SetPaintBackground( true )
		panellist.Paint = function() surface.SetDrawColor( 90, 90, 90, 255 ) surface.DrawRect( 0, 0, panellist:GetWide(), panellist:GetTall() ) end
		panellist:EnableVerticalScrollbar( true )
		panellist:SetSpacing(5)
		panellist:SetPadding(5)
	panellist:DockMargin(0,0,0,5)
	panellist:Dock(FILL)
	
	PanelBackgroundReset()
	
	panellist:AddItem(CreateNameLabel( name,SimplePanel(panellist) ))
	panellist:AddItem(CreateSpriteModifier( data, SimplePanel(panellist) ))
	panellist:AddItem(CreateBoneModifier( data, SimplePanel(panellist), LocalPlayer():GetViewModel() ))
	panellist:AddItem(CreateVRelativeModifier( name, data, SimplePanel(panellist) ))
	panellist:AddItem(CreatePositionModifiers( data, SimplePanel(panellist) ))
	panellist:AddItem(CreateSizeModifiers( data, SimplePanel(panellist), 2 ))
	panellist:AddItem(CreateColorModifiers( data, SimplePanel(panellist) ))
	panellist:AddItem(CreateParamModifiers( data, SimplePanel(panellist) ))
	
	return panellist
	
end

/*** Model panel for adjusting models ***
Name:
Model:
Bone name:
Translation x / y / z
Rotation pitch / yaw / role
Size
*/
local function CreateQuadPanel( name, preset_data )
	
	local data = wep.v_models[name]
	if (!preset_data) then preset_data = {} end
	
	// default data
	data.type = preset_data.type or "Quad"
	data.model = preset_data.model or ""
	data.bone = preset_data.bone or ""
	data.rel = preset_data.rel or ""
	data.pos = preset_data.pos or Vector(0,0,0)
	data.angle = preset_data.angle or Angle(0,0,0)
	data.size = preset_data.size or 0.05

	wep.vRenderOrder = nil // force viewmodel render order to recache
	
	local panellist = vgui.Create("DPanelList", pmodels )
	panellist:SetPaintBackground( true )
		panellist.Paint = function() surface.SetDrawColor( 90, 90, 90, 255 ) surface.DrawRect( 0, 0, panellist:GetWide(), panellist:GetTall() ) end
		panellist:EnableVerticalScrollbar( true )
		panellist:SetSpacing(5)
		panellist:SetPadding(5)
	panellist:DockMargin(0,0,0,5)
	panellist:Dock(FILL)
	
	PanelBackgroundReset()
	
	panellist:AddItem(CreateNameLabel( name, SimplePanel(panellist) ))
	panellist:AddItem(CreateBoneModifier( data, SimplePanel(panellist), LocalPlayer():GetViewModel() ))
	panellist:AddItem(CreateVRelativeModifier( name, data, SimplePanel(panellist) ))
	panellist:AddItem(CreatePositionModifiers( data, SimplePanel(panellist) ))
	panellist:AddItem(CreateAngleModifiers( data, SimplePanel(panellist) ))
	panellist:AddItem(CreateSizeModifiers( data, SimplePanel(panellist), 1 ))
	
	return panellist
	
end

// adding button DoClick
mnbtn.DoClick = function()
	local new = string.Trim( mntext:GetValue() )
	if (new) then
		if (new == "") then CreateNote("Empty name field!") return end
		if (wep.v_models[new] != nil) then CreateNote("Name already exists!") return end
		wep.v_models[new] = {}
		
		if (!wep.v_panelCache[new]) then
			if (boxselected == "Model") then
				wep.v_panelCache[new] = CreateModelPanel( new )
			elseif (boxselected == "Sprite") then
				wep.v_panelCache[new] = CreateSpritePanel( new )
			elseif (boxselected == "Quad") then
				wep.v_panelCache[new] = CreateQuadPanel( new )
			else
				Error("wtf are u doing")
			end
		end
		
		wep.v_panelCache[new]:SetVisible(false)
		
		table.insert(v_relelements, new)
		UpdateRelBoxes("v")
		
		mlist:AddLine(new,boxselected)
	end
end

for k, v in pairs( wep.save_data.v_models ) do
	wep.v_models[k] = {}
	if (v.type == "Model") then
		wep.v_panelCache[k] = CreateModelPanel( k, v )
	elseif (v.type == "Sprite") then
		wep.v_panelCache[k] = CreateSpritePanel( k, v )
	elseif (v.type == "Quad") then
		wep.v_panelCache[k] = CreateQuadPanel( k, v )
	end
	wep.v_panelCache[k]:SetVisible(false)
	
	table.insert(v_relelements, k)
	mlist:AddLine(k,v.type)

end
UpdateRelBoxes("v")

// remove a line
rmbtn.DoClick = function()
	local line = mlist:GetSelectedLine()
	if (line) then
		local name = mlist:GetLine(line):GetValue(1)
		wep.v_models[name] = nil
		// clear from panel cache
		if (wep.v_panelCache[name]) then 
			wep.v_panelCache[name]:Remove()
			wep.v_panelCache[name] = nil
			
			table.RemoveByValue( v_relelements, name )
			RemoveRelBox( "v", name )
			UpdateRelBoxes( "v" )
		end
		mlist:RemoveLine(line)
	end
end

// duplicate line
copybtn.DoClick = function()
	local line = mlist:GetSelectedLine()
	if (line) then
		local name = mlist:GetLine(line):GetValue(1)
		local to_copy = wep.v_models[name]
		local new_preset = table.Copy(to_copy)
		
		// quickly generate a new unique name
		while(wep.v_models[name]) do
			name = name.."+"
		end
		
		// have to fix every sub-table as well because table.Copy copies references
		new_preset.pos = Vector(to_copy.pos.x, to_copy.pos.y, to_copy.pos.z)
		if (to_copy.angle) then
			new_preset.angle = Angle(to_copy.angle.p, to_copy.angle.y, to_copy.angle.r)
		end
		if (to_copy.color) then
			new_preset.color = Color(to_copy.color.r,to_copy.color.g,to_copy.color.b,to_copy.color.a)
		end
		if (type(to_copy.size) == "table") then
			new_preset.size = table.Copy(to_copy.size)
		elseif (type(to_copy.size) == "Vector") then
			new_preset.size = Vector(to_copy.size.x, to_copy.size.y, to_copy.size.z)
		end
		if (to_copy.bodygroup) then
			new_preset.bodygroup = table.Copy(to_copy.bodygroup)
		end
		
		wep.v_models[name] = {}
		
		if (new_preset.type == "Model") then
			wep.v_panelCache[name] = CreateModelPanel( name, new_preset )
		elseif (new_preset.type == "Sprite") then
			wep.v_panelCache[name] = CreateSpritePanel( name, new_preset )
		elseif (new_preset.type == "Quad") then
			wep.v_panelCache[name] = CreateQuadPanel( name, new_preset )
		end
		
		wep.v_panelCache[name]:SetVisible(false)
		
		table.insert(v_relelements, name)
		UpdateRelBoxes("v")
		
		mlist:AddLine(name,new_preset.type)
	end
end



/*//////////////////////////////////////////////////////////////

					World Models

/////////////////////////////////////////////////////////////*/

local lastVisible = ""

local mlabel = vgui.Create( "DLabel", pwmodels )
	mlabel:SetTall( 20 )
	mlabel:SetText( "New worldmodel element:" )
mlabel:Dock(TOP)

local function CreateWNote( text )
	local templabel = vgui.Create( "DLabel" )
		templabel:SetText( text )
		templabel:SizeToContents()

	local x, y = mlabel:GetPos()
	local notif = vgui.Create( "DNotify" , pwmodels )
		notif:SetPos( x + 160, y )
		notif:SetSize( templabel:GetWide(), 20 )
		notif:SetLife( 5 )
		notif:AddItem(templabel)
end

local pnewelement = SimplePanel( pwmodels )
pnewelement:SetTall(20)

	local mnwtext = vgui.Create("DTextEntry", pnewelement )
		mnwtext:SetTall( 20 )
		mnwtext:SetMultiline(false)
		mnwtext:SetText( "element_name" )
	mnwtext:Dock(FILL)
	
	local mnwbtn = vgui.Create( "DButton", pnewelement )
		mnwbtn:SetSize( 50, 20 )
		mnwbtn:SetText( "Add" )
	mnwbtn:DockMargin(5,0,0,0)
	mnwbtn:Dock(RIGHT)
	
	local tpbox = vgui.Create( "DComboBox", pnewelement )
		tpbox:SetSize( 100, 20 )
		tpbox:SetText( "Model" )
		tpbox:AddChoice( "Model" )
		tpbox:AddChoice( "Sprite" )
		tpbox:AddChoice( "Quad" )
		local wboxselected = "Model"
		tpbox.OnSelect = function( p, index, value )
			wboxselected = value
		end
	tpbox:DockMargin(5,0,0,0)
	tpbox:Dock(RIGHT)

pnewelement:DockMargin(0,5,0,5)
pnewelement:Dock(TOP)

local mwlist = vgui.Create( "DListView", pwmodels)
	wep.w_modelListing = mwlist
	
	mwlist:SetTall( 160 )
	mwlist:SetMultiSelect(false)
	mwlist:SetDrawBackground(true)
	mwlist:AddColumn("Name")
	mwlist:AddColumn("Type")
	// cache the created panels
	mwlist.OnRowSelected = function( panel, line )
		local name = mwlist:GetLine(line):GetValue(1)
	
		if (wep.w_panelCache[lastVisible]) then
			wep.w_panelCache[lastVisible]:SetVisible(false)
		end
		wep.w_panelCache[name]:SetVisible(true)
		
		lastVisible = name
	end

mwlist:Dock(TOP)

local pwbuttons = SimplePanel( pwmodels )

	local rmbtn = vgui.Create( "DButton", pwbuttons )
		rmbtn:SetSize( 140, 25 )
		rmbtn:SetText( "Remove selected" )
	rmbtn:Dock(LEFT)
	
	local copybtn = vgui.Create( "DButton", pwbuttons )
		copybtn:SetSize( 140, 25 )
		copybtn:SetText( "Copy selected" )
	copybtn:Dock(RIGHT)
	
	local importbtn = vgui.Create( "DButton", pwbuttons )
		importbtn:SetTall( 25 )
		importbtn:SetText( "Import viewmodels" )
	importbtn:Dock(FILL)

pwbuttons:DockMargin(0,5,0,5)
pwbuttons:Dock(TOP)

// Print buttons
local pctbtn = vgui.Create( "DButton", pwmodels)
	pctbtn:SetTall( 30 )
	pctbtn:SetText("Copy world model table to clipboard")
	pctbtn.DoClick = function()
		SetClipboardText(GetWModelsText())
		LocalPlayer():ChatPrint("Code copied to clipboard!")
	end
pctbtn:DockMargin(0,5,0,0)
pctbtn:Dock(BOTTOM)

local prtbtn = vgui.Create( "DButton", pwmodels)
	prtbtn:SetTall( 30 )
	prtbtn:SetText("Print world model table to console")
	prtbtn.DoClick = function()
		MsgN("*********************************************")
		for k, v in pairs(string.Explode("\n",GetWModelsText())) do
			MsgN(v)
		end
		MsgN("*********************************************")
		LocalPlayer():ChatPrint("Code printed to console!")
	end
prtbtn:Dock(BOTTOM)

/*** Model panel for adjusting models ***
Name:
Model:
Translation x / y / z
Rotation pitch / yaw / role
Model size x / y / z
Material
Color modulation
*/
local function CreateWorldModelPanel( name, preset_data )
	
	local data = wep.w_models[name]
	if (!preset_data) then preset_data = {} end
	
	// default data
	data.type = preset_data.type or "Model"
	data.model = preset_data.model or ""
	data.bone = preset_data.bone or "ValveBiped.Bip01_R_Hand"
	data.rel = preset_data.rel or ""
	data.pos = preset_data.pos or Vector(0,0,0)
	data.angle = preset_data.angle or Angle(0,0,0)
	data.size = preset_data.size or Vector(0.5,0.5,0.5)
	data.color = preset_data.color or Color(255,255,255,255)
	data.surpresslightning = preset_data.surpresslightning or false
	data.material = preset_data.material or ""
	data.bodygroup = preset_data.bodygroup or {}
	data.skin = preset_data.skin or 0
	
	wep.wRenderOrder = nil
	
	local panellist = vgui.Create("DPanelList", pwmodels )
	panellist:SetPaintBackground( true )
		panellist.Paint = function() surface.SetDrawColor( 90, 90, 90, 255 ) surface.DrawRect( 0, 0, panellist:GetWide(), panellist:GetTall() ) end
		panellist:EnableVerticalScrollbar( true )
		panellist:SetSpacing(5)
		panellist:SetPadding(5)
	panellist:DockMargin(0,0,0,5)
	panellist:Dock(FILL)
	
	PanelBackgroundReset()
	
	panellist:AddItem(CreateNameLabel( name, SimplePanel(panellist) ))
	panellist:AddItem(CreateModelModifier( data, SimplePanel(panellist) ))
	panellist:AddItem(CreateBoneModifier( data, SimplePanel(panellist), LocalPlayer() ))
	panellist:AddItem(CreateWRelativeModifier( name, data, SimplePanel(panellist) ))
	panellist:AddItem(CreatePositionModifiers( data, SimplePanel(panellist) ))
	panellist:AddItem(CreateAngleModifiers( data, SimplePanel(panellist) ))
	panellist:AddItem(CreateSizeModifiers( data, SimplePanel(panellist), 3 ))
	panellist:AddItem(CreateColorModifiers( data, SimplePanel(panellist) ))
	panellist:AddItem(CreateSLightningModifier( data, SimplePanel(panellist) ))
	panellist:AddItem(CreateMaterialModifier( data, SimplePanel(panellist) ))
	panellist:AddItem(CreateBodygroupSkinModifier( data, SimplePanel(panellist) ))
	
	return panellist
	
end

/*** Sprite panel for adjusting sprites ***
Name:
Sprite:
Translation x / y / z
Sprite x / y size
Color
*/
local function CreateWorldSpritePanel( name, preset_data )
	
	local data = wep.w_models[name]
	if (!preset_data) then preset_data = {} end
	
	// default data
	data.type = preset_data.type or "Sprite"
	data.sprite = preset_data.sprite or ""
	data.bone = preset_data.bone or "ValveBiped.Bip01_R_Hand"
	data.rel = preset_data.rel or ""
	data.pos = preset_data.pos or Vector(0,0,0)
	data.size = preset_data.size or { x = 1, y = 1 }
	data.color = preset_data.color or Color(255,255,255,255)
	data.nocull = preset_data.nocull or true
	data.additive = preset_data.additive or true
	data.vertexalpha = preset_data.vertexalpha or true
	data.vertexcolor = preset_data.vertexcolor or true
	data.ignorez = preset_data.ignorez or false
	
	wep.wRenderOrder = nil
	
	local panellist = vgui.Create("DPanelList", pwmodels )
	panellist:SetPaintBackground( true )
		panellist.Paint = function() surface.SetDrawColor( 90, 90, 90, 255 ) surface.DrawRect( 0, 0, panellist:GetWide(), panellist:GetTall() ) end
		panellist:EnableVerticalScrollbar( true )
		panellist:SetSpacing(5)
		panellist:SetPadding(5)
	panellist:DockMargin(0,0,0,5)
	panellist:Dock(FILL)
	
	PanelBackgroundReset()
	
	panellist:AddItem(CreateNameLabel( name, SimplePanel(panellist) ))
	panellist:AddItem(CreateSpriteModifier( data, SimplePanel(panellist) ))
	panellist:AddItem(CreateBoneModifier( data, SimplePanel(panellist), LocalPlayer() ))
	panellist:AddItem(CreateWRelativeModifier( name, data, SimplePanel(panellist) ))
	panellist:AddItem(CreatePositionModifiers( data, SimplePanel(panellist) ))
	panellist:AddItem(CreateSizeModifiers( data, SimplePanel(panellist), 2 ))
	panellist:AddItem(CreateColorModifiers( data, SimplePanel(panellist) ))
	panellist:AddItem(CreateParamModifiers( data, SimplePanel(panellist) ))
	
	return panellist
	
end

/*** Model panel for adjusting models ***
Name:
Model:
Bone name:
Translation x / y / z
Rotation pitch / yaw / role
Size
*/
local function CreateWorldQuadPanel( name, preset_data )
	
	local data = wep.w_models[name]
	if (!preset_data) then preset_data = {} end
	
	// default data
	data.type = preset_data.type or "Quad"
	data.model = preset_data.model or ""
	data.bone = preset_data.bone or "ValveBiped.Bip01_R_Hand"
	data.rel = preset_data.rel or ""
	data.pos = preset_data.pos or Vector(0,0,0)
	data.angle = preset_data.angle or Angle(0,0,0)
	data.size = preset_data.size or 0.05

	wep.vRenderOrder = nil // force viewmodel render order to recache
	
	local panellist = vgui.Create("DPanelList", pwmodels )
	panellist:SetPaintBackground( true )
		panellist.Paint = function() surface.SetDrawColor( 90, 90, 90, 255 ) surface.DrawRect( 0, 0, panellist:GetWide(), panellist:GetTall() ) end
		panellist:EnableVerticalScrollbar( true )
		panellist:SetSpacing(5)
		panellist:SetPadding(5)
	panellist:DockMargin(0,0,0,5)
	panellist:Dock(FILL)
	
	PanelBackgroundReset()
	
	panellist:AddItem(CreateNameLabel( name, SimplePanel(panellist) ))
	panellist:AddItem(CreateBoneModifier( data, SimplePanel(panellist), LocalPlayer() ))
	panellist:AddItem(CreateWRelativeModifier( name, data, SimplePanel(panellist) ))
	panellist:AddItem(CreatePositionModifiers( data, SimplePanel(panellist) ))
	panellist:AddItem(CreateAngleModifiers( data, SimplePanel(panellist) ))
	panellist:AddItem(CreateSizeModifiers( data, SimplePanel(panellist), 1 ))
	
	return panellist
	
end

// adding button DoClick
mnwbtn.DoClick = function()
	local new = string.Trim( mnwtext:GetValue() )
	if (new) then
		if (new == "") then CreateWNote("Empty name field!") return end
		if (wep.w_models[new] != nil) then CreateWNote("Name already exists!") return end
		wep.w_models[new] = {}
		
		if (!wep.w_panelCache[new]) then
			if (wboxselected == "Model") then
				wep.w_panelCache[new] = CreateWorldModelPanel( new )
			elseif (wboxselected == "Sprite") then
				wep.w_panelCache[new] = CreateWorldSpritePanel( new )
			elseif (wboxselected == "Quad") then
				wep.w_panelCache[new] = CreateWorldQuadPanel( new )
			else
				Error("wtf are u doing")
			end
		end
		
		wep.w_panelCache[new]:SetVisible(false)
		
		table.insert(w_relelements, new)
		UpdateRelBoxes("w")
		
		mwlist:AddLine(new,wboxselected)
	end
end

for k, v in pairs( wep.save_data.w_models ) do
	wep.w_models[k] = {}
	
	// backwards compatability
	if (!v.bone or v.bone == "") then
		v.bone = "ValveBiped.Bip01_R_Hand"
	end
	
	if (v.type == "Model") then
		wep.w_panelCache[k] = CreateWorldModelPanel( k, v )
	elseif (v.type == "Sprite") then
		wep.w_panelCache[k] = CreateWorldSpritePanel( k, v )
	elseif (v.type == "Quad") then
		wep.w_panelCache[k] = CreateWorldQuadPanel( k, v )
	end			
	wep.w_panelCache[k]:SetVisible(false)
	table.insert(w_relelements, k)
	
	mwlist:AddLine(k,v.type)

end
UpdateRelBoxes("w")

// import viewmodels
importbtn.DoClick = function()
	local num = 0
	for k, v in pairs( wep.v_models ) do
		local name = k
		local i = 1
		while(wep.w_models[name] != nil) do
			name = k..""..i
			i = i + 1
			
			// changing names might mess up the relative transitions of some stuff
			// but whatever.
		end
		
		local new_preset = table.Copy(v)
		new_preset.bone = "ValveBiped.Bip01_R_Hand" // switch to hand bone by default
		
		if (new_preset.rel and new_preset.rel != "") then
			new_preset.pos = Vector(v.pos.x, v.pos.y, v.pos.z)
			if (v.angle) then
				new_preset.angle = Angle(v.angle.p, v.angle.y, v.angle.r)
			end
		else
			new_preset.pos = Vector(num*5,0,-10)
			if (v.angle) then
				new_preset.angle = Angle(0,0,0)
			end
		end
		
		if (v.color) then
			new_preset.color = Color(v.color.r,v.color.g,v.color.b,v.color.a)
		end
		if (type(v.size) == "table") then
			new_preset.size = table.Copy(v.size)
		elseif (type(v.size) == "Vector") then
			new_preset.size = Vector(v.size.x, v.size.y, v.size.z)
		end
		if (v.bodygroup) then
			new_preset.bodygroup = table.Copy(v.bodygroup)
		end
		
		wep.w_models[name] = {}
		if (v.type == "Model") then
			wep.w_panelCache[name] = CreateWorldModelPanel( name, new_preset )
		elseif (v.type == "Sprite") then
			wep.w_panelCache[name] = CreateWorldSpritePanel( name, new_preset )
		elseif (v.type == "Quad") then
			wep.w_panelCache[name] = CreateWorldQuadPanel( name, new_preset )
		end				
		wep.w_panelCache[name]:SetVisible(false)
		
		table.insert(w_relelements, name)
		UpdateRelBoxes("w")
		
		mwlist:AddLine(name,v.type)
		
		num = num + 1
	end
end

// remove a line
rmbtn.DoClick = function()
	local line = mwlist:GetSelectedLine()
	if (line) then
		local name = mwlist:GetLine(line):GetValue(1)
		wep.w_models[name] = nil
		// clear from panel cache
		if (wep.w_panelCache[name]) then 
			wep.w_panelCache[name]:Remove()
			wep.w_panelCache[name] = nil
			
			table.RemoveByValue( w_relelements, name )
			RemoveRelBox( "w", name )
			UpdateRelBoxes( "w" )
		end
		mwlist:RemoveLine(line)
	end
end

// duplicate line
copybtn.DoClick = function()
	local line = mwlist:GetSelectedLine()
	if (line) then
		local name = mwlist:GetLine(line):GetValue(1)
		local to_copy = wep.w_models[name]
		local new_preset = table.Copy(to_copy)
		
		// quickly generate a new unique name
		while(wep.w_models[name]) do
			name = name.."+"
		end
		
		// have to fix every sub-table as well because table.Copy copies references
		new_preset.pos = Vector(to_copy.pos.x, to_copy.pos.y, to_copy.pos.z)
		if (to_copy.angle) then
			new_preset.angle = Angle(to_copy.angle.p, to_copy.angle.y, to_copy.angle.r)
		end
		if (to_copy.color) then
			new_preset.color = Color(to_copy.color.r,to_copy.color.g,to_copy.color.b,to_copy.color.a)
		end
		if (type(to_copy.size) == "table") then
			new_preset.size = table.Copy(to_copy.size)
		elseif (type(to_copy.size) == "Vector") then
			new_preset.size = Vector(to_copy.size.x, to_copy.size.y, to_copy.size.z)
		end
		if (to_copy.bodygroup) then
			new_preset.bodygroup = table.Copy(to_copy.bodygroup)
		end
		
		wep.w_models[name] = {}
		
		if (new_preset.type == "Model") then
			wep.w_panelCache[name] = CreateWorldModelPanel( name, new_preset )
		elseif (new_preset.type == "Sprite") then
			wep.w_panelCache[name] = CreateWorldSpritePanel( name, new_preset )
		elseif (new_preset.type == "Quad") then
			wep.w_panelCache[name] = CreateWorldQuadPanel( name, new_preset )
		end
		
		wep.w_panelCache[name]:SetVisible(false)
		
		table.insert(w_relelements, name)
		UpdateRelBoxes("w")
		
		mwlist:AddLine(name,new_preset.type)
	end
end
