extends Node
# is the main data flow point of the game

var level_queue = []

var enemies = preload("res://scenes/enemies.tscn").instance()
var player_entities = preload("res://scenes/player_entities.tscn").instance()
var globals = preload("res://globals.gd")

var reusable_ui_elements = preload("res://scenes/reusable_ui_elements.tscn").instance()
var tiles = preload("res://scenes/tiles.tscn").instance()

var selected_player_entity

var edit_mode = "select" # select, draw
signal field_selected
signal moves_selected
signal animation_finished # We wont play animation concurrently so one signal
signal health_ajusted

var selected_enemy_move_background = load("res://assets/ui/plain_select.png")
var un_selected_enemy_move_background = load("res://assets/ui/plain.png")

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
    if not get_current_level().first_move_made:
        # Disable the move ment buttons when drawing them
        get_current_level().add_player_moves_to_listing()
        get_current_level().first_move_made = true
    get_current_level().performe_move()
    yield(get_current_level(), "performed_moves")
    get_current_level().update()
    # Check if this was the last move:
    if get_current_level().no_moves_left():
        # Check if win or lose:
        var result = get_current_level().has_player_won()
        if result:
            print("The player has defeated the level")
        else:
            print("player has lost")

func reset_health_bar(value, health_default, first):
    # Resets the level secenes player 1 health bar
    if first:
        get_tree().get_current_scene().get_node("battle_view/health_bar1").reconfigure_relative(value, health_default)
    else:
        get_tree().get_current_scene().get_node("battle_view/health_bar2").reconfigure_relative(value, health_default)


func remove_from_health_bar(value, first):
    if first:
        get_tree().get_current_scene().get_node("battle_view/health_bar1").remove_health(value)
    else:
        get_tree().get_current_scene().get_node("battle_view/health_bar2").remove_health(value)


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
    get_tree().get_current_scene().get_node("player_move_menu/menu_container").rect_position.x = 0
    
func reload_move_menu(node):
    var move_buttons = self.get_move_button_container().get_children()
    for i in range(node.get_parent().move_queue.size()):
        move_buttons[i].state = node.get_parent().move_queue[i]
        move_buttons[i].change_state_region()
        if get_current_level().first_move_made:
            move_buttons[i].disabled = true

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

func highlight_player_move(enemy_num):
    get_current_level().highlight_player_move(enemy_num)

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

var selected_editor_tile
func set_selected_editor_tile(tile):
    # First desect all the other stuff
    selected_field = null
    wait_for_selection = false
    selected_player_entity = null
    emit_signal("field_selected")
    selected_editor_tile = tile

func get_battle_menu():
    return get_tree().get_current_scene().get_node("battle_view")

func show_battle_menu():
    var animations = get_battle_menu().get_node("animations") 
    animations.set_speed_scale(globals.speed_scale)
    animations.play("battle_menu")
    yield(animations, "animation_finished")
    emit_signal("animation_finished")
    #get_battle_menu().position.x = 0

func hide_battle_menu():
    var animations = get_battle_menu().get_node("animations") 
    animations.play_backwards("battle_menu")
    yield(animations, "animation_finished")
    emit_signal("animation_finished")
    #get_battle_menu().position.x = 0
