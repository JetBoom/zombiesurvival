-- FOR ONE TIME: PLY_STEAM_ID, ACHIEVEMENT_ID
-- FOR PROGRESS: PLY_STEAM_ID, ACHIEVEMENT_ID, PROGRESS
local PLAYER = FindMetaTable("Player")
-- Create SQL table
sql.Query("CREATE TABLE IF NOT EXISTS zs_achievements_onetime (SteamID STRING, AchievementID STRING)")
sql.Query("CREATE TABLE IF NOT EXISTS zs_achievements_progress (SteamID STRING, AchievementID STRING, Progress INT)")

function GM:PlayerNotifyAchievement(ply, id)
    net.Start("zs_achievementgained")
    net.WriteEntity(ply)
    net.WriteString(id)
    net.Broadcast()
end

-- Get player achievements from SQL (I'd say this is fairly expensive to do)
function PLAYER:ProcessAchievements()
/*  self.Achs = {}
-- Store count
    local completed = 0

-- Get from SQL
    for id, ach in pairs(GAMEMODE.Achievements) do
        local result = sql.Query("SELECT * FROM zs_achievements_" .. (ach.Goal and "progress" or "onetime") .. " WHERE SteamID = '" .. self:SteamID() .. "' AND AchievementID = '" .. id .. "'")

-- Result will return nil if there's no sql entry
        if result then
-- If we have a goal, we'll check for progress
            if ach.Goal then
                result = result[1]
                result.Progress = tonumber(result.Progress)
-- Store progress
                self.Achs[id] = result.Progress

-- Check for completion
                if self.Achs[id] >= ach.Goal then
                    completed = completed + 1
                end
            else
-- If we get a result on an achievement with no goal, achievement was achieved
                self.Achs[id] = true
                completed = completed + 1
            end
        end
    end
*/

    net.Start("zs_achievementsprogress")
    net.WriteString(util.TableToJSON(self.Achs or {}))
    net.Send(self)
end

-- For one time achievements
function PLAYER:GiveAchievement(id)
    if not GAMEMODE.UnlockAchievements then return end
    if not GAMEMODE.Achievements[id] then return end
    if not self.Achs then self.Achs = {} end

    if self.Achs[id] then return end

--  don't want any errors from comparing numbers with boolean
    if GAMEMODE.Achievements[id].Goal then return end

--  sql.Query("INSERT INTO zs_achievements_onetime VALUES('" .. self:SteamID() .. "', '" .. id .. "')")

    self.Achs[id] = true

    self:ProcessAchievements()

    print(string.format("[ZS] Player %s (%s) earned achievement %s (%s)", self:Name(), self:SteamID(), GAMEMODE.Achievements[id].Name, id))

    GAMEMODE:PlayerNotifyAchievement(self, id)
    self:AddZSBankXP(GAMEMODE.Achievements[id].Reward or 0)
    PrintMessage(HUD_PRINTTALK, Format("%s has earned \"%s\" achievement!", self:Name(), GAMEMODE.Achievements[id].Name))--translate.Format("ach_trans", self:Name(), self:SteamID(), GAMEMODE.Achievements[id].Name, id)

    hook.Run("HASAchievementEarned", self, id)
end

-- For progressive eachievements
function PLAYER:GiveAchievementProgress(id, count)
    if not GAMEMODE.UnlockAchievements then return end
    if not GAMEMODE.Achievements[id] or not GAMEMODE.Achievements[id].Goal then return end
    if not self.Achs then self.Achs = {} end

    if count == 0 or (self.Achs[id] or 0) >= GAMEMODE.Achievements[id].Goal then return end
    self.Achs[id] = self.Achs[id] or 0

-- Update or insert values
/*
    if self.Achs[id] > 0 then
        sql.Query("UPDATE zs_achievements_progress SET SteamID = SteamID, AchievementID = AchievementID, Progress = " .. math.Clamp(self.Achs[id] + count, 0, GAMEMODE.Achievements[id].Goal) .. " WHERE SteamID = '" .. self:SteamID() .. "' AND AchievementID = '" .. id .. "'")
    else
        sql.Query("INSERT INTO zs_achievements_progress VALUES('" .. self:SteamID() .. "', '" .. id .. "', " .. math.Clamp(count, 0, GAMEMODE.Achievements[id].Goal) .. ")")
    end
*/
    self.Achs[id] = self.Achs[id] + count

--  print(string.format("[ZS] Player %s (%s) has new achievement progress on %s (%s): %s/%s", self:Name(), self:SteamID(), GAMEMODE.Achievements[id].Name, id, self.Achs[id], GAMEMODE.Achievements[id].Goal))

    if self.Achs[id] >= GAMEMODE.Achievements[id].Goal then
        print(string.format("[ZS] Player %s (%s) earned achievement %s (%s)", self:Name(), self:SteamID(), GAMEMODE.Achievements[id].Name, id))
        GAMEMODE:PlayerNotifyAchievement(self, id)
        self:AddZSBankXP(GAMEMODE.Achievements[id].Reward or 200, true)
        PrintMessage(HUD_PRINTTALK, Format("%s has earned \"%s\" achievement!", self:Name(), GAMEMODE.Achievements[id].Name))--translate.Format("ach_trans", self:Name(), self:SteamID(), GAMEMODE.Achievements[id].Name, id)

        hook.Run("HASAchievementEarned", self, id)
    end

    -- Update
    self:ProcessAchievements()
end
