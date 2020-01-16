# base enemy class
extends Sprite

var move_stack = []
var globals = preload("res://globals.gd")

var x : int = 2
var y : int = 2

var entity_name

var enemy_num : int

# the moves are emuleted by an array of numbers and a pointer
var move_pointer = 0
var move_queue

var placed = false

func init(_x,_y, entity_name, queue=[]):
    x = _x
    y = _y
    # Initializes the entities move queue if present
    move_queue = queue
    entity_name = self.entity_name

func _ready():
    if game_controller.get_current_level().edit:
        # If in edit mode then initialize a zeroed move queue
        move_queue = [0]
        move_queue.resize(game_controller.get_current_level().turn_amount)
        for i in range(move_queue.size()):
            move_queue[i] = 0
    else:
        position_on_map()

func position_on_map():
    # Sets the enemies position on the map
    print(enemy_num as String)
    placed = true
    var grid = get_tree().get_nodes_in_group("grid")[0] # Load the worlds grid
    position.x = grid.position.x + x * globals.block_width
    position.y = grid.position.y + y * globals.block_width

func place_on_field(field,scene=null):
    var grid = game_controller.get_current_grid()
    position.x = grid.position.x + field[0] * game_controller.globals.block_width
    position.y = grid.position.y + field[1] * game_controller.globals.block_width
    attatch_to_main_grid(scene)
    placed = true

func attatch_to_main_grid(scene=null):
    var tree = get_tree()
    # In The editor we dont want to remove the tile
    if not game_controller.get_current_level().edit:
        get_parent().remove_child(self)
    if scene == null:
        tree.get_current_scene().get_node("enemy_entiti_collection").add_child(self)
    else:
        scene.get_node("enemy_entiti_collection").add_child(self)

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

func change_move_queue(state_id, state):
    move_queue[state_id] = state

func process_after_fight():
    if get_node("type").health <= 0:
        game_controller.get_current_level().remove_enemy(self)

func load_own_character_in_battle(first):
    # Changes the battle character sprite
    if first:
        game_controller.get_battle_menu().remove_entity1()
    else:
        game_controller.get_battle_menu().remove_entity2()


func fight_against(entity, first):
    # first is set if first character in battle
    load_own_character_in_battle(first)
    # Will performe only the attack of that entity
    var enemy_type = entity.get_node("type")
    enemy_type.health -= $type.attack
    # The outer fight function, used to draw the default battle animations
    # $type.fight_against(entity.get_node("type"))



