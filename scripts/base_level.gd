extends Node

var tiles = [0] 
var width = 0
var height = 0

var enemies = [] # List of enemies
var enemy_data # Hold all the enemies after init, before thy are added to the scene

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
    print("Enemies" + ( enemy_data as String) )

func add_enemies_from_data():
    enemies.resize(enemy_data.size())
    for i in range(enemy_data.size()):
        print(enemy_data[i])
        var name = enemy_data[i]["name"]
        var x = enemy_data[i]["x"]
        var y = enemy_data[i]["y"]
        print("Some of the data" + name )
        enemies[i] = get_enemy_node_byname(game_controller.enemies, name)
        enemies[i].init(x, y, self.name)

func get_enemy_node_byname(enemy_nodes, name):
    # load the enmy sceen add it to the tree
    var node = enemy_nodes.find_node(name).duplicate()
    print(node)
    return node

func add_enemies(enemie_nodes):
    var rook = enemie_nodes.find_node("rook").duplicate()
    rook.init(2, 1, "rook")
    enemies.push_back(rook)

func _ready():
    pass # Replace with function body.

func build_level(tree):
    # We here assume the level was added to the scene tree
    # Todo add the tiles
    # Todo put elsewhere
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
    
    # Prints the level as json string
    var level_data = { "level" : tiles, "width": width, "height": height, \
            "enemies": enemie_datas}
    var level_data_json = JSON.print(level_data)
    print(level_data_json)

func parse_enemy_todict(enemie):
    # Generates a data dict for one enemy:
    var data = { "name": enemie.name, "x": enemie.x, "y": enemie.y }
    return data
