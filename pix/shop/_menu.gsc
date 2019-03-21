#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;

CONST_MENU_Y = 40;
CONST_MENU_X = 0;

open_Shop(type)
{
	self thread _wait_for_close();
	self.shop_type = type;
	if(self.shop_type == "weapon")
	{
		self.WeaponShop_Opened = true;
	}
	if(self.shop_type == "support")
	{
		self.SupportShop_Opened = true;
	}
	self.shop_scroller = [];
	self _createGUI();
	self _loadMenu("main");
	
	self endon("shopMenu_close");
	self endon("death");
	for(;;)
	{
		self freezeControls(true);
		if(self menuGetButton("scroll_up")||self menuGetButton("scroll_down"))
		{
			self.shop_scroller[self.shop_currentMenu] -= self menuGetButton("scroll_up");
			self.shop_scroller[self.shop_currentMenu] += self menuGetButton("scroll_down");
			self _scroll_update();
			wait .124;
		}
		if(self menuGetButton("select"))
		{
			self thread [[self.Shop_Menu[self.shop_currentMenu].func[self.shop_scroller[self.shop_currentMenu]]]](self.Shop_Menu[self.shop_currentMenu].input1[self.shop_scroller[self.shop_currentMenu]],self.Shop_Menu[self.shop_currentMenu].input2[self.shop_scroller[self.shop_currentMenu]]);
			wait .4;
		}
		if(self menuGetButton("back"))
		{
			if(self.Shop_Menu[self.shop_currentMenu].parent == "Exit")
			{
				self notify("shopMenu_close");
			}
			else
			{
				self _loadMenu(self.Shop_Menu[self.shop_currentMenu].parent);
			}
			wait .4;
		}
		wait 0.05;
	}
}

_wait_for_close()
{
	self waittill_any("death","shopMenu_close");
	if(self.shop_type == "weapon")
	{
		self.WeaponShop_Opened = false;
	}
	if(self.shop_type == "support")
	{
		self.SupportShop_Opened = false;
	}
	self _destroyText();
	self.BG elemFadeOverTime(.4,0);
	self.Title_line elemFadeOverTime(.4,0);
	self.Scrollbar elemFadeOverTime(.4,0);
	self.Title elemFadeOverTime(.4,0);
	wait .4;
	self.BG destroy();
	self.Title_line destroy();
	self.Title destroy();
	self.Scrollbar destroy();
	self freezeControls(false);
	self.Hud["Money_notify"].y = -20;//Move it back to default when menu is closed
}

_createGUI()
{
	self.Hud["Money_notify"].y = -70;//Move it up while the menu is opened
	
	self.BG = createRectangle("CENTER","CENTER",CONST_MENU_X,CONST_MENU_Y-17,300,155,(0,0,0),0,0,"white");
	self.Title_line = createRectangle("CENTER","CENTER",CONST_MENU_X,CONST_MENU_Y-70,300,1,(1,1,1),0,0,"white");
	self.Title_line.foreground = true;
	self.Scrollbar = createRectangle("CENTER","CENTER",CONST_MENU_X,CONST_MENU_Y-59,300,20,(1,0,0),0,0,"white");
	self.Title = createText("default",2.0,"CENTER","CENTER",CONST_MENU_X,CONST_MENU_Y-85,0,(1,1,1),0,(0,0,0),0);
	self.Title.foreground = true;
	
	self.BG elemFadeOverTime(.4,(1/1.75));
	self.Title_line elemFadeOverTime(.4,1);
	self.Scrollbar elemFadeOverTime(.4,1);
	self.Title elemFadeOverTime(.4,1);
	wait .4;
}
_createText()
{
	self.Text = [];
	for(i=0;i<7;i++)//self.Shop_Menu[self.shop_currentMenu].text.size
	{
		self.Text[i] = createText("default",1.5,"LEFT","CENTER",CONST_MENU_X-148,CONST_MENU_Y-59+(18*i),0,(1,1,1),1,(0,0,0),0,self.Shop_Menu[self.shop_currentMenu].text[i]);
		self.Text[i].foreground = true;
		
		self.price_value[i] = createText("default",1.5,"RIGHT","CENTER",CONST_MENU_X+148,CONST_MENU_Y-59+(18*i),0,(0,1,0),0,(0,0,0),0);
		self.price_value[i].label = "$";
		//self.price_value[i] setValue(0);
		self.price_value[i].foreground = true;
		if(isDefined(self.Shop_Menu[self.shop_currentMenu].price[i]))
		{
			self.price_value[i] setValue(self.Shop_Menu[self.shop_currentMenu].price[i]);
			self.price_value[i].alpha = 1;
		}
		else
		{
			self.price_value[i] setValue(0);
			self.price_value[i].alpha = 0;
		}
	}
}
_destroyText()
{
	if(isDefined(self.Text))
	{
		foreach(text in self.Text)
		{
			text destroy();
		}
		foreach(value in self.price_value)
		{
			value destroy();
		}
	}
}

