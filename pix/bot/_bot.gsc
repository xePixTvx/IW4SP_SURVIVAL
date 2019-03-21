#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;
//juggers - done
//dogs - done
//vehicles - done

init_bots()
{
	level.pix_bots = [];
	level.pix_helis = [];
	
	//DEV STUFF
	level.bot_pacifistMode = undefined;//undefined for OFF
	//DEV STUFF END
	
	level.bot_dontdropweapons = undefined;//gets turned on when weaponshop is unlocked
	level.pix_bots_alive = 0;
	level.pix_helis_alive = 0;
	
	//gets set on the maps setupwave function
	level.default_botHealth = 50;
	level.default_money_for_hit = 5;
	level.default_money_for_kill = 50;
	level.default_money_for_headshot = 80;
	
	level.dog_botHealth = 50;
	level.dog_money_for_hit = 5;
	level.dog_money_for_kill = 50;
	level.dog_money_for_headshot = 100;
	
	level.jugger_botHealth = 3600;//default 3600
	level.jugger_money_for_hit = 5;
	level.jugger_money_for_kill = 150;
	level.jugger_money_for_headshot = 100;
	
	level.MaxBots = 30;//depends on map and spawner but 30 should work on all maps --- should be 26 on maps with delta squad support
	
	
	
	level.botsForWave = [];
	level.botsForWave["total"] = 0;
	level.botsForWave["default"] = 0;
	level.botsForWave["dog"] = 0;
	level.botsForWave["jugger"] = 0;
	
	
	
	
	level thread watch_bot_count();
}

watch_bot_count()
{
	for(;;)
	{
		level waittill("bot_count_changed");
		if(level.pix_bots_alive<=0 && level.pix_helis_alive<=0)
		{
			level notify("next_wave");
			level.pix_bots = [];
			level.pix_helis = [];
		}
		if(level.pix_bots_alive>=level.MaxBots)
		{
			level.canSpawnBots = false;
		}
	}
}


_spawnBots()
{
	level.canSpawnBots = true;
	allowSpawnAgain = (level.MaxBots-randomIntRange(5,15));
	botsToSpawn = level.botsForWave["total"];
	default_bots_ToSpawn = level.botsForWave["default"];
	dog_bots_ToSpawn = level.botsForWave["dog"];
	jugger_bots_ToSpawn = level.botsForWave["jugger"];
	
	
	while(botsToSpawn>0)
	{
		if(level.canSpawnBots)
		{
			if(default_bots_ToSpawn>0)
			{
				thread _spawnBot(getRandomSpawner("default"),"default");
				default_bots_ToSpawn --;
				botsToSpawn --;
			}
			if(dog_bots_ToSpawn>0)
			{
				thread _spawnBot(getRandomSpawner("dog"),"dog");
				dog_bots_ToSpawn --;
				botsToSpawn --;
			}
			if(jugger_bots_ToSpawn>0)
			{
				thread _spawnBot(getRandomSpawner("jugger"),"jugger");
				jugger_bots_ToSpawn --;
				botsToSpawn --;
			}
		}
		else
		{
			if(level.pix_bots_alive<=allowSpawnAgain)
			{
				level.canSpawnBots = true;
			}
		}
		wait .2;
	}
}


