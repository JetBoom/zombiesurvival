-- See zs_main.lua for translator rules.
translate.AddLanguage("en", "English")

-- The help file... Quite big! I wouldn't blame you if you didn't translate this part.
LANGUAGE.help_cat_introduction						= "Introduction"
LANGUAGE.help_cat_survival							= "Survival"
LANGUAGE.help_cat_barricading						= "Barricading"
LANGUAGE.help_cat_upgrades							= "Upgrades"
LANGUAGE.help_cat_being_a_zombie					= "Being a Zombie"
LANGUAGE.help_cont_introduction						= [[<p>    Welcome to Zombie Survival, the (zombie) survival simulator. ZS allows you to fight zombie attacks, create barricades, and even be part of the undead horde.</p>

<p>There are two teams: the survivors and the zombies. The humans win if they survive every wave. Some levels have special objectives to be completed, which may be optional or required to win.
If a human is killed then they'll come back as a zombie, which makes it even more difficult for the remaining humans.</p>

<p>The goal for the zombies is to kill all of the humans, making them all zombies and causing everyone to lose the round.
Alternatively, a zombie can kill four humans to be redeemed. This allows them a second chance at survival and victory.
Remember, the only way to win a round is to be a human when the round ends. Zombies can't technically win the game; zombies can only make everyone else lose!</p>

<p>A certain amount of people are chosen (or volunteer) for being the starting zombies. This amount is displayed at the bottom of your screen before the round starts.</p>

<p><b>Use the buttons up top to get help on more specific things.</b></p>

<p>Tips for this section:
<ul><li>If you leave the game as a human then you'll rejoin as a zombie.</li>
<li>After a certain amount of time has gone by, even new players will spawn as zombies.</li>
<li>Use TEAM CHAT when needed. The default key is U and allows you to speak to only your team.</li>
</ul></p>
]]
LANGUAGE.help_cont_survival							= [[<p>Tips for this section:
<ul><li>Holding the ZOOM key (default: Z) allows you to move freely through barricades while walking extremely slow.</li>
<li>You can only buy more items such as weapons and ammo during wave breaks but you can also loot ammunition, weapons, and tools from fallen comrades.</li>
<li>If a human is directly killed by a zombie then they will rise again wherever they stand. Make sure you end their misery before they give you any.</li>
<li>You're only given a certain amount of Worth to play with so think carefully what you should get!</li>
<li>You can create, save, load, delete, and mark as default carts by pressing F2. This saves a ton of time which could be better spent setting up barricades or creating game plans.</li>
<li>A spot that feels safe one moment may be a death trap with more or different types of zombies roaming around. Always allow extra space and a "Plan B" if things get ugly.</li>
<li>You're useless to your team if you're not doing anything to help. You're even more useless to yourself since you're not getting any points or bigger weapons!</li>
<li>By holding your SPRINT key for about ten seconds while looking at deployed objects that you own, you can pack them up for later use.</li>
<li>Turrets without owners (a blue light) can be claimed by pressing USE on them. Ownerless turrets will not scan for targets!</li>
<li>Props that aren't nailed to something don't make very good barricades unless they're really heavy.</li>
<li>With enough punishment, doors can be thrown off their hinges.</li>
<li>Most props will become red with more and more damage.</li>
<li>Zombies can spawn on top of each other if no humans are around to witness it.</li>
<li>Most melee weapons have a longer reach than zombie claws. Use this to your advantage if you insist on defending with a melee weapon.</li>
<li>Players on the same team do not damage or collide with each other and can freely shoot and swing through each other.</li>
<li>Make sure you use a barricade to your advantage and stay behind it a good distance away from the zombies. Guns have an infinite range, zombie claws do not.</li>
<li>Poison damage will heal over time but enough of it can still kill you.</li>
<li>Your team members aren't always right, don't be a sheep! Zombies like to kill sheep.</li>
<li>Zombies can see your health, even through walls. Make sure to fall back when hurt as zombies will most likely try to pick you off.</li>
<li>Don't hide, zombies can sense you through walls and in complete darkness.</li>
<li>The Horde Meter at the bottom of the screen indicates how much of a damage and knockback resistance you have. Huddle up with other zombies for a big resistance when taking down strongholds!</li>
<li>If you don't have enough zombies to take down a barricade, try hunting for new "team mates" elsewhere.</li>
<li>Don't shoot zombies in the green gas! It quickly heals them and you're only wasting ammunition!</li>
<li>Zombies are resistant to damage in the chest and even more so in the arms and legs. Make sure you're aiming for the head as some zombies have the ability to get up again if you don't!</li>
<li>Although zombies take less damage in the legs, shooting them there will slow them down for a short time, enough to allow you or a team member to escape.</li>
</ul></p>
]]
LANGUAGE.help_cont_barricading						= [[<p>Barricading is an extremely important part of survival. It may seem like the undead aren't a threat early on but eventually they'll be powerful enough to kill your entire team in a few seconds.</p>

<p>The only thing keeping the zombies out is a well-built and well-maintained barricade.</p>

<p>There are a couple of tools that give you the ability to set this up. The one most useful tool is the hammer and nails. This allows you to nail down props which then must have the nails destroyed in order for the zombies to get to you.
Position the prop you want to nail by pressing USE on it to pick it up. You can hold SPRINT while holding it to lock it in place. Then take your hammer and right click where you want the nail to go. It's a good idea to nail the prop to a sturdy object such as a wall instead of other props.
Remember, when a prop is nailed it will forward the damage it takes to the nails themselves. You can repair nails by hitting them with the hammer but eventually they'll become too damaged to repair anymore. You can hold SHIFT with the hammer out to get a view of every single nail deployed on your screen as well as the owner.
If you think a nail is in a bad place or you'd like to reposition a prop, you can remove nails by pointing at it and pressing RELOAD. Be warned, if you take a nail that doesn't belong to you then you will be given a point penalty.
One more thing to remember: nails take less damage when they're nailed to bigger props. The bigger the size of the prop, the less damage its nails take and the other way around.</p>

<p>One other tool is the 'Aegis' Barricade Kit. This quick-deploying tool allows you to place boards on any surface or deploy them between two walls. It doesn't even need props. To use it, you need to position a board in a spot that is legal. The ghost will turn from red to green to let you know.
Deploy a board by pressing PRIMARY ATTACK. Rotate the board by using SECONDARY ATTACK and RELOAD. It uses boards for ammunition so boards you have from the Board Pack work as extra ammunition! You can pack up boards you've deployed by pressing SPRINT while pointing at it.</p>

<p>Another tool worth noting is the Turret. This tosses bullets at any zombie that gets in the way of its laser. Its only downside is that it requires ammunition. You can refill ammunition by pressing USE on it. This will give you bonus points for helping the team.
To deploy the turret, position it in a way so that the ghost is green. It must be on a solid surface (no props!). Rotate the turret with SECONDARY ATTACK and RELOAD. If you mess up, you can always pack the turret back up by pressing SPRINT while pointing at it. Remember, the turret will only fire at zombies that cross its tracking beam.</p>

<p>Tips for this section:
<ul>
<li>You get a 25% point bonus for killing zombies that are attacking a barricade!</li>
<li>Use bigger props for barricades. The nails take less damage and the prop has room for more nails. In addition to that, it even acts as cover from projectiles.</li>
</ul></p>]]
LANGUAGE.help_cont_upgrades							= [[<p>Points are obtained through killing zombies, healing team mates, and building defenses.
You can then exchange points in the Points Shop at Arsenal Crates.</p>

<p>Tips for this section:
<ul>
<li>Try planning ahead. Buy extra pistol ammunition in the Worth menu so you have plenty to spare once you get your first upgrade.</li>
<li>You still get points for assists. The greater half of the points goes to the killer and the lesser half goes to the one who assisted in the kill.</li>
<li>Worth and Points are separate. Make sure you spend all of your Worth!</li>
<li>Arsenal Crates are extremely valuable and prime targets for zombie attacks.</li>
</ul></p>]]
LANGUAGE.help_cont_being_a_zombie					= [[<p>Tips for this section:
<ul>
<li>You have an unlimited amount of lives, the humans only have one each. Don't be afraid to attack, attack, attack!</li>
<li>The regular Zombie class has the ability of durability. The only way to kill you for sure is to get shot in the head or be killed by a melee weapon. You don't need your legs.</li>
<li>Zombies can spawn on top of each other if no humans are around to see it. Check the eyes of the skull on the bottom of your screen. If they're green then you are a valid spawn point!</li>
<li>With enough practice, you can use props to slam them in to humans from a distance.</li>
<li>Destroy deployables such as turrets and especially Arsenal Crates to cripple the humans.</li>
<li>With enough punishment, doors can be thrown off their hinges.</li>
<li>Most props will become red with more and more damage.</li>
<li>The Wraith is completely invisible while standing still or at a distance.</li>
<li>The Fast Zombie's lunge attack damage scales by how long you're in the air. The more air time you get, the larger the damage. Use your claw attack when in close range!</li>
<li>In addition to being extremely tough, the Poison Zombie can rip out chunks of its own poison flesh and throw them at humans by pressing SECONDARY ATTACK.</li>
<li>Most zombie claws have two chances to hit their target. If you "hit" your target when you click your mouse button then you're guaranteed a hit as long as they remain in range.</li>
<li>The Poison Headcrab's spit projectile can confuse humans if it hits them in the head.</li>
<li>Go for the humans with low health! Other zombies are also attracted to them so they should be the easiest targets.</li>
<li>The Horde Meter at the bottom of the screen indicates how much of a damage and knockback resistance you have. Huddle up with other zombies for a big resistance when taking down strongholds!</li>
<li>If you don't have enough zombies to take down a barricade, try hunting for new "team mates" elsewhere.</li>
<li>If an area is too dark, try pressing your FLASHLIGHT button to toggle night vision.</li>
</ul></p>
]]