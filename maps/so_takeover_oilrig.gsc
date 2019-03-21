#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;

#include pix\_common_scripts;

main()
{
	//ORIGINAL
	precacheModel( "com_barrel_white_rust" );
	precacheModel( "com_barrel_blue_rust" );
	save_triggers();
	so_delete_all_spawntriggers();
	so_delete_all_triggers();
	//so_delete_all_spawners();
	so_delete_breach_ents();
	maps\oilrig_precache::main();
	maps\createart\oilrig_fog::main();
	maps\oilrig_fx::main();
	maps\createfx\oilrig_audio::main();
	maps\_pmc::preLoad();
	maps\_attack_heli::preLoad();
    maps\_load::main();
	common_scripts\_sentry::main();
    level thread maps\oilrig_amb::main();
	thread maps\oilrig::killtrigger_ocean_on();
    door1 = getent("door_deck1","targetname");
    door1 connectPaths();
    door1 delete();
    door2 = getent("door_deck1_opposite","targetname");
    door2 connectPaths();
    door2 delete();
    eGate = getent("gate_01","targetname");
	eGate connectpaths();
	eGate moveto((eGate.origin-(0,-170,0)),1);
	fix_c4_barrels();
	array_call(getentarray("hide","script_noteworthy"),::hide);
	music_loop("so_takeover_oilrig_music",136);
	DDS = getentarray("sub_dds_01","targetname");
	DoorDDS = getentarray("dds_door_01","targetname");
	array_thread(DDS,::hide_entity);
	array_thread(DoorDDS,::hide_entity);
	DDS = getentarray("sub_dds_02","targetname");
	DoorDDS = getentarray("dds_door_02","targetname");
	array_thread(DDS,::hide_entity);
	array_thread(DoorDDS,::hide_entity);
	thread maps\oilrig::above_water_art_and_ambient_setup();
	//ORIGINAL end
	
	//compass & minimap
	minimap_setup_survival("compass_map_oilrig_lvl_1");
	array_thread(getentarray("compassTriggers","targetname"),::compass_triggers_think);
	array_thread(getentarray("compassTriggers","targetname"),maps\oilrig::compass_triggers_think);
	
	//remove placed weapons
	thread removePlacedWeapons();
	
	//remove refill ammo triggers --- or atleast the ammo icons
	ents = GetEntArray();
	for(i=0;i<ents.size;i++)
	{
		if((IsDefined(ents[i].classname)) && (GetSubStr(ents[i].classname,0,8)=="trigger_"))
		{
			ents[i] delete();
		}
	}
	
	//mod stuff
	_start_IW4SP_Survival_setup();
}

fix_c4_barrels()
{
	array_call( getentarray( "c4barrelPacks", "script_noteworthy" ), ::delete );
	
	barrels = getentarray( "c4_barrel", "script_noteworthy" );
	foreach( barrel in barrels )
	{
		if ( cointoss() )
			barrel setModel( "com_barrel_white_rust" );
		else
			barrel setModel( "com_barrel_blue_rust" );
	}
}
save_triggers()
{
	array_thread( getentarray( "compassTriggers", "targetname" ), ::make_special_op_ent );
	getent( "killtrigger_ocean", "targetname" ) make_special_op_ent();
}
make_special_op_ent()
{
	assert( isdefined( self ) );
	self.script_specialops = 1;
}
compass_triggers_think()
{
	assertex(isdefined(self.script_noteworthy),"compassTrigger at "+self.origin+" needs to have a script_noteworthy with the name of the minimap to use");
	while(true)
	{
		wait(1);
		self waittill("trigger");
		setsaveddvar("ui_hidemap",0);
		maps\_compass::setupMiniMap(self.script_noteworthy);
	}
}



