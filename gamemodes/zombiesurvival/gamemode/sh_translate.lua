-- Translation library by William Moodhe
-- Feel free to use this in your own addons.
-- See the languages folder to add your own languages.

translate = {}

local Languages = {}
local Translations = {}
local AddingLanguage
local DefaultLanguage = "en"
local CurrentLanguage = DefaultLanguage

if CLIENT then
	-- Need to make a new convar since gmod_language isn't sent to server.
	CreateClientConVar("gmod_language_rep", "en", false, true)

	timer.Create("checklanguagechange", 1, 0, function()
		CurrentLanguage = GetConVarString("gmod_language")
		if CurrentLanguage ~= GetConVarString("gmod_language_rep") then
			-- Let server know our language changed.
			RunConsoleCommand("gmod_language_rep", CurrentLanguage)
		end
	end)
end

function translate.GetLanguages()
	return Languages
end

function translate.GetLanguageName(short)
	return Languages[short]
end

function translate.GetTranslations(short)
	return Translations[short] or Translations[DefaultLanguage]
end

function translate.AddLanguage(short, long)
	Languages[short] = long
	Translations[short] = Translations[short] or {}
	AddingLanguage = short
end

function translate.AddTranslation(id, text)
	if not AddingLanguage or not Translations[AddingLanguage] then return end

	Translations[AddingLanguage][id] = text
end

function translate.Get(id)
	return translate.GetTranslations(CurrentLanguage)[id] or translate.GetTranslations(DefaultLanguage)[id] or ("@"..id.."@")
end

function translate.Format(id, ...)
	return string.format(translate.Get(id), ...)
end

if SERVER then
	function translate.ClientGet(pl, ...)
		CurrentLanguage = pl:GetInfo("gmod_language_rep")
		return translate.Get(...)
	end

	function translate.ClientFormat(pl, ...)
		CurrentLanguage = pl:GetInfo("gmod_language_rep")
		return translate.Format(...)
	end

	function PrintTranslatedMessage(printtype, str, ...)
		for _, pl in pairs(player.GetAll()) do
			pl:PrintMessage(printtype, translate.ClientFormat(pl, str, ...))
		end
	end
end

if CLIENT then
	function translate.ClientGet(_, ...)
		return translate.Get(...)
	end
	function translate.ClientFormat(_, ...)
		return translate.Format(...)
	end
end

for i, filename in pairs(file.Find(GM.FolderName.."/gamemode/languages/*.lua", "LUA")) do
	LANGUAGE = {}
	AddCSLuaFile("languages/"..filename)
	include("languages/"..filename)
	for k, v in pairs(LANGUAGE) do
		translate.AddTranslation(k, v)
	end
	LANGUAGE = nil
end

local meta = FindMetaTable("Player")
if not meta then return end

function meta:PrintTranslatedMessage(hudprinttype, translateid, ...)
	if ... ~= nil then
		self:PrintMessage(hudprinttype, translate.ClientFormat(self, translateid, ...))
	else
		self:PrintMessage(hudprinttype, translate.ClientGet(self, translateid))
	end
end
