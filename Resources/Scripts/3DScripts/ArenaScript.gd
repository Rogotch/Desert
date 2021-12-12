extends Spatial

onready var GridClass = preload("res://Resources/Entities/3D/Grid.tscn")
onready var tileClass = preload("res://Resources/Entities/3D/PathAreaTile.tscn")

export var GridYValue : float
export var ZonesParameters = [
	{ZoneName = "Zone1", ZoneId = 0, StartPos = Vector2(0, 0),  EndPos = Vector2(3,5),  interzone = false},
	{ZoneName = "Interzone1", ZoneId = 1, StartPos = Vector2(4, 0),  EndPos = Vector2(4,5),  interzone = true},
	{ZoneName = "Zone3", ZoneId = 2, StartPos = Vector2(5, 0),  EndPos = Vector2(8,5),  interzone = false},
	{ZoneName = "Interzone2", ZoneId = 3, StartPos = Vector2(9, 0),  EndPos = Vector2(9,5),  interzone = true},
	{ZoneName = "Zone5", ZoneId = 4, StartPos = Vector2(10, 0), EndPos = Vector2(13,5), interzone = false},
	]

export var GridsPath            : NodePath
export var _PathZone            : NodePath
export var GridMapPath          : NodePath
export var CharactersNodePath   : NodePath

onready var gridMap          = get_node(GridMapPath)
onready var PathZone         = get_node(_PathZone)
onready var Grids            = get_node(GridsPath)
onready var CharactersNode   = get_node(CharactersNodePath)

var Grid = []
var Zones = []
var GridSize
var GridStart

const RoundDirections = [
	Vector2( 1, 0),
	Vector2( 0, 1),
	Vector2(-1, 0),
	Vector2( 0,-1),
	Vector2( 1, 1),
	Vector2(-1, 1),
	Vector2( 1,-1),
	Vector2(-1,-1)]

const RectDirections = [
	Vector2( 1, 0),
	Vector2( 0, 1),
	Vector2(-1, 0),
	Vector2( 0,-1)]

func _ready():
	add_to_group("Arena")
	FightSystem.Arena = self
	
	SignalsScript.connect("CameOnZone",  self, "CheckZone")
	SignalsScript.connect("LeftTheZone", self, "CheckZone")
	SignalsScript.connect("UpdateZoneEffects", self, "UpdateAllZonesEffects")
	
	SetVisualGrids()
	SetCharacters()
	pass # Replace with function body.

func CheckZone(character, zoneID):
	yield(get_tree(), "idle_frame")
	GetZoneByID(zoneID).CheckSignal(character, zoneID)
	pass

#Устанавливает персонажей в список системы боя и начинает ход
func SetCharacters():
	FightSystem.TurnsQueue.append_array(CharactersNode.get_children())
	yield(get_tree(), "idle_frame")
	FightSystem.StartTurn()
	FightSystem.PlayerTurn = true
	for zone in Zones:
		zone.GetAllCharacters()
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

# 
func UpdateAllZonesEffects():
	for zone in Zones:
		if zone.Interzone:
			continue
		else:
			zone.UpdateZoneEffects()
	pass

#Устанавливает визуальное отображение сетки
func SetVisualGrids():
#	var count = 0
	var MinPos = Vector2(99,99)
	var MaxPos = Vector2(0,0)
#	print(str(Zones))
	for zone in ZonesParameters:
		var newZone = Zone.new()
		newZone.Arena = self
		newZone.AllZones = Zones
		newZone.ZoneParameters = zone
		Zones.append(newZone)
		if zone.interzone:
			continue
		MinPos.x = (MinPos.x if zone.StartPos.x >= MinPos.x else zone.StartPos.x)
		MinPos.y = (MinPos.y if zone.StartPos.y >= MinPos.y else zone.StartPos.y)
		MaxPos.x = (MaxPos.x if zone.EndPos.x <= MaxPos.x else zone.EndPos.x)
		MaxPos.y = (MaxPos.y if zone.EndPos.y <= MaxPos.y else zone.EndPos.y)
		var newGrid = GridClass.instance()
		newZone.VisualGrid = newGrid
		Grids.add_child(newGrid)
		var CellsNum = zone.EndPos - zone.StartPos
#		print(str($Environment/GridVisualizers/Line.get_active_material(0).set_shader_param("Offset", Vector2((0 if CellsNum.x % 2 == 0 else 5), (0 if CellsNum.y % 2 == 0 else 5)))))
		newGrid.AlfaMultiply = 0.5
