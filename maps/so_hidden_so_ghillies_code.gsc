#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\_specialops;


remove_church_door()
{
	church_doors = getentarray("church_door_front","targetname");
	foreach(door in church_doors)
	{
		door ConnectPaths();
		door Delete();
	}
}