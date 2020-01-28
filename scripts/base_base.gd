extends Sprite

var placed = false

var move_queue = []
var move_pointer = 0

var x : int = 0
var y : int = 0

var entity_name
var entity_num

var globals

signal move_performed
signal attack_finished

var friendly = false

func _ready():
    globals = game_controller.get_globals()

func place_on_field(field):
    var grid = game_controller.get_current_grid()
    position.x = grid.position.x + field[0] * game_controller.globals.block_width
    position.y = grid.position.y + field[1] * game_controller.globals.block_width
    placed = true
    attatch_to_main_grid()

func attatch_to_main_grid(tree=get_tree()):
    if placed:
        get_parent().remove_child(self)
    if friendly:
        tree.get_current_scene().get_node("player_entiti_collection").add_child(self)
    else:
        tree.get_current_scene().get_node("enemy_container").add_child(self)

func add_to_scene(tree):
    attatch_to_main_grid(tree)
    



func change_move_queue(state_id, state):
    move_queue[state_id] = state
    print(move_queue as String)

func position_on_map():
    # Sets the enemies position on the map
    var grid = get_tree().get_nodes_in_group("grid")[0] # Load the worlds grid
    position.x = grid.position.x + x * globals.block_width
    position.y = grid.position.y + y * globals.block_width

func calculate_new_position_on_map(x_pos, y_pos):
    # Does same as above but without changing it
    var grid = get_tree().get_nodes_in_group("grid")[0] # Load the worlds grid
    return Vector2(grid.position.x + x_pos * globals.block_width,grid.position.y + y_pos * globals.block_width)

var was_move_made = false
func performe_move():
    was_move_made = false
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
            print("Nothing to do")
            return
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
            var future_pos = calculate_new_position_on_map(future_x, future_y)
            generate_movement_animation_and_play(future_pos)
            was_move_made = true
            x = future_x
            y = future_y
            if next_tile != null:
                next_tile.get_node("type").enter()
            else:
                print("no next tile")


func process_after_fight():
    if get_node("type").health <= 0:
        print("entity, dead")
        if friendly:
            game_controller.get_current_level().remove_player_entity(self)
        else:
            game_controller.get_current_level().remove_enemy(self)

func load_own_character_in_battle(first):
    # Changes the battle character sprite
    $animations.set_animation_start_pos(self.position)
    # TODO: removing the enteties not needed anymore
    if first:
        game_controller.get_battle_menu().remove_entity1()
    else:
        game_controller.get_battle_menu().remove_entity2()

func generate_movement_animation_and_play(future):
    # Based on the given direction this will return a animation for that
    var animation = Animation.new()
    var leng = 0.5
    animation.set_length(leng) # Half a second
    animation.add_track(Animation.TYPE_VALUE)
    animation.track_set_path(0, ".:position")
    animation.track_insert_key(0, 0, position)
    animation.track_insert_key(0, leng, future)
    $animations.add_animation("move", animation)
    $animations.play("move")
    yield($animations, "animation_finished")
    was_move_made = false
    emit_signal("move_performed")

func take_battle_position(first):
    if first:
        $animations.play("move_to_battle_view1")
    else:
        $animations.play("move_to_battle_view2")

func fight_against(entity, first):
    # first is set if first character in battle
    load_own_character_in_battle(first)
    # Will performe only the attack of that entity
    var enemy_type = entity.get_node("type")

    if first:
        $animations.play("attack_pos1")
        yield($animations, "animation_finished")
        $animations.play_backwards("attack_pos1")
    else:
        $animations.play("attack_pos2")
        yield($animations, "animation_finished")
        $animations.play_backwards("attack_pos2")
    yield($animations, "animation_finished")

    enemy_type.health -= $type.attack
    emit_signal("attack_finished")
    # The outer fight function, used to draw the default battle animations
    # $type.fight_against(entity.get_node("type"))