#		newGrid.SetAlfaMultiplySmooth(2)
#		newGrid.GridColor = Color.yellow
#		newGrid.SetGridColorSmooth(Color.green)
		newGrid.Offset = Vector2((0 if int(CellsNum.x) % 2 == 0 else 5), (0 if int(CellsNum.y) % 2 == 0 else 5))
#		newGrid.get_active_material(0).set_shader_param("Offset", Vector2((0 if int(CellsNum.x) % 2 == 0 else 5), (0 if int(CellsNum.y) % 2 == 0 else 5)))
		newGrid.transform.origin = Vector3(CellsNum.x * 10/2 + zone.StartPos.x * 10, GridYValue, CellsNum.y * 10/2 + zone.StartPos.y * 10)
		var newMesh = CubeMesh.new()
		newMesh.size = Vector3(CellsNum.x * 10, 0.01, CellsNum.y * 10)
		newGrid.mesh = newMesh
#		count += 1
	print("MaxPos - " + str(MaxPos))
	print("Zones - " + str(Zones))
	GridSize = MaxPos
	GridStart = MinPos
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
			if pointZone:
				NewPoint.zoneID = pointZone.ZoneId
				NewPoint.interzone = pointZone.Interzone
			else:
				NewPoint.zoneID = null
				NewPoint.interzone = null
				NewPoint.content = NewPoint.OUTZONE
			line.append(NewPoint)
		Grid.append(line)
	pass

#Волнами сканируем поле и ищем короткий путь
func WaveFindPath(_character, finPos):
	var startPos = _character.ZonePosition
#	var BigTrace = []
	var actualZone = GetZoneByPosition(startPos)
	var ZonePoints = [{start = actualZone.StartPos, end = actualZone.EndPos}, {start = Vector2.ZERO, end = GridSize}]
	for zPoint in ZonePoints:
		Grid[startPos.x][startPos.y].step = 0
		var newGrid = Grid.duplicate(true)
		var ScanningNodes = [startPos]
		for node in ScanningNodes:
			if node == finPos:
				print("Дошли до обратной постройки пути!")
	#			break
				PrintGrid(finPos)
				return SetTrace(finPos, newGrid)
			else:
				var DirectionArr = (RectDirections if Grid[node.x][node.y].interzone else RoundDirections)
				for dir in DirectionArr:
					# Проверка, чтобы проход через междузонье был строго прямо
					if (InGridCheck(node, dir, zPoint.start, zPoint.end) && 
						(Grid[node.x][node.y].interzone && 
						 Grid[node.x + dir.x][node.y + dir.y].interzone ||
						 Grid[node.x + dir.x][node.y + dir.y].interzone &&
						abs(dir.x) + abs(dir.y) > 1)):
						continue
						# Проверка, что следующая точка является доступной для перемещения и находится в рамках зоны
					elif isCellCheck(node, dir, newGrid, zPoint.start, zPoint.end, _character):
						ScanningNodes.append(node + dir)
#		var startString = "Startpos - %s, Endpos - %s"
#		var actualstring = startString % [str(startPos), str(finPos)]
#		print(actualstring)
	#	print(str(Grid))
		PrintGrid(finPos)
		ClearPoints()
		print("Путь не был найден")
	return []
	pass

func SetZoneGrid(character):
	var cell = {movement = 0, actionPoints = 0, zonePoints = 0, interzoneDir = Vector2.ZERO}
	var startPos = character.ZonePosition
	var movValue = character.Speed * character.ActionPoints + character.Movement
	var zonValue = character.ZonePoints
	var ScanningNodes = {startPos : cell}
	var nodesKeys = ScanningNodes.keys()
	for node in nodesKeys:
		var DirectionArr = (RectDirections if Grid[node.x][node.y].interzone else RoundDirections)
		for dir in DirectionArr:
			# Проверка, чтобы значение находилось в рамках зоны
			if InGridCheck(node, dir, Vector2.ZERO, GridSize):
				# Проверка, чтобы в интерзону можно было входить и выходить только прямо, а не диагонально
				# Или проверка, чтобы нельзя было проходить диагонально при наличии боковых препятствий
				if((Grid[node.x][node.y].interzone && 
					 Grid[node.x + dir.x][node.y + dir.y].interzone ||
					 Grid[node.x + dir.x][node.y + dir.y].interzone &&
					 abs(dir.x) + abs(dir.y) > 1) || 
					(!character.CheckDiagonalPosition(node, dir))):
					continue
				else:
					var gridPos = node + dir
					# Если клетка пуста и её ещё нет в словаре сканированных клеток
					if Grid[gridPos.x][gridPos.y].content == GridPoint.EMPTY && !ScanningNodes.has(gridPos):
						# Поставь флаг, не интерзона ли это
						var flag = Grid[gridPos.x][gridPos.y].interzone
						# Если не интерзона, увеличь стоимость передвижения на 1
						var movementCost   = ScanningNodes[node].movement   + (0 if flag else 1)
						# Проверь стоимость в AP
						var actionsCost    = int(movementCost - character.Movement) / int(character.Speed)
