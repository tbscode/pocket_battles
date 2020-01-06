extends Button


func pressed():
    # Fist clicking the Player node to use
    game_controller.wait_for_field_selection()
    yield(game_controller, "field_selected")
    # Then click the field to place it in
    var field = game_controller.selected_field
    print((field as String))
    get_parent().place_on_field(field)
