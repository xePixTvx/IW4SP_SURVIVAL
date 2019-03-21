#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;

#include pix\_common_scripts;

main()
{
	//ORIGINAL
	so_delete_all_spawntriggers();
	so_delete_all_triggers();
	//so_delete_all_spawners();
	so_delete_breach_ents();
	default_start(::_removeStuff);
	maps\_juggernaut::main();
	animscripts\dog\dog_init::initDogAnimations();
	maps\boneyard_precache::main();
	maps\createart\boneyard_fog::main();
	maps\createfx\boneyard_audio::main();
	maps\boneyard_fx::main();
	maps\_load::main();
	level thread enable_escape_warning();
	level thread enable_escape_failure();
	maps\boneyard_amb::main();
	//music_loop("so_intel_boneyard_music",190);
	//ORIGINAL end
	
	//So they dont kill eachother on spawn
	SetIgnoreMeGroup("axis","team3");
	SetIgnoreMeGroup("team3","axis");

	//compass & minimap
	minimap_setup_survival("compass_map_boneyard");
	
	//mod stuff
	_start_IW4SP_Survival_setup();
}

_removeStuff()
{
	//remove placed weapons
	thread removePlacedWeapons();
}


_start_IW4SP_Survival_setup()
{
	level.waveSetup_scheme = "default_dogs_juggers";
	level.MaxBots = 26;
	
	level.bot_spawnPoints = [];
	level.bot_spawnPoints[0] = (-3384.24,-867.564,12.0889);
	level.bot_spawnPoints[1] = (-6633.27,-3331.38,-71.5306);
	level.bot_spawnPoints[2] = (-2471.73,-2746.26,10.9597);
	pix\bot\_bot::addSpawner(0,"default",level.bot_spawnPoints[0]);//ar
	pix\bot\_bot::addSpawner(1,"default",level.bot_spawnPoints[0]);//smg
	pix\bot\_bot::addSpawner(4,"default",level.bot_spawnPoints[0]);//lmg
	pix\bot\_bot::addSpawner(12,"default",level.bot_spawnPoints[0]);//shotgun
	pix\bot\_bot::addSpawner(36,"default",level.bot_spawnPoints[0]);//auto shotgun
	pix\bot\_bot::addSpawner(19,"default",level.bot_spawnPoints[0]);//rpg
	pix\bot\_bot::addSpawner(60,"default",level.bot_spawnPoints[0]);//sniper
	pix\bot\_bot::addSpawner(407,"jugger",level.bot_spawnPoints[0]);//jugger
	pix\bot\_bot::addSpawner(31,"dog",level.bot_spawnPoints[0]);//dog
	pix\bot\_bot::addSpawner(2,"default",level.bot_spawnPoints[1]);//ar
	pix\bot\_bot::addSpawner(8,"default",level.bot_spawnPoints[1]);//smg
	pix\bot\_bot::addSpawner(9,"default",level.bot_spawnPoints[1]);//lmg
	pix\bot\_bot::addSpawner(13,"default",level.bot_spawnPoints[1]);//shotgun
	pix\bot\_bot::addSpawner(57,"default",level.bot_spawnPoints[1]);//auto shotgun
	pix\bot\_bot::addSpawner(30,"default",level.bot_spawnPoints[1]);//rpg
	pix\bot\_bot::addSpawner(114,"default",level.bot_spawnPoints[1]);//sniper
	pix\bot\_bot::addSpawner(408,"jugger",level.bot_spawnPoints[1]);//jugger
	pix\bot\_bot::addSpawner(32,"dog",level.bot_spawnPoints[1]);//dog
	pix\bot\_bot::addSpawner(3,"default",level.bot_spawnPoints[2]);//ar
	pix\bot\_bot::addSpawner(10,"default",level.bot_spawnPoints[2]);//smg
	pix\bot\_bot::addSpawner(24,"default",level.bot_spawnPoints[2]);//lmg
	pix\bot\_bot::addSpawner(51,"default",level.bot_spawnPoints[2]);//shotgun
	pix\bot\_bot::addSpawner(67,"default",level.bot_spawnPoints[2]);//auto shotgun
	pix\bot\_bot::addSpawner(58,"default",level.bot_spawnPoints[2]);//rpg
	pix\bot\_bot::addSpawner(125,"default",level.bot_spawnPoints[2]);//sniper
	pix\bot\_bot::addSpawner(409,"jugger",level.bot_spawnPoints[2]);//jugger
	
	
	pix\player\_player::addPlayers((8649.2,-2158.81,-95.9341),(0,170,0),(8654.94,-1932.94,-96.3383),(0,170,0),"usp_silencer");
	
	
	level.shopModel = "com_laptop_2_open_obj";
	
	level.WeaponShop_Unlocked_at_Wave = 5;
	level.weaponShop_Icon = "waypoint_ammo";
	level.WeaponsSetup_func = maps\so_intel_boneyard::setUpWeaponShop_Weapons;
	level.weaponShop_spawnPoint = (6095.03,-2200.8,30);
	level.weaponShop_spawnAngle = (0,50,0);
	level.weaponShop_refillAmmo_price = 500;
	
	level.SupportShop_Unlocked_at_Wave = 8;
	level.SupportShop_Icon = "hud_burningcaricon";
	level.SupportShop_spawnPoint = (1530.66,-2335.56,14);
	level.SupportShop_spawnAngle = (0,180,0);
	
	//Cpt price delta squad with random names xD
	pix\shop\_shop::addDeltaSquad(5000);
	pix\shop\_support::setUpDeltaSquad(206,(13.2272,-2944.74,-41.0766));
	pix\shop\_support::setUpDeltaSquad(206,(13.2272,-2944.74,-41.0766));
	pix\shop\_support::setUpDeltaSquad(206,(13.2272,-2944.74,-41.0766));
	pix\shop\_support::setUpDeltaSquad(206,(13.2272,-2944.74,-41.0766));
	
	pix\shop\_shop::addMortarStrike(2000,"rpg_player");
	
	
	
	thread pix\_main::_start_IW4SP_Survival();
}

