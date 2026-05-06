// Check Items.dm and sift through the spaghetti to find how this item is equipped and unequipped via the Equip proc and the ObjectUse proc
// (I fucking hate this shit dude)
#define BASE_MAX_CHARGES 2 // How many charges we start out with

/obj/Items/Flask
    Unwieldy = 1 // Should prevent people from using this outside of meditate
    icon = 'Icons/enchantment/Magic Potion.dmi'
    // 0 means they will not trigger if statements 
    // 1 means they will 
    // Basic Healing effects
    var/Heal=0
    var/Energy=0  
    var/Mana=0
    // Damaging effects
    var/Toxic=0
    // Passive Effects
    var/Hallucinogen=0 // Anger Buffs
    var/Searing=0 // Damage Buffs
    var/Flowy=0 // Flow Buffs
    var/Hard=0 // Tank Buffs
    // Misc stuff
    var/Tier = 0 // This will be used to upgrade your flask
    var/DrinkMessage
    var/OffMessage
    var/Slots=2 // How many Herbs/Buffs a charge holds
    var/Charges = 0 // How many uses you have in your flask before you need to meditate again 
    // Charge refilling is handled in Gains.dm, line 237
    // Below is The Buff We Pass This Shit To and spends charges
    Techniques = list("/obj/Skills/Buffs/SlotlessBuffs/Autonomous/Flask_Charge")
        
// This is the thing the players actually interact with, it also can be accessed in all the important ways
/mob/var/obj/Items/Flask/equippedFlask 

// What actually handles the Potion Buff and Hopefully works?
/obj/Skills/Buffs/SlotlessBuffs/Autonomous/Flask_Charge
    var/CD = 300 // Base Cooldown of 5 mins
    MagicNeeded=1
    ActiveMessage="quaffs a mysterious potion!"
    TextColor=rgb(0, 153, 255)
    AlwaysOn=1
    Cooldown=1
    adjust(mob/P)
        // I am so fucking sorry for what is about to happen
        if(P.equippedFlask == 1) // if you chose a  herb, your value for said herb should be 1 and ONLY 1
            InstantAffect=1
            StableHeal=1
            //Check glob.dm for POTIONHEAL 
            src.HealthHeal = glob.POTIONHEAL/2*(P.equippedFlask.Tier+1)  // 2.5, 5, 7.5 if POTIONHEAL is stil 5
            src.ManaHeal -= glob.POTIONHEAL*5-(P.equippedFlask.Tier) // 25 Mana if POTIONHEAL is 5 
            src.EnergyHeal -= glob.POTIONHEAL*2-(P.equippedFlask.Tier)// Same as above but you lose 10 energy, since it's easy to recharge
        if(P.equippedFlask.Mana == 1) // same rule, ONLY THE VALUE OF 1 SHOULD BE HERE
            InstantAffect=1
            src.ManaHeal = glob.POTIONHEAL*5*(P.equippedFlask.Tier+1) // 25 50 75 mana regen based on tier provided potion heal is the same 
            src.EnergyHeal -= glob.POTIONHEAL*2-(P.equippedFlask.Tier)
        if(P.equippedFlask.Energy == 1) // Same as above
            InstantAffect=1
            src.EnergyHeal = glob.POTIONHEAL*(2+P.equippedFlask.Tier) // 15, 20, 25 energy 
            src.ManaHeal -= glob.POTIONHEAL*5-(P.equippedFlask.Tier) // 25 Mana if POTIONHEAL is 5 
        if(P.equippedFlask.Hallucinogen == 1) // This gives you immediate anger and anger buffs at expense of defense
            AutoAnger=1 // Makes you angry instantly
            // Please note: the comments will tell you what the math does   
            AngerMult = 1 + ((P.equippedFlask.Tier+1)/3) // T0 = +33%, T1 = +66%  T2 = +100% anger multiplier
            EndMult = 0.7 + ((P.equippedFlask.Tier+1)/10) // T0 = 0.8, T1 = 0.9, T3 = 1 endurance mult 
            DefMult = 0.7 + ((P.equippedFlask.Tier+1)/10) // T0 = 0.8, T1 = 0.9, T3 = 1 endurance mult 
            passives["PureReduction"] = -4 + (P.equippedFlask.Tier+1) // T0 = 3, T1 = -2 T2 = -1, PS: -1 PureReduction = 10% extra damage taken,
            passives["AngerAdaptiveForce"] = ((P.equippedFlask.Tier+1)/10) // T0 0.1 AAF, T1 0.2, T2 0.3 PS: 0.1 AAF = 10% increase of strongest dmg stat
        if(P.equippedFlask.Hallucinogen)

    verb/Imbibe_Flask(mob/P) // We cosnume a charge from the flask!
        set category = "Skills"
        P.reduceCharge() // mob proc that is detched
        if(P.equippedFlask.Charges == 0) return // If we have no charges, this will return 0, which means false, which means get out
        if(!usr.BuffOn(src)) // Activate the buff
            adjust(usr)
        src.Trigger(usr)



mob/proc/reduceCharge(mob/P) // this has given me a serious headache 
    if(equippedFlask.Charges == 0) // Empty 
        src << "You have no Flask Charges left!"
        return
    else if(equippedFlask.Charges > 3 || equippedFlask.Charges < 0) // Why do you have more than 3? Max flask tier is 2
        src << "ERROR: Your number of Flask Charges is [equippedFlask.Charges], this shouldn't be possible. Contact staff."
        liveDebugMsg("[P] has [equippedFlask.Charges] Flask Charges. This shouldn't be possible.") // I'll thank myself later when someone inevitably exploits flasks.
        return
    --equippedFlask.Charges
        

mob/proc/GetMaxCharges(mob/P)
    return BASE_MAX_CHARGES + equippedFlask.Tier
    