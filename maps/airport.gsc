#include maps\_utility;
#include common_scripts\utility;
#include maps\_riotshield;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_hud_util;

#include maps\airport_code;

#include pix\_common_scripts;

//look into maps\_introscreen.gsc !!!!!!!!!!
main()
{
	//ORIGINAL
	default_start(::start_intro);
	level.CONST_WAIT_TARMAC_BSC = 1.5;
	SetDvar("scr_elevator_speed","64");
	SetSavedDvar("ai_friendlyFireBlockDuration",0);
	maps\createart\airport_art::main();
	maps\createfx\airport_audio::main();
	maps\createfx\airport_fx::main();
	maps\airport_precache::main();
	maps\airport_fx::main();
	maps\_load::main();
	maps\airport_anim::main();
	thread glass_elevator_setup();//keep it otherwise glass elevators look shit
	thread music_loop("airport_alternate",212);
	
	PreCacheModel("projectile_us_smoke_grenade");
	PreCacheModel("com_cellphone_on");
	PreCacheModel("com_metal_briefcase");
	PreCacheModel("electronics_pda");
	PreCacheModel("tag_origin");
	PreCacheItem("usp_airport");
	PreCacheItem("m4_grunt_airport");
	PreCacheItem("saw_airport");
	PreCacheItem("rpg_straight");
	PreCacheRumble("tank_rumble");
	PreCacheRumble("damage_heavy");
	PreCacheShader("hint_mantle");
	PreCacheShader("overlay_airport_death");
	PreCacheShader("white");
	PreCacheShellShock("airport");
	PreCacheString(&"AIRPORT_FAIL_POLICE_BARRICADE");
	PreCacheMenu("offensive_skip");
	//ORIGINAL end
	
	
	//minimap & compass
	minimap_setup_survival("compass_map_airport");
	
	//Mod Stuff
	_start_IW4SP_Survival_setup();
}
escape_kill_player(guy){}//still gets used in maps\airport_anim.gsc




start_intro()
{
	//get Intro Elevator Doors ------ maybe not needed cause of different spawnpoints
	intro_elevator_door_left = GetEnt("intro_elevator_door_left","targetname");
	intro_elevator_door_right = GetEnt("intro_elevator_door_right","targetname");
	
	
	//Remove Triggers
	ents = GetEntArray();
	for(i=0;i<ents.size;i++)
	{
		if((IsDefined(ents[i].classname)) && (GetSubStr(ents[i].classname,0,8)=="trigger_") && (ents[i].classname!="trigger_use_touch"))//keep glass elevator triggers
		{
			ents[i] delete();
		}
	}
	
	//Show or Remove Bodies
	thread show_intro_stairs_upperdeck_dead_bodies();//dead bodies intro lobby,stairs(escalators) and some crawlers upstairs
	thread remove_dummies();//remove the rest
	//thread intro_civilians_custom();// ---- removed    makes no sense to shoot at civilians anyway
	
	//Remove Doors ----- zombie style pay for door opening??
	door = GetEnt("escape_door_behind","targetname");
	door2 = GetEnt("escape_door","targetname");
	//door3 = GetEnt("basement_door","targetname");//get outside
	door delete();
	door2 delete();
	//door3 delete();
	
	//Remove Safety Gates
	gate1 = GetEnt("gate_gate_closing","targetname");
	gate2 = GetEnt("gate_gate_closing2","targetname");
	gate2 ConnectPaths();
	gate1 delete();
	gate2 delete();
	
	//Kill remaining friendlies
	friendAI = GetAIArray("allies");
	for(i=0;i<friendAI.size;i++)
	{
		friendAI[i] dodamage((friendAI[i].health*99999),(0,0,0));
	}
	
	
	wait 3;
	//open intro elevator doors
	intro_elevator_door_left MoveTo(intro_elevator_door_left.origin-(-100,0,0),2);
	intro_elevator_door_right MoveTo(intro_elevator_door_right.origin-(100,0,0),2);
	wait 3;
	//delete them
	intro_elevator_door_left delete();
	intro_elevator_door_right delete();
	
	//Remove placed weapons
	level thread removePlacedWeapons();
}
_start_IW4SP_Survival_setup()
{
	level.waveSetup_scheme = "default";
	level.MaxBots = 30;
	
	level.bot_spawnPoints = [];
	level.bot_spawnPoints[0] = (3843.71,3480.45,64.125);
	level.bot_spawnPoints[1] = (505.591,3440.29,-63.875);
	pix\bot\_bot::addSpawner(104,"default",level.bot_spawnPoints[0]);//ar
	pix\bot\_bot::addSpawner(51,"default",level.bot_spawnPoints[0]);//smg
	pix\bot\_bot::addSpawner(119,"default",level.bot_spawnPoints[0]);//shotgun
	pix\bot\_bot::addSpawner(58,"default",level.bot_spawnPoints[0]);//riotshield
	pix\bot\_bot::addSpawner(107,"default",level.bot_spawnPoints[0]);//ar
	pix\bot\_bot::addSpawner(61,"default",level.bot_spawnPoints[0]);//smg
	
	
	pix\player\_player::addPlayers((6547.87,2288.15,64.125),(0,-92.5323,0),(6499.96,2265.75,64.125),(0,-91.2085,0),"usp_airport");
	
	
	level.shopModel = "com_vending_can_new2_lit";
	
	level.WeaponShop_Unlocked_at_Wave = 5;
	level.weaponShop_Icon = "waypoint_ammo";
	level.WeaponsSetup_func = maps\airport::setUpWeaponShop_Weapons;
	level.weaponShop_spawnPoint = (3607.62,4958.38,320.125);
	level.weaponShop_spawnAngle = (0,0,0);
	level.weaponShop_refillAmmo_price = 500;
	
	level.SupportShop_Unlocked_at_Wave = 8;
	level.SupportShop_Icon = "hud_burningcaricon";
	level.SupportShop_spawnPoint = (1681.29,4920.11,-159.875);
	level.SupportShop_spawnAngle = (0,0,0);
	
	
	thread pix\_main::_start_IW4SP_Survival();
	
	
	
	//BASEMENT DOOR BUYING
	level.airport_door_opened = false;
	level.airport_door_price = 1000;
	level thread init_door_buying();
}

