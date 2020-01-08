extends Sprite
# The default player entitie template
var placed = false

var move_queue = []
var move_pointer = 0

var x = 0
var y = 0

var entitie_name

var globals


func _ready():
    globals = game_controller.get_globals()

func init(name):
    entitie_name = self.name
    move_queue.resize(game_controller.get_current_level().turn_amount)
    for i in range(move_queue.size()):
        move_queue[i] = 0


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


func change_move_queue(state_id, state):
    move_queue[state_id] = state
    print(move_queue as String)

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
