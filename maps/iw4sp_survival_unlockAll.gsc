#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_hud_util;
#include common_scripts\utility;

#include pix\_common_scripts;

main()
{
	friendlyfire_warnings_off();
	setDvarIfUninitialized( "trainer_debug", "0" );
	setsaveddvar( "r_lightGridEnableTweaks", 1 );
	setsaveddvar( "r_lightGridIntensity", 1.2 );
	setsaveddvar( "r_lightGridContrast", 0 );
	default_start( ::start_default );
	init_precache();
	maps\createart\trainer_fog::main();
	maps\trainer_precache::main();
	maps\createfx\trainer_audio::main();
	maps\trainer_fx::main();
	maps\_drone_ai::init();
	maps\_load::main();	
	maps\_compass::setupMiniMap("compass_map_trainer");
	thread maps\trainer_amb::main();
	maps\trainer_anim::main();
	
	
	flag_init( "start_anims" );
	
	//Remove Gates
	array_call(getentarray("gate_cqb_enter","targetname"),::Delete);
	array_call(getentarray("gate_cqb_exit","targetname"),::Delete);
	array_call(getentarray("gate_cqb_enter_main","targetname"),::Delete);
	array_call(getentarray("so_gate","targetname"),::Delete);
	
	//Remove Blockers
	end_blockers = getent("end_blockers","targetname");
	end_blockers hide_entity();
	blocker_range = getent("blocker_range","targetname");
	blocker_range hide_entity();
	course_end_blocker = getent("course_end_blocker","targetname");
	course_end_blocker hide_entity();
	
	//Remove pit cases
	level.pit_case_01 = getent("pit_case_01","targetname");
	level.pit_case_02 = getent("pit_case_02","targetname");
	level.pit_case_01 delete();
	level.pit_case_02 delete();
	
	//populate map and allow friendlyfire
	level thread populate_map();
	level.friendlyFireDisabled = 1;
	
	thread music();
}


