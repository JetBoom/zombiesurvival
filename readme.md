<p align="center">
  <img alt="Steam Subscriptions" src="https://img.shields.io/steam/subscriptions/105462463?style=for-the-badge&logo=steam&label=Steam%20subscriptions&color=black">
  <img alt="Steam Favorites" src="https://img.shields.io/steam/favorites/105462463?style=for-the-badge&logo=steam&label=Steam%20favorites&color=black">
  <img alt="Steam Update Date" src="https://img.shields.io/steam/update-date/105462463?style=for-the-badge&logo=steam&label=Steam%20last%20update&color=black">
</p>

# Zombie Survival
A gamemode for Garry's Mod where some players start as survivors and some as zombies.
The zombies try to kill all the survivors and turn them in to zombies.
That's the short version at least.

# Installation

1. Just put the zombiesurvival folder in garrysmod/gamemodes with all the other gamemode folders.
2. Zombie Survival should appear as a selectable gamemode on the main menu.

# Dedicated Servers

1. Refer to the Valve wiki on how to setup steamcmd and srcds [here](https://developer.valvesoftware.com/wiki/SteamCMD).
2. Get some maps. ZS_ maps are plentiful on the [Steam workshop](https://steamcommunity.com/workshop/browse/?appid=4000&searchtext=zs_) and the game also supports many other map types: CS_, DE_, ZM_, ZE_, ZH_, ZPS_, and more.
3. Either setup a custom voting script or use mapcycle_zombiesurvival.txt. Make a file called mapcycle_zombiesurvival.txt in base garrysmod folder. Put in names of maps without the .bsp ending. One per line.
4. `srcds.exe -port 27015 -console -game garrysmod -secure +ip 24.102.103.104 +hostport 27015 +gamemode zombiesurvival +maxplayers 32 +map zs_oldhouse +hostname "Your ZS Server"`
5. Run it. You now have a server. See other guides on the web for setting up sv_downloadurl. You may also wish to install your server as service or have an auto-start script.

# Contributors

* William "JetBoom" Moodhe <williammoodhe@gmail.com> - Creator and programmer
* 11k <tjd113@gmail.com> - Zombie view models
* Eisiger <k2deseve@gmail.com> - Zombie kill icons
* Typhon <lukas-tinel@hotmail.com> - HUD textures
* Austin "Little Nemo" Killey <austin_odyssey@yahoo.com> - Soundtrack
* Samuel <samuel_games@hotmail.com> - Board Kit model

# Additional Credits
* [Zombie Panic: Source](http://www.zombiepanic.org/) team for some melee weapon models.

# Legal
See the [LICENSE](https://github.com/JetBoom/zombiesurvival/blob/master/LICENSE) file.
