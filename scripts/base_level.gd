extends Node

var tiles = [0] 
var width = 0
var height = 0

var enemies = [] # List of enemies
var player_entities = [] # Holds the Players Tiles.
var enemy_data # Hold all the enemies after init, before thy are added to the scene
var player_entitie_data

func init(width, height):
    tiles.resize(width)
    for i in range(tiles.size()):
        tiles[i] = [0]
        tiles[i].resize(height)
        for j in range(tiles[i].size()):
            tiles[i][j] = 0
    var base_enemy = load("res://scripts/base_enemy.gd")
    # Todo remove, just for testing

func init_from_string(level_string):
    # Loads the level, from the level string created with print_json
    var data = JSON.parse(level_string).get_result()
    print(data)
    width = (data["width"] as int)
    height = (data["height"] as int)
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

func get_enemy_node_byname(enemy_nodes, name):
    # load the enmy sceen add it to the tree
    var node = enemy_nodes.find_node(name).duplicate()
    print(node)
    return node

func add_enemies(enemie_nodes):
    var rook = enemie_nodes.find_node("rook").duplicate()
    rook.init(2, 1, "rook")
    enemies.push_back(rook)

func build_level(tree):
    # We here assume the level was added to the scene tree
    # TODO add the tiles
    # TODO` put elsewhere
    for e in enemies:
        print(e)
        tree.get_root().add_child(e)
        e.position_on_map()
        print("added enemy")

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
    var level_data = { "level" : tiles, "width": width, "height": height, \
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
