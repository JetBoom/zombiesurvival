translate.AddLanguage("ru", "Russian")

-- 1 = enable. 0 = disable.
-- Language Settings
LANGUAGE.lowercase_after_comma							= "1" -- Lowercase the first word after a comma.
LANGUAGE.qlt_weapon_lowercase							= "1" -- Lowercase the quality name of a remantled weapon. Used in the qlt_weapon_format_targetid string.
LANGUAGE.class_name_lowercase							= "1" -- Lowercase the zombie class name inside strings like "you_will_spawn_as_a_x".
LANGUAGE.class_name_lowercase_scripts					= "cyrillic"  -- Optional. Which scripts the class_name_lowercase rule applies to. Accepted values: "cyrillic", "cyrillic, greek", "latin". Empty = any script.

-- Font Settings
-- Useful for languages whose characters are not supported by decorative fonts (e.g. Cyrillic, ideographs). Set font_extended = "1" to enable the extended Unicode range in surface.CreateFont. Required for some non-Latin alphabets.
LANGUAGE.font_extended									= "1"                     -- Extended Unicode range (needed for CJK)
LANGUAGE.font_outline									= "1"                     -- 1px outline around text
