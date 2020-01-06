extends Button


func pressed():
    if not get_parent().placed:
        # Fist clicking the Player node to use
        game_controller.hide_player_menu()
        game_controller.wait_for_field_selection()
        yield(game_controller, "field_selected")
        # Then click the field to place it in
        var field = game_controller.selected_field
        print((field as String))
        get_parent().place_on_field(field)
        game_controller.expand_player_menu()
