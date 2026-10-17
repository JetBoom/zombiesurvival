local M_Weapon = FindMetaTable("Weapon")
local oldSendWeaponAnim = M_Weapon.SendWeaponAnim
function M_Weapon:SendWeaponAnim(anim)
    if GAMEMODE:IsBotWeaponNoop(self) then return end
    return oldSendWeaponAnim(self, anim)
end

local M_Entity = FindMetaTable("Entity")
local oldSetDTFloat = M_Entity.SetDTFloat
local oldGetDTFloat = M_Entity.GetDTFloat
local oldSetDTInt   = M_Entity.SetDTInt
local oldGetDTInt   = M_Entity.GetDTInt
local oldSetDTBool  = M_Entity.SetDTBool
local oldGetDTBool  = M_Entity.GetDTBool

local function IsOptimizedWeapon(ent)
    if not ent:IsWeapon() then return false end
    return GAMEMODE:IsBotWeaponNoop(ent)
end

function M_Entity:SetDTFloat(index, value)
    if IsOptimizedWeapon(self) then
        self._zsBotDTF = self._zsBotDTF or {}
        self._zsBotDTF[index] = value
        return
    end
    return oldSetDTFloat(self, index, value)
end

function M_Entity:GetDTFloat(index)
    if IsOptimizedWeapon(self) and self._zsBotDTF and self._zsBotDTF[index] ~= nil then
        return self._zsBotDTF[index]
    end
    return oldGetDTFloat(self, index)
end