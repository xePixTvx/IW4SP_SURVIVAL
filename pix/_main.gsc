#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;

_start_IW4SP_Survival()
{
	level.iw4sp_survival_version = 0.6;
	objective_add(0,"current", "Survive!");
	objective_add(1,"current", " ");
	objective_add(2,"current", " ");
	objective_add(3,"current", "^1IW4SP Survival by P!X[VERSION: " + level.iw4sp_survival_version+ "]");
	
	precacheShader("line_horizontal");
	
	if(!isDefined(level.bot_spawnPoints))
	{
		iprintln("^1IW4SP_SURVIVAL_ERROR:^7 ------ pix\_main::_start_IW4SP_Survival() -> level.bot_spawnPoints is not DEFINED! ------");
		return;
	}
	if(!isDefined(level.pix_spawner))
	{
		iprintln("^1IW4SP_SURVIVAL_ERROR:^7 ------ pix\_main::_start_IW4SP_Survival() -> level.pix_spawner is not DEFINED! ------");
		return;
	}
	if(!isDefined(level.player1_spawnPoint))
	{
		iprintln("^1IW4SP_SURVIVAL_ERROR:^7 ------ pix\_main::_start_IW4SP_Survival() -> level.player1_spawnPoint is not DEFINED! ------");
		return;
	}
	if(!isDefined(level.player1_spawnAngle))
	{
		iprintln("^1IW4SP_SURVIVAL_ERROR:^7 ------ pix\_main::_start_IW4SP_Survival() -> level.player1_spawnAngle is not DEFINED! ------");
		return;
	}
	if(!isDefined(level.player2_spawnPoint))
	{
		iprintln("^1IW4SP_SURVIVAL_ERROR:^7 ------ pix\_main::_start_IW4SP_Survival() -> level.player2_spawnPoint is not DEFINED! ------");
		return;
	}
	if(!isDefined(level.player2_spawnAngle))
	{
		iprintln("^1IW4SP_SURVIVAL_ERROR:^7 ------ pix\_main::_start_IW4SP_Survival() -> level.player2_spawnAngle is not DEFINED! ------");
		return;
	}
	if(!isDefined(level.waveSetup_scheme))
	{
		iprintln("^3IW4SP_SURVIVAL_WARNING:^7 ------ pix\_main::_start_IW4SP_Survival() -> level.waveSetup_scheme is not DEFINED! ---- set to default ------");
		level.waveSetup_scheme = "default";
	}
	if(!isDefined(level.waveHelicopters))
	{
		level.waveHelicopters = false;
	}
	else
	{
		if(level.waveHelicopters && !isDefined(level.waveHelicopters_targetname))
		{
			iprintln("^1IW4SP_SURVIVAL_ERROR:^7 ------ pix\_main::_start_IW4SP_Survival() -> level.waveHelicopters_targetname is not DEFINED! ------");
			return;
		}
	}
	if(!isDefined(level.startWeapon))
	{
		iprintln("^3IW4SP_SURVIVAL_WARNING:^7 ------ pix\_main::_start_IW4SP_Survival() -> level.startWeapon is not DEFINED! ---- set to defaultweapon ------");
		level.startWeapon = "defaultweapon";
	}
	if(!isDefined(level.shopModel))
	{
		iprintln("^3IW4SP_SURVIVAL_WARNING:^7 ------ pix\_main::_start_IW4SP_Survival() -> level.shopModel is not DEFINED! ---- set to com_plasticcase_beige_big ------");
		level.shopModel = "com_plasticcase_beige_big";
		precacheModel(level.shopModel);
	}
	else
	{
		precacheModel(level.shopModel);
	}
	if(!isDefined(level.weaponShop_Icon))
	{
		iprintln("^3IW4SP_SURVIVAL_WARNING:^7 ------ pix\_main::_start_IW4SP_Survival() -> level.weaponShop_Icon is not DEFINED! ---- set to waypoint_ammo ------");
		level.weaponShop_Icon = "waypoint_ammo";
		precacheShader(level.weaponShop_Icon);
	}
	else
	{
		precacheShader(level.weaponShop_Icon);
	}
	if(!isDefined(level.weaponShop_spawnPoint))
	{
		iprintln("^3IW4SP_SURVIVAL_WARNING:^7 ------ pix\_main::_start_IW4SP_Survival() -> level.weaponShop_spawnPoint is not DEFINED! ---- spawnpoint set to (0,0,0) ------");
		level.weaponShop_spawnPoint = (0,0,0);
	}
	if(!isDefined(level.weaponShop_spawnAngle))
	{
		iprintln("^3IW4SP_SURVIVAL_WARNING:^7 ------ pix\_main::_start_IW4SP_Survival() -> level.weaponShop_spawnAngle is not DEFINED! ---- spawnangle set to (0,0,0) ------");
		level.weaponShop_spawnAngle = (0,0,0);
	}
	if(!isDefined(level.weaponShop_refillAmmo_price))
	{
		iprintln("^3IW4SP_SURVIVAL_WARNING:^7 ------ pix\_main::_start_IW4SP_Survival() -> level.weaponShop_refillAmmo_price is not DEFINED! ---- set to 500 ------");
		level.weaponShop_refillAmmo_price = 500;
	}
	if(!isDefined(level.WeaponsSetup_func))
	{
		iprintln("^3IW4SP_SURVIVAL_WARNING:^7 ------ pix\_main::_start_IW4SP_Survival() -> level.WeaponsSetup_func is not DEFINED! ---- set to default function ------");
		level.WeaponsSetup_func = pix\_main::default_weaponshopSetup;
	}
	if(!isDefined(level.SupportShop_Icon))
	{
		iprintln("^3IW4SP_SURVIVAL_WARNING:^7 ------ pix\_main::_start_IW4SP_Survival() -> level.SupportShop_Icon is not DEFINED! ---- set to hud_burningcaricon ------");
		level.SupportShop_Icon = "hud_burningcaricon";
		precacheShader(level.SupportShop_Icon);
	}
	else
	{
		precacheShader(level.SupportShop_Icon);
	}
	if(!isDefined(level.SupportShop_spawnPoint))
	{
		iprintln("^3IW4SP_SURVIVAL_WARNING:^7 ------ pix\_main::_start_IW4SP_Survival() -> level.SupportShop_spawnPoint is not DEFINED! ---- spawnpoint set to (0,0,0) ------");
		level.SupportShop_spawnPoint = (0,0,0);
	}
	if(!isDefined(level.SupportShop_spawnAngle))
	{
		iprintln("^3IW4SP_SURVIVAL_WARNING:^7 ------ pix\_main::_start_IW4SP_Survival() -> level.SupportShop_spawnAngle is not DEFINED! ---- spawnangle set to (0,0,0) ------");
		level.SupportShop_spawnAngle = (0,0,0);
	}
	if(!isDefined(level.DeltaSquad_Active))
	{
		level.DeltaSquad_Active = undefined;
	}
	else
	{
		if(!isDefined(level.DeltaSquad_guys_alive))
		{
			level.DeltaSquad_guys_alive = 0;
		}
		if(!isDefined(level.DeltaSquad))
		{
			iprintln("^1IW4SP_SURVIVAL_ERROR:^7 ------ pix\_main::_start_IW4SP_Survival() -> level.DeltaSquad is not DEFINED! ---- define atleast 1 deltasquad bot ------");
			return;
		}
		if(!isDefined(level.DeltaSquad_price))
		{
			iprintln("^3IW4SP_SURVIVAL_WARNING:^7 ------ pix\_main::_start_IW4SP_Survival() -> level.DeltaSquad_price is not DEFINED! ---- set to 5000 ------");
			level.DeltaSquad_price = 5000;
		}
	}
	if(!isDefined(level.MortarStrike_Supported)||!level.MortarStrike_Supported)
	{
		level.MortarStrike_Supported = undefined;
	}
	else
	{
		if(!isDefined(level.MortarStrike_bullet))
		{
			iprintln("^1IW4SP_SURVIVAL_ERROR:^7 ------ pix\_main::_start_IW4SP_Survival() -> level.MortarStrike_bullet is not DEFINED! ----");
			return;
		}
		if(!isDefined(level.MortarStrike_price))
		{
			iprintln("^3IW4SP_SURVIVAL_WARNING:^7 ------ pix\_main::_start_IW4SP_Survival() -> level.MortarStrike_price is not DEFINED! ---- set to 7000 ------");
			level.MortarStrike_price = 7000;
		}
	}
	if(!isDefined(level.PredatorDrone_Supported)||!level.PredatorDrone_Supported)
	{
		level.PredatorDrone_Supported = undefined;
	}
	else
	{
		if(!isDefined(level.PredatorDrone_weaponName))
		{
			iprintln("^1IW4SP_SURVIVAL_ERROR:^7 ------ pix\_main::_start_IW4SP_Survival() -> level.PredatorDrone_weaponName is not DEFINED! ----");
			return;
		}
		if(!isDefined(level.PredatorDrone_price))
		{
			iprintln("^3IW4SP_SURVIVAL_WARNING:^7 ------ pix\_main::_start_IW4SP_Survival() -> level.PredatorDrone_price is not DEFINED! ---- set to 4000 ------");
			level.PredatorDrone_price = 4000;
		}
	}
	
	
	
	level thread pix\system\_wave::init();
	level thread [[level.WeaponsSetup_func]]();
	level thread pix\shop\_shop::init();
	level thread pix\player\_player::_players_spawn();
	
	
	wait 3;
	if(level.DEV_ALLOW_START||!isDefined(level.DEV_ALLOW_START))
	{
		level notify("next_wave");//next wave = 1 wave
	}
}




default_weaponshopSetup()
{
	level.weaponshop_items = [];
	thread pix\shop\_weapon::addWeaponShopItem(&"WEAPON_DEFAULTWEAPON","defaultweapon",50,"pistol");
}