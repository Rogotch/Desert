extends TileMap

export var _player : NodePath
onready var Player = get_node(_player)

var tile_size = get_cell_size()
var half_tile_size = tile_size / 2

enum {EMPTY = -1, PLAYER, OBSTACLE, COLLECTIBLE}

var grid_size = Vector2(16,16)
var grid = []

const RoundDirections = [
	Vector2( 1, 0),
	Vector2( 0, 1),
	Vector2(-1, 0),
	Vector2( 0,-1),
	Vector2( 1, 1),
	Vector2(-1, 1),
	Vector2( 1,-1),
	Vector2(-1,-1),]

onready var Obstacle = preload("res://Resources/Entities/2D/Obstacle.tscn")
#vid - https://youtu.be/Yus8zAculWA?t=172

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(grid_size.x):
		grid.append([])
		for y in grid_size.y:
			grid[x].append(null)
	
	var objPosition = []
	for n in range(5):
		var grid_pos = Vector2(randi() % int(grid_size.x), randi() % int(grid_size.y))
		if not grid_pos in objPosition:
			objPosition.append(grid_pos)
	
	var StartPos = updateChildPos(Player.position, Player.direction, Player.type)
	Player.set_position(StartPos)
	Player.gridPosition = world_to_map(Player.position)
	
	for pos in objPosition:
		var new_obstacle = Obstacle.instance()
		new_obstacle.position = map_to_world(pos)+half_tile_size
		grid[pos.x][pos.y] = OBSTACLE
		add_child(new_obstacle)
	pass # Replace with function body.

func isCellVacant(pos, direction):
	var gridPos = world_to_map(pos) + direction
	
	if gridPos.x < grid_size.x && gridPos.x >= 0:
		if gridPos.y < grid_size.y && gridPos.y >= 0:
			return grid[gridPos.x][gridPos.y] == null
	return false
	pass

func updateChildPos(this_world_pos, direction, type):

	var this_grid_pos = world_to_map(this_world_pos)
	var new_grid_pos = this_grid_pos + direction

	# remove player from current grid location
	grid[this_grid_pos.x][this_grid_pos.y] = EMPTY

	# place player on new grid location
	grid[new_grid_pos.x][new_grid_pos.y] = type

	var new_world_pos = map_to_world(new_grid_pos) + half_tile_size
	return new_world_pos


func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
#			print(str(grid))
			var MouseClck = world_to_map(get_global_mouse_position())
			if ((MouseClck.x >= Player.gridPosition.x - 1   &&
				 MouseClck.x <= Player.gridPosition.x + 1 ) &&
				(MouseClck.y >= Player.gridPosition.y - 1   &&
				 MouseClck.y <= Player.gridPosition.y + 1 ) &&
				grid[MouseClck.x][MouseClck.y] == null):
					Player.Trace.append(map_to_world(MouseClck) + half_tile_size)
			else:
				if grid[MouseClck.x][MouseClck.y] == null:
					var finalPath = WaveFindPath(Player.gridPosition, MouseClck)
#					print(str(finalPath))
					Player.Trace = SetPath(finalPath)
#				print(str(grid[MouseClck.x][MouseClck.y]))
				print("Вне диапазона!")
	pass

#Волнами сканируем поле и ищем короткий путь
func WaveFindPath(startPos, finPos):
	var newGrid = grid.duplicate(true)
	var ScanningNodes = [startPos]
	for node in ScanningNodes:
		if node == finPos:
			return SetTrace(finPos, newGrid)
		else:
			for dir in RoundDirections:
				if isCellCheck(node, dir, newGrid):
					ScanningNodes.append(node + dir)
	print("Путь не был найден")
	return []
	pass

#Проверяем, доступна ли нам соседняя ячейка по направлению dir ячейка и если да, то увеличиваем её вес на 1
func isCellCheck(pos, direction, gridArr):
	var gridPos = (pos) + direction
	if InGridCheck(pos, direction):
		if  gridArr[gridPos.x][gridPos.y] == null:
#			print(str(gridArr[pos.x][pos.y]))
			var step = 0
			if typeof(gridArr[pos.x][pos.y]) != TYPE_INT:
				step = gridArr[pos.x][pos.y].step
			gridArr[gridPos.x][gridPos.y] = {step = step + 1}
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
	return newTrace
	pass

#Проверяем, что следующая, по направлению dir, ячейка весит меньше текущей
#Если да, возвращаем положение этой новой ячейки, иначе возвращаем старое значение
func NextStep(pos, nGrid, dir):
	if (InGridCheck(pos, dir) &&
			 typeof(nGrid[pos.x + dir.x][pos.y + dir.y]) ==  TYPE_DICTIONARY &&
					nGrid[pos.x + dir.x][pos.y + dir.y].step < nGrid[pos.x][pos.y].step):
		return     Vector2(pos.x + dir.x, pos.y + dir.y)
	else:
		return     Vector2(pos.x, pos.y)
	pass

#Проверяем, что ячейка находится внутри сетки
func InGridCheck(pos, direction):
	var gridPos = (pos) + direction
	if gridPos.x < grid_size.x && gridPos.x >= 0:
		if gridPos.y < grid_size.y && gridPos.y >= 0:
			return true
	return false
	pass

#Переворачиваем массив и заполняем его мировыми координатами
func SetPath(trace):
	trace.invert()
	var finalPath = []
	for point in trace:
		finalPath.append(map_to_world(point) + half_tile_size)
	return finalPath
	pass
