extends Button

func _ready():
    pass # Replace with function body.

func pressed():
    var level = load("res://scripts/base_level.gd").new()
    # level.init(10, 10)
    var file = File.new()
    file.open("res://levels/level1.lvl", File.READ)
    text = file.get_as_text()
    level.init_from_string(text)
    game_controller.level_queue.push_back(level)
    get_tree().change_scene("res://mainscene.tscn")
    # When scene loads before transition enemie nodes are not preloaded
