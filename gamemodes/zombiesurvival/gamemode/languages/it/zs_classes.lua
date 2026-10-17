-- Translated by Kradar (http://www.noxiousnet.com/forums/index.php?action=profile;u=6103)
-- Feel free to update translation for anyone

translate.AddLanguage("it", "Italian")

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

-- Class descriptions
LANGUAGE.description_zombie							= "Lo zombie di base è molto resistente e ha dei potenti artigli.\nE' duro da uccidere, specie se non si spara alla testa."
LANGUAGE.description_poison_zombie					= "Questo zombie mutante non solo è estremamente robusto ma è anche dotato di una forza fuori dal comune.\nIl suo corpo è altamente tossico ed è in grado di strapparsi da solo brani della propria carne per poi lanciarla lontano, ove le sue braccia non giungono."
LANGUAGE.description_fast_zombie					= "Questo cadavere ossuto è molto più veloce degli altri zombie.\nNon sono una grande minaccia da soli ma sono in grado di raggiungere quasi qualsiasi posto arrampicandosi con i loro artigli affilati.\nInoltre possono facilmente uccidere umani feriti o deboli."
LANGUAGE.description_bloated_zombie					= "Il loro corpo è ricco di sostanze chimiche tossiche e volatili.\nNonostante si muovano molto lentamente, occorre molto piu danno per buttarli giù."
LANGUAGE.description_ghoul							= "Questo zombie, anch'esso tossico, è leggermente più debole di altri, ma compensa questo difetto con i suoi attacchi velenosi.\nI suoi artigli possono debilitare un umano per un breve periodo di tempo e può  zombie has highly toxic flesh.\nIt's slightly weaker than other zombies but makes up for it with its poison attacks.\nIts claws can debilitate a human for a short time and it will eject poison through its wounds if hit with enough damage."
LANGUAGE.description_headcrab						= "Gli Headcrabs sono ciò che hanno causato l'infezione iniziale.\nNessuno è a conoscenza della loro origine.\nIl loro modo di attaccare è quello di saltare, mettendo in mostra i loro denti affilati nella loro parte inferiore del corpo."
LANGUAGE.description_fast_headcrab					= "L'headcrab maschio è decisamente più veloce della femmina, nonostante sia anche meno resistente.\nTuttavia, se sono in gruppo possono essere ugualmente pericolosi."
LANGUAGE.description_poison_headcrab				= "Questo tipo di Headcrab ha a disposizione delle neurotossine letali.\nUn morso di solito è sufficiente a uccidere un uomo.\nHa anche la facoltà di emettere una versione meno potente del proprio veleno.\n Lo 'sputo' è ugualmente letale se la vittima viene colpita in testa."
LANGUAGE.description_the_tickle_monster				= "Si dice che sia il mostro che si nasconde nel tuo armadio durante la notte per trascinarti a sè dal tuo letto.\nIl Tickle Monster è dotato di braccia quasi elastiche che gli permettono di rendere difficile la fuga a chiunque viene seguito da esso, e lo rendono anche un ideale distruttore di barricate."
LANGUAGE.description_nightmare						= "Una mutazione estremamente rara dona al Nightmare le sue abilità paranormali.\nE' molto più forte di ogni altro zombie, tanto da essere la creatura più temibile che esista.\nUn suo attacco è sufficiente a uccidere quasi chiunque."
LANGUAGE.description_pukepus						= "Il cadavere marcito del Puke Pus è composto interamente da organi adibiti alla produzione di veleno.\n E' capace di scagliare grandi quantità di vomito tossico alla volta, rendendolo estremamente pericoloso."
LANGUAGE.description_bonemesh						= "Sfigurato e squartato, il Bonemesh è capace di scaraventare bombe di sangue.\nOgni bomba è composta da ossa e carne che ferisce gli umani e al tempo stesso ciba gli altri zombie."
LANGUAGE.description_crow							= "I corvi corrieri sono più pestiferi rispetto a prima dell'infezione.\nSi cibano di carne infetta e diventano quindi corrieri per i non-morti.\nPerché ignorare questa classe?\nChe problemi hai?."
LANGUAGE.description_wilowisp						= "Spesso riferito ai spiriti dei morti."
LANGUAGE.description_zombie_torso					= "Non dovresti neanche vederlo."
LANGUAGE.description_zombie_legs					= "Non dovresti neanche vederlo."
LANGUAGE.description_wraith							= "Uno zombie o un'apparizione?\nNon si sa molto su di esso a parte il fatto che usi la sua\nUnica abilità di nascondersi e le sue unghie affilate per affettare ogni cosa."
LANGUAGE.description_fast_zombie_legs				= "Non dovresti neanche vederlo."
LANGUAGE.description_shade							= "Creando un forte campo magnetico attorno a se stesso, tutti i proiettili e attacchi ravvicinati vengono resi inutili contro di esso.\nTuttavia, per qualche strana ragione, lo Shade è vulnerabile alla luce chiara."

-- Class control schemes
LANGUAGE.controls_zombie							= "> {{bind:+attack|PRIMARY}}: Artigli\n> {{bind:+attack2|SECONDARY}}: Urlo\n> {{bind:+reload|RELOAD}}: Lamento\n> {{bind:+speed|SPRINT}}: Finta morte\n> Ucciso colpito alle gambe: Resurrezione / Trasformazione"
LANGUAGE.controls_poison_zombie						= "> {{bind:+attack|PRIMARY}}: Artigli\n> {{bind:+attack2|SECONDARY}}: Lancio di carne\n> {{bind:+reload|RELOAD}}: Urlo"
LANGUAGE.controls_fast_zombie						= "> {{bind:+attack|PRIMARY}}: Artigli\n> {{bind:+attack2|SECONDARY}}: Slancio / Arrampicarsi (vicino ad un muro)\n> {{bind:+reload|RELOAD}}: Urlo"
LANGUAGE.controls_bloated_zombie					= "> {{bind:+attack|PRIMARY}}: Artigli\n> {{bind:+attack2|SECONDARY}}: Lamento\n> {{bind:+speed|SPRINT}}: Finta morte\n> ALLA MORTE: Budella velenose"
--LANGUAGE.controls_ghoul   			            = "> {{bind:+attack|PRIMARY}}: Artigli di veleno\n> {{bind:+attack2|SECONDARY}}: Lancio di carne\n> {{bind:+speed|SPRINT}}: Finta morte\n> {{bind:+reload|RELOAD}}: Urlo\n> COLPENDO UN UMANO: Rallentamento\n> COLPITO DA UN UMANO: Emissione di veleno" -- Outdated
LANGUAGE.controls_headcrab							= "> {{bind:+attack|PRIMARY}}: Slancio\n> {{bind:+reload|RELOAD}}: Seppellimento"
LANGUAGE.controls_fast_headcrab						= "> {{bind:+attack|PRIMARY}}: Slancio"
LANGUAGE.controls_poison_headcrab					= "> {{bind:+attack|PRIMARY}}: Slancio\n> {{bind:+attack2|SECONDARY}}: Sputa veleno\n> COLPENDO UN UMANO: Veleno letale\n> COLPENDO AGLI OCCHI: Cecità\n> {{bind:+reload|RELOAD}}: Urlo"
LANGUAGE.controls_the_tickle_monster				= "> {{bind:+attack|PRIMARY}}: Unghie elastiche\n> {{bind:+attack2|SECONDARY}}: Lamento"
LANGUAGE.controls_nightmare							= "> {{bind:+attack|PRIMARY}}: Tocco della morte\n> {{bind:+attack2|SECONDARY}}: Lamento"
--LANGUAGE.controls_pukepus     					= "> {{bind:+attack|PRIMARY}}: Vomito" -- Outdated
LANGUAGE.controls_bonemesh							= "> {{bind:+attack|PRIMARY}}: Artigli\n> {{bind:+attack2|SECONDARY}}: Lancio bomba di sangue"
LANGUAGE.controls_wraith							= "> {{bind:+attack|PRIMARY}}: Artigli\n> {{bind:+attack2|SECONDARY}}: Urlo\n> INVISIBILITA' BASATA SULLA VISIBILITA' E SULLA DISTANZA"
--LANGUAGE.controls_shade   			            = "> {{bind:+attack|PRIMARY}}: Solleva\n> {{bind:+attack2|SECONDARY}}: Lancio" -- Outdated