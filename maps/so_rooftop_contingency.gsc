#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_specialops;
#include maps\_hud_util;
#include maps\_vehicle;
#include maps\so_rooftop_contingency_code;

#include pix\_common_scripts;
//use predator???
main()
{
	//ORIGINAL
	SetSavedDvar( "sm_sunShadowScale", 0.5 );
	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1.5 );
	SetSavedDvar( "r_lightGridContrast", 0 );
	PreCacheItem( "remote_missile_snow" );
	level.visionThermalDefault = "contingency_thermal_inverted";
	level.VISION_UAV = "contingency_thermal_inverted";
	SetThermalBodyMaterial( "thermalbody_snowlevel" );
	level.friendly_thermal_Reflector_Effect = LoadFX( "misc/thermal_tapereflect" );
	PreCacheItem( "remote_missile_not_player" );
	PreCacheModel( "com_computer_keyboard_obj" );
	PrecacheNightvisionCodeAssets();
	so_delete_all_by_type( ::type_spawn_trigger );
	default_start( ::start_so_rooftop );
	maps\_bm21_troops::main( "vehicle_bm21_mobile_cover_snow" );
	maps\_uaz::main( "vehicle_uaz_winter_destructible", "uaz_physics" );
	maps\_uaz::main( "vehicle_uaz_winter_destructible" );
	maps\_ucav::main( "vehicle_ucav" );
	maps\contingency_precache::main();
	maps\createart\contingency_fog::main();
	maps\contingency_fx::main();
	maps\contingency_anim::main_anim();
	maps\_load::main();
	maps\_load::set_player_viewhand_model( "viewhands_player_arctic_wind" );
	thread maps\contingency_amb::main();
	maps\createart\contingency_art::main();
	level.remote_detonator_weapon = "remote_missile_detonator";
	PreCacheItem( level.remote_detonator_weapon );
	//maps\_remotemissile::init_radio_dialogue();
	vehicles = GetEntArray( "destructible_vehicle", "targetname" );
	foreach(vehicle in vehicles)
	{
		vehicle thread destructible_damage_monitor();
	}
	//ORIGINAL end
	
	//predator drone setup
	maps\_remotemissile::init();
	level.uav = spawn_vehicle_from_targetname_and_drive("second_uav");
	level.uav playLoopSound("uav_engine_loop");
	level.uavRig = spawn("script_model",level.uav.origin);
	level.uavRig setmodel("tag_origin");
	thread UAVRigAiming();
	
	//minimap & compass
	minimap_setup_survival("compass_map_contingency");
	
	//Mod Stuff
	_start_IW4SP_Survival_setup();
}
UAVRigAiming()
{
	focus_points = GetEntArray("uav_focus_point","targetname");
	level.uav endon("death");
	for(;;)
	{
		closest_focus = getClosest(level.player.origin,focus_points);
		targetPos = closest_focus.origin;
		angles = VectorToAngles(targetPos-level.uav.origin);
		level.uavRig MoveTo(level.uav.origin,0.10,0,0);
		level.uavRig RotateTo(ANGLES,0.10,0,0);
		wait 0.05;
	}
}
start_so_rooftop()
{
	//Remove predator controller & open submarine door
	GetEnt("uav_controller","targetname") delete();
	GetEnt("hatch_model_collision","targetname") delete();
	GetEnt("hatch_model","targetname") delete();
	
	//DELETE ALL TRIGGERS
	ents = GetEntArray();
	for(i=0;i<ents.size;i++)
	{
		if((IsDefined(ents[i].classname))&&(GetSubStr(ents[i].classname,0,8)=="trigger_"))
		{
			ents[i] delete();
		}
	}
	
	//Remove placed weapons
	thread removePlacedWeapons();
}
destructible_damage_monitor()
{
	self endon("exploded");
	while(1)
	{
		self waittill("damage",dmg,attacker,dir,point,mod,model,tagname,partname,dflags,weapon);
		if(IsPlayer(attacker))
		{
			if(IsDefined(weapon))
			{
				if(weapon=="remote_missile_snow")
				{
					self.hellfired = true;
				}
				else if(weapon=="claymore")
				{
					self.claymored = true;
				}
			}
		}
	}
}


