extends Node

# This type script every enemy has, it contains enemy type specific data

var base_moves = [ 0, 1, 2, 3, 4] # Nothing, Up, Right, Down, Left

var health = 5
var health_default = health
var attack = 3

func fight_against(entity):
    health -= entity.attack
    entity.health -= attack
    get_parent().process_after_fight()
    entity.get_parent().process_after_fight()