setUpWeaponShop_Weapons()
{
	level.weaponshop_items = [];
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AA12_REDDOT","aa12_reflex",900,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_REDDOT","ak47_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_BERETTA","beretta",400,"pistol");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_DRAGUNOV","dragunov",1000,"sniper");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FLASH_GRENADE","flash_grenade",600,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FN2000","fn2000",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FN2000_ACOG","fn2000_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FN2000_EOTECH","fn2000_eotech",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FN2000_REDDOT","fn2000_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FN2000_THERMAL","fn2000_thermal",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M2FRAGGRENADE","fraggrenade",600,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_GLOCK","glock",500,"pistol");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_KRISS","kriss",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_KRISS_REDDOT","kriss_reflex",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_BENELLI","m1014",800,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_BENELLI_REDDOT","m1014_reflex",900,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M240","m240",2000,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M240_ACOG","m240_acog",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M240_REDDOT","m240_reflex",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M4M203","m4_grenadier",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_MASADA","masada_digital",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_MASADA_ACOG","masada_digital_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_MASADA_EOTECH","masada_digital_eotech",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_MASADA_REDDOT","masada_digital_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_P90","p90",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_P90_ACOG","p90_acog",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_P90_REDDOT","p90_reflex",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_PP2000","pp2000",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RPD","rpd",2000,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RPD_ACOG","rpd_acog",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RPD_REDDOT","rpd_reflex",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RPG","rpg",2000,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SCAR","scar_h",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SCAR_ACOG","scar_h_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SCAR_GL","scar_h_grenadier",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SCAR_REDDOT","scar_h_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SCAR_SHOTGUN","scar_h_shotgun",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SCAR_THERMAL","scar_h_thermal",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SPAS12","spas12",700,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_STRIKER","striker_woodland",700,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TAVOR_MARS","tavor_mars",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TAVOR_REDDOT","tavor_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TAVOR_ACOG","tavor_woodland_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TAVOR_EOTECH","tavor_woodland_eotech",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TMP","tmp",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TMP_REDDOT","tmp_reflex",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_UMP45_ACOG","ump45_acog",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_UMP45_EOTECH","ump45_eotech",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_UMP45_REDDOT","ump45_reflex",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_USP_SILENCER","usp_silencer",400,"pistol");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_UZI","uzi",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_WA2000","wa2000",1000,"sniper");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_WA2000_THERMAL","wa2000_thermal",1200,"sniper");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_CHEYTAC","cheytac",1000,"sniper");
}