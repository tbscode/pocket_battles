extends Node2D

var edit = false

var tiles = [0] 
var tile_nodes = []
var width : int
var height : int

var enemies = [] # List of enemies
var player_entities = [] # Holds the Players Tiles.
var enemy_data # Hold all the enemies after init, before thy are added to the scene
var enemy_move_containers = []
var player_entitie_data

var globals = preload("res://globals.gd")

var turn_amount # every level has a locked amount of turns
var moves_performed : int = 0

signal performed_moves

func init(width, height):
    tiles.resize(width)
    for i in range(tiles.size()):
        tiles[i] = [0]
        tiles[i].resize(height)
        for j in range(tiles[i].size()):
            tiles[i][j] = 0

func init_from_string(level_string):
    # Loads the level, from the level string created with print_json
    var data = JSON.parse(level_string).get_result()
    print(data)
    self.width = (data["width"] as int)
    self.height = (data["height"] as int)
    self.turn_amount = (data["turn_amount"] as int)
    tiles = data["level"]
    # init(width, height)
    enemy_data = data["enemies"]
    player_entitie_data = data["player_entities"]
    print("Enemies" + ( enemy_data as String) )

func add_enemies_from_data():
    enemies.resize(enemy_data.size())
    for i in range(enemy_data.size()):
        print(enemy_data[i])
        var name = enemy_data[i]["name"]
        var x = enemy_data[i]["x"]
        var y = enemy_data[i]["y"]
        var enemy_move_queue = enemy_data[i]['moves']
        print("Some of the data" + name )
        print("The moves " + ( enemy_move_queue as String))
        enemies[i] = get_enemy_node_byname(game_controller.enemies, name)
        enemies[i].init(x, y, self.name, enemy_move_queue)
        enemies[i].entity_num = i

func add_level_tiles_from_data():
    # Loads all the levels tiles and adds them to the map
    tile_nodes = []
    tile_nodes.resize(width)
    for x in range(width):
        tile_nodes[x] = []
        tile_nodes[x].resize(height)
        for y in range(height):
            tile_nodes[x][y] = game_controller.get_tile_by_id(tiles[x][y])
            if tile_nodes[x][y] != null:
                get_tree().get_current_scene().get_node("grid").add_child(tile_nodes[x][y])
                tile_nodes[x][y].position.x = x * globals.block_width
                tile_nodes[x][y].position.y = y * globals.block_width
    print(tile_nodes as String)

func add_player_entities_from_data():
    player_entities.resize(player_entitie_data.size())
    for i in range(player_entities.size()):
        print(player_entitie_data[i])
        var name = player_entitie_data[i]["name"]
        player_entities[i] = get_player_node_byname(game_controller.player_entities, name)
        player_entities[i].init(name)
        player_entities[i].entity_num = i

func get_enemy_node_byname(enemy_nodes, name):
    # load the enmy sceen add it to the tree
    var node = enemy_nodes.find_node(name).duplicate()
    print(node)
    return node

func get_player_node_byname(player_nodes, name):
    print(player_nodes)
    # Expects the game controllers collection of all available player entities
    var node = player_nodes.find_node(name).duplicate()
    print(node)
    return node

func add_enemies(enemie_nodes):
    var rook = enemie_nodes.find_node("rook").duplicate()
    rook.init(2, 1, "rook")
    enemies.push_back(rook)

func build_level(scene):
    # We here assume the level was added to the scene tree
    # TODO add the tiles
    # TODO` put elsewhere
    add_level_nodes_to_scene(scene)
    

func add_level_nodes_to_scene(scene):
    var enemy_container = scene.find_node("enemy_container")
    for e in enemies:
        enemy_container.add_child(e)
        e.position_on_map()
        e.get_node("animations").set_speed_scale(game_controller.get_globals().speed_scale)

        e.placed = true

    var x_pos = 0
    var y_pos = 0
    var player_entitie_container = scene.find_node("menu_container")
    
    for entitie in player_entities:
        player_entitie_container.add_child(entitie)
        entitie.position.x = x_pos
        entitie.position.y = y_pos
        x_pos += globals.block_width
        entitie.get_node("animations").set_speed_scale(game_controller.get_globals().speed_scale)
        # TODO: add line break logic

    # Add the Move buttons to the player_move_menu
    # Fist load the external Button
    add_player_move_menu()

