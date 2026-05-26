proc/getHadoSpells()
	return list(
		list("name"="Hadō #1: Shō",
		     "path"="/obj/Skills/Projectile/Hado/Sho",
		     "tier"=1, "requires"=null),
		list("name"="Hadō #4: Byakurai",
		     "path"="/obj/Skills/Projectile/Hado/Byakurai",
		     "tier"=1, "requires"=null),
		list("name"="Hadō #11: Tsuzuri Raiden",
		     "path"="/obj/Skills/Buffs/ActiveBuffs/Hado/Tsuzuri_Raiden",
		     "tier"=1, "requires"=null),
		list("name"="Hadō #31: Shakkahou",
		     "path"="/obj/Skills/Projectile/Hado/Shakkahou",
		     "tier"=2, "requires"=null),
		list("name"="Hadō #32: Ōkasen",
		     "path"="/obj/Skills/Projectile/Hado/Oukasen",
		     "tier"=2, "requires"=null),
		list("name"="Hadō #33: Sōkatsui",
		     "path"="/obj/Skills/Projectile/Hado/Soukatsui",
		     "tier"=2, "requires"=null),
		list("name"="Hadō #54: Haien",
		     "path"="/obj/Skills/Projectile/Hado/Haien",
		     "tier"=3, "requires"=null),
		list("name"="Hadō #58: Tenran",
		     "path"="/obj/Skills/Projectile/Hado/Tenran",
		     "tier"=3, "requires"=null),
		list("name"="Hadō #63: Raikōhō",
		     "path"="/obj/Skills/AutoHit/Hado/Raikouhou",
		     "tier"=4, "requires"=null),
		list("name"="Hadō #73: Sōren Sōkatsui",
		     "path"="/obj/Skills/Projectile/Hado/Souren_Soukatsui",
		     "tier"=4,
		     "requires"="/obj/Skills/Projectile/Hado/Soukatsui"),
		list("name"="Hadō #78: Zangerin",
		     "path"="/obj/Skills/AutoHit/Hado/Zangerin",
		     "tier"=4, "requires"=null),
		list("name"="Hadō #88: Hiryū Gekizoku Shinten Raihō",
		     "path"="/obj/Skills/Projectile/Hado/Hiryu",
		     "tier"=5, "requires"=null),
		list("name"="Hadō #91: Senju Kōten Taihō",
		     "path"="/obj/Skills/Projectile/Hado/Senju_Kouten_Taihou",
		     "tier"=5, "requires"=null),
		list("name"="Hadō #96: Ittō Kasō",
		     "path"="/obj/Skills/AutoHit/Hado/Itto_Kaso",
		     "tier"=5, "requires"=null)
	)

// Returns which pick slot is currently available for this user and the associated tier cap.
// Slots are consumed in ascending order (SL1 before SL3, etc.).
proc/getKidoPickSlot(mob/User)
	if(User.SagaLevel >= 1 && User.KidoSL1Picks < 2)
		return list("tierCap"=1, "slot"="KidoSL1Picks")
	if(User.SagaLevel >= 3 && User.KidoSL3Picks < 2)
		return list("tierCap"=2, "slot"="KidoSL3Picks")
	if(User.SagaLevel >= 5 && User.KidoSL5Picks < 1)
		return list("tierCap"=3, "slot"="KidoSL5Picks")
	if(User.SagaLevel >= 6 && User.KidoSL6Picks < 1)
		return list("tierCap"=4, "slot"="KidoSL6Picks")
	if(User.SagaLevel >= 7 && User.KidoSL7Picks < 1)
		return list("tierCap"=5, "slot"="KidoSL7Picks")
	return null

// How many picks remain in the current slot after a pick is spent.
proc/getKidoPicksRemaining(mob/User)
	if(User.SagaLevel >= 1 && User.KidoSL1Picks < 2)
		return 2 - User.KidoSL1Picks - 1
	if(User.SagaLevel >= 3 && User.KidoSL3Picks < 2)
		return 2 - User.KidoSL3Picks - 1
	return 0

/obj/Skills/Buffs/SlotlessBuffs/Shinigami_Form
	verb/Learn_Hado()
		set name = "Learn Hado"
		set category = "Shinigami"
		var/mob/User = usr
		if(User.Saga != "Shinigami")
			return

		var/list/pickSlot = getKidoPickSlot(User)
		if(!pickSlot)
			User << "You have no Hadō selections available."
			return

		var/tierCap = pickSlot["tierCap"]

		var/list/options = list()
		for(var/list/spell in getHadoSpells())
			if(spell["tier"] > tierCap) continue
			var/path = text2path(spell["path"])
			if(!path) continue
			if(locate(path, User)) continue
			if(spell["requires"])
				var/reqPath = text2path(spell["requires"])
				if(!locate(reqPath, User)) continue
			options[spell["name"]] = path

		if(!options.len)
			User << "You have already learned all eligible Hadō (Tier [tierCap] or lower)."
			return

		var/choice = input(User, "Select a Hadō spell to learn. (Tier [tierCap] cap)", "Learn Hadō") as null|anything in options
		if(!choice) return

		var/chosenPath = options[choice]
		User.AddSkill(new chosenPath)
		User << "You learn <b>[choice]</b>!"

		var/slot = pickSlot["slot"]
		switch(slot)
			if("KidoSL1Picks") User.KidoSL1Picks++
			if("KidoSL3Picks") User.KidoSL3Picks++
			if("KidoSL5Picks") User.KidoSL5Picks++
			if("KidoSL6Picks") User.KidoSL6Picks++
			if("KidoSL7Picks") User.KidoSL7Picks++

		var/remaining = 0
		switch(slot)
			if("KidoSL1Picks") remaining = 2 - User.KidoSL1Picks
			if("KidoSL3Picks") remaining = 2 - User.KidoSL3Picks
		if(remaining > 0)
			User << "You have [remaining] Hadō selection\s remaining."

	verb/Learn_Bakudo()
		set name = "Learn Bakudo"
		set category = "Shinigami"
		usr << "Bakudō instruction is not yet available."

	verb/Learn_Hoho()
		set name = "Learn Hoho"
		set category = "Shinigami"
		usr << "Hohō instruction is not yet available."

	verb/Learn_Hakuda()
		set name = "Learn Hakuda"
		set category = "Shinigami"
		usr << "Hakuda instruction is not yet available."
