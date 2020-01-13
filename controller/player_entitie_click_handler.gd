extends Button


# TODO Move all this in the base enemy it self
# TODO Remove duble capsulation of base player and enemy
func pressed():
    if not get_parent().placed:
        # Fist clicking the Player node to use
        game_controller.register_as_selected_player_entity(get_parent())
        # Set the states of all direction buttons to the entities move queue
        game_controller.reload_move_menu(self)
        game_controller.wait_for_field_selection()
        yield(game_controller, "field_selected")
        # Then click the field to place it in
        var field = game_controller.selected_field
        print((field as String))

        #Now check if an entity is allowed on that field
        var tile_node = game_controller.get_current_level().get_tile_node_at(field[0],field[1])
        if tile_node == null or tile_node.get_node("type").can_place_entity_on():
            get_parent().x = field[0]
            get_parent().y = field[1]
            get_parent().place_on_field(field)
            # The ask the player to set the desired move chain
            game_controller.show_move_menu()
            # Now wait for the player to hide the move menu, implieing that he is done
            game_controller.get_current_level().reposition_player_entities_in_menu()
        else:
            # Deselect this entity again
            game_controller.deregister_unselect_entity()
    else:
        # Reopen the move menu if not jet in battle mode
        print("Pressed but already placed")
        game_controller.register_as_selected_player_entity(get_parent())
        game_controller.reload_move_menu(self)
        game_controller.show_move_menu()
        game_controller.select_position(get_parent().position)
