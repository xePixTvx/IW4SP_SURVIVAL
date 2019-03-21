#include maps\_utility;
#include maps\_riotshield;
#include maps\_vehicle;
#include maps\_vehicle_spline;
#include maps\_anim;
#include maps\_hud_util;
#include common_scripts\utility;
#include maps\gulag_code;
#include maps\_specialops;

#include pix\_common_scripts;

main()
{
	//ORIGINAL
	gulag_destructible_volumes = GetEntArray("gulag_destructible_volume","targetname");
	mask_destructibles_in_volumes(gulag_destructible_volumes);
	mask_interactives_in_volumes(gulag_destructible_volumes);
	maps\createfx\gulag_audio::main();
	set_default_start("so_showers");
	add_start("so_showers",::start_so_showers_timed,"SpecialOps: Showers");
	maps\_drone_ai::init();
	maps\gulag_precache::main();
	maps\createart\gulag_fog::main();
	maps\gulag_fx::main();
	maps\_load::main();
	maps\_slowmo_breach::slowmo_breach_init();
	level._effect["breach_door"] = LoadFX("explosions/breach_wall_concrete");
	maps\gulag_anim::gulag_anim();
	maps\_nightvision::main(level.players);
	PreCacheItem("smoke_grenade_american");
	PreCacheItem("armory_grenade");
	PreCacheItem("m4m203_reflex_arctic");
	PreCacheItem("f15_sam");
	PreCacheItem("sam");
	PreCacheItem("slamraam_missile");
	PreCacheItem("slamraam_missile_guided");
	PreCacheItem("stinger");
	PreCacheItem("cobra_seeker");
	PreCacheItem("rpg_straight");
	PreCacheItem("cobra_Sidewinder");
	PreCacheItem("m14_scoped");
	PreCacheItem("claymore");
	PreCacheItem("mp5_silencer_reflex");
	PreCacheTurret("heli_spotlight");
	PreCacheTurret("player_view_controller");
	PreCacheItem("fraggrenade");
	PreCacheItem("flash_grenade");
	PreCacheItem("claymore");
	precachemodel("viewhands_player_udt");
	precachemodel("viewhands_udt");
	PreCacheModel("com_emergencylightcase_blue");
	PreCacheModel("gulag_price_ak47");
	PreCacheModel("com_emergencylightcase_orange");
	PreCacheModel("com_emergencylightcase_blue_off");
//	PreCacheModel("rappelrope100_le_obj");
	PreCacheModel("com_drop_rope_obj");
	PreCacheModel("com_blackhawk_spotlight_on_mg_setup");
	PreCacheModel("com_blackhawk_spotlight_on_mg_setup_3x");
	PreCacheModel("vehicle_slamraam_launcher_no_spike");
	PreCacheModel("vehicle_slamraam_missiles");
	PreCacheModel("projectile_slamraam_missile");
	PreCacheModel("tag_turret");
	PreCacheModel("me_lightfluohang_double_destroyed");
	PreCacheModel("me_lightfluohang_single_destroyed");
	PreCacheModel("ma_flatscreen_tv_wallmount_broken_01");
	PreCacheModel("ma_flatscreen_tv_wallmount_broken_02");
	PreCacheModel("com_tv2_d");
	PreCacheModel("com_tv1");
	PreCacheModel("com_tv2");
	PreCacheModel("com_tv1_testpattern");
	PreCacheModel("com_tv2_testpattern");
	PreCacheModel("com_locker_double_destroyed");
	PreCacheModel("ch_street_wall_light_01_off");
	PreCacheModel("dt_mirror_dam");	
	PreCacheModel("dt_mirror_des");	
	loadfx("explosions/tv_flatscreen_explosion");
	loadfx("misc/light_fluorescent_single_blowout_runner");
	loadfx("misc/light_fluorescent_blowout_runner");
	loadfx("props/locker_double_des_01_left");
	loadfx("props/locker_double_des_02_right");
	loadfx("props/locker_double_des_03_both");
	loadfx("misc/no_effect");
	loadfx("misc/light_blowout_swinging_runner");
	loadfx("props/mirror_dt_panel_broken");
	loadfx("props/mirror_shatter");
	precacheshellshock("gulag_attack");
	precacheshellshock("nosound");
	level.breakables_fx["tv_explode"] = LoadFX("explosions/tv_explosion");
	thread so_handle_exterior_fx();
	thread handle_gulag_world_fx();
	level thread maps\gulag_amb::main();
	SetIgnoreMeGroup("team3","axis");
	SetIgnoreMeGroup("axis","team3");
	//ORIGINAL end
	
	
	//minimap & compass
	minimap_setup_survival("compass_map_gulag_2");
	
	
	//mod stuff
	_start_IW4SP_Survival_setup();
}

