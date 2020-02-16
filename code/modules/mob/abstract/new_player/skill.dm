var/global/const
	SKILL_NONE = 0
	SKILL_BASIC = 1
	SKILL_ADEPT = 2
	SKILL_EXPERT = 3

datum/skill/var
    ID = "none" // ID of the skill, used in code
    name = "None" // name of the skill
    desc = "Placeholder skill" // detailed description of the skill
    field = "Misc" // the field under which the skill will be listed
    secondary = 0 // secondary skills only have two levels and cost significantly less

var/global/list/SKILLS = null
var/list/SKILL_RANGER = list(/*"field" = "Engineering", */"unarmed" = SKILL_BASIC, "guns" = SKILL_ADEPT, "sneak" = SKILL_BASIC, "survival" = SKILL_ADEPT)
var/list/SKILL_DOCTOR = list("medicine" = SKILL_ADEPT, "science" = SKILL_BASIC, "repair" = SKILL_ADEPT, "energy" = SKILL_BASIC)
var/list/SKILL_LEGIONARY = list("unarmed" = SKILL_BASIC, "melee" = SKILL_ADEPT, "survival" = SKILL_ADEPT, "guns" = SKILL_BASIC)
var/list/SKILL_MERCHANT = list("speech" = SKILL_ADEPT, "barter" = SKILL_ADEPT, "repair" = SKILL_BASIC, "luck" = SKILL_BASIC)
var/global/list/SKILL_PRE = list("Ranger" = SKILL_RANGER, "Doctor" = SKILL_DOCTOR, "Legionary" = SKILL_LEGIONARY, "Merchant" = SKILL_MERCHANT)

datum/skill/melee
	ID = "melee"
	name = "Melee Weapons"
	desc = "This skill describes your training in melee weapon usage."
	field = "Strength"

datum/skill/energy
	ID = "energy"
	name = "Energy Weapons"
	desc = "This skill describes your expertise with and knowledge of energy weapons such as laser rifles."
	field = "Perception"

datum/skill/lockpick
    ID = "lockpick"
    name = "Lockpick"
    desc = "This skill describes your proficiency at picking mechanical locks."
    field = "Perception"

datum/skill/explosives
	ID = "explosives"
	name = "Explosives"
	desc = "This skill describes your ability to use explosive devices such as grenades and mines."
	field = "Perception"

datum/skill/unarmed
	ID = "unarmed"
	name = "Unarmed"
	desc = "This skill describes your training in unarmed combat techniques."
	field = "Endurance"

datum/skill/survival
	ID = "survival"
	name = "Survival"
	desc = "This skill describes your ability to live off the land, including cooking and crafting natural equipment such as leather armor."
	field = "Endurance"

datum/skill/speech
	ID = "speech"
	name = "Speech"
	desc = "This skill describes your ability to persuade others to your way of thinking through words."
	field = "Charisma"

datum/skill/barter
	ID = "barter"
	name = "Barter"
	desc = "This skill describes your proficiency in trading and haggling, and your ability to strike better deals when doing so."
	field = "Charisma"

datum/skill/repair
    ID = "repair"
    name = "Repair"
    desc = "This skill describes your proficiency in crafting and repairing items, including weapons, armor and ammunition."
    field = "Intelligence"

datum/skill/science
	ID = "science"
	name = "Science"
	desc = "This skill describes your experience and knowledge with scientific methods, processes and equipment."
	field = "Intelligence"

datum/skill/medicine
	ID = "medicine"
	name = "Medicine"
	desc = "This skill describes your experience and knowledge with medicinal tools, equipment, drugs and chems."
	field = "Intelligence"

datum/skill/guns
	ID = "guns"
	name = "Guns"
	desc = "This skill describes your proficiency with ballistic firearms, including pistols and rifles."
	field = "Agility"

datum/skill/sneak
	ID = "sneak"
	name = "Sneak"
	desc = "This skill describes your ability to remain undetected and hide from plain sight."
	field = "Agility"

datum/skill/luck
	ID = "luck"
	name = "Luck"
	desc = "This skill determines your luck. It's up to you to figure out what that means."
	field = "Luck"

datum/attribute/var
	ID = "none"
	name = "None"
	desc = "This is a placeholder"


proc/setup_skills()
	if(SKILLS == null)
		SKILLS = list()
		for(var/T in (typesof(/datum/skill)-/datum/skill))
			var/datum/skill/S = new T
			if(S.ID != "none")
				if(!SKILLS.Find(S.field))
					SKILLS[S.field] = list()
				var/list/L = SKILLS[S.field]
				L += S


mob/living/carbon/human/proc/GetSkillClass(points)
	return CalculateSkillClass(points, age)

proc/show_skill_window(var/mob/user, var/mob/living/carbon/human/M)
	if(!istype(M)) return
	if(SKILLS == null)
		setup_skills()

	if(!M.skills || M.skills.len == 0)
		to_chat(user, "There are no skills to display.")
		return

	var/HTML = "<body>"
	HTML += "<b>Select your Skills</b><br>"
	HTML += "Current skill level: <b>[M.GetSkillClass(M.used_skillpoints)]</b> ([M.used_skillpoints])<br>"
	HTML += "<table>"
	for(var/V in SKILLS)
		HTML += "<tr><th colspan = 5><b>[V]</b>"
		HTML += "</th></tr>"
		for(var/datum/skill/S in SKILLS[V])
			var/level = M.skills[S.ID]
			HTML += "<tr style='text-align:left;'>"
			HTML += "<th>[S.name]</th>"
			HTML += "<th><font color=[(level == SKILL_NONE) ? "red" : "black"]>\[Low\]</font></th>"
			// secondary skills don't have an amateur level
			if(S.secondary)
				HTML += "<th></th>"
			else
				HTML += "<th><font color=[(level == SKILL_BASIC) ? "red" : "black"]>\[Medium\]</font></th>"
			HTML += "<th><font color=[(level == SKILL_ADEPT) ? "red" : "black"]>\[High\]</font></th>"
			HTML += "<th><font color=[(level == SKILL_EXPERT) ? "red" : "black"]>\[Extreme\]</font></th>"
			HTML += "</tr>"
	HTML += "</table>"

	user << browse(null, "window=preferences")
	user << browse(HTML, "window=show_skills;size=600x800")
	return

mob/living/carbon/human/verb/show_skills()
	set category = "IC"
	set name = "Show Own Skills"

	show_skill_window(src, src)
