include("shared.lua")

-- Nothing needs to be drawn: all rendering is handled by cl_maptext_entities.lua
-- via HUDPaint, listening to net.Receive("zs_maptext_display").
function ENT:Draw() end
function ENT:Think() end