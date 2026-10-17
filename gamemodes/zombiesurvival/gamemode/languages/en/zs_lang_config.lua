translate.AddLanguage("en", "English")

-- 1 = enable. 0 = disable.
-- Language Settings
LANGUAGE.lowercase_after_comma							= "0" -- Lowercase the first word after a comma.
LANGUAGE.qlt_weapon_lowercase							= "0" -- Lowercase the quality name of a remantled weapon. Used in the qlt_weapon_format_targetid string.
LANGUAGE.notify_stack_prefix							= "0" -- Place the notification counter BEFORE the message instead of after it.
LANGUAGE.kill_assist_swap								= "0" -- Order of names in the "X and Y killed Z" message. "0" or missing key: attacker first, assistant second. "1": assistant first, attacker second. Change together with the and_separator string (for example, " y " for Spanish).
LANGUAGE.class_name_lowercase							= "0" -- Lowercase the zombie class name inside strings like "you_will_spawn_as_a_x".
LANGUAGE.class_name_lowercase_scripts					= ""  -- Optional. Which scripts the class_name_lowercase rule applies to. Accepted values: "cyrillic", "cyrillic, greek", "latin". Empty = any script.

-- Font Settings
-- Useful for languages whose characters are not supported by decorative fonts (e.g. Cyrillic, ideographs). Set font_extended = "1" to enable the extended Unicode range in surface.CreateFont. Required for some non-Latin alphabets.
LANGUAGE.font_family									= "ghoulish_fright_aoe_v2.1"   -- Main font (HUD, menus, labels)
LANGUAGE.font_family_sm									= "remington_noiseless_v2"   -- Small text font
LANGUAGE.font_family_3d									= "hidden_v2"                -- 3D text font used in the world
LANGUAGE.font_size_add									= "6"                     -- Amount added to every font size
LANGUAGE.font_weight									= "0"                     -- Font weight
LANGUAGE.font_extended									= "0"                     -- Extended Unicode range (needed for CJK)
LANGUAGE.font_outline									= "1"                     -- 1px outline around text
LANGUAGE.font_fallback_enabled							= "0"                     -- Use a fallback font for glyphs the game font does not support
LANGUAGE.font_fallback									= "Tahoma"                -- Font used when font_fallback_enabled = "1"