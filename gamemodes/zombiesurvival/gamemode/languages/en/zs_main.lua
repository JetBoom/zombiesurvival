--[[
English is the standard language that you should base your ID's off of.
If something isn't found in your language file then it will fall back to English.

Valid languages (from gmod's menu): bg cs da de el en en-PT es-ES et fi fr ga-IE he hr hu it ja ko lt nl no pl pt-BR pt-PT ru sk sv-SE th tr uk vi zh-CN zh-TW
You MUST use one of the above when using translate.AddLanguage

============================================================================
RULES FOR TRANSLATORS
============================================================================
* Only translate formally. No slang, no improper grammar, no misspellings.
* Do not translate proper nouns (JetBoom, etc.). For weapon names, translate 
  only the descriptive part ('Peashooter' Handgun). For class names,
  translate the words (Bloated Zombie) but not the invented names.
* Comment out anything you have not translated yet. Missing keys fall back
  to English automatically.
* Keep the original key order where possible.
* Do not duplicate keys between files. If two files define the same key,
  whichever loads last wins.
* Prefer clarity over style.

============================================================================
PLURALS
============================================================================
A value can be a plain string, or a table of plural forms: zero (optional),
one, few, many, other. The form used is decided by the language's plural
rule. Missing forms fall back in the order: other, many, few, one.

Russian needs one/few/many/other; using only one/other will give wrong
forms for 2-4.

============================================================================
PLACEHOLDERS
============================================================================
* Never translate or drop placeholders: %s, %d, %%, %1$s, %2$d, {{SomeKey}}.
* You may reorder numbered placeholders (%1$s, %2$d) to fit your language.
* Non-numbered placeholders (%s, %d) fill in order and must not be reordered
  unless you switch to the numbered form.
* %% is a literal percent sign and must stay %% in translations.
* {{...}} names are resolved by the attribute system; copy them verbatim.

============================================================================
CASES (nom, gen, acc, dat, ins, pre)
============================================================================
A noun that is substituted into another translated sentence (%s = class or
item name) may need a different grammatical form in that sentence. Provide
all forms as a table instead of a plain string:

    LANGUAGE.class_fast_zombie = {
        nom = "Быстрый зомби",       -- nominative
        gen = "Быстрого зомби",      -- genitive
        acc = "Быстрого зомби",      -- accusative
        dat = "Быстрому зомби",      -- dative
        ins = "Быстрым зомби",       -- instrumental
        pre = "Быстром зомби",       -- prepositional
    }

* Only nom is required. Missing forms fall back to nom.
* A language that does not inflect nouns (English, CJK, most Romance
  and Germanic languages) can just use a plain string — no table.
* A message can pin the case it needs via LANGUAGE.class_case_<message_id>,
  which overrides the case chosen by code.
* Do not mix case keys with plural keys (one/few/many/other) in one table.

============================================================================
FILE LAYOUT
============================================================================
zs_lang_config.lua      language settings, do not translate
zs_key_names.lua        key/button names
zs_main.lua             core gamemode strings and in-round notices
zs_ui.lua               UI, options, skillweb, scoreboard, endboard
zs_classes.lua          zombie classes
zs_help.lua             in-game help pages
zs_ammo.lua             ammo names and item formats
zs_weapons.lua          weapons and qualities
zs_skills.lua           skill names and static descriptions
zs_attributes.lua       shared attribute templates
zs_inventory_items.lua  trinkets and craft items
maps/                   per-map strings, one file per map

Keep this split in your own language folder.

============================================================================
DUMPING MAP TEXTS
============================================================================
To translate text hardcoded into a map (game_text, env_message, logic_waves
outputs, etc.), use the server console command:

    zs_dumpmaptexts

* Requires SuperAdmin privileges (or run from the server console).
* Generates a file at: data/zs_maptexts/<mapname>.lua.txt
* Copy the generated LANGUAGE.xxx = "..." lines into:
      languages/<lang>/maps/<mapname>.lua
* Translate the right-side strings. Do NOT modify the keys or the
  LANGUAGE.__map_signature line — it is required so the engine can
  match the translation to the map even if the file name differs from
  the actual map name (e.g., map versions like _v1, _b2).

============================================================================
FALLBACK
============================================================================
Missing key -> English value is used.
Empty string value -> empty string is used.
Partial plural table -> missing forms are filled in the order
other, many, few, one.
============================================================================
]]

translate.AddLanguage("en", "English")

-- ============================================================
-- Core gamemode strings
-- ============================================================

LANGUAGE.infliction_reached							= "%d%% of humans have died!"
LANGUAGE.x_unlocked									= "%s unlocked!"
LANGUAGE.list_separator								= ", "
LANGUAGE.and_separator								= " and "
LANGUAGE.final_and_separator						= ", and "
LANGUAGE.disconnect_killed							= "%1$s was disconnect killed by %2$s."
LANGUAGE.nail_removed_by							= "%1$s removed a nail belonging to %2$s."
LANGUAGE.banned_for_life_warning					= "You have the Banned for Life skill active so you can't purchase anything!"
LANGUAGE.late_buyer_warning							= "You have the Late Buyer skill active so you can't purchase anything until the second half!"
LANGUAGE.late_buyer_finished						= "The late buyer period has finished. You can now purchase items from the arsenal."
LANGUAGE.need_to_be_near_arsenal_crate				= "You need to be near an Arsenal Crate to purchase items!"
LANGUAGE.need_to_be_near_remantler					= "You need to be near a Remantler!"
LANGUAGE.cant_purchase_right_now					= "You can't purchase anything right now."
LANGUAGE.dont_have_enough_points					= "You don't have enough points."
LANGUAGE.need_to_have_enough_scrap					= "You don't have enough scrap."
LANGUAGE.cannot_dismantle							= "You cannot dismantle this item."
LANGUAGE.prepare_yourself							= "Prepare yourself..."
LANGUAGE.purchased_x_for_y_points					= {one = "Purchased %1$s for %2$d point!", other = "Purchased %1$s for %2$d points!"}
LANGUAGE.created_x_for_y_scrap						= "Created %s for %d scrap!"
LANGUAGE.give_time_before_suicide					= "Give others time to spawn before suiciding."
LANGUAGE.no_spare_ammo_to_give						= "No spare ammo to give!"
LANGUAGE.no_person_in_range							= "No person in range!"
LANGUAGE.that_life									= "That life..."
LANGUAGE.x_damage_to_barricades						= "%d damage to barricades"
LANGUAGE.x_damage_to_humans							= "%d damage to humans"
LANGUAGE.x_brains_eaten								= {one = "%d brain eaten", other = "%d brains eaten"}
LANGUAGE.press_x_to_free_roam						= "Press {{bind:+jump|JUMP}} to free roam"
LANGUAGE.press_x_to_spawn							= "Press {{bind:+attack|LMB}} to spawn randomly"
LANGUAGE.press_x_to_spawn_far						= "Press {{bind:+reload|RELOAD}} to spawn far away from survivors"
LANGUAGE.press_x_nest_menu							= "Press {{bind:+walk}} to open the nest menu/spawn on minions"
LANGUAGE.press_x_to_spawn_close						= "Press {{bind:+attack2|RMB}} to spawn close to survivors"

LANGUAGE.observing_x								= "Observing %s (%d)"
LANGUAGE.observing_x_simple							= "Observing %s"
LANGUAGE.waiting_for_next_wave						= "Waiting for the next wave to begin..."
LANGUAGE.impossible									= "Impossible."
LANGUAGE.trying_to_put_nails_in_glass				= "Trying to put nails in glass is a silly thing to do."
LANGUAGE.boss_class_select							= "You will be %s the next time you're a boss zombie."
LANGUAGE.person_has_weapon							= "They already have that weapon."
LANGUAGE.cant_do_that_in_classic_mode				= "You can't do that in Classic Mode."
LANGUAGE.cant_use_x_in_classic_mode					= "You can't use %s in Classic Mode."
LANGUAGE.cant_use_x_in_zombie_escape				= "You can't use %s in Zombie Escape."
LANGUAGE.no_class_switch_in_this_mode				= "The current mode doesn't allow you to switch classes."
LANGUAGE.press_x_to_get_up							= "Press {{bind:+speed|SPRINT}} to get up"
LANGUAGE.nothing_for_this_ammo						= "You don't have anything that uses this type of ammo."
LANGUAGE.you_decide_to_leave_some					= "You decide to leave some for your team."
LANGUAGE.you_cant_purchase_now						= "You can't purchase items right now."
LANGUAGE.no_ammo_here								= "There's no ammo here right now."
LANGUAGE.you_redeemed								= "You have redeemed!"
LANGUAGE.x_redeemed									= "%s has redeemed!"
LANGUAGE.kill_the_last_human						= "Kill the last human!"
LANGUAGE.kick_the_last_human						= "Kick the last human!"
LANGUAGE.you_are_the_last_human						= "YOU ARE THE LAST HUMAN!"
LANGUAGE.x_zombies_out_to_get_you					= {one = "%d ZOMBIE IS OUT TO GET YOU!", other = "%d ZOMBIES ARE OUT TO GET YOU!"}
LANGUAGE.x_pants_out_to_get_you						= "%d PANTS ARE OUT TO GET YOU!"
LANGUAGE.you_have_died								= "You have died."
LANGUAGE.you_were_killed_by_x						= "You were killed by %s"
LANGUAGE.you_were_kicked_by_x						= "You were kicked in the shins by %s"
LANGUAGE.arsenal_upgraded							= "Arsenal Upgraded"
LANGUAGE.arsenal_upgraded_prefix					= "%1$s: "
LANGUAGE.arsenal_upgraded_suffix					= ""
LANGUAGE.final_wave									= "THE FINAL WAVE HAS BEGUN!"
LANGUAGE.final_wave_sub								= "ALL classes unlocked and the chance for redemption has ended!"
LANGUAGE.wave_x_has_begun							= "Wave %d has begun!"
LANGUAGE.wave_x_is_over								= "Wave %d is over!"
LANGUAGE.wave_x_is_over_sub							= "The Undead have stopped rising."
LANGUAGE.points_for_surviving						= {one = "You've gained %d point for surviving.", other = "You've gained %d points for surviving."}
LANGUAGE.scrap_for_surviving						= "You've gained %d scrap for surviving."
LANGUAGE.you_are_x									= "You are %s!"
LANGUAGE.x_has_risen_as_y							= "%1$s has risen as %2$s!!"
LANGUAGE.x_has_risen								= "A boss zombie has risen!"
LANGUAGE.x_has_been_slain_as_y						= "%1$s has been slain as %2$s!"
LANGUAGE.cant_use_worth_anymore						= "You can't use the Worth menu any more!"
LANGUAGE.class_not_unlocked_will_be_unlocked_x		= "That class is not unlocked yet. It will be unlocked at the start of wave %d."
LANGUAGE.you_are_already_a_x						= "You are already a %s."
LANGUAGE.you_will_spawn_as_a_x						= "You will spawn as a %s."
LANGUAGE.crafting_successful						= "Crafting successful!   (%s)"
LANGUAGE.x_crafted_y								= "%1$s crafted %2$s."
LANGUAGE.escape_from_the_zombies					= "Escape from the zombies!"
LANGUAGE.ze_weapon_pickup							= "%1$s has picked up a ZE Weapon. (%2$s)"
LANGUAGE.too_close_to_another_nail					= "Too close to another nail."
LANGUAGE.object_too_damaged_to_be_used				= "That object is too damaged to be used anymore."
LANGUAGE.thanks_for_being_a_fan_of_zs				= "Thanks for being a fan of Zombie Survival!"
LANGUAGE.cant_remove_nails_of_superior_player		= "You can't remove the nails of a player with the barricade expert skill because you don't also have the skill."
LANGUAGE.x_turned_on_noclip							= "%s turned on noclip."
LANGUAGE.x_turned_off_noclip						= "%s turned off noclip."
LANGUAGE.unlocked_on_wave_x							= "Unlocked on wave %d"
LANGUAGE.brains_eaten_x								= "Brains eaten: %s"
LANGUAGE.points_x									= "Points: %s"
LANGUAGE.next_wave_in_x								= "Next wave in %s"
LANGUAGE.wave_ends_in_x								= "Wave ends in %s"
LANGUAGE.wave_x_of_y								= "Wave %1$d of %2$d"
LANGUAGE.intermission_wave_x_of_y					= "Intermission - Wave %1$d of %2$d"
LANGUAGE.zombie_escape_round_x_of_y					= "Zombie Escape! - Round %1$d of %2$d"
LANGUAGE.zombie_invasion_in_x						= "Zombie invasion in %s"
LANGUAGE.intermission								= "Intermission"
LANGUAGE.press_x_for_the_points_shop				= "Press %s for the Points Shop!"
LANGUAGE.breath										= "Breath"
LANGUAGE.zombie_volunteers							= "Zombie Volunteers"
LANGUAGE.x_will_be_y_soon							= "%1$s will become %2$s soon!"
LANGUAGE.you_will_be_x_soon							= "You will become %s soon!"
LANGUAGE.x_discount_for_buying_between_waves		= "%d%% discount for buying between waves!"
LANGUAGE.number_of_initial_zombies_this_game		= "Number of initial zombies this game (%1$d%%): %2$d"
LANGUAGE.humans_closest_to_spawns_are_zombies		= "The humans closest to the zombie spawns will start as zombies."
LANGUAGE.waiting_for_players_x						= "Waiting for players... %s"
LANGUAGE.requires_x_people							= "Requires %d people"
LANGUAGE.packing_others_object						= "Packing other person's object"
LANGUAGE.packing									= "Packing"
LANGUAGE.ze_humans_are_frozen_until_x				= "Humans are frozen until %d seconds before the round starts."
LANGUAGE.loading									= "Loading..."
LANGUAGE.next_round_in_x							= "Next round in: %s"
LANGUAGE.warning									= "Warning!"
LANGUAGE.ready_3d									= "Ready"
LANGUAGE.ok_and_no_reminder							= "OK and don't pop this message up anymore"
LANGUAGE.classic_mode_warning						= "This server is running Zombie Survival in 'Classic Mode'\nClassic Mode is a setting which greatly alters gameplay. Things that are changed:\n* No selection of zombie classes. Everyone uses the Classic Zombie class\n* No barricading tools such as nailing or turrets\n* More but faster waves\n\nThis is NOT original Zombie Survival!\n\n-- Servers which run classic mode will display CLASSIC MODE in the bottom left of the screen --"
LANGUAGE.classic_mode								= "CLASSIC MODE"
LANGUAGE.resist_x									= "Resist: %d%%"
LANGUAGE.nails_x									= "Nails: %d"
LANGUAGE.resupply_box_3d							= "Resupply Box"
LANGUAGE.purchase_now								= "Purchase now!"
LANGUAGE.integrity_x								= "Integrity: %d%%"
LANGUAGE.empty										= "EMPTY"
LANGUAGE.manual_control								= "MANUAL CONTROL"
LANGUAGE.arsenal_crate								= "Arsenal Crate"
LANGUAGE.not_enough_room_for_a_nest					= "Not enough room here for a nest!"
LANGUAGE.too_close_to_another_nest					= "Too close to another nest!"
LANGUAGE.nest_created								= "Nest created! Finish building to enable spawning here."
LANGUAGE.nest_built_by_x							= "A Flesh Creeper nest has been built by %s and is now a spawn point."
LANGUAGE.nest_destroyed								= "A Flesh Creeper nest has been destroyed."
LANGUAGE.wait_x_seconds_before_making_a_new_nest	= {one = "You must wait %d more second before creating a new nest.", other = "You must wait %d more seconds before creating a new nest."}
LANGUAGE.too_close_to_a_human						= "Too close to a human!"
LANGUAGE.too_close_to_a_spawn						= "Too close to a zombie spawn!"
LANGUAGE.too_close_to_uncorrupt						= "Too close to an uncorrupted sigil!"
LANGUAGE.x_has_built_this_nest_and_is_still_around	= "%s has built this nest and is still around, so you can't demolish it."
LANGUAGE.no_other_nests								= "You can't destroy a nest if only one remains."
LANGUAGE.there_are_too_many_nests					= "There are too many nests so you can't build any more!"
LANGUAGE.you_have_made_too_many_nests				= "You've already created enough nests. Demolish one and try again."
LANGUAGE.no_free_channel							= "Radio interference from too many already being placed!"
LANGUAGE.tier_x_items_unlock_at_wave_y				= "Tier %1$d items unlock at wave %2$d"
LANGUAGE.tier_x_items								= "Tier %d items"
LANGUAGE.humans_furthest_from_sigils_are_zombies	= "The humans furthest from a Sanity Sigil will start as zombies."
LANGUAGE.out_of_stock								= "That item is out of stock!"
LANGUAGE.obtained_x_y_ammo							= "Obtained %d %s ammo"
LANGUAGE.gave_x_y_ammo_to_z							= "Gave %1$d %2$s ammo to %3$s"
LANGUAGE.obtained_x_y_ammo_from_z					= "Obtained %1$d %2$s ammo from %3$s"
LANGUAGE.healed_x_by_y								= "%s healed you for %d HP"
LANGUAGE.healed_x_for_y								= "Healed %s for %d HP"
LANGUAGE.buffed_x_with_y							= "%1$s buffed you with a %2$s"
LANGUAGE.buffed_x_with_a_y							= "Buffed %1$s with a %2$s"
LANGUAGE.removed_your_nail							= "%s removed one of your nails"
LANGUAGE.giving_items_to							= "Giving items to %s"
LANGUAGE.weapon_remantler_3d						= "Weapon Remantler"
LANGUAGE.remantle_success							= "Weapon Remantled"
LANGUAGE.remantle_success_prefix					= "%1$s: "
LANGUAGE.remantle_success_suffix					= ""
LANGUAGE.remantle_used								= "%d scrap has been created in your remantler."
LANGUAGE.remantle_cannot							= "You already have an upgraded weapon of this type."
LANGUAGE.teleporting_to_sigil						= "Teleporting to Sigil %s"
LANGUAGE.press_x_to_cancel							= "Press {{bind:+speed|SPRINT}} to cancel"
LANGUAGE.point_at_a_sigil_to_choose_destination		= "Point at another sigil to choose destination."
LANGUAGE.frail_healdart_warning						= "Healing blocked because %s has DEBUFF: FRAIL!"
LANGUAGE.obtained_a_inv								= "%s added to inventory"
LANGUAGE.you_already_have_this_trinket				= "You already have this trinket in your inventory."
LANGUAGE.they_already_have_this_trinket				= "They already have this trinket in their inventory."
LANGUAGE.you_cannot_carry_more_comps				= "You cannot carry more crafting components."
LANGUAGE.they_cannot_carry_more_comps				= "They cannot carry more crafting components."
LANGUAGE.obtained_inv_item_from_z					= "Obtained %1$s from %2$s added to inventory"
LANGUAGE.deployable_lost							= "Your %s was lost."
LANGUAGE.deployable_claimed							= "You've claimed a %s."
LANGUAGE.trinket_consumed							= "Your %s has been consumed and activated."
LANGUAGE.ran_out_of_ammo							= "Your %s has run out of ammo."
LANGUAGE.trinket_recharged							= "Your %s has recharged and is ready to use again."
LANGUAGE.evolves_in_to_x_on_wave_y					= "Evolves in to %s on wave %d."
LANGUAGE.scrap_amount_x_3d							= "%d Scrap"
LANGUAGE.uses_left_x_3d								= "%d Uses Left"
LANGUAGE.channel_x_of_y								= "CH. %1$d / %2$d"
LANGUAGE.deployable_ammo_count_x_y					= "[%1$d / %2$d]"
LANGUAGE.deployable_owner_format					= "(%s)"
LANGUAGE.deployable_ammotype_format					= "[%s]"
LANGUAGE.resupply_box_easter_3d						= "ur a faget"
LANGUAGE.nail_hp_format								= "%1$d/%2$d"
LANGUAGE.nail_owner_dead							= "(DEAD) %s"
LANGUAGE.number_suffix_kilo							= "K"
LANGUAGE.number_suffix_mega							= "M"
LANGUAGE.number_suffix_giga							= "B"
LANGUAGE.number_suffix_tera							= "T"
LANGUAGE.number_suffix_peta							= "Qa"
LANGUAGE.number_suffix_exa							= "Qi"
LANGUAGE.number_suffix_zetta						= "Sx"
LANGUAGE.number_suffix_yotta						= "Sp"
LANGUAGE.number_suffix_ronna						= "Oc"
LANGUAGE.number_suffix_quetta						= "No"
LANGUAGE.number_suffix_decillion					= "Dc"
LANGUAGE.number_suffix_undecillion					= "Ud"
LANGUAGE.number_suffix_duodecillion					= "Dd"
LANGUAGE.number_suffix_tredecillion					= "Td"
LANGUAGE.number_suffix_quattuordecillion			= "Qad"
LANGUAGE.number_suffix_quindecillion				= "Qid"
LANGUAGE.number_suffix_sexdecillion					= "Sxd"
LANGUAGE.number_suffix_septendecillion				= "Spd"
LANGUAGE.number_suffix_octodecillion				= "Ocd"
LANGUAGE.number_suffix_novemdecillion				= "Nod"
LANGUAGE.number_suffix_vigintillion					= "Vg"
LANGUAGE.number_decimal_separator					= "."
LANGUAGE.changed_player_model_x						= "You've changed your desired player model to %s"
LANGUAGE.x_remaining								= "%d remaining"
LANGUAGE.barricadekit_boards_format					= "Boards: %d"
LANGUAGE.mines_format								= "Mines: %1$d / %2$d"
LANGUAGE.gluon_heat									= "Heat"
LANGUAGE.gluon_venting								= "VENTING"
LANGUAGE.medic_no_target							= "No Target"
LANGUAGE.messagebeacon_select_message				= "Select a message"
LANGUAGE.wep_select_ammo_single						= "[%d]"
LANGUAGE.wep_select_ammo_clip						= "[%1$d / %2$d]"
LANGUAGE.wep_select_ammo_infinite					= "[%d / ∞]"

-- ============================================================
-- In-round notifications: objectives, sigils, skill level-ups, beacons
-- ============================================================

-- Sigils point objectives
LANGUAGE.sigil_corrupted							= "A Sanity Sigil has been corrupted. The Undead grow more resilient."
LANGUAGE.sigil_corrupted_last						= "The last Sanity Sigil has been corrupted! The Undead grow very resilient!"
LANGUAGE.sigil_uncorrupted							= "A Sanity Sigil has been uncorrupted, the Undead have weakened!"
LANGUAGE.sigil_corrupted_x_remain					= "%d remain uncorrupted."
LANGUAGE.prop_obj_exit_h							= "Escape!"
LANGUAGE.prop_obj_exit_z							= "Stop them!"
LANGUAGE.x_sigils_appeared							= {one = "%d Sanity Sigil has appeared. Humans may teleport to it.", other = "%d Sanity Sigils have appeared. Humans may teleport between them."}
LANGUAGE.has_survived								= "%s has survived!"

-- Skill system messages
LANGUAGE.unspent_skill_points_press_x				= "You have unspent skill points. Press \"%s\" to unlock new skills."
LANGUAGE.x_requires_a_skill_you_dont_have			= "%s requires a skill you don't have!"
LANGUAGE.you_ascended_to_level_x					= "You have ascended to level %d!"
LANGUAGE.you_have_remorted_now_rl_x					= "You have remorted and ascended to remort level %d!"
LANGUAGE.you_now_have_x_extra_sp					= {one = "You now have %d extra skill point!", other = "You now have %d extra skill points!"}
LANGUAGE.x_has_remorted_to_rl_y						= "%s has remorted to remort level %d!!"
LANGUAGE.you_have_reset_all							= "All of your skills, XP, and skill points have been reset."
LANGUAGE.skill_unlocked_x							= "You've unlocked a skill: %s"

-- Message beacon messages
LANGUAGE.message_beacon_1							= "Meet up here"
LANGUAGE.message_beacon_2							= "Need defense here"
LANGUAGE.message_beacon_3							= "Need turrets here"
LANGUAGE.message_beacon_4							= "Need arsenal crates here"
LANGUAGE.message_beacon_5							= "Need medics here"
LANGUAGE.message_beacon_6							= "Resupply box here"
LANGUAGE.message_beacon_7							= "Arsenal crate here"
LANGUAGE.message_beacon_8							= "Need force fields here"
LANGUAGE.message_beacon_9							= "Need explosives here"
LANGUAGE.message_beacon_10							= "Zombies come from here"
LANGUAGE.message_beacon_11							= "Do not enter!!"
LANGUAGE.message_beacon_12							= "Don't go out"
LANGUAGE.message_beacon_13							= "Defend this area"
LANGUAGE.message_beacon_14							= "Defend this spot"
LANGUAGE.message_beacon_15							= "Medics here"
LANGUAGE.message_beacon_16							= "Buy from my crate"
LANGUAGE.message_beacon_17							= "Barricade here"
LANGUAGE.message_beacon_18							= "Don't barricade here"
LANGUAGE.message_beacon_19							= "Don't let zombies in here"
LANGUAGE.message_beacon_20							= "This will break"
LANGUAGE.message_beacon_21							= "This place is dangerous!"
LANGUAGE.message_beacon_22							= "Beware of poison!"
LANGUAGE.message_beacon_23							= "Zombies are breaking through here!"
LANGUAGE.message_beacon_24							= "Zombies are coming. Build a barricade!"
LANGUAGE.message_beacon_25							= "Plan B here"

-- Place any custom stuff below here...