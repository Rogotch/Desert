extends Spatial

onready var GridClass = preload("res://Resources/Entities/3D/Grid.tscn")

export var GridYValue : float
export var Zones = [
	{ZoneName = "Zone1", ZoneId = 0, StartPos = Vector2(0, 0),  EndPos = Vector2(3,5),  interzone = false},
	{ZoneName = "Interzone1", ZoneId = 1, StartPos = Vector2(4, 0),  EndPos = Vector2(4,5),  interzone = true},
	{ZoneName = "Zone3", ZoneId = 2, StartPos = Vector2(5, 0),  EndPos = Vector2(8,5),  interzone = false},
	{ZoneName = "Interzone2", ZoneId = 3, StartPos = Vector2(9, 0),  EndPos = Vector2(9,5),  interzone = true},
	{ZoneName = "Zone5", ZoneId = 4, StartPos = Vector2(10, 0), EndPos = Vector2(13,5), interzone = false},
	]

export var GridsPath            : NodePath
export var GridMapPath          : NodePath
export var CharactersNodePath   : NodePath

onready var gridMap          = get_node(GridMapPath)
onready var Grids            = get_node(GridsPath)
onready var CharactersNode   = get_node(CharactersNodePath)

var Grid = []

func _ready():
	SetVisualGrids()
	SetCharacters()
	pass # Replace with function body.

#Устанавливает персонажей в список системы боя и начинает ход
func SetCharacters():
	FightSystem.TurnsQueue.append_array(CharactersNode.get_children())
	FightSystem.StartTurn()
	FightSystem.PlayerTurn = true
	pass

#Возвращает ID зоны по координатам
func GetActualZoneId(objPos):
	for zone in Zones:
		if (zone.StartPos.x <= objPos.x &&
			zone.StartPos.y <= objPos.y &&
			zone.EndPos.x > objPos.x &&
			zone.EndPos.y > objPos.y):
				return zone.ZoneId
	return null
	pass

#Определяет, принадлежит ли объект зоне
func BelongingToZone(objPos, zonId):
	var selectedZone = GetZoneByID(zonId)
	return  (selectedZone.StartPos.x <= objPos.x &&
			 selectedZone.StartPos.y <= objPos.y &&
			 selectedZone.EndPos.x > objPos.x &&
			 selectedZone.EndPos.y > objPos.y)
	pass

#Даёт зону по её ID
func GetZoneByID(id):
	for zone in Zones:
		if zone.ZoneId == id:
			return zone
	pass

#Устанавливает визуальное отображение сетки
func SetVisualGrids():
	var count = 0
#	var MinPos = Vector2(0,0)
	var MaxPos = Vector2(0,0)
	for zone in Zones:
		if zone.interzone:
			continue
#		MinPos.x = (MinPos.x if zone.StartPos.x >= MinPos.x else zone.StartPos.x)
#		MinPos.y = (MinPos.y if zone.StartPos.y >= MinPos.y else zone.StartPos.y)
		MaxPos.x = (MaxPos.x if zone.EndPos.x <= MaxPos.x else zone.EndPos.x)
		MaxPos.y = (MaxPos.y if zone.EndPos.y <= MaxPos.y else zone.EndPos.y)
		var newGrid = GridClass.instance()
		Grids.add_child(newGrid)
		var CellsNum = zone.EndPos - zone.StartPos
#		print(str($Environment/GridVisualizers/Line.get_active_material(0).set_shader_param("Offset", Vector2((0 if CellsNum.x % 2 == 0 else 5), (0 if CellsNum.y % 2 == 0 else 5)))))
		newGrid.get_active_material(0).set_shader_param("Offset", Vector2((0 if int(CellsNum.x) % 2 == 0 else 5), (0 if int(CellsNum.y) % 2 == 0 else 5)))
		newGrid.transform.origin = Vector3(CellsNum.x * 10/2 + zone.StartPos.x * 10, GridYValue, CellsNum.y * 10/2 + zone.StartPos.y * 10)
		var newMesh = CubeMesh.new()
		newMesh.size = Vector3(CellsNum.x * 10, 0.01, CellsNum.y * 10)
		newGrid.mesh = newMesh
		count += 1
#	AutofilGridMap(MaxPos)
	pass

#Устанавливает выбранной зоне цвет и модификатор альфа-канала
func SetZoneColorAndAlfaMod(ZoneId, ZoneColor = null, AMod = 1.0):
	var zone = GetZoneByID(ZoneId)
	if ZoneColor:
		zone.get_active_material(0).set_shader_param("color2", ZoneColor)
	zone.get_active_material(0).set_shader_param("AlfaMult", AMod)
	pass

#Заполняет GridMap тайлами, чтобы позже можно было использовать Get_used_cells()
#Или проходится по ней, занося все клетки в 
func AutofilGridMap(EndPosition):
#	print("EndPosition - " + str(EndPosition))
	for i in (EndPosition.x):
		var line = []
		for j in EndPosition.y:
			var point = Vector2(i,j)
			line.append(point)
		Grid.append(line)
#			print(str(Vector2(i,j)))
#			gridMap.set_cell_item(i, 0, j, 0)
#			pass
	pass


