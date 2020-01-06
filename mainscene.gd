extends Node2D

var level

var grid
var globals = preload("res://globals.gd")
# This is the level init script
func _ready():
    level = game_controller.get_current_level()
    var game_scene = get_tree().get_current_scene()
    print(game_scene.get_path())
    game_scene.add_child(level) # Add the level to scene root to get object acess
    level.add_enemies_from_data()
    level.add_player_entities_from_data()
    level.build_level(game_scene) # Initializes all preloaded scene object
    # Load the grid cords forinput processig
    grid = self.get_node("grid")
    # Place the Player Entities as Options in the Player Menu
    print("Enemies: " + (level.enemies as String))
    print("Player Entities: " + (level.player_entities as String))
    level.print_json()

func _input(event):
    if event is InputEventMouseButton:
        # mouse button event
        if event.pressed:
            # and it was the click down
            # Get the grid position
            # Check if the click is contained in the grid:
            if event.position.x > grid.position.x && event.position.x < (grid.position.x + grid.get_actual_width()):
                if game_controller.wait_for_selection:
                    var x_pos = ((event.position.x - grid.position.x) / globals.block_width) as int
                    var y_pos = ((event.position.y - grid.position.y) / globals.block_width) as int
                    var field_vec = [x_pos, y_pos]
                    game_controller.field_selected(field_vec)
                    print("selected field" + (field_vec as String))

