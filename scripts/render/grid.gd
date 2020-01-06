tool

extends Node2D

var width = 7
var height = 9

export var x = 0
export var y = 0

var viewportsize

var globals = preload("res://globals.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	# For desktop we have to get the screen coodrinates from the settings
	viewportsize = Vector2(ProjectSettings.get_setting("display/window/size/width"), \
							ProjectSettings.get_setting("display/window/size/height"))
	center()
	print(viewportsize)
	print("correct indent")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()
	
func center():
	# Simply centers the gird on the screen after creation
	position.x = viewportsize.x / 2 - width * globals.block_width * 0.5
	position.y = viewportsize.y / 2 - height * globals.block_width * 0.5
	print((position.x as String)+ " was " + (position.y as String))

func _draw():
	for i in range(height + 1):
		draw_line(Vector2( x, y + i * globals.block_width), \
		Vector2( x + width * globals.block_width, y + i * globals.block_width), Color.red)
		
	for i in range(width + 1):
		draw_line(Vector2( x + i * globals.block_width, y), \
		Vector2( x + i * globals.block_width, y + height * globals.block_width), Color.red)

func get_actual_width():
    return width * globals.block_width

func get_actual_height():
    return height * globals.block_width

