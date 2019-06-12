local orbwalking = module.internal("orb");
local prediction = module.internal("pred");
local TS = module.internal("TS");
local TimeWStart = 0;
local AutoAttackTrue = false; 
--Prediction:
local pred_input_Q = {
    delay = 0.25,
    speed = 1200,
    width = 75,
    boundingRadiusMod = 1,
    range = 500,
    collision = {
    minion = false,
    wall = true, 
    hero = false,
    },
};

local pred_input_E = {
    delay = 0.5,
    speed = 1200,
    width = 105,
    boundingRadiusMod = 1,
    range = 500,
    collision = {
    minion = false,
    wall = true, 
    hero = false,
    },
};

--Spells:
local ForSpells = 
{
    {Name = "Caitlyn",      MenuName = "R | Ace in the Hole", spellname = "caitlynaceinthehole", MenuValue = true},
    {Name = "FiddleSticks", MenuName = "R | Crowstorm", spellname = "Crowstorm", MenuValue = true},
    {Name = "FiddleSticks", MenuName = "W | Drain", spellname = "DrainChannel", MenuValue = true},
    {Name = "Galio",        MenuName = "R | Idol of Durand", spellname = "GalioIdolOfDurand", MenuValue = true},
    {Name = "Janna",        MenuName = "R | Monsoon", spellname = "ReapTheWhirlwind", MenuValue = true},
    {Name = "Karthus",      MenuName = "R | Requiem", spellname = "KarthusFallenOne", MenuValue = true},
    {Name = "Katarina",     MenuName = "R | Death Lotus", spellname = "KatarinaR", MenuValue = true},
    {Name = "Lucian",       MenuName = "R | The Culling", spellname = "LucianR", MenuValue = true},
    {Name = "Malzahar",     MenuName = "R | Nether Grasp", spellname = "AlZaharNetherGrasp", MenuValue = true},
    {Name = "MasterYi",     MenuName = "W | Meditate", spellname = "Meditate", MenuValue = true},
    {Name = "MissFortune",  MenuName = "R | Bullet Time", spellname = "MissFortuneBulletTime", MenuValue = true},
    {Name = "Nunu",         MenuName = "R | Absoulte Zero", spellname = "AbsoluteZero", MenuValue = true},
    {Name = "Pantheon",     MenuName = "R | Jump", spellname = "PantheonRJump", MenuValue = true},
    {Name = "Pantheon",     MenuName = "R | Fall", spellname = "PantheonRFall", MenuValue = true},
    {Name = "Shen",         MenuName = "R | Stand United", spellname = "ShenStandUnited", MenuValue = true},
    {Name = "TwistedFate",  MenuName = "R | Destiny", spellname = "Destiny", MenuValue = true},
    {Name = "Urgot",        MenuName = "R | Hyper-Kinetic Position Reverser", spellname = "UrgotSwap2", MenuValue = true},
    {Name = "Varus",        MenuName = "Q | Piercing Arrow", spellname = "VarusQ", MenuValue = true},
    {Name = "Velkoz",       MenuName = "R | Lifeform Disintegration Ray", spellname = "VelkozR", MenuValue = true},
    {Name = "Warwick",      MenuName = "R | Infinite Duress", spellname = "InfiniteDuress", MenuValue = true},
    {Name = "Xerath",       MenuName = "R | Rite of the Arcane", spellname = "XerathLocusOfPower2", MenuValue = true}
};

local IsUnderStatus = false;

