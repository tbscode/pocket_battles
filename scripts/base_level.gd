extends Node

var tiles = [0] 
var width : int
var height : int

var enemies = [] # List of enemies
var player_entities = [] # Holds the Players Tiles.
var enemy_data # Hold all the enemies after init, before thy are added to the scene
var player_entitie_data

var globals = preload("res://globals.gd")

var turn_amount # every level has a locked amount of turns

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

func add_player_entities_from_data():
    player_entities.resize(player_entitie_data.size())
    for i in range(player_entities.size()):
        print(player_entitie_data[i])
        var name = player_entitie_data[i]["name"]
        player_entities[i] = get_player_node_byname(game_controller.player_entities, name)
        player_entities[i].init(name)

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

    var x_pos = 0
    var y_pos = 0
    print("root" + get_tree().get_current_scene().find_node("menu_container").get_path())
    var player_entitie_container = scene.find_node("menu_container")
    
    for entitie in player_entities:
        player_entitie_container.add_child(entitie)
        entitie.position.x = x_pos
        entitie.position.y = y_pos
        x_pos += globals.block_width
        # TODO: add line break logic

    # Add the Move buttons to the player_move_menu
    # Fist load the external Button
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

    add_enemy_moves_to_listing()

func add_enemy_moves_to_listing():
    # Adds all the enemy move desriptions to the listing
    var enemy_move_display = get_tree().get_current_scene().get_node("enemy_move_display/margin/scroll/vbox")
    var row_count = 0
    for enemy in enemies:
        var move_container = game_controller.get_reusable_ui_elements().get_node("enemy_move_container").duplicate()
        move_container.position.y = row_count * move_container.get_node("margin").rect_size.y
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
    player_entitie_datas.resize(enemies.size())
    for i in range(player_entities.size()):
        player_entitie_datas[i] = parse_player_entitie_todict(player_entities[i])
    
    # Prints the level as json string
    var level_data = { "level" : tiles, "width": width, "height": height, "turn_amount": turn_amount, \
            "enemies": enemie_datas, "player_entities": player_entitie_datas}
    var level_data_json = JSON.print(level_data)
    print(level_data_json)

func parse_enemy_todict(enemie):
    # Generates a data dict for one enemy:
    var data = { "name": enemie.name, "x": enemie.x, "y": enemie.y, "moves": enemie.move_queue }
    return data

func parse_player_entitie_todict(entitie):
    var data = { "name": entitie.name } # TODO For now just the name
    return data

func performe_move():
    for enemie in enemies:
        enemie.performe_move()

    for player_entity in player_entities:
        if player_entity.placed:
            player_entity.performe_move()
