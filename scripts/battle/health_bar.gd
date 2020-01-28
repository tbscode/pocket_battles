extends Node2D

# Renders a simple Health bar using the nine Patch


func _ready():
    reconfigure(2)

func reconfigure(health):
    var padding = 10
    var max_width = get_viewport().size.x - position.x - 8 - padding
    # Resets the progress bar to a cartain health
    var offset = 4
    var x_pos = position.x - offset
    for s in range(health):
        var node = game_controller.get_reusable_ui_elements().get_node("bar_tab").duplicate()
        self.add_child(node)
        node.rect_position.x = x_pos
        node.rect_position.y = position.y
        node.rect_size.x = max_width / health
        x_pos += node.rect_size.x