local _Mor = menu("moding", "Sutyn"..player.charName);
_Mor:menu("tarhet", "TargetSelector Settings");
_Mor.tarhet:header('target', 'TargetSelector Header');
_Mor.tarhet:slider('targetdis', "Target Distance Max:", 975, 0, 1200, 1);
_Mor.tarhet:boolean("UseStwich", "Checking under enemy turret.", true);
--Have Menu
_Mor:menu("Combo", "Combo settings");
_Mor.Combo:keybind("keycomb", "Combo Key", "Space", nil)
_Mor.Combo:header('combo', 'Combo Header');
--Combo:
_Mor.Combo:boolean("usq", "Use Q", true);
_Mor.Combo:boolean("usw", "Use W", true);
_Mor.Combo:header('seE', "Death's Grasp Settings");
_Mor.Combo:boolean("use", "Use E", true);
_Mor.Combo:dropdown("emoder", "Mode to use: E", 3, {"Enemy Position", "Within range", "Burts"});
_Mor.Combo:header('seE', "Realm of Death Settings");
_Mor.Combo:boolean("usr", "Use R", true);
_Mor.Combo:dropdown("rmoder", "Mode to use: R", 2, {"Killing", "Always"});
--Harass:
_Mor:menu("Harass", "Harass Settings");
_Mor.Harass:keybind("keyharass", "Harass Key", "C", nil)
_Mor.Harass:header('harass', 'Harass Header');
_Mor.Harass:boolean("usq", "Use Q", true);
_Mor.Harass:boolean("usw", "Use W", true);
_Mor.Harass:header('seE', "Death's Grasp Settings");
_Mor.Harass:boolean("use", "Use E", true);
_Mor.Harass:dropdown("emoder", "Mode to use: E", 3, {"Enemy Position", "Within range", "Burts"});
--Jungle/Lane:
_Mor:menu("lanejungle", "Clear / Jungle Settings");
_Mor.lanejungle:keybind("keylanejungle", "Clear Key", "V", nil)
_Mor.lanejungle:header('Lanejungle', 'Clear / Jungle Header');
_Mor.lanejungle:boolean("usq", "Use Q", true);
_Mor.lanejungle:boolean("use", "Use E", false);
--Misc:
_Mor:menu("Misc", "Misc Settings");
_Mor.Misc:boolean("Inter", "Interrupt Spells:", true);
for i = 0, objManager.enemies_n - 1 do
    local enemy = objManager.enemies[i]
    for i = 1, #ForSpells do
        if enemy.charName == ForSpells[i].Name then
            ForSpells[i].MenuValue = _Mor.Misc:boolean(enemy.charName, ForSpells[i].Name.. " | "..ForSpells[i].MenuName, true);
        end 
    end
end
--//Spellls
--Drawings:
_Mor:menu("draws", "Drawings Settings");
_Mor.draws:header('combo', 'Drawings Header');
_Mor.draws:boolean("drawq", "Drawing Q", false);
_Mor.draws:boolean("drawe", "Drawing E", true);
_Mor.draws:boolean("drawr", "Drawing R", false);

local MordekaiserAttackRange = function(unit)
    local unit = unit or player
    local attackRange = unit.attackRange
    local boundingRadius = unit.boundingRadius
    return attackRange + boundingRadius
end

local Notminions = {
    ["CampRespawn"] = true,
    ["PlantMasterMinion"] = true,
    ["PlantHealth"] = true,
    ["PlantSatchel"] = true,
    ["PlantVision"] = true
}
---Target
local function TargetIsSelector(res, object, Distancia)
    if object and not object.isDead and object.isVisible and object.isTargetable and not object.buff[17] then
        if Distancia > _Mor.tarhet.targetdis:get() then return end
        res.object = object
        return true; 
    end 
end
--TargetSelect
local function TargetSelection()
	return TS.get_result(TargetIsSelector, TS.filter_set[1], false, true).object;
end

--IsUnderTurrent
local function IsUnderTurretEnemy(pos)
    if not pos then return end
    for i = 0, objManager.turrets.size[TEAM_ENEMY] - 1 do
        local tower = objManager.turrets[TEAM_ENEMY][i]
        if  tower and not tower.isDead and tower.health > 0 then
            local turretPos = vec3(tower.x, tower.y, tower.z)
			if turretPos:dist(pos) < 900 then
				return true
            end
        else 
            tower = nil
		end
	end
    return false
end

