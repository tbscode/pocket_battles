extends Node2D

var enemy_num : int

func select():
    get_node("margin/background").texture = game_controller.selected_enemy_move_background

func deselect():
    get_node("margin/background").texture = game_controller.un_selected_enemy_move_background
