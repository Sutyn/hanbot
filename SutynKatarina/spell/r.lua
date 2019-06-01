local orb = module.internal("orb");
local vade = module.seek("evade");
local Katarina = objManager.player;
local katarinalotus = "katarinarsound";
--local Lotus = true;
--local EndTimeLotus = 0;

local r = {
    sSpell = Katarina:spellSlot(3),
    range = 550,
}

r.isready = function()
    return r.sSpell.state == 0;
end

r.iscooldown = function()
    return r.sSpell.cooldown;
end
r.HasBuffed = function(target, name)
    local buff = target.buff[type(name) == "string" and name:lower() or name]
    return buff and buff.endTime > game.time and math.max(buff.stacks, buff.stacks2) > 0
end

r.Redution = function(target)
    local magicResist = (target.spellBlock * Katarina.percentMagicPenetration) - Katarina.flatMagicPenetration
    return magicResist >= 0 and (100 / (100 + magicResist)) or (2 - (100 / (100 - magicResist)))
end
r.GetSpellDamage = function(target)
    local rbasedamage = (({ 375, 562.5, 750 })[r.sSpell.level] + (Katarina.baseAttackDamage + Katarina.flatPhysicalDamageMod) * (Katarina.percentPhysicalDamageMod - Katarina.baseAttackDamage*3.3 + Katarina.flatMagicDamageMod * Katarina.percentMagicDamageMod*2.8))
    if target then
        return rbasedamage * r.Redution(target)
    end
end

r.dancelotus = function()
    if r.HasBuffed(Katarina, katarinalotus) then
        if (vade) then
            vade.core.set_pause(math.huge)
        end
        orb.core.set_pause_move(math.huge)
        orb.core.set_pause_attack(math.huge)
    else 
        if (vade) then
			vade.core.set_pause(0)
		end
		orb.core.set_pause_move(0)
		orb.core.set_pause_attack(0)
	end
end


--cb.add(cb.create_particle, creatinglotus) Not creating R-Cast
--cb.add(cb.delete_particle, deletinglotus)

return r