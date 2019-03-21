#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_specialops;
#include maps\so_killspree_invasion_code;

#include pix\_common_scripts;

main()
{
	//ORIGINAL
	level.attackheliRange = 7000;
	maps\invasion_precache::main();
	maps\invasion_fx::main();
	maps\createart\invasion_art::main();
	precacheItem("smoke_grenade_american");
	precacheItem("remote_missile_not_player_invasion");
	precacheModel("weapon_stinger_obj");
	precacheModel("weapon_uav_control_unit_obj");
	precacheItem("flash_grenade");
	precacheItem("zippy_rockets");
	precacheItem("stinger_speedy");
	add_start("so_killspree",::start_so_killspree);
	maps\_attack_heli::preLoad();
	maps\_load::main();
	thread maps\invasion_amb::main();
	maps\invasion_anim::main_anim();
	//ORIGINAL end
	
	//predator drone setup
	maps\_remotemissile::init();
	level.uav = spawn_vehicle_from_targetname_and_drive("uav");
	level.uav playLoopSound("uav_engine_loop");
	level.uavRig = spawn("script_model",level.uav.origin);
	level.uavRig setmodel("tag_origin");
	thread UAVRigAiming();
	
	//btr80 tank setup
	thread btr80_level_init();
	level.btr80_1_alive = false;
	level.btr80_2_alive = false;
	
	//minimap & compass
	minimap_setup_survival("compass_map_invasion");
	
	//mod stuff
	_start_IW4SP_Survival_setup();
}
UAVRigAiming()
{
	level.uav endon("death");
	for(;;)
	{
		if (IsDefined(level.uavTargetEnt))
		{
			targetPos = level.uavTargetEnt.origin;
		}
		else if(IsDefined(level.uavTargetPos))
		{
			targetPos = level.uavTargetPos;
		}
		else
		{
			targetpos = (-553.753,-2970,2369.84);
		}
		angles = VectorToAngles(targetPos-level.uav.origin);
		level.uavRig MoveTo(level.uav.origin,0.10,0,0);
		level.uavRig RotateTo(ANGLES,0.10,0,0);
		wait 0.05;
	}
}
start_so_killspree()
{	
	thread music_loop("so_killspree_invasion_music",124);
	
	// Open doors around the map.
	door_diner_open();
	door_nates_locker_open();
	door_bt_locker_open();
	
	// Remove ladder clips that are there to help the player in SP.
	ladder_clip = getent("nates_kitchen_ladder_clip","targetname");
	ladder_clip Delete();
	ladder_clip = getent("bt_ktichen_ladder_clip","targetname");
	ladder_clip Delete();

	// Remove ladders entirely
	ladder_ents = getentarray("inv_ladders","script_noteworthy");
	foreach(ent in ladder_ents)
	{
		ent Delete();
	}
	ladder_ents = getentarray("inv_ladders_pathblocker","script_noteworthy");
	foreach(ent in ladder_ents)
	{
		ent disconnectpaths();
	}
	
	// Remove the Predator Control Unit
	ent = GetEnt("predator_drone_control","targetname");
	ent Delete();
	
	// Remove unwanted weapons
	sentries = getentarray("misc_turret","classname");
	foreach(sentry in sentries)
	{
		sentry Delete();
	}
	stingers = getentarray("weapon_stinger","classname");
	foreach(stinger in stingers)
	{
		stinger Delete();
	}
	thread removePlacedWeapons();
}

