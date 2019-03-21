#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;

#include pix\shop\_menu;


addWeaponShopItem(str,id,price,type)
{
	s = level.weaponshop_items.size;
	level.weaponshop_items[s] = spawnStruct();
	level.weaponshop_items[s].string = str;
	level.weaponshop_items[s].id = id;
	level.weaponshop_items[s].price = price;
	level.weaponshop_items[s].type = type;
	/*types
		assault_rifle
		smg
		lmg
		sniper
		shotgun
		pistol
		equipment
	*/
}
getWeaponShopItemCount(type)
{
	count = 0;
	for(i=0;i<level.weaponshop_items.size;i++)
	{
		if(level.weaponshop_items[i].type==type)
		{
			count ++;
		}
	}
	return count;
}

_weaponShopStruct()
{
	self CreateMenu("main","Weapon Shop","Exit");
	self addOption("main","Refill Ammo",::_refillAmmo,"","",level.weaponShop_refillAmmo_price);
	if(getWeaponShopItemCount("pistol")>0)
	{
		self addOption("main","Pistols",::_loadMenu,"pist");
	}
	if(getWeaponShopItemCount("shotgun")>0)
	{
		self addOption("main","Shotguns",::_loadMenu,"shot");
	}
	if(getWeaponShopItemCount("smg")>0)
	{
		self addOption("main","SMGs",::_loadMenu,"smg");
	}
	if(getWeaponShopItemCount("assault_rifle")>0)
	{
		self addOption("main","Assault Rifles",::_loadMenu,"ar");
	}
	if(getWeaponShopItemCount("lmg")>0)
	{
		self addOption("main","LMGs",::_loadMenu,"lmg");
	}
	if(getWeaponShopItemCount("sniper")>0)
	{
		self addOption("main","Snipers",::_loadMenu,"sn");
	}
	if(getWeaponShopItemCount("equipment")>0)
	{
		self addOption("main","Equipment",::_loadMenu,"eq");
	}
	
	self CreateMenu("pist","Pistols","main");
	for(i=0;i<level.weaponshop_items.size;i++)
	{
		if(level.weaponshop_items[i].type=="pistol")
		{
			self addOption("pist",level.weaponshop_items[i].string,::_buyWeapon,level.weaponshop_items[i].id,level.weaponshop_items[i].price,level.weaponshop_items[i].price);
		}
	}
	
	self CreateMenu("shot","Shotguns","main");
	for(i=0;i<level.weaponshop_items.size;i++)
	{
		if(level.weaponshop_items[i].type=="shotgun")
		{
			self addOption("shot",level.weaponshop_items[i].string,::_buyWeapon,level.weaponshop_items[i].id,level.weaponshop_items[i].price,level.weaponshop_items[i].price);
		}
	}
	
	self CreateMenu("smg","SMGs","main");
	for(i=0;i<level.weaponshop_items.size;i++)
	{
		if(level.weaponshop_items[i].type=="smg")
		{
			self addOption("smg",level.weaponshop_items[i].string,::_buyWeapon,level.weaponshop_items[i].id,level.weaponshop_items[i].price,level.weaponshop_items[i].price);
		}
	}
	
	self CreateMenu("ar","Assault Rifles","main");
	for(i=0;i<level.weaponshop_items.size;i++)
	{
		if(level.weaponshop_items[i].type=="assault_rifle")
		{
			self addOption("ar",level.weaponshop_items[i].string,::_buyWeapon,level.weaponshop_items[i].id,level.weaponshop_items[i].price,level.weaponshop_items[i].price);
		}
	}
	
	self CreateMenu("sn","Snipers","main");
	for(i=0;i<level.weaponshop_items.size;i++)
	{
		if(level.weaponshop_items[i].type=="sniper")
		{
			self addOption("sn",level.weaponshop_items[i].string,::_buyWeapon,level.weaponshop_items[i].id,level.weaponshop_items[i].price,level.weaponshop_items[i].price);
		}
	}
	
	self CreateMenu("lmg","LMGs","main");
	for(i=0;i<level.weaponshop_items.size;i++)
	{
		if(level.weaponshop_items[i].type=="lmg")
		{
			self addOption("lmg",level.weaponshop_items[i].string,::_buyWeapon,level.weaponshop_items[i].id,level.weaponshop_items[i].price,level.weaponshop_items[i].price);
		}
	}
	
	self CreateMenu("eq","Equipment","main");
	for(i=0;i<level.weaponshop_items.size;i++)
	{
		if(level.weaponshop_items[i].type=="equipment")
		{
			self addOption("eq",level.weaponshop_items[i].string,::_buyWeapon,level.weaponshop_items[i].id,level.weaponshop_items[i].price,level.weaponshop_items[i].price);
		}
	}
}

_buyWeapon(id,price)
{
	weapons = self GetWeaponsListAll();
	foreach(wep in weapons)
	{
		if(wep==id)
		{
			iprintlnBold("^1You already have that Weapon!");
			return;
		}
	}
	if(self.Money<price)
	{
		iprintlnBold("^1Not Enough Money");
		return;
	}
	self pix\player\_money::_takeMoney(price);
	if(isSubStr(id,"_akimbo"))
	{
		self giveWeapon(id,0,true);
	}
	else
	{
		self giveWeapon(id,0);
	}
	if(self getWeaponsListPrimaries().size > self.max_weapons)
	{
		self takeWeapon(self GetCurrentWeapon());
	}
	self freezeControls(false);
	self GiveMaxAmmo(id);
	self switchToWeapon(id);
}
_refillAmmo()
{
	if(self.Money<level.weaponShop_refillAmmo_price)
	{
		iprintlnBold("^1Not Enough Money");
		return;
	}
	self pix\player\_money::_takeMoney(level.weaponShop_refillAmmo_price);
	weapons = self GetWeaponsListAll();
	foreach(wep in weapons)
	{
		self GiveMaxAmmo(wep);
	}
}