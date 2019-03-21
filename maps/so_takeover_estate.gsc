#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;

#include pix\_common_scripts;

main()
{
	//ORIGINAL
	no_prone_water = getentarray("no_prone_water","targetname");
	foreach(trigger in no_prone_water)
	{
		trigger.script_specialops = 1;
	}
	so_delete_all_spawntriggers();
	so_delete_all_triggers();
	so_delete_breach_ents();
	maps\estate_precache::main();
	maps\createart\estate_art::main();
	maps\createfx\estate_audio::main();
	maps\estate_fx::main();
	maps\_juggernaut::main();
    maps\_load::main();
    thread maps\estate_amb::main();
	thread remove_stuff();
	music_loop("so_takeover_estate_music",124);
	//ORIGINAL end
	
	
	maps\_littlebird::main("vehicle_little_bird_armed");//maybe i get it working
	
	//minimap & compass
	minimap_setup_survival("compass_map_estate");
	
	//mod stuff
	_start_IW4SP_Survival_setup();
}

remove_stuff()
{
	getent("fake_backwards_door_clip","targetname") delete();
	getent("dsm","targetname") delete();
	getent("dsm_obj","targetname") delete();
	array_call(getentarray("window_newspaper","targetname"),::delete);
	array_call(getentarray("window_pane","targetname"),::delete);
	array_call(getentarray("window_brokenglass","targetname"),::delete);
	array_call(getentarray("window_blinds","targetname"),::delete);
	array_call(getentarray("paper_window_sightblocker","targetname"),::delete);
	array_call(getentarray("sp_claymore_pickups","targetname"),::delete);
	
	//cant remove refill ammo trigger so we just close the door and use it as a easteregg
	level.weaponRoom_door_clip = getent("recroom_closed_doors","targetname");
	level.weaponRoom_door_clip.origin = (436.85,353.529,62.125);
	level.weaponRoom_door_clip.angles = (0,-90,0);
	level.weaponRoom_door_clip hide();
	level.weaponRoom_door = getent("fake_backwards_door","targetname");
	level.weaponRoom_door.origin = (436.85,366.529,16.125);
	level.weaponRoom_door.angles = (0,-14,0);
	
	//Remove Triggers
	ents = GetEntArray();
	for(i=0;i<ents.size;i++)
	{
		if((IsDefined(ents[i].classname)) && (GetSubStr(ents[i].classname,0,8)=="trigger_") && (ents[i].classname!="no_prone_water"))
		{
			ents[i] delete();
		}
	}
	
	//Remove placed weapons
	level thread removePlacedWeapons();
}


_start_IW4SP_Survival_setup()
{
	level.waveSetup_scheme = "default_juggers";
	level.MaxBots = 26;
	
	level.bot_spawnPoints = [];
	level.bot_spawnPoints[0] = (3742.99,2665.13,-155.875);
	level.bot_spawnPoints[1] = (-561.376,3617.89,-250.327);
	level.bot_spawnPoints[2] = (392.184,-2606.68,-157.013);
	pix\bot\_bot::addSpawner(0,"default",level.bot_spawnPoints[0]);//ar
	pix\bot\_bot::addSpawner(8,"default",level.bot_spawnPoints[0]);//shotgun
	pix\bot\_bot::addSpawner(7,"default",level.bot_spawnPoints[0]);//smg
	pix\bot\_bot::addSpawner(2,"default",level.bot_spawnPoints[0]);//lmg
	pix\bot\_bot::addSpawner(173,"default",level.bot_spawnPoints[0]);//rpg
	pix\bot\_bot::addSpawner(225,"default",level.bot_spawnPoints[0]);//sniper
	pix\bot\_bot::addSpawner(1,"default",level.bot_spawnPoints[1]);//ar
	pix\bot\_bot::addSpawner(33,"default",level.bot_spawnPoints[1]);//shotgun
	pix\bot\_bot::addSpawner(25,"default",level.bot_spawnPoints[1]);//smg
	pix\bot\_bot::addSpawner(6,"default",level.bot_spawnPoints[1]);//lmg
	pix\bot\_bot::addSpawner(175,"default",level.bot_spawnPoints[1]);//rpg
	pix\bot\_bot::addSpawner(226,"default",level.bot_spawnPoints[1]);//sniper
	pix\bot\_bot::addSpawner(3,"default",level.bot_spawnPoints[2]);//ar
	pix\bot\_bot::addSpawner(36,"default",level.bot_spawnPoints[2]);//shotgun
	pix\bot\_bot::addSpawner(27,"default",level.bot_spawnPoints[2]);//smg
	pix\bot\_bot::addSpawner(19,"default",level.bot_spawnPoints[2]);//lmg
	pix\bot\_bot::addSpawner(176,"default",level.bot_spawnPoints[2]);//rpg
	pix\bot\_bot::addSpawner(359,"default",level.bot_spawnPoints[2]);//sniper
	pix\bot\_bot::addSpawner(145,"default",level.bot_spawnPoints[2]);//shepherd
	pix\bot\_bot::addSpawner(476,"jugger",level.bot_spawnPoints[0]);//jugger
	pix\bot\_bot::addSpawner(477,"jugger",level.bot_spawnPoints[1]);//jugger
	pix\bot\_bot::addSpawner(478,"jugger",level.bot_spawnPoints[2]);//jugger
	
	/*
		Vehicle Spawner ids
		18 littlebird armed ---- classname: script_vehicle_littlebird_armed
		targetname: ending_treecutter_heli_1
		
		SetVehGoalPos(target.origin+(0,0,1200),1);
		heli = vehicle_spawn(spawners[18]);
	*/
	
	
	pix\player\_player::addPlayers((661.107,1335.3,134.125),(0,-102.86,0),(550.96,1366.03,130.364),(0,-102.86,0),"usp_silencer");
	
	
	level.shopModel = "com_plasticcase_beige_big";
	
	level.WeaponShop_Unlocked_at_Wave = 5;
	level.weaponShop_Icon = "waypoint_ammo";
	level.WeaponsSetup_func = maps\so_takeover_estate::setUpWeaponShop_Weapons;
	level.weaponShop_spawnPoint = (558.705,326.697,16.125);
	level.weaponShop_spawnAngle = (0,160,0);
	level.weaponShop_refillAmmo_price = 500;
	
	level.SupportShop_Unlocked_at_Wave = 8;
	level.SupportShop_Icon = "hud_burningcaricon";
	level.SupportShop_spawnPoint = (2161.22,29.7649,-76.0436);
	level.SupportShop_spawnAngle = (0,33,0);
	
	pix\shop\_shop::addDeltaSquad(5000);
	pix\shop\_support::setUpDeltaSquad(9,(661.107,1335.3,134.125));
	pix\shop\_support::setUpDeltaSquad(10,(661.107,1335.3,134.125));
	pix\shop\_support::setUpDeltaSquad(11,(661.107,1335.3,134.125));
	pix\shop\_support::setUpDeltaSquad(12,(661.107,1335.3,134.125));
	
	pix\shop\_shop::addMortarStrike(2000,"rpg");
	
	
	
	thread pix\_main::_start_IW4SP_Survival();
	
	
	
	level thread _es_ist_ostern();
}

