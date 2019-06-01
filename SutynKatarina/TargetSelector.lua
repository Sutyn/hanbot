local ts = module.internal("TS");

local selec = { }

selec.ThanksAPI = function(res, object, Distancia)
    if object and not object.isDead and object.isVisible and object.isTargetable and not object.buff[17] then
        if Distancia > 1200 then return end
        res.object = object
        return true 
    end 
end
--TargetSelect
selec.TargetSelection = function()
	return ts.get_result(selec.ThanksAPI, ts.filter_set[1], false, true).object
end

return selec 