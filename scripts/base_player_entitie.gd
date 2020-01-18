extends "res://scripts/base_base.gd"
# The default player entitie template

func _read():
    friendly = true
    
func init(name):
    entity_name = name
    move_queue.resize(game_controller.get_current_level().turn_amount)
    for i in range(move_queue.size()):
        move_queue[i] = 0

