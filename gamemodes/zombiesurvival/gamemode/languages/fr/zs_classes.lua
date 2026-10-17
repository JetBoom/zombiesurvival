-- Translated by Shen (http://www.noxiousnet.com/forums/index.php?action=profile;u=3311)
-- Feel free to update translation for anyone

translate.AddLanguage("fr", "French")

-- ============================================================
-- Zombie classes: names, descriptions, controls
-- ============================================================

-- Class names
LANGUAGE.class_zombie								= "Zombie"
LANGUAGE.class_poison_zombie						= "Zombie empoisonné"
LANGUAGE.class_fast_zombie							= "Zombie agile"
LANGUAGE.class_bloated_zombie						= "Zombie balloné"
LANGUAGE.class_classic_zombie						= "Zombie classique"
LANGUAGE.class_super_zombie							= "Super Zombie"
LANGUAGE.class_fresh_dead							= "Nouveau mort"
LANGUAGE.class_ghoul								= "Goule"
LANGUAGE.class_headcrab								= "Crabe de tête"
LANGUAGE.class_fast_headcrab						= "Crabe de tête agile"
LANGUAGE.class_poison_headcrab						= "Crabe de tête empoisonné"
LANGUAGE.class_the_tickle_monster					= "The Tickle Monster"
LANGUAGE.class_nightmare							= "Nightmare"
LANGUAGE.class_pukepus								= "Pukepus"
LANGUAGE.class_bonemesh								= "Bonemesh"
LANGUAGE.class_crow									= "Crow"
LANGUAGE.class_wilowisp								= "Wil O' Wisp"
LANGUAGE.class_zombie_torso							= "Torse d'un zombie"
LANGUAGE.class_zombie_legs							= "Jambes d'un zombie"
LANGUAGE.class_wraith								= "Spectre"
LANGUAGE.class_fast_zombie_legs						= "Jambes d'un zombie agile"
LANGUAGE.class_shade								= "Shade"

-- Class descriptions
LANGUAGE.description_zombie							= "Le zombie de base est résistant et porte de puissants coups.\nDur à abattre, surtout si on ne lui tire pas en pleine tête."
LANGUAGE.description_poison_zombie					= "Ce zombie est non seulement très durable mais possède aussi une force anormale.\nSon corps est extrêment toxique et n'hésitera pas à en arracher une partie pour la lancer sur des cibles trop éloignées."
LANGUAGE.description_fast_zombie					= "Ce cadavre composé pratiquement que d'os est extrêment rapide et agile.\nIl ne représente pas de réel danger mais peut en revanche grimper pratiquement partout grâce à ses griffes tranchantes.\nIls ont aussi aucun problème pour ce qu'il est de s'en prendre aux humains affaiblis."
LANGUAGE.description_bloated_zombie					= "Son corps est gorgé de produits toxiques et chimiques.\nMalgré leur lenteur, ils peuvent encaisser plus de coups."
LANGUAGE.description_ghoul							= "Sa chair est hautement toxique.\nSon corps frêle fait qu'il peut encaisser moins de coups, mais cela est compensé par ses attaques toxiques.\nSes griffes peuvent hébéter un humain et le goule peut aussi éjecter du poison s'il prend suffisamment de dégâts."
LANGUAGE.description_headcrab						= "Les crabes de tête sont les causes initiales de l'infection.\nOn ignore à ce jour leur origine.\nLeur méthode d'attaque est de se jeter en avant avec ses griffes tranchantes."
LANGUAGE.description_fast_headcrab					= "Le crabe de tête masculin est bien plus agile mais aussi plus frêle que la femelle.\nEn tous les cas, il est plus contrariant et dangereux en groupe."
LANGUAGE.description_poison_headcrab				= "Ce crabe de tête est gorgé de neurotoxines.\nUne morsure est généralement assez pour tuer un adulte.\nIl peut aussi cracher une boule de poison moins toxique.\nLe crachat est néanmoins mortel si un humain le reçoit dans les yeux."
LANGUAGE.description_the_tickle_monster				= "On dit que c'est le monstre qui attend sous votre lit pour vous prendre avec lui.\nLes bras du Tickle Monster sont très élastiques ce qui fait de lui un adversaire difficile à semer, ils sont aussi très redoutables contre les barricades."
LANGUAGE.description_nightmare						= "Une mutation extrêmement rare est ce qui a rendu le Nightmare surpuissant.\nPlus fort qu'un zombie de toutes les manières, c'est une force qu'il ne faut pas sous-estimer.\nUn coup de ses griffes est suffisant pour abattre une personne."
LANGUAGE.description_pukepus						= "Le corps putréfié du Puke Pus ne conserve que les organes produisant du vomi gorgé de poison.\nIl est capable de vomir des litres de poison en un instant, ce qui fait de lui un redoutable adversaire."
LANGUAGE.description_bonemesh						= "Défiguré et mutilé, le Bonemesh est capable de lancer des bombes sanguines.\nSes bombes sont à base de chair est de sang, potentiellement dangereuses pour les humains, elles font office de nourriture pour les zombies."
LANGUAGE.description_crow							= "Les corbeaux sont moins problématiques que lors de l'infection.\nIls se nourrissent de chair pourrie et transportent l'infection."
LANGUAGE.description_wilowisp						= "Parfois appelé l'Esprit des morts."
LANGUAGE.description_zombie_torso					= "Rien à voir par ici, circulez."
LANGUAGE.description_zombie_legs					= "Rien à voir par ici, circulez."
LANGUAGE.description_wraith							= "Un zombie ou une apparition?\nOn n'en sait peu sur lui à part le fait qu'il puisse se mettre invisible et découper les humains."
LANGUAGE.description_fast_zombie_legs				= "Rien à voir par ici, circulez."
LANGUAGE.description_shade							= "Grâce au champ de force magnétique autour de lui, les balles sont inutiles.\nIl est en revanche vulnérable aux lumières émises par les lampe-torches."

-- Class control schemes
LANGUAGE.controls_zombie							= "> {{bind:+attack|PRIMARY}}: Attaque\n> {{bind:+attack2|SECONDARY}}: Crier\n> {{bind:+reload|RELOAD}}: Crier\n> {{bind:+speed|SPRINT}}: Feindre la mort\n> TIR FATAL DANS LES JAMBES: Résurrection / Transformation"
LANGUAGE.controls_poison_zombie						= "> {{bind:+attack|PRIMARY}}: Attaque\n> {{bind:+attack2|SECONDARY}}: Lancer de la chair\n> {{bind:+reload|RELOAD}}: Crier"
LANGUAGE.controls_fast_zombie						= "> {{bind:+attack|PRIMARY}}: Attaque\n> {{bind:+attack2|SECONDARY}}: Attaquer / Escalader (près d'un mur)\n> {{bind:+reload|RELOAD}}: Crier"
LANGUAGE.controls_bloated_zombie					= "> {{bind:+attack|PRIMARY}}: Attaque\n> {{bind:+attack2|SECONDARY}}: Crier\n> {{bind:+speed|SPRINT}}: Feindre la mort\n> MORT: Morceaux empoisonnés"
--LANGUAGE.controls_ghoul							= "> {{bind:+attack|PRIMARY}}: Attaque empoisonnée\n> {{bind:+attack2|SECONDARY}}: Lancer de la chair\n> {{bind:+speed|SPRINT}}: Feindre la mort\n> {{bind:+reload|RELOAD}}: Crier\n> CONTACT D'UN HUMAIN: Ralentissement\n> ATTAQUÉ PAR UN HUMAIN: éjection de poison" -- Outdated
LANGUAGE.controls_headcrab							= "> {{bind:+attack|PRIMARY}}: Attaque\n> {{bind:+reload|RELOAD}}: S'enterrer"
LANGUAGE.controls_fast_headcrab						= "> {{bind:+attack|PRIMARY}}: Attaque"
LANGUAGE.controls_poison_headcrab					= "> {{bind:+attack|PRIMARY}}: Attaque\n> {{bind:+attack2|SECONDARY}}: Cracher du poison\n> MORSURE: Poison mortel\n> CRACHAT SUR LES YEUX: Aveuglé\n> {{bind:+reload|RELOAD}}: Crier"
LANGUAGE.controls_the_tickle_monster				= "> {{bind:+attack|PRIMARY}}: Attaque élastique\n> {{bind:+attack2|SECONDARY}}: Crier"
LANGUAGE.controls_nightmare							= "> {{bind:+attack|PRIMARY}}: Attaque mortelle\n> {{bind:+attack2|SECONDARY}}: Crier"
--LANGUAGE.controls_pukepus							= "> {{bind:+attack|PRIMARY}}: Vomir" -- Outdated
LANGUAGE.controls_bonemesh							= "> {{bind:+attack|PRIMARY}}: Attaque\n> {{bind:+attack2|SECONDARY}}: Lancer une bombe de sang"
LANGUAGE.controls_wraith							= "> {{bind:+attack|PRIMARY}}: Attaque\n> {{bind:+attack2|SECONDARY}}: Crier\n> L'INVISIBILITÉ DÉPEND DU MOUVEMENT ET DE LA DISTANCE"
--LANGUAGE.controls_shade							= "> {{bind:+attack|PRIMARY}}: Souveler\n> {{bind:+attack2|SECONDARY}}: Lancer" -- Outdated
