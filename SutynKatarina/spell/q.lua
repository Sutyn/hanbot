local Katarina = objManager.player;

local q = {
    sSpell = Katarina:spellSlot(0),
    range = 600,
}

q.isready = function()
    return q.sSpell.state == 0;
end

q.iscooldown = function()
    return q.sSpell.cooldown;
end

q.Redution = function(target)
    local magicResist = (target.spellBlock * Katarina.percentMagicPenetration) - Katarina.flatMagicPenetration
    return magicResist >= 0 and (100 / (100 + magicResist)) or (2 - (100 / (100 - magicResist)))
end
q.GetSpellDamage = function(target)
    local rbasedamage = (({ 75, 105, 135, 165, 195 })[q.sSpell.level] + 0.3 * (player.flatMagicDamageMod * player.percentMagicDamageMod))
    if target then
        return rbasedamage * q.Redution(target)
    end
end

return q