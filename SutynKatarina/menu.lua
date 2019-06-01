local q = module.load("sutynkatarina", "spell/q");
local w = module.load("sutynkatarina", "spell/w");
local r = module.load("sutynkatarina", "spell/r");
--Menu

local _Katsu = menu("sutynkatarina", "SutynKataria");

_Katsu:menu("Combo", "Combo settings");
_Katsu.Combo:header('combo', 'Combo Header');
_Katsu.Combo:boolean("human", "Combo Humanizer", false);
--Combo:
_Katsu.Combo:boolean("usq", "Use Q", true);
_Katsu.Combo:boolean("usw", "Use W", true);
_Katsu.Combo:boolean("use", "Use E", true);
_Katsu.Combo:boolean("usr", "Use R", true);
--RSettings:
_Katsu.Combo:header('Rsettings', 'R settings');
_Katsu.Combo:slider("Minimum", "Minimum enemies to use R.", 1, 0, 5, 1);
_Katsu.Combo:slider("MaxRange", "Maximum R range to cast.", w.range, 0, r.range, 1, w.range);
_Katsu.Combo:boolean("useposr", "Use E -> Cancel Pos Lotus", true);
--Author:
_Katsu.Combo:header("Another", "Another settings");
_Katsu.Combo:slider("Saver", "Don't go in if my health <= {0}% and QW is not ready.", 15, 0, 100, 1);
_Katsu.Combo:boolean("Turret", "Allow E jump under enemy turret.", false);
_Katsu.Combo:slider("TurretMinHP", "My health must be >= {0}% to allow enter under enemy tower.", 35, 0, 100, 1);
--Harass
_Katsu:menu("harass", "Harass settings");
_Katsu.harass:header('haras', 'Harass Header');
_Katsu.harass:boolean("harassq", "Enable Q in harass mode.", true);
_Katsu.harass:keybind("hsKey", "Harass Key", "C", nil)
_Katsu.harass:header('harass', 'Auto-Harass Settings');
_Katsu.harass:boolean("harassa", "Enable auto harass with Q.", true);
_Katsu.harass:slider("Auto", "Auto harass chance.", 50, 0, 100, 1);
--Farm
_Katsu:menu("farm", "Farming settings");
_Katsu.farm:header('farm', 'Farming Header');
_Katsu.farm:boolean("fq", "Use Q in lane / jugnle clear.", true);
_Katsu.farm:boolean("fw", "Use W in lane.", false);
_Katsu.farm:boolean("fe", "Use E in lane / jugnle clear.", true);
_Katsu.farm:header('farm1', 'Lane/Jungle');
_Katsu.farm:boolean("ignore", "Ignore Q count in jungle clear.", true);
_Katsu.farm:slider("creeps", "Use Q if creeps count", 3, 0, 5, 1);
_Katsu.farm:header('last', 'Last hit settings');
_Katsu.farm:boolean("lastq", "Use Q in last hit mode.", true);
_Katsu.farm:header('farm1s', 'Key Header');
_Katsu.farm:keybind("clear", "Farming Key", "V", nil);
_Katsu.farm:keybind("lasthist", "LastHit Key", "X", nil);
--Misc
_Katsu:menu("misc", "Misc settings");
_Katsu.misc:header('mics', 'Misc Header');
_Katsu.misc:boolean("kilq", "Enable Kill Steal with Q.", true);
_Katsu.misc:boolean("kile", "Enable Kill Steal with E.", true);
_Katsu.misc:slider("MinHP", "Your HP must be >= {0}% to use E / Q+E.", 35, 0, 100, 1);
--Flee
_Katsu:menu("flee", "Flee settings");
_Katsu.flee:header('fleed', 'Flee Soon!');
--[[_Katsu.flee:boolean("fleeally", "Enable jump to ally.", true);
_Katsu.flee:boolean("fleedagger", "Enable jump to dagger.", true);
_Katsu.flee:boolean("fleeminion", "Enable jump to ally minion.", true);
_Katsu.flee:boolean("fleeenemymion", "Enable jump to enemy minion.", true);
_Katsu.flee:boolean("fleeemonster", "Enable jump to monster.", true);
_Katsu.flee:slider("MonsterHP", "Enable jump to monster when HP > {0}%", 15, 0, 100, 1);
_Katsu.flee:slider("CursorRange", "Jump to cursor target detect range. ", 200, 0, 250, 1);
_Katsu.flee:keybind('fleeswitch', 'Flee Key', 'Z', nil)]]
--Drawings
_Katsu:menu("Draw", "Drawing settings");
_Katsu.Draw:header('drawing', 'Drawing Header');
_Katsu.Draw:boolean("drawq", "Draw Q range", false);
_Katsu.Draw:boolean("draww", "Draw W range", false);
_Katsu.Draw:boolean("drawe", "Draw E range", true);
_Katsu.Draw:boolean("drawr", "Draw R range", false);
_Katsu.Draw:boolean("drawobj", "Draw daggers", true);

return _Katsu