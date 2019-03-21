#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_hud_util;
#include maps\_specialops;
#include maps\_specialops_code;
#include maps\so_download_arcadia_code;

#include pix\_common_scripts;

main()
{
	//ORIGINAL
	so_download_arcadia_precache();
	so_download_arcadia_anims();
	maps\_stryker50cal::main("vehicle_stryker_config2");
	maps\arcadia_anim::dialog();
	so_delete_all_by_type(::type_spawn_trigger,::type_flag_trigger,::type_killspawner_trigger,::type_goalvolume);//::type_spawners
	maps\arcadia_precache::main();
	maps\createart\arcadia_art::main();
	maps\_utility::set_vision_set("arcadia_secondstreet",1);
	maps\arcadia_fx::main();
	default_start(::start_so_download_arcadia);
	maps\_load::set_player_viewhand_model("viewhands_player_us_army");
	maps\_load::main();
	common_scripts\_sentry::main();
	thread maps\arcadia_amb::main();
	run_thread_on_noteworthy("plane_sound",maps\_mig29::plane_sound_node);
	thread so_fake_choppers();
	thread so_mansion_pool();
	//ORIGINAL end
	
	//minimap & compass
	minimap_setup_survival("compass_map_arcadia");
	
	
	//mod stuff
	_start_IW4SP_Survival_setup();
}
start_so_download_arcadia()
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
	
	//Kill remaining friendlies
	friendAI = GetAIArray("allies");
	for(i=0;i<friendAI.size;i++)
	{
		friendAI[i] dodamage((friendAI[i].health*99999),(0,0,0));
	}
	
	wait 3;
	
	//Remove placed weapons
	thread removePlacedWeapons();
}

_start_IW4SP_Survival_setup()
{
	level.waveSetup_scheme = "default";
	level.MaxBots = 26;
	
	level.bot_spawnPoints = [];
	level.bot_spawnPoints[0] = (7800.04,-8371.91,2416.13);
	level.bot_spawnPoints[1] = (-740.659,-2241.88,2428.58);
	level.bot_spawnPoints[2] = (97.6457,5078.18,2378.33);
	level.bot_spawnPoints[3] = (50.556,-4901.97,2441.46);
	pix\bot\_bot::addSpawner(6,"default",level.bot_spawnPoints[0]);//lmg
	pix\bot\_bot::addSpawner(7,"default",level.bot_spawnPoints[0]);//ar
	pix\bot\_bot::addSpawner(10,"default",level.bot_spawnPoints[0]);//rpg
	pix\bot\_bot::addSpawner(12,"default",level.bot_spawnPoints[0]);//smg
	pix\bot\_bot::addSpawner(31,"default",level.bot_spawnPoints[0]);//shotgun auto
	pix\bot\_bot::addSpawner(9,"default",level.bot_spawnPoints[1]);//lmg
	pix\bot\_bot::addSpawner(8,"default",level.bot_spawnPoints[1]);//ar
	pix\bot\_bot::addSpawner(66,"default",level.bot_spawnPoints[1]);//rpg
	pix\bot\_bot::addSpawner(14,"default",level.bot_spawnPoints[1]);//smg
	pix\bot\_bot::addSpawner(38,"default",level.bot_spawnPoints[1]);//shotgun auto
	pix\bot\_bot::addSpawner(11,"default",level.bot_spawnPoints[2]);//lmg
	pix\bot\_bot::addSpawner(13,"default",level.bot_spawnPoints[2]);//ar
	pix\bot\_bot::addSpawner(77,"default",level.bot_spawnPoints[2]);//rpg
	pix\bot\_bot::addSpawner(15,"default",level.bot_spawnPoints[2]);//smg
	pix\bot\_bot::addSpawner(43,"default",level.bot_spawnPoints[2]);//shotgun auto
	pix\bot\_bot::addSpawner(16,"default",level.bot_spawnPoints[3]);//lmg
	pix\bot\_bot::addSpawner(17,"default",level.bot_spawnPoints[3]);//ar
	pix\bot\_bot::addSpawner(78,"default",level.bot_spawnPoints[3]);//rpg
	pix\bot\_bot::addSpawner(27,"default",level.bot_spawnPoints[3]);//smg
	pix\bot\_bot::addSpawner(68,"default",level.bot_spawnPoints[3]);//shotgun auto
	
	
	pix\player\_player::addPlayers((2501.57,1376.94,2268.13),(0,180,0),(2506.58,1520.69,2268.13),(0,180,0),"beretta");
	
	level.shopModel = "intel_item_laptop";
	
	level.WeaponShop_Unlocked_at_Wave = 5;
	level.weaponShop_Icon = "waypoint_ammo";
	level.WeaponsSetup_func = maps\so_download_arcadia::setUpWeaponShop_Weapons;
	level.weaponShop_spawnPoint = (-850.84,792.988,2331.13);
	level.weaponShop_spawnAngle = (0,0,0);
	level.weaponShop_refillAmmo_price = 500;
	
	level.SupportShop_Unlocked_at_Wave = 8;
	level.SupportShop_Icon = "hud_burningcaricon";
	level.SupportShop_spawnPoint = (6886.68,-10719.8,2475.13);
	level.SupportShop_spawnAngle = (0,50,0);
	

	pix\shop\_shop::addDeltaSquad(5000);
	pix\shop\_support::setUpDeltaSquad(0,(7071.05,-10416.3,2430.13));
	pix\shop\_support::setUpDeltaSquad(1,(7071.05,-10416.3,2430.13));
	pix\shop\_support::setUpDeltaSquad(2,(7071.05,-10416.3,2430.13));
	pix\shop\_support::setUpDeltaSquad(3,(7071.05,-10416.3,2430.13));
	
	pix\shop\_shop::addMortarStrike(2000,"rpg_player");
	
	
	thread pix\_main::_start_IW4SP_Survival();
}

