//In here: Hatch and Ascendance
GLOBAL_LIST_INIT(possibleShadowlingNames, list("U'ruan", "Y`shej", "Nex", "Hel-uae", "Noaey'gief", "Mii`mahza", "Amerziox", "Gyrg-mylin", "Kanet'pruunance", "Vigistaezian")) //Unpronouncable 2: electric boogalo)

/obj/effect/proc_holder/spell/self/shadowling_hatch
	name = "Hatch"
	desc = "Casts off your disguise."
	panel = "Shadowling Evolution"
	cooldown_min = 5 MINUTES //TODO: CHECK LATER
	clothes_req = FALSE
	action_icon = 'icons/mob/actions/actions_shadowling.dmi'
	action_icon_state = "hatch"
	var/cycles_unused = 0

/obj/effect/proc_holder/spell/self/shadowling_hatch/Trigger(list/targets, mob/user)
	var/hatch_or_no = alert(usr, "Are you sure you want to hatch? You cannot undo this!",,"Yes","No")
	switch(hatch_or_no) //TODO: move input somewhere else
		if("No")
			to_chat(user, "<span class='warning'>You decide against hatching for now.")
			revert_cast(user)
			return
	. = ..()


/obj/effect/proc_holder/spell/self/shadowling_hatch/cast(mob/living/carbon/human/user)
	if(user.stat || !ishuman(user) || !user || !is_shadow(user || isinspace(user)))
		return

	if(!isturf(user.loc))
		revert_cast(user)
		to_chat(user, "<span class='warning'>You must be standing on a floor to hatch!</span>")
		return

	user.Stun(INFINITY)
	user.visible_message("<span class='warning'>[user]'s things suddenly slip off. They hunch over and vomit up a copious amount of purple goo which begins to shape around them!</span>", "<span class='shadowling'>You remove any equipment which would hinder your hatching and begin regurgitating the resin which will protect you.</span>")

	for(var/obj/item/item in user.get_equipped_items(include_pockets = TRUE))
		sleep(1)
		user.dropItemToGround(item)

	// TODO: fake throw up cycle
	user.mind.RemoveSpell(src)
	sleep(5 SECONDS)
	if(QDELETED(user))
		return

	var/turf/open/F
	var/turf/shadowturf = get_turf(user)
	for(F in orange(1, user))
		playsound(user, 'sound/effects/splat.ogg', 50, TRUE)
		new /obj/structure/alien/resin/wall/shadowling(F)
		sleep(1)

	for(var/obj/structure/alien/resin/wall/shadowling/R in shadowturf) //extremely hacky
		qdel(R)
		new /obj/structure/alien/weeds/node(shadowturf) //Dim lighting in the chrysalis -- removes itself afterwards

	//Can't die while hatching
	user.physiology.brute_mod = 0;
	user.physiology.burn_mod = 0;
	user.physiology.tox_mod = 0;
	user.physiology.oxy_mod = 0;
	user.physiology.clone_mod = 0;
	user.physiology.brain_mod = 0;

	user.visible_message("<span class='warning'>A chrysalis forms around [user], sealing [user.p_them()] inside.</span>", \
					"<span class='shadowling'>You create your chrysalis and begin to contort within.</span>")

	sleep(10 SECONDS)
	if(QDELETED(user))
		return

	user.visible_message("<span class='warning'><b>The skin on [user]'s back begins to split apart. Black spines slowly emerge from the divide.</b></span>", \
					"<span class='shadowling'>Spines pierce your back. Your claws break apart your fingers. You feel excruciating pain as your true form begins its exit.</span>")

	sleep(9 SECONDS)
	if(QDELETED(user))
		return

	user.visible_message("<span class='warning'><b>[user], skin shifting, begins tearing at the walls around [user.p_them()].</b></span>", \
						"<span class='shadowling'>Your false skin slips away. You begin tearing at the fragile membrane protecting you.</span>")

	sleep(8 SECONDS)
	if(QDELETED(user))
		return

	playsound(user.loc, 'sound/weapons/slash.ogg', 25, TRUE)
	to_chat(user, "<i><b>You rip and slice.</b></i>")

	sleep(1 SECONDS)
	if(QDELETED(user))
		return

	playsound(user.loc, 'sound/weapons/slashmiss.ogg', 25, TRUE)
	to_chat(user, "<i><b>The chrysalis falls like water before you.</b></i>")

	sleep(1 SECONDS)
	if(QDELETED(user))
		return

	playsound(user.loc, 'sound/weapons/slice.ogg', 25, TRUE)
	to_chat(user, "<i><b>You are free!</b></i>")

	sleep(1 SECONDS)
	if(QDELETED(user))
		return

	playsound(user.loc, 'sound/effects/ghost.ogg', 50, TRUE)
	var/newNameId = pick(GLOB.possibleShadowlingNames)
	GLOB.possibleShadowlingNames.Remove(newNameId)
	user.real_name = newNameId
	user.name = user.real_name
	user.SetStun(0)
	to_chat(user, "<i><b><font size=3>YOU LIVE!!!</i></b></font>")

	for(var/obj/structure/alien/resin/wall/shadowling/resin in orange(user, 1))
		playsound(resin, 'sound/effects/splat.ogg', 50, TRUE)
		qdel(resin)

	for(var/obj/structure/alien/weeds/node/node in shadowturf)
		qdel(node)

	user.visible_message("<span class='warning'>The chrysalis explodes in a shower of purple flesh and fluid!</span>")
	user.underwear = "None"
	user.undershirt = "None"
	user.socks = "None"
	user.faction |= "faithless"

	user.set_species(/datum/species/shadowling)	//can't be a shadowling without being a shadowling
	user.equip_to_slot_or_del(new /obj/item/clothing/under/shadowling(user), ITEM_SLOT_ICLOTHING)
	user.equip_to_slot_or_del(new /obj/item/clothing/shoes/shadowling(user), ITEM_SLOT_FEET)
	user.equip_to_slot_or_del(new /obj/item/clothing/suit/space/shadowling(user), ITEM_SLOT_OCLOTHING)
	user.equip_to_slot_or_del(new /obj/item/clothing/head/shadowling(user), ITEM_SLOT_HEAD)
	user.equip_to_slot_or_del(new /obj/item/clothing/gloves/shadowling(user), ITEM_SLOT_GLOVES)
	user.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/shadowling(user), ITEM_SLOT_MASK)
	user.equip_to_slot_or_del(new /obj/item/clothing/glasses/shadowling(user), ITEM_SLOT_EYES)

	sleep(1 SECONDS)
	if(QDELETED(user))
		return

	to_chat(user, "<span class='shadowling'><b><i>Your powers are awoken. You may now live to your fullest extent. Remember your goal. Cooperate with your thralls and allies.</b></i></span>")
	user.ExtinguishMob()
	user.set_nutrition(NUTRITION_LEVEL_FED + 50)
	user.set_thirst(THIRST_LEVEL_THRESHOLD)

	//user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/night_vision(null))
	//user.mind.AddSpell(new /obj/effect/proc_holder/spell/shadowling_vision(null))
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/pointed/shadowling_enthrall(null))
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/pointed/shadowling_glare(null))
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/shadowling_veil(null))
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/self/shadowling_shadow_walk(null))
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shadowling_icy_veins(null))
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/self/shadowling_collective_mind(null))
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/self/shadowling_regen_armor(null))
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/pointed/shadowling_extend_shuttle(null))

	// why do we even need to delete the old hud?
	//QDEL_NULL(user.hud_used)
	//user.hud_used = new /datum/hud/human(user, ui_style2icon(user.client.prefs.UI_style), user.client.prefs.UI_style_color, user.client.prefs.UI_style_alpha)
	//user.hud_used.show_hud(user.hud_used.hud_version)


