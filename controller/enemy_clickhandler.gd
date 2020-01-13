extends Button

func pressed():
    # When an enemy node was pressed
    # move the highlighter sprite to that position
    var enemy_parent = get_parent()
    if game_controller.get_current_level().edit:
        if enemy_parent.placed:
            game_controller.register_as_selected_player_entity(get_parent())
            game_controller.select_position(enemy_parent.position)
            var move_buttons = game_controller.get_move_button_container().get_children()
            for i in range(get_parent().move_queue.size()):
                move_buttons[i].state = get_parent().move_queue[i]
                move_buttons[i].change_state_region()
            # TODO: Apparently changing moves of 
            game_controller.show_move_menu()
        else:
            # The Editor Case 
            # TODO: Rename Game controller selection methods
            game_controller.register_as_selected_player_entity(get_parent())
            # Set the states of all direction buttons to the entities move queue
            var move_buttons = game_controller.get_move_button_container().get_children()
            for i in range(get_parent().move_queue.size()):
                move_buttons[i].state = get_parent().move_queue[i]
                move_buttons[i].change_state_region()
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
            # yield(game_controller, "moves_selected")
            # Now wait for the player to hide the move menu, implieing that he is done
    else:
        if enemy_parent.placed:
            game_controller.select_position(enemy_parent.position)
            game_controller.highlight_enemy_move(enemy_parent.enemy_num)
