local Katarina = objManager.player;

local w = {
    sSpell = Katarina:spellSlot(1),
    range = 375,
}

w.isready = function()
    return w.sSpell.state == 0;
end

w.iscooldown = function()
    return w.sSpell.cooldown;
end


return w
