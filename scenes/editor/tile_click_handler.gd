extends Button

func pressed():
    # Checks if in level in editor mode:
    if game_controller.get_current_level().edit:
        # Check if placed of not
        game_controller.edit_mode = "draw" # TODO: reset in other places
        game_controller.set_selected_editor_tile(get_parent())
        print("selected wall tile")
        pass
