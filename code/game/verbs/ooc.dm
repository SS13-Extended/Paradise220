GLOBAL_VAR_INIT(normal_ooc_colour, "#275FC5")
GLOBAL_VAR_INIT(member_ooc_colour, "#035417")
GLOBAL_VAR_INIT(mentor_ooc_colour, "#00B0EB")
GLOBAL_VAR_INIT(moderator_ooc_colour, "#184880")
GLOBAL_VAR_INIT(admin_ooc_colour, "#b82e00")

//Checks if the client already has a text input open
/client/proc/checkTyping()
	return (prefs.toggles & PREFTOGGLE_TYPING_ONCE && typing)

/client/verb/ooc(msg = "" as text)
	set name = "OOC"
	set category = "OOC"

	if(!mob)
		return
	if(IsGuestKey(key))
		to_chat(src, "<span class='danger'>Guests may not use OOC.</span>")
		return

	if(!check_rights(R_ADMIN|R_MOD, 0))
		if(!CONFIG_GET(flag/ooc_allowed))
			to_chat(src, "<span class='danger'>OOC is globally muted.</span>")
			return
		if(!CONFIG_GET(flag/dooc_allowed) && (mob.stat == DEAD))
			to_chat(usr, "<span class='danger'>OOC for dead mobs has been turned off.</span>")
			return
		if(prefs.muted & MUTE_OOC)
			to_chat(src, "<span class='danger'>You cannot use OOC (muted).</span>")
			return

	if(!msg)
		msg = typing_input(src.mob, "", "ooc \"text\"")

	msg = trim(sanitize(copytext_char(msg, 1, MAX_MESSAGE_LEN)))
	if(!msg)
		return

	if(!(prefs.toggles & PREFTOGGLE_CHAT_OOC))
		to_chat(src, "<span class='danger'>You have OOC muted.</span>")
		return

	if(!check_rights(R_ADMIN|R_MOD,0))
		if(!CONFIG_GET(flag/ooc_allowed))
			to_chat(src, "<span class='danger'>OOC is globally muted.</span>")
			return
		if(handle_spam_prevention(msg, MUTE_OOC, OOC_COOLDOWN))
			return
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>Advertising other servers is not allowed.</B>")
			log_admin("[key_name_log(src)] has attempted to advertise in OOC: [msg]")
			message_admins("[key_name_admin(src)] has attempted to advertise in OOC: [msg]")
			return

	add_ooc_logs(src, msg)

	var/display_colour = GLOB.normal_ooc_colour
	if(holder && !holder.fakekey)
		display_colour = GLOB.mentor_ooc_colour
		if(check_rights(R_MOD,0) && !check_rights(R_ADMIN,0))
			display_colour = GLOB.moderator_ooc_colour
		else if(check_rights(R_ADMIN,0))
			if(CONFIG_GET(flag/allow_admin_ooccolor))
				display_colour = src.prefs.ooccolor
			else
				display_colour = GLOB.admin_ooc_colour

	if(prefs.unlock_content)
		if(display_colour == GLOB.normal_ooc_colour)
			if((prefs.toggles & PREFTOGGLE_MEMBER_PUBLIC))
				display_colour = GLOB.member_ooc_colour

	for(var/client/C in GLOB.clients)
		if(C.prefs.toggles & PREFTOGGLE_CHAT_OOC)
			var/display_name = key

			if(prefs.unlock_content)
				if(prefs.toggles & PREFTOGGLE_MEMBER_PUBLIC)
					var/icon/byond = icon('icons/member_content.dmi', "blag")
					display_name = "[bicon(byond)][display_name]"

			if(donator_level > 0)
				if((prefs.toggles & PREFTOGGLE_DONATOR_PUBLIC))
					var/icon/donator = icon('icons/ooc_tag_16x.png')
					display_name = "[bicon(donator)][display_name]"

			if(holder)
				if(holder.fakekey)
					if(C.holder && C.holder.rights & R_ADMIN)
						display_name = "[holder.fakekey]/([key])"
					else
						display_name = holder.fakekey

			if(!CONFIG_GET(flag/disable_ooc_emoji))
				msg = "<span class='emoji_enabled'>[msg]</span>"

			to_chat(C, "<font color='[display_colour]'><span class='ooc'><span class='prefix'>OOC:</span> <EM>[display_name]:</EM> <span class='message'>[msg]</span></span></font>")

/proc/toggle_ooc()
	CONFIG_SET(flag/ooc_allowed, !CONFIG_GET(flag/ooc_allowed))
	if(CONFIG_GET(flag/ooc_allowed))
		to_chat(world, "<B>The OOC channel has been globally enabled!</B>")
		log_admin("OOC was toggled on automatically.")
		message_admins("OOC has been toggled on automatically.")
	else
		to_chat(world, "<B>The OOC channel has been globally disabled!</B>")
		log_admin("OOC was toggled off automatically.")
		message_admins("OOC has been toggled off automatically.")

/proc/auto_toggle_ooc(var/on)
	if(CONFIG_GET(flag/auto_toggle_ooc_during_round) && CONFIG_GET(flag/ooc_allowed) != on)
		toggle_ooc()

