# Zombie Survival Redemption

This is an experimental modification of the original Zombie Survival gamemode for Garry's Mod by JetBoom!

## About

Over the years I kept on getting countless requests to rebuild and bring
back to what was known as the "Bandit System".
The bandit system is where upon redeeming the client is greeted
with the option which they can choose to stay as
a bandit (which can help or kill humans) or change back into a human.

## Current Features

### Version 6 - Sigil System:

- Basic Redeem System.
- Complete Russian & German Language Translation.
- Spectator system with the option in the F1 menu.
- Altered how dropped deployable items work.
- Worth & in-game pointshop are now bigger.
- Re-balance weapon and item pricing.
- HD Texture icons.
- Healthbars on Resupply & Arsenal Crates.
- Humans and Bandits can use third person.
- Zombie Class Menu now has the Boss Button centered and is much bigger.
- Fixed when another server alters the waves logic.
- Built-in Spray Detector.
- Discount Prices are shown during wave intermissions.
- Fixed an point exploit with skycade props.
- Improved Zombie Class Unlock Infliction Percentage.
- Melee weapons no longer "water splash".
- Fixed prop holding position with doors.
- Improved Healthbar FPS.
- Disabled MouthMoveAnimation.
- Bandits Flash on the Scoreboard.
- New Beats.
- Create Sigils when it's not an objective map.
- Zombie gas now give non-boss zombies health.
- Added Last Human Weapons.
- Zombie Escape Fixes & Zombie Escape Beta Healthbars.
- Added Hidden PvP Zombie Class.
- Added Second Credits Tab.
- Improved Class Select menu.
- More & Updated Translations.
- Added New Bosses.

## Credits

Created and programmed by William "JetBoom" Moodhe!

### Contact:
- E-mail | williammoodhe@gmail.com
- Alternate e-mail | jetboom@noxiousnet.com
- Web | http://www.noxiousnet.com

### Additional credits:

- Zombie view models:
  - 11k | tjd113@gmail.com
- Zombie kill icons:
  - Eisiger | k2deseve@gmail.com
- Some HUD textures:
  - Typhon | lukas-tinel@hotmail.com
- Ambient beat sounds:
  - Austin "Little Nemo" Killey | austin_odyssey@yahoo.com
- Melee weapon models:
  - Zombie Panic: Source | http://www.zombiepanic.org/
- Board Kit model:
  - Samuel | samuel_games@hotmail.com

## Installing Zombie Survival

1. Put the zombiesurvival folder in garrysmod/gamemodes with all the other gamemode folders.
2. Select the Zombie Survival gamemode from the Gamemode button located on the bottom right of the main menu.
3. Select any map and play!


## Running Zombie Survival on a server

1. Get srcds and configure it for garrysmod (requires steamcmd).
2. Put the zombiesurvival folder in garrysmod/gamemodes with all the other gamemode folders.
3. Get some maps! Zombie Survival maps are plentiful on the Internet and the game also supports many other map types: Counter Strike: Source, Zombie Mod, Zombie Horde, Zombie Panic! Source.
4. Either setup a custom voting script or use mapcycle_zombiesurvival.txt. Make a file called mapcycle_zombiesurvival.txt in base garrysmod folder! Put in names of maps without the .bsp ending. One per line!
5. Make your auto-start batch file or whatever you use. The line should look like this.
```
srcds.exe -port 27015 -console -game garrysmod -secure +ip 24.102.103.104 +hostport 27015 +gamemode zombiesurvival +maxplayers 32 +map zs_oldhouse +hostname "Your ZS Server"
```
6. Run it! You now have a server! See other guides on the web for setting up sv_downloadurl!

## License

See the license file!