start_default()
{
	getPlayer1() setOrigin((-2609.23,4987.78,-55.975));
	getPlayer1() setPlayerAngles((0,-90,0));
	if(is_coop())
	{
		getPlayer2() setOrigin((-2746.46,4944.2,-55.975));
		getPlayer2() setPlayerAngles((0,-90,0));
	}
	foreach(player in getPlayers())
	{
		player thread initButtons();
		player.isUnlockingAll = false;
		player.unlockedAll = false;
		player thread unlockall_loop();
	}
	level.UnlockAll_notify = createServerText("hudBig",1.0,"CENTER","TOP",0,20,0,(1,1,1),0,(0.3,0.6,0.3),1,"Press [{+actionslot 2}] to Unlock All!");
	level.UnlockAll_notify elemFadeOverTime(.7,1);
	level.UnlockAll_notify SetPulseFX(100, int(6*1000), 1000);
	wait 8;
	level.UnlockAll_notify destroy();
}
unlockall_loop()
{
	for(;;)
	{
		if(!self.isUnlockingAll && !self.unlockedAll)
		{
			if(self isButtonPressed("+actionslot 2"))
			{
				self thread unlock_all_achiev();
				wait .6;
			}
		}
		wait 0.05;
	}
}
unlock_all_achiev()
{
	self.isUnlockingAll = true;
	useBar = createClientProgressBar( self, 25 );
	progress = 0;
	missionString = self GetLocalPlayerProfileData( "missionHighestDifficulty" );
	newString = "";
	Achievement = strTok("BACK_IN_THE_SADDLE|DANGER_CLOSE|COLD_SHOULDER|TAGEM_AND_BAGEM|ROYAL_WITH_CHEESE|SOAP_ON_A_ROPE|DESPERATE_TIMES|HOUSTON_WE_HAVE_A_PROBLEM|THE_PAWN|OUT_OF_THE_FRYING_PAN|FOR_THE_RECORD|THE_PRICE_OF_WAR|FIRST_DAY_OF_SCHOOL|BLACK_DIAMOND|TURISTAS|RED_DAWN|PRISONER_627|ENDS_JUSTIFY_THE_MEANS|HOME_COMING|QUEEN_TAKES_ROOK|OFF_THE_GRID|PIT_BOSS|GHOST|HOUSTON_WE_HAVE_A_PROBLEM|COLONEL_SANDERSON|GOLD_STAR|HOTEL_BRAVO|CHARLIE_ON_OUR_SIX|IT_GOES_TO_ELEVEN|OPERATIONAL_ASSET|BLACKJACK|HONOR_ROLL|OPERATIVE|SPECIALIST|PROFESSIONAL|STAR_69|THREESOME|DOWNED_BUT_NOT_OUT|NO_REST_FOR_THE_WARY|IM_THE_JUGGERNAUT|ONE_MAN_ARMY|TEN_PLUS_FOOT_MOBILES|UNNECESSARY_ROUGHNESS|KNOCK_KNOCK|LOOK_MA_TWO_HANDS|SOME_LIKE_IT_HOT|TWO_BIRDS_WITH_ONE_STONE|THE_ROAD_LESS_TRAVELED|LEAVE_NO_STONE_UNTURNED|DRIVE_BY|THE_HARDER_THEY_FALL", "|" );
	for ( index = 0;index < missionString.size;index++ )
	{
		if( index < 20 ) newString += "44";
		else newString += 0;
	}
	if(self GetLocalPlayerProfileData( "highestMission" ) != 25) 
		self SetLocalPlayerProfileData( "highestMission", 25 );
	if(self GetLocalPlayerProfileData( "cheatPoints" ) != 45) 
		self SetLocalPlayerProfileData( "cheatPoints", 45 );
	if(self GetLocalPlayerProfileData( "missionHighestDifficulty" ) != newString) 
		self SetLocalPlayerProfileData( "missionHighestDifficulty", newString );
	if(self GetLocalPlayerProfileData( "PercentCompleteSO" ) != 69) 
		self SetLocalPlayerProfileData( "PercentCompleteSO", 69 );
	if(self GetLocalPlayerProfileData( "percentCompleteSP" ) != 10000) 
		self SetLocalPlayerProfileData( "percentCompleteSP", 10000 );
	if(self GetLocalPlayerProfileData( "percentCompleteMP" ) != 1100) 
		self SetLocalPlayerProfileData( "percentCompleteMP", 1100 );
	if(self GetLocalPlayerProfileData( "missionsohighestdifficulty" ) != "44444444444444444444444444444444444444444444444444")
		self SetLocalPlayerProfileData( "missionsohighestdifficulty", "44444444444444444444444444444444444444444444444444" );
	for( s = 0; s <= Achievement.size; s++ )
	{
		//self thread player_giveachievement_wrapper( Achievement[s] );
		progress++;
		percent = ceil( (progress/50) * 100 );
		useBar updateBar( percent / 100 );
		wait 0.5;
	}
	useBar destroyElem();
	UpdateGamerProfile();
	self.isUnlockingAll = false;
	self.unlockedAll = true;
}
init_precache()
{
	precacheModel( "weapon_binocular" );
	precachemodel( "mil_grenade_box_opened" );
	precachemodel( "adrenaline_syringe_animated" );
	precachemodel( "clotting_powder_animated" );
	precacheModel( "com_bottle2" );
	precacheModel( "viewmodel_desert_eagle" );
	precacheshader( "black" );
	precacheModel( "weapon_m67_grenade_obj" );
	precacheModel( "prop_price_cigar" );
	PreCacheModel( "electronics_pda" );
	precacheModel( "weapon_m4" );
	precacheModel( "weapon_m4_clip" );
	precacheModel( "characters_accessories_pencil" );
	precacheModel( "mil_mre_chocolate01" );
	precacheModel( "weapon_desert_eagle_tactical_obj" );
	precacheModel( "weapon_m4_obj" );
	//precacheModel( "weapon_m4_obj" );
	precacheShader( "objective" );
	precacheShader( "hud_icon_c4" );
	precacheShader( "hud_dpad" );
	precacheShader( "hud_arrow_right" );
	precacheShader( "hud_arrow_down" );
	precacheShader( "hud_icon_40mm_grenade" );
	precacheshader( "popmenu_bg" );
}


