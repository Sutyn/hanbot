local haras = {}

local q = module.load("sutynkatarina", "spell/q");
local Ts = module.load("sutynkatarina", "TargetSelector");
local menu = module.load("sutynkatarina", "menu");

haras.YouHarass = function()
    if (menu.harass.hsKey:get()) then
        local target = Ts.TargetSelection();
        if (target) then
            if (q.isready() and player.pos:dist(target.pos) <= q.range) then
                player:castSpell("obj", 0, target)
                return;
            end
        end
	end
end

return haras