setUpWeaponShop_Weapons()
{
	level.weaponshop_items = [];
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AA12SP","aa12",900,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_ACOG","ak47_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_EOTECH","ak47_eotech",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_REDDOT","ak47_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_SHOTGUN","ak47_shotgun",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47","ak47_woodland",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_GP25","ak47_woodland_grenadier",1400,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AUG_REFLEX","aug_reflex",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AUG_SCOPE","aug_scope",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_BARRETT","barrett",1000,"sniper");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_BERETTA","beretta",400,"pistol");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_CLAYMORE","claymore",600,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_ANACONDA","coltanaconda",400,"pistol");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_DESERTEAGLE","deserteagle",400,"pistol");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_DRAGUNOV","dragunov",1000,"sniper");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FAMAS","famas_woodland",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FAMAS_EOTECH","famas_woodland_eotech",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FAMAS_REDDOT","famas_woodland_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FLASH_GRENADE","flash_grenade",600,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FN2000_ACOG","fn2000_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FN2000_EOTECH","fn2000_eotech",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FN2000_REDDOT","fn2000_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FN2000_THERMAL","fn2000_thermal",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M2FRAGGRENADE","fraggrenade",600,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_GLOCK","glock",500,"pistol");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_KRISS_REDDOT","kriss_reflex",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M4M203","m4_grenadier",1400,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M4","m4_grunt",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M4M203_ACOG","m4m203_acog",1600,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M4M203_EOTECH","m4m203_eotech",1600,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M4M203_REFLEX","m4m203_reflex",1600,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M14EBR_SCOPED","m14_scoped",1000,"sniper");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M16_ACOG","m16_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M16_GL","m16_grenadier",1400,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M16_REDDOT","m16_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M240","m240",2000,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M240_ACOG","m240_acog",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M240_EOTECH","m240_eotech",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M240_REDDOT","m240_reflex",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_BENELLI","m1014",800,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_MASADA","masada",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_MASADA_ACOG","masada_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_MASADA_EOTECH","masada_digital_eotech",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_MASADA_REDDOT","masada_digital_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_MODEL1887","model1887",800,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_MP5_SILENCER","mp5_silencer",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_P90","p90",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_P90_ACOG","p90_acog",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_P90_REDDOT","p90_reflex",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_P90_SILENCER","p90_silencer",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_PP2000","pp2000",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_PP2000_REDDOT","pp2000_reflex",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_PP2000_SILENCER","pp2000_silencer",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RPD","rpd",2000,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RPD_ACOG","rpd_acog",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RPD_REDDOT","rpd_reflex",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RPG","rpg",2000,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SA80","sa80",2000,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SA80_SCOPE","sa80lmg_scope",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SCAR","scar_h",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SCAR_ACOG","scar_h_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SCAR_GL","scar_h_grenadier",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SCAR_REDDOT","scar_h_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SCAR_SHOTGUN","scar_h_shotgun",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SCAR_THERMAL","scar_h_thermal",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SPAS12_EOTECH","spas12_eotech",800,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_STRIKER","striker",800,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_STRIKER_REDDOT","striker_reflex",900,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TAVOR_ACOG","tavor_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TAVOR_EOTECH","tavor_eotech",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TAVOR_MARS","tavor_mars",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TAVOR_REDDOT","tavor_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TMP","tmp",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TMP_REDDOT","tmp_reflex",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_UMP45_ACOG","ump45_acog",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_UMP45_EOTECH","ump45_eotech",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_UMP45_REDDOT","ump45_reflex",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_USP_SILENCER","usp_silencer",400,"pistol");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_UZI","uzi",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_WA2000","wa2000",1000,"sniper");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_WA2000_THERMAL","wa2000_thermal",1200,"sniper");
}








