#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;
init()
{
	level.weaponShop_crate = _spawnCrate(level.weaponShop_spawnPoint,level.weaponShop_Icon);
	level.weaponShop_crate.angles = level.weaponShop_spawnAngle;
	
	level.supportShop_crate = _spawnCrate(level.SupportShop_spawnPoint,level.SupportShop_Icon);
	level.supportShop_crate.angles = level.SupportShop_spawnAngle;
	
	foreach(player in getPlayers())
	{
		player.WeaponShop_Opened = false;
		player.SupportShop_Opened = false;
	}
	level thread _monitor_Shop_usage();
}



_monitor_Shop_usage()
{
	for(;;)
	{
		foreach(player in getPlayers())
		{
			if(distance(player.origin,level.weaponShop_crate.origin)<=80)
			{
				if(player UseButtonPressed() && !player.WeaponShop_Opened && level.Wave>=level.WeaponShop_Unlocked_at_Wave)
				{
					player pix\player\_player::_setHint("");
					player thread pix\shop\_menu::open_Shop("weapon");
					wait .4;
				}
				else
				{
					if(!player.WeaponShop_Opened && level.Wave>=level.WeaponShop_Unlocked_at_Wave)
					{
						player pix\player\_player::_setHint("Press ^3[{+activate}]^7 to open the Weapon Shop!");
					}
					else if(!player.WeaponShop_Opened && level.Wave<level.WeaponShop_Unlocked_at_Wave)
					{
						player pix\player\_player::_setHint("Unlocked at WAVE "+level.WeaponShop_Unlocked_at_Wave+"!");
					}
				}
			}
			else if(distance(player.origin,level.supportShop_crate.origin)<=80)
			{
				if(player UseButtonPressed() && !player.SupportShop_Opened && level.Wave>=level.WeaponShop_Unlocked_at_Wave)
				{
					player pix\player\_player::_setHint("");
					player thread pix\shop\_menu::open_Shop("support");
					wait .4;
				}
				else
				{
					if(!player.SupportShop_Opened && level.Wave>=level.WeaponShop_Unlocked_at_Wave)
					{
						player pix\player\_player::_setHint("Press ^3[{+activate}]^7 to open the Support Shop!");
					}
					else if(!player.SupportShop_Opened && level.Wave<level.WeaponShop_Unlocked_at_Wave)
					{
						player pix\player\_player::_setHint("Unlocked at WAVE "+level.SupportShop_Unlocked_at_Wave+"!");
					}
				}
			}
			else
			{
				player pix\player\_player::_setHint("");
			}
		}
		wait 0.05;
	}
}





addDeltaSquad(price)
{
	level.DeltaSquad_Active = false;
	level.DeltaSquad_guys_alive = 0;
	level.DeltaSquad_price = price;
}
addMortarStrike(price,bullet)
{
	level.MortarStrike_Supported = true;
	level.MortarStrike_price = price;
	level.MortarStrike_bullet = bullet;
}
addPredatorDrone(price,weapon)
{
	level.PredatorDrone_Supported = true;
	level.PredatorDrone_weaponName = weapon;
	level.PredatorDrone_price = price;
}