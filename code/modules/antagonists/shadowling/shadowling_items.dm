/obj/item/clothing/under/shadowling
	name = "blackened flesh"
	desc = "Black, chitinous skin with thin red veins."
	icon = 'icons/obj/shadowling_clothes.dmi' // threw them here becuase they don't have any onmob icon to begin with
	icon_state = "shadowling_uniform"
	item_flags = ABSTRACT
	has_sensor = FALSE
	//displays_id = FALSE TODO: find why it needed
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF

/obj/item/clothing/under/shadowling/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)

/obj/item/clothing/suit/space/shadowling
	name = "chitin shell"
	//Still takes damage from spacewalking but is immune to space itself
	desc = "Dark, semi-transparent shell. Protects against vacuum, but not against the light of the stars."
	icon = 'icons/obj/shadowling_clothes.dmi'
	icon_state = "shadowling"
	body_parts_covered = FULL_BODY //Shadowlings are immune to space
	cold_protection = FULL_BODY
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	flags_inv = HIDEGLOVES | HIDESHOES | HIDEJUMPSUIT
	slowdown = 0
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	heat_protection = null //You didn't expect a light-sensitive creature to have heat resistance, did you?
	max_heat_protection_temperature = null
	armor = list(melee = 25, bullet = 0, laser = 25, energy = 10, bomb = 25, bio = 100, rad = 100, fire = 100, acid = 100)
	item_flags = ABSTRACT
	clothing_flags = THICKMATERIAL | STOPSPRESSUREDAMAGE

/obj/item/clothing/suit/space/shadowling/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)

/obj/item/clothing/shoes/shadowling
	name = "chitin feet"
	desc = "Charred-looking feet. They have minature hooks that latch onto flooring."
	icon = 'icons/obj/shadowling_clothes.dmi'
	icon_state = "shadowling_shoes"
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	item_flags = ABSTRACT
	clothing_flags = NOSLIP

/obj/item/clothing/shoes/shadowling/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)

/obj/item/clothing/mask/gas/shadowling
	name = "chitin mask"
	desc = "A mask-like formation with slots for facial features. A red film covers the eyes."
	icon = 'icons/obj/shadowling_clothes.dmi'
	icon_state = "shadowling_mask"
	siemens_coefficient = 0
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	item_flags = ABSTRACT
	flags_cover = MASKCOVERSEYES	//We don't need to cover mouth

/obj/item/clothing/mask/gas/shadowling/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)

/obj/item/clothing/gloves/shadowling
	name = "chitin hands"
	desc = "An electricity-resistant covering of the hands."
	icon = 'icons/obj/shadowling_clothes.dmi'
	icon_state = "shadowling_gloves"
	siemens_coefficient = 0
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	item_flags = ABSTRACT

/obj/item/clothing/gloves/shadowling/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)

/obj/item/clothing/head/shadowling
	name = "chitin helm"
	desc = "A helmet-like enclosure of the head."
	icon = 'icons/obj/shadowling_clothes.dmi'
	icon_state = "shadowling_helmet"
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	item_flags = ABSTRACT
	clothing_flags = STOPSPRESSUREDAMAGE
	flags_cover = HEADCOVERSEYES	//We don't need to cover mouth

/obj/item/clothing/head/shadowling/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)

/obj/item/clothing/glasses/shadowling
	name = "crimson eyes"
	desc = "A shadowling's eyes. Very light-sensitive and can detect body heat through walls."
	icon = 'icons/obj/shadowling_clothes.dmi'
	icon_state = "shadowling_glasses"
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	flash_protect = -1
	vision_flags = SEE_MOBS | SEE_BLACKNESS
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	item_flags = ABSTRACT
	actions_types = list(/datum/action/item_action/toggle_night_vision)
	darkness_view = NIGHTVISION_FOV_RANGE

/obj/item/clothing/glasses/shadowling/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)

/datum/action/item_action/toggle_night_vision // maybe put in in directory to other actions
	name = "Toggle Night Vision"

/obj/item/clothing/glasses/shadowling/ui_action_click(mob/user, datum/action/item_action/actiontype)
	. = ..()
	switch(lighting_alpha)
		if (LIGHTING_PLANE_ALPHA_VISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
			actiontype.button.name = "Toggle Nightvision \[More]"
		if (LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
			actiontype.button.name = "Toggle Nightvision \[Full]"
		if (LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
			actiontype.button.name = "Toggle Nightvision \[OFF]"
		else
			lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
			actiontype.button.name = "Toggle Nightvision \[ON]"
	user.update_sight()
