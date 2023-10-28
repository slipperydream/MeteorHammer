Started as a classic space invaders clone from the tutorial  at https://kidscancode.org/godot_recipes/4.x/games/first_2d/
Heavily modified now

TODOs (not in priority order yet)
-----
- Start building 30 to 60 second long stages
    - add song changes with the stage changes
    - update spawner to specify location
- make pickup system
- make different items and weapons as pickups
  - slashing effect, super cannon shot, screen wide weak bullets, meteor hammer (meteor crashing down in front of player)

- Start adding flags to different functionality that I eventually want to be able to turn off/change

- Add settings menu

- Add game over screen

- Add high score saving

- Remove shield and make it an item. 
  - Add animation for shield being hit 
 
- Add checkpoints / restart

- Code bullet cancelling - dead enemies bullet disappear or fly to the player and become scoring items. Need to investigate who owns the bullets
- After death cancel enemy shots for a few seconds, but leave existing bullets on screen. Give player a few seconds of invincibility, remove pause & repositioning

- Add attract mode

- Add more shot patterns to each enemy for difficulty increase
- Adjustable difficulty by widening shot patterns, increasing number of waves, bullet speed, spread, damage

- make modes: story, attack (remove cutscenes), level select, boss select

- add scoring triggers to generate items/powerups/1ups

- add focused shot for player with holding down the button

- look into sound pools for sound effects
- look into object pools for spawning enemies and bullets

- Possibly replace player weaposn with firing modes that can be unlocked throughout play

 - Make a stage struct that defines the number, name, and other things

- update player weapon to better looking sprite

- separte attack mode out to run through stages on after another.

- add Path2D for enemy movement

- display currently playing song title on a side panel

- create different player ships
 - speed + shot width differences seem to be standard
 - fast + narrow
 - average + 45 degree shot
 - slow + 60-90 degree shot?

 - ship customization
    - bombs: more bombs but fewer shots from primary weapon shots (4 & 2)
    - power: no bombs, but 6 shots?
    - balance: 3 bombs and 3 shots?
    - chaining_easier: more time between kills, but grows slower
    - chaining_higher: less time between kills, but grows faster

 Alternate Weapons
  - shield
  - homing missiles
  - laser
  - katana
 
 Items
 - Bombs

Redo code to make components instead of inheritance.
- Attack
- Health
- Hitbox
- Movement?


Add pickups to level spawner

Power ups:
- Shot power increase by 10% not 100%
- Increase width
- Increase speed
- Add effects
- Increase sounda

Items: bombs, mines, power ups, shields, lives

Enemies: bosses, sprites, animations, aimed shots. Fix double & triple stack to offer lanes wide enough to move into. Increase explosion size to larger than enemy. Have multiple deaths. Have hit indicators visual & audio

Enemy types:
[X] scout ship (long range shot, fast, low Hp)
[X] Fighter (fast, close range, slashing attack)
[X] Dreadnought (slow, multi-shot, high hp)
[] Orbital platform (stationary, aimed shot)
[] Torpedo ship (med speed, ripple shot, mid hp)
[] Carrier (slow, spawns fighters, cannon shot)
[] Space fence - constant barrier horizontally across screen
[X] Space tank
[X] Homing droids - chase after the player

Bosses:
1. Ivory Dragon
2. Sable Hawk
3. The Damned Pearl - opens it clamshell firing a spread shot, but reveals a white orb that can be damaged
4. Giant Orbital Platform: fires slew of small bullets then rotates to fire giant beam cannon
5. Quasar - rotates and fires cannons out both ends
6. Super Quasar - fires out in X-pattern
7. Mecha - alternating whip attacks and also a chest barrage of missiles
8. Shield Bearer & Reaper - shield bearer projects shield in front of them & the reaper. Drops shield when Reaper launches slashing shot
9. Big Girl - former colleague
10. Mega Space fence: series of smaller fences that open and close to release small waves of foes.
11. Space Carrier Argus: launches a bunch of small mobs to attack you
12. Citrine Dream: does sweeping electric attacks (like Crono’s attack). Alternates direction


Add enemy ai/pathing
