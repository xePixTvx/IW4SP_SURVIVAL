#include maps\_utility;
#include common_scripts\utility;
#include maps\_riotshield;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_hud_util;

#include pix\_common_scripts;

CONST_ELEV_CABLE_HEIGHT = 94;
CONST_ELEV_CABLE_CLOSE = 2;
glass_elevator_setup()
{
	elevator_glass = GetEntArray( "elevator_housing_glass", "script_noteworthy" );
	elevator_model = GetEntArray( "airport_glass_elevator", "script_noteworthy" );
	elevator_door_models = GetEntArray( "airport_glass_elevator_door", "script_noteworthy" );
	elevator_doors = GetEntArray( "elevator_doors", "script_noteworthy" );
	elevator_house = GetEntArray( "elevator_housing", "targetname" );
	elevator_cables = GetEntArray( "elevator_cable", "targetname" );
	elevator_wheels = GetEntArray( "elevator_wheels", "targetname" );
	foreach ( piece in elevator_glass )
	{
		house = getClosest( piece GetOrigin(), elevator_house );
		piece LinkTo( house );
	}
	foreach ( piece in elevator_model )
	{
		house = getClosest( piece.origin, elevator_house );
		piece LinkTo( house );
	}
	foreach ( piece in elevator_door_models )
	{
		door = getClosest( piece.origin, elevator_doors );
		piece LinkTo( door );
	}
	wait .05;
	foreach ( obj in level.elevators )
	{
		housing = obj.e[ "housing" ][ "mainframe" ][ 0 ];
		cable = getClosest( housing GetOrigin(), elevator_cables );
		cable.elevator_model = housing;
		cable.elevator = obj;

		wheels = get_array_of_closest( housing GetOrigin(), elevator_wheels, undefined, 2 );
		cable.wheels = [];
		foreach ( item in wheels )
		{
			anchor = Spawn( "script_origin", item.origin );
			item LinkTo( anchor );
			cable.wheels[ item.script_noteworthy ] = anchor;
		}
	}
	array_thread( elevator_cables, ::glass_elevator_cable );
}
glass_elevator_cable()
{
	cable = self;
	while ( IsDefined( cable.target ) )
	{
		cable = GetEnt( cable.target, "targetname" );
		cable Hide();
	}
	elevator 	 = self.elevator;
	elevator.cable = self;
	cable 		 = self;
	housing 	 = self.elevator_model;
	cable.wheels 	 = self.wheels;
	level.velF = ( 0, 0, 200 );
	level.velR = ( 0, 0, -200 );
	level.ELEV_CABLE_HEIGHT = CONST_ELEV_CABLE_HEIGHT;
	floor_num = 0;
	mainframe = elevator common_scripts\_elevator::get_housing_mainframe();
	delta_vec = elevator.e[ "floor" + floor_num + "_pos" ] - mainframe.origin;
	speed = level.elevator_speed;
	dist = abs( Distance( elevator.e[ "floor" + floor_num + "_pos" ], mainframe.origin ) );
	moveTime = dist / speed;
	while ( 1 )
	{
		//start at the top
		//moving down
		elevator waittill( "elevator_moving" );
			elevator elevator_animated_down( cable, housing, moveTime );
		//stopped	
		elevator waittill( "elevator_moved" );
		//moving back up
		elevator waittill( "elevator_moving" );
			elevator elevator_animated_up( cable, housing, moveTime );
		//stopped	
		elevator waittill( "elevator_moved" );
	}
}
elevator_animated_down( cable, housing, moveTime )
{
	wheels = cable.wheels;
	cable thread glass_elevator_cable_down( housing, self );
	wheels[ "top" ] RotateVelocity( level.velF, moveTime, 1, 1 );
	wheels[ "bottom" ] RotateVelocity( level.velR, moveTime, 1, 1 );
}
elevator_animated_down_fast( cable, housing, moveTime, velF, velR )
{
	wheels = cable.wheels;
	cable thread glass_elevator_cable_down( housing, self );
	wheels[ "top" ] RotateVelocity( velF, moveTime, moveTime );
	wheels[ "bottom" ] RotateVelocity( velR, moveTime, moveTime );
}
elevator_animated_up( cable, housing, moveTime )
{
	wheels = cable.wheels;
	housing.last_cable thread glass_elevator_cable_up( housing, self );
	wheels[ "top" ] RotateVelocity( level.velR, moveTime, 1, 1 );
	wheels[ "bottom" ] RotateVelocity( level.velF, moveTime, 1, 1 );
}
glass_elevator_cable_down( housing, elevator )
{
	self attach_housing( housing );

	elevator endon( "elevator_moved" );

	while ( DistanceSquared( self.og, self GetOrigin() ) < squared( level.ELEV_CABLE_HEIGHT ) )
		wait .05;

	if ( !isdefined( self.target ) )
		return;

	next_cable = GetEnt( self.target, "targetname" );
	next_cable thread glass_elevator_cable_down( housing, elevator );
}
attach_housing( housing )
{
	self.og = self GetOrigin();
	self LinkTo( housing );
	housing.last_cable = self;

	if ( !isdefined( self.target ) )
		return;

	next_cable = GetEnt( self.target, "targetname" );
	next_cable Show();
}
glass_elevator_cable_up( housing, elevator )
{
	elevator endon( "elevator_moved" );

	while ( DistanceSquared( self.og, self GetOrigin() ) > squared( CONST_ELEV_CABLE_CLOSE ) )
		wait .05;

	self thread detach_housing( housing );

	if ( self.targetname == "elevator_cable" )
		return;

	prev_cable = GetEnt( self.targetname, "target" );
	prev_cable thread glass_elevator_cable_up( housing, elevator );
}
detach_housing( housing )
{
	if ( self.targetname == "elevator_cable" )
		return;
	self Unlink();
	time = .5;
	self MoveTo( self.og, time );
	wait time;
	self Hide();
}

