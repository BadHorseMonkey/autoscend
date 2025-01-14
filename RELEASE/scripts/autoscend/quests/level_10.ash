boolean L10_plantThatBean()
{
	if(internalQuestStatus("questL10Garbage") != 0)
	{
		return false;
	}

	auto_log_info("Planting me magic bean!", "blue");
	string page = visit_url("place.php?whichplace=plains");
	if(contains_text(page, "place.php?whichplace=beanstalk"))
	{
		auto_log_warning("I see the beanstalk has already been planted. fixing questL10Garbage to step1", "blue");
		set_property("questL10Garbage", "step1");
		return true;
	}
	if (item_amount($item[Enchanted Bean]) > 0)
	{
		visit_url("place.php?whichplace=plains&action=garbage_grounds");
		return true;
	}
	else
	{
		// make sure we can get an enchanted bean to open the beanstalk with if we can't open it.
		if (L4_batCave())
		{
			return true;
		}
		else
		{
			auto_log_info("I don't have a magic bean! Travesty!!", "blue");
			return autoAdv($location[The Beanbat Chamber]);
		}
	}
	return false;
}

boolean L10_airship()
{
	if (internalQuestStatus("questL10Garbage") < 1 || internalQuestStatus("questL10Garbage") > 6)
	{
		return false;
	}
	if(my_turncount() == get_property("_LAR_skipNC178").to_int())
	{
		auto_log_info("In LAR path NC178 is forced to reoccur if we skip it. Go do something else.");
		return false;
	}

	auto_log_info("Fantasy Airship Fly Fly time", "blue");
	if((my_mp() > 60) || considerGrimstoneGolem(true))
	{
		handleBjornify($familiar[Grimstone Golem]);
	}

	if(item_amount($item[Model Airship]) == 0)
	{
		set_property("choiceAdventure182", "4"); // Random Lack of an Encounter: Get Model Airship
	}
	else
	{
		set_property("choiceAdventure182", "1"); // Random Lack of an Encounter: Fight!
	}

	if((my_daycount() == 1) && (get_property("_hipsterAdv").to_int() < 7) && is_unrestricted($familiar[Artistic Goth Kid]) && auto_have_familiar($familiar[Artistic Goth Kid]))
	{
		auto_log_info("Hipster Adv: " + get_property("_hipsterAdv"), "blue");
		handleFamiliar($familiar[Artistic Goth Kid]);
	}

	if($location[The Penultimate Fantasy Airship].turns_spent < 10)
	{
		bat_formBats();
	}

	if (isActuallyEd() && $location[The Penultimate Fantasy Airship].turns_spent < 1)	
	{	
		// temp workaround for mafia bug.	
		// see https://kolmafia.us/showthread.php?24767-Quest-tracking-preferences-change-request(s)&p=156733&viewfull=1#post156733
		// still not fixed as of r19986
		visit_url("place.php?whichplace=beanstalk");	
	}

	if (handleFamiliar($familiar[Red-Nosed Snapper])) {
		auto_changeSnapperPhylum($phylum[dude]);
	}
	autoAdv($location[The Penultimate Fantasy Airship]);
	return true;
}

