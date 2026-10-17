ENT.Type = "point"
ENT.Base = "base_point"

ENT.Spawnable = false
ENT.AdminSpawnable = false

-- The defaults have been copied from the original game_text.
-- If the map hasn't specified them, these are used.
ENT.StoredMessage         = nil
ENT.m_flMessageTextTime   = 5      -- holdtime
ENT.m_flFadeInTime        = 0.5
ENT.m_flFadeOutTime       = 0.5
ENT.m_flEffectTime        = 0      -- fxtime
ENT.m_iTextX              = -1     -- -1 = center on X
ENT.m_iTextY              = -1     -- -1 = center on Y
ENT.m_iTextEffect         = 0      -- 0=fade, 1=flicker, 2=writeout, 3/4=mixed
ENT.m_iChannel            = 0
ENT.m_iTextColor1         = {255, 255, 255}
ENT.m_iTextColor2         = {255, 255, 255}
ENT.m_bEnvironmentMessage = false