# base enemy class
extends "res://scripts/base_base.gd"


func init(_x,_y, entity_name, queue=[]):
    x = _x
    y = _y
    # Initializes the entities move queue if present
    move_queue = queue
    entity_name = self.entity_name

func _ready():
    if game_controller.get_current_level().edit:
        # If in edit mode then initialize a zeroed move queue
        move_queue = [0]
        move_queue.resize(game_controller.get_current_level().turn_amount)
        for i in range(move_queue.size()):
            move_queue[i] = 0
    else:
        position_on_map()
