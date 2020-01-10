

> All graphics are still place holders, will be replaced

## [ See Blog ](https://tbscode.github.io/pocket_battles/)

## Game Objective

Create balance between the two sides.
Defeat all enemies but use as few figures as possible.

## Game Play

A level has different blocks and enemies.
Every enemy has a predefined move queue and a starting position.
The player is given a deck of figures.
Then he may place those, and define their moves.

## A Game Turn

After the player placed all his figures he may make the first turn.
All entities perform their next queued move.
The outcome of those moves depends on their current, and the tile about to enter.

If two entities end up in the same place they fight.
The outcome of the fight depends on the entities type.

An entity may - 
- be defeated
- teleport
- stay in place
- ...

## The Tiles

- Wall Tile
    A move on this tile can not be performed
- Teleport Tile
    Teleports to the marked position
- Spike
    Damages or defeats an entity

*More to come*

## The Entities

- Pawn
    Has the base move set and one life
