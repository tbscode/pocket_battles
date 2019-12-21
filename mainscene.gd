extends Node2D

var level

# This is the level init script
func _ready():
    print(game_controller.level_queue)
    # import the level builder
    level = game_controller.level_queue.front()
    # level.add_enemies(game_controller.enemies) 
    get_tree().get_root().add_child(level) # Add the level to scene root to get object acess
    level.add_enemies_from_data()
    level.build_level(get_tree()) # Initializes all preloaded scene object
    print("Enemies: " + (level.enemies as String))
    level.print_json()

