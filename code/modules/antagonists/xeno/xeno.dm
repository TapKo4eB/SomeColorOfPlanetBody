/datum/team/xeno
	name = "Aliens"

//Simply lists them.
/datum/team/xeno/roundend_report()
	var/list/parts = list()
	parts += "<span class='header'>The [name] were:</span>"
	parts += printplayerlist(members)
	return "<div class='panel redborder'>[parts.Join("<br>")]</div>"

/datum/antagonist/xeno
	name = "Xenomorph"
	job_rank = ROLE_ALIEN
	show_in_antagpanel = FALSE
	show_to_ghosts = TRUE
	var/datum/team/xeno/xeno_team
	threat = 3
	soft_antag = FALSE // BLUEMOON ADDITION

/datum/antagonist/xeno/threat()
	. = 3
	if(isalienhunter(owner))
		. = 6
	else if(isaliensentinel(owner))
		. = 12
	else if(isalienroyal(owner))
		if(isalienqueen(owner))
			. = 24
		else
			. = 18

/datum/antagonist/xeno/create_team(datum/team/xeno/new_team)
	if(!new_team)
		for(var/datum/antagonist/xeno/X in GLOB.antagonists)
			if(!X.owner || !X.xeno_team)
				continue
			xeno_team = X.xeno_team
			return
		xeno_team = new
	else
		if(!istype(new_team))
			CRASH("Wrong xeno team type provided to create_team")
		xeno_team = new_team

/datum/antagonist/xeno/get_team()
	return xeno_team

//XENO
/mob/living/carbon/alien/mind_initialize()
	..()
	if(!mind.has_antag_datum(/datum/antagonist/xeno))
		mind.add_antag_datum(/datum/antagonist/xeno)
