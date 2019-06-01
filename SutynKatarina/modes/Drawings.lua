local Draw = { }
local p = module.load("sutynkatarina", "spell/Passive");
local q = module.load("sutynkatarina", "spell/q");
local w = module.load("sutynkatarina", "spell/w");
local e = module.load("sutynkatarina", "spell/e");
local r = module.load("sutynkatarina", "spell/r");
local menu = module.load("sutynkatarina", "menu");


Draw.Draw_Q = function()
    if (menu.Draw.drawq:get()) then
        if (q.isready()) then
            graphics.draw_circle(player.pos, q.range, 2, graphics.argb(255, 0, 255, 0), 100)
        else 
            graphics.draw_circle(player.pos, q.range, 2, graphics.argb(255, 255, 0, 0), 100)
        end
    end
end

Draw.Draw_W = function()
    if (menu.Draw.draww:get())  then
        if (w.isready()) then
            graphics.draw_circle(player.pos, w.range, 2, graphics.argb(255, 0, 255, 0), 100)
        else 
            graphics.draw_circle(player.pos, w.range, 2, graphics.argb(255, 255, 0, 0), 100)
        end
    end 
end

Draw.Draw_E = function()
    if (menu.Draw.drawe:get())  then
        if (e.isready()) then
            graphics.draw_circle(player.pos, e.range, 2, graphics.argb(255, 0, 255, 0), 100)
        else 
            graphics.draw_circle(player.pos, e.range, 2, graphics.argb(255, 255, 0, 0), 100)
        end
    end 
end

Draw.Draw_R = function()
    if (menu.Draw.drawr:get())  then
        if (r.isready()) then
            graphics.draw_circle(player.pos, r.range, 2, graphics.argb(255, 0, 255, 0), 100)
        else 
            graphics.draw_circle(player.pos, r.range, 2, graphics.argb(255, 255, 0, 0), 100)
        end
    end
end

Draw.Draw_Human = function()
--
end

return Draw