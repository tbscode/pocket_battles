extends Node2D

var level

# This is the level init script
func _ready():
    level = game_controller.get_current_level()
    var game_scene = get_tree().get_current_scene()
    print(game_scene.get_path())
    game_scene.add_child(level) # Add the level to scene root to get object acess
    level.add_enemies_from_data()
    level.add_player_entities_from_data()
    level.build_level(game_scene) # Initializes all preloaded scene object
    # Place the Player Entities as Options in the Player Menu
    print("Enemies: " + (level.enemies as String))
    print("Player Entities: " + (level.player_entities as String))
    level.print_json()

