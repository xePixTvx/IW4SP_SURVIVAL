#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;

#include pix\shop\_menu;


_supportShopStruct()
{
	self CreateMenu("main","Support Shop","Exit");
	self addOption("main","+1 Weaponslot[Current Slots: "+self.max_weapons+"]",::_buyWeaponSlot,1000,"",1000);
	self addOption("main","+10 Armor[Current Armor: "+self.armor+"]",::_buyArmor,500,"",500);
	if(isDefined(level.DeltaSquad_Active))
	{
		self addOption("main","Delta Squad",::_buyDeltaSquad,level.DeltaSquad_price,"",level.DeltaSquad_price);
	}
	if(isDefined(level.MortarStrike_Supported))
	{
		self addOption("main","Mortar Strike",::_buyMortarStrike,level.MortarStrike_price,"",level.MortarStrike_price);
	}
	if(isDefined(level.PredatorDrone_Supported))
	{
		self addOption("main","Predator Missile",::_buyPredatorDrone,level.PredatorDrone_price,"",level.PredatorDrone_price);
	}
}


//Weapon slot & armor buying
_buyWeaponSlot(price)
{
	if(self.max_weapons>=4)
	{
		iprintlnBold("^1You cant buy more slots!");
		return;
	}
	if(self.Money<price)
	{
		iprintlnBold("^1Not Enough Money");
		return;
	}
	self pix\player\_money::_takeMoney(price);
	self.max_weapons ++;
	self _updateMenu();
}
_buyArmor(price)
{
	if(self.armor>=200)
	{
		iprintlnBold("^1You cant buy more Armor!");
		return;
	}
	if(self.Money<price)
	{
		iprintlnBold("^1Not Enough Money");
		return;
	}
	self pix\player\_money::_takeMoney(price);
	self.armor += 10;
	self.Hud["Armor_text"] setValue(self.armor);
	if(self.Hud["Armor_text"].alpha==0)
	{
		self pix\player\_player::_showArmorHud();
	}
	self _updateMenu();
}


//Delta Squad buying
_buyDeltaSquad(price)
{
	if(level.DeltaSquad_Active)
	{
		iprintlnBold("^1Delta Squad already active!");
		return;
	}
	if(self.Money<price)
	{
		iprintlnBold("^1Not Enough Money");
		return;
	}
	self pix\player\_money::_takeMoney(price);
	level.DeltaSquad_Active = true;
	thread _monitorDeltaSquadAlive();
	wait .2;
	for(i=0;i<level.DeltaSquad.size;i++)
	{
		thread _spawnDeltaSquadGuy(level.DeltaSquad[i].id,self);
		wait .2;
	}
	
}
_spawnDeltaSquadGuy(id,owner)
{
	spawners = GetSpawnerArray();
	spawners[id].script_forcespawn = true;
	spawners[id].script_playerseek = true;
	spawners[id].script_pacifist = undefined;
	spawners[id].script_ignoreme = undefined;
	spawners[id].dontdropweapon = undefined;
	spawners[id].script_stealth = undefined;
	spawners[id].count = 9999;
	
	bot = spawners[id] stalingradspawn();
	bot.team = "allies";
	bot.health = 6000;//6000;
	bot.deltasquad_owner = owner;
	bot thread _deltasquad_guy_monitor_death();
	level.DeltaSquad_guys_alive ++;
}
_deltasquad_guy_monitor_death()
{
	self endon("dsg_death");
	for(;;)
	{
		self waittill("death");
		level notify("deltasquad_died");
		self notify("dsg_death");
		wait 0.05;
	}
}
_monitorDeltaSquadAlive()
{
	level endon("deltasquad_over");
	for(;;)
	{
		level waittill("deltasquad_died");
		level.DeltaSquad_guys_alive --;
		if(level.DeltaSquad_guys_alive<=0)
		{
			level.DeltaSquad_Active = false;
			level notify("deltasquad_over");
		}
		wait 0.05;
	}
}
setUpDeltaSquad(spawner_id,spawnpoint)
{
	if(!isDefined(level.DeltaSquad))
	{
		level.DeltaSquad = [];
	}
	i = level.DeltaSquad.size;
	level.DeltaSquad[i] = spawnstruct();
	level.DeltaSquad[i].id = spawner_id;
	level.DeltaSquad[i].spawnpoint = spawnpoint;
	pix\bot\_bot::changeSpawnerOrigin(spawner_id,spawnpoint);
}



