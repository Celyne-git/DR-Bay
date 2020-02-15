/obj/item/robot_parts/attack(mob/living/carbon/human/M as mob, mob/living/carbon/user as mob)
	var/limbloc = null

	if(!istype(M))
		return ..()

	if(!((locate(/obj/machinery/optable, M.loc) && M.resting) || (locate(/obj/structure/bed/roller, M.loc) && (M.buckled || M.lying || M.weakened || M.stunned || M.paralysis || M.sleeping || M.stat)) && prob(75) || (locate(/obj/structure/table/, M.loc) && (M.lying || M.weakened || M.stunned || M.paralysis || M.sleeping || M.stat) && prob(66))))
		return ..()

	if(!istype(M, /mob/living/carbon/human))
		return ..()

	if((user.zone_sel.selecting == BP_L_ARM) && (istype(src, /obj/item/robot_parts/l_arm)))
		limbloc = BP_L_HAND
	else if((user.zone_sel.selecting == BP_R_ARM) && (istype(src, /obj/item/robot_parts/r_arm)))
		limbloc = BP_R_HAND
	else if((user.zone_sel.selecting == BP_R_LEG) && (istype(src, /obj/item/robot_parts/r_leg)))
		limbloc = BP_R_FOOT
	else if((user.zone_sel.selecting == BP_L_LEG) && (istype(src, /obj/item/robot_parts/l_leg)))
		limbloc = BP_L_FOOT
	else
		to_chat(user, "<span class='warning'>That doesn't fit there!</span>")
		return ..()

	var/mob/living/carbon/human/H = M
	var/datum/organ/external/S = H.organs[user.zone_sel.selecting]
	if(S.status & ORGAN_DESTROYED)
		if(!(S.status & ORGAN_ATTACHABLE))
			to_chat(user, "<span class='warning'>The wound is not ready for a replacement!</span>")
			return 0
		if(M != user)
			M.visible_message( \
				"<span class='notice'>\The [user] is beginning to attach \the [src] where [H]'s [S.display_name] used to be.</span>", \
				"<span class='notice'>\The [user] begins to attach \the [src] where your [S.display_name] used to be.</span>")
		else
			M.visible_message( \
				"<span class='notice'>\The [user] begins to attach a robotic limb where \his [S.display_name] used to be with [src].</span>", \
				"<span class='notice'>You begin to attach \the [src] where your [S.display_name] used to be.</span>")

		if(do_mob(user, H, 100))
			if(M != user)
				M.visible_message( \
					"<span class='notice'>\The [user] finishes attaching [H]'s new [S.display_name].</span>", \
					"<span class='notice'>\The [user] finishes attaching your new [S.display_name].</span>")
			else
				M.visible_message( \
					"<span class='notice'>\The [user] finishes attaching \his new [S.display_name].</span>", \
					"<span class='notice'>You finish attaching your new [S.display_name].</span>")

			if(H == user && prob(25))
				to_chat(user, "<span class='warning'>You mess up!</span>")
				S.take_damage(15)

			S.status &= ~ORGAN_BROKEN
			S.status &= ~ORGAN_SPLINTED
			S.status &= ~ORGAN_ATTACHABLE
			S.status &= ~ORGAN_DESTROYED
			S.status |= ORGAN_ROBOT
			var/datum/organ/external/T = H.organs["[limbloc]"]
			T.status &= ~ORGAN_BROKEN
			T.status &= ~ORGAN_SPLINTED
			T.status &= ~ORGAN_ATTACHABLE
			T.status &= ~ORGAN_DESTROYED
			T.status |= ORGAN_ROBOT
			H.update_body()
			M.updatehealth()
			M.UpdateDamageIcon()
			qdel(src)

			return 1
		return 0