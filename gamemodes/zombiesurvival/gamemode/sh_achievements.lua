--local translate = translate.Get

GM.Achievements = {
    ["sigil_uncorruptor"] = {
        Name = "Sigil Uncorruptor I",
        Desc = "Uncorrupt 5 sigils.",
        Reward = 135,
        Goal = 5
    },

    ["round_winner_1"] = {
        Name = "First win",
        Desc = "Win 1 round in normal mode",
        Reward = 475
    },

    ["round_winner_2"] = {
        Name = "Round winner",
        Desc = "Win 5 rounds in normal mode",
        Reward = 700,
        Goal = 5
    },

    ["round_winner_3"] = {
        Name = "Master of ZS",
        Desc = "Win 15 rounds in normal mode",
        Reward = 1000,
        Goal = 15
    },

    ["zombie_killer_1"] = {
        Name = "Zombie killer",
        Desc = "Kill 75 zombies",
        Reward = 60,
        Goal = 75
    },
    
    ["zombie_killer_2"] = {
        Name = "Zombie eliminator",
        Desc = "Kill 250 zombies",
        Reward = 175,
        Goal = 250
    },
    
    ["zombie_killer_3"] = {
        Name = "Zombie annihilator",
        Desc = "Kill 650 zombies",
        Reward = 400,
        Goal = 650
    },
    
    ["zombie_killer_4"] = {
        Name = "True Zombie annihilator",
        Desc = "Kill 2000 zombies",
        Reward = 850,
        Goal = 2000
    },

    ["boss_slayer_1"] = {
        Name = "Boss slayer",
        Desc = "Kill 3 boss zombies.",
        Reward = 50,
        Goal = 3
    },

    ["boss_slayer_2"] = {
        Name = "Boss hunter",
        Desc = "Kill 10 boss zombies.",
        Reward = 175,
        Goal = 10
    },

    ["ze_win"] = {
        Name = "Escaped from Zombies",
        Desc = "Win 1 round in zombie escape mode",
        Reward = 175
    },

    ["zs_obj_win"] = {
        Name = "Objective complete",
        Desc = "Win 1 round in objective map",
        Reward = 325
    },

    ["classicmode_win"] = {
        Name = "Classic Survivor",
        Desc = "Win 1 round in classic mode",
        Reward = 370
    },

    ["zmainer"] = {
        Name = "Zmainer",
        Desc = "Kill 15 humans as zombie!",
        Reward = 420,
        Goal = 15
    },

    ["truezmainer"] = {
        Name = "True Zmainer",
        Desc = "Kill 100 humans as zombie",
        Reward = 3150,
        Goal = 100
    },

    ["survivor_1"] = {
        Name = "Survivor I",
        Desc = "Survive 10 waves in endless mode",
        Reward = 1350
    },

    ["survivor_2"] = {
        Name = "Survivor II",
        Desc = "Survive 15 waves in endless mode",
        Reward = 3250
    },

    ["difficult_survival"] = {
        Name = "Difficult Survival",
        Desc = "Win 5 rounds with difficulty 1.25+",
        Reward = 1750,
        Goal = 5
    },

    ["hardmode"] = {
        Name = "Hard mode!",
        Desc = "Win 6 rounds with difficulty 1.5+",
        Reward = 4000,
        Goal = 6
    },

    ["pointfarmer_1"] = {
        Name = "Pointfarmer I",
        Desc = "Gain 5000 points in total",
        Reward = 350,
        Goal = 5000,
    },

    ["pointfarmer_2"] = {
        Name = "Pointfarmer II",
        Desc = "Gain 15000 points in total",
        Reward = 600,
        Goal = 15000,
    },

    ["pointfarmer_3"] = {
        Name = "Pointfarmer III",
        Desc = "Gain 50000 points in total",
        Reward = 1285,
        Goal = 50000,
    },

    ["repair_man_1"] = {
        Name = "Repairman",
        Desc = "Repair 15000 barricade points in total.",
        Reward = 485,
        Goal = 15000,
    },

    ["repair_man_2"] = {
        Name = "Trust me, I'm an engineer!",
        Desc = "Repair 100,000 barricade points in total",
        Reward = 1675,
        Goal = 100000,
    },


}

-- As to not call the table.Count function again
GM.AchievementsCount = table.Count(GM.Achievements)
