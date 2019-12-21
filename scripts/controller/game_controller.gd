extends Node
# is the main data flow point of the game

var level_queue = []

var enemies = preload("res://scenes/enemies.tscn").instance()

func _ready():
	print("initialized game controller")
