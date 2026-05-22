mob/proc/gainShinigami()
	src << "You feel the touch of death upon your soul... you have become a <b>Shinigami</b>."
	src.Saga = "Shinigami"
	src.SagaLevel = 1

	var/list/Releases = list("Zangetsu", "Senbonzakura")
	src.ShinigamiRelease = input("Which Release does [src] receive?", "Zanpakutō Release") in Releases

	src.ZanpakutoClass = input(src, "What form does your Zanpakutō take?", "Zanpakutō Class") in list("Light", "Medium", "Heavy")

	src.ShihakushoClass = input(src, "What weight is your Shihakushō?", "Shihakushō Class") in list("Light", "Medium", "Heavy")

	src.AsauchiName = input(src, "What is the name of your Asauchi?", "Asauchi Name") as text

	src.ShikaiCall = input(src, "What is your call before their name? (for example, \"Scatter\")", "Shikai Call") as text

	var/obj/Items/Sword/Medium/Legendary/Shinigami/Zanpakuto/z = new(src)
	z.Class = src.ZanpakutoClass
	z.setStatLine()
	z.name = "Zanpakutō ([src.AsauchiName])"
	z.Ascended = min(1 + src.SagaLevel, 6)

	var/obj/Items/Armor/sh
	switch(src.ShihakushoClass)
		if("Light")
			sh = new/obj/Items/Armor/Mobile_Armor/Shinigami_Shihakusho(src)
		if("Medium")
			sh = new/obj/Items/Armor/Balanced_Armor/Shinigami_Shihakusho(src)
		if("Heavy")
			sh = new/obj/Items/Armor/Plated_Armor/Shinigami_Shihakusho(src)
	sh.Ascended = min(1 + src.SagaLevel, 6)

	src.AddSkill(new/obj/Skills/Buffs/SlotlessBuffs/Shinigami_Form)
	src.AddSkill(new/obj/Skills/Buffs/NuStyle/SwordStyle/Zanjutsu)

	src << "A <b>[src.ZanpakutoClass]</b> Zanpakutō and Shihakushō have formed for you. Name them, learn them, for they are an extension of your soul."
	src << "Use <b>Shinigami Form</b> to don your Zanpakutō and Shihakushō."


mob/tierUpSaga(Path)
	..()
	if(Path == "Shinigami")
		switch(SagaLevel)
			if(2)
				src << "The spirit within your Zanpakutō stirs... <b>Shikai</b> is within your grasp."
				switch(ShinigamiRelease)
					if("Zangetsu")
						src.AddSkill(new/obj/Skills/Buffs/SlotlessBuffs/Zangetsu)
<<<<<<< HEAD
					if("Senbonzakura")
						src.AddSkill(new/obj/Skills/Buffs/SlotlessBuffs/Senbonzakura)
=======
					if("Shirayuki")
						src.AddSkill(new/obj/Skills/Buffs/SlotlessBuffs/Zanpakuto/Shikai/SodenoShirayuki)
						src.AddSkill(new/obj/Skills/AutoHit/Tsukishiro)
						src.AddSkill(new/obj/Skills/AutoHit/Hakuren)
>>>>>>> a51b60950e1056cf7a83767e3a74ccaa8057455b
				updateShinigamiAscended()

			if(3)
				src << "You have mastered your Shikai. Its drain fades..."
				switch(ShinigamiRelease)
<<<<<<< HEAD
					if("Senbonzakura")
						if(!locate(/obj/Skills/SenbonzakuraPetalWall, src))
							src.AddSkill(new/obj/Skills/SenbonzakuraPetalWall)
							src << "Your control over your petals sharpens. You can now use <b>Petal Wall</b>."
=======
					if("Shirayuki")
						src.AddSkill(new/obj/Skills/Buffs/Shirafune)
						src<<"You learn <i>San no mai, Shirafune!</i>"
