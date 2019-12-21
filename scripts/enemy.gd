# A simple script all enemy sprites will extend
extends "res://scripts/base_enemy.gd"

var move_stack = []
var start_pos = [0, 0]

var globals = preload("res://globals.gd")


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
