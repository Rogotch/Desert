extends KinematicBody

class_name Character


export var PlayerTeam      : bool
export var physic_speed    : float
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

#Блок Характеристик
var Speed        = MaxMovement
var Multitasking = MaxActionPoints
#var Constitution

var Health 

var ZonePosition setget _SetCharacterPosition
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
	Movement = 0
	Speed        = MaxMovement
	Multitasking = MaxActionPoints
	yield(get_tree(), "idle_frame")
	var V3Pos = Grid.world_to_map(transform.origin)
	ZonePosition = Vector2(V3Pos.x, V3Pos.z)
	_SetCharacterPosition(ZonePosition)
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
	if path.size() > 0 && (Movement + Speed * ActionPoints > 0 || freeMovement):
		Moving = true
		velocity = transform.origin.direction_to(path[0]) * physic_speed
		if transform.origin.distance_to(path[0]) > 0.5:
			velocity = move_and_slide(velocity, Vector3.UP)
		else:
			var V3Pos = Grid.world_to_map(transform.origin)
			var newpos = Vector2(V3Pos.x, V3Pos.z)
			_SetCharacterPosition(newpos)
			transform.origin = path[0]
			Arena.Grid[ZonePosition.x][ZonePosition.y].OnCellMove(self)
			path.remove(0)
		if path.size() == 0:
			Moving = false
#			Arena.CreatePathZone(self)
			printt(str(target), str(Movement), str(ActionPoints))
			if target != null:
				DoSomething()
			elif Movement == 0 && ActionPoints == 0:
				FightSystem.EndTurn()
			else:
				Arena.CreatePathZone(self)
#			print("Movement - " + str(movement))
		else:
			SignalsScript.emit_signal("LeftThePosition", self, ZonePosition)
		pass
#			move_and_slide(move_vec.normalized() * speed, Vector3.UP)
	pass

#Смена принадлежности клетки
func _SetCharacterPosition(newPosition):
	Arena.Grid[ZonePosition.x][ZonePosition.y].content   = GridPoint.EMPTY
	Arena.Grid[ZonePosition.x][ZonePosition.y].character = null
	ZonePosition = newPosition
	Arena.Grid[ZonePosition.x][ZonePosition.y].content   = GridPoint.CHARACTER
	Arena.Grid[ZonePosition.x][ZonePosition.y].character = self
	
	SignalsScript.emit_signal("CameOnPosition", self, ZonePosition)
	if !Arena.Grid[ZonePosition.x][ZonePosition.y].interzone && ZoneId != Arena.Grid[ZonePosition.x][ZonePosition.y].zoneID:
		ZoneId = Arena.Grid[ZonePosition.x][ZonePosition.y].zoneID
		SignalsScript.emit_signal("CameOnZone", self, ZoneId)
	if Arena.Grid[ZonePosition.x][ZonePosition.y].interzone:
		SignalsScript.emit_signal("LeftTheZone", self, ZoneId)
		pass
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
	print("ZoneID - " + str(ZoneId))
	SignalsScript.emit_signal("StartTurnOnPosition", self, ZonePosition)
	SignalsScript.emit_signal("StartTurnOnZone", self, ZoneId)
	Selecter.visible = true
	Movement = 0
	ZonePoints = ZoneCross
	ActionPoints = Multitasking
	Arena.CreatePathZone(self)
	pass

func EndTurn():
	SignalsScript.emit_signal("EndTurnOnPosition", self, ZonePosition)
	SignalsScript.emit_signal("EndTurnOnZone", self, ZoneId)
	Selecter.visible = false
	Arena.ClearPathZone()
	pass

func SetPath(newPath):
	print("Setter work!")
	if target != null && Arena.InDistanceCheck(ZonePosition, AttackDistance, target):
		print("In distance without movement")
		DoSomething()
	elif newPath.size() == 0:
		if target != null:
			DoSomething()
	elif newPath.size() > 0:
		path = newPath
	pass

# Атака или другие действия. Срабатывает всегда, когда target != null 
func DoSomething():
	print("Somethimg!")
	if Arena.InDistanceCheck(ZonePosition, AttackDistance, target) && ActionPoints > 0:
		ActionPoints -= 1
		SignalsScript.emit_signal("Attack", self, Arena.Grid[target.x][target.y].character)
		print("In AttackDistance")
	target = null
	if ActionPoints == 0 && Movement == 0:
		FightSystem.EndTurn()
	else:
		Arena.CreatePathZone(self)
	pass

func TakeDamage(DamgeValue):
	SignalsScript.emit_signal("TakingDamage", self)
	Health -= DamgeValue
	pass

# Как персонаж будет вести себя при проходе через диагональные клетки, если в них кто-то есть
func CheckDiagonalPosition(pos, direction):
	# Если это проход прямо, а не диагонально или оба угла пусты
	return (abs(direction.x) + abs(direction.y) == 1 ||
	(Arena.Grid[pos.x][pos.y + direction.y].content == GridPoint.EMPTY &&
	 Arena.Grid[pos.x + direction.x][pos.y].content == GridPoint.EMPTY))
#	return true
	pass