_spawnBot(spawner_id,type)//bot scrub(); ---- reset to default settings and ingoring .script_ stuff
{
	spawners = GetSpawnerArray();
	spawners[spawner_id].script_forcespawn = true;//force spawner to stalingradspawn ai
	spawners[spawner_id].script_playerseek = true;//ai runs to player
	spawners[spawner_id].script_pacifist = level.bot_pacifistMode;//ai only attacks after you hurt it
	spawners[spawner_id].script_ignoreme = undefined;//ai ignores player
	spawners[spawner_id].dontdropweapon = level.bot_dontdropweapons;//self explaining
	//spawners[spawner_id].script_maxspawn = 30;//actually used for flood spawning - so not really needed
	spawners[spawner_id].script_moveoverride = undefined;
	spawners[spawner_id].script_patroller = undefined;
	spawners[spawner_id].script_stealth = undefined;
	spawners[spawner_id].script_startrunning = true;
	spawners[spawner_id].count = 9999;
	/*spawners[spawner_id].script_stealth_dontseek = undefined;
	spawners[spawner_id].script_stealth_function = undefined;
	spawners[spawner_id].script_ignoreall = undefined;
	spawners[spawner_id].script_seekgoal = true;
	spawners[spawner_id].script_forcegoal = true;*/
	
	if(type=="default")
	{
		bot = spawners[spawner_id] stalingradspawn();//spawn_ai();
		bot.team = "axis";
		if(ToLower(GetDvar("mapname"))=="airport" && spawner_id==3)
		{
			bot.name = "Asshole";
			bot.battleChatter = false;
		}
		if(ToLower(GetDvar("mapname"))=="so_takeover_estate" && spawner_id==145)
		{
			bot.name = "Idiot";
			bot.battleChatter = false;
		}
		bot.pix_type = "default";//.type = human
		bot.maxHealth = level.default_botHealth;
		bot.health = bot.maxHealth;
		bot thread _bot_monitor_death();
		bot thread _bot_monitor_damage();
		bot _addBot();
	}
	else if(type=="dog")
	{
		bot = spawners[spawner_id] stalingradspawn();//spawn_ai();
		bot.team = "axis";
		bot.pix_type = "dog";
		bot.maxHealth = level.dog_botHealth;
		bot.health = bot.maxHealth;
		bot thread _bot_monitor_death();
		bot thread _bot_monitor_damage();
		bot _addBot();
	}
	else if(type=="jugger")
	{
		bot = spawners[spawner_id] stalingradspawn();//spawn_ai();
		bot.team = "axis";
		bot.pix_type = "jugger";
		bot.maxHealth = level.jugger_botHealth;
		bot.health = bot.maxHealth;
		bot thread _bot_monitor_death();
		bot thread _bot_monitor_damage();
		bot _addBot();
	}
	else
	{
		//default
		bot = spawners[spawner_id] stalingradspawn();//spawn_ai();
		bot.team = "axis";
		if(ToLower(GetDvar("mapname"))=="airport" && spawner_id==3)
		{
			bot.name = "Asshole";
			bot.battleChatter = false;
		}
		if(ToLower(GetDvar("mapname"))=="so_takeover_estate" && spawner_id==145)
		{
			bot.name = "Idiot";
			bot.battleChatter = false;
		}
		bot.pix_type = "default";
		bot.maxHealth = level.default_botHealth;
		bot.health = bot.maxHealth;
		bot thread _bot_monitor_death();
		bot thread _bot_monitor_damage();
		bot _addBot();
	}
}



/*
	Important damage locations:
	head
	torso_upper
	torso_lower
*/
_bot_monitor_death()
{
	self endon("bot_death");
	for(;;)
	{
		self waittill("death",attacker);
		if(isDefined(attacker.deltasquad_owner))
		{
			attacker = attacker.deltasquad_owner;
		}
		
		if(self.damageLocation == "head")
		{
			if(self.pix_type=="default")
			{
				attacker pix\player\_money::_giveMoney(level.default_money_for_kill,level.default_money_for_headshot);
			}
			else if(self.pix_type=="dog")
			{
				attacker pix\player\_money::_giveMoney(level.dog_money_for_kill,level.dog_money_for_headshot);
			}
			else if(self.pix_type=="jugger")
			{
				attacker pix\player\_money::_giveMoney(level.jugger_money_for_kill,level.jugger_money_for_headshot);
			}
		}
		else
		{
			if(self.pix_type=="default")
			{
				attacker pix\player\_money::_giveMoney(level.default_money_for_kill);
			}
			else if(self.pix_type=="dog")
			{
				attacker pix\player\_money::_giveMoney(level.dog_money_for_kill);
			}
			else if(self.pix_type=="jugger")
			{
				attacker pix\player\_money::_giveMoney(level.jugger_for_kill);
			}
		}
		_removeBot();
		self notify("bot_death");
		wait 0.05;
	}
}
_bot_monitor_damage()
{
	self endon("bot_death");
	for(;;)
	{
		self waittill("damage",damage,attacker,direction_vec,point,type,modelName,tagName);
		if(isDefined(attacker.deltasquad_owner))
		{
			attacker = attacker.deltasquad_owner;
		}
		if(self.pix_type=="default")
		{
			attacker pix\player\_money::_giveMoney(level.default_money_for_hit);
		}
		else if(self.pix_type=="dog")
		{
			attacker pix\player\_money::_giveMoney(level.dog_money_for_hit);
		}
		else if(self.pix_type=="jugger")
		{
			if(self.damageLocation == "head")
			{
				attacker pix\player\_money::_giveMoney(level.jugger_money_for_hit,level.jugger_money_for_headshot);
			}
			else
			{
				attacker pix\player\_money::_giveMoney(level.jugger_money_for_hit);
			}
		}
		wait 0.05;
	}
}



