if player.charName == "Mordekaiser" then
    module.load("moding", "Champion");
    chat.print("Welcome To Hanbot, " .. player.charName);
else 
    chat.print("Unsupported champion!");
end