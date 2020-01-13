extends Node

var health = 1
var attack = 1

func fight_against(entity):
    health -= entity.attack
    entity.health -= attack
    get_parent().process_after_fight()
    entity.get_parent().process_after_fight()

