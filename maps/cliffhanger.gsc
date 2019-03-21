#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include common_scripts\utility;
#include maps\_stealth_utility;
#include maps\_hud_util;
#include maps\_blizzard;
#include maps\cliffhanger_code;
#include maps\cliffhanger_stealth;
#include maps\cliffhanger_snowmobile;

#include pix\_common_scripts;



main()
{
	level.attackheliRange = 7000;
	
	//ORIGINAL
	PreCacheItem("hind_turret_penetration");
	PreCacheItem("hind_FFAR");
	PreCacheItem("zippy_rockets");
	PreCacheModel("com_computer_keyboard_obj");
	PreCacheItem("c4");
	PreCacheShader("overhead_obj_icon_world");
	precacheShader("hud_icon_heartbeat");
	precacheShader("hud_dpad");
	precacheShader("hud_arrow_left");
	PreCacheModel("machinery_welder_handle");
	PreCacheModel("weapon_m21sd_wht");
	PreCacheShader("overlay_frozen");//level.global_ambience_blend_func = ::blizzard_ice_overlay_blend; controls the in/out frozen screen effect
	SetSavedDvar("com_cinematicEndInWhite",0);
	setsaveddvar("r_specularcolorscale","1.2");
	maps\cliffhanger_precache::main();
	default_start(::start_cave);
	maps\_load::set_player_viewhand_model("viewhands_player_arctic_wind");
	maps\_snowmobile_drive::snowmobile_preLoad("viewhands_player_arctic_wind","vehicle_snowmobile_player");
	maps\createart\cliffhanger_art::main();
	maps\cliffhanger_fx::main();
	maps\createfx\cliffhanger_audio::main();
	destructible_trees = GetEntArray("destructible_tree","targetname");
	array_thread(destructible_trees,::destructible_tree_think);
	maps\_empty::main("tag_origin");
	maps\_load::main();
	maps\_idle::idle_main();
	maps\_idle_sit_load_ak::main();
	maps\_c4::main();
	maps\cliffhanger_anim::main_anim();
	maps\_idle_coffee::main();
	maps\_idle_smoke::main();
	maps\_idle_lean_smoke::main();
	maps\_idle_phone::main();
	maps\_idle_sleep::main();
	maps\_patrol_anims::main();
	maps\_climb::climb_init();
	maps\_attack_heli::preLoad();
	//thread hide_extra_migs();// extra migs that hide and then pop out later all destroyed
	thread maps\cliffhanger_amb::main();
	mig_spawners = GetEntArray("script_vehicle_mig29","classname");
	array_thread(mig_spawners,::add_spawn_function,::miglights);
	//ORIGINAL end
	
	//minimap & compass
	minimap_setup_survival("compass_map_cliffhanger");
	
	//mod stuff
	_start_IW4SP_Survival_setup();
	
	//hunter_killer_start
	//cobra
	//kill heli
}

start_cave()
{
	foreach(player in getPlayers())
	{
		player thread playerSnowFootsteps();
	}
	model_initializations();
	
	
	//Remove Triggers
	ents = GetEntArray();
	for(i=0;i<ents.size;i++)
	{
		if((IsDefined(ents[i].classname)) && (GetSubStr(ents[i].classname,0,8)=="trigger_"))
		{
			ents[i] delete();
		}
	}
	
	//Remove placed weapons
	level thread removePlacedWeapons();
}

