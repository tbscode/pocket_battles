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
            game_controller.edit_mode = "select"
            # The Editor Case 
            # TODO: Rename Game controller selection methods
            # Make a copy of that entity TODO: Delete it later
            var entity_copy = get_parent().duplicate()
            game_controller.register_as_selected_player_entity(entity_copy)
            # Set the states of all direction buttons to the entities move queue
            var move_buttons = game_controller.get_move_button_container().get_children()
            for i in range(get_parent().move_queue.size()):
                move_buttons[i].state = get_parent().move_queue[i]
                move_buttons[i].change_state_region()
            game_controller.wait_for_field_selection()
            yield(game_controller, "field_selected")
            # Then click the field to place it in
            var field = game_controller.selected_field
            if field == null:
                return
            entity_copy.x = field[0]
            entity_copy.y = field[1]
            print((field as String))
            game_controller.get_current_level().enemies.push_back(entity_copy)
            entity_copy.place_on_field(field, get_tree().get_current_scene())
            # The ask the player to set the desired move chain
            game_controller.show_move_menu()
            # yield(game_controller, "moves_selected")
            # Now wait for the player to hide the move menu, implieing that he is done
            game_controller.get_current_level().print_json()
    else:
        if enemy_parent.placed:
            game_controller.select_position(enemy_parent.position)
            game_controller.highlight_enemy_move(enemy_parent.enemy_num)
