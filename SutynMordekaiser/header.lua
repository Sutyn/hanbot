local ChampionName = player.charName == "Mordekaiser";
return { id = "moding", name = "SutynMordekaiser", riot = true, type = "Champion",
  load = function()
    return ChampionName
  end
}