setUpWeaponShop_Weapons()
{
	level.weaponshop_items = [];
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_BERETTA","beretta",400,"pistol");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FLASH_GRENADE","flash_grenade",600,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FN2000","fn2000",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FN2000_ACOG","fn2000_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FN2000_REDDOT","fn2000_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FN2000_SCOPE","fn2000_scope",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M2FRAGGRENADE","fraggrenade",600,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M14EBR_SCOPED","m14_scoped",1000,"sniper");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M16_ACOG","m16_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M16","m16_basic",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M16_GL","m16_grenadier",1400,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M240","m240",2000,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M240_ACOG","m240_acog",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M240_REDDOT","m240_reflex",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M4M203","m4_grenadier",1400,"assault_rifle");
	//thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M4","m4_grunt",50,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M4","m4_grunt_airport",1000,"assault_rifle");//with animation
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M79","m79",2000,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_MP5","mp5",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_MP5_REDDOT","mp5_reflex",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_MP5_SILENCER","mp5_silencer",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_MP5_SILENCED_REDDOT","mp5_silencer_reflex",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RIOTSHIELD","riotshield",2000,"equipment");
	//thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RPG","rpg_straight",50,"equipment");//has unlimited ammo
	//thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SAW","saw_airport",50,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SCAR_ACOG","scar_h_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SCAR_GL","scar_h_grenadier",1400,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SCAR_REDDOT","scar_h_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SCAR_SHOTGUN","scar_h_shotgun",1200,"assault_rifle");
	//thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_ANM8_SMOKE_GRENADE","smoke_grenade_american",50,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SPAS12","spas12",800,"shotgun");
	//thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SPAS12_REDDOT","spas12_relfex",50,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_STRIKER","striker",800,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TAVOR_ACOG","tavor_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TAVOR","tavor_mars",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TMP","tmp",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TMP_REDDOT","tmp_reflex",800,"smg");
	//thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TMP_AKIMBO","tmp_akimbo",50,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_UMP45","ump45",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_UMP45_EOTECH","ump45_eotech",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_UMP45_REDDOT","ump45_reflex",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_USP","usp",400,"pistol");
	//thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_USP_AIRPORT","usp_airport",50,"pistol");
}