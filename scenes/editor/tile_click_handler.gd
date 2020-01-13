extends Button

func pressed():
    # Checks if in level in editor mode:
    if game_controller.get_current_level().edit:
        # Check if placed of not
        print("selected wall tile")
        pass