/client/proc/set_ooc(newColor as color)
	set name = "Set Player OOC Colour"
	set desc = "Modifies the default player OOC color."
	set category = "Server"

	if(!check_rights(R_SERVER))	return

	GLOB.normal_ooc_colour = newColor
	message_admins("[key_name_admin(usr)] has set the default player OOC color to [newColor]")
	log_admin("[key_name_log(usr)] has set the default player OOC color to [newColor]")


	SSblackbox.record_feedback("tally", "admin_verb", 1, "Set Player OOC")

/client/proc/reset_ooc()
	set name = "Reset Player OOC Color"
	set desc = "Returns the default player OOC color to default."
	set category = "Server"

	if(!check_rights(R_SERVER))	return

	GLOB.normal_ooc_colour = initial(GLOB.normal_ooc_colour)
	message_admins("[key_name_admin(usr)] has reset the default player OOC color")
	log_admin("[key_name_log(usr)] has reset the default player OOC color")

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Reset Player OOC")

/client/proc/colorooc()
	set name = "Set Your OOC Color"
	set desc = "Allows you to pick a custom OOC color."
	set category = "Preferences"

	if(!check_rights(R_ADMIN)) return

	var/new_ooccolor = input(src, "Please select your OOC color.", "OOC color", prefs.ooccolor) as color|null
	if(new_ooccolor)
		prefs.ooccolor = new_ooccolor
		prefs.save_preferences(src)
		to_chat(usr, "Your OOC color has been set to [new_ooccolor].")

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Set Own OOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/resetcolorooc()
	set name = "Reset Your OOC Color"
	set desc = "Returns your OOC color to default."
	set category = "Preferences"

	if(!check_rights(R_ADMIN)) return

	prefs.ooccolor = initial(prefs.ooccolor)
	prefs.save_preferences(src)
	to_chat(usr, "Your OOC color has been reset.")

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Reset Own OOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/looc(msg = "" as text)
	set name = "LOOC"
	set desc = "Local OOC, seen only by those in view."
	set category = "OOC"

	if(!mob)
		return
	if(IsGuestKey(key))
		to_chat(src, "<span class='danger'>Guests may not use OOC.</span>")
		return

	if(!check_rights(R_ADMIN|R_MOD,0))
		if(!CONFIG_GET(flag/looc_allowed))
			to_chat(src, "<span class='danger'>LOOC is globally muted.</span>")
			return
		if(!CONFIG_GET(flag/dooc_allowed) && (mob.stat == DEAD))
			to_chat(usr, "<span class='danger'>LOOC for dead mobs has been turned off.</span>")
			return
		if(prefs.muted & MUTE_OOC)
			to_chat(src, "<span class='danger'>You cannot use LOOC (muted).</span>")
			return

	if(!msg)
		msg = typing_input(src.mob, "Local OOC, seen only by those in view.", "looc \"text\"")

	msg = trim(sanitize(copytext_char(msg, 1, MAX_MESSAGE_LEN)))
	if(!msg)
		return

	if(!(prefs.toggles & PREFTOGGLE_CHAT_LOOC))
		to_chat(src, "<span class='danger'>You have LOOC muted.</span>")
		return

	if(!check_rights(R_ADMIN|R_MOD,0))
		if(handle_spam_prevention(msg, MUTE_OOC, OOC_COOLDOWN))
			return
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>Advertising other servers is not allowed.</B>")
			log_admin("[key_name_log(src)] has attempted to advertise in LOOC: [msg]")
			message_admins("[key_name_admin(src)] has attempted to advertise in LOOC: [msg]")
			return

	add_ooc_logs(src, msg, TRUE)

	var/mob/source = mob.get_looc_source()
	var/list/heard = get_mobs_in_view(7, source)

	var/display_name = key
	if(holder && holder.fakekey)
		display_name = holder.fakekey
	if(mob.stat != DEAD)
		display_name = mob.name

	for(var/client/target in GLOB.clients)
		if(target.prefs.toggles & PREFTOGGLE_CHAT_LOOC)
			var/prefix = ""
			var/admin_stuff = ""
			var/send = 0

			if(target in GLOB.admins)
				if(check_rights(R_ADMIN|R_MOD,0,target.mob))
					admin_stuff += "/([key])"
					if(target != src)
						admin_stuff += " ([admin_jump_link(mob)])"

			if(target.mob in heard)
				send = 1
				if(isAI(target.mob))
					prefix = " (Core)"

			else if(isAI(target.mob)) // Special case
				var/mob/living/silicon/ai/A = target.mob
				if(A.eyeobj in hearers(7, source))
					send = 1
					prefix = " (Eye)"

			if(!send && (target in GLOB.admins))
				if(check_rights(R_ADMIN|R_MOD,0,target.mob))
					send = 1
					prefix = "(R)"

			if(send)
				to_chat(target, "<span class='ooc'><span class='looc'>LOOC<span class='prefix'>[prefix]: </span><EM>[display_name][admin_stuff]:</EM> <span class='message'>[msg]</span></span></span>")

/mob/proc/get_looc_source()
	return src

/mob/living/silicon/ai/get_looc_source()
	if(eyeobj)
		return eyeobj
	return src
