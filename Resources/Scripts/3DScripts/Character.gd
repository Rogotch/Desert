extends KinematicBody

class_name Character

export var speed           : float
export var MaxMovement     : int
export var ZoneCross       : int
export var MaxActionPoints : int
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
#var Trace = []
var startY

var Moving = false
var freeMovement = false

export var AttackDistance : int
var Movement
var ZonePoints
var ActionPoints

var path = [] setget SetPath
#var path_ind = 0

#var ActivePointID = null

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Units")
	Movement = MaxMovement
	yield(get_tree(), "idle_frame")
	var V3Pos = Grid.world_to_map(transform.origin)
	ZonePosition = Vector2(V3Pos.x, V3Pos.z)
	_SetCharacterPosition()
#	Arena.Grid[ZonePosition.x][ZonePosition.y].content = GridPoint.PLAYER
	ZoneId = Arena.GetActualZoneId(ZonePosition)
	transform.origin = Grid.map_to_world(ZonePosition.x, 0, ZonePosition.y)
	print("ZoneId - " + str(ZoneId))
#	print(str((Grid.world_to_map(transform.origin))))
#	var newPosition = Grid.world_to_map(transform.origin) * Grid.cell_size + Grid.cell_size/2
#	newPosition.y = transform.origin.y
#	transform.origin = newPosition
	pass # Replace with function body.

func _physics_process(_delta):
	if path.size() > 0 && (Movement > 0 || freeMovement):
		Moving = true
		velocity = transform.origin.direction_to(path[0]) * speed
		if transform.origin.distance_to(path[0]) > 0.5:
			velocity = move_and_slide(velocity, Vector3.UP)
		else:
			_SetCharacterPosition()
			transform.origin = path[0]
			Arena.Grid[ZonePosition.x][ZonePosition.y].OnCellMove(self)
			path.remove(0)
		if path.size() == 0:
			Moving = false
			Arena.CreatePathZone(self)
			printt(str(target), str(Movement), str(ActionPoints))
			if target != null:
				DoSomething()
			elif Movement == 0 && ActionPoints == 0:
				FightSystem.EndTurn()
#			print("Movement - " + str(movement))
		pass
#			move_and_slide(move_vec.normalized() * speed, Vector3.UP)
	pass

func _SetCharacterPosition():
#Смена принадлежности клетки
	Arena.Grid[ZonePosition.x][ZonePosition.y].content = GridPoint.EMPTY
	var V3Pos = Grid.world_to_map(transform.origin)
	ZonePosition = Vector2(V3Pos.x, V3Pos.z)
	Arena.Grid[ZonePosition.x][ZonePosition.y].content = GridPoint.CHARACTER
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
		im.add_vertex(path_array[(path_array.size() - 1 if path_array.size() - 1 < Movement else Movement)])
		im.end()
		im.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
		var count = 0
	#	var endPath = (path_array.size() -1 if path_array.size() -1 < movement else path_array.size() -1 - movement)
	#	print(str(endPath))
		for x in path_array:
	#		if count < movement:
	#			break
	#		if count < path_ind -1:
			if count >= Movement:
				break
			count += 1
	#			continue
			im.add_vertex(x)
	im.end()
	pass

func StartTurn():
	Selecter.visible = true
	Movement = MaxMovement
	ZonePoints = ZoneCross
	ActionPoints = MaxActionPoints
	Arena.CreatePathZone(self)
	pass

func EndTurn():
	Selecter.visible = false
	Arena.ClearPathZone()
	pass

func SetPath(newPath):
	print("Setter work!")
	if target != null && Arena.InDistanceCheck(self, AttackDistance, target):
		print("In distance without movement")
		DoSomething()
	elif newPath.size() == 0:
		if target != null:
			DoSomething()
	elif newPath.size() > 0:
		path = newPath
	pass

func DoSomething():
	print("Somethimg!")
	if Arena.InDistanceCheck(self, AttackDistance, target) && ActionPoints > 0:
		ActionPoints -= 1
		print("In AttackDistance")
	target = null
	if ActionPoints == 0 && Movement == 0:
		FightSystem.EndTurn()
	else:
		Arena.CreatePathZone(self)
	pass
