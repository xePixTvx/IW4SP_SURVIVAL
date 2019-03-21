#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;
#include pix\player\_money;
#include maps\_introscreen;

_players_spawn()
{
	getPlayer1() setOrigin(level.player1_spawnPoint);
	getPlayer1() setPlayerAngles(level.player1_spawnAngle);
	getPlayer1() thread pix\player\_player::init();
	if(is_coop())//coop in actual sp missions is possible! -- atleast on pc
	{
		getPlayer2() setOrigin(level.player2_spawnPoint);
		getPlayer2() setPlayerAngles(level.player2_spawnAngle);
		getPlayer2() thread pix\player\_player::init();
	}
}

init()//init player
{
	self.Hud = [];
	self _setMoney(0);
	
	self.maxHealth = 100;//does nothing
	self.health = 100;
	self takeAllWeapons();
	self giveWeapon(level.startWeapon,0);
	self switchToWeapon(level.startWeapon);
	
	
	
	self.max_weapons = 2;//max 4 slots --- i think 6 or 7 is max but mortar also takes 1 slot soo idk
	self.armor = 20;
	self.hasMortarStrike = false;
	self.hasPredatorDrone = false;
	self.hasPredatorDrone_Weapon = false;//remote missile detonator cannot be taken away so only the first buy should give the detonator weapon
										 //if the detonator weapon is already given just enable it(uav/remote stuff gets disabled after remote_missile_exploded is notified)
										 //its a server thing so maybe it causes bugs
	
	self thread initButtons();//mostly used for the non host player
	self thread flying_intro_custom();
	
	self waittill("flying_intro_done");
	self thread _createHud();
}


flying_intro_custom()
{
	self thread weapon_pullout();
	self FreezeControls(true);
	if(ToLower(GetDvar("mapname"))=="airport")
	{
		zoomHeight = 120;
	}
	else
	{
		zoomHeight = 2000;
	}
	origin = self.origin;
	self PlayerSetStreamOrigin(origin);
	self.origin = origin+(0,0,zoomHeight);
	ent = Spawn("script_model",(69,69,69));
	ent.origin = self.origin;
	ent SetModel("tag_origin");
	ent.angles = self.angles;
	self PlayerLinkTo(ent,undefined,1,0,0,0,0);
	ent.angles = (ent.angles[0]+89,ent.angles[1],0);
	ent MoveTo(origin+(0,0,0),2,0,2);
	wait(1.00);
	wait(0.5);
	ent RotateTo((ent.angles[0]-89,ent.angles[1],0),0.5,0.3,0.2);
	wait(0.5);
	flag_set("pullup_weapon");
	self notify("flying_intro_done");
	SetSavedDvar("compass",1);
	SetSavedDvar("ammoCounterHide","0");
	SetSavedDvar("hud_showstance","1");
	SetSavedDvar("actionSlotsHide","0");
	wait(0.2);
	self Unlink();
	self FreezeControls(false);
	self PlayerClearStreamOrigin();
	thread play_sound_in_space("ui_screen_trans_in",self.origin);
	wait(0.2);
	thread play_sound_in_space("ui_screen_trans_out",self.origin);
	wait(0.2);
	flag_set("introscreen_complete");
	wait(2);
	ent Delete();

	return true;
}


_createHud()//create player hud
{
	self.Hud["Line"] = createRectangle("LEFT","CENTER",-527,208,420,1,(1,1,1),0,0,"line_horizontal");
	
	self.Hud["Money"] = createText("objective",1.5,"BOTTOMLEFT","BOTTOMLEFT",-55,28,0,(1,1,1),0,(0.3,0.6,0.3),1);
	self.Hud["Money"].label = "$";
	self.Hud["Money"] setValue(self.Money);
	
	self.Hud["Money_notify"] = createText("objective",1.5,"CENTER","CENTER",0,-20,0,(0,1,0),0,(0,1,0),0);
	self.Hud["Money_notify"].label = "+";
	self.Hud["Money_notify"] setValue(0);
	self.money_update = 0;
	
	self.Hud["Headshot_notify"] = createText("objective",1.5,"CENTER","CENTER",0,-40,0,(1,1,1),0,(0,1,0),0);
	self.Hud["Headshot_notify"].label = "Headshot ^2+";
	self.Hud["Headshot_notify"] setValue(0);
	self.headshot_update = 0;
	
	
	self.Hud["Armor_text"] = createText("objective",1.5,"BOTTOMLEFT","BOTTOMLEFT",-55,-5,0,(1,1,1),0,(0,0,0.8),1);
	self.Hud["Armor_text"].label = "Armor: ";
	self.Hud["Armor_text"] setValue(self.armor);
	self thread _armor_monitor();
	
	
	self.currentHint = "";
	self.Hud["hint"] = createText("default",1.5,"MIDDLE",undefined,0,30,0,(1,1,1),1,(0,1,0),0,self.currentHint);
	
	
	wait .4;
	self.Hud["Line"] elemFadeOverTime(.7,1);
	self.Hud["Money"] elemFadeOverTime(.7,1);
	if(self.armor>0)
	{
		self _showArmorHud();
	}
}

_armor_monitor()
{
	self endon("death");
	for(;;)
	{
		self waittill("damage");
		if(self.armor>0)
		{
			self.health = 100;
			/*if(self.damageLocation == "head")
			{
				self.armor -= 5;
			}
			else
			{*/
				self.armor --;
			//}
			self.Hud["Armor_text"] setValue(self.armor);
			if(self.armor<=0)//fixes hud bug i think
			{
				if(self.Hud["Armor_text"].alpha==1)
				{
					self _hideArmorHud();
				}
			}
		}
		else
		{
			if(self.Hud["Armor_text"].alpha==1)
			{
				self _hideArmorHud();
			}
		}
		wait 0.05;
	}
}
_showArmorHud()
{
	self.Hud["Armor_text"] elemFadeOverTime(.7,1);
}
_hideArmorHud()
{
	self.Hud["Armor_text"] elemFadeOverTime(.7,0);
}


//lowermsg system from mp?
_setHint(text)
{
	if(self.currentHint == text)
	{
		return;
	}
	self.currentHint = text;
	self.Hud["hint"] setText(self.currentHint);
}


addPlayers(spawnpoint1,spawnangles1,spawnpoint2,spawnangles2,startweapon)
{
	level.player1_spawnPoint = spawnpoint1;
	level.player1_spawnAngle = spawnangles1;
	level.player2_spawnPoint = spawnpoint2;
	level.player2_spawnAngle = spawnangles2;
	level.startWeapon = startweapon;
}