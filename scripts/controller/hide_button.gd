extends Button

# The Coordinates of the aread for given directions
var up_region = [96, 64]
var right_region = [32, 64]
var down_region = [64, 64]
var left_region = [32, 32]
var nothing_region = [128, 64]

var state = 0

func pressed():
    # Loop Trough all direction States of a given entitie 
    state += 1
    if state > 4:
        state = 0
    match state:
        0:
            change_image_region(nothing_region)
        1:
            change_image_region(up_region)
        2:
            change_image_region(right_region)
        3:
            change_image_region(down_region)
        4:
            change_image_region(left_region)

func change_image_region(region):
    self.get_node("direction_texture_sprite").region_rect.position.x = region[0] as float
    self.get_node("direction_texture_sprite").region_rect.position.y = region[1] as float
