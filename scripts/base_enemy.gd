# base enemy class
extends Sprite

var move_stack = []
var globals = preload("res://globals.gd")

var x : int = 2
var y : int = 2

var entity_name

# the moves are emuleted by an array of numbers and a pointer
var move_pointer = 0
var move_queue

func init(_x,_y, entity_name, queue=[]):
    x = _x
    y = _y
    # Initializes the entities move queue if present
    move_queue = queue
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
    var move : int = move_queue[move_pointer]
    move_pointer += 1
    print("The proposed move is " + ( move as String))
    if move_pointer >= move_queue.size():
        return
    match move:
        0:# Down
            y += 1
        1:# Left
            x -= 1
        2:# Up
            y -= 1
        3:# Right
            x += 1
    position_on_map()