func add_player_move_menu():
    var x_pos = 0 
    var move_button = game_controller.get_reusable_ui_elements().get_node("direction_button")
    print("got the button" + (move_button.rect_size.x as String))
    x_pos = 0
    for i in range(turn_amount):
        var new_button = move_button.duplicate()
        new_button.rect_position.x = x_pos
        get_tree().get_current_scene().get_node("player_move_menu/menu_container/margin/scroll/hbox").add_child(new_button)
        x_pos += move_button.rect_size.x
        new_button.move_num = i
        print((i as String))


func add_enemy_moves_to_listing():
    # Adds all the enemy move desriptions to the listing
    var enemy_move_display = get_tree().get_current_scene().get_node("enemy_move_display/margin/scroll/vbox")
    var row_count = 0
    for enemy in enemies:
        var move_container = game_controller.get_reusable_ui_elements().get_node("enemy_move_container").duplicate()
        move_container.position.y = row_count * move_container.get_node("margin").rect_size.y
        move_container.entity_num = row_count
        enemy_move_containers.push_front(move_container)
        var line_count = 0
        for move in enemy.move_queue:
            var move_disp = game_controller.get_reusable_ui_elements().get_node("enemy_direction_sprite").duplicate()
            move_container.get_node("margin/scroll/hbox").add_child(move_disp)
            move_disp.g = game_controller.get_globals()
            move_disp.position.x = line_count * globals.block_width
            move_disp.set_state(move)
            move_disp.change_state_region()
            line_count += 1
        enemy_move_display.add_child(move_container)
        row_count += 1

func highlight_enemy_move(entity_num):
    for container in enemy_move_containers:
        if container.entity_num == entity_num:
            container.select()
        else:
            container.deselect()

func reposition_player_entities_in_menu():
    var x_pos = 0
    var move_button = game_controller.get_reusable_ui_elements().get_node("direction_button")
    for entitie in player_entities:
        if not entitie.placed:
            entitie.position.x = x_pos
            x_pos += move_button.rect_size.x



func print_json():
    # Then parse all the enemies to a list:
    var enemie_datas = []
    enemie_datas.resize(enemies.size())
    for i in range(enemies.size()):
        enemie_datas[i] = parse_enemy_todict(enemies[i])

    var player_entitie_datas = []
    player_entitie_datas.resize(player_entities.size())
    for i in range(player_entities.size()):
        player_entitie_datas[i] = parse_player_entitie_todict(player_entities[i])
    
    # Prints the level as json string
    var level_data = { "level" : tiles, "width": width, "height": height, "turn_amount": turn_amount, \
            "enemies": enemie_datas, "player_entities": player_entitie_datas}
    var level_data_json = JSON.print(level_data)
    print(level_data_json)
    return level_data_json

func get_tile_node_at(x_pos : int, y_pos : int):
    return tile_nodes[x_pos][y_pos]

func strip_of_numbering(node_name):
    node_name = node_name.replace("@", "")
    for i in range(10):
        node_name = node_name.replace(str(i), "")
    return node_name

func parse_enemy_todict(enemie):
    # Generates a data dict for one enemy:
    var data = { "name": strip_of_numbering(enemie.name), "x": enemie.x, "y": enemie.y, "moves": enemie.move_queue }
    return data

func parse_player_entitie_todict(entitie):
    var data = { "name": strip_of_numbering(entitie.name) } # TODO For now just the name
    return data