populate_map()
{
	aVehicleSpawners = maps\_vehicle::_getvehiclespawnerarray();
	array_thread( aVehicleSpawners, ::add_spawn_function, ::vehicle_think );
	array_thread( getentarray( "ai_ambient", "script_noteworthy" ), ::add_spawn_function, ::ai_ambient_noprop_think );
	array_spawn_function_noteworthy( "patrol", ::AI_patrol_think );
	array_spawn_function_noteworthy( "runners", ::AI_runners_think );
	
	level.foley = spawn_targetname( "foley", true );
	level.foley.animname = "foley";
	level.foley.animnode = getent( "node_foley", "targetname" );
	level.foley forceUseWeapon( "m4_grunt", "primary" );
	level.traineeanimnode = spawn( "script_origin", ( 0, 0, 0 ) );
	level.traineeanimnode.origin = level.foley.animnode.origin;
	level.traineeanimnode.angles = level.foley.animnode.angles;
	level.translatoranimnode = spawn( "script_origin", ( 0, 0, 0 ) );
	level.translatoranimnode.origin = level.foley.animnode.origin;
	level.translatoranimnode.angles = level.foley.animnode.angles;
	level.trainees = array_spawn( getentarray( "trainees", "targetname" ), true );
	level.translator = spawn_script_noteworthy( "translator", true );
	level.translator gun_remove();
	level.translator.animname = "translator";
	level.trainee_01 = spawn_script_noteworthy( "trainee_01", true );
	level.trainee_01.animname = "trainee_01";
	level.translatoranimnode thread anim_loop_solo( level.translator, "training_intro_begining", "stop_idle" );		//loop forever
	level.traineeanimnode thread anim_loop_solo( level.trainee_01, "training_intro_begining", "stop_idle" );		//loop forever
	level.foley.animnode thread anim_first_frame_solo( level.foley, "training_intro_begining" );
	level.aRangeActors = [];
	level.aRangeActors[ 0 ] = level.foley;
	level.aRangeActors[ 1 ] = level.translator;
	level.aRangeActors[ 2 ] = level.trainee_01;
	level.aRangeActors = array_merge( level.aRangeActors, level.trainees );
	
	
	level.ambientai = array_spawn( getentarray( "friendlies_ambient", "targetname" ), true );
	thread bridge_layer_think();
	level.basketball_guys = array_spawn( getentarray( "friendlies_basketball", "targetname" ), true );
	thread AI_runner_group_think( "runner_group_01" );
	thread AI_runner_group_think( "runner_group_02" );
	thread ambient_vehicles();
}


vehicle_think()
{
	switch( self.vehicletype )
    {
		case "humvee":
		case "hummer_minigun":
		case "hummer":
   			self thread vehicle_humvee_think();
    		break;
    	case "m1a1":
    		self thread vehicle_m1a1_think();
    		break;
    	case "cobra":
    		self thread vehicle_cobra_think();
    		break;
    }
}
vehicle_humvee_think(){}
vehicle_m1a1_think(){}
vehicle_cobra_think(){}

