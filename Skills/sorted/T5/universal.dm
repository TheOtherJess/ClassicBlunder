/obj/Skills/Projectile/Cataclysmic_Orb
	SkillCost=TIER_5_COST
	Copyable=6
	EnergyCost=20
	Speed = 2
	Distance=20
	Blasts=30
	Charge=1
	DamageMult=3
	ComboMaster=1
	Stunner= 3
	Instinct=1
	AccMult=2
	Homing=3
	Explode=1
	ZoneAttackX=8
	ZoneAttackY=8
	IconLock='Plasma.dmi'
	LockX=0
	LockY=0
	Hover=7
	Variation=0
	Cooldown = 150
	ActiveMessage="Kicks up a Barrage of Orbs, creating an inescapable trap!"
	verb/Cataclysmic_Orb()
		set category="Skills"
		usr.UseProjectile(src)

/obj/Skills/Projectile/Desperado_Blaster
	SkillCost = TIER_5_COST
	Copyable = 6
	DamageMult = 6
	Distance = 20
	Explode = 1
	AccMult = 2
	Speed = 1
	Instinct = 1
	Cooldown = 75
	Variation = 0
	IconLock = 'Blast1.dmi'
	LockX = 0
	LockY = 0
	ActiveMessage = "unleashes a relentless barrage with the Desperado Blaster!"

	HeldSkill = TRUE
	InfiniteHold = TRUE
	FireRate = 1

	var/tmp/spin_dir = 0

	OnHeldStart(mob/p)
		spin_dir = p.dir
		p.dir_locked = TRUE
		OMsg(p, "<b>[p] [src.ActiveMessage]</b>")

	OnHeldTick(mob/p)
		var/left_dir  = turn(spin_dir, 45)
		var/right_dir = turn(spin_dir, -45)
		p.Blast(src, p, 0, 'Blast1.dmi', spin_dir)
		p.Blast(src, p, 0, 'Blast1.dmi', left_dir)
		p.Blast(src, p, 0, 'Blast1.dmi', right_dir)
		spin_dir = turn(spin_dir, 45)
		p.dir = spin_dir

	OnHeldRelease(mob/p, benefit, sweet_spot_hit)
		p.dir_locked = FALSE
		src.Cooldown(1, null, p)

	OnHeldFizzle(mob/p)
		p.dir_locked = FALSE

	verb/Desperado_Blaster()
		set category = "Skills"
		usr.BeginHeldSkill(src)
