#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\_specialops;
#include maps\so_hidden_so_ghillies_code;

#include pix\_common_scripts;


//overflow at 984
//intel_item_laptop --- com_plasticcase_beige_big should work on all maps --- NOPE


// ---------------------------------------------------------------------------------
//	Init
// ---------------------------------------------------------------------------------
main()
{
	//ORIGINAL
	default_start(::start_so_hidden);
	setsaveddvar("sm_sunShadowScale","0.7");
	maps\so_hidden_so_ghillies_anim::main();
	maps\so_ghillies_precache::main();
	maps\createart\so_ghillies_art::main();
	maps\so_ghillies_fx::main();
	maps\_load::main();
	thread maps\so_ghillies_amb::main();
	thread maps\_radiation::main();
	//ORIGINAL end
	
	//minimap & compass
	minimap_setup_survival("");
	
	
	
	//maps\_drone_ai::init();// drone spawning tests
	
	
	
	//Mod Stuff
	_start_IW4SP_Survival_setup();
}

start_so_hidden()
{
	remove_church_door();
	level thread _block_churchtower_ladder();//blocked cause it confuses the AI
	
	//Remove placed weapons
	level thread removePlacedWeapons();

	//thread radio_dialogue("so_hid_ghil_rad_warning");//radiation warning dialogue
}

//since im to stupid to find collision stuff im doing it the lazy way
_block_churchtower_ladder()
{
	level.church_tower_blocker = spawn("script_model",(-34235.2,-1472.22,308.056));
	for(;;)
	{
		foreach(player in getPlayers())
		{
			if(distance(player.origin,level.church_tower_blocker.origin)<=20)
			{
				player setOrigin((-34156.5,-1442.98,224.125));
				iprintlnBold("Cant go up here!");
				wait 0.05;
			}
		}
		wait 0.05;
	}
}


_start_IW4SP_Survival_setup()
{
	level.waveSetup_scheme = "default";
	level.MaxBots = 30;
	
	level.bot_spawnPoints = [];
	level.bot_spawnPoints[0] = (-33778.3,-7072.9,194.485);
	level.bot_spawnPoints[1] = (-32201.2,-120.428,212.125);
	pix\bot\_bot::addSpawner(7,"default",level.bot_spawnPoints[0]);//sniper
	pix\bot\_bot::addSpawner(21,"default",level.bot_spawnPoints[0]);//shotgun
	pix\bot\_bot::addSpawner(22,"default",level.bot_spawnPoints[0]);//ar
	pix\bot\_bot::addSpawner(26,"default",level.bot_spawnPoints[0]);//smg
	pix\bot\_bot::addSpawner(8,"default",level.bot_spawnPoints[1]);//sniper
	pix\bot\_bot::addSpawner(35,"default",level.bot_spawnPoints[1]);//shotgun
	pix\bot\_bot::addSpawner(27,"default",level.bot_spawnPoints[1]);//ar
	pix\bot\_bot::addSpawner(37,"default",level.bot_spawnPoints[1]);//smg
	
	
	pix\player\_player::addPlayers((-35579.6,-1550.02,220.199),(0,-25.5418,0),(-35243.5,-1042.31,218.357),(0,-65.3617,0),"usp_silencer");
	
	
	level.shopModel = "com_plasticcase_beige_big";
	
	level.WeaponShop_Unlocked_at_Wave = 5;
	level.weaponShop_Icon = "waypoint_ammo";
	level.WeaponsSetup_func = maps\so_hidden_so_ghillies::setUpWeaponShop_Weapons;
	level.weaponShop_spawnPoint = (-30151.8,-37.1247,176.72);
	level.weaponShop_spawnAngle = (0,50,0);
	level.weaponShop_refillAmmo_price = 500;
	
	level.SupportShop_Unlocked_at_Wave = 8;
	level.SupportShop_Icon = "hud_burningcaricon";
	level.SupportShop_spawnPoint = (-28541.7,5015.94,239.125);
	level.SupportShop_spawnAngle = (0,50,0);
	
	
	
	
	thread pix\_main::_start_IW4SP_Survival();
}

setUpWeaponShop_Weapons()
{
	level.weaponshop_items = [];
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_ACOG","ak47_digital_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_REDDOT","ak47_digital_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47","ak47_woodland",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_EOTECH","ak47_woodland_eotech",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_GP25","ak47_woodland_grenadier",1400,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_DRAGUNOV","dragunov",1000,"sniper");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FAMAS","famas_woodland",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FAMAS_EOTECH","famas_woodland_eotech",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FAMAS_REDDOT","famas_woodland_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FN2000_ACOG","fn2000_acog",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FN2000_EOTECH","fn2000_eotech",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FN2000_REDDOT","fn2000_reflex",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M2FRAGGRENADE","fraggrenade",600,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_GLOCK","glock",400,"pistol");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_USP_SILENCER","usp_silencer",400,"pistol");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_BENELLI","m1014",800,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_BENELLI_SILENCER","m1014_silencer",800,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_P90","p90",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_P90_ACOG","p90_acog",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_P90_REDDOT","p90_reflex",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_PP2000","pp2000",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_PP2000_SILENCER","pp2000_silencer",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_STRIKER","striker",800,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_STRIKER_REDDOT","striker_reflex",900,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_STRIKER_SILENCER","striker_woodland_silencer",800,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TAVOR_MARS","tavor_mars",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TAVOR_REDDOT","tavor_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TAVOR_ACOG","tavor_woodland_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TAVOR_EOTECH","tavor_woodland_eotech",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TMP","tmp",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_UMP45_ACOG","ump45_acog",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_UMP45_EOTECH","ump45_eotech",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_UMP45_REDDOT","ump45_reflex",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_WA2000","wa2000",1000,"sniper");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_UZI_SILENCER","uzi_silencer",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_MP5_SILENCER","mp5_silencer",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_CHEYTAC_SILENCER","cheytac_silencer",1000,"sniper");
}