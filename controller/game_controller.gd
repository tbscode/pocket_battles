extends Node
# is the main data flow point of the game

var level_queue = []

var enemies = preload("res://scenes/enemies.tscn").instance()
var player_entities = preload("res://scenes/player_entities.tscn").instance()
var globals = preload("res://globals.gd")

var reusable_ui_elements = preload("res://scenes/reusable_ui_elements.tscn").instance()
var tiles = preload("res://scenes/tiles.tscn").instance()

var selected_player_entity

signal field_selected
signal moves_selected

var selected_enemy_move_background = load("res://assets/ui/red_pressed.png")
var un_selected_enemy_move_background = load("res://assets/ui/red.png")

var selected_field = [0, 0]

func _ready():
	print("initialized game controller")

func get_globals():
    return globals

func get_current_level():
    return level_queue.front()

func get_enemy_entities():
    return enemies

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

func get_tile_by_id(id):
    # Returns a map tile by its id
    for tile in tiles.get_children():
        if tile.get_node("type").ID == id:
            return tile.duplicate()

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
    print("showing the move menu")
    self.un_hide_all_move_buttons()
    get_tree().get_current_scene().get_node("player_move_menu/menu_container").position.x = 0
    
func reload_move_menu(node):
	var move_buttons = self.get_move_button_container().get_children()
	for i in range(node.get_parent().move_queue.size()):
		move_buttons[i].state = node.get_parent().move_queue[i]
		move_buttons[i].change_state_region()

func hide_all_move_buttons():
	get_move_button_container().set_visible(false)

func un_hide_all_move_buttons():
	get_move_button_container().set_visible(true)

func hide_move_menu():
    # Will simply move the move emnu in view
    get_tree().get_current_scene().get_node("player_move_menu/menu_container").position.x = 420

func get_move_button_container():
    return get_tree().get_current_scene().get_node("player_move_menu/menu_container/margin/scroll/hbox")

func register_as_selected_player_entity(entity):
    # for the entity to call when clicked
    selected_player_entity = entity

func deregister_unselect_entity():
    selected_player_entity = null

func get_selected_player_entity():
    # get the currently selected player entity
    return selected_player_entity

func highlight_enemy_move(enemy_num):
    get_current_level().highlight_enemy_move(enemy_num)

func state_of_selected_entity_changed(state_id, state):
    # When one of the direction buttons was pressed
    get_selected_player_entity().change_move_queue(state_id, state)

func add_tiles_to_editor_tile_menu():
    # Adds all available tiles to the editors menu
    var editor_menu_container = get_tree().get_current_scene().get_node("tile_menu/margin")
    var tile_nodes = tiles.get_children()
    for i in range(tile_nodes.size()):
        var tile = tile_nodes[i].duplicate()
        editor_menu_container.add_child(tile)
        tile.position.x = i * globals.block_width

func select_position(vec):
    get_tree().get_current_scene().get_node("selector").position = vec
