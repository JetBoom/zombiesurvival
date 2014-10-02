 ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
ZZZ                                  ZZZ
ZZZ          ZOMBIE SURVIVAL         ZZZ
ZZZ THE DEFINITIVE ZOMBIE EXPERIENCE ZZZ
ZZZ        A GAMEMODE FOR GMOD       ZZZ
ZZZ                                  ZZZ
 ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ

Created and programmed by        William "JetBoom" Moodhe
E-mail:                          williammoodhe@gmail.com
Alternate e-mail:                jetboom@noxiousnet.com
Web:                             http://www.noxiousnet.com

Additional credits:
Zombie view models               11k (tjd113@gmail.com)
Zombie kill icons                Eisiger (k2deseve@gmail.com)
Some HUD textures                Typhon (lukas-tinel@hotmail.com)
Ambient beat sounds              Austin "Little Nemo" Killey (austin_odyssey@yahoo.com)
Melee weapon models              Zombie Panic: Source (http://www.zombiepanic.org/)
Board Kit model                  Samuel (samuel_games@hotmail.com)


 ZZZZZZZZZZZZZZZZZZZZZZZZZ
ZZ                       ZZ
ZZ        INSTALL        ZZ
ZZ                       ZZ
 ZZZZZZZZZZZZZZZZZZZZZZZZZ

1. Put the zombiesurvival folder in garrysmod/gamemodes with all the other gamemode folders.
2. In console: gamemode zombiesurvival
3. Run a zs_ map.


 ZZZZZZZZZZZZZZZZZZZZZZZZZ
ZZ                       ZZ
ZZ    RUNNING SERVERS    ZZ
ZZ                       ZZ
 ZZZZZZZZZZZZZZZZZZZZZZZZZ

1. Get srcds and configure it for garrysmod (requires steamcmd).
2. Put the zombiesurvival folder in garrysmod/gamemodes with all the other gamemode folders.
3. Get some maps. ZS_ maps are plentiful on the Internet and the game also supports many other map types: CS:S, Zombie Mod, Zombie Horde, Zombie Panic! Source
4. Either setup a custom voting script or use mapcycle_zombiesurvival.txt. Make a file called mapcycle_zombiesurvival.txt in base garrysmod folder. Put in names of maps without the .bsp ending. One per line.
5. Make your auto-start batch file or whatever you use. The line should look like this:
srcds.exe -port 27015 -console -game garrysmod -secure +ip 24.102.103.104 +hostport 27015 +gamemode zombiesurvival +maxplayers 32 +map zs_oldhouse +hostname "Your ZS Server"
6. Run it. You now have a server. See other guides on the web for setting up sv_downloadurl.


 ZZZZZZZZZZZZZZZZZZZZZZZZ
ZZ                       ZZ
ZZ      LEGAL JARGON     ZZ
ZZ                       ZZ
 ZZZZZZZZZZZZZZZZZZZZZZZZZ

See license file