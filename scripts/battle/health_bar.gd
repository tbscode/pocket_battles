extends Node2D

# Renderso a simple Health bar using the nine Patch
var bars
signal health_ajusted

func reconfigure(health):
    print("reconfigured a bar" + (health as String))
    bars = []
    bars.resize(health)
    var padding = 10
    var max_width = + get_viewport().size.x - position.x - 8 - padding
    # Resets the progress bar to a cartain health
    var offset = 4
    var x_pos = position.x - offset
    for s in range(health):
        var node = game_controller.get_reusable_ui_elements().get_node("bar_tab").duplicate()
        self.add_child(node)
        print("health counter")
        node.rect_position.x = x_pos
        node.rect_position.y = position.y
        node.rect_size.x = max_width / health
        x_pos += node.rect_size.x
        node.ID = health - s - 1
        bars[s] = node
    print("Bar size " + (bars.size() as String))

func reconfigure_relative(health, health_default):
    print("reconfigured a bar" + (health as String))
    bars = []
    bars.resize(health)
    var padding = 10
    var max_width = + get_viewport().size.x - position.x - 8 - padding
    # Resets the progress bar to a cartain health
    for c in self.get_children():
        self.remove_child(c)
    var offset = 4
    var x_pos = position.x - offset
    for s in range(health):
        var node = game_controller.get_reusable_ui_elements().get_node("bar_tab").duplicate()
        self.add_child(node)
        print("health counter")
        node.rect_position.x = x_pos
        node.rect_position.y = position.y
        node.rect_size.x = max_width / health_default
        x_pos += node.rect_size.x
        node.ID = health - s - 1
        bars[s] = node
    print("Bar size " + (bars.size() as String))

func remove_health(value):
    print("Wanna remove by" + (bars.size() as String))
    for i in range(0, value):
        print("Removed " + ( i as String))
        for c in get_children():
            if c.ID == i:
                self.remove_child(c)
                break
        bars.remove(i)
    emit_signal("health_ajusted")

