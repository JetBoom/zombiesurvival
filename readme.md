# Zombie Survival Redemption

This is an experimental modification of the original Zombie Survival gamemode for Garry's Mod by JetBoom.

## About

Over the years I kept on getting countless requests to rebuild and bring
back to what was known as the "Bandit System".
The bandit system is where upon redeeming the client is greeted
with the option which they can choose to stay as
a bandit (which can help or kill humans) or change back into a human.

## TODO

These need to be done before any other feature gets added in!

- [ ] Move a lot of the init code into separate files!
  - [ ] Wave Stuff!
  - [ ] Player Stuff!
  - [ ] Human Stuff!
  - [ ] Zombie Stuff!
  - [ ] Weapon Stuff!
  - [ ] Sigil Stuff!
  - [ ] Other Stuff!
- [ ] Move the random prop spawner for sigils to it's own file or just as an addon as it does not belong in that file!
- [ ] Move the progress bars such as the packup progress bar back into their status files!
- [ ] Update the sigils!
  - [ ] Replace the timer with CurTime!
  - [ ] Display a progress bar, also make sure the progress bar is located in status_sigilteleport instead of putting it in the human hud!
- [ ] Rescale some of the text to fit on certain screens such as the worth menu text and the intermission text!
  - [ ] Intermission Text!
  - [ ] Worth Menu Text!

## Current Features

### Version 6 - Sigil System:

- Basic Bandit Redeem System.
- Complete Russian, German & Spanish language translation.
- Spectator support with the option in the F1 menu.
- Altered how dropped deployable items work.
- Improved worth, in-game pointshop & zombie class menus.
- Balanced weapon & items.
- HD Texture icons.
- Healthbars on resupply & arsenal crates.
- Human & bandit third person.
- Fixed when another server alters the waves logic.
- Built-in spray detector.
- Discount prices in pointshop menu during wave intermissions.
- Fixed an point exploit with skycade props.
- Improved zombie class unlock infliction percentage.
- No Melee weapon "water splash".
- Fixed prop holding position with doors.
- Improved healthbar FPS.
- Disabled MouthMoveAnimation.
- Bandits flash on the scoreboard.
- New Beats.
- Zombie gas give non-boss zombies health.
- Last Human Weapon support.
- Zombie Escape fixes & boss entity healthbar support.
- Hidden PvP zombie class.
- Second credits tab in the F1 menu.
- New zombie bosses.
- Custom Sigil with mapper support.


## Zombie Survival Redemption Credits

- Project Leader:
  - MrCraigTunstall | https://steamcommunity.com/profiles/76561198059515155
- Programmer / Contributor:
  - Flairieve | https://steamcommunity.com/profiles/76561198055782802
- Assistant Programmer / German Translation:
  - Dadido3 | https://steamcommunity.com/profiles/76561198005024048
- Issue Tracker / Russian Translation:
  - Nyanpasu | https://steamcommunity.com/profiles/76561198158864042
- Spectate System:
  - ForrestMarkX | https://steamcommunity.com/profiles/76561197997881512
- Spanish Translation:
  - Sulfito | https://steamcommunity.com/profiles/76561198026081830

## Original Credits

Created and programmed by William "JetBoom" Moodhe.

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
4. Either setup a custom voting script or use mapcycle_zombiesurvival.txt. Make a file called mapcycle_zombiesurvival.txt in base garrysmod folder! Put in names of maps without the .bsp ending. One per line.
5. Make your auto-start batch file or whatever you use. The line should look like this:
```
srcds.exe -port 27015 -console -game garrysmod -secure +ip 185.38.148.139 +hostport 27015 +gamemode zombiesurvival +maxplayers 32 +map gm_construct +hostname "Your ZS Server"
```
6. Run it! You now have a server! See other guides on the web for setting up sv_downloadurl.

## License

See the license file.