_loadMenu(menu)
{
	self _destroyText();
	self.shop_currentMenu = menu;
	if(self.shop_type == "weapon")
	{
		self pix\shop\_weapon::_weaponShopStruct();
	}
	if(self.shop_type == "support")
	{
		self pix\shop\_support::_supportShopStruct();
	}
	if(!isDefined(self.shop_scroller[self.shop_currentMenu]))
	{
		self.shop_scroller[self.shop_currentMenu] = 0;
	}
	self.Title setText(self.Shop_Menu[self.shop_currentMenu].title);
	self _createText();
	self _scroll_update();
}

_scroll_update()
{
	max = 7;
	max_half = 3;
	max_half_one = 4;
	if(self.shop_scroller[self.shop_currentMenu]<0)
	{
		self.shop_scroller[self.shop_currentMenu] = self.Shop_Menu[self.shop_currentMenu].text.size-1;
	}
	if(self.shop_scroller[self.shop_currentMenu]>self.Shop_Menu[self.shop_currentMenu].text.size-1)
	{
		self.shop_scroller[self.shop_currentMenu] = 0;
	}
	if(!isDefined(self.Shop_Menu[self.shop_currentMenu].text[self.shop_scroller[self.shop_currentMenu]-max_half])||self.Shop_Menu[self.shop_currentMenu].text.size<=max)
	{
		for(i=0;i<max;i++)
		{
			if(isDefined(self.Shop_Menu[self.shop_currentMenu].text[i]))
			{
				self.Text[i] setText(self.Shop_Menu[self.shop_currentMenu].text[i]);
			}
			else
			{
				self.Text[i] setText("");
			}
			if(isDefined(self.Shop_Menu[self.shop_currentMenu].price[i]))
			{
				self.price_value[i] setValue(self.Shop_Menu[self.shop_currentMenu].price[i]);
				self.price_value[i].alpha = 1;
			}
			else
			{
				self.price_value[i] setValue(0);
				self.price_value[i].alpha = 0;
			}
		}
		self.Scrollbar.y = CONST_MENU_Y-59+(18*self.shop_scroller[self.shop_currentMenu]);
	}
	else
	{
		if(isDefined(self.Shop_Menu[self.shop_currentMenu].text[self.shop_scroller[self.shop_currentMenu]+max_half]))
		{
			pix = 0;
			for(i=self.shop_scroller[self.shop_currentMenu]-max_half;i<self.shop_scroller[self.shop_currentMenu]+max_half_one;i++)
			{
				if(isDefined(self.Shop_Menu[self.shop_currentMenu].text[i]))
				{
					self.Text[pix] setText(self.Shop_Menu[self.shop_currentMenu].text[i]);
				}
				else
				{
					self.Text[pix] setText("");
				}
				if(isDefined(self.Shop_Menu[self.shop_currentMenu].price[i]))
				{
					self.price_value[pix] setValue(self.Shop_Menu[self.shop_currentMenu].price[i]);
					self.price_value[pix].alpha = 1;
				}
				else
				{
					self.price_value[pix] setValue(0);
					self.price_value[pix].alpha = 0;
				}
				pix ++;
			}           
			self.Scrollbar.y = CONST_MENU_Y-59+(18*max_half);
		}
		else
		{
			for(i=0;i<max;i++)
			{
				self.Text[i] setText(self.Shop_Menu[self.shop_currentMenu].text[self.Shop_Menu[self.shop_currentMenu].text.size+(i-max)]);
				if(isDefined(self.Shop_Menu[self.shop_currentMenu].price[self.Shop_Menu[self.shop_currentMenu].text.size+(i-max)]))
				{
					self.price_value[i] setValue(self.Shop_Menu[self.shop_currentMenu].price[self.Shop_Menu[self.shop_currentMenu].text.size+(i-max)]);
					self.price_value[i].alpha = 1;
				}
				else
				{
					self.price_value[i] setValue(0);
					self.price_value[i].alpha = 0;
				}
			}
			self.Scrollbar.y = CONST_MENU_Y-59+(18*((self.shop_scroller[self.shop_currentMenu]-self.Shop_Menu[self.shop_currentMenu].text.size)+max));
		}
	}
}
_updateMenu()
{
	if(self.shop_type == "weapon")
	{
		self pix\shop\_weapon::_weaponShopStruct();
	}
	if(self.shop_type == "support")
	{
		self pix\shop\_support::_supportShopStruct();
	}
	self _scroll_update();
}

CreateMenu(menu,title,parent)
{
	if(!isDefined(self.Shop_Menu))self.Shop_Menu=[];
	self.Shop_Menu[menu] = spawnStruct();
	self.Shop_Menu[menu].title = title;
	self.Shop_Menu[menu].parent = parent;
	self.Shop_Menu[menu].text = [];
	self.Shop_Menu[menu].func = [];
	self.Shop_Menu[menu].input1 = [];
	self.Shop_Menu[menu].input2 = [];
	self.Shop_Menu[menu].price = [];
}
addOption(menu,text,func,inp1,inp2,price)
{
	F = self.Shop_Menu[menu].text.size;
	self.Shop_Menu[menu].text[F] = text;
	self.Shop_Menu[menu].func[F] = func;
	self.Shop_Menu[menu].input1[F] = inp1;
	self.Shop_Menu[menu].input2[F] = inp2;
	if(isDefined(price))
	{
		self.Shop_Menu[menu].price[F] = price;
	}
	else
	{
		self.Shop_Menu[menu].price[F] = undefined;
	}
}