setUpWeaponShop_Weapons()
{
	level.weaponshop_items = [];
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47","ak47",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_REDDOT","ak47_reflex",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_ACOG","ak47_digital_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_EOTECH","ak47_digital_eotech",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_AK47_SHOTGUN","ak47_shotgun",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_BERETTA","beretta",400,"pistol");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FAL_ACOG","fal_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FAL_SHOTGUN","fal_shotgun",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_FLASH_GRENADE","flash_grenade",600,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M2FRAGGRENADE","fraggrenade",600,"equipment");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_KRISS","kriss",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_KRISS_REDDOT","kriss_reflex",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_BENELLI","m1014",800,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_BENELLI_EOTECH","m1014_eotech",900,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_BENELLI_REDDOT","m1014_reflex",900,"shotgun");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M16","m16_basic",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M16_ACOG","m16_acog",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M16_GL","m16_grenadier",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M240","m240",2000,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M240_ACOG","m240_acog",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M240_REDDOT","m240_reflex",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M4","m4_grunt",1000,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_M4M203","m4_grenadier",1200,"assault_rifle");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_MP5","mp5",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_P90","p90",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_P90_ACOG","p90_acog",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_P90_EOTECH","p90_eotech",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_P90_REDDOT","p90_reflex",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_PP2000","pp2000",700,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RPD","rpd",2000,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RPD_ACOG","rpd_acog",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RPD_REDDOT","rpd_reflex",2200,"lmg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_RPG","rpg",2000,"equipment");
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
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_UMP45_ACOG","ump45_digital_acog",800,"smg");
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_UMP45_EOTECH","ump45_digital_eotech",800,"smg");
}











