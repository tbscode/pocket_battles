# base enemy class
extends Sprite

var move_stack = []
var globals = preload("res://globals.gd")

var x = 2
var y = 2

var entity_name

func init(x, y, entity_name):
    x = self.x
    y = self.y 
    entity_name = self.entity_name

func _ready():
    position_on_map()

func position_on_map():
    # Sets the enemies position on the map
    var grid = get_tree().get_nodes_in_group("grid")[0] # Load the worlds grid
    position.x = grid.position.x + x * globals.block_width
    position.y = grid.position.y + (y + 1) * globals.block_width

func performe_move():
    # Does one move of the move stack
    var move = move_stack[0]
    move_stack.erase(0) # Then remove the move
