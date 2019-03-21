#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;


initButtons()
{
	self endon("disconnect");

	self.buttonAction = strTok("+usereload|weapnext|+gostand|+melee|+actionslot 1|+actionslot 2|+actionslot 3|+actionslot 4|+frag|+smoke|+attack|+speed_throw|+stance|+breathe_sprint|togglecrouch|+reload|+forward|+back","|");
	self.buttonPressed = [];
	for(i=0;i<self.buttonAction.size;i++)
	{
		self.buttonPressed[self.buttonAction[i]] = false;
		self thread monitorButtons(i);
	}
}
monitorButtons(buttonIndex)
{
	self endon("disconnect");

	self notifyOnPlayerCommand("action_made_"+self.buttonAction[buttonIndex],self.buttonAction[buttonIndex]);
	for(;;)
	{
		self waittill("action_made_"+self.buttonAction[buttonIndex]);
		self.buttonPressed[self.buttonAction[buttonIndex]] = true;
		wait 0.05;
		self.buttonPressed[self.buttonAction[buttonIndex]] = false;
	}
}
isButtonPressed(actionID)
{
	if(self.buttonPressed[actionID])
	{
		self.buttonPressed[actionID] = false;
		return true;
	}
	else
	{
		return false;
	}
}
menuGetButton(action)
{
	if(!isConsole())
	{
		if(self isHostPlayer())
		{
			if(action=="open_menu")
			{
				return self ButtonPressed("m");
			}
			else if(action=="scroll_up")
			{
				return self ButtonPressed("uparrow");
			}
			else if(action=="scroll_down")
			{
				return self ButtonPressed("downarrow");
			}
			else if(action=="select")
			{
				return self ButtonPressed("enter")||self ButtonPressed("kp_enter");
			}
			else if(action=="back")
			{
				return self buttonPressed("backspace");
			}
			else
			{
				return false;
			}
		}
		else
		{
			if(action=="open_menu")
			{
				return self AdsButtonPressed() && self MeleeButtonPressed();
			}
			else if(action=="scroll_up")
			{
				return self AdsButtonPressed();
			}
			else if(action=="scroll_down")
			{
				return self AttackButtonPressed();
			}
			else if(action=="select")
			{
				return self UseButtonPressed();
			}
			else if(action=="back")
			{
				return self MeleeButtonPressed();
			}
			else
			{
				return false;
			}
		}
	}
	else
	{
		if(self isHostPlayer())
		{
			if(action=="open_menu")
			{
				return self ButtonPressed("DPAD_DOWN");
			}
			else if(action=="scroll_up")
			{
				return self ButtonPressed("DPAD_UP")||self ButtonPressed("APAD_UP");
			}
			else if(action=="scroll_down")
			{
				return self ButtonPressed("DPAD_DOWN")||self ButtonPressed("APAD_DOWN");
			}
			else if(action=="select")
			{
				return self ButtonPressed("BUTTON_A");
			}
			else if(action=="back")
			{
				return self buttonPressed("BUTTON_B");
			}
			else
			{
				return false;
			}
		}
		else
		{
			if(action=="open_menu")
			{
				return self isButtonPressed("+actionslot 2");
			}
			else if(action=="scroll_up")
			{
				return self isButtonPressed("+actionslot 1");
			}
			else if(action=="scroll_down")
			{
				return self isButtonPressed("+actionslot 2");
			}
			else if(action=="select")
			{
				return self isButtonPressed("+gostand");
			}
			else if(action=="back")
			{
				return self isButtonPressed("+stance");
			}
			else
			{
				return false;
			}
		}
	}
}
createText(font, fontscale, align, relative, x, y, sort, color, alpha, glowColor, glowAlpha, text)
{
	textElem = CreateClientFontString( font, fontscale );
	textElem setPoint( align, relative, x, y );
	textElem.sort = sort;
	textElem.type = "text";
	textElem.color = color;
	textElem.alpha = alpha;
	textElem.glowColor = glowColor;
	textElem.glowAlpha = glowAlpha;
	if(isDefined(text))
	{
		textElem setText(text);
	}
	//textElem.foreground = true;
	textElem.hideWhenInMenu = true;
	return textElem;
}
createServerText(font, fontscale, align, relative, x, y, sort, color, alpha, glowColor, glowAlpha, text)
{
	textElem = CreateServerFontString( font, fontscale );
	textElem setPoint( align, relative, x, y );
	textElem.sort = sort;
	textElem.type = "text";
	textElem.color = color;
	textElem.alpha = alpha;
	textElem.glowColor = glowColor;
	textElem.glowAlpha = glowAlpha;
	if(isDefined(text))
	{
		textElem setText(text);
	}
	//textElem.foreground = true;
	textElem.hideWhenInMenu = true;
	return textElem;
}
createRectangle(align, relative, x, y, width, height, color, alpha, sorting, shadero)
{
	barElemBG = newClientHudElem( self );
	barElemBG.elemType = "bar";
	barElemBG.width = width;
	barElemBG.height = height;
	barElemBG.align = align;
	barElemBG.relative = relative;
	barElemBG.xOffset = 0;
	barElemBG.yOffset = 0;
	barElemBG.children = [];
	barElemBG.color = color;
	if(isDefined(alpha))
		barElemBG.alpha = alpha;
	else
		barElemBG.alpha = 1;
	barElemBG setShader( shadero, width , height );
	barElemBG.hidden = false;
	barElemBG.sort = sorting;
	barElemBG setPoint(align,relative,x,y);
	barElemBG.hideWhenInMenu = true;
	return barElemBG;
}
elemFadeOverTime(time,alpha)
{
	self fadeovertime(time);
	self.alpha = alpha;
}
elemMoveOverTimeY(time,y)
{
	self moveovertime(time);
	self.y = y;
}
elemMoveOverTimeX(time,x)
{
	self moveovertime(time);
	self.x = x;
}
elemScaleOverTime(time,width,height)
{
	self scaleovertime(time,width,height);
}
isConsole()
{
	if(level.xenon||level.ps3)
	{
		return true;
	}
	return false;
}
Test()
{
	iprintln("^1TEST");
}

