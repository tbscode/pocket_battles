extends Button

func pressed():
    print("pressed play")
    var level = load("res://scripts/base_level.gd").new()
    # level.init(10, 10)
    level.init_from_string(game_controller.get_current_level().print_json())
    game_controller.level_queue.push_front(level)
    get_tree().change_scene("mainscene.tscn")
    print("playing level")