AI_patrol_think()
{
	self endon( "death" );
	self pushplayer( true );
	self.walkdist = 1000;
	self.disablearrivals = true;
	wait( 0.1 );
	self thread maps\_patrol::patrol();
	level.patrolDudes[ level.patrolDudes.size ] = self;
}
AI_runners_think()
{
	self gun_remove();
	self.runanim = level.scr_anim[ "generic" ][ self.animation ];
}
AI_runner_group_think( spawnerTargetname )
{
	spawners = getentarray( spawnerTargetname, "targetname" );
	runners = undefined;
	while ( true )
	{
		runners = array_spawn( spawners, true );
		waittill_dead( runners );
	}
}
bridge_layer_think()
{
	bridge_layer = getent( "bridge_layer", "targetname" );
	bridge_layer_bridge = getent( "bridge_layer_bridge", "targetname" );

	bridge_layer.animname = "bridge_layer";
	bridge_layer assign_animtree();
	bridge_layer_bridge.animname = "bridge_layer_bridge";
	bridge_layer_bridge assign_animtree();

	animOrg = spawn( "script_origin", ( 0, 0, 0 ) );
	animOrg.origin = bridge_layer.origin;
	animOrg.angles = bridge_layer.angles;
	
	animOrg thread anim_first_frame_solo( bridge_layer, "bridge_raise" );
	animOrg anim_first_frame_solo( bridge_layer_bridge, "bridge_raise" );

	bridge_layer playloopsound( "m1a1_abrams_idle_low" );
	
	//flag_wait( "player_passing_barracks" );
	
	animOrg thread anim_single_solo( bridge_layer, "bridge_raise" );
	animOrg anim_single_solo( bridge_layer_bridge, "bridge_raise" );
	
}
ambient_vehicles()
{
	
	thread spawn_vehicles_from_targetname_and_drive( "heli_group_01" );
	
	pavelows = spawn_vehicles_from_targetname_and_drive( "pavelow_group_01" );
	array_call( pavelows,::Vehicle_TurnEngineOff );
	//thread spawn_vehicles_from_targetname_and_drive( "f15_takeoff_01" );
	
	flag_wait( "player_leaving_range" );
	thread spawn_vehicles_from_targetname_and_drive( "f15_flyby_01" );

}

