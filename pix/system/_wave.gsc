#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;
#include pix\bot\_bot;

init()
{
	level.Wave = 0;
	level.enemy_hud_count = 0;
	level.BotsForWave = 0;
	
	level.default_botsForWave = 13;
	level.dog_botsForWave = 0;
	level.jugger_botsForWave = 0;
	
	level.intermissionTime = 40;
	
	level thread init_bots();
	level thread wave_count_hud_init();
	level thread watch_wave();
	level thread enemy_count_hud_init();
	level thread enemy_heli_count_hud_init();
}





watch_wave()
{
	for(;;)
	{
		level waittill("next_wave");
		level.pix_bots = [];
		level thread _watch_players_skip_intermission();
		level thread _doIntermission();
		level waittill("intermission_done");
		level.Wave ++;
		if(level.Wave>=level.WeaponShop_Unlocked_at_Wave)
		{
			if(!isDefined(level.bot_dontdropweapons)||!level.bot_dontdropweapons)
			{
				level.bot_dontdropweapons = true;
				level thread removePlacedWeapons();
				thread _ShopUnlockedNotify("Weapon Shop Unlocked!");
			}
		}
		if(level.Wave==level.SupportShop_Unlocked_at_Wave)
		{
			thread _ShopUnlockedNotify("Support Shop Unlocked!");
		}
		thread _WaveNotify();
		thread wave_count_hud_update();
		_do_wave_scheme(level.waveSetup_scheme);
		wait 0.05;
	}
}








_watch_players_skip_intermission()
{
	level endon("intermission_done");
	getPlayer1().hasIntermissionSkipped = false;
	getPlayer1() pix\player\_player::_showIntermissionSkipInfo();
	if(is_coop())
	{
		getPlayer2().hasIntermissionSkipped = false;
		getPlayer2() pix\player\_player::_showIntermissionSkipInfo();
	}
	for(;;)
	{
		foreach(player in getPlayers())
		{
			if(player AdsButtonPressed() && player MeleeButtonPressed())
			{
				if(!player.hasIntermissionSkipped)
				{
					player.hasIntermissionSkipped = true;
					player pix\player\_player::_hideIntermissionSkipInfo();
				}
				wait .4;
			}
		}
		wait 0.05;
	}
}
_doIntermission()
{
	level.Intermission_hud = createServerText("objective",1.3,"CENTER","BOTTOM",0,-30,0,(1,1,1),0,(0.3,0.6,0.3),1);
	level.Intermission_hud.label = "Next Wave in: ";
	level.Intermission_hud setValue(level.intermissionTime);
	level.Intermission_hud elemFadeOverTime(.4,1);
	wait .4;
	for(i=level.intermissionTime;i>-1;i--)
	{
		if(!is_coop())
		{
			if(getPlayer1().hasIntermissionSkipped)
			{
				continue;
			}
		}
		else
		{
			if(getPlayer1().hasIntermissionSkipped && getPlayer2().hasIntermissionSkipped)
			{
				continue;
			}
		}
		level.Intermission_hud setValue(i);
		foreach(player in getPlayers())
		{
			player playLocalSound("match_countdown_tick");//("so_player_not_ready");//ERROR: not found in sp maps - of course cause its so_blablabla
			//arcademode_zerodeaths - maybe for something else
		}
		wait 1;
	}
	level notify("intermission_done");
	foreach(player in getPlayers())
	{
		player pix\player\_player::_hideIntermissionSkipInfo();
	}
	level.Intermission_hud elemFadeOverTime(.4,0);
	wait .4;
	level.Intermission_hud destroy();
}




_WaveNotify()
{
	if(isDefined(level.Wave_notify))
	{
		level.Wave_notify destroy();
	}
	level.Wave_notify = createServerText("hudBig",1.0,"CENTER","TOP",0,20,0,(1,1,1),0,(0.3,0.6,0.3),1);
	level.Wave_notify.label = "Wave: ";
	level.Wave_notify setValue(level.Wave);
	level.Wave_notify elemFadeOverTime(.7,1);
	level.Wave_notify SetPulseFX(100,int(4*1000), 1000);
	wait 6;
	level.Wave_notify destroy();
}
_ShopUnlockedNotify(text)
{
	if(isDefined(level.Shop_Unlocked_notify))
	{
		level.Shop_Unlocked_notify destroy();
	}
	level.Shop_Unlocked_notify = createServerText("hudBig",1.0,"CENTER","TOP",0,40,0,(1,1,1),0,(0.3,0.6,0.3),1,text);
	level.Shop_Unlocked_notify elemFadeOverTime(.7,1);
	level.Shop_Unlocked_notify SetPulseFX(100,int(4*1000), 1000);
	wait 6;
	level.Shop_Unlocked_notify destroy();
}