boolean L10_basement()
{
	if (internalQuestStatus("questL10Garbage") != 7)
	{
		return false;
	}

	if (possessEquipment($item[Titanium Assault Umbrella]) && !auto_can_equip($item[Titanium Assault Umbrella]))
	{
		return false;
	}

	if (possessEquipment($item[Amulet of Extreme Plot Significance]) && !auto_can_equip($item[Amulet of Extreme Plot Significance]))
	{
		return false;
	}

	auto_log_info("Basement Search", "blue");
	set_property("choiceAdventure670", "5"); // You Don't Mess Around with Gym: Open Ground floor (with amulet)
	if(item_amount($item[Massive Dumbbell]) > 0)
	{
		set_property("choiceAdventure671", "1"); // Out in the Open Source: Open Ground floor
	}
	else
	{
		set_property("choiceAdventure671", "4"); // Out in the Open Source: Go to Fitness Choice
	}

	if(my_primestat() == $stat[Muscle])
	{
		buyUpTo(1, $item[Ben-Gal&trade; Balm]);
		buffMaintain($effect[Go Get \'Em\, Tiger!], 0, 1, 1);
	}
	buyUpTo(1, $item[Hair Spray]);
	buffMaintain($effect[Butt-Rock Hair], 0, 1, 1);

	if(possessEquipment($item[Titanium Assault Umbrella]) && can_equip($item[Titanium Assault Umbrella]))
	{
		set_property("choiceAdventure669", "4"); // The Fast and the Furry-ous: Skip (and ensure reoccurance)
	}
	else
	{
		set_property("choiceAdventure669", "1"); // The Fast and the Furry-ous: Open Ground floor (with Umbrella) or Neckbeard Choice
	}

	if (possessEquipment($item[Amulet of Extreme Plot Significance]))
	{
		auto_forceNextNoncombat();
	}

	if(in_gnoob() && auto_have_familiar($familiar[Robortender]))
	{
		if(!have_skill($skill[Bendable Knees]) && (item_amount($item[Bottle of Gregnadigne]) == 0))
		{
			handleFamiliar($familiar[Robortender]);
		}
	}

	autoAdv($location[The Castle in the Clouds in the Sky (Basement)]);
	resetMaximize();
	

	if(contains_text(get_property("lastEncounter"), "The Fast and the Furry-ous"))
	{
		auto_log_info("We was fast and furry-ous!", "blue");
		autoEquip($item[Titanium Assault Umbrella]);
		set_property("choiceAdventure669", "1"); // The Fast and the Furry-ous: Open Ground floor (with Umbrella)
		autoAdv(1, $location[The Castle in the Clouds in the Sky (Basement)]);
		if(!contains_text(get_property("lastEncounter"), "The Fast and the Furry-ous"))
		{
			auto_log_warning("Got interrupted trying to unlock the Ground Floor of the Castle", "red");
		}
	}
	else if(contains_text(get_property("lastEncounter"), "You Don\'t Mess Around with Gym"))
	{
		auto_log_info("Just messed with Gym", "blue");
		if(!can_equip($item[Amulet of Extreme Plot Significance]) || (item_amount($item[Massive Dumbbell]) > 0))
		{
			auto_log_warning("Can't equip an Amulet of Extreme Plot Signifcance...", "red");
			auto_log_warning("I suppose we will try the Massive Dumbbell... Beefcake!", "red");
			set_property("choiceAdventure670", "1"); // You Don't Mess Around with Gym: Get Massive Dumbbell then Skip
			autoAdv(1, $location[The Castle in the Clouds in the Sky (Basement)]);
			return true;
		}

		set_property("choiceAdventure670", "5"); // You Don't Mess Around with Gym: Open Ground floor (with amulet)
		if(!possessEquipment($item[Amulet Of Extreme Plot Significance]))
		{
			pullXWhenHaveY($item[Amulet of Extreme Plot Significance], 1, 0);
			if(!possessEquipment($item[Amulet of Extreme Plot Significance]))
			{
				if($location[The Penultimate Fantasy Airship].turns_spent >= 45 || in_koe())
				{
					auto_log_warning("Well, we don't seem to be able to find an Amulet...", "red");
					auto_log_warning("I suppose we will get the Massive Dumbbell... Beefcake!", "red");
					set_property("choiceAdventure670", "1"); // You Don't Mess Around with Gym: Get Massive Dumbbell then Skip
					autoAdv(1, $location[The Castle in the Clouds in the Sky (Basement)]);
				}
				else
				{
					auto_log_warning("Backfarming an Amulet of Extreme Plot Significance, sigh :(", "blue");
					if (handleFamiliar($familiar[Red-Nosed Snapper])) {
						auto_changeSnapperPhylum($phylum[dude]);
					}
					autoAdv(1, $location[The Penultimate Fantasy Airship]);
				}
				return true;
			}
		}
		set_property("choiceAdventure670", "4"); // You Don't Mess Around with Gym: Open Ground floor (with amulet)

		if(!autoEquip($slot[acc3], $item[Amulet Of Extreme Plot Significance]))
		{
			abort("Unable to equip the Amulet when we wanted to...");
		}
		autoAdv(1, $location[The Castle in the Clouds in the Sky (Basement)]);
	}
	return true;
}

boolean L10_ground()
{
	if (internalQuestStatus("questL10Garbage") != 8)
	{
		return false;
	}

	if(!canGroundhog($location[The Castle in the Clouds in the Sky (Ground Floor)]))
	{
		return false;
	}

	if (canBurnDelay($location[The Castle in the Clouds in the Sky (Ground Floor)]))
	{
		return false;
	}

	auto_log_info("Castle Ground Floor, boring!", "blue");

	auto_sourceTerminalEducate($skill[Extract], $skill[Portscan]);

	if(in_gnoob() && auto_have_familiar($familiar[Robortender]))
	{
		if(!have_skill($skill[Bendable Knees]) && (item_amount($item[Bottle of Gregnadigne]) == 0))
		{
			handleFamiliar($familiar[Robortender]);
		}
	}

	return autoAdv($location[The Castle in the Clouds in the Sky (Ground Floor)]);
}

boolean L10_topFloor()
{
	if (internalQuestStatus("questL10Garbage") < 9 || internalQuestStatus("questL10Garbage") > 10)
	{
		return false;
	}

	if (possessEquipment($item[mohawk wig]) && !auto_can_equip($item[Mohawk Wig]))
	{
		return false;
	}

	if (shenShouldDelayZone($location[The Castle in the Clouds in the Sky (Top Floor)]))
	{
		auto_log_debug("Delaying Top Floor in case of Shen.");
		return false;
	}

	auto_log_info("Castle Top Floor", "blue");
	set_property("choiceAdventure680", 1); // Mercy adventure: Are you a Man or a Mouse?
	if(item_amount($item[Drum \'n\' Bass \'n\' Drum \'n\' Bass Record]) > 0)
	{
		auto_log_info("We have a drum 'n' bass record and are willing to use it!", "green");
		// Copper Feel: Move to Mellon Collie
		set_property("choiceAdventure677", 4);
		// Mellon Collie: Turn in record, complete quest
		set_property("choiceAdventure675", 2);
	}
	else
	{
		// Mellon Collie: Move to Gimme Steam
		set_property("choiceAdventure675", 4);
		// Copper feel: Turn in airship (will fight otherwise)
		set_property("choiceAdventure677", 1);
	}
	if (!possessEquipment($item[mohawk wig]) && auto_can_equip($item[mohawk wig]) && !in_hardcore())
	{
		pullXWhenHaveY($item[Mohawk Wig], 1, 0);
	}

	if(!possessEquipment($item[mohawk wig]) && 0 == item_amount($item[Drum \'n\' Bass \'n\' Drum \'n\' Bass Record]))
	{
		auto_log_info("We don't have a mohawk wig, let's try to get a drum 'n' bass record...", "green");
		// Yeah, You're for Me, Punk Rock Giant: Move to Flavor of a Raver (676)
		set_property("choiceAdventure678", 4);
		// Floor of a Raver: Acquire drum 'n' bass 'n' drum 'n' bass record
		set_property("choiceAdventure676", 3);
	}
	else
	{
		// Floor of a Raver: Move to "Yeah, You're for Me, Punk Rock Giant (678)"
		set_property("choiceAdventure676", 4);
		// Yeah, You're for Me, Punk Rock Giant: Get the Punk's Attention, complete quest
		set_property("choiceAdventure678", 1);
	}

	if (isActuallyEd())
	{
		set_property("choiceAdventure679", 2);
	}
	else
	{
		set_property("choiceAdventure679", 1);
	}

	auto_forceNextNoncombat();
	autoEquip($item[mohawk wig]);
	autoAdv(1, $location[The Castle in the Clouds in the Sky (Top Floor)]);

	if (internalQuestStatus("questL10Garbage") > 9)
	{
		council();
		if (in_koe())
		{
			cli_execute("refresh quests");
		}
	}

	return true;
}

boolean L10_holeInTheSkyUnlock()
{
	if (internalQuestStatus("questL10Garbage") < 11)
	{
		//top floor opens at step9. but we want to finish the giant trash quest first before we do hole in the sky.
		return false;
	}
	if(!get_property("auto_holeinthesky").to_boolean())
	{
		return false;
	}
	if(item_amount($item[Steam-Powered Model Rocketship]) > 0)
	{
		set_property("auto_holeinthesky", false);
		return false;
	}
	int day = get_property("shenInitiationDay").to_int();
	boolean[location] shenLocs = shenSnakeLocations(day, 0);
	if (!needStarKey() && !(shenLocs contains $location[The Hole in the Sky]))
	{
		// we force auto_holeinthesky to true in L11_shenCopperhead() as Ed if Shen sends us to the Hole in the Sky
		// as otherwise the zone isn't required at all for Ed.
		// Should also handle situations where the player manually got the star key before unlocking Shen.
		set_property("auto_holeinthesky", false);
		return false;
	}

	if (shenShouldDelayZone($location[The Castle in the Clouds in the Sky (Top Floor)]))
	{
		auto_log_debug("Delaying unlocking Hole in the Sky in case of Shen.");
		return false;
	}

	auto_log_info("Castle Top Floor - Opening the Hole in the Sky", "blue");
	set_property("choiceAdventure677", 2);
	set_property("choiceAdventure675", 4);
	set_property("choiceAdventure678", 3);
	set_property("choiceAdventure676", 4);

	auto_forceNextNoncombat();
	autoAdv(1, $location[The Castle in the Clouds in the Sky (Top Floor)]);

	return true;
}

boolean L10_rainOnThePlains()
{
	if (L10_plantThatBean() || L10_airship() || L10_basement() || L10_ground() || L10_topFloor() || L10_holeInTheSkyUnlock())
	{
		return true;
	}
	return false;
}