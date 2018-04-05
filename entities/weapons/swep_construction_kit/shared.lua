
if SERVER then
	AddCSLuaFile("shared.lua")
	AddCSLuaFile("client.lua")
	AddCSLuaFile("glon.lua")
	AddCSLuaFile("menu/tool.lua")
	AddCSLuaFile("menu/weapon.lua")
	AddCSLuaFile("menu/ironsights.lua")
	AddCSLuaFile("menu/models.lua")
	AddCSLuaFile("base_code.lua")
end

if CLIENT then

	SWEP.PrintName		= "SWEP Construction Kit"
	SWEP.Author			= "Clavus"
	SWEP.Contact		= "clavus@clavusstudios.com"
	SWEP.Purpose		= "Design SWEP ironsights and clientside models"
	SWEP.Instructions	= "http://tinyurl.com/swepkit"
	SWEP.Slot			= 5
	SWEP.SlotPos		= 10
	SWEP.ViewModelFlip	= false
	
	SWEP.DrawCrosshair	= false
	
	SWEP.ShowViewModel 	= true
	SWEP.ShowWorldModel = true
	
end

local debugging = false

function SCKDebug( msg )
	if !debugging then return end
	MsgN("[SCK] "..msg)
end

local repmsg = {}
function SCKDebugRepeat( tag, msg )
	if !debugging then return end
	if !repmsg[tag] then repmsg[tag] = { last = 0, num = 0 } end
	repmsg[tag].num = repmsg[tag].num + 1
	if (CurTime() - repmsg[tag].last >= 1) then
		MsgN("[SCK][Repeated "..repmsg[tag].num.." times in last sec] "..msg)
		repmsg[tag].num = 0
		repmsg[tag].last = CurTime()
	end
end


SWEP.HoldType = "pistol"
SWEP.HoldTypes = { "normal", "melee", "melee2", "fist", 
"knife", "smg", "ar2", "pistol", "revolver", "rpg", "physgun", 
"grenade", "shotgun", "crossbow", "slam", "duel", "passive",
"camera" }

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_pistol.mdl"
SWEP.WorldModel			= "models/weapons/w_pistol.mdl"
SWEP.CurWorldModel 		= "models/weapons/w_pistol.mdl" // this is where shit gets hacky 

SWEP.ViewModelFOV		= 70
SWEP.BobScale			= 0
SWEP.SwayScale			= 0

SWEP.Primary.Automatic	= false

SWEP.IronsightTime = 0.2

SWEP.IronSightsPos = Vector(0, 0, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)

local sck_class = ""

function SWEP:Initialize()

	self:SetWeaponHoldType(self.HoldType)
	
	self:SetIronSights( true )
	self:ResetIronSights()
	
	if CLIENT then
		self:CreateWeaponWorldModel()
		self:ClientInit()
		if (not file.IsDir("swep_construction_kit", "DATA")) then
			file.CreateDir("swep_construction_kit")
		end
	end
	
	self.Dropped = false
	
	sck_class = self:GetClass()
	
end

function SWEP:Equip()

	self.Dropped = false

end

function SWEP:PrimaryAttack()

	self.Weapon:SetNextPrimaryFire(CurTime() + 0.2)

	if CLIENT then
		self:OpenMenu()
	end
	if game.SinglePlayer() then
		self.Owner:SendLua("LocalPlayer():GetActiveWeapon():OpenMenu()")
	end
	
end

function SWEP:SecondaryAttack()
	
	self.Weapon:SetNextSecondaryFire(CurTime() + 0.2)
	
	if CLIENT then
		self:OpenMenu()
	end
	if game.SinglePlayer() then
		self.Owner:SendLua("LocalPlayer():GetActiveWeapon():OpenMenu()")
	end
	
end


function SWEP:SetupDataTables()

	self:DTVar( "Bool", 0, "ironsights" )
	self:DTVar( "Bool", 1, "thirdperson" )
	
end

