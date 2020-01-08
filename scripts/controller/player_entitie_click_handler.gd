extends Button


# TODO Move all this in the base enemy it self
# TODO Remove duble capsulation of base player and enemy
func pressed():
    if not get_parent().placed:
        # Fist clicking the Player node to use
        game_controller.register_as_selected_player_entity(get_parent())
        game_controller.hide_player_menu()
        game_controller.wait_for_field_selection()
        yield(game_controller, "field_selected")
        # Then click the field to place it in
        var field = game_controller.selected_field
        get_parent().x = field[0]
        get_parent().y = field[1]
        print((field as String))
        get_parent().place_on_field(field)
        # The ask the player to set the desired move chain
        game_controller.show_move_menu()
        yield(game_controller, "moves_selected")
        # Now wait for the player to hide the move menu, implieing that he is done
        game_controller.get_current_level().reposition_player_entities_in_menu()
        game_controller.expand_player_menu()
    else:
        # Reopen the move menu if not jet in battle mode
        print("Pressed but already placed")
        game_controller.show_move_menu()
