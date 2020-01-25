# Blog for Pocket Battles

### Asset Sources and Mentions:

- [Base ui](https://opengameart.org/content/pixel-uihud-pack)
- [Base Tile Assets](https://opengameart.org/content/bomber-planet-16x16-pixel-art-assets)
- [Pixel Webpons By SCay](https://opengameart.org/content/pixel-weapons-1)

Godot game I'm building within the \#FFSjam on itch.io.

> Graphics are placeholders

## The Game

It will be a tun based puzzle strategy game.

### 25/01 Desighned temporary logo, ui polishing

Used some open source pixel art to desighn a fast logo, as the FFSjam Deadline is coming up.

<img src="blog/pocket_battles13.gif" width="49%">

### 21/01 Adding new Graphics & found a  bug in godot?

Here the new Look (see sources on top of page)

<img src="blog/pocket_battles12.gif" width="49%">

Godot Scroll boxes seem to change anchors as thy want. Worked around that by resizing the object by code rather than relying on godots anchoring system.

<img src="blog/godot_problem1.gif" width="49%">

### 16/01 adding animations and battle system infrastructure

The entities can move now and fights are performed in order of entity placement. And all entities have individual animations now.

<img src="blog/pocket_battles11.gif" width="49%">

Before I change the graphics i can improved the look by adding some animations.

<img src="blog/pocket_battles10.gif" width="49%">

### 15/01 Editor almost done

Draw drawing and opponent placing and on is now implemented.

<img src="blog/pocket_battles9.gif" width="49%">

### 13/01 Added Level editor and Implemented the battle system

Added a level editor for the game, especially to be able to test edge-case level scenarios.

<img src="blog/pocket_battle7.gif" width="49%">

Entities will now fight at the end of the turn, if they end up in the same position.

<img src="blog/pocket_battle6.gif" width="49%">

### 11/01 Added Tiles and their functionality

The wall tile was implemented so far an blocks moves entering.

<img src="blog/pocket_battles5.gif" width="49%">

### 09/01 Finished the in game ui

Added all in game ui elements, and connected them to the entities.

### 07/01 More ui stuff and move selection

Implemented move selection

<img src="blog/pocket_battles4.gif" width="49%">

Select and place player nodes.

<img src="blog/pocket_battles3.gif" width="49%">

### 05/01 Base scene mechanic

Added the simple grid and implemented a level loader.
Implemented using independent objects for flexability.

<img src="blog/pocket_battles_1.gif" width="49%">

And base ui for player entity placement.

<img src="blog/pocket_battles2.gif" width="49%">



### TODO

- [ ] build levels
- [ ] implement main game mecanic
- [ ] anchor ui element to support different resolutions
- [x] Level loaded and saver using JSON 
- [x] level init enemy spawing and player selection