wave_count_hud_init()
{
	level.wave_count_hud = createServerText("objective",1.5,"TOPLEFT","TOPLEFT",-55,-10+level.survival_hud_main_y,0,(1,1,1),0,(1,0,0),0);
	level.wave_count_hud.label = "Wave: ";
	level.wave_count_hud setValue(level.Wave);
	level.wave_count_hud elemFadeOverTime(.4,1);
}
wave_count_hud_update()
{
	level.wave_count_hud elemFadeOverTime(.2,0);
	wait .2;
	level.wave_count_hud setValue(level.Wave);
	level.wave_count_hud elemFadeOverTime(.2,1);
	wait .2;
}

enemy_count_hud_init()
{
	level.enemy_count_hud = createServerText("objective",1.5,"TOPLEFT","TOPLEFT",-55,7+level.survival_hud_main_y,0,(1,1,1),0,(1,0,0),0);
	level.enemy_count_hud.label = "Enemies Left: ";
	level.enemy_count_hud setValue(level.enemy_hud_count);
	level.enemy_count_hud elemFadeOverTime(.4,1);
}
enemy_count_hud_nextWave()
{
	level.enemy_hud_count = 0;//just to make sure
	for(i=0;i<level.botsForWave["total"]+1;i++)
	{
		level.enemy_hud_count = i;
		level.enemy_count_hud setValue(level.enemy_hud_count);
		wait 0.05;
	}
}
enemy_count_hud_decrease()
{
	level.enemy_hud_count --;
	level.enemy_count_hud setValue(level.enemy_hud_count);
}


enemy_heli_count_hud_init()
{
	level.enemy_heli_count_hud = createServerText("objective",1.5,"TOPLEFT","TOPLEFT",-55,24+level.survival_hud_main_y,0,(1,1,1),0,(1,0,0),0);
	level.enemy_heli_count_hud.label = "Helicopters: ";
	level.enemy_heli_count_hud setValue(level.pix_helis_alive);
}
enemy_heli_count_hud_update()
{
	if(level.pix_helis_alive>0 && (level.enemy_heli_count_hud.alpha == 0))
	{
		level.enemy_heli_count_hud setValue(level.pix_helis_alive);
		level.enemy_heli_count_hud elemFadeOverTime(.4,1);
	}
	else if(level.pix_helis_alive<=0 && (level.enemy_heli_count_hud.alpha == 1))
	{
		level.enemy_heli_count_hud setValue(level.pix_helis_alive);
		level.enemy_heli_count_hud elemFadeOverTime(.4,0);
	}
	else
	{
		level.enemy_heli_count_hud setValue(level.pix_helis_alive);
	}
}



_do_wave_scheme(scheme)
{	
	if(scheme=="default")
	{
		thread wave_default_scheme();
	}
	else if(scheme=="default_dogs")
	{
		thread wave_spawn_dogs();
		thread wave_default_scheme();
	}
	else if(scheme=="default_juggers")
	{
		thread wave_spawn_juggers();
		thread wave_default_scheme();
	}
	else if(scheme=="default_dogs_juggers")
	{
		thread wave_spawn_dogs();
		thread wave_spawn_juggers();
		thread wave_default_scheme();
	}
	else
	{
		thread wave_default_scheme();
	}
	
	
	if(level.waveHelicopters)
	{
		thread wave_spawn_helicopters();
	}
	if(isDefined(level.wave_extra_waveFunc))
	{
		thread [[level.wave_extra_waveFunc]]();
	}
}


wave_spawn_helicopters()
{
	if(level.Wave==11||level.Wave==16)
	{
		thread pix\bot\_vehicle::_spawnEnemyHeli(level.waveHelicopters_targetname);
	}
	if(level.Wave==20||level.Wave==28||level.Wave==31||level.Wave==38)
	{
		thread pix\bot\_vehicle::_spawnEnemyHeli(level.waveHelicopters_targetname);
		wait .2;
		thread pix\bot\_vehicle::_spawnEnemyHeli(level.waveHelicopters_targetname);
	}
	if(level.Wave>=40)//we should never have more than 2 helis at the same time
	{
		thread pix\bot\_vehicle::_spawnEnemyHeli(level.waveHelicopters_targetname);
		wait .2;
		thread pix\bot\_vehicle::_spawnEnemyHeli(level.waveHelicopters_targetname);
	}
}