local function CountEnemyChampAroundObject(pos, range) 
	local enemies_in_range = {}
	for i = 0, objManager.enemies_n - 1 do
		local enemy = objManager.enemies[i]
		if pos:dist(enemy.pos) < range and enemy and not enemy.isDead and enemy.isVisible and enemy.isTargetable and enemy.buff[17] then
			enemies_in_range[#enemies_in_range + 1] = enemy
		end
	end
	return enemies_in_range;
end
--
local function CountAllyChampAroundObject(pos, range) 
	local Allyend = {}
	for i = 0, objManager.allies_n - 1 do
		local aled = objManager.allies[i]
		if pos:dist(aled.pos) < range and enemy and not enemy.isDead and enemy.isVisible and enemy.isTargetable and not enemy.buff[17] then
			Allyend[#Allyend + 1] = aled
		end
	end
	return Allyend;
end

cb.add(cb.spell, function(spell)
    object = player;
    if object and object.isDead and object.isVisible and object.isTargetable and object.buff[17] then return end 
    if orbwalking.combat.is_active() then
        for i = 0, objManager.enemies_n - 1 do
            local enemy = objManager.enemies[i]
            for i = 1, #ForSpells do
                if enemy.charName == ForSpells[i].Name then
                    if _Mor.Misc.Inter:get() and _Mor.Misc[enemy.charName]:get() then
                        if spell.owner.type == TYPE_HERO and spell.owner.team == TEAM_ENEMY then
                            if player.pos2D:dist(spell.owner.pos2D) < 700 and spell.owner and not spell.owner.isDead and spell.owner.isVisible and player:spellSlot(2).state == 0 then
							    player:castSpell("obj", 2, spell.owner)
						    end
                        end
                    end
                end
            end
        end
    end
    if spell.owner.type == TYPE_HERO and spell.owner.team == TEAM_ENEMY then
        if spell.name:lower():find("attack") then
            if spell and (spell.target and spell.target == player) then
                AutoAttackTrue = true;
            end 
        end 
    end
end)

local function Redution(target)
    local magicResist = (target.spellBlock * player.percentMagicPenetration) - player.flatMagicPenetration
    return magicResist >= 0 and (100 / (100 + magicResist)) or (2 - (100 / (100 - magicResist)))
end

local function GetSpellDamage(target)
    local rbasedamage = (({ 235, 280.5, 670 })[player:spellSlot(3).level] + (player.baseAttackDamage + player.flatPhysicalDamageMod) * (player.percentPhysicalDamageMod - player.baseAttackDamage*3.3 + player.flatMagicDamageMod * player.percentMagicDamageMod*2.8))
    if target then
        return rbasedamage * Redution(target)
    end
end

local function Harass(IsTarget)
    if (IsTarget) then
        if IsTarget == nil and IsTarget.isDead and IsTarget.buff[17] and IsTarget.isDash then return end 
        if (player:spellSlot(0).state == 0) and (_useq) then
            local res = prediction.linear.get_prediction(pred_input_Q, IsTarget);
            if res and res.startPos:dist(res.endPos) < 510 and not prediction.collision.get_prediction(pred_input_Q, res, IsTarget)  then
                player:castSpell("pos", 0, vec3(res.endPos.x, mousePos.y, res.endPos.y));
                return;
            end
        end
        if (player:spellSlot(1).state == 0 and not player.buff["mordekaiserw"]) and (_usew) then
            if AutoAttackTrue == true then
                player:castSpell("self", 1);
                return;
            end
        elseif player.buff["mordekaiserw"] and os.clock() - TimeWStart > 0.25 and ((player.health / player.maxHealth) * 100 < (IsTarget.health / IsTarget.maxHealth)* 100) then
            player:castSpell("self", 1);
            return;
        end
        if (_usemode == 1) then
            if player:spellSlot(2).state ~= 0 then return end 
            local res = prediction.linear.get_prediction(pred_input_E, IsTarget);
            if res and res.startPos:dist(res.endPos) < 700 and not prediction.collision.get_prediction(pred_input_E, res, IsTarget)  then
                player:castSpell("pos", 2, vec3(res.endPos.x, mousePos.y, res.endPos.y));
                return;
            end
        end

        if player:spellSlot(2).state == 0 and player.buff["mordekaiserpassive_fullstacks"] then 
            local res = prediction.linear.get_prediction(pred_input_E, IsTarget);
            if res and res.startPos:dist(res.endPos) < 700 and not prediction.collision.get_prediction(pred_input_E, res, IsTarget) then
                player:castSpell("pos", 2, vec3(res.endPos.x, mousePos.y, res.endPos.y));
                return;
            end 
        end 
    end
    -- body
end

orbwalking.combat.register_f_pre_tick(function()
    --Buffe name: MordekaiserW
    --mordekaiserpassive_fullstacks
    object = player;
    if object and object.isDead and not object.isVisible and not object.isTargetable and object.buff[17] then return end 
    local IsTarget = TargetSelection();
    if _Mor.tarhet.UseStwich:get()  and (IsTarget) then
        if IsTarget == nil and not IsUnderTurretEnemy(IsTarget.pos) and #CountAllyChampAroundObject(IsTarget.pos, 1000) < 0 then return; end
        IsUnderStatus = true;
    else 
        IsUnderStatus = false;
    end
    if player then
        if player.buff["mordekaiserw"] then
            TimeWStart = os.clock();
        end 
    end
    if not (orbwalking.combat.is_active()) then return; end 

    _useq = _Mor.Combo.usq:get();
    _usew = _Mor.Combo.usw:get();
    _usee = _Mor.Combo.use:get();
    _user = _Mor.Combo.usr:get();
    _usemode = _Mor.Combo.emoder:get();
    _usemoder = _Mor.Combo.rmoder:get();
    if (IsTarget) then
        if IsTarget == nil and IsTarget.isDead and IsTarget.buff[17] and IsTarget.isDash then return end 
        if (player:spellSlot(0).state == 0) and (_useq) then
            local res = prediction.linear.get_prediction(pred_input_Q, IsTarget);
            if res and res.startPos:dist(res.endPos) < 510 and not prediction.collision.get_prediction(pred_input_Q, res, IsTarget)  then
                player:castSpell("pos", 0, vec3(res.endPos.x, mousePos.y, res.endPos.y));
                return;
            end
        end
        if (player:spellSlot(1).state == 0 and not player.buff["mordekaiserw"]) and (_usew) then
            if AutoAttackTrue == true then
                player:castSpell("self", 1);
                return;
            end
        elseif player.buff["mordekaiserw"] and os.clock() - TimeWStart > 0.65 then
            player:castSpell("self", 1);
            return;
        end
        if (_usemode == 1) then
            if player:spellSlot(2).state ~= 0 then return end 
            local res = prediction.linear.get_prediction(pred_input_E, IsTarget);
            if res and res.startPos:dist(res.endPos) < 700 and not prediction.collision.get_prediction(pred_input_E, res, IsTarget)  then
                player:castSpell("pos", 2, vec3(res.endPos.x, mousePos.y, res.endPos.y));
                return;
            end
        elseif (_usemode == 2) then
            if player:spellSlot(2).state ~= 0 then return end 
            local res = prediction.linear.get_prediction(pred_input_E, IsTarget);
            if res and res.startPos:dist(res.endPos) < 700 and not prediction.collision.get_prediction(pred_input_E, res, IsTarget) and IsTarget.pos:dist(player.pos) > MordekaiserAttackRange()  then
                player:castSpell("pos", 2, vec3(res.endPos.x, mousePos.y, res.endPos.y));
                return;
            end 
        elseif (_usemode == 3) then
            if player:spellSlot(2).state ~= 0 then return end 
            if player:spellSlot(0).state ~= 0 then return end 
            local res = prediction.linear.get_prediction(pred_input_E, IsTarget);
            if res and res.startPos:dist(res.endPos) < 700 and not prediction.collision.get_prediction(pred_input_E, res, IsTarget) then
                player:castSpell("pos", 2, vec3(res.endPos.x, mousePos.y, res.endPos.y));
                return;
            end 
        end
        if player:spellSlot(2).state == 0 and player.buff["mordekaiserpassive_fullstacks"] then 
            local res = prediction.linear.get_prediction(pred_input_E, IsTarget);
            if res and res.startPos:dist(res.endPos) < 700 and not prediction.collision.get_prediction(pred_input_E, res, IsTarget) then
                player:castSpell("pos", 2, vec3(res.endPos.x, mousePos.y, res.endPos.y));
                return;
            end 
        end 
        if (_usemoder == 1) and (_user) then
            if player:spellSlot(3).state ~= 0 then return end 
            if GetSpellDamage(IsTarget) > IsTarget.health then return end 
            if IsTarget.pos:dist(player.pos) <= 650 then
                player:castSpell("obj", 3, IsTarget);
                return;
            end
        elseif (_usemoder == 2) and (_user) then
            if player:spellSlot(3).state ~= 0 then return end 
            if IsTarget.pos:dist(player.pos) <= 650 and IsTarget.health / IsTarget.maxHealth* 100 < 50 then
                player:castSpell("obj", 3, IsTarget);
                return;
            end
        end
    end
    --if IsUnderStatus == false then
        ---chat.print("attack hero");
    --end
end)


cb.add(cb.tick, function()
    if player.isDead then return end;
    local IsTarget = TargetSelection();
    if _Mor.Harass.keyharass:get() then
        Harass(IsTarget);
    end
    --Jungle
    if _Mor.lanejungle.keylanejungle:get() then
        for i = 0, objManager.minions.size[TEAM_NEUTRAL] - 1 do
            local monster = objManager.minions[TEAM_NEUTRAL][i]
            if monster and not monster.isDead and monster.isVisible and monster.health > 0 and not monster.name:find("Ward") and not Notminions[monster.name] then
                if (player:spellSlot(0).state == 0) and _Mor.lanejungle.usq:get() and monster.pos:dist(player.pos) <= 500 then
                    player:castSpell("pos", 0, monster.pos);
                    return;
                end
                if (player:spellSlot(0).state == 0) and _Mor.lanejungle.use:get() and monster.pos:dist(player.pos) <= 700 then
                    player:castSpell("pos", 2, monster.pos);
                    return;
                end
            end
        end
        --Lane
        for i = 0, objManager.minions.size[TEAM_ENEMY] - 1 do
            local MOBS = objManager.minions[TEAM_ENEMY][i]
            if MOBS and not MOBS.isDead and MOBS.isVisible and MOBS.health > 0 and not MOBS.name:find("Ward") and not Notminions[MOBS.name] then
                if (player:spellSlot(0).state == 0) and _Mor.lanejungle.usq:get() and MOBS.pos:dist(player.pos) <= 500 then
                    player:castSpell("pos", 0, MOBS.pos);
                    return;
                end
            end
        end
    end
end)
cb.add(cb.draw, function()
    object = player;
    drawinq = _Mor.draws.drawq:get();
    drawine = _Mor.draws.drawe:get();
    drawinr =_Mor.draws.drawr:get();
    if (object and not object.isDead and object.isVisible and object.isTargetable) then
        if (player.isOnScreen) then
            if player:spellSlot(0).state == 0 and drawinq then
                graphics.draw_circle(player.pos, 500, 2, graphics.argb(255, 92, 191, 158), 100)
            end 
            if player:spellSlot(2).state == 0 and drawine then
                graphics.draw_circle(player.pos, 700, 2, graphics.argb(255, 92, 191, 158), 100)
            end 
            if player:spellSlot(3).state == 0 and drawinr then
                graphics.draw_circle(player.pos, 650, 2, graphics.argb(255, 92, 191, 158), 100)
            end 
        end
    end
end)