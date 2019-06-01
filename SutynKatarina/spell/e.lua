local Katarina = objManager.player;
local q = module.load("sutynkatarina", "spell/q");
local w = module.load("sutynkatarina", "spell/w");
local misc = module.load("sutynkatarina", "modes/misc");
local menu = module.load("sutynkatarina", "menu");

local e = {
    sSpell = Katarina:spellSlot(2),
    range = 725,
}

e.isready = function()
    return e.sSpell.state == 0;
end

e.iscooldown = function()
    return e.sSpell.cooldown;
end

e.get_caste = function(position)
    if ((player.health / player.maxHealth) <= menu.Combo.Saver:get() and not q.isready() and not w.isready()) then return end
    if misc.IsUnderTurretEnemy(position) and menu.Combo.Turret:get() and (player.health / player.maxHealth) * 100 >= menu.Combo.TurretMinHP:get() then 
        player:castSpell("pos", 2, position); 
    elseif not misc.IsUnderTurretEnemy(position) then 
        player:castSpell("pos", 2, position);
    end
    return;
end

e.get_caste_dagger = function(position)
    if not e.isready() then return end
    if misc.IsUnderTurretEnemy(position) and menu.Combo.Turret:get() and (player.health / player.maxHealth) * 100 >= menu.Combo.TurretMinHP:get() then 
        player:castSpell("pos", 2, position); 
    elseif not misc.IsUnderTurretEnemy(position) then 
        player:castSpell("pos", 2, position);
    end
    return;
end


e.Redution = function(target)
    local magicResist = (target.spellBlock * Katarina.percentMagicPenetration) - Katarina.flatMagicPenetration
    return magicResist >= 0 and (100 / (100 + magicResist)) or (2 - (100 / (100 - magicResist)))
end
e.GetSpellDamage = function(target)
    local rbasedamage = (({ 15, 30, 45, 60, 75 })[e.sSpell.level] + 0.25 * (Katarina.flatMagicDamageMod * Katarina.percentMagicDamageMod) + 0.5 * ((Katarina.baseAttackDamage + Katarina.flatPhysicalDamageMod)*(1 + Katarina.percentPhysicalDamageMod)))
    if target then
        return rbasedamage * e.Redution(target)
    end
end

return e