_start_IW4SP_Survival_setup()
{
	level.waveSetup_scheme = "default_dogs";
	level.MaxBots = 26;
	
	level.bot_spawnPoints = [];
	level.bot_spawnPoints[0] = (-9495.35,2905.47,608.125);
	level.bot_spawnPoints[1] = (-12033.2,-224.112,586.598);
	level.bot_spawnPoints[2] = (-16906.9,-349.307,682.718);
	pix\bot\_bot::addSpawner(1,"default",level.bot_spawnPoints[0]);//ar
	pix\bot\_bot::addSpawner(46,"default",level.bot_spawnPoints[0]);//smg
	pix\bot\_bot::addSpawner(11,"dog",level.bot_spawnPoints[0]);//dog
	pix\bot\_bot::addSpawner(32,"default",level.bot_spawnPoints[0]);//rpg
	pix\bot\_bot::addSpawner(48,"default",level.bot_spawnPoints[0]);//lmg
	pix\bot\_bot::addSpawner(50,"default",level.bot_spawnPoints[0]);//shotgun
	pix\bot\_bot::addSpawner(72,"default",level.bot_spawnPoints[0]);//sniper
	pix\bot\_bot::addSpawner(90,"default",level.bot_spawnPoints[0]);//auto shotgun
	pix\bot\_bot::addSpawner(2,"default",level.bot_spawnPoints[1]);//ar
	pix\bot\_bot::addSpawner(3,"default",level.bot_spawnPoints[1]);//smg
	pix\bot\_bot::addSpawner(13,"dog",level.bot_spawnPoints[1]);//dog
	pix\bot\_bot::addSpawner(55,"default",level.bot_spawnPoints[1]);//rpg
	pix\bot\_bot::addSpawner(52,"default",level.bot_spawnPoints[1]);//lmg
	pix\bot\_bot::addSpawner(61,"default",level.bot_spawnPoints[1]);//shotgun
	pix\bot\_bot::addSpawner(95,"default",level.bot_spawnPoints[1]);//sniper
	pix\bot\_bot::addSpawner(4,"default",level.bot_spawnPoints[2]);//ar
	pix\bot\_bot::addSpawner(7,"default",level.bot_spawnPoints[2]);//smg
	pix\bot\_bot::addSpawner(17,"dog",level.bot_spawnPoints[2]);//dog
	pix\bot\_bot::addSpawner(65,"default",level.bot_spawnPoints[2]);//rpg
	pix\bot\_bot::addSpawner(64,"default",level.bot_spawnPoints[2]);//lmg
	pix\bot\_bot::addSpawner(85,"default",level.bot_spawnPoints[2]);//shotgun
	pix\bot\_bot::addSpawner(108,"default",level.bot_spawnPoints[2]);//sniper
	
	
	pix\player\_player::addPlayers((-13635.4,-65.4969,606.106),(0,85,0),(-13796,-28.6969,602.799),(0,85,0),"usp");
	
	
	level.shopModel = "weapon_uav_control_unit_obj";
	
	level.WeaponShop_Unlocked_at_Wave = 5;
	level.weaponShop_Icon = "waypoint_ammo";
	level.WeaponsSetup_func = maps\so_rooftop_contingency::setUpWeaponShop_Weapons;
	level.weaponShop_spawnPoint = (-13828.4,2221.17,640.125);
	level.weaponShop_spawnAngle = (0,180,0);
	level.weaponShop_refillAmmo_price = 500;
	
	level.SupportShop_Unlocked_at_Wave = 8;
	level.SupportShop_Icon = "hud_burningcaricon";
	level.SupportShop_spawnPoint = (-16166.2,957.476,939.457);
	level.SupportShop_spawnAngle = (0,40,0);
	

	pix\shop\_shop::addDeltaSquad(5000);
	pix\shop\_support::setUpDeltaSquad(0,(-13635.4,-65.4969,606.106));
	pix\shop\_support::setUpDeltaSquad(56,(-13635.4,-65.4969,606.106));
	pix\shop\_support::setUpDeltaSquad(57,(-13635.4,-65.4969,606.106));
	pix\shop\_support::setUpDeltaSquad(141,(-13635.4,-65.4969,606.106));
	
	pix\shop\_shop::addMortarStrike(7000,"remote_missile");
	
	pix\shop\_shop::addPredatorDrone(4000,"remote_missile_detonator");
	
	
	thread pix\_main::_start_IW4SP_Survival();
}

setUpWeaponShop_Weapons()
{
	level.weaponshop_items = [];
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AA12SP_EOTECH","aa12_eotech",1000,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AA12SP_REDDOT","aa12_reflex",1000,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47","ak47",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_ACOG","ak47_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_GP25","ak47_arctic_grenadier",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_REDDOT","ak47_arctic_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_EOTECH","ak47_eotech",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_SHOTGUN","ak47_shotgun",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AUG_REFLEX","aug_reflex",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AUG_SCOPE","aug_scope",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_BERETTA","beretta",400,"pistol");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_DRAGUNOV","dragunov_arctic",1000,"sniper");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FAMAS","famas_arctic",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FAMAS_REDDOT","famas_arctic_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FLASH_GRENADE","flash_grenade",600,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M2FRAGGRENADE","fraggrenade",600,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_KRISS","kriss",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_KRISS_EOTECH","kriss_eotech",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_KRISS_REDDOT","kriss_reflex",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_BENELLI","m1014",800,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M16_ACOG","m16_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M16_GL","m16_grenadier",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M16_REDDOT","m16_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M14EBR_SCOPED_SILENCED","m21_scoped_arctic_silenced",1000,"sniper");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M240_ACOG","m240_acog",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M240_HEARTBEAT","m240_heartbeat_reflex_arctic",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M4M203_ACOG","m4m203_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M4M203_EOTECH","m4m203_eotech",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M4M203_REFLEX","m4m203_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M4M203","m4_grenadier",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M4","m4_grunt",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_MASADA","masada",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_MASADA_ACOG","masada_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_MASADA_REDDOT","masada_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_MG4","mg4",2000,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_P90","p90",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_P90_ACOG","p90_acog",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RPG","rpg",2000,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SCAR","scar_h",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SCAR_ACOG","scar_h_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SCAR_REDDOT","scar_h_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SCAR_SHOTGUN","scar_h_shotgun",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SPAS12","spas12",700,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SPAS12_EOTECH","spas12_eotech",800,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_SPAS12_REDDOT","spas12_reflex",800,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TAVOR_ACOG","tavor_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_TAVOR_MARS","tavor_mars",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_UMP45","ump45_arctic",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_UMP45_REDDOT","ump45_reflex",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_USP","usp",400,"pistol");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_USP_SILENCER","usp_silencer",400,"pistol");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_BARRETT","barrett",1000,"sniper");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_DESERTEAGLE","deserteagle",400,"pistol");
}