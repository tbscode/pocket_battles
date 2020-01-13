extends Button

# The Coordinates of the aread for given directions

var state = 0
var move_num = 0

var g

func _ready():
    g = game_controller.get_globals()

func pressed():
    # Loop Trough all direction States of a given entitie 
    state += 1
    if state > 4:
        state = 0
    change_state_region()
    # Now Notify the game controller, that a state hast changed
    game_controller.state_of_selected_entity_changed(move_num, state)
    
func reset_state():
    # Simply resets to the default state
    state = 0
    change_state_region()

func change_state_region():
    match state:
        0:
            change_image_region(g.nothing_region)
        1:
            change_image_region(g.up_region)
        2:
            change_image_region(g.right_region)
        3:
            change_image_region(g.down_region)
        4:
            change_image_region(g.left_region)



func change_image_region(region):
    self.get_node("direction_texture_sprite").region_rect.position.x = region[0] as float
    self.get_node("direction_texture_sprite").region_rect.position.y = region[1] as float
