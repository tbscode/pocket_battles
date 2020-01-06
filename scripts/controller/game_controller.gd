extends Node
# is the main data flow point of the game

var level_queue = []

var enemies = preload("res://scenes/enemies.tscn").instance()
var player_entities = preload("res://scenes/player_entities.tscn").instance()
var globals = preload("res://globals.gd")

signal field_selected
var selected_field = [0, 0]

func _ready():
	print("initialized game controller")

func get_globals():
    return globals

func get_current_level():
    return level_queue.front()

var wait_for_selection = false
func performe_move_on_current_level():
    get_current_level().performe_move()

func get_current_grid():
    return get_tree().get_current_scene().get_node("grid")

func wait_for_field_selection():
    # Startes the game controller to wait for an area selection on the map
    wait_for_selection = true

func field_selected(field):
    # called by the grid, when field on the grid was selected
    selected_field = field
    print(field as String)
    emit_signal("field_selected")