_start_IW4SP_Survival_setup()
{
	level.waveSetup_scheme = "default";
	level.wave_extra_waveFunc = maps\cliffhanger::_blizzard_waveSetup;
	level.MaxBots = 26;
	
	level.bot_spawnPoints = [];
	level.bot_spawnPoints[0] = (-12077.5,-27932.5,996.556);
	level.bot_spawnPoints[1] = (-12058.5,-30444.8,896.125);
	level.bot_spawnPoints[2] = (-3624.52,-26907.8,1087.69);
	pix\bot\_bot::addSpawner(10,"default",level.bot_spawnPoints[0]);//smg
	pix\bot\_bot::addSpawner(11,"default",level.bot_spawnPoints[0]);//ar
	pix\bot\_bot::addSpawner(26,"default",level.bot_spawnPoints[0]);//shotgun
	pix\bot\_bot::addSpawner(59,"default",level.bot_spawnPoints[0]);//sniper
	pix\bot\_bot::addSpawner(66,"default",level.bot_spawnPoints[0]);//smg
	pix\bot\_bot::addSpawner(20,"default",level.bot_spawnPoints[1]);//smg
	pix\bot\_bot::addSpawner(12,"default",level.bot_spawnPoints[1]);//ar
	pix\bot\_bot::addSpawner(57,"default",level.bot_spawnPoints[1]);//shotgun
	pix\bot\_bot::addSpawner(60,"default",level.bot_spawnPoints[1]);//sniper
	pix\bot\_bot::addSpawner(64,"default",level.bot_spawnPoints[1]);//smg
	pix\bot\_bot::addSpawner(21,"default",level.bot_spawnPoints[2]);//smg
	pix\bot\_bot::addSpawner(18,"default",level.bot_spawnPoints[2]);//ar
	pix\bot\_bot::addSpawner(61,"default",level.bot_spawnPoints[2]);//shotgun
	pix\bot\_bot::addSpawner(67,"default",level.bot_spawnPoints[2]);//ar
	pix\bot\_bot::addSpawner(63,"default",level.bot_spawnPoints[2]);//smg
	pix\bot\_bot::addSpawner(65,"default",level.bot_spawnPoints[2]);//shotgun
	
	
	pix\player\_player::addPlayers((-5045.66,-28714.6,896.125),(0,120,0),(-4800.61,-28564.3,896.125),(0,120,0),"usp");
	
	
	level.shopModel = "intel_item_laptop";
	
	level.WeaponShop_Unlocked_at_Wave = 5;
	level.weaponShop_Icon = "waypoint_ammo";
	level.WeaponsSetup_func = maps\cliffhanger::setUpWeaponShop_Weapons;
	level.weaponShop_spawnPoint = (-5459.34,-25255.6,1170.12);
	level.weaponShop_spawnAngle = (0,-117,0);
	level.weaponShop_refillAmmo_price = 500;
	
	level.SupportShop_Unlocked_at_Wave = 8;
	level.SupportShop_Icon = "hud_burningcaricon";
	level.SupportShop_spawnPoint = (-9442.91,-25484.3,1070.13);
	level.SupportShop_spawnAngle = (0,40,0);
	
	pix\shop\_shop::addDeltaSquad(5000);
	pix\shop\_support::setUpDeltaSquad(0,(-9057.18,-25645.2,898.125));
	pix\shop\_support::setUpDeltaSquad(1,(-9057.18,-25645.2,898.125));
	pix\shop\_support::setUpDeltaSquad(2,(-9057.18,-25645.2,898.125));
	pix\shop\_support::setUpDeltaSquad(3,(-9057.18,-25645.2,898.125));
	
	pix\shop\_shop::addMortarStrike(2000,"zippy_rockets");
	
	
	
	thread pix\_main::_start_IW4SP_Survival();
	
	
	level.cliffhanger_door_opened = false;
	level.cliffhanger_door_price = 1000;
	thread init_door_buying();
}

