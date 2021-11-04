extends KinematicBody

class_name Character

export var speed : float
export var MaxMovement : int
export var ZoneCross : int
#export var gravity : float

export var GridPath            : NodePath
export var SelecterPath        : NodePath
#export var CameraPath          : NodePath
export var MarkerPath          : NodePath
export var DrawPath            : NodePath
export var ArenaMainNodePath   : NodePath

onready var Marker        = get_node(MarkerPath)
onready var Selecter      = get_node(SelecterPath)
#onready var CharCamera    = get_node(CameraPath)
onready var Grid          = get_node(GridPath)
onready var Draw          = get_node(DrawPath)
onready var Arena         = get_node(ArenaMainNodePath)
#onready var PlayerCamera = $Camera

#var Trace = []
#var rayOrigin = Vector3()
#var rayEnd = Vector3()

var HitPoints

var ZonePosition = Vector2()
var ZoneId
var velocity = Vector3.ZERO
var target = null
var Trace = []
var startY

var movement
var zonePoints

var path = []
var path_ind = 0

var ActivePointID = null

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Units")
	movement = MaxMovement
#	var V3Pos = Grid.world_to_map(transform.origin)
#	ZonePosition = Vector2(V3Pos.x, V3Pos.z)
	ZoneId = Arena.GetActualZoneId(ZonePosition)
	print("ZoneId - " + str(ZoneId))
#	print(str((Grid.world_to_map(transform.origin))))
#	var newPosition = Grid.world_to_map(transform.origin) * Grid.cell_size + Grid.cell_size/2
#	newPosition.y = transform.origin.y
#	transform.origin = newPosition
	pass # Replace with function body.

func _physics_process(delta):
	if path_ind < path.size() && movement > 0:
#		if path.size() != 0:
#			draw_path(path)
		if path_ind != 0:
			target = path[path_ind]
		if target:
			target.y = transform.origin.y
			if target != transform.origin:
				look_at(target, Vector3.UP)
		var move_vec = (path[path_ind] - global_transform.origin)
		if move_vec.length() < 0.5:
			print("movement - " + str(movement))
			path_ind += 1
			movement -= 1
#			draw_path(path)
			if ActivePointID != null:
				Arena.astar.set_point_disabled(ActivePointID, false)
			ActivePointID = Arena.astar.get_closest_point(path[path_ind-1])
			Arena.astar.set_point_disabled(ActivePointID, true)
			if movement == 0:
				path = []
				print("EndMovement!")
				Marker.visible = false
			if path_ind == path.size():
				print("EndPath!")
				Marker.visible = false
		else:
			move_and_slide(move_vec.normalized() * speed, Vector3.UP)
	pass

func move_to(target_pos):
#	print("target_pos? - " + str(target_pos))
	path = Arena._get_path(global_transform.origin, target_pos)
#	print("path - " + str(path))
	path_ind = 0
pass

func draw_path(target_pos):
	var path_array = Arena._get_path(global_transform.origin, target_pos)
	var m = SpatialMaterial.new()
	var im = Draw
	im.set_material_override(m)
	im.clear()
	im.begin(Mesh.PRIMITIVE_POINTS, null)
#	for pathPoint in path_array:
#		im.add_vertex(pathPoint)
	if path_array.size() > 0:
		im.add_vertex(path_array[0])
		im.add_vertex(path_array[(path_array.size() - 1 if path_array.size() - 1 < movement else movement)])
		im.end()
		im.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
		var count = 0
	#	var endPath = (path_array.size() -1 if path_array.size() -1 < movement else path_array.size() -1 - movement)
	#	print(str(endPath))
		for x in path_array:
	#		if count < movement:
	#			break
	#		if count < path_ind -1:
			if count >= movement:
				break
			count += 1
	#			continue
			im.add_vertex(x)
	im.end()
	pass

func StartTurn():
	Selecter.visible = true
	movement = MaxMovement
	zonePoints = ZoneCross
	pass

func EndTurn():
	Selecter.visible = false
	pass