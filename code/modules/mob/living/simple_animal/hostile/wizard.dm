/mob/living/simple_animal/hostile/wizard
	name = "Space Wizard"
	desc = "EI NATH?"
	icon_state = "wizard"
	icon_living = "wizard"
	icon_dead = "wizard_dead"
	speak_chance = 0
	turns_per_move = 3
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = 0
	maxHealth = 100
	health = 100
	harm_intent_damage = 5
	melee_damage_lower = 5
	melee_damage_upper = 5
	attacktext = "punches"
	attack_sound = 'sound/weapons/punch1.ogg'
	a_intent = "harm"
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	unsuitable_atmos_damage = 15
	faction = list("wizard")
	status_flags = list(CANPUSH)

	retreat_distance = 3 //out of fireball range
	minimum_distance = 3
	del_on_death = 1
	loot = list(/obj/effect/mob_spawn/human/corpse/wizard,
				/obj/item/weapon/staff)

	var/obj/effect/proc_holder/spell/dumbfire/fireball/fireball = null
	var/obj/effect/proc_holder/spell/targeted/turf_teleport/blink/blink = null
	var/obj/effect/proc_holder/spell/targeted/projectile/magic_missile/mm = null

	var/next_cast = 0


/mob/living/simple_animal/hostile/wizard/New()
	..()
	fireball = new /obj/effect/proc_holder/spell/dumbfire/fireball
	fireball.clothes_req = 0
	fireball.human_req = 0
	fireball.player_lock = 0
	AddSpell(fireball)

	mm = new /obj/effect/proc_holder/spell/targeted/projectile/magic_missile
	mm.clothes_req = 0
	mm.human_req = 0
	mm.player_lock = 0
	AddSpell(mm)

	blink = new /obj/effect/proc_holder/spell/targeted/turf_teleport/blink
	blink.clothes_req = 0
	blink.human_req = 0
	blink.player_lock = 0
	blink.outer_tele_radius = 3
	AddSpell(blink)

/mob/living/simple_animal/hostile/wizard/handle_automated_action()
	. = ..()
	if(target && next_cast < world.time)
		if((get_dir(src,target) in list(SOUTH,EAST,WEST,NORTH)) && fireball.cast_check(0,src)) //Lined up for fireball
			src.dir = get_dir(src,target)
			fireball.choose_targets(src)
			next_cast = world.time + 10 //One spell per second
			return .
		if(mm.cast_check(0,src))
			mm.choose_targets(src)
			next_cast = world.time + 10
			return .
		if(blink.cast_check(0,src)) //Spam Blink when you can
			blink.choose_targets(src)
			next_cast = world.time + 10
			return .

/mob/living/simple_animal/hostile/wizard/cloaked
	name = "cloaked space wizard"
	desc = "Malarky the Mad, former space wizard who was recently disbanded from the wizards federation. He uses unholy magic to preserve his body trapped up in his bubble made of magic slowly decaying. Now he spends his days hallucinating in his old abandoned wizard den plotting his revenge."
	stat_attack = 1
	robust_searching = 1
	speed = 1 // they are slow
	unsuitable_atmos_damage = 0
	minbodytemp = 0
	maxbodytemp = INFINITY
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	var/image/shieldoverlay

/mob/living/simple_animal/hostile/wizard/cloaked/New()
	..()
	shieldoverlay = image('icons/effects/effects.dmi', "shield-old")
	overlays += shieldoverlay


/mob/living/simple_animal/hostile/wizard/cloaked/death()
	..()
	overlays -= shieldoverlay
	shieldoverlay = null