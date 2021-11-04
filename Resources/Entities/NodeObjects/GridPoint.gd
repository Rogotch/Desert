extends Node

class_name GridPoint, "res://Resources/Images/GUI/SimpleIcons/White/1x/target.png"

enum {EMPTY = 0, PLAYER = 1, OBSTACLE = 2}

var inPath = false
var step = 0
var content = EMPTY

func _ready():
	add_to_group("GridPoints")
	pass

func ClearPoint():
	step = 0
	pass
