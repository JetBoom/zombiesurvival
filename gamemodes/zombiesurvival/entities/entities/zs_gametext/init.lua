AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

-- Duplicating it here — KeyValue may reach this file earlier,
-- than sv_maptext_entities.lua.
local function ParseFloat(v)
    if type(v) == "number" then return v end
    if type(v) ~= "string" then return nil end
    return tonumber(v) or tonumber((v:gsub(",", ".")))
end

-- Parses color from KeyValue game_text. Format is always "R G B"
-- (or "R G B A", but the engine ignores alpha — we set it to 255).
local function ParseColor(str)
    if type(str) ~= "string" then return nil end
    local r, g, b = str:match("(%d+)%s+(%d+)%s+(%d+)")
    if not r then return nil end
    return { tonumber(r), tonumber(g), tonumber(b) }
end

-- All fields that the map can set via .vmf.
-- Values match the defaults of the original game_text.
function ENT:KeyValue(key, value)
    local k = key:lower()

    if k == "message" then
        self.StoredMessage = value
	elseif k == "holdtime" then
		self.m_flMessageTextTime = ParseFloat(value) or self.m_flMessageTextTime
	elseif k == "fadein" then
		self.m_flFadeInTime = ParseFloat(value) or self.m_flFadeInTime
	elseif k == "fadeout" then
		self.m_flFadeOutTime = ParseFloat(value) or self.m_flFadeOutTime
	elseif k == "fxtime" then
		self.m_flEffectTime = ParseFloat(value) or self.m_flEffectTime
	elseif k == "x" then
		self.m_iTextX = ParseFloat(value) or self.m_iTextX
	elseif k == "y" then
		self.m_iTextY = ParseFloat(value) or self.m_iTextY
    elseif k == "effect" then
        self.m_iTextEffect = tonumber(value) or self.m_iTextEffect
    elseif k == "channel" then
        self.m_iChannel = tonumber(value) or self.m_iChannel
    elseif k == "color" then
        local c = ParseColor(value)
        if c then self.m_iTextColor1 = c end
    elseif k == "color2" then
        local c = ParseColor(value)
        if c then self.m_iTextColor2 = c end
    end
end

function ENT:_ParseColor(str)
    return ParseColor(str)
end

function ENT:Initialize()
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_NONE)
    self:SetNotSolid(true)
    self:DrawShadow(false)

    -- spawnflag 1 = "Start On" — like the original, show immediately.
    if bit.band(self:GetSpawnFlags(), 1) ~= 0 then
        timer.Simple(0, function()
            if IsValid(self) then
                self:DisplayMessage(nil)
            end
        end)
    end
end

function ENT:AcceptInput(name, activator, caller, data)
    name = string.lower(name or "")

    -- ─── Display Message ───
    if name == "display" then
        -- IMPORTANT: cards often pass the "1" parameter (a flag) to Display, rather than
        -- new text. If StoredMessage is overwritten with this "1", the message
        -- will turn into a digit. Therefore, we overwrite ONLY if data
        -- looks like text, not a number.
        if type(data) == "string" and data ~= "" and not tonumber(data) then
            self.StoredMessage = data
        end
        self:DisplayMessage(activator)
        return true
    end

	-- Message/SetText — change the text, but do NOT display it.
    -- Display it using a separate “Display” input (as in the original game_text).
	if name == "message" or name == "settext" then
		if type(data) == "string" and data ~= "" then
			self.StoredMessage = data
		end
		return true
	end

    -- ─── Set* inputs — only change the fields; they do NOT display a message ───
    if name == "setcolor" then
        local c = ParseColor(data)
        if c then self.m_iTextColor1 = c end
        return true
    end

    if name == "setcolor2" then
        local c = ParseColor(data)
        if c then self.m_iTextColor2 = c end
        return true
    end

    if name == "setfadein" then
        self.m_flFadeInTime = tonumber(data) or self.m_flFadeInTime
        return true
    end

    if name == "setfadeout" then
        self.m_flFadeOutTime = tonumber(data) or self.m_flFadeOutTime
        return true
    end

    if name == "setholdtime" then
        self.m_flMessageTextTime = tonumber(data) or self.m_flMessageTextTime
        return true
    end

    if name == "setfxtime" then
        self.m_flEffectTime = tonumber(data) or self.m_flEffectTime
        return true
    end

    if name == "setchannel" then
        self.m_iChannel = tonumber(data) or self.m_iChannel
        return true
    end

    if name == "seteffect" then
        self.m_iTextEffect = tonumber(data) or self.m_iTextEffect
        return true
    end

    -- ─── Kill — remove all active messages ───
    if name == "kill" then
        net.Start("zs_maptext_clear")
        net.Broadcast()
        return true
    end

    return false
end

-- Sends the current state to the client. The field order MUST
-- match that of net.Receive in cl_maptext_entities.lua.
function ENT:DisplayMessage(activator)
    if not self.StoredMessage or self.StoredMessage == "" then return end

    local type_ = self.m_bEnvironmentMessage and 1 or 0
    local c1 = self.m_iTextColor1 or {255, 255, 255}
    local c2 = self.m_iTextColor2 or {255, 255, 255}

    net.Start("zs_maptext_display")
        net.WriteUInt(type_, 2)
        net.WriteString(self.StoredMessage)
        net.WriteFloat(self.m_flMessageTextTime)
        net.WriteFloat(self.m_flFadeInTime)
        net.WriteFloat(self.m_flFadeOutTime)
        net.WriteFloat(self.m_flEffectTime)
        net.WriteFloat(self.m_iTextX)
        net.WriteFloat(self.m_iTextY)
        net.WriteUInt(self.m_iTextEffect, 4)
        net.WriteUInt(self.m_iChannel, 4)
        net.WriteColor(Color(c1[1], c1[2], c1[3]), false)
        net.WriteColor(Color(c2[1], c2[2], c2[3]), false)
    net.Broadcast()
end