ai_ambient_think( sAnim, sFailSafeFlag )
{	
	self endon( "death" );
	self AI_ambient_ignored(); 
	eGoal = undefined;
	sAnimGo = undefined;
	looping = false;
	/*-----------------------
	DOES AI HAVE A GOAL NODE?
	-------------------------*/	
	if ( isdefined( self.target ) )
		eGoal = getnode( self.target, "targetname" );
	
	/*-----------------------
	CLEANUP PROPS AND ANIMATION NODE WHEN DEAD
	-------------------------*/	
	self thread ai_ambient_cleanup();

	/*-----------------------
	GO AHEAD AND PLAY LOOPING IDLE (IF ANIM IS LOOPING)
	-------------------------*/	
	if ( isarray( level.scr_anim[ "generic" ][ sAnim ] ) )
	{
		looping = true;
		
		if ( sAnim == "training_basketball_guy2" )
		{
			basketball = getent( "basketball", "targetname" );
			basketball.animname = "basketball";
			basketball assign_animtree();
			self.eAnimEnt thread anim_loop_solo( basketball, "training_basketball_loop", "stop_idle" );
		}

		self.eAnimEnt thread anim_generic_loop( self, sAnim, "stop_idle" );
		sAnimGo = sAnim + "_go";	//This will be the next animation to play after the loop (if defined)
		if ( anim_exists( sAnimGo ) )
			sAnim = sAnimGo;
		else
			sAnimGo = undefined;
	}
	/*-----------------------
	FREEZE FRAME AT START OF ANIM (IF IT'S NOT A LOOP)
	-------------------------*/	
	else
		self.eAnimEnt anim_generic_first_frame( self, sAnim );

	/*-----------------------
	WAIT FOR A FLAG (IF DEFINED IN THE SPAWNER) THEN PLAY ANIM
	-------------------------*/	
	if ( isdefined( self.script_flag ) )
	{
		if ( isdefined( sFailSafeFlag ) )
			flag_wait_either( self.script_flag, sFailSafeFlag );
		else
			flag_wait( self.script_flag );
		
	}
	
	
	/*-----------------------
	IF HEADED TO A GOAL NODE LATER....
	-------------------------*/	
	if ( isdefined( eGoal ) )
	{
		self.disablearrivals = true;
		self.disableexits = true;
	}
	
	if ( !looping ) 
		self.eAnimEnt anim_generic( self, sAnim );
		
	if ( isdefined( sAnimGo ) )
	{
		self.eAnimEnt notify( "stop_idle" );
		self.eAnimEnt anim_generic( self, sAnimGo );
	}

	/*-----------------------
	DO CUSTOM SHIT BASED ON ANIMNAME
	-------------------------*/	
	switch( sAnim )
	{
		case "civilian_run_2_crawldeath":
			self kill();
			break;
	}
	
	/*-----------------------
	FINISH ANIM THEN RUN TO A NODE
	-------------------------*/	
	if ( isdefined( eGoal ) )
	{
		self setgoalnode( eGoal );
		wait( 1 );
		self.disablearrivals = false;
		self.disableexits = false;
		self waittill( "goal" );
		if ( isdefined( self.cqbwalking ) && self.cqbwalking )
			self cqb_walk( "off" );
	}
	
	/*-----------------------
	FINISH ANIM THEN PLAY LOOPING IDLE
	-------------------------*/	
	else if ( isdefined( level.scr_anim[ "generic" ][ sAnim + "_idle" ] ) )
		self.eAnimEnt thread anim_generic_loop( self, sAnim + "_idle", "stop_idle" );
		
	/*-----------------------
	PLAY MORTAR REACTIONS IF AVAILABLE
	-------------------------*/	
	if ( anim_exists( sAnim + "_react" ) )
	{
		if ( !looping )
			sAnim = sAnim + "_idle";
		sAnimReact = sAnim + "_react";
		
		if ( anim_exists( sAnim + "_react2" ) )
			sAnimReact2 = sAnim + "_react2";
		else
			sAnimReact2 = sAnimReact;
		while( isdefined( self ) )
		{
			level waittill( "mortar_hit" );
			self.eAnimEnt notify( "stop_idle" );
			self notify ( "stop_idle" );
			waittillframeend;
			if ( RandomInt( 100 ) > 50 )
				anim_generic( self, sAnimReact );
			else
				anim_generic( self, sAnimReact2 );
			thread anim_generic_loop( self, sAnim, "stop_idle" );
			
		}
	}
}


