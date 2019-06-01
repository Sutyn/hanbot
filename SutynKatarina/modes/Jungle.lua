local jungle = { }

local p = module.load("sutynkatarina", "spell/Passive");
local q = module.load("sutynkatarina", "spell/q");
local w = module.load("sutynkatarina", "spell/w");
local e = module.load("sutynkatarina", "spell/e");
local misc = module.load("sutynkatarina", "modes/misc");
local menu = module.load("sutynkatarina", "menu");
local AC = module.load("sutynkatarina", "modes/PermaActive");

jungle.GetMinionsHit = function(Pos, radius)
	local count = 0
    for i = 0, objManager.minions.size[TEAM_ENEMY] - 1 do
        local minion = objManager.minions[TEAM_ENEMY][i]
		if minion.pos:dist(Pos) < radius then
			count = count + 1
		end
	end
	return count
end

jungle.GetPercenteLife = function()
    return (player.health / player.maxHealth) * 100
end

local Notminions = {
    ["CampRespawn"] = true,
    ["PlantMasterMinion"] = true,
    ["PlantHealth"] = true,
    ["PlantSatchel"] = true,
    ["PlantVision"] = true
}

jungle.GetClosestDagger = function()
    for i, Daggers in pairs(p.Hidden) do
        if Daggers then
            if Daggers.StartTime <= game.time then
                return Daggers;
            end 
        end 
    end
    return;
end

jungle.JungleFarming = function()
    for i = 0, objManager.minions.size[TEAM_NEUTRAL] - 1 do
        local monster = objManager.minions[TEAM_NEUTRAL][i]
        if monster and not monster.isDead and monster.isVisible and monster.health > 0 and not monster.name:find("Ward") and not Notminions[monster.name] then
            if monster.pos:dist(player.pos) <= q.range then
                local Hit = jungle.GetMinionsHit(monster, 600)
                if q.isready() and menu.farm.fq:get() then
                    if not menu.farm.ignore:get() and Hit >= menu.farm.creeps:get() then return end
                    player:castSpell("obj", 0, monster);
                    return;
                end
            end
            if e.isready() and menu.farm.fe:get() then
                local daga = jungle.GetClosestDagger();
                if daga and daga.Position:dist(player.pos) <= e.range then
                    --if not misc.IsUnderTurretEnemy(daga.Position) and (#AC.EnemiesInRange(player.pos, e.range) <= 1) and jungle.GetPercenteLife() >= 50 then
                        local best_pos = daga.Position + (monster.pos - daga.Position):norm() * 230
                        player:castSpell("pos", 2, best_pos);
                        return;
                    --end
                end
            end
        end
    end
end


return jungle;