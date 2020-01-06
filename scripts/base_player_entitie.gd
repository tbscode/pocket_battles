extends Sprite
# The default player entitie template
var placed = false

var entitie_name
func init(name):
    entitie_name = self.name

func place_on_field(field):
    var grid = game_controller.get_current_grid()
    position.x = grid.position.x + field[0] * game_controller.globals.block_width
    position.y = grid.position.y + field[1] * game_controller.globals.block_width
    attatch_to_main_grid()
    placed = true

func attatch_to_main_grid():
    var tree = get_tree()
    get_parent().remove_child(self)
    tree.get_current_scene().get_node("player_entiti_collection").add_child(self)
