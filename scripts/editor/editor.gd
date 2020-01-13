extends Node2D

# Handles all the main editor stuff
var level

var grid
var globals = preload("res://globals.gd")
# This is the level init script
func _ready():
    level = game_controller.get_current_level()
    level.edit = true
    var game_scene = get_tree().get_current_scene()
    print(game_scene.get_path())
    game_scene.add_child(level) # Add the level to scene root to get object acess
    level.add_enemies_from_data()
    level.add_player_entities_from_data()
    level.add_level_tiles_from_data()
    level.build_level(game_scene) # Initializes all preloaded scene object
    game_controller.add_tiles_to_editor_tile_menu()
    # Load the grid cords forinput processig
    grid = self.get_node("grid")
    # Place the Player Entities as Options in the Player Menu
    print("Enemies: " + (level.enemies as String))
    print("Player Entities: " + (level.player_entities as String))
    level.print_json()
    add_enemy_entities_to_menu()

func _input(event):
    if event is InputEventMouseButton:
        # mouse button event
        if not event.pressed:
            # and it was the click down
            # Get the grid position
            # Check if the click is contained in the grid:
            if is_click_event_in_grid(event):
                if game_controller.wait_for_selection:
                    var x_pos = ((event.position.x - grid.position.x) / globals.block_width) as int
                    var y_pos = ((event.position.y - grid.position.y) / globals.block_width) as int
                    var field_vec = [x_pos, y_pos]
                    game_controller.field_selected(field_vec)
                    print("selected field" + (field_vec as String))

func add_enemy_entities_to_menu():
    # Will add all available enemy entites to the menu
    var enemy_entities = game_controller.get_enemy_entities().get_children()
    for i in range(enemy_entities.size()):
        # Now add it to the menu with given offset
        var enemy = enemy_entities[i].duplicate()
        enemy.position.x = i * globals.block_width
        enemy.position.y = 0
        get_tree().get_current_scene().get_node("enemy_entitie_menu").add_child(enemy)

func is_click_event_in_grid(event):
    var x_contained = event.position.x > grid.position.x && event.position.x < (grid.position.x + grid.get_actual_width())
    var y_contained = event.position.y > grid.position.y && event.position.y < (grid.position.y + grid.get_actual_height())
    return ( x_contained && y_contained)