setUpWeaponShop_Weapons()
{
	level.weaponshop_items = [];
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47","ak47_arctic",1000,"assault_rifle");
	//thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_ACOG","ak47_arctic-acog",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_GP25","ak47_arctic_grenadier",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_REDDOT","ak47_arctic_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AUG_REFLEX","aug_reflex",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AUG_SCOPE","aug_scope",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_DRAGUNOV","dragunov_arctic",1000,"sniper");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FAMAS","famas_arctic",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FAMAS_REDDOT","famas_arctic_reflex",1200,"assault_rifle");
	//thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FLASH_GRENADE","flash_grenade",1000,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M2FRAGGRENADE","fraggrenade",600,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_KRISS","kriss",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_KRISS_EOTECH","kriss_eotech",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_KRISS_REDDOT","kriss_reflex",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M14EBR_SCOPED_SILENCED","m21_scoped_arctic_silenced",1000,"sniper");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M4","m4_grunt",1000,"assault_rifle");
	//thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_MASADA_SILENCER_ON","masada_silencer_mt_camo_on",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_P90","p90",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SPAS12","spas12",700,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_UMP45","ump45_arctic",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_UMP45_REDDOT","ump45_reflex",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_USP","usp",400,"pistol");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_USP_SILENCER","usp_silencer",400,"pistol");
	//thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_BERETTA","beretta",1000,"pistol");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RPG","zippy_rockets",2000,"equipment");
	
}


_blizzard_waveSetup()
{
	if(level.Wave==11)
	{
		thread maps\_blizzard::blizzard_level_transition_light(5);
	}
	if(level.Wave==20)
	{
		thread maps\_blizzard::blizzard_level_transition_med(5);
	}
	if(level.Wave==30)
	{
		thread maps\_blizzard::blizzard_level_transition_hard(5);
	}
	if(level.Wave==40)
	{
		thread maps\_blizzard::blizzard_level_transition_extreme(5);
	}
}

init_door_buying()
{
	getPlayer1() cliffhanger_player_door_hint_init();
	if(is_coop())
	{
		getPlayer2() cliffhanger_player_door_hint_init();
	}
	
	thread cliffhanger_buy_door_watcher();
}
cliffhanger_player_door_hint_init()
{
	self.Hud["cliffhanger_hint"] = createText("default",1.5,"MIDDLE",undefined,0,30,0,(1,1,1),1,(0,1,0),0,"");
}
cliffhanger_buy_door_watcher()
{
	level endon("cliffhanger_buy_door_watcher_end_YAY");
	for(;;)
	{
		foreach(player in getPlayers())
		{
			if(!level.cliffhanger_door_opened)
			{
				if((distance(player.origin,(-8748.05,-26178.3,896.125))<=80)||(distance(player.origin,(-9553.02,-25691.8,898.125))<=80))
				{
					player.Hud["cliffhanger_hint"] setText("Press ^3[{+activate}]^7 to open the Door!(^2$"+level.cliffhanger_door_price+"^7)");
					if(player UseButtonPressed())
					{
						player thread cliffhanger_buy_door(level.cliffhanger_door_price);
						wait .4;
					}
				}
				else if((distance(player.origin,(-8748.05,-26178.3,896.125))>80)||(distance(player.origin,(-9553.02,-25691.8,898.125))>80))
				{
					player.Hud["cliffhanger_hint"] setText("");
				}
			}
			else
			{
				if(isDefined(player.Hud["cliffhanger_hint"]))
				{
					player.Hud["cliffhanger_hint"] destroy();
				}
			}
		}
		wait 0.05;
	}
}
cliffhanger_buy_door(price)
{
	if(self.Money<price)
	{
		iprintlnBold("^1Not Enough Money");
		return;
	}
	self pix\player\_money::_takeMoney(price);
	level.cliffhanger_door_opened = true;
	thread open_hanger_doors();
	door = GetEnt("hanger_entrance_door","targetname");
	attachments = GetEntArray( door.target, "targetname" );
	for(i=0;i<attachments.size;i++)
	{
	    attachments[i] LinkTo(door);
	}
	door hunted_style_door_open();
	level notify("cliffhanger_buy_door_watcher_end_YAY");
}

//Original Stuff
start_ch_tarmac( e3 ){}
cliffhanger_tarmac_main(){}
start_common_cliffhanger(){}