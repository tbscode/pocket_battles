extends Sprite
# The default player entitie template
var entitie_name
func init(name):
    entitie_name = self.name

func place_on_field(field):
    var grid = game_controller.get_current_grid()
    position.x = grid.position.x + field[0] * game_controller.globals.block_width
    position.y = grid.position.y + field[1] * game_controller.globals.block_width