_start_IW4SP_Survival_setup()
{
	level.waveSetup_scheme = "default_juggers";
	level.waveHelicopters = true;
	level.waveHelicopters_targetname = "heli_deck2";
	level.MaxBots = 26;
	
	level.bot_spawnPoints = [];
	level.bot_spawnPoints[0] = (647.579,479.077,-671.875);
	level.bot_spawnPoints[1] = (1297.46,1740.92,-671.875);
	level.bot_spawnPoints[2] = (552.295,222.85,-1047.88);
	pix\bot\_bot::addSpawner(254,"default",level.bot_spawnPoints[0]);//ar
	pix\bot\_bot::addSpawner(258,"default",level.bot_spawnPoints[0]);//ar
	pix\bot\_bot::addSpawner(259,"default",level.bot_spawnPoints[0]);//ar
	pix\bot\_bot::addSpawner(260,"default",level.bot_spawnPoints[0]);//ar
	pix\bot\_bot::addSpawner(261,"default",level.bot_spawnPoints[0]);//ar
	pix\bot\_bot::addSpawner(255,"jugger",level.bot_spawnPoints[0]);//jugger
	pix\bot\_bot::addSpawner(262,"default",level.bot_spawnPoints[1]);//ar
	pix\bot\_bot::addSpawner(263,"default",level.bot_spawnPoints[1]);//ar
	pix\bot\_bot::addSpawner(264,"default",level.bot_spawnPoints[1]);//ar
	pix\bot\_bot::addSpawner(265,"default",level.bot_spawnPoints[1]);//ar
	pix\bot\_bot::addSpawner(266,"default",level.bot_spawnPoints[1]);//ar
	pix\bot\_bot::addSpawner(256,"jugger",level.bot_spawnPoints[1]);//jugger
	pix\bot\_bot::addSpawner(267,"default",level.bot_spawnPoints[2]);//ar
	pix\bot\_bot::addSpawner(268,"default",level.bot_spawnPoints[2]);//ar
	pix\bot\_bot::addSpawner(269,"default",level.bot_spawnPoints[2]);//ar
	pix\bot\_bot::addSpawner(270,"default",level.bot_spawnPoints[2]);//ar
	pix\bot\_bot::addSpawner(271,"default",level.bot_spawnPoints[2]);//ar
	pix\bot\_bot::addSpawner(257,"jugger",level.bot_spawnPoints[2]);//jugger
	
	
	pix\player\_player::addPlayers((-84.9665,-143.605,-287.875),(0,80,0),(-2.7492,-148.215,-287.875),(0,80,0),"usp_silencer");
	
	
	level.shopModel = "com_plasticcase_beige_big";
	
	level.WeaponShop_Unlocked_at_Wave = 5;
	level.weaponShop_Icon = "waypoint_ammo";
	level.WeaponsSetup_func = maps\so_takeover_oilrig::setUpWeaponShop_Weapons;
	level.weaponShop_spawnPoint = (695.84,1069.06,-279.875);
	level.weaponShop_spawnAngle = (0,0,0);
	level.weaponShop_refillAmmo_price = 500;
	
	level.SupportShop_Unlocked_at_Wave = 8;
	level.SupportShop_Icon = "hud_burningcaricon";
	level.SupportShop_spawnPoint = (990.546,588.58,-671.875);
	level.SupportShop_spawnAngle = (0,0,0);
	
	pix\shop\_shop::addDeltaSquad(5000);
	pix\shop\_support::setUpDeltaSquad(2,(649.919,1045.7,-670.875));
	pix\shop\_support::setUpDeltaSquad(171,(649.919,1045.7,-670.875));
	pix\shop\_support::setUpDeltaSquad(71,(649.919,1045.7,-670.875));
	pix\shop\_support::setUpDeltaSquad(170,(649.919,1045.7,-670.875));
	
	pix\shop\_shop::addMortarStrike(2000,"rpg");
	
	
	
	
	thread pix\_main::_start_IW4SP_Survival();
}

setUpWeaponShop_Weapons()
{
	level.weaponshop_items = [];
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AA12","aa12",900,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AA12_REDDOT","aa12_reflex",1000,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47","ak47_arctic",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_ACOG","ak47_arctic_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_GP25","ak47_arctic_grenadier",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_REDDOT","ak47_arctic_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AUG_REFLEX","aug_reflex",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AUG_SCOPE","aug_scope",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_BERETTA","beretta",400,"pistol");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_CHEYTAC_THERMAL","cheytac_thermal",1200,"sniper");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_DRAGUNOV","dragunov",1000,"sniper");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FAMAS","famas_arctic",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FAMAS_REDDOT","famas_arctic_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FLASH_GRENADE","flash_grenade",600,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FN2000_THERMAL","fn2000_thermal",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M2FRAGGRENADE","fraggrenade",600,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_GLOCK","glock",500,"pistol");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_KRISS","kriss",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_KRISS_EOTECH","kriss_eotech",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_KRISS_REDDOT","kriss_reflex",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_BENELLI","m1014",800,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M14EBR_SCOPED","m14_scoped",1000,"sniper");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M16","m16_basic",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M16_ACOG","m16_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M16_GL","m16_grenadier",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M4","m4_grunt",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M4M203","m4_grenadier",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M4_SILENCER","m4_silencer",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_MG4","mg4",2000,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_MP5","mp5",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_MP5_REDDOT","mp5_arctic_reflex",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_MP5_SILENCER","mp5_silencer",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_P90","p90",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_P90_REDDOT","p90_reflex",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_PP2000_THERMAL","pp2000_thermal",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RPD","rpd",2000,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RPD_ACOG","rpd_acog",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RPD_REDDOT","rpd_reflex",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RPG","rpg",2000,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SPAS12","spas12",700,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SPAS12_REDDOT","spas12_arctic_reflex",800,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_STINGER","stinger",1800,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_STRIKER","striker",800,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TAVOR_MARS","tavor_mars",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_UMP45","ump45",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_UMP45_REDDOT","ump45_reflex",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_USP","usp",400,"pistol");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_USP_SILENCER","usp_silencer",400,"pistol");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_UZI","uzi",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M240","m240",2000,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M240_ACOG","m240_acog",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M240_EOTECH","m240_eotech",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M240_REDDOT","m240_reflex",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M79","m79",2000,"equipment");
}