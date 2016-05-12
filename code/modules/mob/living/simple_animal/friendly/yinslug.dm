/*
  All the mobs related to the Yin go in here
*/

//Mob defines.
/mob/living/simple_animal/yin
	name = "yin"
	desc = "A small, intelligent creature mostly made of nerve tissue."
	icon = 'icons/mob/yin_pilot.dmi'
	icon_state = "yin"
	icon_living = "yin"
	icon_dead = "yin_dead"
	icon_resting = "yin_asleep"
	pass_flags = PASSTABLE | PASSMOB
	small = 1
	can_hide = 1
	ventcrawler = 2

	maxHealth = 60
	health = 60

	voice_name = "yin"
	speak_emote = list("buzzes")
	emote_hear = list("buzzes")
	emote_see = list("buzzes")

	response_help  = "pets"
	response_disarm = "pushes"
	response_harm   = "kicks"

	melee_damage_lower = 0
	melee_damage_upper = 0
	attacktext = "bites"
	attack_sound = 'sound/weapons/bite.ogg'

	speed = 0
	stop_automated_movement = 0
	turns_per_move = 4

	var/datum/dna/cached_dna
	holder_type = /obj/item/organ/internal/brain/yinslug
	can_collar = 0

/mob/living/simple_animal/yin/New()
	..()
	if(name == initial(name)) //To stop Pun-Pun becoming generic.
		name = "[name] ([rand(1, 1000)])"
		real_name = name

	add_language("Yin Tactical Uplink")

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


/mob/living/simple_animal/yin/verb/enter_shell()
	set category = "Animal"
	set name = "Enter shell"
	set desc = "Enter the control pod of a humanoid mechanical shell."

	if(stat)
		to_chat(src, "You cannot climb into a shell in your current state.")
		return

	var/list/choices = list()
	for(var/mob/living/carbon/human/H in view(1,src))
		var/obj/item/organ/external/head/head = H.get_organ("head")
		//var/obj/item/organ/internal/brain/yinslug/P = H.get_organ("pilot")
		var/species = H.get_species()
		if(head.status & ORGAN_DESTROYED)
			continue
		if(H.stat == DEAD && src.Adjacent(H) && species == "Yin")
			choices += H

	var/mob/living/carbon/human/M = input(src,"Which shell do you wish to enter?") in null|choices

	if(!M || !src) return

	if(!(src.Adjacent(M))) return

	if(M.getBrainLoss()<200)
		to_chat(src, "This shell already has someone inside!")
		return

	to_chat(src, "You begin climbing into the empty control pod in [M]'s head...")

	if(!do_after(src,20, target = M))
		to_chat(src, "As [M] moves away, you are dislodged and fall to the ground.")
		return

	if(!M || !src) return

	if(src.stat)
		to_chat(src, "You cannot climb into a shell in your current state.")
		return

	if(M.stat != DEAD)
		to_chat(src, "That is not an appropriate target.")
		return

	if(M in view(1, src))
		to_chat(src, "You enter the control pod of the [M] shell")

		var/obj/item/organ/internal/brain/Y = new /obj/item/organ/internal/brain/yinslug(M)
		Y.set_dna(cached_dna)
		M.internal_organs |= Y
		Y.insert(M)
		mind.transfer_to(M)
		M.adjustBrainLoss((60 - src.health)*2)
		qdel(src)
		return
	else
		to_chat(src, "They are no longer in range!")
		return
/*
/mob/living/simple_animal/yinslug/proc/perform_entrance(var/mob/living/carbon/M)
	src.host = M
	src.forceMove(M)

	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/head = H.get_organ("head")
		head.implants += src

	host.status_flags |= PASSEMOTES */

/////////////////////////////////////////////////////
/////////// Invasion Shells   ///////////////////////
/////////////////////////////////////////////////////

/mob/living/silicon/robot/yinvader
	icon = 'icons/mob/yin_pilot.dmi'
	base_icon = "invader"
	icon_state = "invader"
	lawupdate = 0
	scrambledcodes = 1
	modtype = "Invader"
	faction = list("yin")
	designation = "Yin Invader"
	req_access = list(access_yin)
	var/searching_for_ckey = 0

/mob/living/silicon/robot/yinvader/New(loc)
	..()
	cell.maxcharge = 50000
	cell.charge = 50000

/mob/living/silicon/robot/yinvader/init()
	laws = new /datum/ai_laws/deathsquad
	module = new /obj/item/weapon/robot_module/yinvader(src)

	aiCamera = new/obj/item/device/camera/siliconcam/robot_camera(src)
	radio = new /obj/item/device/radio/borg/deathsquad(src)
	radio.recalculateChannels()

	playsound(loc, 'sound/mecha/nominalsyndi.ogg', 75, 0)

/obj/item/weapon/robot_module/yinvader
	name = "Yin Combat Module"
	module_type = "Malf"

/obj/item/weapon/robot_module/yinvader/New()
	src.modules += new /obj/item/device/flash/cyborg(src)
	src.modules += new /obj/item/borg/sight/thermal(src)
	src.modules += new /obj/item/weapon/melee/energy/sword/cyborg(src)
	src.modules += new /obj/item/weapon/gun/energy/pulse_rifle/cyborg(src)
	src.modules += new /obj/item/weapon/tank/jetpack/carbondioxide(src)
	src.modules += new /obj/item/weapon/crowbar(src)
	src.emag = null

	fix_modules()