_addBot()
{
	level.pix_bots_alive ++;
	level.pix_bots[level.pix_bots.size] = self;
	level notify("bot_count_changed");
}
_removeBot()
{
	level.pix_bots_alive --;
	level notify("bot_count_changed");
	pix\system\_wave::enemy_count_hud_decrease();
}
_addHeli()
{
	level.pix_helis_alive ++;
	level.pix_helis[level.pix_helis.size] = self;
	thread pix\system\_wave::enemy_heli_count_hud_update();
	level notify("bot_count_changed");
}
_removeHeli()
{
	level.pix_helis_alive --;
	thread pix\system\_wave::enemy_heli_count_hud_update();
	level notify("bot_count_changed");
}
_killAll_pixBots()
{
	for(i=0;i<level.pix_bots.size;i++)
	{
		level.pix_bots[i] dodamage((level.pix_bots[i].health*99999),(0,0,0));
	}
}
_killAll_pixHelis()
{
	if(!isDefined(level.pix_helis)||level.pix_helis.size<=0)
	{
		return;
	}
	for(i=0;i<level.pix_helis.size;i++)
	{
		level.pix_helis[i] dodamage((level.pix_helis[i].health*99999),(0,0,0));
	}
}


setUpBotSettings(bottype,health,money_hit,money_kill,money_headshot)
{
	if(bottype=="default")
	{
		level.default_botHealth = health;
		level.default_money_for_hit = money_hit;
		level.default_money_for_kill = money_kill;
		level.default_money_for_headshot = money_headshot;
	}
	else if(bottype=="dog")
	{
		level.dog_botHealth = health;
		level.dog_money_for_hit = money_hit;
		level.dog_money_for_kill = money_kill;
		level.dog_money_for_headshot = money_headshot;
	}
	else if(bottype=="jugger")
	{
		level.jugger_botHealth = health;
		level.jugger_money_for_hit = money_hit;
		level.jugger_money_for_kill = money_kill;
		level.jugger_money_for_headshot = money_headshot;
	}
}
setUpBotsForWave(defaults,dogs,juggers)
{
	level.botsForWave["default"] = defaults;
	level.botsForWave["dog"] = dogs;
	level.botsForWave["jugger"] = juggers;
	level.botsForWave["total"] = defaults+dogs+juggers;
}







addSpawner(id,type,origin)
{
	if(!isDefined(level.pix_spawner))
	{
		level.pix_spawner = [];
	}
	i = level.pix_spawner.size;
	level.pix_spawner[i] = spawnStruct();
	level.pix_spawner[i].id = id;
	level.pix_spawner[i].type = type;//default,dog,jugger
	changeSpawnerOrigin(id,origin);
}
changeSpawnerOrigin(id,origin)
{
	spawner = GetSpawnerArray();
	spawner[id].origin = origin;
}
getRandomSpawner(type)
{
	list = [];
	for(i=0;i<level.pix_spawner.size;i++)
	{
		if(level.pix_spawner[i].type==type)
		{
			list[list.size] = level.pix_spawner[i].id;
		}
	}
	return list[randomInt(list.size)];
}