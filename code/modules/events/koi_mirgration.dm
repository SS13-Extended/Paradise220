/datum/event/carp_migration/koi
	spawned_mobs = list(
    /mob/living/simple_animal/hostile/carp/koi = 98,
    /mob/living/simple_animal/hostile/carp/koi/honk = 2)


/datum/event/carp_migration/koi/start()
	log_debug("Starting event with spawning [GLOB.landmarks_list.len] koi")
	spawn_fish(GLOB.landmarks_list.len)