#						prints("movementCost", "character.Movement", "character.Speed", "actionsCost", str(movementCost), str(character.Movement), str(character.Speed), str(actionsCost))
						# Если интерзона, увеличь стоимость очков зоны на 1
						var zonePointsCost = ScanningNodes[node].zonePoints + (1 if flag else 0)
						# Если интерзона, укажи направление прохода
						var interzoneDir   = (dir if flag else Vector2.ZERO)
						# Если стоимость укладывается в имеющиеся параметры персонажа, то добавь эту точку в словарь
						if movValue >= movementCost && zonValue >= zonePointsCost:
							# Проверка, чтобы в финальную область передвижения не попадали никуда не ведущие клетки междузония
							if !(flag && movValue == movementCost):
								ScanningNodes[gridPos] = {movement = movementCost, zonePoints = zonePointsCost, interzoneDir = interzoneDir, actionsCost = actionsCost}
								nodesKeys.append(gridPos)
						pass
					pass
				pass
			pass
		pass
#	CreateVisualGrid(ScanningNodes)
	return ScanningNodes
	pass

func CreateVisualGrid(dic):
	for i in Grid.size():
		var Line = ""
		for j in Grid[i].size():
			if dic.has(Vector2(i, j)):
				Line += "%5s" % (str(dic[Vector2(i, j)].movement) if !Grid[i][j].interzone else "!")
			else:
				Line += "%5s" % ""
				pass
		print(str(Line))
	pass

func CreatePathZone(character):
	var zone = SetZoneGrid(character)
	for tilepos in zone.keys():
		if !Grid[tilepos.x][tilepos.y].interzone && !zone[tilepos].movement == 0:
			var newTile = tileClass.instance()
			PathZone.add_child(newTile)
			newTile.transform.origin = gridMap.map_to_world(tilepos.x, 0, tilepos.y)
			newTile.set_meta("moveStep", zone[tilepos].movement)
		pass
	get_tree().call_group("PathTiles", "_appear")
	pass

func ClearPathZone():
	get_tree().call_group("PathTiles", "_quit")
#	for tile in PathZone.get_children():
#		tile.queue_free()
	pass

func CircleArea(startPos, radius):
	var directions = [
		Vector2( 1, 1), 
		Vector2(-1, 1), 
		Vector2( 1,-1), 
		Vector2(-1,-1),
	]
	var StartPoint = startPos
	var Octan = []
	var AllPoints = []
	# This defines how many tiles are roughly within the radius of the circle
	for i in radius+1:
		for j in radius+1:
			
			prints(i, j, radius, Vector2(i,j).length())
			if int(round(Vector2(i,j).length()))<= radius:
				Octan.append(Vector2(i,j))
#	for i in radius:
#		if i == 0:
#			Octan.append(Vector2(radius, 0))
#		else:
##			prints(pow(Octan[i-1].x, 2), 2 * Octan[i-1].y, pow(Octan[i-1].x, 2) - 2 * Octan[i-1].y - 1, sqrt(pow(Octan[i-1].x, 2) - 2 * Octan[i-1].y - 1))
##			var preX = ((pow(Octan[i-1].x, 2) - 2 * Octan[i-1].y - 1) * -1 if pow(Octan[i-1].x, 2) - 2 * Octan[i-1].y - 1 < 0 else pow(Octan[i-1].x, 2) - 2 * Octan[i-1].y - 1)
#			var y = i
#			var x = int(sqrt(pow(Octan[i-1].x, 2) - 2 * Octan[i-1].y - 1))
##			var y = int((pow(Octan[i-1].x, 2) - (pow(Octan[i-1].x, 2) - 2 * Octan[i-1].y - 1) - 1) / 2)
#			prints(i, x, y, (Vector2(x,y)))
#			Octan.append(Vector2(x,y))
#	Octan.append(Vector2(0, radius))
	
#	prints("Все точки одного октана", Octan)
	
	for octPoint in Octan:
		for dir in directions:
			if !AllPoints.has(octPoint * dir):
				AllPoints.append(Vector2(octPoint * dir))
	
#	prints("Все точки              ", AllPoints)
	
	for i in AllPoints.size():
		AllPoints[i] = StartPoint + AllPoints[i]
	
