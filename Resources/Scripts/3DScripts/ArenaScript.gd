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
var GridSize
const RoundDirections = [
	Vector2( 1, 0),
	Vector2( 0, 1),
	Vector2(-1, 0),
	Vector2( 0,-1),
	Vector2( 1, 1),
	Vector2(-1, 1),
	Vector2( 1,-1),
	Vector2(-1,-1),]

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

#Даёт зону по позиции объекта в ней
func GetZoneByPosition(objPos):
	for zone in Zones:
		if (zone.StartPos.x <= objPos.x &&
			zone.StartPos.y <= objPos.y &&
			zone.EndPos.x > objPos.x &&
			zone.EndPos.y > objPos.y):
				return zone
	return null
	pass

#Устанавливает визуальное отображение сетки
func SetVisualGrids():
	var count = 0
#	var MinPos = Vector2(0,0)
	var MaxPos = Vector2(0,0)
#	print(str(Zones))
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
	print("MaxPos - " + str(MaxPos))
	GridSize = MaxPos
	AutofilGridMap(MaxPos)
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
			var NewPoint = GridPoint.new()
			var pointZone = GetZoneByPosition(Vector2(i,j))
			NewPoint.zoneID = pointZone.ZoneId
			NewPoint.interZonePoint = pointZone.interzone
			line.append(NewPoint)
		Grid.append(line)
	pass

#Волнами сканируем поле и ищем короткий путь
func WaveFindPath(startPos, finPos):
	Grid[startPos.x][startPos.y].step = 0
	var newGrid = Grid.duplicate(true)
	var ScanningNodes = [startPos]
	for node in ScanningNodes:
		if node == finPos:
			print("Дошли до обратной постройки пути!")
#			break
			return SetTrace(finPos, newGrid)
		else:
			for dir in RoundDirections:
				if isCellCheck(node, dir, newGrid):
					ScanningNodes.append(node + dir)
	var startString = "Startpos - %s, Endpos - %s"
	var actualstring = startString % [str(startPos), str(finPos)]
	print(actualstring)
#	print(str(Grid))
	PrintGrid(finPos)
	print("Путь не был найден")
	return []
	pass

func PrintGrid(finPos):
	for i in Grid.size():
		var Line = ""
		for j in Grid[0].size():
#			print()
			if Vector2(i,j) == finPos:
				Line += ("  <!>")
			elif Grid[i][j].step == null:
				Line += "     "
			else:
				Line += ("%5d" % Grid[i][j].step)
		print(str(Line))
	pass

#Проверяем, доступна ли нам соседняя ячейка по направлению dir ячейка и если да, то увеличиваем её вес на 1
func isCellCheck(pos, direction, gridArr):
#	Проверка соседней клетки pos по направлению direction
	var gridPos = (pos) + direction
#	Проверка, находится ли точка в рамках сетки
	if InGridCheck(pos, direction):
#		Проверка, что точка свободна для передвижения
		if  gridArr[gridPos.x][gridPos.y].content == GridPoint.EMPTY && gridArr[gridPos.x][gridPos.y].step == null:
#			print(str(gridArr[pos.x][pos.y]))
			var step = 0
#			Проверка, что предыдущая точка не занята игроком и определение её шага
			if  gridArr[pos.x][pos.y].step != null:
				step = gridArr[pos.x][pos.y].step
#			Увеличение шага текущей точки на 1 по сравнению с прошлой
			gridArr[gridPos.x][gridPos.y].step = step + 1
			return true
	return false
	pass

#Строим путь обратно от финальной ячейки по полю
func SetTrace(finPos, gridArr):
	var newTrace = [finPos]
	var stepNum = gridArr[finPos.x][finPos.y].step
	while stepNum != 1:
#		Перебираем окружающие ячейки
		for dir in RoundDirections:
#			Берём одну из ближайших ячеек, относительно нашей сдвинутой на dir
			var NextPoint = NextStep(newTrace[-1], gridArr, dir)
#			Проверяем, что её вес меньше веса текущей ячейки
			if gridArr[NextPoint.x][NextPoint.y].step < stepNum:
#				Если да, уменьшаем текущий вес ячейки, добавляем выбранную ячейку в массив пути и выходим из цикла перебора окружающих ячеек
				stepNum = gridArr[NextPoint.x][NextPoint.y].step
				newTrace.append(NextPoint)
				break
	print("Trace - " + str(newTrace))
	ClearPoints()
#	get_tree().call_group("GridPoints", "ClearPoint")
	return newTrace
	pass

func ClearPoints():
	for i in Grid.size():
		for j in Grid[0].size():
			Grid[i][j].ClearPoint()
	pass

#Проверяем, что следующая, по направлению dir, ячейка весит меньше текущей
#Если да, возвращаем положение этой новой ячейки, иначе возвращаем старое значение
func NextStep(pos, nGrid, dir):
	if (InGridCheck(pos, dir) &&
			nGrid[pos.x + dir.x][pos.y + dir.y].step != null &&
			nGrid[pos.x + dir.x][pos.y + dir.y].step < nGrid[pos.x][pos.y].step):
		return     Vector2(pos.x + dir.x, pos.y + dir.y)
	else:
		return     Vector2(pos.x, pos.y)
	pass

#Проверяем, что ячейка находится внутри сетки
func InGridCheck(pos, direction):
	var gridPos = (pos) + direction
#	print("GridSize - "+ str(GridSize))
	if gridPos.x < GridSize.x && gridPos.x >= 0:
		if gridPos.y < GridSize.y && gridPos.y >= 0:
			return true
	return false
	pass

func CheckTrace(_Character, endPos):
	var trace = WaveFindPath(_Character.ZonePosition, endPos)
	trace.invert()
	var newTrace = []
	var Cost = {movement = 0, zonePoints = 0}
	for tracePosition in trace:
		if Grid[tracePosition.x][tracePosition.y].CheckMovement(_Character, Cost):
			print("Один есть!")
			newTrace.append(tracePosition)
		else:
			break
	print("StartTrace - " + str(trace))
	print("FinalTrace - " + str(newTrace))
	print("Cost - " + str(Cost))
	print("GlobalPath - " + str(SetGlobalPath(newTrace)))
	return {path = newTrace, cost = Cost}
#	_Character.ZoneId
#	_Character.movement
#	_Character.zonePoints
	
#	var cost = {movement = 0, zonePoints = 0}
	pass

func SetGlobalPath(mapPath):
	var finalPath = []
	for point in mapPath:
		var pathPoint = gridMap.map_to_world(point.x, 0, point.y)
		finalPath.append(pathPoint)
	return finalPath
	pass


#Переворачиваем массив и заполняем его мировыми координатами
#func SetPath(trace):
#	trace.invert()
#	var finalPath = []
#	for point in trace:
#		finalPath.append(map_to_world(point) + half_tile_size)
#	return finalPath
#	pass