ai_ambient_cleanup()
{
	self waittill( "death" );
	if ( ( isdefined( self.eAnimEnt ) ) && ( !isspawner( self.eAnimEnt ) ) )
		self.eAnimEnt delete();
			
}
ai_ambient_noprop_think()
{
	/*-----------------------
	GLOBAL SCRIPT TO HANDLE ALL AMMBIENT GUYS
	-------------------------*/	
	self endon( "death" );
	assert( isdefined( self.animation ) );	//must be defined in the spawner
	sAnim = self.animation;
	bSpecial = false;
	if ( !isdefined( self.eAnimEnt ) )
		self.eAnimEnt = self.spawner;
	
	sFailSafeFlag = undefined;
	/*-----------------------
	SPECIAL CASES
	-------------------------*/	
	switch( sAnim )
	{
		case "training_humvee_repair":
			self thread mechanic_sound_loop();
			self gun_remove();
			break;
		case "roadkill_humvee_map_sequence_quiet_idle":
			self attach( "characters_accessories_pencil", "TAG_INHAND", 1 );
			self gun_remove();
			break;
		case "training_locals_kneel":
			//this particular guy needs his weapon attached to chest
			self gun_remove();
			self.m4 = spawn( "script_model", ( 0, 0, 0 ) );
			self.m4 setmodel( "weapon_m4" );
			self.m4 HidePart( "TAG_THERMAL_SCOPE" );
			self.m4 HidePart( "TAG_FOREGRIP" );
			self.m4 HidePart( "TAG_ACOG_2" );
			self.m4 HidePart( "TAG_HEARTBEAT" );
			self.m4 HidePart( "TAG_RED_DOT" );
			self.m4 HidePart( "TAG_SHOTGUN" );
			self.m4 HidePart( "TAG_SILENCER" );
			self.m4.origin = self gettagorigin( "tag_inhand" );
			self.m4.angles = self gettagangles( "tag_inhand" );
			self.m4 linkto( self, "tag_inhand" );
			self thread delete_on_death( self.m4 );
			break;
		case "training_locals_groupA_guy1":
		case "training_locals_groupA_guy2":
		case "training_locals_groupB_guy1":
		case "training_locals_groupB_guy2":
		case "training_locals_sit":
			//leave weapons on these guys
			break;
		case "parabolic_leaning_guy_idle_training":
		case "parabolic_leaning_guy_idle":
		case "little_bird_casual_idle_guy1":
		case "killhouse_sas_2_idle":
			//leave weapons on these guys
			break;
		case "training_sleeping_in_chair":
			self gun_remove();
			self.eAnimEnt = getent( self.target, "targetname" );	//just use whatever model he is targeting
			break;
		case "death_explosion_run_F_v1":
		case "civilian_run_2_crawldeath":
			self gun_remove();
			self.skipDeathAnim = true;
			self.noragdoll = true;
			break;
		case "afgan_caves_sleeping_guard_idle":
			self gun_remove();
			self.eAnimEnt.origin = self.eAnimEnt.origin + ( 0, 0, 26 );
			break;
		case "bunker_toss_idle_guy1":
		case "DC_Burning_artillery_reaction_v1_idle":
		case "DC_Burning_artillery_reaction_v2_idle":
		case "DC_Burning_bunker_stumble":
			self gun_remove();
			break;
		case "unarmed_panickedrun_loop_V2":
			self set_generic_run_anim( "unarmed_panickedrun_loop_V2" );
			self gun_remove();
			self.disablearrivals = true;
			self.disableexits = true;
			self.goalradius = 16;
			self waittill( "goal" );
			self clear_run_anim();
			wait( 1 );
			self gun_recall();
			bSpecial = true;
			return;
		case "wounded_carry_fastwalk_carrier":
			spawner = getent( self.target, "targetname" );
			eBuddy = spawner spawn_ai();
			self.eAnimEnt anim_generic_first_frame( self, sAnim );
			self.eAnimEnt anim_generic_first_frame( eBuddy, "wounded_carry_fastwalk_wounded" );
			self gun_remove();
			eBuddy gun_remove();
			bSpecial = true;
			eEndOrg = getent( self.script_Linkto, "script_linkname" );
			if ( isdefined( self.script_flag ) )
				flag_wait( self.script_flag );
			
			while ( distance( eEndOrg.origin, self.origin ) > 128 )
			{
				thread anim_generic( self, sAnim );
				anim_generic( eBuddy, "wounded_carry_fastwalk_wounded" );
			}
			thread anim_generic( self, "wounded_carry_putdown_closet_carrier" );
			anim_generic( eBuddy, "wounded_carry_putdown_closet_wounded" );
			thread anim_generic_loop( eBuddy, "wounded_carry_closet_idle_wounded" );
			thread anim_generic_loop( self, "wounded_carry_closet_idle_carrier" );
			return;
		case "sitting_guard_loadAK_idle":
			self gun_remove();
			self Attach( "weapon_m4_clip", "tag_inhand" );
			break;
		case "civilian_texting_standing":
		case "civilian_texting_sitting":
			self gun_remove();
			self Attach( "electronics_pda", "tag_inhand" );
			break;
		case "civilian_reader_1":
		case "civilian_reader_2":
			self gun_remove();
			self Attach( "open_book_static", "tag_inhand" );
			break;
		case "civilian_smoking_A":
		case "oilrig_balcony_smoke_idle":
		case "parabolic_leaning_guy_smoking_idle":
			self thread maps\_props::attach_cig_self();
			break;
		case "cliffhanger_welder_wing":
			self gun_remove();
			self.eAnimEnt.origin = self.eAnimEnt.origin + ( 0, 0, -3 );
			self Attach( "machinery_welder_handle", "tag_inhand" );
			self thread flashing_welding();
			self thread play_loop_sound_on_entity( "scn_trainer_welders_working_loop" );
			//thread flashing_welding_death_handler( self );
			break;
		case "roadkill_cover_radio_soldier2":
			break;
		case "roadkill_cover_spotter_idle":
			self attach( "weapon_binocular", "TAG_INHAND", 1 );
			break;
		case "roadkill_cover_radio_soldier3":
			self attach( "mil_mre_chocolate01", "TAG_INHAND", 1 );
			break;
		case "training_basketball_rest":
			self gun_remove();
			self attach( "com_bottle2", "TAG_INHAND", 1 );
			break;
		case "favela_run_and_wave":
			break;
		default:
			self gun_remove();
			break;
	}
	
	self thread ai_ambient_think( sAnim, sFailSafeFlag );

}

