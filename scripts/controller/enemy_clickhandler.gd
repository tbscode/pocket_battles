extends Button

func pressed():
    # When an enemy node was pressed
    # move the highlighter sprite to that position
    var enemy_parent = get_parent()
    game_controller.select_position(enemy_parent.position)
    game_controller.highlight_enemy_move(enemy_parent.enemy_num)

