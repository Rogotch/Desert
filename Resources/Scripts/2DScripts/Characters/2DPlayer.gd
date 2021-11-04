extends KinematicBody2D

var direction = Vector2()
var gridPosition = Vector2()

#const MAX_SPEED = 400

var speed = 300
var velocity = Vector2()

var world_target_pos = Vector2()
var target_direction = Vector2()
var is_moving = false
var Trace = []

var type
var grid


func _ready():
	grid = get_parent()
	type = grid.PLAYER

func GoToCell():
	pass

func _physics_process(delta):
	if Trace.size() != 0:
		velocity = position.direction_to(Trace[0]) * speed
		if position.distance_to(Trace[0]) > 5:
			velocity = move_and_slide(velocity)
			grid.grid[gridPosition.x][gridPosition.y] = null
			gridPosition = grid.world_to_map(Trace[0])
			grid.grid[grid.world_to_map(Trace[0]).x][grid.world_to_map(Trace[0]).y] = grid.PLAYER
		else:
			position = Trace[0]
			Trace.remove(0)
	pass

