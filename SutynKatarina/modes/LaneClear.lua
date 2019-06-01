local lane = {}


local p = module.load("sutynkatarina", "spell/Passive");
local q = module.load("sutynkatarina", "spell/q");
local w = module.load("sutynkatarina", "spell/w");
local e = module.load("sutynkatarina", "spell/e");
local misc = module.load("sutynkatarina", "modes/misc");
local menu = module.load("sutynkatarina", "menu");
local AC = module.load("sutynkatarina", "modes/PermaActive");


local Notminions = {
    ["CampRespawn"] = true,
    ["PlantMasterMinion"] = true,
    ["PlantHealth"] = true,
    ["PlantSatchel"] = true,
    ["PlantVision"] = true,
}

lane.GetMinionsHit = function(Pos, radius)
	local count = 0
    for i = 0, objManager.minions.size[TEAM_ENEMY] - 1 do
        local minion = objManager.minions[TEAM_ENEMY][i]
		if minion.pos:dist(Pos) < radius and not minion.isDead and minion.isVisible and not minion.name:find("Ward") and not Notminions[minion.name] then
			count = count + 1
		end
	end
	return count
end

lane.Count_Minion = function(pos, range)
	local enemies = {}
	for i = 0, objManager.minions.size[TEAM_ENEMY] - 1 do
		local enemy = objManager.minions[TEAM_ENEMY][i]
		if pos:dist(enemy.pos) < range and not enemy.isDead and enemy.isVisible then
			enemies[#enemies + 1] = enemy
		end
	end
	return enemies
end

lane.GetPercenteLife = function()
    return (player.health / player.maxHealth) * 100
end

lane.GetClosestDagger = function()
    for i, Daggers in pairs(p.Hidden) do
        if Daggers then
            if Daggers.StartTime <= game.time then
                return Daggers;
            end 
        end 
    end
    return;
end

lane.LaneFarming = function()
    for i = 0, objManager.minions.size[TEAM_ENEMY] - 1 do
        local minion = objManager.minions[TEAM_ENEMY][i]
        if minion and not minion.isDead and minion.isVisible and minion.health > 0 and not minion.name:find("Ward") and not Notminions[minion.name] then
            if minion.pos:dist(player.pos) <= q.range then
                local Hit = lane.GetMinionsHit(minion, 600)
                if q.isready() and menu.farm.fq:get() then
                    if Hit >= menu.farm.creeps:get() then
                        player:castSpell("obj", 0, minion);
                        return;
                    end
                end
            end
            if w.isready() and menu.farm.fw:get() then
                if #lane.Count_Minion(player.pos, 375) >= 5 then
                    player:castSpell("self", 1);
                    return;
                end
            end
            if e.isready() and menu.farm.fe:get() then
                local daga = lane.GetClosestDagger();
                if daga and daga.Position:dist(player.pos) <= e.range then
                    if not misc.IsUnderTurretEnemy(daga.Position) and (#AC.EnemiesInRange(player.pos, e.range) <= 1) and lane.GetPercenteLife() >= 50 then
                        local best_pos = daga.Position + (minion.pos - daga.Position):norm() * 230
                        player:castSpell("pos", 2, best_pos);
                        return;
                    end
                end
            end
        end
    end
end

return lane; 