//Original Stuff
so_download_arcadia_precache()
{
	PrecacheItem( "m79" );
	PrecacheItem( "claymore" );
	
	PrecacheModel( "mil_wireless_dsm" );
	PrecacheModel( "mil_wireless_dsm_obj" );
	PrecacheModel( "com_laptop_rugged_open" );
	
	precacheShader( "dpad_laser_designator" );
}
so_fake_choppers()
{
	choppers = getentarray( "fake_creek_chopper", "targetname" );
	array_call( choppers, ::Delete );

	choppers = getentarray( "fake_golf_course_chopper", "targetname" );
	array_call( choppers, ::Delete );

	choppers = getentarray( "checkpoint_fake_chopper", "targetname" );
	array_call( choppers, ::Hide );

	foreach ( chopper in choppers )
	{
		chopper.destination = getstruct( chopper.target, "targetname" );
		chopper.origin = chopper.origin + ( 0, 0, -2000 );

		if ( chopper.origin[ 0 ] < 20000 )
		{
			chopper.origin = ( 20000, chopper.origin[ 1 ] + 10000, chopper.origin[ 2 ] );
		}
	}

	min_delay = 3;
	max_delay = 5;
	min_speed = 1000;
	max_speed = 1300;
	diff_speed = max_speed - min_speed;
	max_pitch = 15;
	min_pitch = 5;
	diff_pitch = max_pitch - min_pitch;
	level.chopper_max_count = 10;
	level.chopper_count = 0;
	
	while ( 1 )
	{
		choppers = array_randomize( choppers );

		foreach ( idx, chopper in choppers )
		{
			if ( level.chopper_count < level.chopper_max_count )
			{
				d = Distance( chopper.origin, chopper.destination.origin );
				speed = RandomIntRange( 1000, 1600 );
				move_time = d / speed;
	
				percent = 1 - ( max_speed - speed ) / diff_speed;
				pitch = ( diff_pitch * percent ) + min_pitch;
	
				chopper.angles = ( pitch, chopper.angles[ 1 ], chopper.angles[ 2 ] );
				chopper thread so_fake_chopper_create_and_move( move_time, chopper.destination.origin );
			}

			wait( RandomFloatRange( min_delay, max_delay ) );
		}
	}
}
#using_animtree( "vehicles" );
so_fake_chopper_create_and_move( moveTime, destination )
{	
	assert( isdefined( moveTime ) );
	assert( moveTime > 0 );
	assert( isdefined( destination ) );
	
	chopper = spawn( "script_model", self.origin );
	chopper endon( "delete" );

	level.chopper_count++;

	chopper PlayLoopSound( "veh_helicopter_loop" );
	
	chopper.angles = self.angles;

	chopper thread so_fake_chopper_tilt();
	
	chopperModel[ 0 ] = "vehicle_blackhawk_low";
	chopperModel[ 1 ] = "vehicle_pavelow_low";
	chopper setModel( chopperModel[ randomint( chopperModel.size ) ] );
	
	chopper useAnimTree( #animtree );
	chopper setanim( %bh_rotors, 1, .2, 1 );
	
	chopper moveto( destination, moveTime, 0, 0 );
	wait moveTime;
	chopper delete();

	level.chopper_count--;
}
so_fake_chopper_tilt()
{
	self endon( "death" );
	start_angle = self.angles;

	while ( 1 )
	{
		time = RandomFloatRange( 2, 3 );
		pitch = start_angle[ 0 ] + RandomFloatRange( -5, 5 );
		yaw = start_angle[ 1 ] + RandomFloatRange( -7, 7 );
		roll = start_angle[ 2 ]  + RandomFloatRange( -10, 10 );

		self RotateTo( ( pitch, yaw, roll ), time, time * 0.5, time * 0.5 );
		wait( time );
	}
}
so_download_arcadia_anims()
{
	// "There are several ruggedized laptops in your AO that contain high-value information."
	level.scr_radio[ "so_dwnld_hqr_laptops" ] = "so_dwnld_hqr_laptops";
	
	// "Download the data from each of the laptops, then return to the Stryker for extraction."
	level.scr_radio[ "so_dwnld_hqr_downloaddata" ] = "so_dwnld_hqr_downloaddata";
	
	
	// "All Hunter units, Badger One will not engage targets without your explicit authorization."
	level.scr_radio[ "so_dwnld_stk_explicitauth" ] = "so_dwnld_stk_explicitauth";
	
	// "Hunter Two-One, I repeat, Badger One is not authorized to engage targets that you haven't designated."
	level.scr_radio[ "so_dwnld_stk_designated" ] = "so_dwnld_stk_designated";
	
	// "Hunter Two-One, we can't fire on enemies without your authorization!"
	level.scr_radio[ "so_dwnld_stk_cantfire" ] = "so_dwnld_stk_cantfire";
	
	
	// "Hunter Two-One, ten-plus foot-mobiles approaching from the east!"
	level.scr_radio[ "so_dwnld_stk_tenfootmobiles" ] = "so_dwnld_stk_tenfootmobiles";
	
	// "We've got activity to the west, they're coming from the light brown mansion!"
	level.scr_radio[ "so_dwnld_stk_brownmansion" ] = "so_dwnld_stk_brownmansion";
	
	// "Hostiles spotted across the street, they're moving to your position!"
	level.scr_radio[ "so_dwnld_stk_acrossstreet" ] = "so_dwnld_stk_acrossstreet";
	
	// "Hunter Two-One, you got movement right outside your location!"
	level.scr_radio[ "so_dwnld_stk_gotmovement" ] = "so_dwnld_stk_gotmovement";
	
	
	// "Hunter Two-One, there are hostiles in the area that can wirelessly disrupt the data transfer."
	level.scr_radio[ "so_dwnld_hqr_wirelesslydisrupt" ] = "so_dwnld_hqr_wirelesslydisrupt";
	
	// "Hunter Two-One, the download has been interrupted! You'll have to restart the data transfer manually."
	level.scr_radio[ "so_dwnld_hqr_restartmanually" ] = "so_dwnld_hqr_restartmanually";
	
	// "Hunter Two-One, hostiles have interrupted the download! Get back there and manually resume the transfer!"
	level.scr_radio[ "so_dwnld_hqr_getbackrestart" ] = "so_dwnld_hqr_getbackrestart";
	
	
	// "Good job, Hunter Two-One. Our intel indicates that there are two more laptops in the area - go find them and get their data."
	level.scr_radio[ "so_dwnld_hqr_gofindthem" ] = "so_dwnld_hqr_gofindthem";
	
	// "Stay frosty, Hunter Two-One, there's one laptop left."
	level.scr_radio[ "so_dwnld_hqr_onelaptop" ] = "so_dwnld_hqr_onelaptop";
	
	
	// "Nice work, Hunter Two-One. Now get back to the Stryker, we're pulling you out of the area."
	level.scr_radio[ "so_dwnld_hqr_pullingyouout" ] = "so_dwnld_hqr_pullingyouout";
	
	// "Hunter Two-One, get back to the Stryker for extraction!"
	level.scr_radio[ "so_dwnld_hqr_extraction" ] = "so_dwnld_hqr_extraction";
	
	// "Hunter Two-One, return to the Stryker to complete your mission!"
	level.scr_radio[ "so_dwnld_hqr_completemission" ] = "so_dwnld_hqr_completemission";
}
so_mansion_pool()
{
	foreach ( player in level.players )
	{
		player.so_in_water = false;
		player thread waterfx();
	}

	trigger = getent( "pool", "targetname" );
	
	while ( 1 )
	{
		trigger waittill( "trigger" );

		players_touching = [];
		foreach ( player in level.players )
		{
			if ( player IsTouching( trigger ) && !player.so_in_water )
			{
				player thread so_mansion_pool_internal( trigger );
			}
		}

		wait( 0.5 );
	}
}
so_mansion_pool_internal( trigger )
{
	self.so_in_water = true;
	while ( self IsTouching( trigger ) )
	{
		self SetMoveSpeedScale( 0.3 );
		self AllowStand( true );
		self AllowCrouch( false );
		self AllowProne( false );

		wait( 0.1 );
	}

	self SetMoveSpeedScale( 1 );
	self AllowStand( true );
	self AllowCrouch( true );
	self AllowProne( true );
	self.so_in_water = false;
}