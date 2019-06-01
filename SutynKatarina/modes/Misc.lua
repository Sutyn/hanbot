local misc = { }

misc.IsUnderTurretEnemy = function(pos)
    if not pos then return false; end
    for i = 0, objManager.turrets.size[TEAM_ENEMY] - 1 do
        local tower = objManager.turrets[TEAM_ENEMY][i]
        if  tower and not tower.isDead and tower.health > 0 then
            local turretPos = vec3(tower.x, tower.y, tower.z)
			if turretPos:dist(pos) < 900 then
				return true;
            end
        else 
            tower = nil;
		end
	end
    return false;
end

return misc