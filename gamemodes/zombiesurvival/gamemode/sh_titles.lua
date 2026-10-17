-- ============================================================
-- Engine title names → language token references
-- ============================================================

translate = translate or {}

translate.BundledTitles = {
    -- Half-Life 2 game over
    GAMEOVER_ALLY           = "#HL2_GameOver_Ally",
    GAMEOVER_OBJECT         = "#HL2_GameOver_Object",
    GAMEOVER_TIMER          = "#HL2_GameOver_Timer",
    GAMEOVER_STUCK          = "#HL2_GameOver_Stuck",

    -- Episodes
    GAMEOVER_ALYXDEAD       = "#Episodic_GameOver_AlyxDead",
    GAMEOVER_ALYXLEFT       = "#EP2_GameOver_AlyxLeft",

    -- HL2 chapters
    CHAPTER1_TITLE          = "#HL2_Chapter1_Title",
    CHAPTER2_TITLE          = "#HL2_Chapter2_Title",
    CHAPTER3_TITLE          = "#HL2_Chapter3_Title",
    CHAPTER4_TITLE          = "#HL2_Chapter4_Title",
    CHAPTER5_TITLE          = "#HL2_Chapter5_Title",
    CHAPTER6_TITLE          = "#HL2_Chapter6_Title",
    CHAPTER7_TITLE          = "#HL2_Chapter7_Title",
    CHAPTER8_TITLE          = "#HL2_Chapter8_Title",
    CHAPTER9_TITLE          = "#HL2_Chapter9_Title",
    CHAPTER9A_TITLE         = "#HL2_Chapter9a_Title",
    CHAPTER10_TITLE         = "#HL2_Chapter10_Title",
    CHAPTER11_TITLE         = "#HL2_Chapter11_Title",
    CHAPTER12_TITLE         = "#HL2_Chapter12_Title",
    CHAPTER13_TITLE         = "#HL2_Chapter13_Title",
    CHAPTER14_TITLE         = "#HL2_Chapter14_Title",

    -- Episode 1
    EP1_CHAPTER1_TITLE      = "#episodic_Chapter1_Title",
    EP1_CHAPTER2_TITLE      = "#episodic_Chapter2_Title",
    EP1_CHAPTER3_TITLE      = "#episodic_Chapter3_Title",
    EP1_CHAPTER4_TITLE      = "#episodic_Chapter4_Title",
    EP1_CHAPTER5_TITLE      = "#episodic_Chapter5_Title",

    -- Episode 2
    EP2_CHAPTER1_TITLE      = "#ep2_Chapter1_Title",
    EP2_CHAPTER2_TITLE      = "#ep2_Chapter2_Title",
    EP2_CHAPTER3_TITLE      = "#ep2_Chapter3_Title",
    EP2_CHAPTER4_TITLE      = "#ep2_Chapter4_Title",
    EP2_CHAPTER5_TITLE      = "#ep2_Chapter5_Title",
    EP2_CHAPTER6_TITLE      = "#ep2_Chapter6_Title",
    EP2_CHAPTER7_TITLE      = "#ep2_Chapter7_Title",
    EP2_CHAPTER8_TITLE      = "#ep2_Chapter8_Title",
    EP2_CHAPTER9_TITLE      = "#ep2_Chapter9_Title",

    -- Save-game messages
    GAMESAVING              = "#HL2_Saved",
    GAMESAVED               = "#HL2_Saved",
    GAMESAVING_360          = "#HL2_Saved",
    GAMESAVED_360           = "#HL2_Saved",
    GAMETITLE               = "Half-Life",
}

if CLIENT then
    translate.Titles = translate.Titles or {}

    for k, v in pairs(translate.BundledTitles) do
        if translate.Titles[k] == nil then
            translate.Titles[k] = v
        end
    end

    if not translate.GetTitleValue then
        function translate.GetTitleValue(name)
            if type(name) ~= "string" or name == "" then return nil end
            return translate.Titles[name]
        end
    end
end