show_intro_stairs_upperdeck_dead_bodies()
{
	array = intro_setup_dead_bodies();
	foreach(model in array)
	{
		model Hide();
	}
	array["stairs_dead_body3"] Show();
	array["stairs_dead_body2"] Show();
	array["stairs_dead_body"] Show();
	foreach(model in array)
	{
		model Show();
	}
}
#using_animtree("generic_human");
intro_setup_dead_bodies()
{
	models = GetEntArray("upperdeck_dead_body","targetname");
	array = [];
	foreach(key,model in models)
	{
		array["upperdeck_dead_body"+key] = model;
	}
	array["stairs_dead_body"] = GetEnt("stairs_dead_body","targetname");
	array["stairs_dead_body2"] = GetEnt("stairs_dead_body2","targetname");
	array["stairs_dead_body3"] = GetEnt("stairs_dead_body3","targetname");
	foreach(model in array)
	{
		model UseAnimTree(#animtree);
		model thread anim_generic(model,model.script_animation);
		model SetAnimTime(getanim_generic(model.script_animation),1);
	}
	return array;
}
remove_dummies()
{
	array = GetEntArray("massacre_dummy","targetname");
	foreach(obj in array)
	{
		obj delete();
	}
	array = GetEntArray("gate_canned_deaths","targetname");
	foreach(obj in array)
	{
		obj delete();
	}
	array = GetEntArray("upperdeck_canned_deaths","targetname");
	foreach(obj in array)
	{
		if(IsDefined(obj.target))
		{
			temp = GetEnt(obj.target,"targetname");
			temp delete();
		}
		obj delete();
	}
}

init_door_buying()
{
	getPlayer1() airport_player_door_hint_init();
	if(is_coop())
	{
		getPlayer2() airport_player_door_hint_init();
	}
	
	thread airport_buy_door_watcher();
}
airport_player_door_hint_init()
{
	self.Hud["airport_hint"] = createText("default",1.5,"MIDDLE",undefined,0,30,0,(1,1,1),1,(0,1,0),0,"");
}
airport_buy_door_watcher()
{
	level endon("airport_buy_door_watcher_end_YAY");
	for(;;)
	{
		foreach(player in getPlayers())
		{
			if(!level.airport_door_opened)
			{
				door = GetEnt("basement_door","targetname");
				if(distance(player.origin,door.origin)<=80)
				{
					player.Hud["airport_hint"] setText("Press ^3[{+activate}]^7 to open the Door!(^2$"+level.airport_door_price+"^7)");
					if(player UseButtonPressed())
					{
						player thread airport_buy_door(door,level.airport_door_price);
						wait .4;
					}
				}
				else if(distance(player.origin,door.origin)>80)
				{
					player.Hud["airport_hint"] setText("");
				}
			}
			else
			{
				if(isDefined(player.Hud["airport_hint"]))
				{
					player.Hud["airport_hint"] destroy();
				}
			}
		}
		wait 0.05;
	}
}
airport_buy_door(door,price)
{
	if(self.Money<price)
	{
		iprintlnBold("^1Not Enough Money");
		return;
	}
	self pix\player\_money::_takeMoney(price);
	level.airport_door_opened = true;
	door MoveTo(door.origin-(-100,0,0),2);
	wait 3;
	door delete();
	//add spawner stuff for outside
	pix\bot\_bot::addSpawner(106,"default",level.bot_spawnPoints[1]);//ar
	pix\bot\_bot::addSpawner(55,"default",level.bot_spawnPoints[1]);//smg
	pix\bot\_bot::addSpawner(3,"default",level.bot_spawnPoints[1]);//makarov
	pix\bot\_bot::addSpawner(105,"default",level.bot_spawnPoints[1]);//ar
	pix\bot\_bot::addSpawner(60,"default",level.bot_spawnPoints[1]);//smg
	level notify("airport_buy_door_watcher_end_YAY");
}