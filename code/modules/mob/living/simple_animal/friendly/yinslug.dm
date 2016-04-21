/*
  Tiny babby plant critter plus procs.
*/

//Mob defines.
/mob/living/simple_animal/yin
	name = "yin"
	icon = 'icons/mob/mob.dmi'
	icon_state = "headcrab"
	icon_living = "headcrab"
	icon_dead = "headcrab_dead"
//	icon_resting = "nymph_sleep"
	pass_flags = PASSTABLE | PASSMOB
	small = 1
	ventcrawler = 2

	maxHealth = 100
	health = 100

	voice_name = "yin"
	speak_emote = list("chirrups")
	emote_hear = list("chirrups")
	emote_see = list("chirrups")

	response_help  = "pets"
	response_disarm = "pushes"
	response_harm   = "kicks"

	melee_damage_lower = 5
	melee_damage_upper = 8
	attacktext = "bites"
	attack_sound = 'sound/weapons/bite.ogg'

	speed = 0
	stop_automated_movement = 0
	turns_per_move = 4

	var/list/donors = list()
	var/ready_evolve = 0
	holder_type = /obj/item/organ/internal/brain/yinslug
	can_collar = 1

/mob/living/simple_animal/yin/New()
	..()
	if(name == initial(name)) //To stop Pun-Pun becoming generic.
		name = "[name] ([rand(1, 1000)])"
		real_name = name

	add_language("Rootspeak")

/mob/living/simple_animal/yin/attack_hand(mob/living/carbon/human/M as mob)
	if(M.a_intent == I_HELP)
		get_scooped(M)
	..()

/mob/living/simple_animal/yin/put_in_hands(obj/item/W)
	W.loc = get_turf(src)
	W.layer = initial(W.layer)
	W.dropped()

/mob/living/simple_animal/yin/put_in_active_hand(obj/item/W)
	to_chat(src, "<span class='warning'>You don't have any hands!</span>")
	return

/mob/living/simple_animal/yin/emote(var/act, var/m_type=1, var/message = null)
	if(stat)
		return

	var/on_CD = 0
	switch(act)
		if("chirp")
			on_CD = handle_emote_CD()
		else
			on_CD = 0

	if(on_CD == 1)
		return

	switch(act) //IMPORTANT: Emotes MUST NOT CONFLICT anywhere along the chain.
		if("chirp")
			message = "<B>\The [src]</B> chirps!"
			m_type = 2 //audible
			playsound(src, 'sound/misc/nymphchirp.ogg', 40, 1, 1)

	..(act, m_type, message)