wave_spawn_dogs()
{
	if(level.Wave>=4 && level.Wave<=10)
	{
		level.dog_botsForWave = 2;
		pix\bot\_bot::setUpBotSettings("dog",140,5,50,100);
	}
	else if(level.Wave>10 && level.Wave<16)
	{
		level.dog_botsForWave = 4;
		pix\bot\_bot::setUpBotSettings("dog",180,5,50,100);
	}
	else if(level.Wave>=16 && level.Wave<20)
	{
		level.dog_botsForWave = 6;
		pix\bot\_bot::setUpBotSettings("dog",220,10,80,140);
	}
	else if(level.Wave>=20 && level.Wave<30)
	{
		level.dog_botsForWave = 8;
		pix\bot\_bot::setUpBotSettings("dog",260,10,80,140);
	}
	else if(level.Wave>=30 && level.Wave<40)
	{
		level.dog_botsForWave = 10;
		pix\bot\_bot::setUpBotSettings("dog",300,15,100,160);
	}
	else if(level.Wave>=40 && level.Wave<50)
	{
		level.dog_botsForWave = 12;
		pix\bot\_bot::setUpBotSettings("dog",340,20,120,180);
	}
	else if(level.Wave>=50)
	{
		level.dog_botsForWave = 16;
		pix\bot\_bot::setUpBotSettings("dog",340,20,120,180);
	}
	else
	{
		level.dog_botsForWave = 0;
		pix\bot\_bot::setUpBotSettings("dog",140,5,50,100);
	}
}

wave_spawn_juggers()
{
	if(level.Wave==10||level.Wave==14||level.Wave==17)
	{
		level.jugger_botsForWave = 2;
		pix\bot\_bot::setUpBotSettings("jugger",3600,5,150,100);
	}
	else if(level.Wave==20||level.Wave==25||level.Wave==28)
	{
		level.jugger_botsForWave = 4;
		pix\bot\_bot::setUpBotSettings("jugger",4200,10,180,120);
	}
	else if(level.Wave==30||level.Wave==34||level.Wave==37)
	{
		level.jugger_botsForWave = 6;
		pix\bot\_bot::setUpBotSettings("jugger",4400,15,220,150);
	}
	else if(level.Wave==40||level.Wave==44||level.Wave==48)
	{
		level.jugger_botsForWave = 8;
		pix\bot\_bot::setUpBotSettings("jugger",4600,20,250,180);
	}
	else if(level.Wave>=50)
	{
		level.jugger_botsForWave = 12;
		pix\bot\_bot::setUpBotSettings("jugger",4800,20,280,200);
	}
	else
	{
		level.jugger_botsForWave = 0;
		pix\bot\_bot::setUpBotSettings("jugger",3600,5,150,100);
	}
}

wave_default_scheme()
{
	if(level.Wave<=10)
	{
		//level.intermissionTime = 10;
		level.default_botsForWave += 2;
		pix\bot\_bot::setUpBotsForWave(level.default_botsForWave,level.dog_botsForWave,level.jugger_botsForWave);
		pix\bot\_bot::setUpBotSettings("default",120,5,50,80);
	}
	else if(level.Wave>10 && level.Wave<16)
	{
		//level.intermissionTime = 15;
		level.default_botsForWave += 2;
		pix\bot\_bot::setUpBotsForWave(level.default_botsForWave,level.dog_botsForWave,level.jugger_botsForWave);
		pix\bot\_bot::setUpBotSettings("default",160,15,60,80);
	}
	else if(level.Wave>=16 && level.Wave<20)
	{
		//level.intermissionTime = 15;
		level.default_botsForWave += 2;
		pix\bot\_bot::setUpBotsForWave(level.default_botsForWave,level.dog_botsForWave,level.jugger_botsForWave);
		pix\bot\_bot::setUpBotSettings("default",220,15,70,100);
	}
	else if(level.Wave>=20 && level.Wave<30)
	{
		//level.intermissionTime = 20;
		level.default_botsForWave += 2;
		pix\bot\_bot::setUpBotsForWave(level.default_botsForWave,level.dog_botsForWave,level.jugger_botsForWave);
		pix\bot\_bot::setUpBotSettings("default",260,15,70,100);
	}
	else if(level.Wave>=30 && level.Wave<40)
	{
		//level.intermissionTime = 20;
		level.default_botsForWave += 2;
		pix\bot\_bot::setUpBotsForWave(level.default_botsForWave,level.dog_botsForWave,level.jugger_botsForWave);
		pix\bot\_bot::setUpBotSettings("default",300,30,120,150);
	}
	else if(level.Wave>=40 && level.Wave<50)
	{
		level.default_botsForWave += 2;
		pix\bot\_bot::setUpBotsForWave(level.default_botsForWave,level.dog_botsForWave,level.jugger_botsForWave);
		pix\bot\_bot::setUpBotSettings("default",420,50,200,250);
	}
	else if(level.Wave>=50)
	{
		//level.intermissionTime = 30;
		level.default_botsForWave = 600;
		pix\bot\_bot::setUpBotsForWave(level.default_botsForWave,level.dog_botsForWave,level.jugger_botsForWave);
		pix\bot\_bot::setUpBotSettings("default",450,60,220,270);
	}
	else
	{
		//level.intermissionTime = 30;
		level.default_botsForWave = 600;
		pix\bot\_bot::setUpBotsForWave(level.default_botsForWave,level.dog_botsForWave,level.jugger_botsForWave);
		pix\bot\_bot::setUpBotSettings("default",450,60,220,270);
	}
	thread pix\system\_wave::enemy_count_hud_nextWave();
	thread pix\bot\_bot::_spawnBots();
}