--Definitys
local orbwalker = module.internal("orb");
local p = module.load("sutynkatarina", "spell/Passive");
local q = module.load("sutynkatarina", "spell/q");
local w = module.load("sutynkatarina", "spell/w");
local e = module.load("sutynkatarina", "spell/e");
local r = module.load("sutynkatarina", "spell/r");
local AC = module.load("sutynkatarina", "modes/PermaActive");
local d = module.load("sutynkatarina", "modes/Drawings");
local c = module.load("sutynkatarina", "modes/Combo");
local l = module.load("sutynkatarina", "modes/LaneClear");
local j = module.load("sutynkatarina", "modes/Jungle");
local harass = module.load("sutynkatarina", "modes/Harass");
local menu = module.load("sutynkatarina", "menu");

--Dagger: -- NOT WORKKKKKKKKKKKKKKKKKKKKKKKKKKK
--[[local function GetDagger() 
    local Diar = { }
    for i = 0, objManager.maxObjects - 1 do
        local Hidden = Diar[i];
        if Hidden and Hidden.type == TYPE_MINION then
            if Hidden.name == "HiddenMinion" and not Hidden.isDead and Hidden.isVisible and Hidden.health > 0 and not Hidden.name:find("Ward") and not NotHiddenMinion[Hidden.name] then
                return Hidden;
            end
        end 
    end
    return 0;
end]]
orbwalker.combat.register_f_pre_tick(function()
    if not r.HasBuffed(player, "katarinarsound") then 
        if not orbwalker.combat.is_active() then return end
        c.Combo_Kat();
    end 
    if player.isDead then return end;
    harass.YouHarass();
    --[[LaneClear]]
end)

cb.add(cb.draw, function()
    for i, Daggers in pairs(p.Hidden) do
        if Daggers then
            if Daggers.StartTime <= game.time then
                graphics.draw_circle(Daggers.Position, Daggers.Width, 2, graphics.argb(255, 0, 255, 0), 100)
            else 
                graphics.draw_circle(Daggers.Position, Daggers.Width, 2, graphics.argb(255, 255, 0, 0), 100)
            end
        end
    end
    --[[Draw]]--
    d.Draw_Q();
    d.Draw_W();
    d.Draw_E();
    d.Draw_R();
end)

cb.add(cb.tick, function()
    if player.isDead then return end;
    --[[Checking if Lotus is em processment]]
    r.dancelotus();
    --[[Cancel R is Lotus]]
    AC.CancelR();
    --[[Kill -> Q and E]]
    AC.KillSteal();
    --[[Harass AUTO Q]]
    if menu.harass.harassa:get() then
        AC.AutoHarassQ();
    end
    if menu.farm.clear:get() then
        --chat.print("dasdasd");
        l.LaneFarming();
        j.JungleFarming();
    end
end)
  