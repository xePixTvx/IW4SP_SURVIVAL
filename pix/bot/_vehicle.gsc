#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include maps\_vehicle;
#include maps\_attack_heli;
#include pix\_common_scripts;



_spawnEnemyHeli(targetname)
{
	heliSpawner = getent(targetname,"targetname");
	//heliSpawner.origin = heliSpawner.origin;
	heliSpawner.script_forcespawn = true;
	heliSpawner.script_playerseek = true;
	heliSpawner.script_avoidvehicles = true;
	heliSpawner.script_vehicle_selfremove = undefined;
	heliSpawner.script_team = "axis";
	eHeli = spawn_vehicle_from_targetname_and_drive(targetname);
	eHeli endon("death");
	//eHeli setVehGoalPos( level.player.origin+(0,0,400), true );//TESTING SHIT
	if(ToLower(GetDvar("mapname"))=="so_takeover_oilrig")
	{
		foreach(eTurret in eHeli.mgturret)
		{
			eTurret turret_set_default_on_mode("manual");
			eTurret setMode("manual");
		}
		eHeli.dontWaitForPathEnd = true;
		//eHeli delaythread(3,maps\_attack_heli::heli_spotlight_on,"tag_barrel",true);
		//eHeli thread stalk_players(0,"axis");//makes it more agressive
	}
	if(ToLower(GetDvar("mapname"))=="so_killspree_invasion")
	{
		eHeli.circling = true;
		eHeli.no_attractor = true;
	}
	wait 1;
	eHeli = maps\_attack_heli::begin_attack_heli_behavior( eHeli );
	thread _enemyHeli_rampupdamage(eHeli);
	eHeli thread _enemyHeli_death_monitor();
	eHeli thread _enemyHeli_damage_monitor();
	eHeli pix\bot\_bot::_addHeli();
	//iprintln("health: " + eHeli.health);
}
_enemyHeli_death_monitor()
{
	self waittill("death",attacker);
	attacker pix\player\_money::_giveMoney(500);
	pix\bot\_bot::_removeHeli();
}
_enemyHeli_damage_monitor()
{
	self endon("death");
	for(;;)
	{
		self waittill("damage",damage,attacker,direction_vec,P,type);
		attacker pix\player\_money::_giveMoney(5);
	}
}
_enemyHeli_rampupdamage(eHeli)
{
	heli_damage_delay = 0.95;
	heli_damage_ramp_loops = 10;
	i = 0;
	while((isdefined(eHeli))&&(i<heli_damage_ramp_loops))
	{
		level.player waittill("damage",amount,attacker);
		if(!isdefined(eHeli))
		{
			break;
		}
		if(!isdefined(eHeli.mgturret))
		{
			break;
		}
		if ((isdefined(attacker))&&(isdefined(eHeli.mgturret))&&(is_in_array(eHeli.mgturret,attacker)))
		{
			level.player enableInvulnerability();
			wait(heli_damage_delay);
			i++;
			heli_damage_delay = heli_damage_delay/1.3;
			level.player disableInvulnerability();
		}
	}
	level.player disableInvulnerability();
}


/*
	stalk_players function coded by momo5502
	
	taken from the multiplayer survival mod
*/
/*
stalk_players( lifeId, heli_team )
{
//Code by momo5502
	self endon ( "death" );
	self endon ( "leaving" );

	// only one thread instance allowed
	self notify( "flying");
	self endon( "flying" );
	
	if(!isDefined(self.firstloop))
	{
		self.firstloop = 1;
		if(lifeId == 1)
			wait 5;
	}
	
	heli_reset();
	//self thread deathLower();
	target = "ZOB";
	direction = "ZOB";
	
	while ( 1 )
	{	
		foreach(player in level.players)
		{
			if( player.team != heli_team ) 
			{
				if( target == "ZOB" )
				target = player.origin;
				
				if(Distance(self.origin, player.origin) <= Distance(self.origin, target) )
				{
					target = player.origin;
					direction = player.angles;
					level.victim[ lifeId ] = player;
				}
			}

		}
		yaw = 155 + randomint(50);
		 
		if(level.waveLittleBirds == 1 || ( level.waveLittleBirds == 2 && level.victim[0] != level.victim[1] ))
			target += vector_multiply( anglestoforward( direction ), 500 + randomint(500) ) + ( 0, 0, 400 + randomint(500) );

			
		if(level.waveLittleBirds == 2)
		{
			if(lifeId == 0)
				target += vector_multiply( anglestoforward( direction ), 500 + randomint(500) ) + ( 0, 0, 400 + randomint(500) ) + vector_multiply( anglestoforward( direction - (0, 90, 0) ), 300);
		
			if(lifeId == 1)
				target += vector_multiply( anglestoforward( direction ), 500 + randomint(500) ) + ( 0, 0, 400 + randomint(500) ) + vector_multiply( anglestoforward( direction + (0, 90, 0) ), 300);
		}
		
		heli_speed = 30 + randomInt(20);
		heli_accel = 15 + randomInt(15);

		//Test - prevent the birds from flying into objects
		target = PhysicsTrace(target+(0,0,1000),target-(0,0,100));
		
		self Vehicle_SetSpeed( heli_speed, heli_accel );
		self setVehGoalPos( target, true );
		self waittill( "near_goal" );
		
		self setGoalYaw( direction[ 1 ] - yaw );
		
		//Really need this, as otherwise there are horible lags!
		if(level.waveLittleBirds >= 1)
		{
			wait ( 5 + randomint( 5 * level.waveLittleBirds ) );
		}
		
		else
			wait 5;
	}

}
heli_reset()
{
	self clearTargetYaw();
	self clearGoalYaw();
	self Vehicle_SetSpeed( 60, 25 );	
	self setyawspeed( 75, 45, 45 );
	//self setjitterparams( (30, 30, 30), 4, 6 );
	self setmaxpitchroll( 30, 30 );
	self setneargoalnotifydist( 256 );
	self setturningability(0.9);
}
*/