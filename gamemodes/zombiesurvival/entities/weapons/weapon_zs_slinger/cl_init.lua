INC_CLIENT()

SWEP.HUD3DBone = "v_weapon.p228_Slide"
SWEP.HUD3DPos = Vector(-1.4, 0.15, 0)
SWEP.HUD3DAng = Angle(0, 0, 0)
SWEP.HUD3DScale = 0.017

SWEP.VElements = {
	["BACKING+"] = { type = "Model", model = "models/props_wasteland/light_spotlight02_base.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "train", pos = Vector(-0.101, -1.787, -0.027), angle = Angle(111.536, 90, 0), size = Vector(0.18, 0.504, 1.327), color = Color(75, 75, 75, 255), surpresslightning = false, material = "models/props_canal/metalwall005b", skin = 0, bodygroup = {} },
	["BOLT"] = { type = "Model", model = "models/crossbow_bolt.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "train", pos = Vector(-0.042, 11.982, 1.141), angle = Angle(0, 90, 0), size = Vector(0.65, 0.65, 0.65), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["train"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "v_weapon.p228_Parent", rel = "", pos = Vector(0, -3.579, -2.291), angle = Angle(180, 0, -90), size = Vector(0.023, 0.019, 0.009), color = Color(100, 100, 100, 255), surpresslightning = false, material = "models/props_canal/metalwall005b", skin = 0, bodygroup = {} },
	["backa"] = { type = "Model", model = "models/props_wasteland/tram_bracket01.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "train", pos = Vector(-0.065, 4.964, 0.18), angle = Angle(0, -90, 0), size = Vector(0.043, 0.043, 0.043), color = Color(100, 100, 100, 255), surpresslightning = false, material = "models/props_canal/metalwall005b", skin = 0, bodygroup = {} },
	["BACKING"] = { type = "Model", model = "models/props_wasteland/light_spotlight02_base.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "train", pos = Vector(-0.062, -3.317, 1.368), angle = Angle(93.779, 90, 0), size = Vector(0.18, 0.504, 1.327), color = Color(75, 75, 75, 255), surpresslightning = false, material = "models/props_canal/metalwall005b", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["BACKING+"] = { type = "Model", model = "models/props_wasteland/light_spotlight02_base.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "train", pos = Vector(-0.101, -1.787, -0.027), angle = Angle(111.536, 90, 0), size = Vector(0.18, 0.504, 1.327), color = Color(100, 100, 100, 255), surpresslightning = false, material = "models/props_canal/metalwall005b", skin = 0, bodygroup = {} },
	["BOLT"] = { type = "Model", model = "models/crossbow_bolt.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "train", pos = Vector(-0.042, 11, 1.141), angle = Angle(0, 90, 0), size = Vector(0.65, 0.65, 0.65), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["train"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.178, 1.909, -3.55), angle = Angle(180, 85.359, -2.799), size = Vector(0.023, 0.019, 0.009), color = Color(100, 100, 100, 255), surpresslightning = false, material = "models/props_canal/metalwall005b", skin = 0, bodygroup = {} },
	["BACKING"] = { type = "Model", model = "models/props_wasteland/light_spotlight02_base.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "train", pos = Vector(-0.062, -3.317, 1.368), angle = Angle(93.779, 90, 0), size = Vector(0.18, 0.504, 1.327), color = Color(75, 75, 75, 255), surpresslightning = false, material = "models/props_canal/metalwall005b", skin = 0, bodygroup = {} },
	["backa"] = { type = "Model", model = "models/props_wasteland/tram_bracket01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "train", pos = Vector(-0.065, 4.964, 0.18), angle = Angle(0, -90, 0), size = Vector(0.043, 0.043, 0.043), color = Color(100, 100, 100, 255), surpresslightning = false, material = "models/props_canal/metalwall005b", skin = 0, bodygroup = {} }
}

SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false

SWEP.Slot = 3
SWEP.SlotPos = 0

function SWEP:ShootBullets(damage, numshots, cone)
	local owner = self:GetOwner()
	self:SendWeaponAnimation()
	owner:DoAttackEvent()

	if self.Recoil > 0 then
		local r = math.Rand(0.8, 1)
		owner:ViewPunch(Angle(r * -self.Recoil, 0, (1 - r) * (math.random(2) == 1 and -1 or 1) * self.Recoil))
	end

	self.ProjShootTime = CurTime()
end


function SWEP:PostDrawViewModel(vm, pl, wep)
	if self.HUD3DPos and GAMEMODE:ShouldDraw3DWeaponHUD() then
		local pos, ang = self:GetHUD3DPos(vm)
		if pos then
			self:Draw3DHUD(vm, pos, ang)
		end
	end

	local veles = self.VElements

	local boltpos = veles["BOLT"].pos
	local backang = veles["BACKING"].angle

	local time = CurTime()
	local reloadfinish = self:GetReloadFinish()
	local reloadstart = self:GetReloadStart()

	local col1, col2 = Color(0, 0, 0, 0), Color(255, 255, 140, 255)
	if (reloadfinish == 0 and self:Clip1() < 1) or (reloadfinish - time * 5) > (time - reloadstart) then
		veles["BOLT"].color = col1
	else
		veles["BOLT"].color = col2
	end

	if time < reloadfinish then
		local lowertime = math.min(reloadfinish - time, time - reloadstart)
		local delta = math.Clamp(lowertime * 4 / (reloadfinish - reloadstart), 0, 1)

		boltpos.y = Lerp(delta, 11, 5)
		backang.pitch = Lerp(delta, 105, 120)
	else
		boltpos.y = 11
		backang.pitch = 95
	end
end
