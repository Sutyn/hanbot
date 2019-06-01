local combo = { }

local p = module.load("sutynkatarina", "spell/Passive");
local q = module.load("sutynkatarina", "spell/q");
local w = module.load("sutynkatarina", "spell/w");
local e = module.load("sutynkatarina", "spell/e");
local r = module.load("sutynkatarina", "spell/r");
local Ts = module.load("sutynkatarina", "TargetSelector");
local misc = module.load("sutynkatarina", "modes/misc");
local menu = module.load("sutynkatarina", "menu");
local AC = module.load("sutynkatarina", "modes/PermaActive");

combo.GetPercenteLife = function()
    return (player.health / player.maxHealth) * 100
end

local W_Time = 0;
combo.Combo_Kat = function()
    local target = Ts.TargetSelection();
    if (target) then
        if menu.Combo.human:get() then
            if r.HasBuffed(player, "katarinarsound") then return end 
            if (menu.Combo.use:get() and e.isready()) then
                if player.pos:dist(target.pos) <= e.range then
                    e.get_caste(target.pos)
                end
                for i, Daggers in pairs(p.Hidden) do
                    if Daggers then
                        if Daggers.StartTime <= game.time and player.pos:dist(Daggers.Position) > 150 and Daggers.Position:dist(player.pos) <= e.range  then                     
                            local DaggerSpell = Daggers.Position + (target.pos - Daggers.Position):norm() * 230
                            if target.pos:dist(Daggers.Position) <= w.range then
                                e.get_caste_dagger(DaggerSpell);
                                return
                            end
                        end 
                    end 
                end
            end
            if w.isready() and menu.Combo.usw:get() then
                if target.pos:dist(player.pos) <= w.range then
                    player:castSpell("self", 1);
                    W_Time = game.time
                    return
                end
            end
            if q.isready() and menu.Combo.usq:get() then
                if target.pos:dist(player.pos) <= q.range then
                    if game.time - W_Time > 0.250 then
                        player:castSpell("obj", 0, target);
                        return
                    end
                end
            end
            if (r.isready() and menu.Combo.usr:get()) then
                if (#AC.EnemiesInRange(player.pos, menu.Combo.MaxRange:get()) >= menu.Combo.Minimum:get()) then 
                    if e.GetSpellDamage(target) + q.GetSpellDamage(target) + p.GetSpellDamage(target) >= target.health then return end
                    if game.time - W_Time > 0.250 then
                        player:castSpell("pos", 3, target.pos);
                        return
                    end
                end
            end
        else
            if e.isready() and target.pos:dist(player.pos) <= e.range and menu.Combo.use:get() then
                for i, Daggers in pairs(p.Hidden) do
                    if Daggers then
                        if Daggers.StartTime <= game.time and player.pos:dist(Daggers.Position) > 150 and Daggers.Position:dist(player.pos) <= e.range  then
                            local DaggerSpell = Daggers.Position + (target.pos - Daggers.Position):norm() * 230
                            if target.pos:dist(Daggers.Position) <= w.range then
                                e.get_caste_dagger(DaggerSpell);
                                return
                            end
                        end
                    end  
                end
                if player.pos:dist(target.pos) <= e.range then
                    e.get_caste(target.pos)
                end
            end
            if q.isready() and menu.Combo.usq:get() then
                if target.pos:dist(player.pos) <= q.range then
                    player:castSpell("obj", 0, target);
                    return
                end
            end
            if w.isready() and menu.Combo.usw:get() then
                if target.pos:dist(player.pos) <= w.range then
                    player:castSpell("self", 1);
                    return
                end
            end
            if r.isready() and menu.Combo.usr:get() then
                if (#AC.EnemiesInRange(player.pos, menu.Combo.MaxRange:get()) >= menu.Combo.Minimum:get()) then 
                    if e.GetSpellDamage(target) + q.GetSpellDamage(target) + p.GetSpellDamage(target) >= target.health then return end
                    player:castSpell("pos", 3, target.pos);
                    return
                end
            end
        end
    end
end

return combo;