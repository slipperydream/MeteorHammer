Started as a classic space invaders clone from the tutorial  at https://kidscancode.org/godot_recipes/4.x/games/first_2d/
Heavily modified now

TODOs (rough priority order)
-----
- []ship customization
   - [] chaining_easier: more time between kills, but grows slower
   - [] chaining_higher: less time between kills, but grows faster

- [] Add option switch between normal (two) vs boost (four/ less damage per option)

- Special Weapons
  - [] shield
  - [x] homing missiles
  - [x] laser - made as a standard weapon
  - [x] katana
  - [x] mines
 
- Power ups
- [] Shot power increase by 10% not 100%
- [] Increase width
- [] Increase speed
- [] Add effects
- [] Increase sounda

- [] Add game over screen
- [\] Add settings menu
- [\] Add high score saving

- [x] add paths and prototyped moving an enemy with one. 
- [] Add pathing (Path2D) for enemy waves that aren’t just flying directly south 
- [] Add UI indication of incoming enemy path with Line2D?

- [] Make a stage struct that defines the number, name, and other things

- [] break up current waves into smaller waves. Save as wave scenes? 
    - Save as wave scenes and update spawner to take those?

- [] Move non-spawning functionality of spawner and make a level scene with spawner and other details
- [x] make pickup system (use area2d area entered calls to hoover up things)
- [] make pickup spawner
- 1ups: score or tasking based?

- [] Add game progress and statistics tracker
  - track stages cleared, bosses killed, deaths, continues, enemies killed, highest score
  - Possible Achievements: 
  - [] Beating each stage
  - [] Beating the game
  - [] Beating the game on 1CC (sign post this after beating the game)
  - [] Beating score attack
  - [] Multiplier above X
  - [] Bombs killed X enemies
  - [] Killed X enemies
  - [] Beat on each difficulty
  - [] Collect X medals
  - [] Novice mode kills X enemies
  - [] one each for clearing a level with a ship type

- []Start building 60 second long stage 1
  - goal is to have each stage be about 2 minutes and a 30-45 second boss fight
  - Keep main story stages to 5 to 7 
    - [x] add song changes with the stage changes
    - [X] update spawner to specify location
    - [] add complete boss scene 
      - [x] change music to boss theme

- [] make game modes: 
   - [x] stage select: galaxy map with brief overview of mission when selected
     - need to go to the stage select screen after stage results
   - [] boss select: just play the bosses you've seen before
   - [] attack mode: out to run through stages on after another.
     - need to go to the next stage after stage results
   - [] attract mode: self playing 

- Revisit scoring system. Think about the following:
 - item chaining 
 - Speed kill
 - Proximity based scoring
 - Hyper?
 - Bonus for lives not spent 
- [x] add triggers to generate items
  - []powerups/1ups
- [] Add corpse on screen for last death. Worth X points if "salvaged" i.e. picked up
- [] add ghost path of last route?

- [\] Replace credits with a continue meter that refills with score
- [] Add player shot limit. Forces closer attacks for higher damage
- [] Possibly add a collision shield? Doesn’t stop bullets
- [x] update player weapon to better looking sprite

- []Redo code to make components instead of inheritance.
    - Attack
    - Movement?

- [] Add soundtrack mode, i.e., just play the music in a loop with simple play controls
  - [] add song selection for stages and bosses?
- [] Add a thorn aura around player?
- [] On selection of stage allow user to turn off cutscenes 

- []Start adding flags to different functionality that I eventually want to be able to turn off/change

- [] Add difficulty levels
   - [] Add more shot patterns to each enemy for difficulty increase
   - [] Adjustable difficulty by widening shot patterns, increasing number of waves, bullet speed, spread, damage

- [] Add checkpoints 
  - [] Possibly make stage progress checkpoints that are selectable from the stage selection screen

- [] Possibly add secondary story lines and stages that are playable after progression in the main storyline. 
   - Would use different ship. Rebel, Imperial

- [] Investigate 2player mode & sidekick/assistant mode (I.e. can kill enemies, but not damageable)
  - Perhaps the sidekick mode is control of the options

- [] Add side panels
  - customize panels
  - [] art offerings
  - [] info offerings: music, score, multiplier
- [] display currently playing song title on a side panel

- [] Update ship select to show animation of ship firing arcs

- [] look into sound pools for sound effects
- [] look into object pools for spawning enemies and bullets


## Enemies
- Enemy deaths
- [] Increase explosion size to larger than enemy. 
- [] Have multiple deaths. 
- [] Have hit indicators: 
  - [x] visual
  - [] audio

- [] give enemies the ability to spawn other enemies
  - e.g., a mine laying ship

Enemy types:
[X] scout ship (long range shot, fast, low Hp)
[X] Fighter (fast, close range, slashing attack)
[X] Dreadnought (slow, multi-shot, high hp)
[] Orbital platform (stationary, aimed shot)
[] Torpedo ship (med speed, ripple shot, mid hp)
[] Carrier (slow, spawns fighters, cannon shot)
[] Space fence: constant barrier horizontally across screen
[X] Space tank
[X] Homing droids: chase after the player

Boss Ideas:
1. Ivory Dragon
2. Sable Hawk
3. The Damned Pearl: opens it clamshell firing a spread shot, but reveals a white orb that can be damaged
4. Giant Orbital Platform: fires slew of small bullets then rotates to fire giant beam cannon
5. Quasar: rotates and fires cannons out both ends
6. Super Quasar: fires out in X-pattern
7. Mecha: alternating whip attacks and also a chest barrage of missiles
8. Shield Bearer & Reaper: shield bearer projects shield in front of them & the reaper. Drops shield when Reaper launches slashing shot
9. Big Girl: former colleague
10. Mega Space fence: series of smaller fences that open and close to release small waves of foes.
11. Space Carrier Argus: launches a bunch of small mobs to attack you
12. Citrine Dream: does sweeping electric attacks (like Crono’s attack). Alternates direction

## Think about
* what if the source does bullets at different speeds?
* what if the bullets change speed as they fly?
* what if the bullets change directions as they fly?
* what if the bullets change behavior mid flight? (Fly out, a distance, stop, then fly at the player's current position)