/obj/effect/proc_holder/spell/self/shadowling_ascend
	name = "Ascend"
	desc = "Enters your true form."
	panel = "Shadowling Evolution"
	cooldown_min = 5 MINUTES
	clothes_req = FALSE
	action_icon_state = "ascend"

/obj/effect/proc_holder/spell/self/shadowling_ascend/cast(list/targets, mob/living/carbon/human/user = usr)
	if(!shadowling_check(user))
		return

	var/hatch_or_no = alert(user, "It is time to ascend. Are you sure about this?",,"Yes","No")
	switch(hatch_or_no)
		if("No")
			to_chat(user, "<span class='warning'>You decide against ascending for now.")
			revert_cast(user)
			return

		if("Yes")
			//user.notransform = TRUE
			user.visible_message("<span class='warning'>[user] gently rises into the air, red light glowing in its eyes.</span>", \
								"<span class='shadowling'>You rise into the air and get ready for your transformation.</span>")

			sleep(5 SECONDS)
			if(QDELETED(user))
				return

			user.visible_message("<span class='warning'>[user]'s skin begins to crack and harden.</span>", \
								"<span class='shadowling'>Your flesh begins creating a shield around yourself.</span>")

			sleep(10 SECONDS)
			if(QDELETED(user))
				return
			user.visible_message("<span class='warning'>The small horns on [user]'s head slowly grow and elongate.</span>", \
								"<span class='shadowling'>Your body continues to mutate. Your telepathic abilities grow.</span>") //y-your horns are so big, senpai...!~

			sleep(9 SECONDS)
			if(QDELETED(user))
				return
			user.visible_message("<span class='warning'>[user]'s body begins to violently stretch and contort.</span>", \
							  "<span class='shadowling'>You begin to rend apart the final barriers to godhood.</span>")

			sleep(4 SECONDS)
			if(QDELETED(user))
				return
			to_chat(user, "<i><b>Yes!</b></i>")

			sleep(1 SECONDS)
			if(QDELETED(user))
				return
			to_chat(user, "<i><b><span class='big'>YES!!</span></b></i>")

			sleep(1 SECONDS)
			if(QDELETED(user))
				return
			to_chat(user, "<i><b><span class='reallybig'>YE--</span></b></i>")

			sleep(0.1 SECONDS)
			if(QDELETED(user))
				return
			for(var/mob/living/mob in orange(7, user))
				mob.Knockdown(20 SECONDS) //TODO: does weak even exists in tg? maybe stun instead
				to_chat(mob, "<span class='userdanger'>An immense pressure slams you onto the ground!</span>")

			for(var/obj/machinery/power/apc/apc in GLOB.apcs_list)
				INVOKE_ASYNC(apc, TYPE_PROC_REF(/obj/machinery/power/apc, overload_lighting))

			var/mob/living/simple_animal/ascendant_shadowling/ascendant = new (user.loc)
			ascendant.announce("VYSHA NERADA YEKHEZET U'RUU!!", 5, 'sound/hallucinations/veryfar_noise.ogg')
			for(var/obj/effect/proc_holder/spell/spell in user.mind.spell_list)
				if(spell == src)
					continue
				user.mind.RemoveSpell(spell)

			user.mind.transfer_to(ascendant)
			ascendant.name = user.real_name
			//ascendant.languages = user.languages
			//ascendant.mind.AddSpell(new /obj/effect/proc_holder/spell/ascendant_annihilate(null))
			//ascendant.mind.AddSpell(new /obj/effect/proc_holder/spell/ascendant_hypnosis(null))
			//ascendant.mind.AddSpell(new /obj/effect/proc_holder/spell/ascendant_phase_shift(null))
			//ascendant.mind.AddSpell(new /obj/effect/proc_holder/spell/aoe/ascendant_storm(null))
			//ascendant.mind.AddSpell(new /obj/effect/proc_holder/spell/ascendant_transmit(null))

			if(ascendant.real_name)
				ascendant.real_name = user.real_name

			user.invisibility = 60 //This is pretty bad, but is also necessary for the shuttle call to function properly
			user.forceMove(ascendant)

			sleep(5 SECONDS)
			if(QDELETED(user))
				return

			var/datum/antagonist/shadowling/s = user.mind.has_antag_datum(/datum/antagonist/shadowling)

			if(!s.ling_team.shadowling_ascended)
				SSshuttle.emergency.request(null, 0.3)
				SSshuttle.emergencyNoRecall = TRUE

			s.ling_team.shadowling_ascended = TRUE
			ascendant.mind.RemoveSpell(src)
			qdel(user)

