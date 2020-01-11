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
    # Fisr get the tile, in the current position
    # Then call the try_exit method, if that return true
    # Then call try_enter on the future tile, if that return true
    # Call exit, on current, and enter on future
    if move_pointer >= move_queue.size():
        return

    var future_x : int = x
    var future_y : int = y

    match move:
        0:
            pass
        1:# up
            if y > 0:
                future_y -= 1
        2:# right
            if x < game_controller.get_current_level().width: 
                future_x += 1
        3:# Down
            if y < game_controller.get_current_level().height:
                future_y += 1
        4:# Right
            if x > 0:
                future_x -= 1

    var level = game_controller.get_current_level()
    print("future pos" + ( future_x as String ) + " " + ( future_y as String ))
    var next_tile = level.get_tile_node_at(future_x, future_y)
    var current_tile = level.get_tile_node_at(x, y)
    if current_tile == null or current_tile.get_node("type").try_exit():
        if next_tile == null or next_tile.get_node("type").try_enter():
            if current_tile != null:
                current_tile.get_node("type").exit()
            else:
                print("no current tile")
            x = future_x
            y = future_y
            if next_tile != null:
                next_tile.get_node("type").enter()
            else:
                print("no next tile")
    position_on_map()

