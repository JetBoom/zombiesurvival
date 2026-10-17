if not CLIENT then return end

local oldAddText = chat.AddText

function chat.AddText(...)
    local parts = {}
    for i = 1, select("#", ...) do
        local v = select(i, ...)
        if type(v) == "string" then parts[#parts + 1] = v end
    end
    local line = table.concat(parts, "")
    if line ~= "" then
        net.Start("zs_maptext_capture")
            net.WriteString(line)
        net.SendToServer()
    end
    return oldAddText(...)
end

-- ============================================================
-- We intercept the engine chat through the engine "say" event.
-- This is the only way to intercept messages that the engine
-- renders itself (say from the server console, point_servercommand,
-- PrintMessage, etc.) — chat.AddText is not called for them.
-- ============================================================
gameevent.Listen("say")
gameevent.Listen("say_team")

local function CaptureSayEvent(data)
    local text = data and data.text
    if type(text) ~= "string" or text == "" then return end
    -- Filter out GMod's own system messages (mode prefixes)
    -- optionally — but for now just write everything.
    net.Start("zs_maptext_capture")
        net.WriteString(text)
    net.SendToServer()
end

hook.Add("say",      "ZS_ChatCapture_Say",     CaptureSayEvent)
hook.Add("say_team", "ZS_ChatCapture_SayTeam", CaptureSayEvent)
