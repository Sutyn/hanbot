local Passeive = { }
Passeive.Hidden, Passeive.HiddenCount = {}, 0;

local DaggerMutiplis = 0;
Passeive.LevelDamager = function()
    local DaggerMutiplis = 0;
    local level1to6 = {1, 55};
    local level6to11 = {6, 70};
    local level11to16 = {11, 85};
    local level16 = {16, 100};
    if (player.levelRef >= 1 and player.levelRef < 6) then
        DaggerMutiplis = level1to6
    end
    if (player.levelRef >= 6 and player.levelRef < 11) then
        DaggerMutiplis = level6to11
    end
    if (player.levelRef >= 11 and player.levelRef < 16) then
        DaggerMutiplis = level11to16
    end
    if (player.levelRef >= 16) then
        DaggerMutiplis = level16
    end
    return DaggerMutiplis
end

Passeive.Redution = function(target)
    local magicResist = (target.spellBlock * player.percentMagicPenetration) - player.flatMagicPenetration
    return magicResist >= 0 and (100 / (100 + magicResist)) or (2 - (100 / (100 - magicResist)))
end

Passeive.GetSpellDamage = function(target)
    if target then
        local Damage = 0;
        local Passive = 0;
        local Special =  {75, 80, 87, 94, 102, 111, 120, 131, 143, 155, 168, 183, 198, 214, 231, 248, 267, 287};
        if player.levelRef <= 18 then
            Damage = (Special[player.levelRef] + ((player.baseAttackDamage + player.flatPhysicalDamageMod) * player.percentPhysicalDamageMod) - player.baseAttackDamage + (player.flatMagicDamageMod * player.percentMagicDamageMod * DaggerMutiplis))
        end 
        if player.levelRef > 18 then
            Damage = (Special[18] + ((player.baseAttackDamage + player.flatPhysicalDamageMod) * player.percentPhysicalDamageMod) - player.baseAttackDamage + (player.flatMagicDamageMod * player.percentMagicDamageMod * DaggerMutiplis))
        end
        return Damage * Passeive.Redution(target)
	end
end

cb.add(cb.create_particle, function(obj)
    if player.pos:dist(obj.pos) > 2500 then return end
    --chat.print(obj.name)
    if obj.name:find("W_Indicator_Ally") then        
        Passeive.Hidden[obj.ptr] = {StartTime = game.time + 1.25, EndTime = game.time + 5.1, Position = obj.pos, Width = 150}
        Passeive.HiddenCount = Passeive.HiddenCount + 1        
    end 
end)

cb.add(cb.delete_particle, function(obj)
    if Passeive.Hidden[obj.ptr] then
        Passeive.Hidden[obj.ptr] = nil
        Passeive.HiddenCount = Passeive.HiddenCount - 1  
    end
end)

return Passeive