-- Translated by Mr. Darkness (http://www.noxiousnet.com/forums/index.php?action=profile;u=6296)
-- Feel free to update translation for anyone

translate.AddLanguage("ru", "Russian")

-- ============================================================
-- Zombie classes: names, descriptions, controls
-- ============================================================

-- Class names
LANGUAGE.class_zombie								= "Зомби"
LANGUAGE.class_poison_zombie						= "Ядовитый зомби"
LANGUAGE.class_fast_zombie							= "Быстрый зомби"
LANGUAGE.class_bloated_zombie						= "Жирный зомби"
LANGUAGE.class_classic_zombie						= "Классический зомби"
LANGUAGE.class_super_zombie							= "Супер зомби"
LANGUAGE.class_fresh_dead							= "Свежий зараженный"
LANGUAGE.class_ghoul								= "Вурдалак"
LANGUAGE.class_headcrab								= "Хэдкраб"
LANGUAGE.class_fast_headcrab						= "Быстрый хэдкраб"
LANGUAGE.class_poison_headcrab						= "Ядовитый хэдкраб"
LANGUAGE.class_the_tickle_monster					= "The Tickle Monster"
LANGUAGE.class_nightmare							= "Nightmare"
LANGUAGE.class_pukepus								= "Pukepus"
LANGUAGE.class_bonemesh								= "Bonemesh"
LANGUAGE.class_crow									= "Ворон"
LANGUAGE.class_wilowisp								= "Wil O' Wisp"
LANGUAGE.class_zombie_torso							= "Торс зомби"
LANGUAGE.class_zombie_legs							= "Ноги зомби"
LANGUAGE.class_wraith								= "Дух"
LANGUAGE.class_fast_zombie_legs						= "Ноги быстрого зомби"
LANGUAGE.class_shade								= "Shade"

-- Class descriptions
LANGUAGE.description_zombie							= "Обычный зомби очень стойкий и довольно силен.\nЕго сложно положить, особенно если не стрелять в голову."
LANGUAGE.description_poison_zombie					= "Этот мутированный зараженный не только серьезно стойкий у него также высокая сила удара.\nЕго тело очень токсично И рвёт его собственное мясо и кожу что позволяет ему кидать все это в выживших."
LANGUAGE.description_fast_zombie					= "Этот кадавр гораздо быстрее, чем остальные зараженные.\nОни не такие опасные одиночками, Но могут достигнуть любого района, ползая по стенам своими острыми когтями.\nОни также могут без проблем охотиться на слабых, еле живых выживших."
LANGUAGE.description_bloated_zombie					= "Их тело состоит из токсичных веществ.\nХоть они и двигаются медленно, они могут нанести большой ущерб."
LANGUAGE.description_ghoul							= "У этого зомби высоко токсичная плоть.\nЭтот зомби немного слабее других, но наносит большой ущерб своими токсическими атаками.\nЕго когти могут ослабить выжившего на короткий срок, а также он выпускает яд из своих ран, если ущерб, нанесенный ему будет довольно высоким."
LANGUAGE.description_headcrab						= "Хэдкрабы - первая причина заражения.\nНикто не знает, откуда они на самом деле пришли.\nИх метод атаки заключается в прыгании на жертву своими когтями на животе."
LANGUAGE.description_fast_headcrab					= "Самец хэдкраба гораздо быстрее, но слабее, чем самка.\nНо как бы ни так, они все же надоедливее и опаснее в группах."
LANGUAGE.description_poison_headcrab				= "Этот хэдкраб полон нейротоксинов.\nОдного укуса обычно достаточно, чтобы убить взрослого человека.\nОн также может плеваться менее опасным ядом.\nПлевок, однако также смертельно опасен, если попадает в лицо своей жертвы."
LANGUAGE.description_the_tickle_monster				= "Известен, как \"монстр, прячущийся у тебя в шкафу\" чтобы ночью утащить тебя из твоей кровати.\nУ этого Tickle Monster почти эластичные руки, что делают его неизбегаемым как и почти что идеальным уничтожителем баррикад."
LANGUAGE.description_nightmare						= "Этой очень редкой мутации дает необычные способности Nightmare.\nОн сильнее, чем любой обычный зараженный в почти что любом направлении, у Nightmare ужасающая сила.\nОдного взмаха когтями обычно достаточно чтобы убить выжившего."
LANGUAGE.description_pukepus						= "Гниющее тело Puke Pus использует внутренние органы для создания яда.\nОн способен извергать массы рвоты яда, который очень опасен."
LANGUAGE.description_bonemesh						= "Без фигуры и изуродованный Bonemesh способен делать бомбы из крови.\nКаждая бомба состоит из костей и плоти, которая вредит выжившим, одновременно являясь отличной едой для других зараженных."
LANGUAGE.description_crow							= "Отвратительные вороны сейчас более чем паразиты после инфекции.\nОни питаются плотью зараженных и становятся \"носителями\" зараженным.\nПочему вы вообще не скрыли этот класс?\nЧто с Вами не так?"
LANGUAGE.description_wilowisp						= "Иногда известный, как \"дух зараженных\"."
LANGUAGE.description_zombie_torso					= "Вам даже не следует видеть ЭТО."
LANGUAGE.description_zombie_legs					= "Это не для Ваших глаз."
LANGUAGE.description_wraith							= "Зомби или иллюзия?\nНе многое известно о нем, кроме факта, что его\nнеобычная способность невидимости и острые когти могут разрезать все по кусочкам."
LANGUAGE.description_fast_zombie_legs				= "Не для Ваших глаз."
LANGUAGE.description_shade							= "Создавая сильное магнитное поле вокруг себя, все пули и рукопашные атаки бесполезны против него.\nОднако, по какой-то причине Shade раним ярким светом."

-- Class control schemes
LANGUAGE.controls_zombie							= "> {{bind:+attack|PRIMARY}}: Когти\n> {{bind:+attack2|SECONDARY}}: Крик\n> {{bind:+reload|RELOAD}}: Плач\n> {{bind:+speed|SPRINT}}: Притвориться мертвым\n> УБИЙСТВО В НОГИ: Шанс на реанимацию / трансформация"
LANGUAGE.controls_poison_zombie						= "> {{bind:+attack|PRIMARY}}: Когти\n> {{bind:+attack2|SECONDARY}}: Кинуть плотью\n> {{bind:+reload|RELOAD}}: Крик"
LANGUAGE.controls_fast_zombie						= "> {{bind:+attack|PRIMARY}}: Когти\n> {{bind:+attack2|SECONDARY}}: Пригнуть высоко / Лазить (по стене)\n> {{bind:+reload|RELOAD}}: Крик"
LANGUAGE.controls_bloated_zombie					= "> {{bind:+attack|PRIMARY}}: Когти\n> {{bind:+attack2|SECONDARY}}: Плач\n> {{bind:+speed|SPRINT}}: Притвориться мертвым\n> СМЕРТЬ: Ядовитые куски плоти"
--LANGUAGE.controls_ghoul							= "> {{bind:+attack|PRIMARY}}: Ядовитые когти\n> {{bind:+attack2|SECONDARY}}: Кинуть плотью\n> {{bind:+speed|SPRINT}}: Притвориться мертвым\n> {{bind:+reload|RELOAD}}: Крик\n> УДАРИВ ВЫЖИВШЕГО: Замедление\n> ПРИ ПОЛУЧЕНИИ РАНЕНИЯ: Выпуск яда из ран" -- Outdated
LANGUAGE.controls_headcrab							= "> {{bind:+attack|PRIMARY}}: Укус в прыжке\n> {{bind:+reload|RELOAD}}: Зарыться под землю"
LANGUAGE.controls_fast_headcrab						= "> {{bind:+attack|PRIMARY}}: Укус в прыжке"
LANGUAGE.controls_poison_headcrab					= "> {{bind:+attack|PRIMARY}}: Укус в прыжке\n> {{bind:+attack2|SECONDARY}}: Плевок ядом\n> УДАРИВ ВЫЖИВШЕГО: Смертельный яд\n> ПОПАДАНИЕ ЯДОМ В ГЛАЗА: Ослепление\n> {{bind:+reload|RELOAD}}: Крик"
LANGUAGE.controls_the_tickle_monster				= "> {{bind:+attack|PRIMARY}}: Эластичные когти\n> {{bind:+attack2|SECONDARY}}: Плач"
LANGUAGE.controls_nightmare							= "> {{bind:+attack|PRIMARY}}: Прикосновение смерти\n> {{bind:+attack2|SECONDARY}}: Плач"
--LANGUAGE.controls_pukepus							= "> {{bind:+attack|PRIMARY}}: Рвота" -- Outdated
LANGUAGE.controls_bonemesh							= "> {{bind:+attack|PRIMARY}}: Когти\n> {{bind:+attack2|SECONDARY}}: Кинуть кровавой бомбой"
LANGUAGE.controls_wraith							= "> {{bind:+attack|PRIMARY}}: Когти\n> {{bind:+attack2|SECONDARY}}: Крик\n> НЕВИДИМОСТЬ ЗАВИСИТ ОТ ДВИЖЕНИЯ И РАССТОЯНИЯ ВИДИМОСТИ"
--LANGUAGE.controls_shade							= "> {{bind:+attack|PRIMARY}}: Левитация\n> {{bind:+attack2|SECONDARY}}: Кинуть" -- Outdated