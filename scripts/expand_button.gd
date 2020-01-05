extends Button

func pressed():
    get_parent().get_node("menu_container").position.y = 0
    print("Tried to move menu container position")
