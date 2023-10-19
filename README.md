Started as a classic space invaders clone from the tutorial  at https://kidscancode.org/godot_recipes/4.x/games/first_2d/
Heavily modified now

TODOs (not in priority order yet)
-----
- Go change the z-ordering of enemy bullets to be drawn above everything

- Add firing station and order to enemies
- Make shot patterns a part of each enemy/weapon
- Start building 30 to 60 second long stages
    - add song changes with the stage changes
    - add in spawn pattern following 5-7 lanes with alternating sides of the screen
        - move the other spawn patterns to a randomizer spawn node
- Remove enemy warp back to start
- Figure out how to play more than one song
- make pickup system
- make different items and weapons as pickups
  - slashing effect, super cannon shot, screen wide weak bullets, meteor hammer (meteor crashing down in front of player)

- add environmental hazards like asteroids

- Start adding flags to different functionality that I eventually want to be able to turn off/change

- Add settings menu

- Add splash screen

- Add start screen

- Add game over screen

- Add high score saving

- Remove shield and make it an item. 
  - Add animation for shield being hit 
 
- Add checkpoints / restart

- Add invincibility after respawn

- Cancel bullets of dead enemies?

- Add attract mode

- Add more shot patterns to each enemy for difficulty increase

- make story mode and attack mode

- add scoring triggers to generate items/powerups/1ups

- add focused shot for player with holding down the button

- Add UI indication of scoring chain: either timer or "x Multiplier" UI element?

- look into sound pools for sound effects
- look into object pools for spawning enemies and bullets

- Possibly replace player weaposn with firing modes that can be unlocked throughout play
 - options Stack, Spread, Tailfan, 

 - possibly add drones that fly around the player that do damage:
    - firing modes: spread, tail, front, ring, rolling (always forward firing, but rotate around player)
