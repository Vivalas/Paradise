/datum/species/pilot
	name = "Yin"
	name_plural = "Yini"

	icobase = 'icons/mob/human_races/r_pilot.dmi'
	deform = 'icons/mob/human_races/r_pilot.dmi'
	path = /mob/living/carbon/human/pilot
	default_language = "Galactic Common"
	unarmed_type = /datum/unarmed_attack/claws
	blood_color = "#1F181F"
	flesh_color = "#AAAAAA"
	has_organ = list(
		"brain" = /obj/item/organ/internal/brain/yinslug,
		"reactor" = /obj/item/organ/internal/reactor,
		"optics" = /obj/item/organ/internal/optical_sensor
		)
	vision_organ = /obj/item/organ/internal/optical_sensor
	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest/yin),
		"groin" =  list("path" = /obj/item/organ/external/groin/yin),
		"head" =   list("path" = /obj/item/organ/external/head/yin),
		"l_arm" =  list("path" = /obj/item/organ/external/arm/yin),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right/yin),
		"l_leg" =  list("path" = /obj/item/organ/external/leg/yin),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right/yin),
		"l_hand" = list("path" = /obj/item/organ/external/hand/yin),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right/yin),
		"l_foot" = list("path" = /obj/item/organ/external/foot/yin),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right/yin)
		)

	flags = IS_WHITELISTED | NO_BREATHE | NO_SCAN | NO_BLOOD | NO_PAIN | NO_DNA | NO_POISON | ALL_RPARTS
	bodyflags = HAS_SKIN_COLOR
	virus_immune = 1
	can_revive_by_healing = 1
	dietflags = DIET_OMNI
	reagent_tag = PROCESS_SYN
	suicide_messages = list(
		"is shutting down life support!",
		"is overloading their controls!!",
		"is sticking their fingers through their windscreen!",
		"is overheating the compartment!")

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 500
	heat_level_2 = 540
	heat_level_3 = 600
	heat_level_3_breathe = 600