#	var count = 0
#	while true:
#		if InGridCheck(AllPoints[count]):
#			count += 1
#		else:
#			AllPoints.remove(count)
#
#		if AllPoints.size() == count:
#			break
#	prints("Все точки перед выводом", AllPoints)
#	PrintMap(AllPoints)
	return AllPoints
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

func PrintMap(PositionsArr):
	for i in Grid.size():
		var Line = ""
		for j in Grid[0].size():
#			print()
			if PositionsArr.has(Vector2(i,j)):
				Line += (" *")
			else:
				Line += ("  ")
		print(str(Line))
	pass

#Проверяем, доступна ли нам соседняя ячейка по направлению dir ячейка и если да, то увеличиваем её вес на 1
func isCellCheck(pos, direction, gridArr, startZPoint, endZPoint, _Character):
#	Проверка соседней клетки pos по направлению direction
	var gridPos = (pos) + direction
#	Проверка, находится ли точка в рамках сетки
	if gridPos == _Character.target:
		print("Клетка была отсканирована")
	if InGridCheck(pos, direction, startZPoint, endZPoint):
#		Проверка, что точка свободна для передвижения или она является целью персонажа и его предыдущая позиция не является междузоньем
		if  ((gridArr[gridPos.x][gridPos.y].content == GridPoint.EMPTY || gridPos == _Character.target && !gridArr[pos.x][pos.y].interzone) &&
		gridArr[gridPos.x][gridPos.y].step == null):
#			print(str(gridArr[pos.x][pos.y]))
#			Проверка, что при диагональном переходе обе боковые клетки пусты
			if (_Character.CheckDiagonalPosition(pos, direction) || gridPos == _Character.target):
				var step = 0
				print("")
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
#		var DirectionArr = (RectDirections if Grid[newTrace[-1].x][newTrace[-1].y].interzone else RoundDirections)
		for dir in RoundDirections:
#			Если и текущая и прошлая точки находятся в междузонье, то пропусти текущую точку
			if (InGridCheck(newTrace[-1], dir, Vector2.ZERO, GridSize) &&
			Grid[newTrace[-1].x][newTrace[-1].y].interzone &&
			gridArr[newTrace[-1].x + dir.x][newTrace[-1].y + dir.y].interzone):
				continue
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
	if (InGridCheck(pos, dir, Vector2.ZERO, GridSize) &&
			nGrid[pos.x + dir.x][pos.y + dir.y].step != null &&
			nGrid[pos.x + dir.x][pos.y + dir.y].step < nGrid[pos.x][pos.y].step):
		return     Vector2(pos.x + dir.x, pos.y + dir.y)
	else:
		return     Vector2(pos.x, pos.y)
	pass

#Проверяем, что ячейка находится внутри сетки
func InGridCheck(pos, direction = Vector2.ZERO, ZoneStartPosition = GridStart, ZoneEndPosition = GridSize):
	var gridPos = (pos) + direction
#	print("GridSize - "+ str(GridSize))
	if gridPos.x < ZoneEndPosition.x && gridPos.x >= ZoneStartPosition.x:
		if gridPos.y < ZoneEndPosition.y && gridPos.y >= ZoneStartPosition.y:
			return true
	return false
	pass

func InDistanceCheck(startPos, Distance, targetPosition):
	var cell = {stepLevel = 0}
#	var startPos = character.ZonePosition
#	var targetPosition = character.target
#	var Distance = character.AttackDistance
	var ScanningNodes = {startPos : cell}
	var nodesKeys = ScanningNodes.keys()
	print("targetPosition " + str(targetPosition))
	for node in nodesKeys:
		for dir in RoundDirections:
			# Проверка, чтобы значение находилось в рамках зоны
			if InGridCheck(node, dir, Vector2.ZERO, GridSize):
				var gridPos = node + dir
				# Если клетки ещё нет в словаре сканированных клеток
				if !ScanningNodes.has(gridPos):
					# Увеличь уровень шага на 1
					var newStepLevel   = ScanningNodes[node].stepLevel + 1
					# Если клетка входит в доступную зону атаки
					if Distance >= newStepLevel:
						# Проверка, является ли эта точка целью
						if gridPos == targetPosition:
							return true
						else: # иначе просто добавь её в массив сканируемых точек
							ScanningNodes[gridPos] = {stepLevel = newStepLevel}
							nodesKeys.append(gridPos)
#	print("ScanningNodes " + str(ScanningNodes.keys()))
	return false
	pass

