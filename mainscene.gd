extends Node2D

var level

# This is the level init script
func _ready():
    print(game_controller.level_queue)
    # import the level builder
    level = game_controller.level_queue.front()
    # level.add_enemies(game_controller.enemies) 
    level.build_level(get_tree(), game_controller.enemies)
    level.print_json()
    print("Enemies: " + (level.enemies as String))

