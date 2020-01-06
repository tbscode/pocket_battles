extends Button

func pressed():
    game_controller.hide_move_menu()
    game_controller.selected_moves()