AI_ambient_ignored()
{
	self endon( "death" );
	if ( !isdefined( self ) ) 
		return;
	if ( ( isdefined( self.code_classname ) ) && ( self.code_classname == "script_model" ) )
		return;
	self setFlashbangImmunity( true );
	self.ignoreme = undefined;
	self.ignoreall = undefined;
	self.grenadeawareness = 0;
}


anim_exists( sAnim, animname )
{
	if ( !isdefined( animname ) )
		animname = "generic";
	if ( isDefined( level.scr_anim[ animname ][ sAnim ] ) )
		return true;
	else
		return false;
}


mechanic_sound_loop()
{
	self endon( "death" );
	while( true )
	{
		self waittillmatch( "looping anim", "end" );
		self thread play_sound_in_space( "scn_trainer_mechanic" );
	}
}

flashing_welding()
{
	self endon( "death" );
	self thread stop_sparks();
	while( true )
	{
		self waittillmatch( "looping anim", "spark on" );
		self thread start_sparks();
	}
}

start_sparks()
{
	self endon( "death" );
	self notify( "starting sparks" );
	self endon( "starting sparks" );
	self endon( "spark off" );
	while( true )
	{
		PlayFXOnTag( level._effect[ "welding_runner" ], self, "tag_tip_fx" );
		self PlaySound( "elec_spark_welding_bursts" );
		wait( randomfloatRange( .25, .5 ) );
	}
}

stop_sparks()
{
	self endon( "death" );
	while( true )
	{
		self waittillmatch( "looping anim", "spark off" );
		self notify( "spark off" );
	}
}

flashing_welding_death_handler( welder )
{
	//light = GetEnt( "welding_light", "targetname" );
	welder waittill( "death" );

	//light stop_loop_sound_on_entity( "scn_cliffhanger_welders_loop" );
	//light SetLightIntensity( 0 );
}

AI_think( guy )
{
	guy.ignoreme = undefined;
	guy.ignoreall = undefined;
	guy thread magic_bullet_shield();
	guy disable_pain();
	if ( guy.team == "axis" )
		guy thread AI_axis_think();

	if ( guy.team == "allies" )
		guy thread AI_allies_think();
}

AI_allies_think()
{

}

AI_axis_think()
{
	self forceUseWeapon( "m4_grunt", "primary" );
	self.team = "allies";
}

music()
{
	radio_org = getent( "radio_org", "targetname" );
	
	while( true )
	{
		radio_org playsound( "training_radio_music_01", "done" );
		radio_org waittill( "done" );
		wait( 1 );
		radio_org playsound( "training_radio_music_02", "done" );
		radio_org waittill( "done" );
		wait( 1 );
		radio_org playsound( "training_radio_music_03", "done" );
		radio_org waittill( "done" );
		wait( 1 );
		radio_org playsound( "training_radio_music_04", "done" );
		radio_org waittill( "done" );
		wait( 1 );
	}
}