func performe_move():
    for enemie in enemies:
        enemie.performe_move()

    for player_entity in player_entities:
        if player_entity.placed:
            player_entity.performe_move()

    # After all entities performed there move:
    var all_entities = []
    all_entities.resize((player_entities.size() + enemies.size()))
    var i = 0
    for e in enemies:
        all_entities[i] = e
        i += 1
    for e in player_entities:
        all_entities[i] = e
        i += 1

    print("Entity count: " + (all_entities.size() as String))

    # Remove not placed entities:
    var remove_marked = []
    for j in range(all_entities.size()):
        if not all_entities[j].placed:
            remove_marked.push_front(j)


    for e in remove_marked:
        all_entities.remove(e)

    print("Entity count: " + (all_entities.size() as String))
    # Wait untill all animations finished
    i = 0
    for e in all_entities:
        if e.was_move_made:
            print("waiting on " + (i as String))
            # This is some fancy multithreading stuff, im pretty certain no deadlock can occur
            yield(e, "move_performed")
        i += 1

    game_controller.get_current_level().update()

    i = 0
    for entitie in all_entities:
        print(entitie.x as String)
        # Check if that entitie is in the same position with another
        for j in range(i + 1, all_entities.size()):
            if entitie.x == all_entities[j].x and entitie.y == all_entities[j].y:
                # They are at the same position
                # Let the fight
                print("Ey you on same position" + (i as String) + (j as String))
                game_controller.show_battle_menu()
                entitie.take_battle_position(true)
                all_entities[j].take_battle_position(false)
                yield(game_controller, "animation_finished")
                entitie.fight_against(all_entities[j], true)
                yield(entitie, "attack_finished")
                all_entities[j].fight_against(entitie, false)
                yield(all_entities[j], "attack_finished")
                entitie.process_after_fight()
                all_entities[j].process_after_fight()
                game_controller.hide_battle_menu()
                yield(game_controller, "animation_finished")
        i += 1
    print("moves performed")
    moves_performed += 1
    emit_signal("performed_moves")

func draw_move_connection_indicators():
    # Simply Draws a line between entities and moves:
    # TODO: Save these postions to now constantly go through all nodes!!!!!
    var enemy_move_display = get_tree().get_current_scene().get_node("enemy_move_display/margin/scroll/vbox")
    var container = enemy_move_display.get_node("../../../")
    var offset = globals.block_width / 2
    print("updating")
    for e in enemies:
        var move_disp = enemy_move_display.get_children()[e.entity_num]
        draw_line(Vector2( e.position.x + offset, e.position.y + offset ), \
			Vector2( container.position.x + move_disp.position.x , container.position.y + move_disp.position.y ), Color.green)

func _draw():
    if not edit:
        draw_move_connection_indicators()


func remove_player_entity(entity):
    var num = entity.entity_num
    get_tree().get_current_scene().get_node("player_entiti_collection").remove_child(entity)
    player_entities.remove(num)
    # TODO: remove that enemies move display
    for i in range(num, player_entities.size()):
        player_entities[i].entity_num -= 1
    print(player_entities.size() as String)

func add_tile_by_id_if_not_present(x_pos, y_pos, id):
    if tiles[x_pos][y_pos] != id:
        tiles[x_pos][y_pos] = id
        tile_nodes[x_pos][y_pos] = game_controller.get_tile_by_id(id)
        get_tree().get_current_scene().get_node("grid").add_child(tile_nodes[x_pos][y_pos])
        tile_nodes[x_pos][y_pos].position.x = x_pos * globals.block_width
        tile_nodes[x_pos][y_pos].position.y = y_pos * globals.block_width
        print("added tile")

func remove_enemy(entity):
    var num = entity.entity_num
    get_tree().get_current_scene().get_node("enemy_container").remove_child(entity)
    enemies.remove(num)
    # TODO: remove that enemies move display
    for i in range(num, enemies.size()):
        enemies[i].entity_num -= 1
    print(enemies.size() as String)
    var moves_perfored : int = 0

func no_moves_left():
    return (turn_amount == moves_performed)

func has_player_won():
    return enemies.size() == 0
