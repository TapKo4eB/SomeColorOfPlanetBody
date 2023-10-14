
/datum/species/shadowling
	//Normal shadowpeople but with enhanced effects
	name = "Shadowling"
	id = SPECIES_SHADOWLING
	sexes = TRUE // Please, don't even try to ask me why shadowpeople don't have that but shadowlings do.
	blacklisted = TRUE

	//blood_color = "#555555" //working around that will take some time and new blood types (rly?)
	//flesh_color = "#222222"

	species_traits = list(NOBLOOD)
	//Can't use guns due to muzzle flash
	inherent_traits = list(TRAIT_RADIMMUNE, TRAIT_NOBREATH, TRAIT_NOGUNS, TRAIT_NOHUNGER, TRAIT_INVISIBLE_MAN, TRAIT_VIRUSIMMUNE, TRAIT_SILENT_STEP) //TODO: invisman may not be working

	burnmod = 1.25
	heatmod = 1.5

	//grant_vision_toggle = 0
	mutanteyes = /obj/item/organ/eyes // normal eyes so we don't break anything with night vision ability
	disliked_food = NONE

/datum/species/shadowling/lesser //Empowered thralls. Obvious, but powerful
	//name = "Lesser Shadowling" // TODO: add specific icons
	name = "Shadowling"

	//icobase = 'icons/mob/human_races/r_lshadowling.dmi'
	//deform = 'icons/mob/human_races/r_lshadowling.dmi'

	//blood_color = "#CCCCCC"
	//flesh_color = "#AAAAAA"
	species_traits = list(NOBLOOD)
	inherent_traits = list(TRAIT_RADIMMUNE, TRAIT_NOBREATH, TRAIT_NOGUNS, TRAIT_NOHUNGER, TRAIT_INVISIBLE_MAN, TRAIT_VIRUSIMMUNE, TRAIT_SILENT_STEP)
	//species_traits = list(NO_BLOOD, NO_BREATHE, RADIMMUNE, NO_HUNGER, NO_EXAMINE)
	burnmod = 1.1
	heatmod = 1.1

/datum/species/shadowling/lesser/spec_life(mob/living/carbon/human/H)
	//if(!H.weakeyes)
	//	H.weakeyes = 1
	handle_light(H)

/datum/species/shadowling/proc/handle_light(mob/living/carbon/human/H)
	var/light_amount = 0
	if(isturf(H.loc))
		var/turf/T = H.loc
		light_amount = T.get_lumcount() * 10
		if(light_amount > LIGHT_DAM_THRESHOLD && !H.incorporeal_move) //Can survive in very small light levels.Also doesn't take damage while incorporeal, for shadow walk purposes
			H.throw_alert("lightexposure", /atom/movable/screen/alert/lightexposure)
			if(is_species(H, /datum/species/shadowling/lesser))
				H.take_overall_damage(0, LIGHT_DAMAGE_TAKEN/2)
			else
				H.take_overall_damage(0, LIGHT_DAMAGE_TAKEN)
			if(H.stat != DEAD)
				to_chat(H, "<span class='userdanger'>Свет жжёт вас!</span>")//Message spam to say "GET THE FUCK OUT"
				H << 'sound/weapons/sear.ogg'
		else if(light_amount < LIGHT_HEAL_THRESHOLD)
			H.clear_alert("lightexposure")
			H.adjustOrganLoss(ORGAN_SLOT_EYES, -1)
			if(is_species(H, /datum/species/shadowling/lesser))
				H.heal_overall_damage(2, 3)
			else
				H.heal_overall_damage(5, 7)
			H.adjustToxLoss(-5)
			H.adjustOrganLoss(ORGAN_SLOT_BRAIN, -25) //Shad O. Ling gibbers, "CAN U BE MY THRALL?!!"
			//H.AdjustEyeBlurry(-2 SECONDS)
			//H.CureNearsighted()
			//H.CureBlind()
			//H.adjustCloneLoss(-1)
			H.SetKnockdown(0)
			H.SetStun(0)
		else
			if(H.health <= HEALTH_THRESHOLD_CRIT) // to finish shadowlings in rare occations
				H.adjustBruteLoss(1)

/datum/species/shadowling/spec_life(mob/living/carbon/human/H)
	//if(!H.weakeyes)
	//	H.weakeyes = 1 //Makes them more vulnerable to flashes and flashbangs
	handle_light(H)

/atom/movable/screen/alert/lightexposure
	name = "Light Exposure"
	desc = "You're exposed to light!"
	icon_state = "lightexposure"
