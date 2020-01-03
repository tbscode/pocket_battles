extends Button

func pressed():
    game_controller.get_current_level().performe_move()
