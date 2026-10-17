-- Translated by The Special Duckling (http://www.noxiousnet.com/forums/index.php?action=profile;u=8557)
-- Feel free to update translation for anyone

translate.AddLanguage("da", "Danish")

-- ============================================================
-- Zombie classes: names, descriptions, controls
-- ============================================================

-- Class names
LANGUAGE.class_zombie								= "Zombie"
LANGUAGE.class_poison_zombie						= "Poison Zombie"
LANGUAGE.class_fast_zombie							= "Fast Zombie"
LANGUAGE.class_bloated_zombie						= "Bloated Zombie"
LANGUAGE.class_classic_zombie						= "Classic Zombie"
LANGUAGE.class_super_zombie							= "Super Zombie"
LANGUAGE.class_fresh_dead							= "Fresh Dead"
LANGUAGE.class_ghoul								= "Ghoul"
LANGUAGE.class_headcrab								= "Headcrab"
LANGUAGE.class_fast_headcrab						= "Fast Headcrab"
LANGUAGE.class_poison_headcrab						= "Poison Headcrab"
LANGUAGE.class_the_tickle_monster					= "The Tickle Monster"
LANGUAGE.class_nightmare							= "Nightmare"
LANGUAGE.class_pukepus								= "Pukepus"
LANGUAGE.class_bonemesh								= "Bonemesh"
LANGUAGE.class_crow									= "Crow"
LANGUAGE.class_wilowisp								= "Wil O' Wisp"
LANGUAGE.class_zombie_torso							= "Zombie Torso"
LANGUAGE.class_zombie_legs							= "Zombie Legs"
LANGUAGE.class_wraith								= "Wraith"
LANGUAGE.class_fast_zombie_legs						= "Fast Zombie Legs"
LANGUAGE.class_shade								= "Shade"
LANGUAGE.class_flesh_creeper						= "Flesh Creeper"

-- Class descriptions
LANGUAGE.description_zombie							= "Dette er den mest normale af de udøde. Den er meget kraftig, og har kraftige klør. \nDen er svær at holde nede, specielt hvis den ikke bliver skudt i hovedet."
LANGUAGE.description_poison_zombie					= "Denne muterede udøde er ikke kun ekstremt kraftig, men ejer også unormal styrke. \n Dens krop er ekstremt giftig, og den vil rive sit eget kød af og kaste det, efter ting som ikke kan slås med dens klør."
LANGUAGE.description_fast_zombie					= "Dette knoglede kadaver er meget hurtigere end andre udøde. \nDe gør ikke megen skade alene, men de kan kravle op næsten over alt, og smadre overlevende som ikke er på vagt. \nDe har heller ikke noget problem med at fange svage, eller sårede mennesker."
LANGUAGE.description_bloated_zombie					= "Deres krop består af råddent kød, blandet med meget giftige kemikalier. \nSelvom de er langsommere, kan de tage en smule flere kugler end andre udøde."
LANGUAGE.description_ghoul							= "Denne udøde har enormt giftigt kød. \nDen er lidt svagere end andre udøde, men i dens beskyttelse er dens angreb dybt giftige. \nDens klør vil svække en overlevende i et kort øjeblik, og den vil spytte gift ud af dens sår, hvis den tager nok skade."
LANGUAGE.description_headcrab						= "Hoverkrabber er hvad startede infektionen. \nIngen ved hvor de virkelig stammede fra. \nDeres metode af angreb, er ved hjælp af deres skarpe næb under deres mave."
LANGUAGE.description_fast_headcrab					= "Den mandelige hovedkrappe er betydeligt hurtigere, men mindre kraftig end den kvindelige. \nUanset hvad, er de lige irriterende og dødelige i grupper."
LANGUAGE.description_poison_headcrab				= "Denne hovedkrappe er fuldt med dødelige giftstoffer. \nEn bid er normalt nok til at dræbe et voksent menneske. \nDen har også evnen til at spytte en mindre giftig version af dens giftstoffer. \nSpyttet er lige så giftigt, hvis offeret bliver ramt i ansigtet."
LANGUAGE.description_the_tickle_monster				= "Det siges at dette monster gemmer sig i dit skab om natten, for at trække dig ud af din seng. \nTickle Monsterets næsten elastiske arme gør det ekstremt svært at løbe væk fra, og så er de også de ideale barrikade ødelæggere."
LANGUAGE.description_nightmare						= "En enormt sjælden mutation giver Nightmare dens anormale egenskaber. \nStærkere end en normal udød på næsten alle måder, Nightmare er ikke en kræft som du ønsker at slås med. \nEt stik fra dens klør er nok til at dræbe næsten hvilken som helst person."
LANGUAGE.description_pukepus						= "Den rådne krop af Puke Pus består kun af organer som bruges til at genere gift. \nDen er i stand til at kaste litervis af gift op, hvilket gør den ekstremt farlig."
LANGUAGE.description_bonemesh						= "Vansiret og lemlæstet, Bonemesh har egenskaben af at kunne kaste blod bomber. \nHver bombe består af knogler of kød, som skader mennesker, mens den udleverer mad til andre udøde."
LANGUAGE.description_crow							= "Carrion Kraver er mere af en pest end de var før infektionen. \nDe spiser af de udødes kød, og slæber sygdommen med sig. \nHvofor fanden er den her overhovedet tilgængelig? \nHvad er der galt med dig?"
LANGUAGE.description_wilowisp						= "Nogle gang hentydet til som ånderne af død."
LANGUAGE.description_zombie_torso					= "Du burde ikke kunne se det her… Men nu du gør, så er Anders Volander sej!"
LANGUAGE.description_zombie_legs					= "Du burde ikke kunne se det her… Men nu du gør, så er Anders Volander sej!"
LANGUAGE.description_wraith							= "En udød eller en skiggelse? \nIkke meget er kendt omkring den, udover det faktum at de bruger en \nunik skygge egenskab, for at gøre sig selv usynlig, og skarpe klør til at skære ting til konfetti."
LANGUAGE.description_fast_zombie_legs				= "Du burde ikke kunne se det her… Men nu du gør, så er Anders Volander sej!"
LANGUAGE.description_shade							= "Ved at lave et stærkt magnetisk område omkring sig selv, vil alle kugler og nærkampsangreb blive ligegyldige omkring den. \nMen af en eller anden grund kan den ikke lide skarpe lys."

-- Class control schemes
LANGUAGE.controls_zombie							= "> {{bind:+attack|PRIMARY}}: Claws\n> {{bind:+attack2|SECONDARY}}: Scream\n> {{bind:+reload|RELOAD}}: Moan\n> {{bind:+speed|SPRINT}}: Feign death\n> ON FATAL HIT IN LEGS: Revive / Transform"
LANGUAGE.controls_poison_zombie						= "> {{bind:+attack|PRIMARY}}: Claws\n> {{bind:+attack2|SECONDARY}}: Flesh toss\n> {{bind:+reload|RELOAD}}: Scream"
LANGUAGE.controls_fast_zombie						= "> {{bind:+attack|PRIMARY}}: Claws\n> {{bind:+attack2|SECONDARY}}: Lunge / Climb (next to wall)\n> {{bind:+reload|RELOAD}}: Scream"
LANGUAGE.controls_bloated_zombie					= "> {{bind:+attack|PRIMARY}}: Claws\n> {{bind:+attack2|SECONDARY}}: Moan\n> {{bind:+speed|SPRINT}}: Feign death\n> ON DEATH: Poison Gibs"
--LANGUAGE.controls_ghoul							= "> {{bind:+attack|PRIMARY}}: Poison claws\n> {{bind:+attack2|SECONDARY}}: Flesh toss\n> {{bind:+speed|SPRINT}}: Feign death\n> {{bind:+reload|RELOAD}}: Scream\n> ON HIT HUMAN: Slow\n> ON HIT BY HUMAN: Poison ejection" -- Outdated
LANGUAGE.controls_headcrab							= "> {{bind:+attack|PRIMARY}}: Lunge attack\n> {{bind:+reload|RELOAD}}: Burrow"
LANGUAGE.controls_fast_headcrab						= "> {{bind:+attack|PRIMARY}}: Lunge attack"
LANGUAGE.controls_poison_headcrab					= "> {{bind:+attack|PRIMARY}}: Lunge attack\n> {{bind:+attack2|SECONDARY}}: Spit poison\n> ON HIT HUMAN: Deadly poison\n> ON HIT POISON IN EYES: Blind\n> {{bind:+reload|RELOAD}}: Scream"
LANGUAGE.controls_the_tickle_monster				= "> {{bind:+attack|PRIMARY}}: Elastic claws\n> {{bind:+attack2|SECONDARY}}: Moan"
LANGUAGE.controls_nightmare							= "> {{bind:+attack|PRIMARY}}: Death touch\n> {{bind:+attack2|SECONDARY}}: Moan"
--LANGUAGE.controls_pukepus							= "> {{bind:+attack|PRIMARY}}: Puke" -- Outdated
LANGUAGE.controls_bonemesh							= "> {{bind:+attack|PRIMARY}}: Claws\n> {{bind:+attack2|SECONDARY}}: Toss blood bomb"
LANGUAGE.controls_wraith							= "> {{bind:+attack|PRIMARY}}: Claws\n> {{bind:+attack2|SECONDARY}}: Scream\n> INVISIBILITY BASED ON MOVEMENT AND VIEW DISTANCE"
--LANGUAGE.controls_shade							= "> {{bind:+attack|PRIMARY}}: Lift\n> {{bind:+attack2|SECONDARY}}: Throw" -- Outdated
