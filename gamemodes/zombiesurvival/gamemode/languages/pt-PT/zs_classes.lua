-- Translated by rui_troia (http://www.noxiousnet.com/forums/index.php?action=profile;u=6471)
-- Feel free to update translation for anyone

translate.AddLanguage("pt-PT", "Portuguese")

-- ============================================================
-- Zombie classes: names, descriptions, controls
-- ============================================================

-- Class names
LANGUAGE.class_zombie								= "Zombie"
LANGUAGE.class_poison_zombie						= "Zombie Venenoso"
LANGUAGE.class_fast_zombie							= "Zombie Rápido"
LANGUAGE.class_bloated_zombie						= "Zombie Inchado"
LANGUAGE.class_classic_zombie						= "Zombie Classico"
LANGUAGE.class_super_zombie							= "Super Zombie"
LANGUAGE.class_fresh_dead							= "Morto fresco"
LANGUAGE.class_ghoul								= "Ghoul"
LANGUAGE.class_headcrab								= "Headcrab"
LANGUAGE.class_fast_headcrab						= "Headcrab Rápido"
LANGUAGE.class_poison_headcrab						= "Headcrab Venenoso"
LANGUAGE.class_the_tickle_monster					= "The Tickle Monster"
LANGUAGE.class_nightmare							= "Nightmare"
LANGUAGE.class_pukepus								= "Pukepus"
LANGUAGE.class_bonemesh								= "Bonemesh"
LANGUAGE.class_crow									= "Corvo"
LANGUAGE.class_wilowisp								= "Wil O' Wisp"
LANGUAGE.class_zombie_torso							= "Torso Zombie"
LANGUAGE.class_zombie_legs							= "Zombie Pernas"
LANGUAGE.class_wraith								= "Wraith"
LANGUAGE.class_fast_zombie_legs						= "Zombie Rápido pernas"
LANGUAGE.class_shade								= "Shade"

-- Class descriptions
LANGUAGE.description_zombie							= "O Zombie básico que é muito duravel e tem garras potentes.\nÉ dificil de ser derrubado, especialmente se não é disparado na cabeça."
LANGUAGE.description_poison_zombie					= "Este zombie mutante não é so extremamente duravel mas tem uma força anormal.\nSeu corpo é extremamente tóxico e irá arrancar e atirar a sua própia carne para longe."
LANGUAGE.description_fast_zombie					= "Este cadáver ossoso é muito mais rápido comparado com os outros zombies.\nEles não são uma ameaça por eles própios, mas podem alcançar uma área perto deles, subindo com as suas garras.\nEles também não têm problema quando caçam humanos fracos com pouca vida."
LANGUAGE.description_bloated_zombie					= "O corpo é constituído por voláteis, qúimicos tóxicos.\nMesmo que eles movem devagar, eles podem levar um pouco mais do que uma batida."
LANGUAGE.description_ghoul							= "Este zombie tem uma carne muito tóxica.\nÉ um pouco fraco comparado com os outros zombies, mas compensa com o seu ataque venenoso.\nSuas garras podem delibirar um humano por um curto periodo de tempo e irá ejectar veneno através dos seus ferimentos, se danificado com dano suficiente."
LANGUAGE.description_headcrab						= "Headcrabs foram a causa da infeção original\nNinguém sabe de onde eles verdadeiramente vieram.\nO seu método de ataque é morder com os seus dentes na sua barriga."
LANGUAGE.description_fast_headcrab					= "O headcrab macho é consideravelmente rápido mas menos carnudo que a fémea.\nDe qualquer maneira, é igualmente chato e mortífero em grupos."
LANGUAGE.description_poison_headcrab				= "Este headcrab está cheio de neurotóxinas.\nUma dentada é suficiente para matar um humano adulto.\nTambém tem a habilidade de guspir uma parte fraca do seu veneno.\nO guspo é mais mortífero se atinge a cabeça da vitima."
LANGUAGE.description_the_tickle_monster				= "Dito para ser o monstro que esconde no teu armário e te puxa da cama.\nOs braços do Tickle Monster são elásticos que o faz extremamente dificil de ser ultrapassado e também o fazem o ideal destruídor de barricadas."
LANGUAGE.description_nightmare						= "Uma extremamente rara mutação dá o Nightmare as suas habilidades.\nMais forte do que qualquer outro zombie em quase qualquer forma, o Nightmare é a força para ser contada.\nUma passada com as suas garras é o suficiente para derrubar a maioria das pessoas."
LANGUAGE.description_pukepus						= "O corpo apodrecído de Puke Pus é compremetido inteiramente com orgãos que são usados para fazer a regeneração de veneno.\nÉ capáz de vomitar galões de vómito infectado que o torna extremamente perigoso."
LANGUAGE.description_bonemesh						= "Desfigurado e mutilado, o Bonemesh é capaz de atirar bombas de sangue.\nCada bomba é compremetida com ossos e carnes que é uma grande ameaça para os Humanos, no entanto é uma refeição deliciosa para os zombies."
LANGUAGE.description_crow							= "Corvos carnivoros são mais do que uma peste do que eles eram antes da infeção.\nEles alimentam-se da carne dos infectados e funcionam como ''carregadores'' para os Mortos-Vivos.\nPorque nunca querias fazer esta classe escondida?\nQual é o teu problema?"
LANGUAGE.description_wilowisp						= "Ás vezes referidos como espíritos dos mortos."
LANGUAGE.description_zombie_torso					= "Tu nem devias estar a ver isto."
LANGUAGE.description_zombie_legs					= "Tu nem devias estar a ver isto."
LANGUAGE.description_wraith							= "Um zombie ou uma aparição?\nNada se sabe muito sobre isso, tirando o facto que usa a sua\núnica habilidade desprevinida e garras afiádas para cortar coisas aos pedaços."
LANGUAGE.description_fast_zombie_legs				= "Tu nem devias a estar a ver isto."
LANGUAGE.description_shade							= "Criando um campo magnético á sua volta, todos os ataques a bala e melee são inúteis contra ele.\nPor alguma razão, Shade é vulneravel á luz brilhante."

-- Class control schemes
LANGUAGE.controls_zombie							= "> {{bind:+attack|PRIMARY}}: Garras\n> {{bind:+attack2|SECONDARY}}: Gritar\n> {{bind:+reload|RELOAD}}: Queixar\n> {{bind:+speed|SPRINT}}: Fingir morte\n> DISPARO FATAL NAS PERNAS: Reviver / Transformar"
LANGUAGE.controls_poison_zombie						= "> {{bind:+attack|PRIMARY}}: Claws\n> {{bind:+attack2|SECONDARY}}: Atirar carne\n> RELOAD: Gritar"
LANGUAGE.controls_fast_zombie						= "> {{bind:+attack|PRIMARY}}: Claws\n> {{bind:+attack2|SECONDARY}}: Atirar-se / Trepar (próximo da parede)\n> {{bind:+reload|RELOAD}}: Gritar"
LANGUAGE.controls_bloated_zombie					= "> {{bind:+attack|PRIMARY}}: Claws\n> {{bind:+attack2|SECONDARY}}: Queixar\n> {{bind:+speed|SPRINT}}: Fingir morte\n> NA MORTE: Sangue venenoso"
--LANGUAGE.controls_ghoul						    = "> {{bind:+attack|PRIMARY}}: Garras venenósas\n> {{bind:+attack2|SECONDARY}}: Atirar carne\n> {{bind:+speed|SPRINT}}: Fingir morte\n> {{bind:+reload|RELOAD}}: Gritar\n> QUANDO ATINGE HUMANO: Lento\n> ATINGIDO POR HUMANO: Ejeção de veneno" -- Outdated
LANGUAGE.controls_headcrab							= "> {{bind:+attack|PRIMARY}}: Ataque estocado\n> {{bind:+reload|RELOAD}}: Cavar"
LANGUAGE.controls_fast_headcrab						= "> {{bind:+attack|PRIMARY}}: Ataque estocado"
LANGUAGE.controls_poison_headcrab					= "> {{bind:+attack|PRIMARY}}: Ataque estocado\n> {{bind:+attack2|SECONDARY}}: Guspir Veneno\n> QUANDO ATINGE HUMANO: Veneno mortífero\n> QUANDO ATINGE NOS OLHOS: Cegueira\n> {{bind:+reload|RELOAD}}: Gritar"
LANGUAGE.controls_the_tickle_monster				= "> {{bind:+attack|PRIMARY}}: Garras elásticas\n> {{bind:+attack2|SECONDARY}}: Queixar"
LANGUAGE.controls_nightmare							= "> {{bind:+attack|PRIMARY}}: Toque mortífero\n> {{bind:+attack2|SECONDARY}}: Queixar"
--LANGUAGE.controls_pukepus							= "> {{bind:+attack|PRIMARY}}: Vómito" -- Outdated
LANGUAGE.controls_bonemesh							= "> {{bind:+attack|PRIMARY}}: Garras\n> {{bind:+attack2|SECONDARY}}: Atira bomba de sangue"
LANGUAGE.controls_wraith							= "> {{bind:+attack|PRIMARY}}: Garras\n> {{bind:+attack2|SECONDARY}}: Gritar\n> INVISIBILIDADE BASEADA NO MOVIMENTO E DISTANCIA"
--LANGUAGE.controls_shade							= "> {{bind:+attack|PRIMARY}}: Subir\n> {{bind:+attack2|SECONDARY}}: Atirar" -- Outdated