_start_IW4SP_Survival_setup()
{
	level.waveSetup_scheme = "default";
	level.waveHelicopters = true;
	level.waveHelicopters_targetname = "kill_heli";
	level.wave_extra_waveFunc = maps\so_killspree_invasion::_btr80_waveSetup;
	level.MaxBots = 26;
	
	
	level.bot_spawnPoints = [];
	level.bot_spawnPoints[0] = (3461.14,-6002.49,2310.13);
	level.bot_spawnPoints[1] = (4103.56,-4273.25,2307.15);
	level.bot_spawnPoints[2] = (4489.87,-2390.73,2331.37);
	level.bot_spawnPoints[3] = (2073.63,-953.56,2314.86);
	level.bot_spawnPoints[4] = (2762.07,-6187.2,2310.13);
	pix\bot\_bot::addSpawner(43,"default",level.bot_spawnPoints[0]);//ar
	pix\bot\_bot::addSpawner(56,"default",level.bot_spawnPoints[0]);//shotgun
	pix\bot\_bot::addSpawner(142,"default",level.bot_spawnPoints[0]);//lmg
	pix\bot\_bot::addSpawner(133,"default",level.bot_spawnPoints[0]);//rpg
	pix\bot\_bot::addSpawner(1,"default",level.bot_spawnPoints[1]);//ar
	pix\bot\_bot::addSpawner(8,"default",level.bot_spawnPoints[1]);//shotgun
	pix\bot\_bot::addSpawner(28,"default",level.bot_spawnPoints[1]);//lmg
	pix\bot\_bot::addSpawner(25,"default",level.bot_spawnPoints[1]);//rpg
	pix\bot\_bot::addSpawner(3,"default",level.bot_spawnPoints[2]);//ar
	pix\bot\_bot::addSpawner(20,"default",level.bot_spawnPoints[2]);//shotgun
	pix\bot\_bot::addSpawner(64,"default",level.bot_spawnPoints[2]);//lmg
	pix\bot\_bot::addSpawner(30,"default",level.bot_spawnPoints[2]);//rpg
	pix\bot\_bot::addSpawner(44,"default",level.bot_spawnPoints[3]);//ar
	pix\bot\_bot::addSpawner(68,"default",level.bot_spawnPoints[3]);//shotgun
	pix\bot\_bot::addSpawner(81,"default",level.bot_spawnPoints[3]);//lmg
	pix\bot\_bot::addSpawner(65,"default",level.bot_spawnPoints[3]);//rpg*
	pix\bot\_bot::addSpawner(45,"default",level.bot_spawnPoints[4]);//ar
	pix\bot\_bot::addSpawner(60,"default",level.bot_spawnPoints[4]);//shotgun
	pix\bot\_bot::addSpawner(152,"default",level.bot_spawnPoints[4]);//lmg
	pix\bot\_bot::addSpawner(82,"default",level.bot_spawnPoints[4]);//rpg
	
	
	pix\player\_player::addPlayers((-2280.21,-3604.34,2358.13),(0,0,0),(-2279.66,-3809.46,2358.12),(0,0,0),"beretta");
	
	
	level.shopModel = "weapon_uav_control_unit";
	
	level.WeaponShop_Unlocked_at_Wave = 5;
	level.weaponShop_Icon = "waypoint_ammo";
	level.WeaponsSetup_func = maps\so_killspree_invasion::setUpWeaponShop_Weapons;
	level.weaponShop_spawnPoint = (-704.662,-1038.22,2356.12);
	level.weaponShop_spawnAngle = (0,90,0);
	level.weaponShop_refillAmmo_price = 500;
	
	level.SupportShop_Unlocked_at_Wave = 8;
	level.SupportShop_Icon = "hud_burningcaricon";
	level.SupportShop_spawnPoint = (482.177,-5602.88,2358.13);
	level.SupportShop_spawnAngle = (0,-90,0);
	
	pix\shop\_shop::addDeltaSquad(5000);
	pix\shop\_support::setUpDeltaSquad(4,(509.46,-5786.72,2308.63));
	pix\shop\_support::setUpDeltaSquad(5,(509.46,-5786.72,2308.63));
	pix\shop\_support::setUpDeltaSquad(40,(509.46,-5786.72,2308.63));
	pix\shop\_support::setUpDeltaSquad(41,(509.46,-5786.72,2308.63));
	
	pix\shop\_shop::addMortarStrike(7000,"remote_missile_not_player_invasion");
	
	pix\shop\_shop::addPredatorDrone(4000,"remote_missile_detonator");
	
	
	
	
	thread pix\_main::_start_IW4SP_Survival();
}