start_so_showers_timed()
{
	//DELETE ALL TRIGGERS
	ents = GetEntArray();
	for(i=0;i<ents.size;i++)
	{
		if((IsDefined(ents[i].classname))&&(GetSubStr(ents[i].classname,0,8)=="trigger_"))
		{
			ents[i] delete();
		}
	}
	
	//open gates
	//array_call(getentarray("gulag_top_gate","targetname"),::delete);
	
	//Remove placed weapons
	thread removePlacedWeapons();
}




_start_IW4SP_Survival_setup()
{
	level.waveSetup_scheme = "default";
	level.MaxBots = 26;
	
	level.bot_spawnPoints = [];
	level.bot_spawnPoints[0] = (-2672.38,-501.415,1594.13);
	level.bot_spawnPoints[1] = (-2671.47,1662.17,1868.13);
	level.bot_spawnPoints[2] = (-3282.22,93.3113,1868.13);
	pix\bot\_bot::addSpawner(2,"default",level.bot_spawnPoints[0]);//shotgun
	pix\bot\_bot::addSpawner(6,"default",level.bot_spawnPoints[0]);//smg
	pix\bot\_bot::addSpawner(18,"default",level.bot_spawnPoints[0]);//ar
	pix\bot\_bot::addSpawner(58,"default",level.bot_spawnPoints[0]);//lmg
	pix\bot\_bot::addSpawner(98,"default",level.bot_spawnPoints[0]);//riotshield
	pix\bot\_bot::addSpawner(11,"default",level.bot_spawnPoints[1]);//shotgun
	pix\bot\_bot::addSpawner(9,"default",level.bot_spawnPoints[1]);//smg
	pix\bot\_bot::addSpawner(29,"default",level.bot_spawnPoints[1]);//ar
	pix\bot\_bot::addSpawner(67,"default",level.bot_spawnPoints[1]);//lmg
	//pix\bot\_bot::addSpawner(99,"default",level.bot_spawnPoints[1]);//riotshield
	pix\bot\_bot::addSpawner(62,"default",level.bot_spawnPoints[2]);//shotgun auto
	pix\bot\_bot::addSpawner(65,"default",level.bot_spawnPoints[2]);//shotgun auto
	pix\bot\_bot::addSpawner(69,"default",level.bot_spawnPoints[2]);//shotgun auto
	pix\bot\_bot::addSpawner(77,"default",level.bot_spawnPoints[2]);//lmg
	//pix\bot\_bot::addSpawner(100,"default",level.bot_spawnPoints[2]);//riotshield
	
	
	
	pix\player\_player::addPlayers((-1736.74,-1319.58,1908.13),(0,140,0),(-1578.11,-1072.78,1908.13),(0,140,0),"usp");
	
	
	level.shopModel = "com_plasticcase_beige_big";
	
	level.WeaponShop_Unlocked_at_Wave = 5;
	level.weaponShop_Icon = "waypoint_ammo";
	level.WeaponsSetup_func = maps\so_showers_gulag::setUpWeaponShop_Weapons;
	level.weaponShop_spawnPoint = (-1809.84,1110.23,1872.13);
	level.weaponShop_spawnAngle = (0,50,0);
	level.weaponShop_refillAmmo_price = 500;
	
	level.SupportShop_Unlocked_at_Wave = 8;
	level.SupportShop_Icon = "hud_burningcaricon";
	level.SupportShop_spawnPoint = (-3652.71,1508.24,1988.13);
	level.SupportShop_spawnAngle = (0,40,0);
	

	pix\shop\_shop::addDeltaSquad(5000);
	pix\shop\_support::setUpDeltaSquad(1,(-3239.34,1554.77,1867.29));
	pix\shop\_support::setUpDeltaSquad(3,(-3239.34,1554.77,1867.29));
	pix\shop\_support::setUpDeltaSquad(129,(-3239.34,1554.77,1867.29));
	pix\shop\_support::setUpDeltaSquad(139,(-3239.34,1554.77,1867.29));
	
	pix\shop\_shop::addMortarStrike(2000,"slamraam_missile_guided");
	
	
	thread pix\_main::_start_IW4SP_Survival();
}

