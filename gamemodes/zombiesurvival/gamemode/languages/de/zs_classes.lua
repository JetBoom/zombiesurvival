-- Translated by Raptor (http://www.noxiousnet.com/forums/index.php?action=profile;u=5280)
-- Feel free to update translation for anyone

translate.AddLanguage("de", "German")

-- ============================================================
-- Zombie classes: names, descriptions, controls
-- ============================================================

-- Class names
LANGUAGE.class_zombie								= "Zombie"
LANGUAGE.class_poison_zombie						= "Gift Zombie"
LANGUAGE.class_fast_zombie							= "Schneller Zombie"
LANGUAGE.class_bloated_zombie						= "Aufgeblähter Zombie"
LANGUAGE.class_classic_zombie						= "Klassischer Zombie"
LANGUAGE.class_super_zombie							= "Super Zombie"
LANGUAGE.class_fresh_dead							= "Fresh Dead"
LANGUAGE.class_ghoul								= "Ghoul"
LANGUAGE.class_headcrab								= "Headcrab"
LANGUAGE.class_fast_headcrab						= "Schnelles Headcrab"
LANGUAGE.class_poison_headcrab						= "Gift Headcrab"
LANGUAGE.class_the_tickle_monster					= "The Tickle Monster"
LANGUAGE.class_nightmare							= "Nightmare"
LANGUAGE.class_pukepus								= "Pukepus"
LANGUAGE.class_bonemesh								= "Bonemesh"
LANGUAGE.class_crow									= "Krähe"
LANGUAGE.class_wilowisp								= "Wil O' Wisp"
LANGUAGE.class_zombie_torso							= "Zombietorso"
LANGUAGE.class_zombie_legs							= "Zombiebeine"
LANGUAGE.class_wraith								= "Wraith"
LANGUAGE.class_fast_zombie_legs						= "Beine des schnellen Zombies"
LANGUAGE.class_shade								= "Shade"

-- Class descriptions
LANGUAGE.description_zombie							= "Der normale Zombie ist sehr beständig und hat kraftvolle Klauen.\nEs ist schwer ihn unten zu halten, vor allem wenn er nicht in den Kopf geschossen wird."
LANGUAGE.description_poison_zombie					= "Dieser mutierte Zombie is nicht nur extrem langlebig, aber hat auch noch eine abnormale Kraft.\nSein Körper is extrem giftig. Er wird sogar sein eigenes Fleisch rausreissen und es auf Dinge werfen, die zu weit weg zum schlagen sind."
LANGUAGE.description_fast_zombie					= "Dieser knochige Kadaver ist viel schneller als andere Zombies.\nSie sind keine große Bedrohung alleine, aber können fast jedes Gebiet durchs Klettern mit ihren rasierscharfen Klauen erreichen.\nZudem haben sie keine Problem schwache oder verletzte Menschen zu jagen."
LANGUAGE.description_bloated_zombie					= "Ihre Körper beinhalten unberechenbare, giftige Chemikalien.\nObwohl sie sich langsamer bewegen, können sie etwas mehr einstecken."
LANGUAGE.description_ghoul							= "Dieser Zombie hat hoch giftiges Fleisch.\nEs is etwas schwächer als andere Zombies, gleicht das jedoch wieder aus mit seinen Giftattacken.\nSeine Klauen können einen Menschen für kurze Zeit entkräften und es wird Gift ausstoßen, wenn es mit genügend Kraft schlägt."
LANGUAGE.description_headcrab						= "Headcrabs sind was die Infektionen begonnen haben.\nNiemand weiss woher sie tatsächlich gekommen sind.\nIhre Angriffsmethode ist es sich auf ihr Opfer mit ihren scharfen Zähnen auf ihrem Bauch zu stürzen."
LANGUAGE.description_fast_headcrab					= "Das männliche Headcrab ist beträchtlich schneller, aber nicht so kräftig wie das weibliche.\nSo oder so sind sie beide gleich nervig und tödlich in Gruppen."
LANGUAGE.description_poison_headcrab				= "Diese Headcrab ist voller tödlichem Nervengift.\nEin Biss ist immer genug um einen erwachsenen Menschen zu töten.\nEs hat zudem die Fähigkeit eine wenige wirksame Version seines Giftes zu spucken.\nDer Speichel ist genau so tödlich, wenn ihr Opfer damit ins Gesicht getroffen wird."
LANGUAGE.description_the_tickle_monster				= "Bekannt als das Monster, dass sich nachts in deinem Schrank versteckt, um dich aus deinem Bett zu ziehen.\nDie beinahe elastischen Arme des Tickle Monsters machen es extrem schwer zu entkommen, zudem sind sie ideal zum zerstören von Barrikaden."
LANGUAGE.description_nightmare						= "Eine extrem seltene Mutation gibt dem Nightmare seine abnormalen Kräfte.\nStärker als der x-beliebige Zombie in soziemlich jeder Weise ist der Nightmare eine Einheit mit dar man rechnen muss.\nEin Schwung mit seinen Klauen ist genug um fast jede Person auszuschalten."
LANGUAGE.description_pukepus						= "Der verrottende Körper des Puke Pus ist komplett gefüllt mit Organen, die zur Produktion von Gift dienen.\nEs ist in der Lage Gallonen an giftiger Kotze auf ein Mal zu erbrechen, was es extrem gefährlich macht."
LANGUAGE.description_bonemesh						= "Entstellt und übel zugerichtet ist es dem Bonemesh möglich Blutbomben zu werfen.\nJede Bombe enthält Knochen und Fleisch, was Menschen schmerzen bereitet, aber anderen Zombies während dessen wertvolle Nahrung gibt."
LANGUAGE.description_crow							= "Aaskrähen sind eine größere Plage als bevor der Epidemie.\nSie nähren sich an infiziertem Fleich und werden zu 'Trägern' für die Untoten.\nWarum würdest du jemals diese Klasse nicht versteckt halten?\nWas stimmt mit dir nicht?"
LANGUAGE.description_wilowisp						= "Manchmal als Geister der Toten bezeichnet."
LANGUAGE.description_zombie_torso					= "Du solltest das noch nicht einmal sehen."
LANGUAGE.description_zombie_legs					= "Du solltest das noch nicht einmal sehen."
LANGUAGE.description_wraith							= "Ein Zombie oder ein Gespenst?\nNicht viel ist über es bekannt, außer der Tatsache dass es seine\nbesondere Unsichtbarkeit und scharfen Klauen verwendet um Dinge in Scheiben zu schneiden."
LANGUAGE.description_fast_zombie_legs				= "Du solltest das noch nicht einmal sehen."
LANGUAGE.description_shade							= "In dem es ein starkes magnetisches Feld um sich herum aufbaut werden alle Angriffe mit Projektilen und Nahkampfwaffen nutzlos.\nAus irgendeinem Grund ist Shade verletzbar bei hellem Licht."

-- Class control schemes
LANGUAGE.controls_zombie							= "> {{bind:+attack|PRIMARY}}: Klauen\n> {{bind:+attack2|SECONDARY}}: Schrei\n> {{bind:+reload|RELOAD}}: Stöhnen\n> {{bind:+speed|SPRINT}}: Tod vortäuschen\n> BEI FATALEM ANGRIFF AUF DIE BEINE: Wiederbeleben / Transformieren"
LANGUAGE.controls_poison_zombie						= "> {{bind:+attack|PRIMARY}}: Klauen\n> {{bind:+attack2|SECONDARY}}: Fleisch werfen\n> RELOAD: Schreien"
LANGUAGE.controls_fast_zombie						= "> {{bind:+attack|PRIMARY}}: Klauen\n> {{bind:+attack2|SECONDARY}}: Sturzangriff / Klettern (nahe einer Wand)\n> RELOAD: Schreien"
LANGUAGE.controls_bloated_zombie					= "> {{bind:+attack|PRIMARY}}: Klauen\n> {{bind:+attack2|SECONDARY}}: Stöhnen\n> SPRINT: Tod vortäuschen\n> BEIM TOD: Giftige Innereien"
--LANGUAGE.controls_ghoul							= "> {{bind:+attack|PRIMARY}}: Giftklauen\n> {{bind:+attack2|SECONDARY}}: Fleisch werfen\n> {{bind:+speed|SPRINT}}: Tod vortäuschen\n> {{bind:+reload|RELOAD}}: Schreien\n> BEIM SCHLAG AUF MENSCHEN: Verlangsamen\n> BEIM SCHLAG VON MENSCHEN: Auswurf von Gift" -- Outdated
LANGUAGE.controls_headcrab							= "> {{bind:+attack|PRIMARY}}: Sturzangriff\n> {{bind:+reload|RELOAD}}: Vergraben"
LANGUAGE.controls_fast_headcrab						= "> {{bind:+attack|PRIMARY}}: Sturzangriff"
LANGUAGE.controls_poison_headcrab					= "> {{bind:+attack|PRIMARY}}: Sturzangriff\n> {{bind:+attack2|SECONDARY}}: Gift spucken\n> BEIM SCHLAG AUF MENSCHEN: Tödliches Gift\n> WENN GIFT AUGEN TRIFFT: Blind machen\n> {{bind:+reload|RELOAD}}: Schreien"
LANGUAGE.controls_the_tickle_monster				= "> {{bind:+attack|PRIMARY}}: Elastische Klauen\n> {{bind:+attack2|SECONDARY}}: Stöhnen"
LANGUAGE.controls_nightmare							= "> {{bind:+attack|PRIMARY}}: Todesberührung\n> {{bind:+attack2|SECONDARY}}: Stöhnen"
--LANGUAGE.controls_pukepus							= "> {{bind:+attack|PRIMARY}}: Erbrechen" -- Outdated
LANGUAGE.controls_bonemesh							= "> {{bind:+attack|PRIMARY}}: Klauen\n> {{bind:+attack2|SECONDARY}}: Blutbombe werfen"
LANGUAGE.controls_wraith							= "> {{bind:+attack|PRIMARY}}: Klauen\n> {{bind:+attack2|SECONDARY}}: Schreien\n> UNSICHTBARKEIT BASIEREND AUF BEWEGUNG UND SICHT"
--LANGUAGE.controls_shade							= "> {{bind:+attack|PRIMARY}}: Heben\n> {{bind:+attack2|SECONDARY}}: Werfen" -- Outdated