_btr80_waveSetup()
{
	if(level.Wave==5)
	{
		if(!level.btr80_1_alive)
		{
			thread _spawnBTR80(1);
		}
	}
	if(level.Wave==14||level.Wave==25||level.Wave==34||level.Wave>=40)
	{
		if(!level.btr80_1_alive)
		{
			thread _spawnBTR80(1);
		}
		if(!level.btr80_2_alive)
		{
			thread _spawnBTR80(2);
		}
	}
}

setUpWeaponShop_Weapons()
{
	level.weaponshop_items = [];
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47","ak47",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_ACOG","ak47_digital_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_EOTECH","ak47_digital_eotech",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_GP25","ak47_digital_grenadier",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_REDDOT","ak47_digital_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_SHOTGUN","ak47_shotgun",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_BERETTA","beretta",400,"pistol");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_CHEYTAC","cheytac",1000,"sniper");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FAL_ACOG","fal_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FAL_SHOTGUN","fal_shotgun",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SEMTEX","semtex_grenade",600,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M2FRAGGRENADE","fraggrenade",600,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M240","m240",2000,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M240_ACOG","m240_acog",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M240_REDDOT","m240_reflex",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M4","m4_grunt",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_PP2000","pp2000",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RPD","rpd",2000,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RPD_ACOG","rpd_acog",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RPD_REDDOT","rpd_reflex",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RPG","rpg_player",2000,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SCAR_ACOG","scar_h_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SCAR_GL","scar_h_grenadier",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SCAR_REDDOT","scar_h_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SCAR_SHOTGUN","scar_h_shotgun",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SCAR_THERMAL","scar_h_thermal",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_STRIKER","striker",800,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_STRIKER_REDDOT","striker_reflex",900,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TAVOR_ACOG","tavor_digital_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TAVOR_EOTECH","tavor_digital_eotech",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TAVOR_MARS","tavor_mars",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TAVOR_REDDOT","tavor_reflex",1200,"assault_rifle");
}


_spawnBTR80(number)
{		
	if(isDefined(number))
	{
		if(number==1)
		{
			number = "nate_attacker_left";
		}
		else
		{
			number = "nate_attacker_mid";
		}
	}
	else
	{
		number = "nate_attacker_left";
	}
	btr80 = spawn_vehicle_from_targetname_and_drive(number);
	btr80.survival_number = number;
	if(btr80.survival_number=="nate_attacker_left")
	{
		level.btr80_1_alive = true;
	}
	else
	{
		level.btr80_2_alive = true;
	}
	array_thread(getvehiclenodearray("new_target","script_noteworthy"),::btr80_new_target_think);
	btr80 thread btr80_watch_for_player();
	//btr80 thread btr80_register_death();
	btr80 thread ent_flag_init("spotted_player");
	btr80 thread btr80_turret_spotlight();
	btr80 thread maps\_vehicle::damage_hints();
	//btr80 thread dialog_btr80_spotted_you();
	btr80 thread _deathMonitor_btr80();
}
_deathMonitor_btr80()
{
	self endon("death_notify");
	for(;;)
	{
		self waittill("death",attacker);
		attacker pix\player\_money::_giveMoney(1000);
		if(self.survival_number=="nate_attacker_left")
		{
			level.btr80_1_alive = false;
		}
		else
		{
			level.btr80_2_alive = false;
		}
		//self thread _btr80_deleteAfterTime();
		self notify("death_notify");
		wait 0.05;
	}
}
_btr80_deleteAfterTime()
{
	time = randomIntRange(30,120);
	iprintln("time: " + time);
	wait 10; 
	self notify("stop_looping_death_fx");
	self delete();
}


//Original stuff
enable_smoke_wave_north(dialog_wait,flag_start){}
enable_smoke_wave_south(dialog_wait,flag_start){}
enable_hunter_truck_enemies_bank(flag_start){}
enable_hunter_truck_enemies_road(flag_start){}
enable_btr80_circling_street(flag_start){}
enable_btr80_circling_parking_lot(flag_start){}
enable_hunter_enemy_refill(refill_at,min_fill,max_fill){}
enable_hunter_enemy_group_bank(enemy_count,flag_start){}
enable_hunter_enemy_group_gas_station(enemy_count,flag_start){}
enable_hunter_enemy_group_taco(enemy_count,flag_start){}