setUpWeaponShop_Weapons()
{
	level.weaponshop_items = [];
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AA12","aa12",900,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AA12_REDDOT","aa12_reflex",1000,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47","ak47",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_ACOG","ak47_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_GP25","ak47_grenadier",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_REDDOT","ak47_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AUG_REFLEX","aug_reflex",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AUG_SCOPE","aug_scope",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_BERETTA","beretta",400,"pistol");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_BERETTA393","beretta393",500,"pistol");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_DRAGUNOV","dragunov_arctic",1000,"sniper");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FAMAS","famas_woodland",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FAMAS_EOTECH","famas_woodland_eotech",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FAMAS_REDDOT","famas_woodland_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FLASH_GRENADE","flash_grenade",600,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FN2000_ACOG","fn2000_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FN2000_EOTECH","fn2000_eotech",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FN2000_REDDOT","fn2000_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M2FRAGGRENADE","fraggrenade",600,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_GLOCK","glock",500,"pistol");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_KRISS","kriss",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_KRISS_EOTECH","kriss_eotech",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_KRISS_REDDOT","kriss_reflex",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_BENELLI","m1014",800,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M4M203_REFLEX","m4m203_reflex_arctic",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M4","m4_grunt",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_MG4","mg4",2000,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_MP5","mp5",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_MP5_REDDOT","mp5_reflex",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_MP5_SILENCED_REDDOT","mp5_silencer_reflex",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_P90","p90",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_P90_ACOG","p90_acog",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_P90_REDDOT","p90_reflex",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_PP2000","pp2000",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RIOTSHIELD","riotshield",2000,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RPD","rpd",2000,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RPD_ACOG","rpd_acog",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RPD_REDDOT","rpd_reflex",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RPG","rpg",2000,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SPAS12","spas12",700,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_STRIKER","striker",800,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_STRIKER_REDDOT","striker_reflex",900,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TAVOR_MARS","tavor_mars",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TAVOR_REDDOT","tavor_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TAVOR_ACOG","tavor_woodland_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TAVOR_EOTECH","tavor_woodland_eotech",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TMP","tmp",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_UMP45","ump45",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_UMP45_ACOG","ump45_acog",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_UMP45_EOTECH","ump45_eotech",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_UMP45_REDDOT","ump45_reflex",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_USP","usp",400,"pistol");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_USP_SILENCER","usp_silencer",400,"pistol");
	
}


















//Original Stuff
so_handle_exterior_fx()
{
	volume = getent( "gulag_exterior_fx_vol", "targetname" );

	dummy = Spawn( "script_origin", ( 0, 0, 0 ) );

	fx_array = [];
	foreach ( entFx in level.createfxent )
	{
		dummy.origin = EntFx.v[ "origin" ];

		if ( dummy IsTouching( volume ) )
		{
			fx_array[ fx_array.size ] = EntFx;
		}
    }

	flag_wait( "enable_interior_fx" );

	count = 0;
	foreach ( fx in fx_array )
	{
		fx pauseEffect();
		count++;
		if ( count > 5 )
		{
			count = 0;
			wait( 0.05 );
		}
	}
}