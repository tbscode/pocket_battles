extends Button

func pressed():
    var level = load("res://scripts/base_level.gd").new()
    # level.init(10, 10)
    var file = File.new()
    file.open("res://levels/level2.lvl", File.READ)
    text = file.get_as_text()
    level.init_from_string(text)
    game_controller.level_queue.push_back(level)
    get_tree().change_scene("res://scenes/editor/editor.tscn")
    # When scene loads before transition enemie nodes are not preloaded

