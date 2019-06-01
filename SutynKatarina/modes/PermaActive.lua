local Active =  { }
local orbwalker = module.internal("orb");
local p = module.load("sutynkatarina", "spell/Passive");
local q = module.load("sutynkatarina", "spell/q");
local w = module.load("sutynkatarina", "spell/w");
local e = module.load("sutynkatarina", "spell/e");
local r = module.load("sutynkatarina", "spell/r");
local Ts = module.load("sutynkatarina", "TargetSelector");
local menu = module.load("sutynkatarina", "menu");

Active.CountEnemiesInRange = function(pos, range)
    local n = 0
    for i = 0, objManager.enemies_n - 1 do
        local enemy = objManager.enemies[i]
        if not enemy.isDead then
            local objectPos = enemy.pos
            if pos:distSqr(objectPos) <= math.pow(range, 2) then
                n = n + 1
            end
        end 
        return n 
    end
end

Active.EnemiesInRange = function(pos, range)
    local Enemy_Ranger = {}
    for i = 0, objManager.enemies_n - 1 do
    	local enemy = objManager.enemies[i]
		if pos:dist(enemy.pos) < range and not enemy.isDead  then
			Enemy_Ranger[#Enemy_Ranger + 1] = enemy
        end
    end
    return Enemy_Ranger
end

Active.CancelR = function()
    local target = Ts.TargetSelection();
    if r.HasBuffed(player, "katarinarsound") then 
        if #Active.EnemiesInRange(player.pos, r.range - 10) == 0 then
            player:move(mousePos);
            if target and not target.isDead and e.isready() and menu.Combo.useposr:get() then
                e.get_caste(target.pos)
                return;
            end
        end
    end
end

Active.KillSteal = function()
    for i = 0, objManager.enemies_n - 1 do
        local united = objManager.enemies[i]
        if (united and not united.isDead and united.isVisible and united.isTargetable and not united.buff[17]) then  
            if q.isready() and united.pos:dist(player.pos) <= q.range and menu.misc.kilq:get()  then
                if united.health >= q.GetSpellDamage(united) then return end
                player:castSpell("obj", 0, united)
                return;
            end
            if e.isready() and united.pos:dist(player.pos) <= e.range and menu.misc.kile:get()  then
                if united.health >= e.GetSpellDamage(united) then return end
                player:castSpell("pos", 2, united.pos)
                return;
            end
            --[[local damage = 0;
            if (q.isready() and w.isready() and e.isready()) then
                damage = q.GetSpellDamage(united) + e.GetSpellDamage(united) + 2*r.GetSpellDamage(united);
            elseif (q.isready() and w.isready()) then
                damage = q.GetSpellDamage(united) + r.GetSpellDamage(united);
            elseif (q.isready() and e.isready()) then
                damage = q.GetSpellDamage(united) + e.GetSpellDamage(united) + r.GetSpellDamage(united);
            elseif (e.isready() and w.isready()) then
                damage = e.GetSpellDamage(united) + r.GetSpellDamage(united);
            elseif (q.isready()) then
                damage = q.GetSpellDamage(united);
            elseif (w.isready()) then
                damage = 0;
            elseif (e.isready()) then
                damage = e.GetSpellDamage(united);
            end 
            player:castSpell("pos", 2, united.pos)]]
        end
    end
end

local Limitetime = 1;
Active.Chance = function()
    if (game.time - Limitetime <= menu.harass.Auto:get()) then
        return;
    end
    Limitetime = game.time - 7000;
end

Active.AutoHarassQ = function()
    local target = Ts.TargetSelection();
    if r.HasBuffed(player, "katarinarsound") then return end 
    if orbwalker.combat.is_active() then return end
    if (target) then  
        if (q.isready() and player.pos:dist(target.pos) <= q.range) then
            if Limitetime <= menu.harass.Auto:get() then
                player:castSpell("obj", 0, target)
                return;
            end
        end
    end
    
end



return Active