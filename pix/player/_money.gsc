#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;


_giveMoney(amount,headAmount)
{
	if(isDefined(headAmount))
	{
		self thread _money_notify(amount,"+",(0,1,0));
		self thread _headShot_notify(headAmount);
		self.Money += amount+headAmount;
	}
	else
	{
		self thread _money_notify(amount,"+",(0,1,0));
		self.Money += amount;
	}
	self.Hud["Money"] setValue(self.Money);
}
_takeMoney(amount)
{
	self thread _money_notify(amount,"-",(1,0,0));
	self.Money -= amount;
	self.Hud["Money"] setValue(self.Money);
}
_setMoney(amount)
{
	self.Money = amount;
	self.Hud["Money"] setValue(self.Money);
}


//Money and Headshot notifactions
_money_notify(amount,label,color)
{
	self notify("money_notify");
	self endon("money_notify");
	self.money_update += amount;
	self.Hud["Money_notify"].label = label;
	self.Hud["Money_notify"].color = color;
	self.Hud["Money_notify"] setValue(self.money_update);
	self.Hud["Money_notify"].alpha = 1;
	wait .5;
	self.Hud["Money_notify"] fadeOverTime(.4);
	self.Hud["Money_notify"].alpha = 0;
	wait .4;
	self.money_update = 0;
}
_headShot_notify(amount)
{
	self notify("headshot_notify");
	self endon("headshot_notify");
	self.headshot_update += amount;
	self.Hud["Headshot_notify"].label = "Headshot ^2+";
	self.Hud["Headshot_notify"].color = (1,1,1);
	self.Hud["Headshot_notify"] setValue(self.headshot_update);
	self.Hud["Headshot_notify"].alpha = 1;
	wait .5;
	self.Hud["Headshot_notify"] fadeOverTime(.4);
	self.Hud["Headshot_notify"].alpha = 0;
	wait .4;
	self.headshot_update = 0;
}