func GetCharactersInPointsArray(array):
	var charactersArray = []
	for arrPoint in array:
		# Проверка, является ли эта точка целью
		if Grid[arrPoint.x][arrPoint.y].character:
			charactersArray.append(Grid[arrPoint.x][arrPoint.y].character)
#	print("ScanningNodes " + str(ScanningNodes.keys()))
	return charactersArray
	pass

func BuildPathToTheEmptyZone(_Character, endPos):
	var trace = WaveFindPath(_Character, endPos)
	trace.invert()
	var newTrace = []
	var Cost = {movement = 0, zonePoints = 0}
	for tracePosition in trace:
		if Grid[tracePosition.x][tracePosition.y].CheckMovement(_Character, Cost):
			print("Один есть!")
			newTrace.append(tracePosition)
		else:
			break
#	print("StartTrace - " + str(trace))
#	print("FinalTrace - " + str(newTrace))
#	print("Cost - " + str(Cost))
#	print("GlobalPath - " + str(SetGlobalPath(newTrace)))
	return {path = newTrace, cost = Cost}
	pass

#Строит путь до цели, может просто до неё вплотную, а может до позиции, пока цель не окажется в зоне поражения
#Можно расширить так, что мы определяем какая зона поражения
#Скорее всего мы добавляем в персонажа энумератор действия и даём геттер, чтобы он выдавал параметры действия - урон, дистанция и т.д.
func BuildPathToTheTarget(_Character, endPos, CharAction = null):
	var trace = WaveFindPath(_Character, endPos)
	trace.invert()
	var newTrace = []
	var InDistance = false
	var inDistancePosition = null
#	var CharAction = Action.new()
	var Cost = {movement = 0, zonePoints = 0}
	print()
	for tracePosition in trace:
		if Grid[tracePosition.x][tracePosition.y].CheckMovement(_Character, Cost):
#			print("Cost - " + str(Cost))
			newTrace.append(tracePosition)
#			print("NewCost - " + str(GetCostMovement(_Character, newTrace)))
			if CharAction:
				if (CharAction.ActivationCheck(endPos) && #Если цель на этой точке находится в дистанции поражения
				!Grid[tracePosition.x][tracePosition.y].interzone): # И если это не интерзона
					# Сохраняем позицию, с которой персонаж может достать до цели
					inDistancePosition = tracePosition
					if GetCostMovement(_Character, newTrace).actionPoints + CharAction.ActionCost <= _Character.ActionPoints: # И если у игрока достаточно AP для действия
						print("newTrace - " + str(newTrace))
						InDistance = true
						break
		else:
			break
	var SelectedTarget = null
	print("newTrace - " + str(newTrace))
	if newTrace.size() > 0 && _Character.target == newTrace[-1]:
		SelectedTarget = newTrace[-1]
		newTrace.remove(newTrace.find(newTrace[-1]))
	return {path = newTrace, cost = Cost, target = SelectedTarget, InDistance = InDistance, inDistancePosition = inDistancePosition}
	pass

# Высчитывание стоимости передвижения по пути
func GetCostMovement(character, path):
	var Cost = {movement = 0, actionPoints = 0, zonePoints = 0}
	for point in path:
		if !Grid[point.x][point.y].interzone:
			if character.Movement + character.Speed * Cost.actionPoints > Cost.movement:
				Cost.movement += 1
			else:
				Cost.movement += 1
				Cost.actionPoints += 1
		else:
			Cost.zonePoints += 1
	return Cost
	pass

func SetGlobalPath(mapPath):
	var finalPath = []
	for point in mapPath:
		var pathPoint = gridMap.map_to_world(point.x, 0, point.y)
		finalPath.append(pathPoint)
	return finalPath
	pass

# Функция, которая говорит персонажу двигаться к точке
func GoToClick(character, click_position):
	var startPosition = character.ZonePosition
	var selectedPosition = Vector2(gridMap.world_to_map(click_position).x, gridMap.world_to_map(click_position).z)
	if InGridCheck(selectedPosition, Vector2.ZERO) && startPosition != selectedPosition:
		var trace
		if !Grid[selectedPosition.x][selectedPosition.y].interzone:
			ClearPathZone()
			if Grid[selectedPosition.x][selectedPosition.y].content == GridPoint.CHARACTER:
	#			print("Находится ли цель в зоне")
				character.target = selectedPosition
				trace = BuildPathToTheTarget(character, selectedPosition, character.SelectedAction)
				prints("target", str(trace.target))
			elif Grid[selectedPosition.x][selectedPosition.y].content == GridPoint.EMPTY:
				trace = BuildPathToTheEmptyZone(character, selectedPosition)
			var finalPath = SetGlobalPath(trace.path)
			character.path = finalPath
	pass