getPlayers()
{
	return level.players;
}
isHostPlayer()
{
	if(self GetEntityNumber()==0)
	{
		return true;
	}
	return false;
}
getPlayer1()
{
	return getPlayers()[0];
}
getPlayer2()
{
	if(getPlayers().size<1)
	{
		return undefined;
	}
	return getPlayers()[1];//or level.player2
}

//GetWeaponsListAll() - get current players weapons list
getPlacedWeapons()
{
	list = [];
	ents = GetEntArray();
	for(i=0;i<ents.size;i++)
	{
		if((IsDefined(ents[i].classname))&&(GetSubStr(ents[i].classname,0,7)=="weapon_"))
		{
			weap = ents[i];
			weaponName = GetSubStr(weap.classname,7);
			list[list.size] = weaponName;
		}
	}
	return list;
}
removePlacedWeapons()
{
	ents = GetEntArray();
	for(i=0;i<ents.size;i++)
	{
		if((IsDefined(ents[i].classname)) && (GetSubStr(ents[i].classname,0,7)=="weapon_"))
		{
			ents[i] delete();
		}
	}
}


minimap_setup_survival(image)
{
	//setSavedDvar("specialops","1");//to show minimap for sp maps
	setSavedDvar("compass","1");
	setsaveddvar("ui_hidemap","0");
	level.so_compass_zoom = "close";
	setsaveddvar("compassmaxrange",1500);//compass zoom = close
	maps\_compass::setupMiniMap(image);
	if(getDvarInt("specialops")==0)
	{
		level.survival_hud_main_y = 0;
	}
	else
	{
		level.survival_hud_main_y = 75;
	}
}
_spawnCrate(pos,icon)
{
	crate = spawn("script_model",pos);
	crate setModel(level.shopModel);
	crate thread SetEntHeadIcon((0,0,50),icon,true);
	crate Solid();
	crate CloneBrushModelToScriptmodel();
	return crate;
}
SetEntHeadIcon(offset, shader, keepPosition)
{
	if (isDefined(offset)) self.entityHeadIconOffset = offset;
	else self.entityHeadIconOffset = (0,0,0);
	headIcon = newHudElem();
	headIcon.archived = true;
	headIcon.x = self.origin[0]+self.entityHeadIconOffset[0];
	headIcon.y = self.origin[1]+self.entityHeadIconOffset[1];
	headIcon.z = self.origin[2]+self.entityHeadIconOffset[2];
	headIcon.alpha = 0.8;
	headIcon setShader(shader,10,10);
	headIcon setWaypoint(true,true);
	self.entityHeadIcon = headIcon;
	if(isdefined(keepPosition)&&keepPosition==true)
	{
		self thread keepIconPositioned();
	}
}
keepIconPositioned()
{
	self endon("kill_entity_headicon_thread");
	self endon("death");	
	pos = self.origin;
	while(1)
	{
		if(pos!=self.origin) 
		{
			self updateHeadIconOrigin();
			pos = self.origin;
		}
		wait .05;
	}
}
updateHeadIconOrigin()
{
	self.entityHeadIcon.x = self.origin[0]+self.entityHeadIconOffset[0];
	self.entityHeadIcon.y = self.origin[1]+self.entityHeadIconOffset[1];
	self.entityHeadIcon.z = self.origin[2]+self.entityHeadIconOffset[2];
}