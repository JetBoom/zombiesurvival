--[[
English is the standard language that you should base your ID's off of.
If something isn't found in your language file then it will fall back to English.

Valid languages (from gmod's menu): bg cs da de el en en-PT es-ES et fi fr ga-IE he hr hu it ja ko lt nl no pl pt-BR pt-PT ru sk sv-SE th tr uk vi zh-CN zh-TW
You MUST use one of the above when using translate.AddLanguage
]]

--[[
RULES FOR TRANSLATORS!!
* Only translate formally. Do not translate with slang, improper grammar, spelling, etc.
* Do not translate proper things. For example, do not translate Zombie Survival (the name of the game). Do translate "survive the zombies".
  For names of weapons, you would translate only the "Handgun" part of 'Peashooter' Handgun (and the quotes if your language doesn't use ' as quotes)
  For names of classes, you would translate Bloated Zombie to whatever the word for Bloated and Zombie are. But you wouldn't translate Pukepus or Bonemesh.
* Comment out things that you have not yet translated in your language file.
  It will then fall back to this file instead of potentially using out of date wording in yours.
]]

translate.AddLanguage("en", "English")

-- Various gamemode stuff
LANGUAGE.minute_points_added						= "No damage received for a whole minute! Added %d points."
LANGUAGE.infliction_reached_class_unlocked			= "%d%% infliction has been reached! %s unlocked!"
LANGUAGE.infliction_reached							= "%d%% of humans have died!"
LANGUAGE.x_unlocked									= "%s unlocked!"
LANGUAGE.disconnect_killed							= "%s was disconnect killed by %s."
LANGUAGE.nail_removed_by							= "%s removed a nail belonging to %s."
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
LANGUAGE.purchased_x_for_y_points					= "Purchased %s for %d points!"
LANGUAGE.created_x_for_y_scrap						= "Created %s for %d scrap!"
LANGUAGE.give_time_before_suicide					= "Give others time to spawn before suiciding."
LANGUAGE.no_spare_ammo_to_give						= "No spare ammo to give!"
LANGUAGE.no_person_in_range							= "No person in range!"
LANGUAGE.that_life									= "That life..."
LANGUAGE.x_damage_to_barricades						= "%d damage to barricades"
LANGUAGE.x_damage_to_humans							= "%d damage to humans"
LANGUAGE.x_brains_eaten								= "%d brains eaten"

LANGUAGE.press_jump_to_free_roam					= "Press JUMP to free roam"
LANGUAGE.press_rmb_to_cycle_targets					= "Press RMB to cycle targets"
LANGUAGE.press_lmb_to_spawn_on_them					= "Press LMB to spawn on them"
LANGUAGE.press_lmb_to_spawn							= "Press LMB to spawn randomly"
LANGUAGE.press_reload_to_spawn_far					= "Press RELOAD to spawn far away from survivors"
LANGUAGE.press_alt_nest_menu						= "Press ALT to open the nest menu/spawn on minions"
LANGUAGE.press_reload_to_spawn_at_normal_point		= "Press RELOAD to spawn at a normal spawn point"
LANGUAGE.press_walk_to_spawn_as_x					= "Press %s to spawn as a %s"
LANGUAGE.press_rmb_to_spawn_close					= "Press RMB to spawn close to survivors"
LANGUAGE.press_left_and_right_to_cycle_targets		= "Press STRAFE LEFT and STRAFE RIGHT to cycle targets"

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
LANGUAGE.press_sprint_to_get_up						= "Press SPRINT to get up"
LANGUAGE.zombie_escape								= "Zombie Escape!"
LANGUAGE.nothing_for_this_ammo						= "You don't have anything that uses this type of ammo."
LANGUAGE.you_decide_to_leave_some					= "You decide to leave some for your team."
LANGUAGE.you_cant_purchase_now						= "You can't purchase items right now."
LANGUAGE.no_ammo_here								= "There's no ammo here right now."
LANGUAGE.you_redeemed								= "You have redeemed!"
LANGUAGE.x_redeemed									= "%s has redeemed!"
LANGUAGE.kill_the_last_human						= "Kill the last human!"
LANGUAGE.kick_the_last_human						= "Kick the last human!"
LANGUAGE.you_are_the_last_human						= "YOU ARE THE LAST HUMAN!"
LANGUAGE.x_zombies_out_to_get_you					= "%d ZOMBIES ARE OUT TO GET YOU!"
LANGUAGE.x_pants_out_to_get_you						= "%d PANTS ARE OUT TO GET YOU!"
LANGUAGE.you_have_died								= "You have died."
LANGUAGE.you_were_killed_by_x						= "You were killed by %s"
LANGUAGE.you_were_kicked_by_x						= "You were kicked in the shins by %s"
LANGUAGE.arsenal_upgraded							= "Arsenal Upgraded"
LANGUAGE.final_wave									= "THE FINAL WAVE HAS BEGUN!"
LANGUAGE.final_wave_sub								= "ALL classes unlocked and the chance for redemption has ended!"
LANGUAGE.wave_x_has_begun							= "Wave %d has begun!"
LANGUAGE.x_unlocked									= "%s unlocked!"
LANGUAGE.wave_x_is_over								= "Wave %d is over!"
LANGUAGE.wave_x_is_over_sub							= "The Undead have stopped rising."
LANGUAGE.points_for_surviving						= "You've gained %d points for surviving."
LANGUAGE.scrap_for_surviving						= "You've gained %d scrap for surviving."
LANGUAGE.you_are_x									= "You are %s!"
LANGUAGE.x_has_risen_as_y							= "%s has risen as %s!!"
LANGUAGE.x_has_risen								= "A boss zombie has risen!"
LANGUAGE.x_has_been_slain_as_y						= "%s has been slain as %s!"
LANGUAGE.cant_use_worth_anymore						= "You can't use the Worth menu any more!"
LANGUAGE.class_not_unlocked_will_be_unlocked_x		= "That class is not unlocked yet. It will be unlocked at the start of wave %d."
LANGUAGE.you_are_already_a_x						= "You are already a %s."
LANGUAGE.you_will_spawn_as_a_x						= "You will spawn as a %s."
LANGUAGE.crafting_successful						= "Crafting successful!"
LANGUAGE.x_crafted_y								= "%s crafted %s."
LANGUAGE.escape_from_the_zombies					= "Escape from the zombies!"
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
LANGUAGE.wave_x_of_y								= "Wave %d of %d"
LANGUAGE.round_x_of_y								= "Round %d of %d"
LANGUAGE.zombie_invasion_in_x						= "Zombie invasion in %s"
LANGUAGE.intermission								= "Intermission"
LANGUAGE.press_f2_for_the_points_shop				= "Press F2 for the Points Shop!"
LANGUAGE.breath										= "Breath"
LANGUAGE.zombie_volunteers							= "Zombie Volunteers"
LANGUAGE.x_will_be_y_soon							= "%s will become %s soon!"
LANGUAGE.you_will_be_x_soon							= "You will become %s soon!"
LANGUAGE.x_discount_for_buying_between_waves		= "%d%% discount for buying between waves!"
LANGUAGE.number_of_initial_zombies_this_game		= "Number of initial zombies this game (%d%%): %d"
LANGUAGE.humans_closest_to_spawns_are_zombies		= "The humans closest to the zombie spawns will start as zombies."
LANGUAGE.waiting_for_players						= "Waiting for players..."
LANGUAGE.requires_x_people							= "Requires %d people"
LANGUAGE.packing_others_object						= "Packing other person's object"
LANGUAGE.packing									= "Packing"
LANGUAGE.ze_humans_are_frozen_until_x				= "Humans are frozen until %d seconds before the round starts."
LANGUAGE.loading									= "Loading..."
LANGUAGE.next_round_in_x							= "Next round in: %s"
LANGUAGE.warning									= "Warning!"
LANGUAGE.ready										= "Ready"
LANGUAGE.ok_and_no_reminder							= "OK and don't pop this message up anymore"
LANGUAGE.classic_mode_warning						= "This server is running Zombie Survival in 'Classic Mode'\nClassic Mode is a setting which greatly alters gameplay. Things that are changed:\n* No selection of zombie classes. Everyone uses the Classic Zombie class\n* No barricading tools such as nailing or turrets\n* More but faster waves\n\nThis is NOT original Zombie Survival!\n\n-- Servers which run classic mode will display CLASSIC MODE in the bottom left of the screen --"
LANGUAGE.classic_mode								= "CLASSIC MODE"
LANGUAGE.resist_x									= "Resist: %d%%"
LANGUAGE.right_click_to_hammer_nail					= "Right click to hammer in a nail."
LANGUAGE.nails_x									= "Nails: %d"
LANGUAGE.resupply_box								= "Resupply Box"
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
LANGUAGE.wait_x_seconds_before_making_a_new_nest	= "You must wait %d more seconds before creating a new nest."
LANGUAGE.too_close_to_a_human						= "Too close to a human!"
LANGUAGE.too_close_to_a_spawn						= "Too close to a zombie spawn!"
LANGUAGE.too_close_to_uncorrupt						= "Too close to an uncorrupted sigil!"
LANGUAGE.x_has_built_this_nest_and_is_still_around	= "%s has built this nest and is still around, so you can't demolish it."
LANGUAGE.no_other_nests								= "You can't destroy a nest if only one remains."
LANGUAGE.there_are_too_many_nests					= "There are too many nests so you can't build any more!"
LANGUAGE.you_have_made_too_many_nests				= "You've already created enough nests. Demolish one and try again."
LANGUAGE.no_free_channel							= "Radio interference from too many already being placed!"
LANGUAGE.tier_x_items_unlock_at_wave_y				= "Tier %d items unlock at wave %d"
LANGUAGE.tier_x_items								= "Tier %d items"
LANGUAGE.humans_furthest_from_sigils_are_zombies	= "The humans furthest from a Sanity Sigil will start as zombies."
LANGUAGE.out_of_stock								= "That item is out of stock!"
LANGUAGE.obtained_x_y_ammo							= "Obtained %d %s ammo"
LANGUAGE.gave_x_y_ammo_to_z							= "Gave %d %s ammo to %s"
LANGUAGE.obtained_x_y_ammo_from_z					= "Obtained %d %s ammo from %s"
LANGUAGE.healed_x_by_y								= "%s healed you for %d HP"
LANGUAGE.healed_x_for_y								= "Healed %s for %d HP"
LANGUAGE.buffed_x_with_y							= "%s buffed you with a %s"
LANGUAGE.buffed_x_with_a_y							= "Buffed %s with a %s"
LANGUAGE.removed_your_nail							= "%s removed one of your nails"
LANGUAGE.giving_items_to							= "Giving items to %s"
LANGUAGE.weapon_remantler							= "Weapon Remantler"
LANGUAGE.remantle_success							= "Weapon Remantled:"
LANGUAGE.remantle_used								= "%d scrap has been created in your remantler."
LANGUAGE.remantle_cannot							= "You already have an upgraded weapon of this type."
LANGUAGE.teleporting_to_sigil						= "Teleporting to Sigil %s"
LANGUAGE.press_shift_to_cancel						= "Press SHIFT to cancel"
LANGUAGE.point_at_a_sigil_to_choose_destination		= "Point at another sigil to choose destination."
LANGUAGE.frail_healdart_warning						= "Healing blocked because %s has DEBUFF: FRAIL!"
LANGUAGE.obtained_a_inv								= "%s added to inventory"
LANGUAGE.you_already_have_this_trinket				= "You already have this trinket in your inventory."
LANGUAGE.they_already_have_this_trinket				= "They already have this trinket in their inventory."
LANGUAGE.you_cannot_carry_more_comps				= "You cannot carry more crafting components."
LANGUAGE.they_cannot_carry_more_comps				= "They cannot carry more crafting components."
LANGUAGE.obtained_inv_item_from_z					= "Obtained %s from %s added to inventory"
LANGUAGE.deployable_lost							= "Your %s was lost."
LANGUAGE.deployable_claimed							= "You've claimed a %s."
LANGUAGE.trinket_consumed							= "Your %s has been consumed and activated."
LANGUAGE.ran_out_of_ammo						 	= "Your %s has run out of ammo."
LANGUAGE.trinket_recharged							= "Your %s has recharged and is ready to use again."
LANGUAGE.evolves_in_to_x_on_wave_y					= "Evolves in to %s on wave %d."

-- Sigils point objectives
LANGUAGE.sigil										= "Sanity Sigil"
--LANGUAGE.sigil_destroyed							= "A Sanity Sigil has been destroyed. The Undead grow stronger!"
LANGUAGE.sigil_corrupted							= "A Sanity Sigil has been corrupted. The Undead grow more resilient."
LANGUAGE.sigil_corrupted_last						= "The last Sanity Sigil has been corrupted! The Undead grow very resilient!"
LANGUAGE.sigil_uncorrupted							= "A Sanity Sigil has been uncorrupted, the Undead have weakened!"
--[[LANGUAGE.sigil_destroyed_only_one_remain_h		= "Only one Sanity Sigil remains!"
LANGUAGE.sigil_destroyed_only_one_remain_z			= "Only one Sanity Sigil remains!"
LANGUAGE.sigil_destroyed_x_remain					= "%d remaining."]]
LANGUAGE.sigil_corrupted_x_remain					= "%d remain uncorrupted."
--[[LANGUAGE.last_sigil_destroyed_all_is_lost		= "The Undead have destroyed the last Sanity Sigil..."
LANGUAGE.last_sigil_destroyed_all_is_lost2			= "Time to die!"]]
LANGUAGE.prop_obj_exit_h							= "Escape!"
LANGUAGE.prop_obj_exit_z							= "Stop them!"
LANGUAGE.x_sigils_appeared							= "%d Sanity Sigils have appeared. Humans may teleport between them."
LANGUAGE.has_survived								= "has survived!"

-- Skill system messages
LANGUAGE.unspent_skill_points_press_x				= "You have unspent skill points. Press %q to unlock new skills."
LANGUAGE.x_requires_a_skill_you_dont_have			= "%s requires a skill you don't have!"
LANGUAGE.you_ascended_to_level_x					= "You have ascended to level %d!"
LANGUAGE.you_have_remorted_now_rl_x					= "You have remorted and ascended to remort level %d!"
LANGUAGE.you_now_have_x_extra_sp					= "You now have %d extra skill points!"
LANGUAGE.x_has_remorted_to_rl_y						= "%s has remorted to remort level %d!!"
LANGUAGE.you_have_reset_all							= "All of your skills, XP, and skill points have been reset."

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

-- Class names
LANGUAGE.class_zombie								= "Zombie"
LANGUAGE.class_zombie_gore_blaster					= "Gore Blaster Zombie"
LANGUAGE.class_poison_zombie						= "Poison Zombie"
LANGUAGE.class_wild_poison_zombie					= "Wild Poison Zombie"
LANGUAGE.class_fast_zombie							= "Fast Zombie"
LANGUAGE.class_fast_zombie_slingshot				= "Slingshot Zombie"
LANGUAGE.class_bloated_zombie						= "Bloated Zombie"
LANGUAGE.class_vile_bloated_zombie					= "Vile Bloated Zombie"
LANGUAGE.class_classic_zombie						= "Classic Zombie"
LANGUAGE.class_super_zombie							= "Super Zombie"
LANGUAGE.class_fresh_dead							= "Fresh Dead"
LANGUAGE.class_recent_dead							= "Recent Dead"
LANGUAGE.class_agile_dead							= "Agile Dead"
LANGUAGE.class_ghoul								= "Ghoul"
LANGUAGE.class_chilled_ghoul						= "Frigid Ghoul"
LANGUAGE.class_elderghoul							= "Elder Ghoul"
LANGUAGE.class_noxiousghoul							= "Noxious Ghoul"
LANGUAGE.class_headcrab								= "Headcrab"
LANGUAGE.class_fast_headcrab						= "Fast Headcrab"
LANGUAGE.class_bloodsucker_headcrab					= "Bloodsucker Headcrab"
LANGUAGE.class_poison_headcrab						= "Poison Headcrab"
LANGUAGE.class_barbed_headcrab						= "Barbed Headcrab"
LANGUAGE.class_the_tickle_monster					= "The Tickle Monster"
LANGUAGE.class_nightmare							= "Nightmare"
LANGUAGE.class_ancient_nightmare					= "Ancient Nightmare"
LANGUAGE.class_devourer								= "Devourer"
LANGUAGE.class_pukepus								= "Pukepus"
LANGUAGE.class_bonemesh								= "Bonemesh"
LANGUAGE.class_crow									= "Crow"
LANGUAGE.class_wilowisp								= "Wil O' Wisp"
LANGUAGE.class_coolwisp								= "Cool Wisp"
LANGUAGE.class_zombie_torso							= "Zombie Torso"
LANGUAGE.class_zombie_legs							= "Zombie Legs"
LANGUAGE.class_wraith								= "Wraith"
LANGUAGE.class_tormented_wraith						= "Tormented Wraith"
LANGUAGE.class_fast_zombie_legs						= "Fast Zombie Legs"
LANGUAGE.class_fast_zombie_torso					= "Fast Zombie Torso"
LANGUAGE.class_fast_zombie_torso_slingshot			= "Slingshot Zombie Torso"
LANGUAGE.class_chem_burster							= "Chem Burster"
LANGUAGE.class_shade								= "Shade"
LANGUAGE.class_frostshade							= "Frost Shade"
LANGUAGE.class_butcher								= "The Butcher"
LANGUAGE.class_gravedigger							= "The Grave Digger"
LANGUAGE.class_flesh_creeper						= "Flesh Creeper"
LANGUAGE.class_gore_child							= "Gore Child"
LANGUAGE.class_giga_gore_child						= "Giga Gore Child"
LANGUAGE.class_shadow_gore_child					= "Shadow Child"
LANGUAGE.class_giga_shadow_child					= "Giga Shadow Child"
LANGUAGE.class_asskicker							= "Ass Kicker"
LANGUAGE.class_shitslapper							= "Shit Slapper"
LANGUAGE.class_doomcrab								= "Doom Crab"
LANGUAGE.class_red_marrow							= "Red Marrow"
LANGUAGE.class_skeletal_walker						= "Skeletal Walker"
LANGUAGE.class_skeletal_shambler					= "Skeletal Shambler"
LANGUAGE.class_skeletal_lurker						= "Skeletal Crawler"
LANGUAGE.class_shadow_lurker						= "Shadow Lurker"
LANGUAGE.class_shadow_walker						= "Shadow Walker"
LANGUAGE.class_frigid_revenant						= "Frigid Revenant"
LANGUAGE.class_initial_dead							= "Initial Dead"
LANGUAGE.class_lacerator							= "Lacerator"
LANGUAGE.class_lacerator_charging					= "Charger"
LANGUAGE.class_eradicator							= "Eradicator"
LANGUAGE.class_howler								= "Howler"
LANGUAGE.class_extinctioncrab						= "Extinction Crab"

-- Class descriptions
LANGUAGE.description_zombie							= "The basic zombie is very durable and has powerful claws.\nIt's hard to keep down, especially if not shot in the head."
LANGUAGE.description_zombie_gore_blaster			= "Gore Blaster Zombies send viscera in all direction when killed which can cause minor harm.\nTheir claws can also inflict bleeding."
LANGUAGE.description_poison_zombie					= "This mutated zombie is not only extremely durable but has abnormal strength.\nIts body is extremely toxic and will even tear out and toss its own flesh at things too far away to hit."
LANGUAGE.description_wild_poison_zombie				= "An erratic mutation of the poison zombie, making it stronger and tankier.\nIts flesh toss is much more sporadic and deadly."
LANGUAGE.description_fast_zombie					= "This boney cadaver is much faster than other zombies.\nThey aren't much of a threat by themselves but can reach nearly any area by climbing with their razor sharp claws\nThey also have no problem hunting down weak or hurt humans."
LANGUAGE.description_fast_zombie_slingshot			= "An abnormal Fast Zombie with a powerful lunge.\nThe force applied is so great that it destroys their lower body, sending what's left at incredible speed.\nThe impact it causes will leave humans crippled for a while."
LANGUAGE.description_bloated_zombie					= "Their body is comprised of volatile, toxic chemicals.\nAlthough they move slower, they can take slightly more of a beating."
LANGUAGE.description_vile_bloated_zombie			= "Their body is comprised of volatile, toxic chemicals which they can vomit a fair distance away.\nThey're a little faster than regular bloated zombies at the cost of being not as hardy."
LANGUAGE.description_fresh_dead						= "These are zombies who have come back from the dead recently.\nThey have less durability and power than those who have rotted but make up for it in speed."
LANGUAGE.description_agile_dead						= "These are zombies who have come back from the dead recently.\nThis mutation allows the fresh dead to climb at the cost of being extremely flimsy."
LANGUAGE.description_ghoul							= "This zombie has highly toxic flesh.\nIt's slightly weaker than other zombies but makes up for it with its debilitating attacks.\nIts claws can debuff a human for a short time, causing increased damage from other attacks and it can throw goop which slows them."
LANGUAGE.description_chilled_ghoul					= "This zombie has extremely cold flesh.\nIt's slightly weaker than other zombies but makes up for it with its debilitating attacks."
LANGUAGE.description_frigid_revenant				= "A dark skeleton with a cold heart.\nDerived from the Frigid Ghoul, and has the Shadow Walker's resistance to melee attacks.\nCan chill and blind with its attacks."
LANGUAGE.description_elderghoul						= "An aged Ghoul with a highly poisonous body which they throw pieces of at distant victims.\nTheir frail body will discharge poison towards attackers when harmed."
LANGUAGE.description_noxiousghoul					= "A deeply aged ghoul with highly virulent goop merged with their body.\nTheir projectiles will slow and enfeeble unlucky victims, and their body will discharge poison towards attackers when harmed."
LANGUAGE.description_headcrab						= "Headcrabs are what caused the initial infection.\nNo one knows where they truely came from.\nTheir method of attack is lunging with the sharp beaks on their belly."
LANGUAGE.description_fast_headcrab					= "The male headcrab is considerably faster but less beefy than the female.\nEither way, it's equally as annoying and deadly in groups."
LANGUAGE.description_bloodsucker_headcrab			= "Bloodsuckers are stockier fast headcrabs with bleed inflicting bites.\nEach successful bite will heal a small amount of health."
LANGUAGE.description_poison_headcrab				= "This Headcrab is full of deadly neurotoxins.\nOne bite is usually enough to kill an adult human.\nIt also has the ability to spit a less potent version of its poisons.\nThe spit is just as deadly if its victim is hit in the face."
LANGUAGE.description_barbed_headcrab				= "This Headcrab bristles with sharp quills.\nIt can project a bristle at high speed inflicting bleeding upon unlucky humans."
LANGUAGE.description_the_tickle_monster				= "Said to be the monster that hides in your closet at night to drag you from your bed.\nThe Tickle Monster's almost elastic arms make it extremely hard to outrun and they also make it an ideal barricade destroyer."
LANGUAGE.description_nightmare						= "An extremely rare mutation gives the Nightmare its abnormal abilities.\nStronger than the every day zombie in almost every way, the Nightmare is a force to be reckoned with.\nOne swipe of its claws is enough to put down almost any person."
LANGUAGE.description_ancient_nightmare				= "An elderly Nightmare that has been roaming the land for ages.\nIts body has been tempered by the years, making it sturdier and less mobile but still formidable up close."
LANGUAGE.description_devourer						= "A horrific malformation of bone and flesh, with a throwable rib that pierces into victims to reel them in.\nNot very fast on its own but incredibly dangerous to deal with alone."
LANGUAGE.description_pukepus						= "The rotting body of the Puke Pus is comprised entirely of organs used for the generation of poison.\nIt's capable of vomiting gallons of poison puke at a time making it extremely dangerous."
LANGUAGE.description_bonemesh						= "Disfigured and mangled, the Bonemesh is capable of tossing blood bombs.\nEach bomb is comprised of bones and flesh that damages humans while giving precious food to other zombies."
LANGUAGE.description_crow							= "Carrion Crows are more of a pest than they were before the infection.\nThey feed on infected flesh and become 'carriers' for the undead.\nWhy would you ever make this class not hidden?\nWhat is wrong with you?"
LANGUAGE.description_wilowisp						= "Sometimes referred to as spirits of the dead.\nDoes minimal damage but is capable of blinding humans and explodes when killed.\nInduces almost no fear."
LANGUAGE.description_coolwisp						= "An arctic Wisp with the ability to impede humans with frost.\nFrost reduces the fire rate and reload speed of firearms."
LANGUAGE.description_zombie_torso					= "You shouldn't even be seeing this."
LANGUAGE.description_zombie_legs					= "You shouldn't even be seeing this."
LANGUAGE.description_wraith							= "A zombie or an apparition?\nNot much is known about it besides the fact that it uses its\nunique stealth ability and sharp claws to cut things to ribbons."
LANGUAGE.description_tormented_wraith				= "A more twisted kin of the Wraith.\nThis variant is capable of becoming crazed after taking damage, speeding up their attacks and movement.\nThey attack much faster at the cost of less damage per hit overall.\n"
LANGUAGE.description_fast_zombie_torso				= "You shouldn't even be seeing this."
LANGUAGE.description_fast_zombie_torso_slingshot	= "You shouldn't even be seeing this."
LANGUAGE.description_fast_zombie_legs				= "You shouldn't even be seeing this."
LANGUAGE.description_chem_burster					= "The Chem Burster body is comprised of volatile, toxic chemicals.\nIt has no other means of attack besides being killed in hopes of blowing up next to any nearby humans."
LANGUAGE.description_shade							= "By creating a strong magnetic field around itself with a channeled shield, all bullets and projectiles are rendered useless against it until the shield is destroyed.\nThey can hurl any unnailed object at high velocity towards humans for devastating effect."
LANGUAGE.description_frostshade						= "Frost Shades create weaker shields and projectiles than their normal counterpart, but can afflict humans with frost once shattered.\nThe cold will slow down their actions and jam their weapons, making them fire slower."
LANGUAGE.description_butcher						= "A crazed, undead butcher. It isn't very tough but anyone unlucky enough to be near it will most likely be torn to shreds."
LANGUAGE.description_gravedigger					= "A deranged, undead grave keeper. It wields a shovel made from bones found in a cemetery."
LANGUAGE.description_flesh_creeper					= "Flesh Creepers possess the ability to create nests.\nFrom these nests, other zombified creatures emerge.\nThe way this works is unknown but it is imperative to destroy any nests or creepers."
LANGUAGE.description_gore_child						= "Once zombified, an unborn child becomes infected as well.\nPossessing no special abilities, their strength comes from their numbers."
LANGUAGE.description_giga_gore_child				= "The result of a Gore Child which has been left unchecked for too long.\nA horror to behold, their massive body is the result of zombified stem cells.\nThey also become a host for Gore Children which can always be found in tow with it."
LANGUAGE.description_giga_shadow_child				= "A corrupted Gore Child with the ability to obscure a human's vision.\nLess sturdy than the Giga Gore Child but with a high resistance to melee weapons.\nThe spawns it creates are equally resistant and capable of vision obscuration."
LANGUAGE.description_shadow_gore_child				= "A Gore Child that has been corrupted by the darkness."
LANGUAGE.description_asskicker						= "It's time to kick humans and chew ass, and I'm all out of ass."
LANGUAGE.description_shitslapper					= "How about I slap your shit?"
LANGUAGE.description_doomcrab						= "A massive headcrab that leaps on its victims to crush them.\nAlso has the ability to throw doom balls which debilitate humans."
LANGUAGE.description_red_marrow						= "Mutated polycythemia gives the Red Marrow its color and ability to prfusely expel blood.\nAfter taking some damage a blood shield is created, rendering the Red Marrow impervious to attacks."
LANGUAGE.description_skeletal_walker				= "Animated skeletons don't have a lot of health but they take minimal damage from bullets."
LANGUAGE.description_skeletal_shambler				= "A behemoth of a skeleton that is moderately durable but also take minimal damage from bullets.\nThey also have the capacity to make a second wind."
LANGUAGE.description_skeletal_lurker				= "A Skeletal Walker that lost the use of its legs.\nAnimated skeletons don't have a lot of health but they take minimal damage from bullets."
LANGUAGE.description_shadow_lurker					= "Extremely hard to see in the dark and resistant against melee attacks. Their hits inflict a vision dimming debuff."
LANGUAGE.description_shadow_walker					= "An evolved form of the Shadow Lurker with less mobility.\nExtremely hard to see in the dark and resistant against melee attacks. Their hits inflict a vision dimming debuff."
LANGUAGE.description_lacerator						= "Lacerators are identical to Fast Zombies in almost every way.\nDespite their similarities, they are even deadlier and do not share their counterpart's fragility"
LANGUAGE.description_lacerator_charging				= "These brutes can run deceptively fast while charging despite their burly demeanor.\nThe force behind their charge can knock anyone off their feet."
LANGUAGE.description_eradicator						= "Bringers of death and destruction. The Eradicators sport a durable body that require a lot of fire power to take down.\nUnless shot in the head, they are almost garanteed to rise again."
LANGUAGE.description_howler							= "A terrifying flesh titan with a piercing shriek.\nIts howl inspires the undead and instills fear in the living."
LANGUAGE.description_extinctioncrab					= "Vile diseases churn within this giant headcrab.\nThe spores it spits will afflict those near it, reducing the effectiveness of healing."

-- Class control schemes
LANGUAGE.controls_zombie							= "> PRIMARY: Claws\n> SECONDARY: Scream\n> RELOAD: Moan\n> SPRINT: Feign death\n> ON FATAL HIT IN LEGS: Revive / Transform"
LANGUAGE.controls_zombie_gore_blaster				= "> PRIMARY: Claws\n> ON HIT HUMAN: Bleed\n> SECONDARY: Scream\n> SPRINT: Feign death\n> ON DEATH: Gore Blast"
LANGUAGE.controls_poison_zombie						= "> PRIMARY: Claws\n> SECONDARY: Flesh toss\n> RELOAD: Scream"
LANGUAGE.controls_wild_poison_zombie				= "> PRIMARY: Claws\n> SECONDARY: Flesh toss\n> RELOAD: Scream"
LANGUAGE.controls_fast_zombie						= "> PRIMARY: Claws\n> SECONDARY: Lunge / Climb wall\n> RELOAD: Scream\n> ON FATAL HIT IN LEGS: Transform"
LANGUAGE.controls_fast_zombie_slingshot				= "> PRIMARY: Claws\n> SECONDARY: Slingshot / Climb wall\n> RELOAD: Scream\n> ON SLINGSHOT HUMAN: Slow"
LANGUAGE.controls_bloated_zombie					= "> PRIMARY: Claws\n> SECONDARY: Moan\n> SPRINT: Feign death\n> ON DEATH: Poison Gibs"
LANGUAGE.controls_vile_bloated_zombie				= "> PRIMARY: Claws\n> SECONDARY: Poison Vomit\n> SPRINT: Feign death"
LANGUAGE.controls_fresh_dead						= "> PRIMARY: Claws\n> SECONDARY: Scream\n> SPRINT: Feign death"
LANGUAGE.controls_agile_dead						= "> PRIMARY: Claws\n> SECONDARY: Climb wall"
LANGUAGE.controls_ghoul								= "> PRIMARY: Poison claws\n> SECONDARY: Throw slowing goop\n> SPRINT: Feign death\n> RELOAD: Scream\n> ON HIT HUMAN: Ghoul Touch"
LANGUAGE.controls_chilled_ghoul						= "> PRIMARY: Frost claws\n> SECONDARY: Throw frozen goop\n> SPRINT: Feign death\n> RELOAD: Scream\n> ON HIT HUMAN: Frost"
LANGUAGE.controls_frigid_revenant					= "> PRIMARY: Frost and blind claws\n> SECONDARY: Throw dark ice goop\n> ON HIT HUMAN: Frost and dim vision"
LANGUAGE.controls_elderghoul						= "> PRIMARY: Poison claws\n> SECONDARY: Flesh toss\n> RELOAD: Scream\n> ON DAMAGE TAKEN: Poison spray"
LANGUAGE.controls_noxiousghoul						= "> PRIMARY: Poison claws\n> SECONDARY: Throw disabling goop\n> RELOAD: Scream\n> ON DAMAGE TAKEN: Poison spray\n> ON HIT HUMAN: Ghoul Touch"
LANGUAGE.controls_headcrab							= "> PRIMARY: Lunge attack\n> RELOAD: Burrow"
LANGUAGE.controls_fast_headcrab						= "> PRIMARY: Lunge attack"
LANGUAGE.controls_bloodsucker_headcrab				= "> PRIMARY: Lunge attack\n> ON HIT HUMAN: Bleed and heal for a small amount of health"
LANGUAGE.controls_poison_headcrab					= "> PRIMARY: Lunge attack\n> SECONDARY: Spit poison\n> ON HIT HUMAN: Deadly poison\n> ON HIT POISON IN EYES: Blind\n> RELOAD: Scream"
LANGUAGE.controls_barbed_headcrab					= "> PRIMARY: Lunge attack\n> SECONDARY: Spit bristle\n> ON HIT HUMAN: Strong bleed\n> RELOAD: Scream"
LANGUAGE.controls_the_tickle_monster				= "> PRIMARY: Elastic claws\n> SECONDARY: Moan"
LANGUAGE.controls_nightmare							= "> PRIMARY: Death touch\n> SECONDARY: Moan"
LANGUAGE.controls_ancient_nightmare					= "> PRIMARY: Death claw\n> SECONDARY: Moan"
LANGUAGE.controls_devourer							= "> PRIMARY: Claw\n> SECONDARY: Reel target in with projectile"
LANGUAGE.controls_pukepus							= "> PRIMARY: Puke\n> ON DAMAGE TAKEN: Poison spray\n> ON DEATH: Poison explosion"
LANGUAGE.controls_bonemesh							= "> PRIMARY: Claws\n> SECONDARY: Toss blood bomb"
LANGUAGE.controls_wraith							= "> PRIMARY: Claws\n> SECONDARY: Scream\n> INVISIBILITY BASED ON MOVEMENT AND VIEW DISTANCE"
LANGUAGE.controls_tormented_wraith					= "> PRIMARY: Claws\n> SECONDARY: Scream\n> INVISIBILITY BASED ON MOVEMENT AND VIEW DISTANCE\n> MADDENED WHEN TAKING DAMAGE BELOW 70 HP"
LANGUAGE.controls_chem_burster						= "> PRIMARY: Death Charge\n> ON DEATH: Poison Bomb (power based on charge time)"
LANGUAGE.controls_shade								= "> PRIMARY: Throw\n> SECONDARY: Lift\n> RELOAD: Pull rock from ground\n> SPRINT: Channel shield"
LANGUAGE.controls_frostshade						= "> PRIMARY: Throw\n> SECONDARY: Lift\n> RELOAD: Create ice missile\n> SPRINT: Channel frost shield"
LANGUAGE.controls_butcher							= "> PRIMARY: Chop"
LANGUAGE.controls_gravedigger						= "> PRIMARY: Smack"
LANGUAGE.controls_flesh_creeper						= "> PRIMARY: Head Smash\n> SECONDARY: Nest\n> RELOAD: Leap"
LANGUAGE.controls_gore_child						= "> PRIMARY: Claws"
LANGUAGE.controls_giga_gore_child					= "> PRIMARY: Smash\n> SECONDARY: Throw Gore Child\n> RELOAD: Knockdown Cry"
LANGUAGE.controls_giga_shadow_child					= "> PRIMARY: Smash\n> SECONDARY: Throw Shadow Child\n> RELOAD: Obscuring Knockdown Cry\n> ON HIT: Dim Vision\n> ON HIT BY MELEE: Resist damage"
LANGUAGE.controls_shadow_gore_child					= "> PRIMARY: Claws\n> ON HIT: Dim Vision\n> ON HIT BY MELEE: Resist damage"
LANGUAGE.controls_asskicker							= "> PRIMARY: Left kick\n> SECONDARY: Right kick"
LANGUAGE.controls_shitslapper						= "> PRIMARY: Slap"
LANGUAGE.controls_doomcrab							= "> PRIMARY: Leap attack\n> SECONDARY: Doom ball"
LANGUAGE.controls_red_marrow						= "> PRIMARY: Claws\n> SECONDARY: Scream\n> ON EVERY 200 DAMAGE TAKEN: Create blood shield"
LANGUAGE.controls_skeletal_walker					= "> PRIMARY: Claws\n> SECONDARY: Scream\n> RELOAD: Moan\n> SPRINT: Feign death\n> ON HIT BY BULLET: Resist damage"
LANGUAGE.controls_skeletal_shambler					= "> PRIMARY: Claws\n> SECONDARY: Scream\n> RELOAD: Moan\n> SPRINT: Feign death\n> ON HIT BY BULLET: Resist damage\n> ON FATAL HIT IN LEGS: Revive"
LANGUAGE.controls_skeletal_lurker					= "> PRIMARY: Claws\n> SECONDARY: Moan\n> ON HIT BY BULLET: Resist damage"
LANGUAGE.controls_wilowisp							= "> PRIMARY: Blinding Light\n> RELOAD: Moan\n> ON DEATH: Blinding Explosion"
LANGUAGE.controls_coolwisp							= "> PRIMARY: Freezing Pulse\n> RELOAD: Moan\n> ON DEATH: Arctic Explosion"
LANGUAGE.controls_shadow_lurker						= "> PRIMARY: Claws\n> ON HIT: Dim Vision\n> ON HIT BY MELEE: Resist damage"
LANGUAGE.controls_lacerator							= "> PRIMARY: Claws\n> SECONDARY: Lunge / Climb wall\n> RELOAD: Scream"
LANGUAGE.controls_lacerator_charging				= "> PRIMARY: Bleeding Claws\n> ON HIT HUMAN: Bleed\n> SECONDARY: Charge\n> RELOAD: Scream"
LANGUAGE.controls_eradicator						= "> PRIMARY: Claws\n> SECONDARY: Scream\n> ON FATAL HIT: Revive"
LANGUAGE.controls_howler							= "> PRIMARY: Claws\n> SECONDARY: Howl\n> RELOAD: Moan"
LANGUAGE.controls_extinctioncrab					= "> PRIMARY: Leap Attack\n> SECONDARY: Extinction Spore"

-- The help file... Quite big! I wouldn't blame you if you didn't translate this part.
LANGUAGE.help_cat_introduction						= "Introduction"
LANGUAGE.help_cat_survival							= "Survival"
LANGUAGE.help_cat_barricading						= "Barricading"
LANGUAGE.help_cat_upgrades							= "Upgrades"
LANGUAGE.help_cat_being_a_zombie					= "Being a Zombie"
LANGUAGE.help_cont_introduction						= [[<p>    Welcome to Zombie Survival, the (zombie) survival simulator. ZS allows you to fight zombie attacks, create barricades, and even be part of the undead horde.</p>

<p>There are two teams: the survivors and the zombies. The humans win if they survive every wave. Some levels have special objectives to be completed, which may be optional or required to win.
If a human is killed then they'll come back as a zombie, which makes it even more difficult for the remaining humans.</p>

<p>The goal for the zombies is to kill all of the humans, making them all zombies and causing everyone to lose the round.
Alternatively, a zombie can kill four humans to be redeemed. This allows them a second chance at survival and victory.
Remember, the only way to win a round is to be a human when the round ends. Zombies can't technically win the game; zombies can only make everyone else lose!</p>

<p>A certain amount of people are chosen (or volunteer) for being the starting zombies. This amount is displayed at the bottom of your screen before the round starts.</p>

<p><b>Use the buttons up top to get help on more specific things.</b></p>

<p>Tips for this section:
<ul><li>If you leave the game as a human then you'll rejoin as a zombie.</li>
<li>After a certain amount of time has gone by, even new players will spawn as zombies.</li>
<li>Use TEAM CHAT when needed. The default key is U and allows you to speak to only your team.</li>
</ul></p>
]]
LANGUAGE.help_cont_survival							= [[<p>Tips for this section:
<ul><li>Holding the ZOOM key (default: Z) allows you to move freely through barricades while walking extremely slow.</li>
<li>You can only buy more items such as weapons and ammo during wave breaks but you can also loot ammunition, weapons, and tools from fallen comrades.</li>
<li>If a human is directly killed by a zombie then they will rise again wherever they stand. Make sure you end their misery before they give you any.</li>
<li>You're only given a certain amount of Worth to play with so think carefully what you should get!</li>
<li>You can create, save, load, delete, and mark as default carts by pressing F2. This saves a ton of time which could be better spent setting up barricades or creating game plans.</li>
<li>A spot that feels safe one moment may be a death trap with more or different types of zombies roaming around. Always allow extra space and a "Plan B" if things get ugly.</li>
<li>You're useless to your team if you're not doing anything to help. You're even more useless to yourself since you're not getting any points or bigger weapons!</li>
<li>By holding your SPRINT key for about ten seconds while looking at deployed objects that you own, you can pack them up for later use.</li>
<li>Turrets without owners (a blue light) can be claimed by pressing USE on them. Ownerless turrets will not scan for targets!</li>
<li>Props that aren't nailed to something don't make very good barricades unless they're really heavy.</li>
<li>With enough punishment, doors can be thrown off their hinges.</li>
<li>Most props will become red with more and more damage.</li>
<li>Zombies can spawn on top of each other if no humans are around to witness it.</li>
<li>Most melee weapons have a longer reach than zombie claws. Use this to your advantage if you insist on defending with a melee weapon.</li>
<li>Players on the same team do not damage or collide with each other and can freely shoot and swing through each other.</li>
<li>Make sure you use a barricade to your advantage and stay behind it a good distance away from the zombies. Guns have an infinite range, zombie claws do not.</li>
<li>Poison damage will heal over time but enough of it can still kill you.</li>
<li>Your team members aren't always right, don't be a sheep! Zombies like to kill sheep.</li>
<li>Zombies can see your health, even through walls. Make sure to fall back when hurt as zombies will most likely try to pick you off.</li>
<li>Don't hide, zombies can sense you through walls and in complete darkness.</li>
<li>The Horde Meter at the bottom of the screen indicates how much of a damage and knockback resistance you have. Huddle up with other zombies for a big resistance when taking down strongholds!</li>
<li>If you don't have enough zombies to take down a barricade, try hunting for new "team mates" elsewhere.</li>
<li>Don't shoot zombies in the green gas! It quickly heals them and you're only wasting ammunition!</li>
<li>Zombies are resistant to damage in the chest and even more so in the arms and legs. Make sure you're aiming for the head as some zombies have the ability to get up again if you don't!</li>
<li>Although zombies take less damage in the legs, shooting them there will slow them down for a short time, enough to allow you or a team member to escape.</li>
</ul></p>
]]
LANGUAGE.help_cont_barricading						= [[<p>Barricading is an extremely important part of survival. It may seem like the undead aren't a threat early on but eventually they'll be powerful enough to kill your entire team in a few seconds.</p>

<p>The only thing keeping the zombies out is a well-built and well-maintained barricade.</p>

<p>There are a couple of tools that give you the ability to set this up. The one most useful tool is the hammer and nails. This allows you to nail down props which then must have the nails destroyed in order for the zombies to get to you.
Position the prop you want to nail by pressing USE on it to pick it up. You can hold SPRINT while holding it to lock it in place. Then take your hammer and right click where you want the nail to go. It's a good idea to nail the prop to a sturdy object such as a wall instead of other props.
Remember, when a prop is nailed it will forward the damage it takes to the nails themselves. You can repair nails by hitting them with the hammer but eventually they'll become too damaged to repair anymore. You can hold SHIFT with the hammer out to get a view of every single nail deployed on your screen as well as the owner.
If you think a nail is in a bad place or you'd like to reposition a prop, you can remove nails by pointing at it and pressing RELOAD. Be warned, if you take a nail that doesn't belong to you then you will be given a point penalty.
One more thing to remember: nails take less damage when they're nailed to bigger props. The bigger the size of the prop, the less damage its nails take and the other way around.</p>

<p>One other tool is the 'Aegis' Barricade Kit. This quick-deploying tool allows you to place boards on any surface or deploy them between two walls. It doesn't even need props. To use it, you need to position a board in a spot that is legal. The ghost will turn from red to green to let you know.
Deploy a board by pressing PRIMARY ATTACK. Rotate the board by using SECONDARY ATTACK and RELOAD. It uses boards for ammunition so boards you have from the Board Pack work as extra ammunition! You can pack up boards you've deployed by pressing SPRINT while pointing at it.</p>

<p>Another tool worth noting is the Turret. This tosses bullets at any zombie that gets in the way of its laser. Its only downside is that it requires ammunition. You can refill ammunition by pressing USE on it. This will give you bonus points for helping the team.
To deploy the turret, position it in a way so that the ghost is green. It must be on a solid surface (no props!). Rotate the turret with SECONDARY ATTACK and RELOAD. If you mess up, you can always pack the turret back up by pressing SPRINT while pointing at it. Remember, the turret will only fire at zombies that cross its tracking beam.</p>

<p>Tips for this section:
<ul>
<li>You get a 25% point bonus for killing zombies that are attacking a barricade!</li>
<li>Use bigger props for barricades. The nails take less damage and the prop has room for more nails. In addition to that, it even acts as cover from projectiles.</li>
</ul></p>]]
LANGUAGE.help_cont_upgrades							= [[<p>Points are obtained through killing zombies, healing team mates, and building defenses.
You can then exchange points in the Points Shop at Arsenal Crates.</p>

<p>Tips for this section:
<ul>
<li>Try planning ahead. Buy extra pistol ammunition in the Worth menu so you have plenty to spare once you get your first upgrade.</li>
<li>You still get points for assists. The greater half of the points goes to the killer and the lesser half goes to the one who assisted in the kill.</li>
<li>Worth and Points are separate. Make sure you spend all of your Worth!</li>
<li>Arsenal Crates are extremely valuable and prime targets for zombie attacks.</li>
</ul></p>]]
LANGUAGE.help_cont_being_a_zombie					= [[<p>Tips for this section:
<ul>
<li>You have an unlimited amount of lives, the humans only have one each. Don't be afraid to attack, attack, attack!</li>
<li>The regular Zombie class has the ability of durability. The only way to kill you for sure is to get shot in the head or be killed by a melee weapon. You don't need your legs.</li>
<li>Zombies can spawn on top of each other if no humans are around to see it. Check the eyes of the skull on the bottom of your screen. If they're green then you are a valid spawn point!</li>
<li>With enough practice, you can use props to slam them in to humans from a distance.</li>
<li>Destroy deployables such as turrets and especially Arsenal Crates to cripple the humans.</li>
<li>With enough punishment, doors can be thrown off their hinges.</li>
<li>Most props will become red with more and more damage.</li>
<li>The Wraith is completely invisible while standing still or at a distance.</li>
<li>The Fast Zombie's lunge attack damage scales by how long you're in the air. The more air time you get, the larger the damage. Use your claw attack when in close range!</li>
<li>In addition to being extremely tough, the Poison Zombie can rip out chunks of its own poison flesh and throw them at humans by pressing SECONDARY ATTACK.</li>
<li>Most zombie claws have two chances to hit their target. If you "hit" your target when you click your mouse button then you're guaranteed a hit as long as they remain in range.</li>
<li>The Poison Headcrab's spit projectile can confuse humans if it hits them in the head.</li>
<li>Go for the humans with low health! Other zombies are also attracted to them so they should be the easiest targets.</li>
<li>The Horde Meter at the bottom of the screen indicates how much of a damage and knockback resistance you have. Huddle up with other zombies for a big resistance when taking down strongholds!</li>
<li>If you don't have enough zombies to take down a barricade, try hunting for new "team mates" elsewhere.</li>
<li>If an area is too dark, try pressing your FLASHLIGHT button to toggle night vision.</li>
</ul></p>
]]

-- Place any custom stuff below here...