function SWEP:ToggleIronSights()
	self.dt.ironsights = !self.dt.ironsights
end

function SWEP:SetIronSights( b )
	self.dt.ironsights = b
end

function SWEP:GetIronSights()
	return self.dt.ironsights
end

function SWEP:ResetIronSights()
	RunConsoleCommand("_sp_ironsight_x", 0)
	RunConsoleCommand("_sp_ironsight_y", 0)
	RunConsoleCommand("_sp_ironsight_z", 0)
	RunConsoleCommand("_sp_ironsight_pitch", 0)
	RunConsoleCommand("_sp_ironsight_yaw", 0)
	RunConsoleCommand("_sp_ironsight_roll", 0)
end

function SWEP:ToggleThirdPerson()
	self:SetThirdPerson( !self.dt.thirdperson )
end

function SWEP:SetThirdPerson( b )
	self.dt.thirdperson = b
	
	local owner = self.Owner
	if (!IsValid(owner)) then owner = self.LastOwner end
	if (!IsValid(owner)) then return end
	
	if (self.dt.thirdperson) then 
		owner:SetViewEntity(game.GetWorld())
		owner:CrosshairDisable()
	else 
		owner:SetViewEntity(owner)
		owner:CrosshairEnable() 
	end
end

function SWEP:GetThirdPerson()
	return self.dt.thirdperson
end

function SWEP:GetViewModelPosition(pos, ang)
	
	//if true then return pos, ang end
	//SCKDebugRepeat( "SWEP:VMPos", "Getting viewmodel pos" )
	
	local bIron = self.dt.ironsights
	local fIronTime = self.fIronTime or 0

	if (not bIron and fIronTime < CurTime() - self.IronsightTime) then
		return pos, ang
	end
	
	self.IronSightsPos, self.IronSightsAng = self:GetIronSightCoordination()

	local Mul = 1.0

	if (fIronTime > CurTime() - self.IronsightTime) then
		Mul = math.Clamp((CurTime() - fIronTime) / self.IronsightTime, 0, 1)

		if not bIron then Mul = 1 - Mul end
	end

	local Offset	= self.IronSightsPos

	if (self.IronSightsAng) then
		ang = ang * 1
		ang:RotateAroundAxis(ang:Right(), 		self.IronSightsAng.x * Mul)
		ang:RotateAroundAxis(ang:Up(), 		self.IronSightsAng.y * Mul)
		ang:RotateAroundAxis(ang:Forward(), 	self.IronSightsAng.z * Mul)
	end

	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()

	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul
	
	return pos, ang
end

SWEP.ir_x = CreateConVar( "_sp_ironsight_x", 0.0 )
SWEP.ir_y = CreateConVar( "_sp_ironsight_y", 0.0 )
SWEP.ir_z = CreateConVar( "_sp_ironsight_z", 0.0 )
SWEP.ir_p = CreateConVar( "_sp_ironsight_pitch", 0.0 )
SWEP.ir_yw = CreateConVar( "_sp_ironsight_yaw", 0.0 )
SWEP.ir_r = CreateConVar( "_sp_ironsight_roll", 0.0 )

function SWEP:GetIronSightCoordination()
	
	local vec = Vector( self.ir_x:GetFloat(), self.ir_y:GetFloat(), self.ir_z:GetFloat() )
	local ang = Vector( self.ir_p:GetFloat(), self.ir_yw:GetFloat(), self.ir_r:GetFloat() )
	return vec, ang
	
end

function SWEP:GetHoldTypes()
	return self.HoldTypes
end

SWEP.LastOwner = nil
/***************************
	Helper functions
***************************/
SWEP.IsSCK = true
function GetSCKSWEP( pl )
	local wep = pl:GetActiveWeapon()
	if (IsValid(wep) and wep.IsSCK) then
		return wep
	end
	//Error("Not holding SWEP Construction Kit!")
	return NULL
end

if SERVER then
	include("server.lua")
end

if CLIENT then
	include("client.lua")
end