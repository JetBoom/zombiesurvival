CLASS.Base = "freshdead"

CLASS.Name = "Recent Dead"
CLASS.TranslationName = "class_recent_dead"
CLASS.Description = "description_fresh_dead"
CLASS.Help = "controls_fresh_dead"

CLASS.Wave = 0
CLASS.Hidden = true
CLASS.Disabled = true
CLASS.Unlocked = true

CLASS.Health = 130
CLASS.Points = CLASS.Health/GM.HumanoidZombiePointRatio

CLASS.UsePlayerModel = true
CLASS.UsePreviousModel = false

if SERVER then
	function CLASS:OnKilled() end
end

if not CLIENT then return end

CLASS.Icon = "zombiesurvival/killicons/fresh_dead"