_es_ist_ostern()
{
	level.easteregg_loc_1 = (-340.355,-2823.39,-210.125);
	level.easteregg_loc_2 = (-2943.58,462.762,-290.92);
	level.easteregg_loc_3 = (102.771,-91.3532,26.125);
	level.easteregg_loc_4 = (3952.11,432.066,-119.485);
	level.easteregg_done = false;
	
	//thread _spawnCrate(level.easteregg_loc_1,"arcademode_life");
	//thread _spawnCrate(level.easteregg_loc_2,"arcademode_life");
	//thread _spawnCrate(level.easteregg_loc_3,"arcademode_life");
	//thread _spawnCrate(level.easteregg_loc_4,"arcademode_life");
	
	level.osterei_1_aktiviert = false;
	level.osterei_2_aktiviert = false;
	level.osterei_3_aktiviert = false;
	level.osterei_4_aktiviert = false;
	
	getPlayer1() thread _oster_hud();
	if(is_coop())
	{
		getPlayer2() thread _oster_hud();
	}
	
	level thread _der_osterhase();
}
_oster_hud()
{
	self.Hud["oster_hint"] = createText("default",1.5,"MIDDLE",undefined,0,30,0,(1,1,1),1,(0,1,0),0,"");
}
_der_osterhase()
{
	level endon("ostern_ist_vorbei");
	for(;;)
	{
		foreach(player in getPlayers())
		{
			if(distance(player.origin,level.easteregg_loc_1)<=50 && !level.osterei_1_aktiviert)
			{
				player.Hud["oster_hint"] setText("Press ^3[{+activate}]^7 to Activate!");
				if(player UseButtonPressed())
				{
					level.osterei_1_aktiviert = true;
					player playLocalSound("arcademode_zerodeaths");
					wait .4;
				}
			}
			else if(distance(player.origin,level.easteregg_loc_2)<=50 && !level.osterei_2_aktiviert)
			{
				player.Hud["oster_hint"] setText("Press ^3[{+activate}]^7 to Activate!");
				if(player UseButtonPressed())
				{
					level.osterei_2_aktiviert = true;
					player playLocalSound("arcademode_zerodeaths");
					wait .4;
				}
			}
			else if(distance(player.origin,level.easteregg_loc_3)<=50 && !level.osterei_3_aktiviert)
			{
				player.Hud["oster_hint"] setText("Press ^3[{+activate}]^7 to Activate!");
				if(player UseButtonPressed())
				{
					level.osterei_3_aktiviert = true;
					player playLocalSound("arcademode_zerodeaths");
					wait .4;
				}
			}
			else if(distance(player.origin,level.easteregg_loc_4)<=50 && !level.osterei_4_aktiviert)
			{
				player.Hud["oster_hint"] setText("Press ^3[{+activate}]^7 to Activate!");
				if(player UseButtonPressed())
				{
					level.osterei_4_aktiviert = true;
					player playLocalSound("arcademode_zerodeaths");
					wait .4;
				}
			}
			else
			{
				player.Hud["oster_hint"] setText("");
			}
		}
		if(level.osterei_1_aktiviert && level.osterei_2_aktiviert && level.osterei_3_aktiviert && level.osterei_4_aktiviert && !level.easteregg_done)
		{
			level.easteregg_done = true;
			level.weaponRoom_door_clip delete();
			level.weaponRoom_door delete();
			foreach(player in getPlayers())
			{
				player.Hud["oster_hint"] destroy();
			}
			level.oster_notify = createServerText("hudBig",1.0,"CENTER","TOP",0,20,0,(1,1,1),0,(0.3,0.6,0.3),1,"Easteregg Done: Door Opened!");
			level.oster_notify elemFadeOverTime(.7,1);
			level.oster_notify SetPulseFX(100, int(6*1000), 1000);
			wait 8;
			level.oster_notify destroy();
			level notify("ostern_ist_vorbei");
		}
		wait 0.05;
	}
}