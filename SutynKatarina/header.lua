local ChampionName = player.charName == "Katarina";
return { id = "sutynkatarina", name = "SutynKatarina", riot = true, type = "Champion",
  load = function()
    return ChampionName
  end
}