//Mortar Strike Buying
_buyMortarStrike(price)
{
	if(self.hasMortarStrike)
	{
		iprintlnBold("^1You already have a Mortar Strike!");
		return;
	}
	if(self.Money<price)
	{
		iprintlnBold("^1Not Enough Money");
		return;
	}
	self pix\player\_money::_takeMoney(price);
	self thread _mortarStrike();
}
_mortarStrike()
{
	iprintlnBold("^1Shoot to mark the mortar location!");
	self.hasMortarStrike = true;
	wait .2;
	oldWeapon = self getCurrentWeapon();
    self GiveWeapon("defaultweapon");
    wait 0.4;
	self freezeControls(false);
    self switchToWeapon("defaultweapon");
    wait 0.4;
	self endon("mortar_launched");
	for(;;)
	{
		self waittill("weapon_fired");
		if((self getCurrentWeapon() == "defaultweapon") && self.hasMortarStrike)
		{
			pos = self GetCursorPosMortar();
			self thread mortar_fire(pos);
			self.hasMortarStrike = false;
			self switchToWeapon(oldWeapon);
			self takeWeapon("defaultweapon");
			self notify("mortar_launched");
		}
		wait 0.05;
	}
}
mortar_fire(position)
{
	iprintlnBold("^1Mortar Strike Incoming!");
	wait 4;
	sky = position+(0,0,2500);
	mortar1 = BulletTrace(position,(position+(0,0,-100000)),0,self)["position"];
    mortar1 += (0,0,400);
    self.mortar1 = mortar1;
	s = level.MortarStrike_bullet;
	times = 8;
	wait .4;
	for(i = 0; i < times; i++)
    {
        xM = randomint(250);
        yM = randomint(250);
        zM = randomint(40);
        magicBullet(s,sky,self.mortar1+(xM,yM,zM),self);
        wait 1;
    }
}
GetCursorPosMortar()
{
    return bulletTrace(self getEye(),self getEye()+vectorScaleMortar(anglesToForward(self getPlayerAngles()),1000000),false,self)["position"];
}
vectorScaleMortar(vector,scale)
{
	return(vector[0]*scale,vector[1]*scale,vector[2]*scale);
}



//Predator Drone Buying
_buyPredatorDrone(price)
{
	if(self.hasPredatorDrone)
	{
		iprintlnBold("^1You already have a Predator Drone!");
		return;
	}
	if(self.Money<price)
	{
		iprintlnBold("^1Not Enough Money");
		return;
	}
	self pix\player\_money::_takeMoney(price);
	self thread _givePredatorDrone();
}
_givePredatorDrone()
{
	self.hasPredatorDrone = true;
	if(!self.hasPredatorDrone_Weapon)
	{
		self maps\_remotemissile::give_remotemissile_weapon(level.PredatorDrone_weaponName);
		self.hasPredatorDrone_Weapon = true;
	}
	else
	{
		self maps\_remotemissile::enable_uav(false,level.PredatorDrone_weaponName);
	}
	self endon("remove_predator");
	for(;;)
	{
		level waittill("player_fired_remote_missile");
		if(maps\_remotemissile::is_remote_missile_weapon(self getCurrentWeapon()))
		{
			level waittill( "remote_missile_exploded" );//waittill("survival_mode_predator_restored");
			//iprintln("BOOM!!!");
			self maps\_remotemissile::disable_uav(false,level.PredatorDrone_weaponName);
			/*self SetActionSlot(self maps\_remotemissile::get_remotemissile_actionslot(),"");
			self takeWeapon(level.PredatorDrone_weaponName);*/
			self.hasPredatorDrone = false;
			self notify("remove_predator");
		}
		wait 0.05;
	}
}