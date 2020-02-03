extends AnimationPlayer

# A script that lets the game dynamicly set the starting pos of the animation
signal pos_adjusted

func set_animation_start_pos(pos):
    var ani1 = get_animation("move_to_battle_view1")
    var ani2 = get_animation("move_to_battle_view2")
    var idx = ani1.find_track(".:position")
    var idx2 = ani2.find_track(".:position")
    ani1.track_set_key_value(idx,0, pos)
    ani2.track_set_key_value(idx2,0, pos)
    print("animation start pos adjusted")
    emit_signal("pos_adjusted")