/*
/**
 * Testing purpose.
 */
/mob/living/carbon/human/proc/make_unhatched_shadowling()
	for(var/obj/item/item in get_equipped_items(include_pockets = TRUE))
		dropItemToGround(item)

	var/newNameId = pick(GLOB.possibleShadowlingNames)
	GLOB.possibleShadowlingNames.Remove(newNameId)
	real_name = newNameId
	name = real_name

	underwear = "None"
	undershirt = "None"
	socks = "None"
	faction |= "faithless"
	//add_language("Shadowling Hivemind")

	set_species(/datum/species/shadowling)
	equip_to_slot_or_del(new /obj/item/clothing/under/shadowling(src), ITEM_SLOT_ICLOTHING)
	equip_to_slot_or_del(new /obj/item/clothing/shoes/shadowling(src), ITEM_SLOT_FEET)
	equip_to_slot_or_del(new /obj/item/clothing/suit/space/shadowling(src), ITEM_SLOT_OCLOTHING)
	equip_to_slot_or_del(new /obj/item/clothing/head/shadowling(src), ITEM_SLOT_HEAD)
	equip_to_slot_or_del(new /obj/item/clothing/gloves/shadowling(src), ITEM_SLOT_GLOVES)
	equip_to_slot_or_del(new /obj/item/clothing/mask/gas/shadowling(src), ITEM_SLOT_MASK)
	equip_to_slot_or_del(new /obj/item/clothing/glasses/shadowling(src), ITEM_SLOT_EYES)

	to_chat(src, "<span class='shadowling'><b><i>Your powers are awoken. You may now live to your fullest extent. Remember your goal. Cooperate with your thralls and allies.</b></i></span>")

	ExtinguishMob()
	set_nutrition(NUTRITION_LEVEL_FED + 50)
	set_thirst(THIRST_LEVEL_THRESHOLD)
	/*
	mind.AddSpell(new /obj/effect/proc_holder/spell/shadowling_vision(null))
	mind.AddSpell(new /obj/effect/proc_holder/spell/shadowling_enthrall(null))
	mind.AddSpell(new /obj/effect/proc_holder/spell/shadowling_glare(null))
	mind.AddSpell(new /obj/effect/proc_holder/spell/aoe/shadowling_veil(null))
	mind.AddSpell(new /obj/effect/proc_holder/spell/shadowling_shadow_walk(null))
	mind.AddSpell(new /obj/effect/proc_holder/spell/aoe/shadowling_icy_veins(null))
	mind.AddSpell(new /obj/effect/proc_holder/spell/shadowling_collective_mind(null))
	mind.AddSpell(new /obj/effect/proc_holder/spell/shadowling_regen_armor(null))
	mind.AddSpell(new /obj/effect/proc_holder/spell/shadowling_extend_shuttle(null))
	mind.AddSpell(new /obj/effect/proc_holder/spell/aoe/shadowling_screech(null))
	mind.AddSpell(new /obj/effect/proc_holder/spell/shadowling_blindness_smoke(null))
	mind.AddSpell(new /obj/effect/proc_holder/spell/shadowling_null_charge(null))
	mind.AddSpell(new /obj/effect/proc_holder/spell/shadowling_revive_thrall(null))
	mind.AddSpell(new /obj/effect/proc_holder/spell/shadowling_ascend(null))
	*/
	mind.special_role = ROLE_SHADOWLING
	var/datum/antagonist/shadowling/s = mind.has_antag_datum(/datum/antagonist/shadowling)
	s.ling_team.shadows += src.mind // do i need it?
	//antag hud or whatewher
	//SSticker.mode.update_shadow_icons_added(src.mind)

*/