>>>>>>> a51b60950e1056cf7a83767e3a74ccaa8057455b
				updateShinigamiAscended()

			if(4)
				src << "The full power of your soul erupts, <b>Bankai</b> is yours."
				switch(ShinigamiRelease)
					if("Zangetsu")
						src.BankaiPrefix = input(src, "Your Bankai takes shape. What prefix precedes your Zanpakutō's name?", "Bankai Prefix") as text
						src.AddSkill(new/obj/Skills/Buffs/SlotlessBuffs/Tensa_Zangetsu)
					if("Senbonzakura")
						src.BankaiPrefix = input(src, "Your Bankai takes shape. What suffix comes after your Zanpakutō's name?", "Bankai Suffix") as text
						src.AddSkill(new/obj/Skills/Buffs/SlotlessBuffs/Senbonzakura_Kageyoshi)
						if(!locate(/obj/Skills/SenbonzakuraGoukei, src))
							src.AddSkill(new/obj/Skills/SenbonzakuraGoukei)
							src << "The petals converge at your will. You can now use <b>Goukei</b>."
				updateShinigamiAscended()

			if(5)
				src << "You have mastered your Bankai. Its drain fades..."
				src.passive_handler.Increase("GodKi", 0.15)
				switch(ShinigamiRelease)
					if("Zangetsu")
						if(!locate(/obj/Skills/Buffs/SpecialBuffs/Sword/Getsuga_Tenshou_Clad, src))
							src.AddSkill(new/obj/Skills/Buffs/SpecialBuffs/Sword/Getsuga_Tenshou_Clad)
							src << "The black-clad Getsuga surges through your blade, you can now use <b>Getsuga Tenshou Clad</b>."
					if("Senbonzakura")
						if(!locate(/obj/Skills/SenbonzakuraSenkei, src))
							src.AddSkill(new/obj/Skills/SenbonzakuraSenkei)
							src << "Your petals can arrange themselves into swords of light. You can now use <b>Senkei</b>."
				updateShinigamiAscended()

			if(6)
				src.passive_handler.Increase("GodKi", 0.1)
				switch(ShinigamiRelease)
					if("Zangetsu")
						if(!locate(/obj/Skills/Buffs/SpecialBuffs/Sword/Final_Getsuga_Tenshou, src))
							src.AddSkill(new/obj/Skills/Buffs/SpecialBuffs/Sword/Final_Getsuga_Tenshou)
						src << "The depths of your soul reveal the <b>Final Getsuga Tenshou</b>. Using it will cost you everything... but it may open a new path."
					if("Senbonzakura")
						if(!src.FindSkill(/obj/Skills/Buffs/SlotlessBuffs/Senbonzakura_Hakuteiken))
							src.AddSkill(new/obj/Skills/Buffs/SlotlessBuffs/Senbonzakura_Hakuteiken)
							src << "The ultimate form of your blade awakens. You can now use <b>Shukei: Hakuteiken</b>."
				updateShinigamiAscended()

			if(7)
				src.passive_handler.Increase("GodKi", 0.25)
				for(var/obj/Skills/Buffs/SlotlessBuffs/Mugetsu_Aftermath/MA in src)
					if(MA.SlotlessOn)
						MA.Trigger(src)
					del MA
				src.StrCut = 0
				src.EndCut = 0
				src.ForCut = 0
				src.ManaCut = 0
				src.EnergyCut = 0
				switch(ShinigamiRelease)
					if("Zangetsu")
						if(!locate(/obj/Skills/Projectile/Getsuga_Jujisho, src))
							src.AddSkill(new/obj/Skills/Projectile/Getsuga_Jujisho)
						if(!locate(/obj/Skills/Projectile/True_Getsuga_Tenshou, src))
							src.AddSkill(new/obj/Skills/Projectile/True_Getsuga_Tenshou)
						src << "Your sacrifice was not in vain. Your power returns - greater, and free. You can now use <b>Getsuga Jujisho</b> and <b>True Getsuga Tenshou</b>."
					if("Senbonzakura")
						if(!locate(/obj/Skills/SenbonzakuraIkkaSenjinka, src))
							src.AddSkill(new/obj/Skills/SenbonzakuraIkkaSenjinka)
							src << "Every one of your Senkei blades can answers your call at once. You can now use <b>Ikka Senjinka</b>."
				updateShinigamiAscended()

mob/proc/InShikai()
	for(var/sb in SlotlessBuffs)
		var/obj/Skills/Buffs/SlotlessBuffs/b = SlotlessBuffs[sb]
		if(b && b.IsShikaiForm && b.SlotlessOn)
			return TRUE
	return FALSE

mob/proc/InBankai()
	for(var/sb in SlotlessBuffs)
		var/obj/Skills/Buffs/SlotlessBuffs/b = SlotlessBuffs[sb]
		if(b && b.IsBankaiForm && b.SlotlessOn)
			return TRUE
	return FALSE

mob/proc/updateShinigamiAscended()
	var/newAsc = min(1 + SagaLevel, 6)
	for(var/obj/Items/i in src)
		if(i.IsZanpakuto || i.IsShihakusho)
			i.Ascended = newAsc
