extends Node
# is the main data flow point of the game

var level_queue = []

var enemies = preload("res://scenes/enemies.tscn").instance()
var player_entities = preload("res://scenes/player_entities.tscn").instance()

func _ready():
	print("initialized game controller")

func get_current_level():
    return level_queue.front()

func performe_move_on_current_level():
    get_current_level().performe_move()
