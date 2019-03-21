#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_specialops;
#include maps\so_killspree_favela_code;
#include maps\favela_code;

#include pix\_common_scripts;

main()
{
	//DELETE REFILL AMMO BOXES ---- needs to be done before maps\_load::main() or trigger remains
	array_call(getentarray("ammo_crate_part","targetname"),::delete);
	array_call(getentarray("ammo_crate_clip","targetname"),::delete);
	array_call(getentarray("ammo_cache","targetname"),::delete);
	
	//ORIGINAL
	default_start( ::start_so_favela );
	maps\favela_precache::main();
	maps\favela_fx::main();
	maps\createart\favela_art::main();
	animscripts\dog\dog_init::initDogAnimations();
	maps\_hiding_door_anims::main();
	maps\_load::set_player_viewhand_model("viewhands_player_tf141");	
	maps\_load::main();
	maps\favela_anim::main();
	thread maps\favela_amb::main();
	thread music_loop("so_killspree_favela_music",274);
	//ORIGINAL end
	
	//minimap & compass
	minimap_setup_survival("compass_map_favela");
	
	//Mod Stuff
	_start_IW4SP_Survival_setup();
}


start_so_favela()
{
	/*not deleted
				claymore pickup
	*/
	
	
	//DELETE ALL TRIGGERS
	ents = GetEntArray();
	for(i=0;i<ents.size;i++)
	{
		if((IsDefined(ents[i].classname))&&(GetSubStr(ents[i].classname,0,8)=="trigger_"))
		{
			ents[i] delete();
		}
	}
	favela_spawn_ambush_trigger = getent("so_favela_ambush_spawn_trigger","script_noteworthy");
	original_roof_spawn_trig = getent("favela_spawn_trigger","script_noteworthy");
	seeker_spawn_trig = getent("so_favela_spawn_trigger","script_noteworthy");
	favela_spawn_ambush_trigger delete();
	original_roof_spawn_trig delete();
	seeker_spawn_trig delete();
	
	//Remove placed weapons
	level thread removePlacedWeapons();
}



_start_IW4SP_Survival_setup()
{
	level.waveSetup_scheme = "default_dogs";
	level.MaxBots = 26;
	
	level.bot_spawnPoints = [];
	level.bot_spawnPoints[0] = (-3691.96,-1475.57,650.331);
	level.bot_spawnPoints[1] = (-4073.07,494.089,659.963);
	pix\bot\_bot::addSpawner(3,"default",level.bot_spawnPoints[0]);//ar
	pix\bot\_bot::addSpawner(4,"default",level.bot_spawnPoints[0]);//lmg
	pix\bot\_bot::addSpawner(16,"default",level.bot_spawnPoints[0]);//smg
	pix\bot\_bot::addSpawner(18,"default",level.bot_spawnPoints[0]);//rpg
	pix\bot\_bot::addSpawner(51,"dog",level.bot_spawnPoints[0]);//dog
	pix\bot\_bot::addSpawner(62,"default",level.bot_spawnPoints[0]);//sniper
	pix\bot\_bot::addSpawner(78,"default",level.bot_spawnPoints[0]);//shotgun
	pix\bot\_bot::addSpawner(5,"default",level.bot_spawnPoints[1]);//ar
	pix\bot\_bot::addSpawner(10,"default",level.bot_spawnPoints[1]);//lmg
	pix\bot\_bot::addSpawner(12,"default",level.bot_spawnPoints[1]);//smg
	pix\bot\_bot::addSpawner(13,"default",level.bot_spawnPoints[1]);//rpg
	pix\bot\_bot::addSpawner(55,"dog",level.bot_spawnPoints[1]);//dog
	pix\bot\_bot::addSpawner(92,"default",level.bot_spawnPoints[1]);//sniper
	pix\bot\_bot::addSpawner(88,"default",level.bot_spawnPoints[1]);//shotgun
	
	
	pix\player\_player::addPlayers((-2080.07,-1749.18,650.625),(0,87.6984,0),(-1817.7,-1681.57,650.625),(0,123.777,0),"beretta");
	
	
	level.shopModel = "com_plasticcase_beige_big";
	
	level.WeaponShop_Unlocked_at_Wave = 5;
	level.weaponShop_Icon = "waypoint_ammo";
	level.WeaponsSetup_func = maps\so_killspree_favela::setUpWeaponShop_Weapons;
	level.weaponShop_spawnPoint = (-3551.85,-651.999,659.306);
	level.weaponShop_spawnAngle = (0,0,0);
	level.weaponShop_refillAmmo_price = 500;
	
	level.SupportShop_Unlocked_at_Wave = 8;
	level.SupportShop_Icon = "hud_burningcaricon";
	level.SupportShop_spawnPoint = (-5296.21,3024.58,780.125);
	level.SupportShop_spawnAngle = (0,-35,0);
	

	pix\shop\_shop::addDeltaSquad(5000);
	pix\shop\_support::setUpDeltaSquad(52,(-5499.84,2702.13,779.857));
	pix\shop\_support::setUpDeltaSquad(53,(-5499.84,2702.13,779.857));
	pix\shop\_support::setUpDeltaSquad(187,(-5499.84,2702.13,779.857));
	pix\shop\_support::setUpDeltaSquad(222,(-5499.84,2702.13,779.857));
	
	pix\shop\_shop::addMortarStrike(2000,"rpg_player");
	
	
	thread pix\_main::_start_IW4SP_Survival();
}

setUpWeaponShop_Weapons()
{
	level.weaponshop_items = [];
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_BERETTA","beretta",400,"pistol");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47","ak47",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_ACOG","ak47_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_GP25","ak47_grenadier",1400,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_REDDOT","ak47_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_DESERTEAGLE","deserteagle",400,"pistol");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_DESERTEAGLE_AKIMBO","deserteagle_akimbo",500,"pistol");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_DRAGUNOV","dragunov",1000,"sniper");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FAL","fal",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FAL_ACOG","fal_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FAL_REDDOT","fal_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FAL_SHOTGUN","fal_shotgun",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FLASH_GRENADE","flash_grenade",600,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M2FRAGGRENADE","fraggrenade",600,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_GLOCK","glock",500,"pistol");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_GLOCK_AKIMBO","glock_akimbo",600,"pistol");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M4M203","m4_grenadier",1400,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M4","m4_grunt",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_MODEL1887","model1887",800,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_MP5","mp5",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_MP5_REDDOT","mp5_reflex",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RANGER","ranger",800,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RPD","rpd",2000,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RPD_ACOG","rpd_acog",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RPD_REDDOT","rpd_reflex",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RPG","rpg",2000,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_UZI","uzi",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_UZI_AKIMBO","uzi_akimbo",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AA12SP_HB","aa12_hb",900,"shotgun");
}