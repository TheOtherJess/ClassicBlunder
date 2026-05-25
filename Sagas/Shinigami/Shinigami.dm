mob/proc/gainShinigami()
	src << "You feel the touch of death upon your soul... you have become a <b>Shinigami</b>."
	src.Saga = "Shinigami"
	src.SagaLevel = 1

	var/list/Releases = list("Zangetsu", "Senbonzakura", "Shirayuki", "Hozukimaru", "Nozarashi")
	src.ShinigamiRelease = input("Which Release does [src] receive?", "Zanpakutō Release") in Releases

	src.ZanpakutoClass = input(src, "What form does your Zanpakutō take?", "Zanpakutō Class") in list("Light", "Medium", "Heavy")

	src.ShihakushoClass = input(src, "What weight is your Shihakushō?", "Shihakushō Class") in list("Light", "Medium", "Heavy")

	if(src.ShinigamiRelease != "Nozarashi")
		src.AsauchiName = input(src, "What is the name of your Asauchi?", "Asauchi Name") as text
		src.ShikaiCall = input(src, "What is your call before their name? (for example, \"Scatter\")", "Shikai Call") as text
	else
		src.AsauchiName = "???"

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

	if(src.ShinigamiRelease == "Nozarashi")
		src << "A <b>[src.ZanpakutoClass]</b> Zanpakutō and <b>[src.ShihakushoClass]</b> Shihakushō have found their way into your possession, somehow."
	else
		src << "A <b>[src.ZanpakutoClass]</b> Zanpakutō and <b>[src.ShihakushoClass]</b> Shihakushō have formed for you, serving as an extension of your soul."
	src << "Use <b>Shinigami Form</b> to don your Zanpakutō and Shihakushō."


mob/tierUpSaga(Path)
	..()
	if(Path == "Shinigami")
		switch(SagaLevel)
			if(2)
				switch(ShinigamiRelease)
					if("Nozarashi")
						src << "The name of your Asauchi continues to elude you... but you feel like you don't need it anyway."
						src.AddSkill(new/obj/Skills/Buffs/SlotlessBuffs/Unleash_Spiritual_Pressure)
					else
						src << "The spirit within your Zanpakutō stirs... <b>Shikai</b> is within your grasp."
						switch(ShinigamiRelease)
							if("Zangetsu")
								src.AddSkill(new/obj/Skills/Buffs/SlotlessBuffs/Zangetsu)
							if("Senbonzakura")
								src.AddSkill(new/obj/Skills/Buffs/SlotlessBuffs/Senbonzakura)
							if("Shirayuki")
								src.AddSkill(new/obj/Skills/Buffs/SlotlessBuffs/Zanpakuto/Shikai/SodenoShirayuki)
								src.AddSkill(new/obj/Skills/AutoHit/Tsukishiro)
								src.AddSkill(new/obj/Skills/AutoHit/Hakuren)
							if("Hozukimaru")
								src.AddSkill(new/obj/Skills/Buffs/SlotlessBuffs/Hozukimaru)
				updateShinigamiAscended()

			if(3)
				switch(ShinigamiRelease)
					if("Nozarashi")
						src.AddSkill(new/obj/Skills/Queue/Two_Hands)
						src << "You remembered that you can use <b>Two Hands</b> to swing your sword even harder."
					else
						src << "You have mastered your Shikai. Its drain fades..."
						switch(ShinigamiRelease)
							if("Senbonzakura")
								if(!locate(/obj/Skills/SenbonzakuraPetalWall, src))
									src.AddSkill(new/obj/Skills/SenbonzakuraPetalWall)
									src << "Your control over your petals sharpens. You can now use <b>Petal Wall</b>."
							if("Shirayuki")
								src.AddSkill(new/obj/Skills/Buffs/ActiveBuffs/Shirafune)
								src<<"You learn <i>San no mai, Shirafune!</i>"
				updateShinigamiAscended()

			if(4)
				switch(ShinigamiRelease)
					if("Nozarashi")
						src << "The spirit within your Zanpakutō finally speaks its name..."
						src.AsauchiName = input(src, "What is the name of your Asauchi?", "Asauchi Name") as text
						src.ShikaiCall = input(src, "What is your call before their name? (for example, \"Cut\", \"Devour\")", "Shikai Call") as text
						for(var/obj/Items/i in src)
							if(i.IsZanpakuto)
								i.name = "Zanpakutō ([src.AsauchiName])"
						src.AddSkill(new/obj/Skills/Buffs/SlotlessBuffs/Nozarashi)
						src.AddSkill(new/obj/Skills/AutoHit/Leap_Attack)
					else
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
							if("Shirayuki")
								src.BankaiPrefix = input(src, "Your Bankai takes shape. What is your Zanpakutō's true name?", "Bankai Prefix") as text
								src.AddSkill(new/obj/Skills/Buffs/SlotlessBuffs/Zanpakuto/Bankai/HakkanoTogame)
							if("Hozukimaru")
								src.BankaiPrefix = input(src, "Your Bankai takes shape. What prefix precedes your Zanpakutō's name?", "Bankai Prefix") as text
								src.AddSkill(new/obj/Skills/Buffs/SlotlessBuffs/Ryumon_Hozukimaru)
				updateShinigamiAscended()

			if(5)
				if(ShinigamiRelease == "Nozarashi")
					src << "You have mastered your Shikai. Its drain fades..."
				else
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
				switch(ShinigamiRelease)
					if("Nozarashi")
						src << "The full power of your soul erupts. <b>Bankai</b> is yours."
						src.BankaiPrefix = input(src, "Your Bankai takes shape. What prefix precedes your Zanpakutō's name?", "Bankai Prefix") as text
						src.AddSkill(new/obj/Skills/Buffs/SlotlessBuffs/Nozarashi_Bankai)
					else
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
				if(ShinigamiRelease == "Nozarashi")
					src << "Your body can finally withstand your Bankai's power."
				switch(ShinigamiRelease)
					if("Zangetsu")
						for(var/obj/Skills/Buffs/SlotlessBuffs/Mugetsu_Aftermath/MA in src)
							if(MA.SlotlessOn)
								MA.Trigger(src)
							del MA
						src.StrCut = 0
						src.EndCut = 0
						src.ForCut = 0
						src.ManaCut = 0
						src.EnergyCut = 0
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
