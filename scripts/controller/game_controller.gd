extends Node
# is the main data flow point of the game

var level_queue = []

var enemies = preload("res://scenes/enemies.tscn").instance()
var player_entities = preload("res://scenes/player_entities.tscn").instance()
var globals = preload("res://globals.gd")

var reusable_ui_elements = preload("res://scenes/reusable_ui_elements.tscn").instance()

signal field_selected
signal moves_selected

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
    # TODO: Rename because it doesnt doe the waiting
    # Startes the game controller to wait for an area selection on the map
    wait_for_selection = true

func field_selected(field):
    # called by the grid, when field on the grid was selected
    selected_field = field
    print(field as String)
    wait_for_selection = false
    emit_signal("field_selected")

var wait_for_move_selection = false
func trigger_wait_for_move_selection():
    wait_for_move_selection = true

func selected_moves():
    # Called externally when the player hides the move menu
    wait_for_move_selection = false
    emit_signal("moves_selected")

func get_reusable_ui_elements():
    return reusable_ui_elements

func hide_player_menu():
    get_tree().get_current_scene().get_node("player_menu/menu_container").position.y = -200

func expand_player_menu():
    get_tree().get_current_scene().get_node("player_menu/menu_container").position.y = 0

func show_move_menu():
    # Will simply move the move emnu in view
    get_tree().get_current_scene().get_node("player_move_menu/menu_container").position.x = 0

func hide_move_menu():
    # Will simply move the move emnu in view
    get_tree().get_current_scene().get_node("player_move_menu/menu_container").position.x = 420
