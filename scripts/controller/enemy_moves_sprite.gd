extends Sprite

var g
var state : int = 0

func change_state_region():
    print("Changing with state" + (state as String))
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
    print("Done Matching")


func change_image_region(region):
    region_rect.position.x = region[0] as float
    region_rect.position.y = region[1] as float
    print("changed move region")

func set_state(new_state):
    state = new_state
    change_state_region()
            
